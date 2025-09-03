# VGO微服务架构部署指南

本项目包含VGO微服务架构的完整部署配置，支持Docker Compose和Kubernetes两种部署方式。

## 🚀 快速开始

### Git Submodule管理

本项目使用Git Submodule管理各个微服务组件，每个服务都是独立的Git仓库：

```bash
# 克隆主仓库并初始化所有submodule
git clone --recursive <main-repo-url>

# 或者先克隆主仓库，再初始化submodule
git clone <main-repo-url>
cd vgo_micro_service
task init  # 或者 ./scripts/submodule-init.sh
```

### Task 命令管理

本项目使用 [Taskfile](https://taskfile.dev/) 替代传统的 Makefile 来管理任务。Task 提供了更好的跨平台支持和更清晰的任务定义。

#### 安装 Task

```bash
# macOS
brew install go-task/tap/go-task

# 或使用 Go 安装
go install github.com/go-task/task/v3/cmd/task@latest
```

#### 常用命令

```bash
# 查看所有可用任务
task --list

# 显示详细帮助
task help

# 初始化开发环境
task dev

# 更新所有submodule到最新版本
task update

# 构建所有服务
task build

# 运行测试
task test

# 启动Docker Compose服务
task docker:up
```

### Submodule管理脚本

- `scripts/submodule-init.sh` - 初始化所有submodule
- `scripts/submodule-update.sh` - 更新submodule到最新版本
- `scripts/submodule-sync.sh` - 同步所有submodule更改

## 项目结构

```
vgo_micro_service/
├── .gitmodules                # Git Submodule配置
├── .gitignore                 # Git忽略文件
├── Taskfile.yml               # Task任务定义文件（替代Makefile）
├── go.work                    # Go Workspace配置
├── docker-compose.yml         # Docker Compose配置
├── .env.example              # 环境变量配置示例
├── README.md                 # 项目说明文档
├── scripts/                  # 脚本目录
│   ├── build.sh              # 构建脚本(自动注入版本信息)
│   ├── deploy.sh             # 主部署脚本
│   ├── setup-env.sh          # 环境配置脚本
│   ├── submodule-init.sh     # Submodule初始化脚本
│   ├── submodule-update.sh   # Submodule更新脚本
│   └── submodule-sync.sh     # Submodule同步脚本
├── vgo-kit/                  # [Submodule] 通用工具库
├── vgo-iam/                  # [Submodule] 身份认证服务
├── vgo-gateway/              # [Submodule] API网关服务
├── k8s/                      # Kubernetes配置
│   ├── namespace.yaml        # 命名空间
│   ├── postgres.yaml         # PostgreSQL
│   ├── redis.yaml            # Redis
│   ├── vgo-iam.yaml          # VGO-IAM服务
│   ├── vgo-notify.yaml       # VGO-NOTIFY服务
│   ├── ingress.yaml          # Ingress配置
│   └── monitoring/           # 监控组件
│       ├── prometheus.yaml   # Prometheus
│       ├── grafana.yaml      # Grafana
│       ├── jaeger.yaml       # Jaeger
│       └── node-exporter.yaml # Node Exporter
├── helm/                     # Helm Charts
│   └── vgo-microservices/    # VGO微服务Helm Chart
├── monitoring/               # 监控配置
│   ├── prometheus/           # Prometheus配置
│   └── grafana/              # Grafana配置
├── nginx/                    # Nginx配置
│   └── nginx.conf
└── data/                     # 运行时数据目录
    ├── postgres/             # PostgreSQL数据
    ├── redis/                # Redis数据
    ├── grafana/              # Grafana数据
    └── prometheus/           # Prometheus数据
```

## 服务架构

### 微服务组件
- **VGO-IAM**: 身份认证和访问管理服务
- **VGO-NOTIFY**: 通知服务（邮件、短信、Webhook）
- **VGO-KIT**: 通用工具库

### 基础设施组件
- **PostgreSQL**: 主数据库
- **Redis**: 缓存和会话存储
- **Nginx**: 反向代理和负载均衡

### 监控组件
- **Prometheus**: 指标收集和存储
- **Grafana**: 监控仪表板
- **Jaeger**: 分布式追踪
- **Node Exporter**: 节点指标收集
- **cAdvisor**: 容器指标收集

## VGO-IAM 微服务功能详述

### 核心功能模块

#### 1. 用户管理 (User Management)
- **用户创建**: 支持创建新用户，包含用户名、显示名称、邮箱等信息
- **用户查询**: 根据用户名查询用户详细信息
- **用户数据模型**: 
  - 唯一用户名和邮箱
  - 显示名称支持
  - 密码哈希字段(预留控制台登录)
  - 创建和更新时间戳

#### 2. 策略管理 (Policy Management)
- **策略创建**: 创建基于JSON格式的访问控制策略
- **策略文档**: 支持复杂的权限控制规则定义
- **用户策略绑定**: 将策略附加到指定用户
- **策略引擎**: 
  - 支持通配符匹配 (*)
  - ARN模式匹配
  - 动作和资源权限验证
  - Redis缓存优化性能

#### 3. 访问密钥管理 (Access Key Management)
- **密钥生成**: 自动生成AccessKeyID和SecretAccessKey
- **密钥加密存储**: 使用AES-GCM算法加密存储密钥
- **密钥状态管理**: 支持active/inactive状态切换
- **密钥列表**: 查询用户的所有访问密钥
- **密钥轮换**: 
  - 支持主密钥轮换
  - 保留历史密钥用于解密
  - 自动重新加密机制

#### 4. 签名验证 (Signature Verification)
- **V4签名算法**: 实现类似AWS的签名验证机制
- **HMAC-SHA256**: 使用HMAC-SHA256进行签名计算
- **时间窗口验证**: ±5分钟的时间戳验证
- **签名流程**:
  1. 构建待签名字符串
  2. 派生签名密钥(日期、区域、服务)
  3. 计算HMAC-SHA256签名
  4. Base64编码输出

#### 5. 权限验证 (Permission Verification)
- **访问密钥验证**: 验证请求中的访问密钥有效性
- **权限检查**: 基于用户策略检查操作权限
- **gRPC拦截器**: 自动验证所有gRPC请求
- **忽略列表**: 支持配置无需认证的接口

#### 6. 应用管理 (Application Management)
- **应用创建**: 支持创建OAuth2应用，包含应用名称、描述、类型等信息
- **应用查询**: 根据应用ID查询应用详细信息
- **应用列表**: 支持分页查询用户的应用列表，可按状态筛选
- **应用更新**: 更新应用的基本信息、回调URL、允许的来源等
- **应用删除**: 安全删除应用及其相关数据
- **应用类型**: 支持web、mobile、api、spa等多种应用类型
- **回调URL管理**: 支持多个回调URL配置
- **CORS配置**: 支持配置允许的来源域名
- **状态管理**: 支持active、inactive、suspended等状态
- **输入验证**: 完整的参数验证和错误处理
- **调试界面**: 提供Web界面进行应用管理操作

#### 7. 安全特性 (Security Features)
- **加密存储**: 所有敏感数据使用AES-256-GCM加密
- **密钥管理**: 支持主密钥轮换和历史密钥保留
- **访问控制**: 基于策略的细粒度权限控制
- **审计日志**: 完整的操作日志记录
- **限流保护**: 支持内存和Redis两种限流方式

### 技术架构

#### 数据库设计
- **users表**: 用户基本信息存储
- **policies表**: 策略定义，使用JSONB存储策略文档
- **access_keys表**: 访问密钥信息，密钥加密存储
- **user_policies表**: 用户与策略的多对多关联
- **applications表**: 应用信息存储，包含应用配置和状态
- **索引优化**: 针对查询场景优化的数据库索引

#### gRPC API接口
- **用户管理**: CreateUser, GetUser
- **策略管理**: CreatePolicy, AttachUserPolicy
- **密钥管理**: CreateAccessKey, ListAccessKeys, UpdateAccessKeyStatus
- **应用管理**: CreateApplication, GetApplication, ListApplications, UpdateApplication, DeleteApplication
- **权限验证**: VerifyAccessKey, CheckPermission

#### 中间件与拦截器
- **AccessKeyInterceptor**: gRPC访问密钥验证拦截器
- **签名验证**: 自动验证请求签名
- **元数据提取**: 从gRPC元数据中提取认证信息

#### 配置管理
- **数据库配置**: PostgreSQL连接配置
- **中间件配置**: 主密钥和忽略列表配置
- **日志配置**: 多级别日志输出配置
- **监控配置**: Sentry错误追踪配置
- **限流配置**: 可配置的限流策略

### 部署特性
- **容器化部署**: 完整的Docker支持
- **Kubernetes就绪**: 包含健康检查和资源限制
- **监控集成**: Prometheus指标暴露
- **高可用性**: 支持多实例部署
- **配置外部化**: 支持环境变量和配置文件

### 使用示例

#### 创建用户和策略
```bash
# 创建用户
grpcurl -plaintext -d '{"name":"testuser","display_name":"Test User","email":"test@example.com"}' \
  localhost:50051 iam.v1.IAM/CreateUser

# 创建策略
grpcurl -plaintext -d '{"name":"read-policy","description":"Read access policy","policy_document":"{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"*:Get*\",\"*:List*\"],\"Resource\":[\"*\"]}]}"}' \
  localhost:50051 iam.v1.IAM/CreatePolicy

# 绑定策略到用户
grpcurl -plaintext -d '{"user_name":"testuser","policy_name":"read-policy"}' \
  localhost:50051 iam.v1.IAM/AttachUserPolicy
```

#### 创建和使用访问密钥
```bash
# 创建访问密钥
grpcurl -plaintext -d '{"user_name":"testuser"}' \
  localhost:50051 iam.v1.IAM/CreateAccessKey

# 使用访问密钥进行签名验证(在应用代码中)
# 客户端需要实现V4签名算法，并在gRPC元数据中包含:
# - access-key-id: 访问密钥ID
# - signature: 计算的签名
# - timestamp: 请求时间戳
```

#### 应用管理操作
```bash
# 创建应用
grpcurl -plaintext -d '{"app_name":"MyApp","app_description":"我的测试应用","app_type":"web","app_website":"https://example.com","callback_urls":["https://example.com/callback"],"allowed_origins":["https://example.com"]}' \
  localhost:50051 iam.v1.IAM/CreateApplication

# 查询应用
grpcurl -plaintext -d '{"app_id":1}' \
  localhost:50051 iam.v1.IAM/GetApplication

# 获取应用列表
grpcurl -plaintext -d '{"user_name":"testuser","status":"active","page":1,"page_size":10}' \
  localhost:50051 iam.v1.IAM/ListApplications

# 更新应用
grpcurl -plaintext -d '{"app_id":1,"app_name":"UpdatedApp","app_description":"更新后的应用描述"}' \
  localhost:50051 iam.v1.IAM/UpdateApplication

# 删除应用
grpcurl -plaintext -d '{"app_id":1}' \
  localhost:50051 iam.v1.IAM/DeleteApplication
```

#### 使用调试界面
```bash
# 启动调试GUI
./bin/iam-service debug-gui

# 访问Web界面进行应用管理
# 浏览器打开: http://localhost:8080
# 可以通过Web界面进行用户管理、访问密钥管理、权限检查和应用管理操作
```

## 数据库迁移管理

### 迁移工具安装

项目使用 `golang-migrate` 工具进行数据库迁移管理。

#### 本地开发环境

```bash
# 安装 migrate 工具
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

#### Docker容器环境

`vgo-iam` 服务的Docker镜像中已经集成了 `golang-migrate` 工具（版本 v4.17.0），可以直接在容器内使用 `migrate` 命令。

> **注意**: 如果后续创建其他微服务（如 `vgo-notify`），也需要在各自的 `Dockerfile` 中添加 `migrate` 工具的安装步骤。

### 迁移文件位置

数据库迁移文件位于 `vgo-iam/migrations/` 目录下：

```
vgo-iam/migrations/
├── 000001_init_schema.up.sql      # 初始化数据库结构
├── 000001_init_schema.down.sql    # 回滚初始化
├── 000002_add_last_used_at.up.sql # 添加最后使用时间字段
├── 000002_add_last_used_at.down.sql
└── ...
```

### 迁移命令

#### 执行迁移（向上）

```bash
# 本地开发环境（需要安装migrate工具）
migrate -path ./vgo-iam/migrations/ -database "postgres://vgo_user:vgo_password@localhost:5432/vgo_iam?sslmode=disable" up

# Docker Compose环境（在容器内执行）
docker-compose exec vgo-iam migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" up

# Kubernetes环境（在Pod内执行）
kubectl exec -it deployment/vgo-iam -n vgo-microservices -- migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" up

# 直接连接数据库（开发环境）
migrate -path ./vgo-iam/migrations/ -database "postgres://vgo_iam:KESdCZeYYXBZcebH@10.0.0.200:5432/vgo_iam?sslmode=disable" up
```

#### 回滚迁移（向下）

```bash
# 本地开发环境
migrate -path ./vgo-iam/migrations/ -database "postgres://vgo_user:vgo_password@localhost:5432/vgo_iam?sslmode=disable" down 1

# Docker Compose环境（在容器内执行）
docker-compose exec vgo-iam migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" down 1

# 回滚到指定版本
docker-compose exec vgo-iam migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" goto 2
```

#### 查看迁移状态

```bash
# 本地开发环境
migrate -path ./vgo-iam/migrations/ -database "postgres://vgo_user:vgo_password@localhost:5432/vgo_iam?sslmode=disable" version

# Docker Compose环境（在容器内执行）
docker-compose exec vgo-iam migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" version
```

#### 创建新的迁移文件

```bash
# 创建新的迁移文件
migrate create -ext sql -dir ./vgo-iam/migrations/ -seq add_new_feature
```

### 迁移最佳实践

1. **总是创建配对的up和down文件**：确保每个迁移都可以回滚
2. **测试迁移**：在开发环境中测试迁移的正确性
3. **备份数据**：在生产环境执行迁移前备份数据库
4. **渐进式迁移**：避免在单个迁移中进行过多更改
5. **版本控制**：将迁移文件纳入版本控制系统

### 注意事项

- 迁移文件一旦应用到生产环境，不应再修改
- 使用事务确保迁移的原子性
- 对于大表的结构变更，考虑使用在线DDL工具
- 在集群环境中，确保只有一个实例执行迁移

## 构建和版本管理

### 版本信息注入

项目支持在构建时自动注入版本信息，包括版本号、Git提交哈希和构建时间。这些信息会在服务启动时显示，便于版本追踪和问题排查。

#### 自动构建脚本

使用提供的构建脚本可以自动获取Git信息并构建Docker镜像：

```bash
# 使用构建脚本（推荐）
./scripts/build.sh
```

构建脚本会自动：
- 从Git获取当前版本标签或提交哈希
- 获取短提交哈希
- 设置构建时间
- 将这些信息注入到Docker镜像中

#### 手动指定版本信息

你也可以手动指定版本信息：

```bash
# 设置环境变量
export VERSION="v1.2.0"
export COMMIT="abc1234"
export BUILD_TIME="2024-01-20 10:30:00 UTC"

# 构建镜像
docker-compose build vgo-iam
```

#### 环境变量配置

复制 `.env.example` 为 `.env` 并根据需要修改：

```bash
cp .env.example .env
```

`.env` 文件中可以配置：
- `VERSION`: 版本号（可选，默认从Git获取）
- `COMMIT`: Git提交哈希（可选，默认从Git获取）
- `BUILD_TIME`: 构建时间（可选，默认为当前时间）

#### 版本信息查看

服务启动时会在日志中显示版本信息：

```
VGO-IAM 服务启动 version=v1.2.0 commit=abc1234 build_time="2024-01-20 10:30:00 UTC"
```

### 构建参数说明

| 参数 | 描述 | 默认值 | 获取方式 |
|------|------|--------|----------|
| VERSION | 版本号 | v1.0.0 | `git describe --tags --always --dirty` |
| COMMIT | Git提交哈希 | unknown | `git rev-parse --short HEAD` |
| BUILD_TIME | 构建时间 | unknown | `date -u '+%Y-%m-%d %H:%M:%S UTC'` |

## 快速开始

### 1. Docker Compose部署

#### 前置要求
- Docker 20.10+
- Docker Compose 2.0+
- golang-migrate工具（用于数据库迁移）

```bash
# 安装 migrate 工具
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

#### 部署步骤

```bash
# 1. 克隆项目
git clone <repository-url>
cd vgo_micro_service

# 2. 设置执行权限
chmod +x scripts/*.sh

# 3. 创建开发环境配置
./scripts/setup-env.sh dev create

# 4. 构建镜像
./scripts/deploy.sh build

# 5. 启动服务
./scripts/deploy.sh docker-compose start

# 6. 执行数据库迁移
# 等待数据库服务启动完成后执行（使用容器内的migrate工具）
docker-compose exec vgo-iam migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" up

# 7. 检查服务状态
./scripts/deploy.sh docker-compose status
```

#### 访问地址
- VGO-IAM HTTP: http://localhost:8080
- VGO-IAM gRPC: localhost:9090
- VGO-NOTIFY HTTP: http://localhost:8082
- VGO-NOTIFY gRPC: localhost:9092
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin123)
- Jaeger: http://localhost:16686

