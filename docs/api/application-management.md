# 应用管理 API

应用管理API提供了完整的应用生命周期管理功能，包括应用的创建、查询、更新和删除操作。应用是VGO系统中的重要概念，用于组织和管理相关的用户、策略和访问密钥。

## 📋 API 概览

| 方法 | 描述 | 权限要求 |
|------|------|----------|
| `CreateApplication` | 创建应用 | `iam:CreateApplication` |
| `GetApplication` | 获取应用详情 | `iam:GetApplication` |
| `UpdateApplication` | 更新应用信息 | `iam:UpdateApplication` |
| `DeleteApplication` | 删除应用 | `iam:DeleteApplication` |
| `ListApplications` | 获取应用列表 | `iam:ListApplications` |

## 🔧 API 详情

### CreateApplication - 创建应用

创建一个新的应用实例。

#### 请求

```protobuf
message CreateApplicationRequest {
  string name = 1;              // 应用名称（必需，唯一）
  string description = 2;       // 应用描述（可选）
  string homepage_url = 3;      // 主页URL（可选）
  string callback_url = 4;      // 回调URL（可选）
  ApplicationType type = 5;     // 应用类型（必需）
  repeated string scopes = 6;   // 权限范围（可选）
}
```

#### 响应

```protobuf
message CreateApplicationResponse {
  Application application = 1;   // 创建的应用信息
}
```

#### 示例

```bash
# 创建Web应用
grpcurl -plaintext -d '{
  "name": "my-web-app",
  "description": "我的Web应用",
  "homepage_url": "https://example.com",
  "callback_url": "https://example.com/callback",
  "type": "APPLICATION_TYPE_WEB",
  "scopes": ["read", "write"]
}' localhost:50051 iam.v1.IAM/CreateApplication
```

```bash
# 创建移动应用
grpcurl -plaintext -d '{
  "name": "my-mobile-app",
  "description": "我的移动应用",
  "type": "APPLICATION_TYPE_MOBILE",
  "scopes": ["read", "write", "offline_access"]
}' localhost:50051 iam.v1.IAM/CreateApplication
```

#### 响应示例

