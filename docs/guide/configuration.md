# 配置详解

本文档详细介绍VGO微服务的配置选项，帮助您根据实际需求进行个性化配置。

## 📁 配置文件结构

VGO使用YAML格式的配置文件，默认位置为 `config/config.yaml`。配置文件包含以下主要部分：

```yaml
# 服务基本配置
server:
  grpc_port: "50051"
  http_port: "8080"
  debug_mode: false

# 数据库配置
database:
  dsn: "postgres://user:password@localhost:5432/dbname?sslmode=disable"
  max_open_conns: 25
  max_idle_conns: 5
  conn_max_lifetime: "1h"

# 缓存配置
redis:
  addr: "localhost:6379"
  password: ""
  db: 0
  pool_size: 10

# 安全配置
security:
  master_key: "your-master-key-here"
  jwt_secret: "your-jwt-secret-here"
  access_key_rotation_interval: "24h"

# 日志配置
log:
  level: "info"
  format: "json"
  output: "stdout"
  file_path: "./logs/iam.log"

# 监控配置
metrics:
  enabled: true
  port: "9090"
  path: "/metrics"

# 链路追踪配置
tracing:
  enabled: true
  jaeger_endpoint: "http://localhost:14268/api/traces"
  service_name: "vgo-iam"

# 错误监控配置
sentry:
  dsn: "https://your-sentry-dsn@sentry.io/project-id"
  environment: "production"
  debug: false
```

## 🖥️ 服务配置

### 基本服务设置

```yaml
server:
  # gRPC服务端口
  grpc_port: "50051"
  
  # HTTP调试界面端口
  http_port: "8080"
  
  # 调试模式（开发环境建议开启）
  debug_mode: false
  
  # 服务绑定地址
  bind_addr: "0.0.0.0"
  
  # 优雅关闭超时时间
  shutdown_timeout: "30s"
  
  # 读取超时时间
  read_timeout: "10s"
  
  # 写入超时时间
  write_timeout: "10s"
  
  # 空闲超时时间
  idle_timeout: "60s"
```

### gRPC配置

```yaml
grpc:
  # 最大接收消息大小（字节）
  max_recv_msg_size: 4194304  # 4MB
  
  # 最大发送消息大小（字节）
  max_send_msg_size: 4194304  # 4MB
  
  # 连接超时时间
  connection_timeout: "5s"
  
  # 保持连接设置
  keepalive:
    time: "30s"
    timeout: "5s"
    permit_without_stream: true
```

## 🗄️ 数据库配置

### PostgreSQL配置

```yaml
database:
  # 数据库连接字符串
  dsn: "postgres://username:password@hostname:port/database?sslmode=disable"
  
  # 最大打开连接数
  max_open_conns: 25
  
  # 最大空闲连接数
  max_idle_conns: 5
  
  # 连接最大生存时间
  conn_max_lifetime: "1h"
  
  # 连接最大空闲时间
  conn_max_idle_time: "30m"
  
  # 数据库迁移设置
  migration:
    enabled: true
    path: "./migrations"
    
  # 慢查询日志阈值
  slow_query_threshold: "1s"
```

### 连接池优化

根据不同环境调整连接池参数：

```yaml
# 开发环境
database:
  max_open_conns: 10
  max_idle_conns: 2
  conn_max_lifetime: "30m"

# 测试环境
database:
  max_open_conns: 20
  max_idle_conns: 5
  conn_max_lifetime: "1h"

# 生产环境
database:
  max_open_conns: 50
  max_idle_conns: 10
  conn_max_lifetime: "2h"
```

## 🚀 缓存配置

### Redis配置

```yaml
redis:
  # Redis服务器地址
  addr: "localhost:6379"
  
  # 认证密码
  password: ""
  
  # 数据库编号
  db: 0
  
  # 连接池大小
  pool_size: 10
  
  # 最小空闲连接数
  min_idle_conns: 5
  
  # 连接超时时间
  dial_timeout: "5s"
  
  # 读取超时时间
  read_timeout: "3s"
  
  # 写入超时时间
  write_timeout: "3s"
  
  # 连接池超时时间
  pool_timeout: "4s"
  
  # 空闲连接检查频率
  idle_check_frequency: "60s"
  
  # 最大连接年龄
  max_conn_age: "30m"
  
  # 空闲超时时间
  idle_timeout: "5m"
```

### 缓存策略

```yaml
cache:
  # 用户信息缓存时间
  user_cache_ttl: "15m"
  
  # 策略缓存时间
  policy_cache_ttl: "30m"
  
  # 访问密钥缓存时间
  access_key_cache_ttl: "10m"
  
  # 权限检查缓存时间
  permission_cache_ttl: "5m"
```

## 🔒 安全配置

### 密钥管理

```yaml
security:
  # 主密钥（用于加密访问密钥）
  master_key: "your-32-character-master-key-here"
  
  # JWT密钥
  jwt_secret: "your-jwt-secret-key-here"
  
  # 访问密钥轮换间隔
  access_key_rotation_interval: "24h"
  
  # 密码哈希成本（bcrypt）
  password_hash_cost: 12
  
  # JWT过期时间
  jwt_expiration: "24h"
  
  # 刷新令牌过期时间
  refresh_token_expiration: "168h"  # 7天
```

### TLS配置