### 2. Kubernetes部署

#### 前置要求
- Kubernetes 1.20+
- kubectl
- Helm 3.0+ (可选)

#### 使用脚本部署

```bash
# 1. 创建生产环境配置
./scripts/setup-env.sh prod create

# 2. 更新生产环境密码
./scripts/setup-env.sh prod update-passwords

# 3. 验证配置
./scripts/setup-env.sh prod validate

# 4. 创建Kubernetes密钥
./scripts/setup-env.sh prod k8s-secrets

# 5. 部署到Kubernetes
./scripts/deploy.sh k8s start

# 6. 执行数据库迁移
# 等待数据库Pod启动完成后执行
kubectl exec -it deployment/vgo-iam -n vgo-microservices -- migrate -path ./migrations/ -database "postgres://vgo_user:vgo_password@postgres:5432/vgo_iam?sslmode=disable" up

# 7. 检查部署状态
./scripts/deploy.sh k8s status
```

#### 使用Helm部署

```bash
# 1. 添加依赖仓库
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 2. 安装依赖
helm dependency update helm/vgo-microservices

# 3. 部署
helm install vgo-microservices helm/vgo-microservices \
  --namespace vgo-microservices \
  --create-namespace \
  --values helm/vgo-microservices/values.yaml

# 4. 检查状态
helm status vgo-microservices -n vgo-microservices
kubectl get pods -n vgo-microservices
```