```json
{
  "application": {
    "id": "app-123456",
    "name": "my-web-app",
    "description": "我的Web应用",
    "homepage_url": "https://example.com",
    "callback_url": "https://example.com/callback",
    "type": "APPLICATION_TYPE_WEB",
    "status": "APPLICATION_STATUS_ACTIVE",
    "scopes": ["read", "write"],
    "client_id": "client_1234567890abcdef",
    "client_secret": "secret_abcdef1234567890",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

::: warning 重要提示
`client_secret` 只在创建时返回一次，请妥善保存。后续无法再次获取。
:::

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `ALREADY_EXISTS` | 应用名称已存在 | 使用不同的应用名称 |
| `INVALID_ARGUMENT` | 无效的URL格式 | 检查URL格式是否正确 |
| `INVALID_ARGUMENT` | 无效的应用类型 | 使用有效的应用类型 |
| `PERMISSION_DENIED` | 无创建应用权限 | 确保有`iam:CreateApplication`权限 |

---

### GetApplication - 获取应用详情

根据应用ID或名称获取应用的详细信息。

#### 请求

```protobuf
message GetApplicationRequest {
  oneof identifier {
    string id = 1;              // 应用ID
    string name = 2;            // 应用名称
  }
}
```

#### 响应

```protobuf
message GetApplicationResponse {
  Application application = 1;   // 应用信息
}
```

#### 示例

```bash
# 通过ID获取应用
grpcurl -plaintext -d '{
  "id": "app-123456"
}' localhost:50051 iam.v1.IAM/GetApplication
```

```bash
# 通过名称获取应用
grpcurl -plaintext -d '{
  "name": "my-web-app"
}' localhost:50051 iam.v1.IAM/GetApplication
```

#### 响应示例

```json
{
  "application": {
    "id": "app-123456",
    "name": "my-web-app",
    "description": "我的Web应用",
    "homepage_url": "https://example.com",
    "callback_url": "https://example.com/callback",
    "type": "APPLICATION_TYPE_WEB",
    "status": "APPLICATION_STATUS_ACTIVE",
    "scopes": ["read", "write"],
    "client_id": "client_1234567890abcdef",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "last_used_at": "2024-01-15T10:30:00Z",
    "user_count": 150,
    "access_key_count": 5
  }
}
```

::: tip 提示
出于安全考虑，获取接口不返回 `client_secret` 字段。
:::

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 应用不存在 | 确认应用ID或名称正确 |
| `INVALID_ARGUMENT` | 缺少标识符 | 提供应用ID或名称 |
| `PERMISSION_DENIED` | 无查看应用权限 | 确保有`iam:GetApplication`权限 |

---

### UpdateApplication - 更新应用信息

更新应用的基本信息、状态或配置。

#### 请求

```protobuf
message UpdateApplicationRequest {
  string id = 1;                        // 应用ID（必需）
  string name = 2;                      // 新名称（可选）
  string description = 3;               // 新描述（可选）
  string homepage_url = 4;              // 新主页URL（可选）
  string callback_url = 5;              // 新回调URL（可选）
  ApplicationStatus status = 6;         // 新状态（可选）
  repeated string scopes = 7;           // 新权限范围（可选）
  google.protobuf.FieldMask update_mask = 8;  // 更新字段掩码
}
```

#### 响应

```protobuf
message UpdateApplicationResponse {
  Application application = 1;          // 更新后的应用信息
}
```

#### 示例

```bash
# 更新应用描述
grpcurl -plaintext -d '{
  "id": "app-123456",
  "description": "更新后的应用描述",
  "update_mask": {
    "paths": ["description"]
  }
}' localhost:50051 iam.v1.IAM/UpdateApplication
```

```bash
# 禁用应用
grpcurl -plaintext -d '{
  "id": "app-123456",
  "status": "APPLICATION_STATUS_INACTIVE",
  "update_mask": {
    "paths": ["status"]
  }
}' localhost:50051 iam.v1.IAM/UpdateApplication
```

```bash
# 更新多个字段
grpcurl -plaintext -d '{
  "id": "app-123456",
  "description": "全新的应用描述",
  "homepage_url": "https://newdomain.com",
  "scopes": ["read", "write", "admin"],
  "update_mask": {
    "paths": ["description", "homepage_url", "scopes"]
  }
}' localhost:50051 iam.v1.IAM/UpdateApplication
```

#### 响应示例

```json
{
  "application": {
    "id": "app-123456",
    "name": "my-web-app",
    "description": "更新后的应用描述",
    "homepage_url": "https://newdomain.com",
    "callback_url": "https://example.com/callback",
    "type": "APPLICATION_TYPE_WEB",
    "status": "APPLICATION_STATUS_ACTIVE",
    "scopes": ["read", "write", "admin"],
    "client_id": "client_1234567890abcdef",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-15T14:30:00Z",
    "last_used_at": "2024-01-15T10:30:00Z",
    "user_count": 150,
    "access_key_count": 5
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 应用不存在 | 确认应用ID正确 |
| `ALREADY_EXISTS` | 新名称已被使用 | 使用不同的应用名称 |
| `INVALID_ARGUMENT` | 无效的URL格式 | 检查URL格式是否正确 |
| `PERMISSION_DENIED` | 无更新应用权限 | 确保有`iam:UpdateApplication`权限 |

---

### DeleteApplication - 删除应用

删除指定的应用。

::: warning 注意
删除应用是不可逆操作，会同时删除关联的访问密钥和用户绑定关系。
:::

#### 请求

```protobuf
message DeleteApplicationRequest {
  string id = 1;                // 应用ID（必需）
  bool force = 2;               // 强制删除（可选，默认false）
}
```

#### 响应

```protobuf
message DeleteApplicationResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 删除应用（如果有关联资源会失败）
grpcurl -plaintext -d '{
  "id": "app-123456"
}' localhost:50051 iam.v1.IAM/DeleteApplication
```

```bash
# 强制删除应用（删除所有关联资源）
grpcurl -plaintext -d '{
  "id": "app-123456",
  "force": true
}' localhost:50051 iam.v1.IAM/DeleteApplication
```

#### 响应示例

```json
{}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 应用不存在 | 确认应用ID正确 |
| `FAILED_PRECONDITION` | 应用有关联资源 | 先删除关联资源或使用force=true |
| `PERMISSION_DENIED` | 无删除应用权限 | 确保有`iam:DeleteApplication`权限 |

---

### ListApplications - 获取应用列表

获取应用列表，支持分页和过滤。

#### 请求

```protobuf
message ListApplicationsRequest {
  ApplicationType type = 1;     // 应用类型过滤（可选）
  ApplicationStatus status = 2; // 应用状态过滤（可选）
  string name_filter = 3;       // 名称过滤（支持模糊匹配）
  int32 page = 4;              // 页码（从1开始）
  int32 page_size = 5;         // 每页大小（最大100）
  string sort_by = 6;          // 排序字段（name, created_at, updated_at）
  bool sort_desc = 7;          // 是否降序排列
}
```

#### 响应

```protobuf
message ListApplicationsResponse {
  repeated Application applications = 1;  // 应用列表
  Pagination pagination = 2;              // 分页信息
}
```

#### 示例

```bash
# 获取所有应用
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListApplications
```

```bash
# 获取Web应用
grpcurl -plaintext -d '{
  "type": "APPLICATION_TYPE_WEB",
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListApplications
```

```bash
# 搜索应用名称包含"api"的应用
grpcurl -plaintext -d '{
  "name_filter": "api",
  "sort_by": "created_at",
  "sort_desc": true,
  "page": 1,
  "page_size": 20
}' localhost:50051 iam.v1.IAM/ListApplications
```

#### 响应示例

```json
{
  "applications": [
    {
      "id": "app-123456",
      "name": "my-web-app",
      "description": "我的Web应用",
      "homepage_url": "https://example.com",
      "type": "APPLICATION_TYPE_WEB",
      "status": "APPLICATION_STATUS_ACTIVE",
      "scopes": ["read", "write"],
      "client_id": "client_1234567890abcdef",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-15T14:30:00Z",
      "last_used_at": "2024-01-15T10:30:00Z",
      "user_count": 150,
      "access_key_count": 5
    },
    {
      "id": "app-789012",
      "name": "my-api-service",
      "description": "API服务应用",
      "type": "APPLICATION_TYPE_SERVICE",
      "status": "APPLICATION_STATUS_ACTIVE",
      "scopes": ["read", "write", "admin"],
      "client_id": "client_0987654321fedcba",
      "created_at": "2024-01-10T00:00:00Z",
      "updated_at": "2024-01-10T00:00:00Z",
      "user_count": 25,
      "access_key_count": 2
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 10,
    "total_count": 2,
    "total_pages": 1
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 无效的分页参数 | 检查page和page_size值 |
| `INVALID_ARGUMENT` | 无效的排序字段 | 使用有效的排序字段 |
| `PERMISSION_DENIED` | 无查看应用列表权限 | 确保有`iam:ListApplications`权限 |

## 📊 数据模型

### Application 对象

```protobuf
message Application {
  string id = 1;                        // 应用ID（系统生成）
  string name = 2;                      // 应用名称（唯一）
  string description = 3;               // 应用描述
  string homepage_url = 4;              // 主页URL
  string callback_url = 5;              // 回调URL
  ApplicationType type = 6;             // 应用类型
  ApplicationStatus status = 7;         // 应用状态
  repeated string scopes = 8;           // 权限范围
  string client_id = 9;                 // 客户端ID
  string client_secret = 10;            // 客户端密钥（仅创建时返回）
  google.protobuf.Timestamp created_at = 11;    // 创建时间
  google.protobuf.Timestamp updated_at = 12;    // 更新时间
  google.protobuf.Timestamp last_used_at = 13;  // 最后使用时间
  int32 user_count = 14;                // 关联用户数
  int32 access_key_count = 15;          // 访问密钥数
}
```

### ApplicationType 枚举

```protobuf
enum ApplicationType {
  APPLICATION_TYPE_UNSPECIFIED = 0;     // 未指定
  APPLICATION_TYPE_WEB = 1;             // Web应用
  APPLICATION_TYPE_MOBILE = 2;          // 移动应用
  APPLICATION_TYPE_DESKTOP = 3;         // 桌面应用
  APPLICATION_TYPE_SERVICE = 4;         // 服务应用
  APPLICATION_TYPE_SPA = 5;             // 单页应用
}
```

### ApplicationStatus 枚举

```protobuf
enum ApplicationStatus {
  APPLICATION_STATUS_UNSPECIFIED = 0;   // 未指定
  APPLICATION_STATUS_ACTIVE = 1;        // 活跃
  APPLICATION_STATUS_INACTIVE = 2;      // 非活跃
  APPLICATION_STATUS_SUSPENDED = 3;     // 暂停
}
```

## 🔐 权限要求

### 所需权限

| 操作 | 权限 | 资源 |
|------|------|------|
| 创建应用 | `iam:CreateApplication` | `arn:iam::application/*` |
| 获取应用 | `iam:GetApplication` | `arn:iam::application/*` 或 `arn:iam::application/${app:id}` |
| 更新应用 | `iam:UpdateApplication` | `arn:iam::application/*` 或 `arn:iam::application/${app:id}` |
| 删除应用 | `iam:DeleteApplication` | `arn:iam::application/*` 或 `arn:iam::application/${app:id}` |
| 列表应用 | `iam:ListApplications` | `arn:iam::application/*` |

### 策略示例

#### 应用开发者策略

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
        "iam:ListApplications"
      ],
      "Resource": "arn:iam::application/*",
      "Condition": {
        "StringEquals": {
          "iam:ApplicationOwner": "${aws:username}"
        }
      }
    }
  ]
}
```

#### 应用管理员策略

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

#### 只读访问策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetApplication",
        "iam:ListApplications"
      ],
      "Resource": "arn:iam::application/*"
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
    
    // 1. 创建应用
    fmt.Println("1. 创建应用...")
    createResp, err := client.CreateApplication(ctx, &iamv1.CreateApplicationRequest{
        Name:        "my-test-app",
        Description: "测试应用",
        HomepageUrl: "https://example.com",
        CallbackUrl: "https://example.com/callback",
        Type:        iamv1.ApplicationType_APPLICATION_TYPE_WEB,
        Scopes:      []string{"read", "write"},
    })
    if err != nil {
        log.Fatalf("创建应用失败: %v", err)
    }
    
    appID := createResp.Application.Id
    clientID := createResp.Application.ClientId
    clientSecret := createResp.Application.ClientSecret
    
    fmt.Printf("应用创建成功:\n")
    fmt.Printf("  应用ID: %s\n", appID)
    fmt.Printf("  客户端ID: %s\n", clientID)
    fmt.Printf("  客户端密钥: %s\n", clientSecret)
    
    // 2. 获取应用详情
    fmt.Println("\n2. 获取应用详情...")
    getResp, err := client.GetApplication(ctx, &iamv1.GetApplicationRequest{
        Id: appID,
    })
    if err != nil {
        log.Fatalf("获取应用失败: %v", err)
    }
    
    fmt.Printf("应用详情:\n")
    fmt.Printf("  名称: %s\n", getResp.Application.Name)
    fmt.Printf("  描述: %s\n", getResp.Application.Description)
    fmt.Printf("  类型: %s\n", getResp.Application.Type)
    fmt.Printf("  状态: %s\n", getResp.Application.Status)
    fmt.Printf("  权限范围: %v\n", getResp.Application.Scopes)
    
    // 3. 更新应用
    fmt.Println("\n3. 更新应用...")
    updateResp, err := client.UpdateApplication(ctx, &iamv1.UpdateApplicationRequest{
        Id:          appID,
        Description: "更新后的测试应用",
        Scopes:      []string{"read", "write", "admin"},
        UpdateMask: &fieldmaskpb.FieldMask{
            Paths: []string{"description", "scopes"},
        },
    })
    if err != nil {
        log.Fatalf("更新应用失败: %v", err)
    }
    
    fmt.Printf("应用更新成功:\n")
    fmt.Printf("  新描述: %s\n", updateResp.Application.Description)
    fmt.Printf("  新权限范围: %v\n", updateResp.Application.Scopes)
    
    // 4. 列出应用
    fmt.Println("\n4. 列出应用...")
    listResp, err := client.ListApplications(ctx, &iamv1.ListApplicationsRequest{
        Page:     1,
        PageSize: 10,
        SortBy:   "created_at",
        SortDesc: true,
    })
    if err != nil {
        log.Fatalf("列出应用失败: %v", err)
    }
    
    fmt.Printf("找到 %d 个应用:\n", len(listResp.Applications))
    for i, app := range listResp.Applications {
        fmt.Printf("  %d. %s (%s) - %s\n", i+1, app.Name, app.Type, app.Status)
    }
    
    // 5. 删除应用
    fmt.Println("\n5. 删除应用...")
    _, err = client.DeleteApplication(ctx, &iamv1.DeleteApplicationRequest{
        Id: appID,
    })
    if err != nil {
        log.Fatalf("删除应用失败: %v", err)
    }
    
    fmt.Println("应用删除成功")
}
```

