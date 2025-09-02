# 基本使用

本指南将带您了解VGO微服务的核心功能和基本使用方法，包括用户管理、权限控制、应用管理等核心特性。

## 🎯 功能概览

VGO微服务提供以下核心功能：

- **用户管理**: 创建、查询、更新、删除用户
- **策略管理**: 定义和管理权限策略
- **访问密钥管理**: 生成和管理API访问密钥
- **应用管理**: OAuth2应用注册和管理
- **权限验证**: 细粒度的权限检查
- **开发者认证**: 个人和企业开发者身份验证

## 🖥️ 使用调试界面

### 访问调试界面

启动服务后，打开浏览器访问调试界面：

```
http://localhost:8080
```

调试界面提供了友好的Web界面来管理所有功能，包括：

- **用户管理页面**: 创建、编辑、删除用户
- **策略管理页面**: 管理权限策略
- **访问密钥页面**: 生成和管理API密钥
- **应用管理页面**: 注册和管理OAuth2应用
- **权限检查页面**: 测试权限验证

### 界面功能说明

#### 1. 用户管理

- **创建用户**: 填写用户名、显示名称、邮箱等信息
- **查看用户列表**: 支持分页和搜索
- **编辑用户**: 修改用户基本信息
- **删除用户**: 删除不需要的用户账户

#### 2. 策略管理

- **创建策略**: 定义JSON格式的权限策略
- **策略模板**: 提供常用策略模板
- **策略绑定**: 将策略绑定到用户
- **策略验证**: 验证策略语法正确性

#### 3. 访问密钥管理

- **生成密钥**: 为用户生成API访问密钥
- **密钥状态**: 启用/禁用访问密钥
- **密钥轮换**: 定期更新访问密钥
- **使用统计**: 查看密钥使用情况

#### 4. 应用管理

- **注册应用**: 创建OAuth2应用
- **应用配置**: 设置回调URL、允许来源等
- **应用类型**: 支持Web、移动、API、SPA等类型
- **应用状态**: 管理应用的激活状态

## 🔧 使用gRPC API

### 安装grpcurl工具

```bash
# 使用Go安装
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# 或使用包管理器
# macOS
brew install grpcurl

# Ubuntu/Debian
sudo apt install grpcurl
```

### 用户管理API

#### 创建用户

```bash
grpcurl -plaintext -d '{
  "name": "john_doe",
  "display_name": "John Doe",
  "email": "john@example.com"
}' localhost:50051 iam.v1.IAM/CreateUser
```

响应示例：
```json
{
  "user": {
    "id": "1",
    "name": "john_doe",
    "display_name": "John Doe",
    "email": "john@example.com",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

#### 获取用户信息

```bash
grpcurl -plaintext -d '{
  "name": "john_doe"
}' localhost:50051 iam.v1.IAM/GetUser
```

#### 更新用户信息

```bash
grpcurl -plaintext -d '{
  "name": "john_doe",
  "display_name": "John Smith",
  "email": "john.smith@example.com"
}' localhost:50051 iam.v1.IAM/UpdateUser
```

#### 删除用户

```bash
grpcurl -plaintext -d '{
  "name": "john_doe"
}' localhost:50051 iam.v1.IAM/DeleteUser
```

#### 获取用户列表

```bash
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListUsers
```

### 策略管理API

#### 创建策略

```bash
grpcurl -plaintext -d '{
  "name": "read_only_policy",
  "description": "只读权限策略",
  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\"],\"Resource\":[\"*\"]}]}"
}' localhost:50051 iam.v1.IAM/CreatePolicy
```

#### 获取策略

```bash
grpcurl -plaintext -d '{
  "name": "read_only_policy"
}' localhost:50051 iam.v1.IAM/GetPolicy
```

#### 绑定策略到用户

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "policy_name": "read_only_policy"
}' localhost:50051 iam.v1.IAM/AttachUserPolicy
```

#### 解绑用户策略

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "policy_name": "read_only_policy"
}' localhost:50051 iam.v1.IAM/DetachUserPolicy
```

### 访问密钥管理API

#### 创建访问密钥

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "description": "API访问密钥"
}' localhost:50051 iam.v1.IAM/CreateAccessKey
```

响应示例：
```json
{
  "access_key": {
    "access_key_id": "AKIA1234567890EXAMPLE",
    "secret_access_key": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    "status": "active",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

#### 获取访问密钥列表

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe"
}' localhost:50051 iam.v1.IAM/ListAccessKeys
```

#### 更新访问密钥状态

```bash
grpcurl -plaintext -d '{
  "access_key_id": "AKIA1234567890EXAMPLE",
  "status": "inactive"
}' localhost:50051 iam.v1.IAM/UpdateAccessKey
```

#### 删除访问密钥

```bash
grpcurl -plaintext -d '{
  "access_key_id": "AKIA1234567890EXAMPLE"
}' localhost:50051 iam.v1.IAM/DeleteAccessKey
```

### 应用管理API

#### 创建应用

```bash
grpcurl -plaintext -d '{
  "app_name": "MyWebApp",
  "app_description": "我的Web应用",
  "app_type": "web",
  "app_website": "https://myapp.example.com",
  "callback_urls": ["https://myapp.example.com/callback"],
  "allowed_origins": ["https://myapp.example.com"]
}' localhost:50051 iam.v1.IAM/CreateApplication
```

#### 获取应用信息

