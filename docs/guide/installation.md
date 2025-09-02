# 安装指南

本指南详细介绍了VGO微服务的各种安装方式，您可以根据自己的需求选择合适的安装方法。

## 📦 安装方式概览

| 安装方式 | 适用场景 | 难度 | 推荐度 |
|---------|---------|------|--------|
| Docker Compose | 开发、测试 | ⭐ | ⭐⭐⭐⭐⭐ |
| 二进制文件 | 生产环境 | ⭐⭐ | ⭐⭐⭐⭐ |
| 源码编译 | 定制开发 | ⭐⭐⭐ | ⭐⭐⭐ |
| Kubernetes | 云原生环境 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 🐳 Docker Compose 安装

### 系统要求

- Docker 20.10+
- Docker Compose 2.0+
- 至少 2GB 可用内存
- 至少 5GB 可用磁盘空间

### 安装步骤

#### 1. 获取项目代码

```bash
# 使用Git克隆
git clone https://github.com/vera-byte/vgo_micro_service.git
cd vgo_micro_service

# 或者下载压缩包
wget https://github.com/vera-byte/vgo_micro_service/archive/main.zip
unzip main.zip
cd vgo_micro_service-main
```

#### 2. 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑环境变量
vim .env
```

关键配置项：

```bash
# 数据库配置
POSTGRES_DB=vgo_iam
POSTGRES_USER=vgo_iam
POSTGRES_PASSWORD=your_secure_password

# 服务配置
GRPC_PORT=50051
HTTP_PORT=8080

# 安全配置
MASTER_KEY=your_master_key_here
JWT_SECRET=your_jwt_secret_here
```

#### 3. 启动服务

```bash
# 启动所有服务
docker-compose up -d

# 查看启动状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

#### 4. 初始化数据

```bash
# 等待数据库启动完成
sleep 30

# 运行数据库迁移
docker-compose exec vgo-iam ./bin/iam-service migrate

# 创建管理员账户
docker-compose exec vgo-iam ./bin/iam-service init-admin
```

## 📁 二进制文件安装

### 下载预编译二进制文件

```bash
# 下载最新版本
wget https://github.com/vera-byte/vgo_micro_service/releases/latest/download/iam-service-linux-amd64.tar.gz

# 解压
tar -xzf iam-service-linux-amd64.tar.gz

# 移动到系统路径
sudo mv iam-service /usr/local/bin/
sudo chmod +x /usr/local/bin/iam-service
```

### 配置文件

```bash
# 创建配置目录
sudo mkdir -p /etc/vgo-iam

# 下载配置模板
wget -O /etc/vgo-iam/config.yaml https://raw.githubusercontent.com/vera-byte/vgo_micro_service/main/vgo-iam/config/config.yaml.example

# 编辑配置
sudo vim /etc/vgo-iam/config.yaml
```

### 创建系统服务

```bash
# 创建systemd服务文件
sudo tee /etc/systemd/system/vgo-iam.service > /dev/null <<EOF
[Unit]
Description=VGO IAM Service
After=network.target postgresql.service

[Service]
Type=simple
User=vgo-iam
Group=vgo-iam
ExecStart=/usr/local/bin/iam-service server --config /etc/vgo-iam/config.yaml
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 创建用户
sudo useradd -r -s /bin/false vgo-iam

# 重载systemd配置
sudo systemctl daemon-reload

# 启动服务
sudo systemctl enable vgo-iam
sudo systemctl start vgo-iam

# 查看状态
sudo systemctl status vgo-iam
```

## 🔨 源码编译安装

### 系统要求

- Go 1.19+
- Git
- Make
- Protocol Buffers编译器

### 安装依赖

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y git make protobuf-compiler

# CentOS/RHEL
sudo yum install -y git make protobuf-compiler

# macOS
brew install git make protobuf
```

### 编译步骤

```bash
# 1. 克隆代码
git clone https://github.com/vera-byte/vgo_micro_service.git
cd vgo_micro_service/vgo-iam

