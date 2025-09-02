# 测试指南

本文档详细介绍了VGO微服务的测试策略、测试框架、测试实践和测试工具的使用方法。

## 🎯 测试策略

### 测试金字塔

```mermaid
graph TB
    subgraph "测试金字塔"
        A["端到端测试 (E2E)<br/>少量，高价值"] 
        B["集成测试 (Integration)<br/>适量，关键路径"]
        C["单元测试 (Unit)<br/>大量，快速反馈"]
    end
    
    style A fill:#ff6b6b
    style B fill:#ffd93d
    style C fill:#6bcf7f
```

### 测试分层策略

| 测试类型 | 占比 | 执行速度 | 覆盖范围 | 维护成本 |
|----------|------|----------|----------|----------|
| 单元测试 | 70% | 快 | 函数/方法级别 | 低 |
| 集成测试 | 20% | 中等 | 服务间交互 | 中等 |
| 端到端测试 | 10% | 慢 | 完整业务流程 | 高 |

## 🧪 测试框架

### 1. 单元测试框架

#### Go标准测试库 + Testify

```go
package user

import (
    "context"
    "testing"
    "time"
    
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
    "github.com/stretchr/testify/suite"
)

// 测试套件
type UserServiceTestSuite struct {
    suite.Suite
    service    *UserService
    mockRepo   *MockUserRepository
    mockCache  *MockCacheService
    mockLogger *MockLogger
}

// 设置测试环境
func (suite *UserServiceTestSuite) SetupTest() {
    suite.mockRepo = &MockUserRepository{}
    suite.mockCache = &MockCacheService{}
    suite.mockLogger = &MockLogger{}
    
    suite.service = &UserService{
        repo:   suite.mockRepo,
        cache:  suite.mockCache,
        logger: suite.mockLogger,
    }
}

// 清理测试环境
func (suite *UserServiceTestSuite) TearDownTest() {
    suite.mockRepo.AssertExpectations(suite.T())
    suite.mockCache.AssertExpectations(suite.T())
}

// 测试用例：创建用户成功
func (suite *UserServiceTestSuite) TestCreateUser_Success() {
    // Arrange
    ctx := context.Background()
    user := &User{
        Username: "testuser",
        Email:    "test@example.com",
    }
    
    suite.mockRepo.On("Create", ctx, user).Return(nil)
    suite.mockCache.On("Delete", ctx, "users:list").Return(nil)
    
    // Act
    err := suite.service.CreateUser(ctx, user)
    
    // Assert
    assert.NoError(suite.T(), err)
    assert.NotEmpty(suite.T(), user.ID)
    assert.Equal(suite.T(), "active", user.Status)
}

// 测试用例：创建用户失败 - 用户名已存在
func (suite *UserServiceTestSuite) TestCreateUser_UsernameExists() {
    // Arrange
    ctx := context.Background()
    user := &User{
        Username: "existinguser",
        Email:    "test@example.com",
    }
    
    suite.mockRepo.On("Create", ctx, user).Return(ErrUsernameExists)
    
    // Act
    err := suite.service.CreateUser(ctx, user)
    
    // Assert
    assert.Error(suite.T(), err)
    assert.Equal(suite.T(), ErrUsernameExists, err)
}

// 运行测试套件
func TestUserServiceTestSuite(t *testing.T) {
    suite.Run(t, new(UserServiceTestSuite))
}
```

#### Mock生成

使用mockery自动生成Mock对象：

```bash
# 安装mockery
go install github.com/vektra/mockery/v2@latest

# 生成Mock
mockery --name=UserRepository --output=./mocks --outpkg=mocks
mockery --name=CacheService --output=./mocks --outpkg=mocks
```