```bash
grpcurl -plaintext -d '{
  "app_id": 1
}' localhost:50051 iam.v1.IAM/GetApplication
```

#### 更新应用

```bash
grpcurl -plaintext -d '{
  "app_id": 1,
  "app_name": "UpdatedWebApp",
  "app_description": "更新后的Web应用",
  "app_type": "spa"
}' localhost:50051 iam.v1.IAM/UpdateApplication
```

#### 获取应用列表

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "status": "active",
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListApplications
```

#### 删除应用

```bash
grpcurl -plaintext -d '{
  "app_id": 1
}' localhost:50051 iam.v1.IAM/DeleteApplication
```

### 权限验证API

#### 检查权限

```bash
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "action": "iam:GetUser",
  "resource": "*"
}' localhost:50051 iam.v1.IAM/CheckPermission
```

响应示例：
```json
{
  "allowed": true,
  "reason": "User has required permissions"
}
```

## 🔐 权限策略语法

### 策略文档结构

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:ListUsers"
      ],
      "Resource": ["*"]
    }
  ]
}
```

### 策略元素说明

- **Version**: 策略语言版本
- **Statement**: 权限声明数组
- **Effect**: 权限效果（Allow/Deny）
- **Action**: 允许或拒绝的操作
- **Resource**: 操作的资源范围

### 常用策略示例

#### 1. 管理员策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```

#### 2. 只读策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:ListUsers",
        "iam:GetPolicy",
        "iam:ListPolicies",
        "iam:GetApplication",
        "iam:ListApplications"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 3. 用户自管理策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:UpdateUser",
        "iam:CreateAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey",
        "iam:DeleteAccessKey"
      ],
      "Resource": "arn:iam::user/${aws:username}"
    }
  ]
}
```

#### 4. 应用管理策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateApplication",
        "iam:GetApplication",
        "iam:UpdateApplication",
        "iam:DeleteApplication",
        "iam:ListApplications"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🔑 API认证

### 使用访问密钥认证

在调用API时，需要使用访问密钥进行认证：

```bash
# 设置认证头
export ACCESS_KEY_ID="your_access_key_id"
export SECRET_ACCESS_KEY="your_secret_access_key"

# 使用认证调用API
grpcurl -plaintext \
  -H "Authorization: AWS4-HMAC-SHA256 Credential=$ACCESS_KEY_ID/..." \
  -d '{"name":"john_doe"}' \
  localhost:50051 iam.v1.IAM/GetUser
```

### 签名计算

VGO使用AWS Signature Version 4算法进行API签名验证。您可以使用官方SDK或自行实现签名算法。

## 📊 监控和日志

### 查看服务状态

```bash
# 检查服务健康状态
curl http://localhost:8080/health

# 查看Prometheus指标
curl http://localhost:9090/metrics
```

### 查看日志

```bash
# Docker Compose环境
docker-compose logs -f vgo-iam

# 直接运行
tail -f logs/iam.log
```

## 🔧 常用操作脚本

### 批量创建用户

```bash
#!/bin/bash

# 批量创建用户脚本
users=(
  "alice:Alice Smith:alice@example.com"
  "bob:Bob Johnson:bob@example.com"
  "charlie:Charlie Brown:charlie@example.com"
)

for user in "${users[@]}"; do
  IFS=':' read -r name display_name email <<< "$user"
  
  grpcurl -plaintext -d "{
    \"name\": \"$name\",
    \"display_name\": \"$display_name\",
    \"email\": \"$email\"
  }" localhost:50051 iam.v1.IAM/CreateUser
  
  echo "Created user: $name"
done
```

### 批量绑定策略

```bash
#!/bin/bash

# 批量绑定策略脚本
users=("alice" "bob" "charlie")
policy="read_only_policy"

for user in "${users[@]}"; do
  grpcurl -plaintext -d "{
    \"user_name\": \"$user\",
    \"policy_name\": \"$policy\"
  }" localhost:50051 iam.v1.IAM/AttachUserPolicy
  
  echo "Attached policy $policy to user: $user"
done
```

## 🚨 故障排除

### 常见错误

#### 1. 权限被拒绝

```
Error: permission denied
```

解决方案：
- 检查用户是否有相应权限
- 验证策略配置是否正确
- 确认访问密钥状态为active

#### 2. 用户不存在

```
Error: user not found
```

解决方案：
- 确认用户名拼写正确
- 检查用户是否已创建
- 验证数据库连接正常

#### 3. 策略语法错误

```
Error: invalid policy document
```

解决方案：
- 检查JSON语法是否正确
- 验证策略字段是否完整
- 使用策略验证工具检查

### 调试技巧

1. **启用调试日志**：
   ```yaml
   log:
     level: debug
   ```

2. **使用健康检查**：
   ```bash
   curl http://localhost:8080/health
   ```

3. **查看详细错误**：
   ```bash
   grpcurl -plaintext -v localhost:50051 list
   ```

## 📚 下一步

现在您已经了解了VGO的基本使用方法，可以继续学习：

- [API文档](/api/) - 详细的API接口说明
- [部署指南](/deployment/) - 生产环境部署
- [开发指南](/development/) - 参与项目开发

::: tip 提示
建议在开发环境中先熟悉各项功能，然后再部署到生产环境。
:::

::: warning 注意
在生产环境中使用时，请确保：
- 使用强密码和安全的访问密钥
- 定期轮换访问密钥
- 配置适当的权限策略
- 启用监控和日志记录
:::