### Python 客户端示例

```python
import grpc
from google.protobuf import field_mask_pb2

# 假设已生成的Python gRPC客户端
from iam.v1 import iam_pb2, iam_pb2_grpc

def main():
    # 连接到服务
    with grpc.insecure_channel('localhost:50051') as channel:
        client = iam_pb2_grpc.IAMStub(channel)
        
        # 1. 创建应用
        print("1. 创建应用...")
        create_request = iam_pb2.CreateApplicationRequest(
            name="my-python-app",
            description="Python测试应用",
            homepage_url="https://python-app.com",
            type=iam_pb2.APPLICATION_TYPE_DESKTOP,
            scopes=["read", "write"]
        )
        
        create_response = client.CreateApplication(create_request)
        app_id = create_response.application.id
        client_id = create_response.application.client_id
        client_secret = create_response.application.client_secret
        
        print(f"应用创建成功:")
        print(f"  应用ID: {app_id}")
        print(f"  客户端ID: {client_id}")
        print(f"  客户端密钥: {client_secret}")
        
        # 2. 获取应用详情
        print("\n2. 获取应用详情...")
        get_request = iam_pb2.GetApplicationRequest(id=app_id)
        get_response = client.GetApplication(get_request)
        
        app = get_response.application
        print(f"应用详情:")
        print(f"  名称: {app.name}")
        print(f"  描述: {app.description}")
        print(f"  类型: {app.type}")
        print(f"  状态: {app.status}")
        print(f"  权限范围: {list(app.scopes)}")
        
        # 3. 更新应用
        print("\n3. 更新应用...")
        update_mask = field_mask_pb2.FieldMask(paths=["description", "status"])
        update_request = iam_pb2.UpdateApplicationRequest(
            id=app_id,
            description="更新后的Python应用",
            status=iam_pb2.APPLICATION_STATUS_INACTIVE,
            update_mask=update_mask
        )
        
        update_response = client.UpdateApplication(update_request)
        print(f"应用更新成功:")
        print(f"  新描述: {update_response.application.description}")
        print(f"  新状态: {update_response.application.status}")
        
        # 4. 列出应用
        print("\n4. 列出应用...")
        list_request = iam_pb2.ListApplicationsRequest(
            type=iam_pb2.APPLICATION_TYPE_DESKTOP,
            page=1,
            page_size=10
        )
        
        list_response = client.ListApplications(list_request)
        print(f"找到 {len(list_response.applications)} 个桌面应用:")
        for i, app in enumerate(list_response.applications, 1):
            print(f"  {i}. {app.name} - {app.status}")
        
        # 5. 删除应用
        print("\n5. 删除应用...")
        delete_request = iam_pb2.DeleteApplicationRequest(id=app_id)
        client.DeleteApplication(delete_request)
        print("应用删除成功")

if __name__ == "__main__":
    main()
```