```go
// 接口定义
type UserRepository interface {
    Create(ctx context.Context, user *User) error
    GetByID(ctx context.Context, id string) (*User, error)
    Update(ctx context.Context, user *User) error
    Delete(ctx context.Context, id string) error
    List(ctx context.Context, opts ListOptions) ([]*User, error)
}

// 自动生成的Mock
type MockUserRepository struct {
    mock.Mock
}

func (m *MockUserRepository) Create(ctx context.Context, user *User) error {
    args := m.Called(ctx, user)
    return args.Error(0)
}

func (m *MockUserRepository) GetByID(ctx context.Context, id string) (*User, error) {
    args := m.Called(ctx, id)
    return args.Get(0).(*User), args.Error(1)
}
```

### 2. 集成测试框架

#### Testcontainers集成测试

```go
package integration

import (
    "context"
    "database/sql"
    "fmt"
    "testing"
    "time"
    
    "github.com/testcontainers/testcontainers-go"
    "github.com/testcontainers/testcontainers-go/modules/postgres"
    "github.com/testcontainers/testcontainers-go/modules/redis"
    "github.com/stretchr/testify/suite"
)

type IntegrationTestSuite struct {
    suite.Suite
    pgContainer    *postgres.PostgresContainer
    redisContainer *redis.RedisContainer
    db             *sql.DB
    redisClient    *redis.Client
    userService    *UserService
}

func (suite *IntegrationTestSuite) SetupSuite() {
    ctx := context.Background()
    
    // 启动PostgreSQL容器
    pgContainer, err := postgres.RunContainer(ctx,
        testcontainers.WithImage("postgres:17-alpine"),
        postgres.WithDatabase("testdb"),
        postgres.WithUsername("testuser"),
        postgres.WithPassword("testpass"),
        testcontainers.WithWaitStrategy(
            wait.ForLog("database system is ready to accept connections").WithOccurrence(2).WithStartupTimeout(5*time.Second),
        ),
    )
    suite.Require().NoError(err)
    suite.pgContainer = pgContainer
    
    // 启动Redis容器
    redisContainer, err := redis.RunContainer(ctx,
        testcontainers.WithImage("redis:7-alpine"),
    )
    suite.Require().NoError(err)
    suite.redisContainer = redisContainer
    
    // 连接数据库
    connStr, err := pgContainer.ConnectionString(ctx, "sslmode=disable")
    suite.Require().NoError(err)
    
    suite.db, err = sql.Open("postgres", connStr)
    suite.Require().NoError(err)
    
    // 连接Redis
    redisEndpoint, err := redisContainer.Endpoint(ctx, "")
    suite.Require().NoError(err)
    
    suite.redisClient = redis.NewClient(&redis.Options{
        Addr: redisEndpoint,
    })
    
    // 初始化服务
    suite.setupServices()
    
    // 运行数据库迁移
    suite.runMigrations()
}

func (suite *IntegrationTestSuite) TearDownSuite() {
    ctx := context.Background()
    
    if suite.db != nil {
        suite.db.Close()
    }
    
    if suite.redisClient != nil {
        suite.redisClient.Close()
    }
    
    if suite.pgContainer != nil {
        suite.pgContainer.Terminate(ctx)
    }
    
    if suite.redisContainer != nil {
        suite.redisContainer.Terminate(ctx)
    }
}

func (suite *IntegrationTestSuite) TestUserCRUD() {
    ctx := context.Background()
    
    // 创建用户
    user := &User{
        Username: "testuser",
        Email:    "test@example.com",
    }
    
    err := suite.userService.CreateUser(ctx, user)
    suite.Require().NoError(err)
    suite.Assert().NotEmpty(user.ID)
    
    // 获取用户
    retrievedUser, err := suite.userService.GetUser(ctx, user.ID)
    suite.Require().NoError(err)
    suite.Assert().Equal(user.Username, retrievedUser.Username)
    suite.Assert().Equal(user.Email, retrievedUser.Email)
    
    // 更新用户
    user.Email = "updated@example.com"
    err = suite.userService.UpdateUser(ctx, user)
    suite.Require().NoError(err)
    
    // 验证更新
    updatedUser, err := suite.userService.GetUser(ctx, user.ID)
    suite.Require().NoError(err)
    suite.Assert().Equal("updated@example.com", updatedUser.Email)
    
    // 删除用户
    err = suite.userService.DeleteUser(ctx, user.ID)
    suite.Require().NoError(err)
    
    // 验证删除
    _, err = suite.userService.GetUser(ctx, user.ID)
    suite.Assert().Error(err)
}

func TestIntegrationTestSuite(t *testing.T) {
    suite.Run(t, new(IntegrationTestSuite))
}
```