# 2. 安装Go依赖
go mod download

# 3. 安装protobuf工具
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# 4. 生成protobuf代码
make proto

# 5. 编译二进制文件
make build

# 6. 运行测试
make test

# 7. 安装到系统
sudo make install
```

### 编译选项

```bash
# 编译特定平台
GOOS=linux GOARCH=amd64 make build

# 编译所有平台
make build-all

# 编译Docker镜像
make docker

# 编译并推送Docker镜像
make docker-push
```

## ☸️ Kubernetes 安装

### 前置要求

- Kubernetes 1.20+
- kubectl 配置完成
- Helm 3.0+ (可选)

### 使用Helm安装（推荐）

```bash
# 1. 添加Helm仓库
helm repo add vgo https://charts.vgo.dev
helm repo update

# 2. 创建命名空间
kubectl create namespace vgo-system

# 3. 安装VGO
helm install vgo-iam vgo/vgo-iam \
  --namespace vgo-system \
  --set postgresql.enabled=true \
  --set redis.enabled=true

# 4. 查看安装状态
kubectl get pods -n vgo-system
```

### 使用YAML文件安装

```bash
# 1. 应用Kubernetes配置
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/redis.yaml
kubectl apply -f k8s/vgo-iam.yaml

# 2. 查看部署状态
kubectl get all -n vgo-system

# 3. 查看服务日志
kubectl logs -f deployment/vgo-iam -n vgo-system
```

### 配置Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vgo-iam-ingress
  namespace: vgo-system
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - iam.yourdomain.com
    secretName: vgo-iam-tls
  rules:
  - host: iam.yourdomain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: vgo-iam
            port:
              number: 8080
```

## 🔧 安装后配置

### 数据库初始化

```bash
# Docker Compose环境
docker-compose exec vgo-iam ./bin/iam-service migrate
docker-compose exec vgo-iam ./bin/iam-service init-admin

# 二进制安装
iam-service migrate --config /etc/vgo-iam/config.yaml
iam-service init-admin --config /etc/vgo-iam/config.yaml

# Kubernetes环境
kubectl exec -it deployment/vgo-iam -n vgo-system -- ./bin/iam-service migrate
kubectl exec -it deployment/vgo-iam -n vgo-system -- ./bin/iam-service init-admin
```

### 验证安装

```bash
# 检查服务健康状态
curl http://localhost:8080/health

# 测试gRPC接口
grpcurl -plaintext localhost:50051 grpc.health.v1.Health/Check

# 访问调试界面
open http://localhost:8080
```

## 🚨 故障排除

### 常见问题

#### 1. 端口被占用

```bash
# 查看端口占用
sudo netstat -tlnp | grep :8080
sudo netstat -tlnp | grep :50051

# 修改配置文件中的端口
vim config/config.yaml
```

#### 2. 数据库连接失败

```bash
# 检查PostgreSQL状态
sudo systemctl status postgresql

# 测试数据库连接
psql -h localhost -U vgo_iam -d vgo_iam

# 检查防火墙设置
sudo ufw status
```

#### 3. 权限问题

```bash
# 检查文件权限
ls -la /usr/local/bin/iam-service
ls -la /etc/vgo-iam/

# 修复权限
sudo chown vgo-iam:vgo-iam /etc/vgo-iam/config.yaml
sudo chmod 600 /etc/vgo-iam/config.yaml
```

### 日志查看

```bash
# Docker Compose
docker-compose logs vgo-iam

# Systemd服务
sudo journalctl -u vgo-iam -f

# Kubernetes
kubectl logs -f deployment/vgo-iam -n vgo-system
```

## 📚 下一步

安装完成后，您可以：

1. [配置详解](./configuration.md) - 了解详细配置选项
2. [基本使用](./basic-usage.md) - 开始使用VGO服务
3. [API文档](/api/) - 查看API接口文档

::: warning 注意
在生产环境中，请确保：
- 使用强密码和安全的密钥
- 配置适当的防火墙规则
- 定期备份数据库
- 监控服务运行状态
:::