### 批量应用管理脚本

```bash
#!/bin/bash

# 批量应用管理脚本
SERVER="localhost:50051"
APPS_CONFIG="apps_config.json"
OUTPUT_FILE="applications_report.csv"

# 创建CSV头部
echo "应用名称,应用ID,客户端ID,客户端密钥,类型,状态,创建时间" > "$OUTPUT_FILE"

# 从配置文件读取应用配置并批量创建
jq -c '.applications[]' "$APPS_CONFIG" | while read app_config; do
    name=$(echo "$app_config" | jq -r '.name')
    description=$(echo "$app_config" | jq -r '.description')
    type=$(echo "$app_config" | jq -r '.type')
    scopes=$(echo "$app_config" | jq -r '.scopes | join(",")')
    
    echo "创建应用: $name"
    
    # 构造创建请求
    create_request=$(echo "$app_config" | jq '{
        name: .name,
        description: .description,
        homepage_url: .homepage_url,
        callback_url: .callback_url,
        type: .type,
        scopes: .scopes
    }')
    
    # 创建应用
    result=$(grpcurl -plaintext -d "$create_request" "$SERVER" iam.v1.IAM/CreateApplication 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # 解析结果
        app_id=$(echo "$result" | jq -r '.application.id')
        client_id=$(echo "$result" | jq -r '.application.client_id')
        client_secret=$(echo "$result" | jq -r '.application.client_secret')
        app_type=$(echo "$result" | jq -r '.application.type')
        status=$(echo "$result" | jq -r '.application.status')
        created_at=$(echo "$result" | jq -r '.application.created_at')
        
        # 写入CSV文件
        echo "$name,$app_id,$client_id,$client_secret,$app_type,$status,$created_at" >> "$OUTPUT_FILE"
        
        echo "  成功: $app_id"
    else
        echo "  失败: 无法创建应用 $name"
    fi
    
    sleep 0.1  # 避免过快请求
done

echo "批量创建完成，结果保存在 $OUTPUT_FILE"
```

