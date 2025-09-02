# 快速开始

欢迎使用VGO微服务！本指南将帮助您快速了解和部署VGO身份认证与授权管理系统。

## 📚 文档导航

- [安装指南](./installation.md) - 详细的安装步骤
- [配置指南](./configuration.md) - 服务配置说明
- [基础使用](./basic-usage.md) - API使用示例
- [国际化指南](./internationalization.md) - 多语言支持配置

## 📋 系统要求

在开始之前，请确保您的系统满足以下要求：

### 基础环境
- **操作系统**: Linux、macOS 或 Windows
- **Go语言**: 1.19+ (如需从源码编译)
- **Docker**: 20.10+ (推荐使用Docker部署)
- **Docker Compose**: 2.0+

### 数据库要求
- **PostgreSQL**: 13+
- **Redis**: 6.0+ (可选，用于缓存)

## 🚀 快速部署

### 方式一：使用Docker Compose（推荐）

这是最简单的部署方式，适合快速体验和开发环境。

```bash
# 1. 克隆项目
git clone https://github.com/vera-byte/vgo_micro_service.git
cd vgo_micro_service

# 2. 启动所有服务
docker-compose up -d

# 3. 查看服务状态
docker-compose ps
```

服务启动后，您可以访问：
- **调试界面**: http://localhost:8080
- **gRPC服务**: localhost:50051
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

### 方式二：手动部署

如果您希望更精细地控制部署过程，可以选择手动部署。

#### 1. 准备数据库

```bash
# 启动PostgreSQL
docker run -d \
  --name vgo-postgres \
  -e POSTGRES_DB=vgo_iam \
  -e POSTGRES_USER=vgo_iam \
  -e POSTGRES_PASSWORD=your_password \
  -p 5432:5432 \
  postgres:13

# 启动Redis（可选）
docker run -d \
  --name vgo-redis \
  -p 6379:6379 \
  redis:6-alpine
```

#### 2. 配置服务

```bash
# 进入vgo-iam目录
cd vgo-iam

# 复制配置文件
cp config/config.yaml.example config/config.yaml

# 编辑配置文件，修改数据库连接信息
vim config/config.yaml
```

#### 3. 编译和运行

```bash
# 编译服务
go build -o bin/iam-service cmd/server.go

# 运行数据库迁移
./bin/iam-service migrate

# 初始化管理员账户
./bin/iam-service init-admin

# 启动服务
./bin/iam-service server
```

## 🔧 初始化配置

### 创建管理员账户

首次部署后，您需要创建管理员账户：

```bash
# 使用Docker Compose
docker-compose exec vgo-iam ./bin/iam-service init-admin

# 或者直接运行
./bin/iam-service init-admin
```

系统会提示您输入管理员信息：
- 用户名
- 显示名称
- 邮箱地址
- 密码

### 获取访问密钥

创建管理员账户后，获取API访问密钥：

```bash
# 获取管理员访问密钥
docker-compose exec vgo-iam ./bin/iam-service get-admin-key
```

## 🎯 验证部署

### 1. 检查服务状态

```bash
# 检查所有容器状态
docker-compose ps

# 查看服务日志
docker-compose logs vgo-iam
```

### 2. 访问调试界面

打开浏览器访问 http://localhost:8080，您应该能看到VGO调试界面，包括：
- 用户管理
- 策略管理
- 访问密钥管理
- 应用管理
- 权限检查

### 3. 测试gRPC API

使用grpcurl测试API接口：

```bash
# 安装grpcurl
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# 测试创建用户
grpcurl -plaintext -d '{
  "name":"testuser",
  "display_name":"Test User",
  "email":"test@example.com"
}' localhost:50051 iam.v1.IAM/CreateUser
```

## 🔍 故障排除

### 常见问题

#### 1. 数据库连接失败

```bash
# 检查PostgreSQL是否正常运行
docker-compose logs postgres

# 检查数据库连接配置
cat vgo-iam/config/config.yaml
```

#### 2. 端口冲突

如果遇到端口冲突，可以修改`docker-compose.yml`中的端口映射：

```yaml
services:
  vgo-iam:
    ports:
      - "8081:8080"  # 修改调试界面端口
      - "50052:50051" # 修改gRPC端口
```

#### 3. 权限问题

```bash
# 确保有足够的权限
sudo chown -R $USER:$USER .

# 检查Docker权限
sudo usermod -aG docker $USER
```

### 查看日志

```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs vgo-iam

# 实时查看日志
docker-compose logs -f vgo-iam
```

## 📚 下一步

恭喜！您已经成功部署了VGO微服务。接下来您可以：

1. [配置详解](./configuration.md) - 了解详细的配置选项
2. [基本使用](./basic-usage.md) - 学习如何使用各项功能
3. [API文档](/api/) - 查看完整的API接口文档
4. [部署指南](/deployment/) - 了解生产环境部署

::: tip 提示
如果您在部署过程中遇到问题，请查看[故障排除指南](./troubleshooting.md)或在GitHub上提交Issue。
:::