### 3. 端到端测试框架

#### API测试

```go
package e2e

import (
    "bytes"
    "encoding/json"
    "fmt"
    "net/http"
    "testing"
    "time"
    
    "github.com/stretchr/testify/suite"
)

type E2ETestSuite struct {
    suite.Suite
    baseURL    string
    httpClient *http.Client
    authToken  string
}

func (suite *E2ETestSuite) SetupSuite() {
    suite.baseURL = "http://localhost:8080"
    suite.httpClient = &http.Client{
        Timeout: 30 * time.Second,
    }
    
    // 等待服务启动
    suite.waitForService()
    
    // 获取认证令牌
    suite.authenticate()
}

func (suite *E2ETestSuite) waitForService() {
    for i := 0; i < 30; i++ {
        resp, err := suite.httpClient.Get(suite.baseURL + "/health")
        if err == nil && resp.StatusCode == http.StatusOK {
            resp.Body.Close()
            return
        }
        if resp != nil {
            resp.Body.Close()
        }
        time.Sleep(time.Second)
    }
    suite.FailNow("Service did not start within 30 seconds")
}

func (suite *E2ETestSuite) authenticate() {
    loginReq := map[string]string{
        "username": "admin",
        "password": "admin123",
    }
    
    body, _ := json.Marshal(loginReq)
    resp, err := suite.httpClient.Post(
        suite.baseURL+"/api/v1/auth/login",
        "application/json",
        bytes.NewBuffer(body),
    )
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Require().Equal(http.StatusOK, resp.StatusCode)
    
    var loginResp struct {
        Token string `json:"token"`
    }
    
    err = json.NewDecoder(resp.Body).Decode(&loginResp)
    suite.Require().NoError(err)
    
    suite.authToken = loginResp.Token
}

func (suite *E2ETestSuite) makeAuthenticatedRequest(method, path string, body interface{}) (*http.Response, error) {
    var reqBody *bytes.Buffer
    if body != nil {
        jsonBody, _ := json.Marshal(body)
        reqBody = bytes.NewBuffer(jsonBody)
    }
    
    req, err := http.NewRequest(method, suite.baseURL+path, reqBody)
    if err != nil {
        return nil, err
    }
    
    req.Header.Set("Authorization", "Bearer "+suite.authToken)
    req.Header.Set("Content-Type", "application/json")
    
    return suite.httpClient.Do(req)
}

func (suite *E2ETestSuite) TestUserManagementWorkflow() {
    // 1. 创建用户
    createUserReq := map[string]interface{}{
        "username": "testuser",
        "email":    "test@example.com",
        "password": "password123",
    }
    
    resp, err := suite.makeAuthenticatedRequest("POST", "/api/v1/users", createUserReq)
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Assert().Equal(http.StatusCreated, resp.StatusCode)
    
    var createResp struct {
        User struct {
            ID       string `json:"id"`
            Username string `json:"username"`
            Email    string `json:"email"`
        } `json:"user"`
    }
    
    err = json.NewDecoder(resp.Body).Decode(&createResp)
    suite.Require().NoError(err)
    
    userID := createResp.User.ID
    suite.Assert().NotEmpty(userID)
    
    // 2. 获取用户
    resp, err = suite.makeAuthenticatedRequest("GET", "/api/v1/users/"+userID, nil)
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Assert().Equal(http.StatusOK, resp.StatusCode)
    
    // 3. 更新用户
    updateUserReq := map[string]interface{}{
        "email": "updated@example.com",
    }
    
    resp, err = suite.makeAuthenticatedRequest("PUT", "/api/v1/users/"+userID, updateUserReq)
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Assert().Equal(http.StatusOK, resp.StatusCode)
    
    // 4. 删除用户
    resp, err = suite.makeAuthenticatedRequest("DELETE", "/api/v1/users/"+userID, nil)
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Assert().Equal(http.StatusNoContent, resp.StatusCode)
    
    // 5. 验证用户已删除
    resp, err = suite.makeAuthenticatedRequest("GET", "/api/v1/users/"+userID, nil)
    suite.Require().NoError(err)
    defer resp.Body.Close()
    
    suite.Assert().Equal(http.StatusNotFound, resp.StatusCode)
}

func TestE2ETestSuite(t *testing.T) {
    suite.Run(t, new(E2ETestSuite))
}
```

