# 用户管理 API

用户管理API提供了完整的用户生命周期管理功能，包括用户的创建、查询、更新、删除和列表操作。

## 📋 API 概览

| 方法 | 描述 | 权限要求 |
|------|------|----------|
| `CreateUser` | 创建新用户 | `iam:CreateUser` |
| `GetUser` | 获取用户信息 | `iam:GetUser` |
| `UpdateUser` | 更新用户信息 | `iam:UpdateUser` |
| `DeleteUser` | 删除用户 | `iam:DeleteUser` |
| `ListUsers` | 获取用户列表 | `iam:ListUsers` |

## 🔧 API 详情

### CreateUser - 创建用户

创建一个新的用户账户。

#### 请求

```protobuf
message CreateUserRequest {
  string name = 1;          // 用户名（必需，唯一）
  string display_name = 2;  // 显示名称（必需）
  string email = 3;         // 邮箱地址（必需，唯一）
  string password = 4;      // 密码（可选，如果不提供将生成随机密码）
  UserStatus status = 5;    // 用户状态（可选，默认为ACTIVE）
}
```

#### 响应

```protobuf
message CreateUserResponse {
  User user = 1;           // 创建的用户信息
  string password = 2;     // 生成的密码（如果未提供密码）
}
```

#### 示例

```bash
# 创建用户（提供密码）
grpcurl -plaintext -d '{
  "name": "john_doe",
  "display_name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePassword123!"
}' localhost:50051 iam.v1.IAM/CreateUser
```

```bash
# 创建用户（自动生成密码）
grpcurl -plaintext -d '{
  "name": "jane_smith",
  "display_name": "Jane Smith",
  "email": "jane@example.com"
}' localhost:50051 iam.v1.IAM/CreateUser
```

#### 响应示例

```json
{
  "user": {
    "id": "123",
    "name": "john_doe",
    "display_name": "John Doe",
    "email": "john@example.com",
    "status": "USER_STATUS_ACTIVE",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 用户名或邮箱为空 | 提供有效的用户名和邮箱 |
| `ALREADY_EXISTS` | 用户名或邮箱已存在 | 使用不同的用户名或邮箱 |
| `PERMISSION_DENIED` | 无创建用户权限 | 确保有`iam:CreateUser`权限 |

---

### GetUser - 获取用户信息

根据用户名或用户ID获取用户详细信息。

#### 请求

```protobuf
message GetUserRequest {
  oneof identifier {
    string name = 1;    // 用户名
    string id = 2;      // 用户ID
  }
}
```

#### 响应

```protobuf
message GetUserResponse {
  User user = 1;        // 用户信息
}
```

#### 示例

```bash
# 通过用户名获取
grpcurl -plaintext -d '{
  "name": "john_doe"
}' localhost:50051 iam.v1.IAM/GetUser
```

```bash
# 通过用户ID获取
grpcurl -plaintext -d '{
  "id": "123"
}' localhost:50051 iam.v1.IAM/GetUser
```

#### 响应示例

```json
{
  "user": {
    "id": "123",
    "name": "john_doe",
    "display_name": "John Doe",
    "email": "john@example.com",
    "status": "USER_STATUS_ACTIVE",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "last_login_at": "2024-01-15T10:30:00Z"
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 未提供用户名或ID | 提供有效的标识符 |
| `NOT_FOUND` | 用户不存在 | 确认用户名或ID正确 |
| `PERMISSION_DENIED` | 无查看用户权限 | 确保有`iam:GetUser`权限 |

---

### UpdateUser - 更新用户信息

更新现有用户的信息。

#### 请求

```protobuf
message UpdateUserRequest {
  oneof identifier {
    string name = 1;          // 用户名
    string id = 2;            // 用户ID
  }
  string display_name = 3;    // 新的显示名称（可选）
  string email = 4;           // 新的邮箱地址（可选）
  string password = 5;        // 新密码（可选）
  UserStatus status = 6;      // 新状态（可选）
  google.protobuf.FieldMask update_mask = 7;  // 更新字段掩码
}
```

#### 响应

```protobuf
message UpdateUserResponse {
  User user = 1;              // 更新后的用户信息
}
```

#### 示例

```bash
# 更新显示名称和邮箱
grpcurl -plaintext -d '{
  "name": "john_doe",
  "display_name": "John Smith",
  "email": "john.smith@example.com",
  "update_mask": {
    "paths": ["display_name", "email"]
  }
}' localhost:50051 iam.v1.IAM/UpdateUser
```

```bash
# 更新用户状态
grpcurl -plaintext -d '{
  "id": "123",
  "status": "USER_STATUS_SUSPENDED",
  "update_mask": {
    "paths": ["status"]
  }
}' localhost:50051 iam.v1.IAM/UpdateUser
```

```bash
# 重置密码
grpcurl -plaintext -d '{
  "name": "john_doe",
  "password": "NewSecurePassword456!",
  "update_mask": {
    "paths": ["password"]
  }
}' localhost:50051 iam.v1.IAM/UpdateUser
```

#### 响应示例

```json
{
  "user": {
    "id": "123",
    "name": "john_doe",
    "display_name": "John Smith",
    "email": "john.smith@example.com",
    "status": "USER_STATUS_ACTIVE",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-15T14:30:00Z"
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 无效的更新字段 | 检查update_mask和字段值 |
| `NOT_FOUND` | 用户不存在 | 确认用户标识符正确 |
| `ALREADY_EXISTS` | 邮箱已被其他用户使用 | 使用不同的邮箱地址 |
| `PERMISSION_DENIED` | 无更新用户权限 | 确保有`iam:UpdateUser`权限 |

---

### DeleteUser - 删除用户

删除指定的用户账户。

::: warning 注意
删除用户是不可逆操作，会同时删除用户的所有关联数据（访问密钥、策略绑定等）。
:::

#### 请求

```protobuf
message DeleteUserRequest {
  oneof identifier {
    string name = 1;    // 用户名
    string id = 2;      // 用户ID
  }
  bool force = 3;       // 强制删除（即使有关联资源）
}
```

#### 响应

```protobuf
message DeleteUserResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 删除用户
grpcurl -plaintext -d '{
  "name": "john_doe"
}' localhost:50051 iam.v1.IAM/DeleteUser
```

```bash
# 强制删除用户（包括关联资源）
grpcurl -plaintext -d '{
  "id": "123",
  "force": true
}' localhost:50051 iam.v1.IAM/DeleteUser
```

#### 响应示例

```json
{}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 未提供用户标识符 | 提供用户名或ID |
| `NOT_FOUND` | 用户不存在 | 确认用户标识符正确 |
| `FAILED_PRECONDITION` | 用户有关联资源且未设置force | 设置force=true或先删除关联资源 |
| `PERMISSION_DENIED` | 无删除用户权限 | 确保有`iam:DeleteUser`权限 |