```yaml
tls:
  # 启用TLS
  enabled: true
  
  # 证书文件路径
  cert_file: "/path/to/cert.pem"
  
  # 私钥文件路径
  key_file: "/path/to/key.pem"
  
  # CA证书文件路径
  ca_file: "/path/to/ca.pem"
  
  # 客户端认证模式
  client_auth: "require_and_verify"
```

### 速率限制

```yaml
rate_limit:
  # 启用速率限制
  enabled: true
  
  # 每秒请求数限制
  requests_per_second: 100
  
  # 突发请求数
  burst: 200
  
  # 限制窗口大小
  window: "1m"
```

## 📊 日志配置

### 基本日志设置

```yaml
log:
  # 日志级别：debug, info, warn, error
  level: "info"
  
  # 日志格式：json, text
  format: "json"
  
  # 输出目标：stdout, stderr, file
  output: "stdout"
  
  # 日志文件路径（当output为file时）
  file_path: "./logs/iam.log"
  
  # 日志文件最大大小（MB）
  max_size: 100
  
  # 保留的日志文件数量
  max_backups: 10
  
  # 日志文件保留天数
  max_age: 30
  
  # 是否压缩旧日志文件
  compress: true
```

### 结构化日志字段

```yaml
log:
  # 自定义字段
  fields:
    service: "vgo-iam"
    version: "1.2.0"
    environment: "production"
    
  # 敏感字段过滤
  sensitive_fields:
    - "password"
    - "secret"
    - "token"
    - "key"
```

## 📈 监控配置

### Prometheus指标

```yaml
metrics:
  # 启用指标收集
  enabled: true
  
  # 指标服务端口
  port: "9090"
  
  # 指标路径
  path: "/metrics"
  
  # 指标收集间隔
  interval: "15s"
  
  # 自定义标签
  labels:
    service: "vgo-iam"
    version: "1.2.0"
```

### 健康检查

```yaml
health:
  # 健康检查端点
  endpoint: "/health"
  
  # 检查间隔
  interval: "30s"
  
  # 超时时间
  timeout: "5s"
  
  # 检查项目
  checks:
    - "database"
    - "redis"
    - "external_api"
```

## 🔍 链路追踪配置

### Jaeger配置

```yaml
tracing:
  # 启用链路追踪
  enabled: true
  
  # Jaeger端点
  jaeger_endpoint: "http://localhost:14268/api/traces"
  
  # 服务名称
  service_name: "vgo-iam"
  
  # 采样率（0.0-1.0）
  sampling_rate: 0.1
  
  # 标签
  tags:
    version: "1.2.0"
    environment: "production"
```

## 🚨 错误监控配置

### Sentry配置

```yaml
sentry:
  # Sentry DSN
  dsn: "https://your-sentry-dsn@sentry.io/project-id"
  
  # 环境标识
  environment: "production"
  
  # 调试模式
  debug: false
  
  # 采样率
  sample_rate: 1.0
  
  # 发布版本
  release: "vgo-iam@1.2.0"
  
  # 忽略的错误
  ignore_errors:
    - "context canceled"
    - "connection reset by peer"
```

## 🌍 环境变量

您可以使用环境变量覆盖配置文件中的设置：

```bash
# 数据库配置
export VGO_DATABASE_DSN="postgres://user:pass@localhost/db"
export VGO_DATABASE_MAX_OPEN_CONNS=50

# 服务配置
export VGO_SERVER_GRPC_PORT=50051
export VGO_SERVER_HTTP_PORT=8080
export VGO_SERVER_DEBUG_MODE=true

# 安全配置
export VGO_SECURITY_MASTER_KEY="your-master-key"
export VGO_SECURITY_JWT_SECRET="your-jwt-secret"

# Redis配置
export VGO_REDIS_ADDR="localhost:6379"
export VGO_REDIS_PASSWORD="redis-password"

# 日志配置
export VGO_LOG_LEVEL=debug
export VGO_LOG_FORMAT=json
```

## 📋 配置验证

### 验证配置文件

```bash
# 验证配置文件语法
iam-service config validate --config config/config.yaml

# 显示当前配置
iam-service config show --config config/config.yaml

# 测试数据库连接
iam-service config test-db --config config/config.yaml

# 测试Redis连接
iam-service config test-redis --config config/config.yaml
```

### 配置模板

```bash
# 生成配置模板
iam-service config template > config/config.yaml

# 生成开发环境配置
iam-service config template --env dev > config/config-dev.yaml

# 生成生产环境配置
iam-service config template --env prod > config/config-prod.yaml
```

## 🔧 最佳实践

### 1. 安全配置

- 使用强密码和随机密钥
- 定期轮换密钥
- 启用TLS加密
- 配置适当的速率限制

### 2. 性能优化

- 根据负载调整连接池大小
- 合理设置缓存TTL
- 启用gRPC连接复用
- 优化数据库查询

### 3. 监控配置

- 启用所有监控组件
- 设置合适的采样率
- 配置告警规则
- 定期检查日志

### 4. 环境隔离

```bash
# 开发环境
cp config/config-dev.yaml config/config.yaml

# 测试环境
cp config/config-test.yaml config/config.yaml

# 生产环境
cp config/config-prod.yaml config/config.yaml
```

## 📚 相关文档

- [安装指南](./installation.md)
- [基本使用](./basic-usage.md)
- [API文档](/api/)
- [部署指南](/deployment/)

::: tip 提示
配置文件支持热重载，修改配置后发送SIGHUP信号即可重新加载配置。
:::

::: warning 注意
在生产环境中，请确保配置文件的权限设置正确，避免敏感信息泄露。
:::