## 🔧 测试工具

### 1. 测试数据管理

#### 测试数据工厂

```go
package testdata

import (
    "time"
    "github.com/google/uuid"
)

// 用户测试数据工厂
type UserFactory struct {
    defaults *User
}

func NewUserFactory() *UserFactory {
    return &UserFactory{
        defaults: &User{
            ID:        uuid.New().String(),
            Username:  "testuser",
            Email:     "test@example.com",
            Status:    "active",
            CreatedAt: time.Now(),
            UpdatedAt: time.Now(),
        },
    }
}

func (f *UserFactory) Build() *User {
    user := *f.defaults
    user.ID = uuid.New().String()
    return &user
}

func (f *UserFactory) WithUsername(username string) *UserFactory {
    f.defaults.Username = username
    return f
}

func (f *UserFactory) WithEmail(email string) *UserFactory {
    f.defaults.Email = email
    return f
}

func (f *UserFactory) WithStatus(status string) *UserFactory {
    f.defaults.Status = status
    return f
}

// 使用示例
func TestUserCreation(t *testing.T) {
    // 创建默认用户
    user1 := NewUserFactory().Build()
    
    // 创建自定义用户
    user2 := NewUserFactory().
        WithUsername("customuser").
        WithEmail("custom@example.com").
        WithStatus("inactive").
        Build()
    
    // 测试逻辑...
}
```

#### 测试数据清理

```go
package testutil

import (
    "context"
    "database/sql"
    "fmt"
)

type DatabaseCleaner struct {
    db *sql.DB
}

func NewDatabaseCleaner(db *sql.DB) *DatabaseCleaner {
    return &DatabaseCleaner{db: db}
}

// 清理所有测试数据
func (c *DatabaseCleaner) CleanAll(ctx context.Context) error {
    tables := []string{
        "user_roles",
        "policy_attachments",
        "access_key_usage",
        "access_keys",
        "policies",
        "users",
        "roles",
        "applications",
    }
    
    tx, err := c.db.BeginTx(ctx, nil)
    if err != nil {
        return err
    }
    defer tx.Rollback()
    
    // 禁用外键约束
    _, err = tx.ExecContext(ctx, "SET FOREIGN_KEY_CHECKS = 0")
    if err != nil {
        return err
    }
    
    // 清理表数据
    for _, table := range tables {
        _, err = tx.ExecContext(ctx, fmt.Sprintf("DELETE FROM %s", table))
        if err != nil {
            return err
        }
    }
    
    // 重新启用外键约束
    _, err = tx.ExecContext(ctx, "SET FOREIGN_KEY_CHECKS = 1")
    if err != nil {
        return err
    }
    
    return tx.Commit()
}

// 清理特定表
func (c *DatabaseCleaner) CleanTable(ctx context.Context, table string) error {
    _, err := c.db.ExecContext(ctx, fmt.Sprintf("DELETE FROM %s", table))
    return err
}
```

### 2. 性能测试

#### 基准测试