---

### ListUsers - 获取用户列表

获取系统中的用户列表，支持分页和过滤。

#### 请求

```protobuf
message ListUsersRequest {
  int32 page = 1;           // 页码（从1开始）
  int32 page_size = 2;      // 每页大小（最大100）
  string filter = 3;        // 过滤条件
  string order_by = 4;      // 排序字段
  bool desc = 5;            // 是否降序
}
```

#### 过滤条件

支持的过滤字段：
- `status`: 用户状态（active, inactive, suspended）
- `email`: 邮箱地址（支持模糊匹配）
- `name`: 用户名（支持模糊匹配）
- `created_after`: 创建时间之后
- `created_before`: 创建时间之前

#### 排序字段

支持的排序字段：
- `name`: 用户名
- `email`: 邮箱
- `created_at`: 创建时间
- `updated_at`: 更新时间
- `last_login_at`: 最后登录时间

#### 响应

```protobuf
message ListUsersResponse {
  repeated User users = 1;      // 用户列表
  Pagination pagination = 2;    // 分页信息
}

message Pagination {
  int32 page = 1;              // 当前页码
  int32 page_size = 2;         // 每页大小
  int32 total_count = 3;       // 总记录数
  int32 total_pages = 4;       // 总页数
}
```

#### 示例

```bash
# 获取第一页用户（默认20条）
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 20
}' localhost:50051 iam.v1.IAM/ListUsers
```

```bash
# 获取活跃用户
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10,
  "filter": "status=active"
}' localhost:50051 iam.v1.IAM/ListUsers
```

```bash
# 按创建时间降序排列
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10,
  "order_by": "created_at",
  "desc": true
}' localhost:50051 iam.v1.IAM/ListUsers
```

```bash
# 复合过滤条件
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10,
  "filter": "status=active AND email LIKE %@example.com AND created_after=2024-01-01T00:00:00Z"
}' localhost:50051 iam.v1.IAM/ListUsers
```

#### 响应示例