配置文件示例 (`apps_config.json`)：

```json
{
  "applications": [
    {
      "name": "web-frontend",
      "description": "Web前端应用",
      "homepage_url": "https://web.example.com",
      "callback_url": "https://web.example.com/callback",
      "type": "APPLICATION_TYPE_WEB",
      "scopes": ["read", "write"]
    },
    {
      "name": "mobile-app",
      "description": "移动应用",
      "type": "APPLICATION_TYPE_MOBILE",
      "scopes": ["read", "write", "offline_access"]
    },
    {
      "name": "api-service",
      "description": "API服务",
      "type": "APPLICATION_TYPE_SERVICE",
      "scopes": ["read", "write", "admin"]
    }
  ]
}
```

## 🔍 最佳实践

### 1. 应用设计原则

#### 单一职责
```go
// 为不同用途创建不同的应用
func createApplications(client iamv1.IAMClient) error {
    ctx := context.Background()
    
    // Web前端应用
    _, err := client.CreateApplication(ctx, &iamv1.CreateApplicationRequest{
        Name:        "web-frontend",
        Description: "Web前端应用",
        Type:        iamv1.ApplicationType_APPLICATION_TYPE_WEB,
        Scopes:      []string{"read", "write"},
    })
    if err != nil {
        return err
    }
    
    // 移动应用
    _, err = client.CreateApplication(ctx, &iamv1.CreateApplicationRequest{
        Name:        "mobile-app",
        Description: "移动应用",
        Type:        iamv1.ApplicationType_APPLICATION_TYPE_MOBILE,
        Scopes:      []string{"read", "write", "offline_access"},
    })
    if err != nil {
        return err
    }
    
    // 后台服务
    _, err = client.CreateApplication(ctx, &iamv1.CreateApplicationRequest{
        Name:        "backend-service",
        Description: "后台服务应用",
        Type:        iamv1.ApplicationType_APPLICATION_TYPE_SERVICE,
        Scopes:      []string{"read", "write", "admin"},
    })
    
    return err
}
```