```go
package benchmark

import (
    "context"
    "testing"
    "time"
)

// 用户服务性能测试
func BenchmarkUserService_CreateUser(b *testing.B) {
    service := setupUserService()
    ctx := context.Background()
    
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            user := NewUserFactory().Build()
            err := service.CreateUser(ctx, user)
            if err != nil {
                b.Fatal(err)
            }
        }
    })
}

func BenchmarkUserService_GetUser(b *testing.B) {
    service := setupUserService()
    ctx := context.Background()
    
    // 预创建用户
    user := NewUserFactory().Build()
    err := service.CreateUser(ctx, user)
    if err != nil {
        b.Fatal(err)
    }
    
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            _, err := service.GetUser(ctx, user.ID)
            if err != nil {
                b.Fatal(err)
            }
        }
    })
}

// 权限检查性能测试
func BenchmarkPermissionService_CheckPermission(b *testing.B) {
    service := setupPermissionService()
    ctx := context.Background()
    
    req := &CheckPermissionRequest{
        UserId:   "user123",
        Resource: "users",
        Action:   "read",
    }
    
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            _, err := service.CheckPermission(ctx, req)
            if err != nil {
                b.Fatal(err)
            }
        }
    })
}

// 内存分配测试
func BenchmarkUserService_CreateUser_Memory(b *testing.B) {
    service := setupUserService()
    ctx := context.Background()
    
    b.ReportAllocs()
    b.ResetTimer()
    
    for i := 0; i < b.N; i++ {
        user := NewUserFactory().Build()
        err := service.CreateUser(ctx, user)
        if err != nil {
            b.Fatal(err)
        }
    }
}
```

#### 压力测试

```go
package stress

import (
    "context"
    "sync"
    "testing"
    "time"
)

// 并发用户创建压力测试
func TestConcurrentUserCreation(t *testing.T) {
    service := setupUserService()
    ctx := context.Background()
    
    concurrency := 100
    iterations := 1000
    
    var wg sync.WaitGroup
    errors := make(chan error, concurrency*iterations)
    
    start := time.Now()
    
    for i := 0; i < concurrency; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            
            for j := 0; j < iterations; j++ {
                user := NewUserFactory().Build()
                if err := service.CreateUser(ctx, user); err != nil {
                    errors <- err
                    return
                }
            }
        }()
    }
    
    wg.Wait()
    close(errors)
    
    duration := time.Since(start)
    totalOps := concurrency * iterations
    
    // 检查错误
    errorCount := 0
    for err := range errors {
        t.Logf("Error: %v", err)
        errorCount++
    }
    
    if errorCount > 0 {
        t.Fatalf("Failed operations: %d/%d", errorCount, totalOps)
    }
    
    // 性能指标
    opsPerSecond := float64(totalOps) / duration.Seconds()
    t.Logf("Operations: %d", totalOps)
    t.Logf("Duration: %v", duration)
    t.Logf("Ops/sec: %.2f", opsPerSecond)
    
    // 性能断言
    if opsPerSecond < 1000 {
        t.Errorf("Performance below threshold: %.2f ops/sec < 1000 ops/sec", opsPerSecond)
    }
}
```

### 3. 测试覆盖率

#### 覆盖率配置

```makefile
# Makefile
.PHONY: test test-unit test-integration test-e2e test-coverage

# 单元测试
test-unit:
	go test -v -race -short ./...

# 集成测试
test-integration:
	go test -v -race -tags=integration ./...

# 端到端测试
test-e2e:
	go test -v -race -tags=e2e ./...

# 所有测试
test: test-unit test-integration test-e2e

# 测试覆盖率
test-coverage:
	go test -v -race -coverprofile=coverage.out -covermode=atomic ./...
	go tool cover -html=coverage.out -o coverage.html
	go tool cover -func=coverage.out

# 覆盖率报告
coverage-report:
	go tool cover -html=coverage.out

# 基准测试
benchmark:
	go test -bench=. -benchmem -cpuprofile=cpu.prof -memprofile=mem.prof ./...

# 压力测试
stress-test:
	go test -v -race -tags=stress ./...
```