#### 配置域名解析

将以下内容添加到 `/etc/hosts`：

```
127.0.0.1 api.vgo.local
127.0.0.1 monitoring.vgo.local
127.0.0.1 vgo-iam.local
127.0.0.1 vgo-notify.local
127.0.0.1 prometheus.vgo.local
127.0.0.1 grafana.vgo.local
127.0.0.1 jaeger.vgo.local
```

## 环境配置

### 环境类型
- **dev**: 开发环境
- **staging**: 预发布环境
- **prod**: 生产环境

### 配置管理

```bash
# 创建环境配置
./scripts/setup-env.sh [env] create

# 验证配置
./scripts/setup-env.sh [env] validate

# 创建Kubernetes密钥
./scripts/setup-env.sh [env] k8s-secrets

# 更新生产环境密码
./scripts/setup-env.sh prod update-passwords
```

### 重要配置项

#### 数据库配置
- `POSTGRES_HOST`: PostgreSQL主机地址
- `POSTGRES_PASSWORD`: 数据库密码
- `REDIS_PASSWORD`: Redis密码

#### 安全配置
- `VGO_IAM_JWT_SECRET`: JWT签名密钥
- `VGO_IAM_ACCESS_KEY_ROTATION_DAYS`: 访问密钥轮换天数

#### 通知配置
- `SMTP_HOST`: 邮件服务器地址
- `SMS_PROVIDER`: 短信服务提供商
- `WEBHOOK_TIMEOUT`: Webhook超时时间