#### 权限最小化
```go
// 根据应用类型设置合适的权限范围
func getScopesForApplicationType(appType iamv1.ApplicationType) []string {
    switch appType {
    case iamv1.ApplicationType_APPLICATION_TYPE_WEB:
        return []string{"read", "write"}
    case iamv1.ApplicationType_APPLICATION_TYPE_MOBILE:
        return []string{"read", "write", "offline_access"}
    case iamv1.ApplicationType_APPLICATION_TYPE_SERVICE:
        return []string{"read", "write", "admin"}
    case iamv1.ApplicationType_APPLICATION_TYPE_SPA:
        return []string{"read"} // 单页应用通常只需要读权限
    default:
        return []string{"read"}
    }
}
```

### 2. 客户端密钥管理

#### 安全存储
```go
// 安全存储客户端密钥
type ApplicationCredentials struct {
    ClientID     string `json:"client_id"`
    ClientSecret string `json:"-"` // 不序列化到JSON
}

func (ac *ApplicationCredentials) StoreSecurely(keyring string) error {
    // 使用系统密钥环存储客户端密钥
    return storeInKeyring(keyring, ac.ClientID, ac.ClientSecret)
}

func (ac *ApplicationCredentials) LoadSecurely(keyring string) error {
    // 从系统密钥环加载客户端密钥
    secret, err := loadFromKeyring(keyring, ac.ClientID)
    if err != nil {
        return err
    }
    ac.ClientSecret = secret
    return nil
}
```