```json
{
  "users": [
    {
      "id": "123",
      "name": "john_doe",
      "display_name": "John Doe",
      "email": "john@example.com",
      "status": "USER_STATUS_ACTIVE",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "last_login_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": "124",
      "name": "jane_smith",
      "display_name": "Jane Smith",
      "email": "jane@example.com",
      "status": "USER_STATUS_ACTIVE",
      "created_at": "2024-01-02T00:00:00Z",
      "updated_at": "2024-01-02T00:00:00Z",
      "last_login_at": "2024-01-14T15:45:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_count": 150,
    "total_pages": 8
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 无效的分页参数 | 检查page和page_size值 |
| `INVALID_ARGUMENT` | 无效的过滤条件 | 检查filter语法 |
| `PERMISSION_DENIED` | 无列表用户权限 | 确保有`iam:ListUsers`权限 |

## 📊 数据模型

### User 对象

```protobuf
message User {
  string id = 1;                    // 用户ID（系统生成）
  string name = 2;                  // 用户名（唯一）
  string display_name = 3;          // 显示名称
  string email = 4;                 // 邮箱地址（唯一）
  UserStatus status = 5;            // 用户状态
  google.protobuf.Timestamp created_at = 6;     // 创建时间
  google.protobuf.Timestamp updated_at = 7;     // 更新时间
  google.protobuf.Timestamp last_login_at = 8;  // 最后登录时间
  map<string, string> metadata = 9; // 用户元数据
}
```

### UserStatus 枚举

```protobuf
enum UserStatus {
  USER_STATUS_UNSPECIFIED = 0;  // 未指定
  USER_STATUS_ACTIVE = 1;       // 活跃
  USER_STATUS_INACTIVE = 2;     // 非活跃
  USER_STATUS_SUSPENDED = 3;    // 已暂停
}
```

## 🔐 权限要求

### 所需权限

| 操作 | 权限 | 资源 |
|------|------|------|
| 创建用户 | `iam:CreateUser` | `*` |
| 获取用户 | `iam:GetUser` | `arn:iam::user/*` 或 `arn:iam::user/${aws:username}` |
| 更新用户 | `iam:UpdateUser` | `arn:iam::user/*` 或 `arn:iam::user/${aws:username}` |
| 删除用户 | `iam:DeleteUser` | `arn:iam::user/*` |
| 列表用户 | `iam:ListUsers` | `*` |

### 策略示例

#### 管理员策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateUser",
        "iam:GetUser",
        "iam:UpdateUser",
        "iam:DeleteUser",
        "iam:ListUsers"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 用户自管理策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "iam:UpdateUser"
      ],
      "Resource": "arn:iam::user/${aws:username}"
    }
  ]
}
```

#### 只读策略

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
      "Resource": "*"
    }
  ]
}
```

## 🛠️ 使用示例

### Go 客户端示例

```go
package main

import (
    "context"
    "fmt"
    "log"
    
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
    "google.golang.org/protobuf/types/known/fieldmaskpb"
    
    iamv1 "github.com/your-org/vgo/api/iam/v1"
)

func main() {
    // 连接到服务
    conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        log.Fatalf("连接失败: %v", err)
    }
    defer conn.Close()
    
    client := iamv1.NewIAMClient(conn)
    ctx := context.Background()
    
    // 创建用户
    createResp, err := client.CreateUser(ctx, &iamv1.CreateUserRequest{
        Name:        "test_user",
        DisplayName: "Test User",
        Email:       "test@example.com",
        Password:    "SecurePassword123!",
    })
    if err != nil {
        log.Fatalf("创建用户失败: %v", err)
    }
    fmt.Printf("用户创建成功: %v\n", createResp.User)
    
    // 获取用户
    getResp, err := client.GetUser(ctx, &iamv1.GetUserRequest{
        Identifier: &iamv1.GetUserRequest_Name{Name: "test_user"},
    })
    if err != nil {
        log.Fatalf("获取用户失败: %v", err)
    }
    fmt.Printf("用户信息: %v\n", getResp.User)
    
    // 更新用户
    updateResp, err := client.UpdateUser(ctx, &iamv1.UpdateUserRequest{
        Identifier:  &iamv1.UpdateUserRequest_Name{Name: "test_user"},
        DisplayName: "Updated Test User",
        UpdateMask: &fieldmaskpb.FieldMask{
            Paths: []string{"display_name"},
        },
    })
    if err != nil {
        log.Fatalf("更新用户失败: %v", err)
    }
    fmt.Printf("用户更新成功: %v\n", updateResp.User)
    
    // 获取用户列表
    listResp, err := client.ListUsers(ctx, &iamv1.ListUsersRequest{
        Page:     1,
        PageSize: 10,
        Filter:   "status=active",
    })
    if err != nil {
        log.Fatalf("获取用户列表失败: %v", err)
    }
    fmt.Printf("用户列表: %v\n", listResp.Users)
    fmt.Printf("分页信息: %v\n", listResp.Pagination)
    
    // 删除用户
    _, err = client.DeleteUser(ctx, &iamv1.DeleteUserRequest{
        Identifier: &iamv1.DeleteUserRequest_Name{Name: "test_user"},
    })
    if err != nil {
        log.Fatalf("删除用户失败: %v", err)
    }
    fmt.Println("用户删除成功")
}
```

### Python 客户端示例

```python
import grpc
from google.protobuf import field_mask_pb2
from iam.v1 import iam_pb2
from iam.v1 import iam_pb2_grpc

def main():
    # 连接到服务
    with grpc.insecure_channel('localhost:50051') as channel:
        client = iam_pb2_grpc.IAMStub(channel)
        
        # 创建用户
        create_request = iam_pb2.CreateUserRequest(
            name='test_user',
            display_name='Test User',
            email='test@example.com',
            password='SecurePassword123!'
        )
        create_response = client.CreateUser(create_request)
        print(f'用户创建成功: {create_response.user}')
        
        # 获取用户
        get_request = iam_pb2.GetUserRequest(name='test_user')
        get_response = client.GetUser(get_request)
        print(f'用户信息: {get_response.user}')
        
        # 更新用户
        update_mask = field_mask_pb2.FieldMask(paths=['display_name'])
        update_request = iam_pb2.UpdateUserRequest(
            name='test_user',
            display_name='Updated Test User',
            update_mask=update_mask
        )
        update_response = client.UpdateUser(update_request)
        print(f'用户更新成功: {update_response.user}')
        
        # 获取用户列表
        list_request = iam_pb2.ListUsersRequest(
            page=1,
            page_size=10,
            filter='status=active'
        )
        list_response = client.ListUsers(list_request)
        print(f'用户列表: {list_response.users}')
        print(f'分页信息: {list_response.pagination}')
        
        # 删除用户
        delete_request = iam_pb2.DeleteUserRequest(name='test_user')
        client.DeleteUser(delete_request)
        print('用户删除成功')

if __name__ == '__main__':
    main()
```

## 🔍 最佳实践

### 1. 用户名规范

- 使用小写字母、数字和下划线
- 长度在3-32个字符之间
- 避免使用保留词（admin、root、system等）

```bash
# 好的用户名示例
"john_doe"
"user_123"
"service_account"

# 避免的用户名
"Admin"
"root"
"123"
```

### 2. 密码策略

- 最少8个字符
- 包含大小写字母、数字和特殊字符
- 定期更换密码

### 3. 邮箱验证

```bash
# 创建用户后发送验证邮件
grpcurl -plaintext -d '{
  "name": "new_user",
  "display_name": "New User",
  "email": "new@example.com",
  "status": "USER_STATUS_INACTIVE"
}' localhost:50051 iam.v1.IAM/CreateUser
```

### 4. 批量操作

```bash
#!/bin/bash

# 批量创建用户脚本
users_file="users.txt"

while IFS=',' read -r name display_name email; do
    grpcurl -plaintext -d "{
        \"name\": \"$name\",
        \"display_name\": \"$display_name\",
        \"email\": \"$email\"
    }" localhost:50051 iam.v1.IAM/CreateUser
    
    echo "Created user: $name"
    sleep 0.1  # 避免过快请求
done < "$users_file"
```

### 5. 错误处理

```go
// 带重试的用户创建
func createUserWithRetry(client iamv1.IAMClient, req *iamv1.CreateUserRequest, maxRetries int) (*iamv1.CreateUserResponse, error) {
    for i := 0; i < maxRetries; i++ {
        resp, err := client.CreateUser(context.Background(), req)
        if err == nil {
            return resp, nil
        }
        
        // 检查是否为可重试错误
        if status.Code(err) == codes.AlreadyExists {
            return nil, err // 不重试
        }
        
        time.Sleep(time.Duration(i+1) * time.Second)
    }
    return nil, fmt.Errorf("达到最大重试次数")
}
```

## 🚨 注意事项

### 安全考虑

1. **密码安全**：
   - 不要在日志中记录密码
   - 使用强密码策略
   - 定期轮换密码

2. **权限控制**：
   - 遵循最小权限原则
   - 定期审查用户权限
   - 使用资源级权限控制

3. **数据保护**：
   - 敏感信息加密存储
   - 审计用户操作
   - 定期备份用户数据

### 性能优化

1. **分页查询**：
   - 使用合适的页面大小
   - 避免查询过大的数据集
   - 使用索引优化查询

2. **缓存策略**：
   - 缓存频繁访问的用户信息
   - 设置合适的缓存过期时间
   - 及时更新缓存

3. **连接管理**：
   - 使用连接池
   - 设置合适的超时时间
   - 处理连接异常

---

::: tip 提示
建议在生产环境中启用用户操作审计，记录所有用户管理操作的详细日志。
:::

::: warning 注意
删除用户操作不可逆，请谨慎操作。建议先将用户状态设置为SUSPENDED，确认无影响后再删除。
:::