#### 覆盖率分析

```bash
#!/bin/bash
# scripts/coverage.sh

set -e

# 运行测试并生成覆盖率报告
echo "Running tests with coverage..."
go test -v -race -coverprofile=coverage.out -covermode=atomic ./...

# 生成HTML报告
echo "Generating HTML coverage report..."
go tool cover -html=coverage.out -o coverage.html

# 显示覆盖率统计
echo "Coverage statistics:"
go tool cover -func=coverage.out

# 检查覆盖率阈值
COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
THRESHOLD=80

echo "Total coverage: ${COVERAGE}%"

if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
    echo "❌ Coverage ${COVERAGE}% is below threshold ${THRESHOLD}%"
    exit 1
else
    echo "✅ Coverage ${COVERAGE}% meets threshold ${THRESHOLD}%"
fi

# 生成覆盖率徽章
echo "Generating coverage badge..."
curl -s "https://img.shields.io/badge/coverage-${COVERAGE}%25-brightgreen" > coverage-badge.svg

echo "Coverage report generated: coverage.html"
```

## 🚀 测试自动化

### 1. CI/CD集成

#### GitHub Actions配置

```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:17
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Cache Go modules
      uses: actions/cache@v3
      with:
        path: ~/go/pkg/mod
        key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
        restore-keys: |
          ${{ runner.os }}-go-
    
    - name: Install dependencies
      run: go mod download
    
    - name: Run unit tests
      run: make test-unit
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/testdb?sslmode=disable
        REDIS_URL: redis://localhost:6379
    
    - name: Run integration tests
      run: make test-integration
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/testdb?sslmode=disable
        REDIS_URL: redis://localhost:6379
    
    - name: Generate coverage report
      run: make test-coverage
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/testdb?sslmode=disable
        REDIS_URL: redis://localhost:6379
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.out
        flags: unittests
        name: codecov-umbrella

  e2e-tests:
    runs-on: ubuntu-latest
    needs: unit-tests
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Build application
      run: make build
    
    - name: Start services
      run: |
        docker-compose -f docker-compose.test.yml up -d
        sleep 30
    
    - name: Run E2E tests
      run: make test-e2e
    
    - name: Stop services
      run: docker-compose -f docker-compose.test.yml down
      if: always()
```

### 2. 测试数据管理

#### 测试数据库迁移

```go
package testutil

import (
    "database/sql"
    "fmt"
    "io/ioutil"
    "path/filepath"
    "sort"
    "strings"
)

type TestMigrator struct {
    db          *sql.DB
    migrationsDir string
}

func NewTestMigrator(db *sql.DB, migrationsDir string) *TestMigrator {
    return &TestMigrator{
        db:          db,
        migrationsDir: migrationsDir,
    }
}

func (m *TestMigrator) Up() error {
    files, err := ioutil.ReadDir(m.migrationsDir)
    if err != nil {
        return err
    }
    
    var migrations []string
    for _, file := range files {
        if strings.HasSuffix(file.Name(), ".up.sql") {
            migrations = append(migrations, file.Name())
        }
    }
    
    sort.Strings(migrations)
    
    for _, migration := range migrations {
        content, err := ioutil.ReadFile(filepath.Join(m.migrationsDir, migration))
        if err != nil {
            return err
        }
        
        _, err = m.db.Exec(string(content))
        if err != nil {
            return fmt.Errorf("failed to execute migration %s: %w", migration, err)
        }
    }
    
    return nil
}

func (m *TestMigrator) Down() error {
    files, err := ioutil.ReadDir(m.migrationsDir)
    if err != nil {
        return err
    }
    
    var migrations []string
    for _, file := range files {
        if strings.HasSuffix(file.Name(), ".down.sql") {
            migrations = append(migrations, file.Name())
        }
    }
    
    // 逆序执行
    sort.Sort(sort.Reverse(sort.StringSlice(migrations)))
    
    for _, migration := range migrations {
        content, err := ioutil.ReadFile(filepath.Join(m.migrationsDir, migration))
        if err != nil {
            return err
        }
        
        _, err = m.db.Exec(string(content))
        if err != nil {
            return fmt.Errorf("failed to execute migration %s: %w", migration, err)
        }
    }
    
    return nil
}
```

