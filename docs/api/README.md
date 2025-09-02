# API 文档

VGO微服务提供完整的gRPC API接口，支持用户管理、权限控制、应用管理等核心功能。本文档详细介绍了所有可用的API接口、参数说明和使用示例。

## 📋 API 概览

### 服务信息

- **服务名称**: `iam.v1.IAM`
- **协议**: gRPC
- **端口**: `50051`
- **认证方式**: AWS Signature Version 4
- **数据格式**: Protocol Buffers

### API 分类

| 分类 | 功能 | 接口数量 |
|------|------|----------|
| [用户管理](/api/user-management) | 用户CRUD操作 | 5个 |
| [策略管理](/api/policy-management) | 权限策略管理 | 6个 |
| [访问密钥](/api/access-keys) | API密钥管理 | 4个 |
| [应用管理](/api/applications) | OAuth2应用管理 | 5个 |
| [权限验证](/api/permissions) | 权限检查 | 1个 |
| [开发者认证](/api/developer-verification) | 开发者身份验证 | 4个 |

## 🚀 快速开始

### 1. 安装gRPC客户端工具

```bash
# 安装grpcurl
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# 或使用包管理器
brew install grpcurl  # macOS
sudo apt install grpcurl  # Ubuntu
```

### 2. 查看可用服务

```bash
# 列出所有服务
grpcurl -plaintext localhost:50051 list

# 查看IAM服务的方法
grpcurl -plaintext localhost:50051 list iam.v1.IAM
```

### 3. 查看方法详情

```bash
# 查看CreateUser方法的详细信息
grpcurl -plaintext localhost:50051 describe iam.v1.IAM.CreateUser
```

### 4. 调用API示例

```bash
# 创建用户
grpcurl -plaintext -d '{
  "name": "test_user",
  "display_name": "Test User",
  "email": "test@example.com"
}' localhost:50051 iam.v1.IAM/CreateUser
```

## 🔐 认证方式

### AWS Signature Version 4

VGO使用AWS Signature Version 4算法进行API认证。您需要：

1. **获取访问密钥**：通过管理界面或API创建访问密钥
2. **计算签名**：使用AWS SigV4算法计算请求签名
3. **添加认证头**：在请求中包含Authorization头

### 认证头格式

```
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20230101/us-east-1/iam/aws4_request, SignedHeaders=host;x-amz-date, Signature=calculated_signature
```

### 使用SDK

推荐使用官方SDK来处理签名计算：

```go
// Go SDK示例
import (
    "github.com/aws/aws-sdk-go/aws/credentials"
    "github.com/aws/aws-sdk-go/aws/signer/v4"
)

creds := credentials.NewStaticCredentials(accessKeyID, secretAccessKey, "")
signer := v4.NewSigner(creds)
```

## 📊 响应格式

### 成功响应

```json
{
  "user": {
    "id": "1",
    "name": "test_user",
    "display_name": "Test User",
    "email": "test@example.com",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

### 错误响应

```json
{
  "error": {
    "code": "INVALID_ARGUMENT",
    "message": "用户名不能为空",
    "details": [
      {
        "field": "name",
        "description": "name字段是必需的"
      }
    ]
  }
}
```

### 状态码说明

| 状态码 | 说明 | 示例场景 |
|--------|------|----------|
| `OK` | 请求成功 | 正常操作完成 |
| `INVALID_ARGUMENT` | 参数错误 | 缺少必需字段 |
| `NOT_FOUND` | 资源不存在 | 用户不存在 |
| `ALREADY_EXISTS` | 资源已存在 | 用户名重复 |
| `PERMISSION_DENIED` | 权限不足 | 无操作权限 |
| `UNAUTHENTICATED` | 认证失败 | 签名错误 |
| `INTERNAL` | 内部错误 | 服务器异常 |

## 🔄 分页和过滤

### 分页参数

大多数列表API支持分页：

```json
{
  "page": 1,
  "page_size": 20
}
```

### 分页响应

```json
{
  "users": [...],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_count": 100,
    "total_pages": 5
  }
}
```

### 过滤参数

支持的过滤条件：

```json
{
  "filter": {
    "status": "active",
    "created_after": "2024-01-01T00:00:00Z",
    "created_before": "2024-12-31T23:59:59Z"
  }
}
```

## 📝 数据类型

### 基础类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `string` | 字符串 | `"example"` |
| `int32` | 32位整数 | `123` |
| `int64` | 64位整数 | `1234567890` |
| `bool` | 布尔值 | `true` |
| `timestamp` | 时间戳 | `"2024-01-01T00:00:00Z"` |

### 枚举类型

#### UserStatus
```protobuf
enum UserStatus {
  USER_STATUS_UNSPECIFIED = 0;
  USER_STATUS_ACTIVE = 1;
  USER_STATUS_INACTIVE = 2;
  USER_STATUS_SUSPENDED = 3;
}
```

#### AccessKeyStatus
```protobuf
enum AccessKeyStatus {
  ACCESS_KEY_STATUS_UNSPECIFIED = 0;
  ACCESS_KEY_STATUS_ACTIVE = 1;
  ACCESS_KEY_STATUS_INACTIVE = 2;
}
```

#### ApplicationType
```protobuf
enum ApplicationType {
  APPLICATION_TYPE_UNSPECIFIED = 0;
  APPLICATION_TYPE_WEB = 1;
  APPLICATION_TYPE_MOBILE = 2;
  APPLICATION_TYPE_API = 3;
  APPLICATION_TYPE_SPA = 4;
}
```

#### ApplicationStatus
```protobuf
enum ApplicationStatus {
  APPLICATION_STATUS_UNSPECIFIED = 0;
  APPLICATION_STATUS_ACTIVE = 1;
  APPLICATION_STATUS_INACTIVE = 2;
  APPLICATION_STATUS_SUSPENDED = 3;
}
```

## 🛠️ 开发工具

### Protocol Buffers定义

完整的protobuf定义文件：

```protobuf
syntax = "proto3";