#### 密钥轮换
```go
// 客户端密钥轮换（需要重新创建应用）
func rotateApplicationCredentials(client iamv1.IAMClient, appID string) (*iamv1.Application, error) {
    ctx := context.Background()
    
    // 1. 获取当前应用信息
    getResp, err := client.GetApplication(ctx, &iamv1.GetApplicationRequest{
        Id: appID,
    })
    if err != nil {
        return nil, fmt.Errorf("获取应用信息失败: %v", err)
    }
    
    oldApp := getResp.Application
    
    // 2. 创建新应用（相同配置）
    newApp, err := client.CreateApplication(ctx, &iamv1.CreateApplicationRequest{
        Name:        oldApp.Name + "-new",
        Description: oldApp.Description + " (轮换后)",
        HomepageUrl: oldApp.HomepageUrl,
        CallbackUrl: oldApp.CallbackUrl,
        Type:        oldApp.Type,
        Scopes:      oldApp.Scopes,
    })
    if err != nil {
        return nil, fmt.Errorf("创建新应用失败: %v", err)
    }
    
    // 3. 更新应用配置（这里需要根据实际情况实现）
    if err := updateApplicationConfig(newApp.Application); err != nil {
        return nil, fmt.Errorf("更新应用配置失败: %v", err)
    }
    
    // 4. 等待配置生效
    time.Sleep(30 * time.Second)
    
    // 5. 删除旧应用
    _, err = client.DeleteApplication(ctx, &iamv1.DeleteApplicationRequest{
        Id:    appID,
        Force: true,
    })
    if err != nil {
        log.Printf("删除旧应用失败: %v", err)
    }
    
    return newApp.Application, nil
}
```

### 3. 应用监控和审计

```go
// 应用使用情况监控
func monitorApplicationUsage(client iamv1.IAMClient) {
    ctx := context.Background()
    
    apps, err := client.ListApplications(ctx, &iamv1.ListApplicationsRequest{
        Page:     1,
        PageSize: 100,
    })
    if err != nil {
        log.Printf("获取应用列表失败: %v", err)
        return
    }
    
    for _, app := range apps.Applications {
        // 检查最后使用时间
        if app.LastUsedAt != nil {
            lastUsed := app.LastUsedAt.AsTime()
            if time.Since(lastUsed) > 30*24*time.Hour { // 30天未使用
                log.Printf("警告: 应用 %s 已超过30天未使用", app.Name)
            }
        }
        
        // 检查用户数量
        if app.UserCount == 0 {
            log.Printf("警告: 应用 %s 没有关联用户", app.Name)
        }
        
        // 检查访问密钥数量
        if app.AccessKeyCount > 10 {
            log.Printf("警告: 应用 %s 的访问密钥数量过多 (%d)", app.Name, app.AccessKeyCount)
        }
    }
}
```

### 4. 应用生命周期管理