## 监控和运维

### 健康检查

```bash
# Docker Compose
curl http://localhost:8080/health
curl http://localhost:8082/health

# Kubernetes
kubectl get pods -n vgo-microservices
kubectl describe pod <pod-name> -n vgo-microservices
```

### 日志查看

```bash
# Docker Compose
docker-compose logs -f vgo-iam
docker-compose logs -f vgo-notify

# Kubernetes
kubectl logs -f deployment/vgo-iam -n vgo-microservices
kubectl logs -f deployment/vgo-notify -n vgo-microservices
```

### 指标监控

- **Prometheus**: 收集和存储指标数据
- **Grafana**: 可视化监控仪表板
- **Jaeger**: 分布式追踪分析

### 告警规则

系统包含以下预配置的告警规则：
- 服务可用性监控
- 高错误率告警
- 高延迟告警
- 资源使用率告警
- 数据库连接监控

## 扩容和高可用

### 水平扩容

```bash
# Docker Compose
docker-compose up -d --scale vgo-iam=3 --scale vgo-notify=2

# Kubernetes
kubectl scale deployment vgo-iam --replicas=3 -n vgo-microservices
kubectl scale deployment vgo-notify --replicas=2 -n vgo-microservices

# Helm
helm upgrade vgo-microservices helm/vgo-microservices \
  --set vgoIam.replicaCount=3 \
  --set vgoNotify.replicaCount=2
```