package iam.v1;

option go_package = "github.com/your-org/vgo/api/iam/v1";

// IAM服务定义
service IAM {
  // 用户管理
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc UpdateUser(UpdateUserRequest) returns (UpdateUserResponse);
  rpc DeleteUser(DeleteUserRequest) returns (DeleteUserResponse);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
  
  // 策略管理
  rpc CreatePolicy(CreatePolicyRequest) returns (CreatePolicyResponse);
  rpc GetPolicy(GetPolicyRequest) returns (GetPolicyResponse);
  rpc UpdatePolicy(UpdatePolicyRequest) returns (UpdatePolicyResponse);
  rpc DeletePolicy(DeletePolicyRequest) returns (DeletePolicyResponse);
  rpc ListPolicies(ListPoliciesRequest) returns (ListPoliciesResponse);
  rpc AttachUserPolicy(AttachUserPolicyRequest) returns (AttachUserPolicyResponse);
  rpc DetachUserPolicy(DetachUserPolicyRequest) returns (DetachUserPolicyResponse);
  
  // 访问密钥管理
  rpc CreateAccessKey(CreateAccessKeyRequest) returns (CreateAccessKeyResponse);
  rpc ListAccessKeys(ListAccessKeysRequest) returns (ListAccessKeysResponse);
  rpc UpdateAccessKey(UpdateAccessKeyRequest) returns (UpdateAccessKeyResponse);
  rpc DeleteAccessKey(DeleteAccessKeyRequest) returns (DeleteAccessKeyResponse);
  
  // 应用管理
  rpc CreateApplication(CreateApplicationRequest) returns (CreateApplicationResponse);
  rpc GetApplication(GetApplicationRequest) returns (GetApplicationResponse);
  rpc UpdateApplication(UpdateApplicationRequest) returns (UpdateApplicationResponse);
  rpc DeleteApplication(DeleteApplicationRequest) returns (DeleteApplicationResponse);
  rpc ListApplications(ListApplicationsRequest) returns (ListApplicationsResponse);
  
  // 权限验证
  rpc CheckPermission(CheckPermissionRequest) returns (CheckPermissionResponse);
  
  // 开发者认证
  rpc CreateDeveloperVerification(CreateDeveloperVerificationRequest) returns (CreateDeveloperVerificationResponse);
  rpc GetDeveloperVerification(GetDeveloperVerificationRequest) returns (GetDeveloperVerificationResponse);
  rpc UpdateDeveloperVerification(UpdateDeveloperVerificationRequest) returns (UpdateDeveloperVerificationResponse);
  rpc ListDeveloperVerifications(ListDeveloperVerificationsRequest) returns (ListDeveloperVerificationsResponse);
}
```

### 客户端SDK

#### Go客户端

```go
package main

import (
    "context"
    "log"
    
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
    
    iamv1 "github.com/your-org/vgo/api/iam/v1"
)

func main() {
    // 连接到gRPC服务
    conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        log.Fatalf("连接失败: %v", err)
    }
    defer conn.Close()
    
    // 创建客户端
    client := iamv1.NewIAMClient(conn)
    
    // 调用API
    resp, err := client.CreateUser(context.Background(), &iamv1.CreateUserRequest{
        Name:        "test_user",
        DisplayName: "Test User",
        Email:       "test@example.com",
    })
    if err != nil {
        log.Fatalf("创建用户失败: %v", err)
    }
    
    log.Printf("用户创建成功: %v", resp.User)
}
```

#### Python客户端

```python
import grpc
from iam.v1 import iam_pb2
from iam.v1 import iam_pb2_grpc

def main():
    # 连接到gRPC服务
    with grpc.insecure_channel('localhost:50051') as channel:
        # 创建客户端
        stub = iam_pb2_grpc.IAMStub(channel)
        
        # 调用API
        request = iam_pb2.CreateUserRequest(
            name='test_user',
            display_name='Test User',
            email='test@example.com'
        )
        
        response = stub.CreateUser(request)
        print(f'用户创建成功: {response.user}')