## 📊 测试最佳实践

### 1. 测试命名规范

```go
// 好的测试命名
func TestUserService_CreateUser_Success(t *testing.T) {}
func TestUserService_CreateUser_UsernameExists_ReturnsError(t *testing.T) {}
func TestUserService_GetUser_NotFound_ReturnsError(t *testing.T) {}

// 不好的测试命名
func TestCreateUser(t *testing.T) {}
func TestUser(t *testing.T) {}
func TestError(t *testing.T) {}
```

### 2. 测试结构模式

```go
// AAA模式：Arrange, Act, Assert
func TestUserService_CreateUser_Success(t *testing.T) {
    // Arrange - 准备测试数据和环境
    ctx := context.Background()
    mockRepo := &MockUserRepository{}
    service := &UserService{repo: mockRepo}
    
    user := &User{
        Username: "testuser",
        Email:    "test@example.com",
    }
    
    mockRepo.On("Create", ctx, user).Return(nil)
    
    // Act - 执行被测试的操作
    err := service.CreateUser(ctx, user)
    
    // Assert - 验证结果
    assert.NoError(t, err)
    assert.NotEmpty(t, user.ID)
    mockRepo.AssertExpectations(t)
}
```

### 3. 测试隔离

```go
// 每个测试都应该是独立的
func TestUserService_CRUD(t *testing.T) {
    tests := []struct {
        name string
        test func(t *testing.T, service *UserService)
    }{
        {
            name: "CreateUser_Success",
            test: func(t *testing.T, service *UserService) {
                // 测试逻辑
            },
        },
        {
            name: "GetUser_Success",
            test: func(t *testing.T, service *UserService) {
                // 测试逻辑
            },
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // 为每个测试创建独立的服务实例
            service := setupUserService()
            defer cleanupUserService(service)
            
            tt.test(t, service)
        })
    }
}
```

### 4. 错误测试

```go
// 测试错误场景
func TestUserService_CreateUser_ErrorCases(t *testing.T) {
    tests := []struct {
        name          string
        user          *User
        mockSetup     func(*MockUserRepository)
        expectedError error
    }{
        {
            name: "EmptyUsername",
            user: &User{Email: "test@example.com"},
            mockSetup: func(mock *MockUserRepository) {
                // 不设置任何期望，因为验证应该在调用repo之前失败
            },
            expectedError: ErrEmptyUsername,
        },
        {
            name: "InvalidEmail",
            user: &User{Username: "test", Email: "invalid-email"},
            mockSetup: func(mock *MockUserRepository) {},
            expectedError: ErrInvalidEmail,
        },
        {
            name: "DatabaseError",
            user: &User{Username: "test", Email: "test@example.com"},
            mockSetup: func(mock *MockUserRepository) {
                mock.On("Create", mock.Anything, mock.Anything).Return(errors.New("database error"))
            },
            expectedError: errors.New("database error"),
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            mockRepo := &MockUserRepository{}
            tt.mockSetup(mockRepo)
            
            service := &UserService{repo: mockRepo}
            
            err := service.CreateUser(context.Background(), tt.user)
            
            assert.Error(t, err)
            assert.Equal(t, tt.expectedError.Error(), err.Error())
        })
    }
}
```

## 📚 相关文档

- [开发指南](./README.md)
- [架构设计](./architecture.md)
- [调试指南](./debugging.md)
- [性能优化](./performance.md)
- [API文档](../api/README.md)
- [部署指南](../deployment/README.md)