```bash
#!/bin/bash

# 应用生命周期管理脚本
SERVER="localhost:50051"

# 应用健康检查
check_application_health() {
    local app_id="$1"
    
    echo "检查应用健康状态: $app_id"
    
    # 获取应用详情
    app_info=$(grpcurl -plaintext -d "{
        \"id\": \"$app_id\"
    }" "$SERVER" iam.v1.IAM/GetApplication)
    
    if [ $? -ne 0 ]; then
        echo "错误: 无法获取应用信息"
        return 1
    fi
    
    # 检查应用状态
    status=$(echo "$app_info" | jq -r '.application.status')
    if [ "$status" != "APPLICATION_STATUS_ACTIVE" ]; then
        echo "警告: 应用状态异常 - $status"
    fi
    
    # 检查最后使用时间
    last_used=$(echo "$app_info" | jq -r '.application.last_used_at')
    if [ "$last_used" != "null" ]; then
        # 计算天数差异（简化计算）
        echo "最后使用时间: $last_used"
    else
        echo "警告: 应用从未被使用"
    fi
    
    # 检查关联资源
    user_count=$(echo "$app_info" | jq -r '.application.user_count')
    access_key_count=$(echo "$app_info" | jq -r '.application.access_key_count')
    
    echo "关联用户数: $user_count"
    echo "访问密钥数: $access_key_count"
    
    if [ "$user_count" -eq 0 ] && [ "$access_key_count" -eq 0 ]; then
        echo "警告: 应用没有关联任何资源，可能需要清理"
    fi
}

# 清理未使用的应用
cleanup_unused_applications() {
    echo "开始清理未使用的应用..."
    
    # 获取所有应用
    apps=$(grpcurl -plaintext -d '{
        "page": 1,
        "page_size": 1000
    }' "$SERVER" iam.v1.IAM/ListApplications)
    
    # 检查每个应用
    echo "$apps" | jq -c '.applications[]' | while read app; do
        app_id=$(echo "$app" | jq -r '.id')
        app_name=$(echo "$app" | jq -r '.name')
        user_count=$(echo "$app" | jq -r '.user_count')
        access_key_count=$(echo "$app" | jq -r '.access_key_count')
        last_used=$(echo "$app" | jq -r '.last_used_at')
        
        # 如果应用没有关联资源且从未使用，标记为可删除
        if [ "$user_count" -eq 0 ] && [ "$access_key_count" -eq 0 ] && [ "$last_used" = "null" ]; then
            echo "发现未使用的应用: $app_name ($app_id)"
            echo "是否删除此应用? (y/N)"
            read -r confirm
            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                grpcurl -plaintext -d "{
                    \"id\": \"$app_id\"
                }" "$SERVER" iam.v1.IAM/DeleteApplication
                echo "应用 $app_name 已删除"
            fi
        fi
    done
}

# 应用备份
backup_applications() {
    local backup_file="applications_backup_$(date +%Y%m%d_%H%M%S).json"
    
    echo "备份应用配置到: $backup_file"
    
    # 获取所有应用
    grpcurl -plaintext -d '{
        "page": 1,
        "page_size": 1000
    }' "$SERVER" iam.v1.IAM/ListApplications > "$backup_file"
    
    echo "备份完成"
}

# 主函数
case "$1" in
    "health")
        if [ -z "$2" ]; then
            echo "用法: $0 health <应用ID>"
            exit 1
        fi
        check_application_health "$2"
        ;;
    "cleanup")
        cleanup_unused_applications
        ;;
    "backup")
        backup_applications
        ;;
    *)
        echo "用法: $0 {health|cleanup|backup} [应用ID]"
        echo "  health <应用ID>  - 检查应用健康状态"
        echo "  cleanup          - 清理未使用的应用"
        echo "  backup           - 备份应用配置"
        exit 1
        ;;
esac
```

## 🚨 注意事项

### 安全考虑

1. **客户端密钥保护**：
   - 永远不要在代码中硬编码客户端密钥
   - 使用环境变量或安全的配置管理系统
   - 定期轮换客户端密钥

2. **权限控制**：
   - 遵循最小权限原则
   - 为不同用途创建不同的应用
   - 定期审查应用权限

3. **访问控制**：
   - 限制应用创建权限
   - 监控应用使用情况
   - 及时删除不使用的应用

### 性能优化

1. **批量操作**：
   - 避免循环调用API
   - 使用分页查询大量数据
   - 合理控制并发数

2. **缓存策略**：
   - 缓存应用基本信息
   - 设置合适的缓存过期时间
   - 监控缓存命中率

### 运维管理

1. **监控告警**：
   - 监控应用创建和删除操作
   - 设置应用数量告警
   - 监控异常使用模式

2. **备份恢复**：
   - 定期备份应用配置
   - 测试恢复流程
   - 保留历史备份

---

::: tip 提示
建议为每个环境（开发、测试、生产）创建独立的应用，便于管理和隔离。
:::

::: warning 注意
应用的客户端密钥只在创建时返回一次，请务必妥善保存。如果丢失，需要重新创建应用。
:::