### 自动扩容（Kubernetes）

系统配置了HPA（Horizontal Pod Autoscaler）：
- CPU使用率超过70%时自动扩容
- 内存使用率超过80%时自动扩容
- 最小副本数：2
- 最大副本数：10

## 安全最佳实践

### 1. 密码管理
- 生产环境必须更改默认密码
- 使用强密码策略
- 定期轮换密钥

### 2. 网络安全
- 启用网络策略
- 使用TLS加密
- 限制服务间通信

### 3. 访问控制
- 使用RBAC权限控制
- 最小权限原则
- 定期审计访问日志

## 故障排除

### 常见问题

#### 1. 服务启动失败
```bash
# 检查日志
docker-compose logs <service-name>
kubectl logs <pod-name> -n vgo-microservices

# 检查配置
kubectl describe pod <pod-name> -n vgo-microservices
```

#### 2. 数据库连接失败
```bash
# 检查数据库状态
docker-compose exec postgres pg_isready
kubectl exec -it <postgres-pod> -n vgo-microservices -- pg_isready

# 检查网络连接
kubectl exec -it <app-pod> -n vgo-microservices -- nslookup postgres
```

#### 3. 监控服务异常
```bash
# 检查Prometheus目标
curl http://localhost:9090/api/v1/targets

# 检查Grafana数据源
curl -u admin:admin123 http://localhost:3000/api/datasources
```