if __name__ == '__main__':
    main()
```

## 📚 详细文档

点击以下链接查看各模块的详细API文档：

- [用户管理API](/api/user-management) - 用户的创建、查询、更新、删除操作
- [策略管理API](/api/policy-management) - 权限策略的管理和绑定
- [访问密钥API](/api/access-keys) - API访问密钥的生命周期管理
- [应用管理API](/api/applications) - OAuth2应用的注册和管理
- [权限验证API](/api/permissions) - 权限检查和验证
- [开发者认证API](/api/developer-verification) - 开发者身份验证流程

## 🔧 测试工具

### Postman集合

我们提供了完整的Postman集合，包含所有API的示例请求：

```json
{
  "info": {
    "name": "VGO IAM API",
    "description": "VGO微服务IAM API集合"
  },
  "item": [
    {
      "name": "用户管理",
      "item": [
        {
          "name": "创建用户",
          "request": {
            "method": "POST",
            "header": [],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"test_user\",\n  \"display_name\": \"Test User\",\n  \"email\": \"test@example.com\"\n}"
            },
            "url": {
              "raw": "{{base_url}}/iam.v1.IAM/CreateUser",
              "host": ["{{base_url}}"],
              "path": ["iam.v1.IAM", "CreateUser"]
            }
          }
        }
      ]
    }
  ]
}
```

### 自动化测试

```bash
#!/bin/bash

# API测试脚本
BASE_URL="localhost:50051"

# 测试创建用户
echo "测试创建用户..."
grpcurl -plaintext -d '{
  "name": "test_user",
  "display_name": "Test User",
  "email": "test@example.com"
}' $BASE_URL iam.v1.IAM/CreateUser

# 测试获取用户
echo "测试获取用户..."
grpcurl -plaintext -d '{
  "name": "test_user"
}' $BASE_URL iam.v1.IAM/GetUser

# 测试删除用户
echo "测试删除用户..."
grpcurl -plaintext -d '{
  "name": "test_user"
}' $BASE_URL iam.v1.IAM/DeleteUser

echo "测试完成"
```

## 🚨 错误处理

### 错误码对照表

| 错误码 | HTTP状态码 | 说明 | 解决方案 |
|--------|------------|------|----------|
| `OK` | 200 | 成功 | - |
| `INVALID_ARGUMENT` | 400 | 参数错误 | 检查请求参数 |
| `UNAUTHENTICATED` | 401 | 认证失败 | 检查访问密钥 |
| `PERMISSION_DENIED` | 403 | 权限不足 | 检查用户权限 |
| `NOT_FOUND` | 404 | 资源不存在 | 确认资源ID |
| `ALREADY_EXISTS` | 409 | 资源已存在 | 使用不同的标识符 |
| `INTERNAL` | 500 | 内部错误 | 联系技术支持 |
| `UNAVAILABLE` | 503 | 服务不可用 | 稍后重试 |

### 重试策略

```go
// 指数退避重试
func retryWithBackoff(fn func() error, maxRetries int) error {
    for i := 0; i < maxRetries; i++ {
        if err := fn(); err == nil {
            return nil
        }
        
        // 指数退避
        time.Sleep(time.Duration(math.Pow(2, float64(i))) * time.Second)
    }
    return fmt.Errorf("达到最大重试次数")
}
```

## 📈 性能优化

### 连接池

```go
// gRPC连接池
type ConnectionPool struct {
    connections []*grpc.ClientConn
    current     int
    mutex       sync.Mutex
}

func (p *ConnectionPool) GetConnection() *grpc.ClientConn {
    p.mutex.Lock()
    defer p.mutex.Unlock()
    
    conn := p.connections[p.current]
    p.current = (p.current + 1) % len(p.connections)
    return conn
}
```

### 批量操作

```bash
# 批量创建用户
grpcurl -plaintext -d '{
  "users": [
    {"name": "user1", "email": "user1@example.com"},
    {"name": "user2", "email": "user2@example.com"},
    {"name": "user3", "email": "user3@example.com"}
  ]
}' localhost:50051 iam.v1.IAM/BatchCreateUsers
```

## 🔍 监控和调试

### 启用gRPC日志

```bash
# 设置gRPC日志级别
export GRPC_GO_LOG_VERBOSITY_LEVEL=99
export GRPC_GO_LOG_SEVERITY_LEVEL=info
```

### 使用gRPC反射

```bash
# 启用反射后可以动态发现服务
grpcurl -plaintext localhost:50051 list
grpcurl -plaintext localhost:50051 describe iam.v1.IAM
```

### 性能指标

```bash
# 查看gRPC指标
curl http://localhost:9090/metrics | grep grpc
```

---

::: tip 提示
建议在开发过程中使用grpcurl进行API测试，在生产环境中使用官方SDK。
:::

::: warning 注意
- 所有API调用都需要正确的认证
- 注意API的速率限制
- 生产环境请使用TLS加密
:::