### 性能调优

#### 1. 资源配置
- 根据实际负载调整CPU和内存限制
- 配置合适的JVM参数
- 优化数据库连接池

#### 2. 缓存策略
- 合理使用Redis缓存
- 配置缓存过期时间
- 监控缓存命中率

## 备份和恢复

### 数据库备份

```bash
# PostgreSQL备份
docker-compose exec postgres pg_dump -U vgo_user vgo_iam > backup.sql
kubectl exec <postgres-pod> -n vgo-microservices -- pg_dump -U vgo_user vgo_iam > backup.sql

# Redis备份
docker-compose exec redis redis-cli --rdb /data/dump.rdb
kubectl exec <redis-pod> -n vgo-microservices -- redis-cli BGSAVE
```

### 配置备份

```bash
# 备份Kubernetes配置
kubectl get all -n vgo-microservices -o yaml > k8s-backup.yaml

# 备份Helm配置
helm get values vgo-microservices -n vgo-microservices > helm-values-backup.yaml
```

## 升级指南

### 滚动升级

```bash
# Docker Compose
docker-compose pull
docker-compose up -d

# Kubernetes
kubectl set image deployment/vgo-iam vgo-iam=vgo-iam:v2.0.0 -n vgo-microservices
kubectl rollout status deployment/vgo-iam -n vgo-microservices

# Helm
helm upgrade vgo-microservices helm/vgo-microservices --set vgoIam.image.tag=v2.0.0
```

### 回滚

```bash
# Kubernetes
kubectl rollout undo deployment/vgo-iam -n vgo-microservices

# Helm
helm rollback vgo-microservices 1 -n vgo-microservices
```

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 创建Pull Request

## 许可证

Apache License 2.0

## 联系方式

- 项目主页: https://github.com/vgo/microservices
- 问题反馈: https://github.com/vgo/microservices/issues



## 发布流程

### 检查所有项目状态：
``` sh
./scripts/release.sh check-all
```

### 发布单个项目：
``` sh
# 发布vgo-kit
./scripts/release.sh release vgo-kit v1.0.0

# 发布vgo-iam
./scripts/release.sh release vgo-iam v1.0.0

# 发布vgo-gateway
./scripts/release.sh release vgo-gateway v1.0.0

```


### 发布所有项目：
``` sh
./scripts/release.sh release-all v1.0.0

```


### 其他有用命令：
``` sh
# 列出所有项目状态
./scripts/release.sh list

# 检查单个项目
./scripts/release.sh check vgo-iam

# 强制发布（跳过确认）
./scripts/release.sh release-all v1.0.0 -f

# 跳过测试发布
./scripts/release.sh release vgo-kit v1.0.0 -s
```