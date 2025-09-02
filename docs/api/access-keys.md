# 访问密钥管理 API

访问密钥管理API提供了完整的API访问密钥生命周期管理功能，包括密钥的创建、查询、更新状态和删除操作。

## 📋 API 概览

| 方法 | 描述 | 权限要求 |
|------|------|----------|
| `CreateAccessKey` | 创建访问密钥 | `iam:CreateAccessKey` |
| `ListAccessKeys` | 获取访问密钥列表 | `iam:ListAccessKeys` |
| `UpdateAccessKey` | 更新访问密钥状态 | `iam:UpdateAccessKey` |
| `DeleteAccessKey` | 删除访问密钥 | `iam:DeleteAccessKey` |

## 🔧 API 详情

### CreateAccessKey - 创建访问密钥

为指定用户创建新的API访问密钥。

#### 请求

```protobuf
message CreateAccessKeyRequest {
  string user_name = 1;         // 用户名（必需）
  string description = 2;       // 密钥描述（可选）
  int32 app_id = 3;            // 关联应用ID（可选）
  int32 expires_in_days = 4;   // 过期天数（可选，默认永不过期）
}
```

#### 响应

```protobuf
message CreateAccessKeyResponse {
  AccessKey access_key = 1;     // 创建的访问密钥信息
}
```

#### 示例

```bash
# 为用户创建访问密钥
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "description": "API访问密钥"
}' localhost:50051 iam.v1.IAM/CreateAccessKey
```

```bash
# 创建关联应用的访问密钥
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "description": "移动应用API密钥",
  "app_id": 123,
  "expires_in_days": 90
}' localhost:50051 iam.v1.IAM/CreateAccessKey
```

#### 响应示例

```json
{
  "access_key": {
    "id": "ak-123456",
    "access_key_id": "AKIA1234567890EXAMPLE",
    "secret_access_key": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    "user_id": "user-789",
    "user_name": "john_doe",
    "description": "API访问密钥",
    "status": "ACCESS_KEY_STATUS_ACTIVE",
    "app_id": 123,
    "created_at": "2024-01-01T00:00:00Z",
    "expires_at": "2024-04-01T00:00:00Z"
  }
}
```

::: warning 重要提示
`secret_access_key` 只在创建时返回一次，请妥善保存。后续无法再次获取。
:::

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 用户不存在 | 确认用户名正确 |
| `INVALID_ARGUMENT` | 无效的过期天数 | 设置合理的过期时间 |
| `RESOURCE_EXHAUSTED` | 用户访问密钥数量达到上限 | 删除不使用的密钥 |
| `PERMISSION_DENIED` | 无创建访问密钥权限 | 确保有`iam:CreateAccessKey`权限 |

---

### ListAccessKeys - 获取访问密钥列表

获取指定用户的访问密钥列表。

#### 请求

```protobuf
message ListAccessKeysRequest {
  string user_name = 1;         // 用户名（必需）
  AccessKeyStatus status = 2;   // 密钥状态过滤（可选）
  int32 page = 3;              // 页码（从1开始）
  int32 page_size = 4;         // 每页大小（最大100）
}
```

#### 响应

```protobuf
message ListAccessKeysResponse {
  repeated AccessKey access_keys = 1;   // 访问密钥列表
  Pagination pagination = 2;            // 分页信息
}
```

#### 示例

```bash
# 获取用户的所有访问密钥
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListAccessKeys
```

```bash
# 只获取活跃的访问密钥
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "status": "ACCESS_KEY_STATUS_ACTIVE",
  "page": 1,
  "page_size": 10
}' localhost:50051 iam.v1.IAM/ListAccessKeys
```

#### 响应示例

```json
{
  "access_keys": [
    {
      "id": "ak-123456",
      "access_key_id": "AKIA1234567890EXAMPLE",
      "user_id": "user-789",
      "user_name": "john_doe",
      "description": "API访问密钥",
      "status": "ACCESS_KEY_STATUS_ACTIVE",
      "app_id": 123,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "last_used_at": "2024-01-15T10:30:00Z",
      "expires_at": "2024-04-01T00:00:00Z"
    },
    {
      "id": "ak-789012",
      "access_key_id": "AKIA0987654321EXAMPLE",
      "user_id": "user-789",
      "user_name": "john_doe",
      "description": "移动应用密钥",
      "status": "ACCESS_KEY_STATUS_INACTIVE",
      "created_at": "2024-01-10T00:00:00Z",
      "updated_at": "2024-01-12T00:00:00Z"
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

::: tip 提示
出于安全考虑，列表接口不返回 `secret_access_key` 字段。
:::

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 用户不存在 | 确认用户名正确 |
| `INVALID_ARGUMENT` | 无效的分页参数 | 检查page和page_size值 |
| `PERMISSION_DENIED` | 无查看访问密钥权限 | 确保有`iam:ListAccessKeys`权限 |

---

### UpdateAccessKey - 更新访问密钥状态

更新访问密钥的状态或描述信息。

#### 请求

```protobuf
message UpdateAccessKeyRequest {
  string access_key_id = 1;     // 访问密钥ID（必需）
  AccessKeyStatus status = 2;   // 新状态（可选）
  string description = 3;       // 新描述（可选）
  google.protobuf.FieldMask update_mask = 4;  // 更新字段掩码
}
```

#### 响应

```protobuf
message UpdateAccessKeyResponse {
  AccessKey access_key = 1;     // 更新后的访问密钥信息
}
```

#### 示例

```bash
# 禁用访问密钥
grpcurl -plaintext -d '{
  "access_key_id": "AKIA1234567890EXAMPLE",
  "status": "ACCESS_KEY_STATUS_INACTIVE",
  "update_mask": {
    "paths": ["status"]
  }
}' localhost:50051 iam.v1.IAM/UpdateAccessKey
```

```bash
# 启用访问密钥并更新描述
grpcurl -plaintext -d '{
  "access_key_id": "AKIA1234567890EXAMPLE",
  "status": "ACCESS_KEY_STATUS_ACTIVE",
  "description": "更新后的API访问密钥",
  "update_mask": {
    "paths": ["status", "description"]
  }
}' localhost:50051 iam.v1.IAM/UpdateAccessKey
```

#### 响应示例

```json
{
  "access_key": {
    "id": "ak-123456",
    "access_key_id": "AKIA1234567890EXAMPLE",
    "user_id": "user-789",
    "user_name": "john_doe",
    "description": "更新后的API访问密钥",
    "status": "ACCESS_KEY_STATUS_ACTIVE",
    "app_id": 123,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-15T14:30:00Z",
    "last_used_at": "2024-01-15T10:30:00Z",
    "expires_at": "2024-04-01T00:00:00Z"
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 访问密钥不存在 | 确认访问密钥ID正确 |
| `INVALID_ARGUMENT` | 无效的状态值 | 使用有效的状态枚举值 |
| `PERMISSION_DENIED` | 无更新访问密钥权限 | 确保有`iam:UpdateAccessKey`权限 |

---

### DeleteAccessKey - 删除访问密钥

删除指定的访问密钥。

::: warning 注意
删除访问密钥是不可逆操作，删除后使用该密钥的API调用将失败。
:::

#### 请求

```protobuf
message DeleteAccessKeyRequest {
  string access_key_id = 1;     // 访问密钥ID（必需）
}
```

#### 响应

```protobuf
message DeleteAccessKeyResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 删除访问密钥
grpcurl -plaintext -d '{
  "access_key_id": "AKIA1234567890EXAMPLE"
}' localhost:50051 iam.v1.IAM/DeleteAccessKey
```

#### 响应示例

```json
{}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 访问密钥不存在 | 确认访问密钥ID正确 |
| `PERMISSION_DENIED` | 无删除访问密钥权限 | 确保有`iam:DeleteAccessKey`权限 |

## 📊 数据模型

### AccessKey 对象

```protobuf
message AccessKey {
  string id = 1;                        // 内部ID（系统生成）
  string access_key_id = 2;             // 访问密钥ID（公开标识符）
  string secret_access_key = 3;         // 秘密访问密钥（仅创建时返回）
  string user_id = 4;                   // 用户ID
  string user_name = 5;                 // 用户名
  string description = 6;               // 密钥描述
  AccessKeyStatus status = 7;           // 密钥状态
  int32 app_id = 8;                     // 关联应用ID
  google.protobuf.Timestamp created_at = 9;     // 创建时间
  google.protobuf.Timestamp updated_at = 10;    // 更新时间
  google.protobuf.Timestamp last_used_at = 11;  // 最后使用时间
  google.protobuf.Timestamp expires_at = 12;    // 过期时间
}
```

### AccessKeyStatus 枚举

```protobuf
enum AccessKeyStatus {
  ACCESS_KEY_STATUS_UNSPECIFIED = 0;    // 未指定
  ACCESS_KEY_STATUS_ACTIVE = 1;         // 活跃
  ACCESS_KEY_STATUS_INACTIVE = 2;       // 非活跃
}
```

## 🔐 权限要求

### 所需权限

| 操作 | 权限 | 资源 |
|------|------|------|
| 创建访问密钥 | `iam:CreateAccessKey` | `arn:iam::user/*` 或 `arn:iam::user/${aws:username}` |
| 列表访问密钥 | `iam:ListAccessKeys` | `arn:iam::user/*` 或 `arn:iam::user/${aws:username}` |
| 更新访问密钥 | `iam:UpdateAccessKey` | `arn:iam::access-key/*` |
| 删除访问密钥 | `iam:DeleteAccessKey` | `arn:iam::access-key/*` |

### 策略示例

#### 用户自管理访问密钥策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey",
        "iam:DeleteAccessKey"
      ],
      "Resource": [
        "arn:iam::user/${aws:username}",
        "arn:iam::access-key/*"
      ],
      "Condition": {
        "StringEquals": {
          "iam:AccessKeyOwner": "${aws:username}"
        }
      }
    }
  ]
}
```

#### 管理员访问密钥管理策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey",
        "iam:DeleteAccessKey"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🔑 访问密钥使用

### AWS Signature Version 4 认证

VGO使用AWS Signature Version 4算法进行API认证。

#### 认证流程

1. **准备请求**：构造HTTP请求
2. **创建规范请求**：标准化请求格式
3. **创建待签名字符串**：包含请求摘要
4. **计算签名**：使用HMAC-SHA256算法
5. **添加认证头**：包含签名信息

#### 认证头格式

```
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20230101/us-east-1/iam/aws4_request, SignedHeaders=host;x-amz-date, Signature=calculated_signature
```

#### Go SDK 示例

```go
package main

import (
    "context"
    "crypto/hmac"
    "crypto/sha256"
    "encoding/hex"
    "fmt"
    "time"
    
    "google.golang.org/grpc"
    "google.golang.org/grpc/metadata"
    
    iamv1 "github.com/your-org/vgo/api/iam/v1"
)

type Credentials struct {
    AccessKeyID     string
    SecretAccessKey string
}

func (c *Credentials) Sign(stringToSign string) string {
    h := hmac.New(sha256.New, []byte(c.SecretAccessKey))
    h.Write([]byte(stringToSign))
    return hex.EncodeToString(h.Sum(nil))
}

func createAuthenticatedContext(creds *Credentials) context.Context {
    now := time.Now().UTC()
    dateStamp := now.Format("20060102")
    amzDate := now.Format("20060102T150405Z")
    
    // 构造认证头
    credential := fmt.Sprintf("%s/%s/us-east-1/iam/aws4_request", creds.AccessKeyID, dateStamp)
    signedHeaders := "host;x-amz-date"
    
    // 简化的签名计算（实际应用中需要完整的SigV4实现）
    stringToSign := fmt.Sprintf("AWS4-HMAC-SHA256\n%s\n%s/%s/us-east-1/iam/aws4_request\n%s",
        amzDate, dateStamp, "iam", "request_hash")
    
    signature := creds.Sign(stringToSign)
    
    authHeader := fmt.Sprintf("AWS4-HMAC-SHA256 Credential=%s, SignedHeaders=%s, Signature=%s",
        credential, signedHeaders, signature)
    
    // 创建带认证信息的context
    md := metadata.New(map[string]string{
        "authorization": authHeader,
        "x-amz-date":    amzDate,
    })
    
    return metadata.NewOutgoingContext(context.Background(), md)
}

func main() {
    // 连接到服务
    conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
    if err != nil {
        panic(err)
    }
    defer conn.Close()
    
    client := iamv1.NewIAMClient(conn)
    
    // 使用访问密钥认证
    creds := &Credentials{
        AccessKeyID:     "AKIA1234567890EXAMPLE",
        SecretAccessKey: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    }
    
    ctx := createAuthenticatedContext(creds)
    
    // 调用API
    resp, err := client.ListAccessKeys(ctx, &iamv1.ListAccessKeysRequest{
        UserName: "john_doe",
        Page:     1,
        PageSize: 10,
    })
    if err != nil {
        panic(err)
    }
    
    fmt.Printf("访问密钥列表: %v\n", resp.AccessKeys)
}
```

### 使用官方AWS SDK

```go
package main

import (
    "context"
    "fmt"
    
    "github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/credentials"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/iam"
)

func main() {
    // 创建AWS会话
    sess := session.Must(session.NewSession(&aws.Config{
        Region: aws.String("us-east-1"),
        Credentials: credentials.NewStaticCredentials(
            "AKIA1234567890EXAMPLE",
            "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
            "",
        ),
        Endpoint: aws.String("http://localhost:50051"), // VGO服务端点
    }))
    
    // 创建IAM客户端
    svc := iam.New(sess)
    
    // 列出访问密钥
    result, err := svc.ListAccessKeys(&iam.ListAccessKeysInput{
        UserName: aws.String("john_doe"),
    })
    if err != nil {
        panic(err)
    }
    
    fmt.Printf("访问密钥: %v\n", result.AccessKeyMetadata)
}
```

## 🛠️ 使用示例

### 完整的访问密钥管理示例

```go
package main

import (
    "context"
    "fmt"
    "log"
    "time"
    
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
    
    userName := "test_user"
    
    // 1. 创建访问密钥
    fmt.Println("1. 创建访问密钥...")
    createResp, err := client.CreateAccessKey(ctx, &iamv1.CreateAccessKeyRequest{
        UserName:      userName,
        Description:   "测试API密钥",
        ExpiresInDays: 90,
    })
    if err != nil {
        log.Fatalf("创建访问密钥失败: %v", err)
    }
    
    accessKeyID := createResp.AccessKey.AccessKeyId
    secretAccessKey := createResp.AccessKey.SecretAccessKey
    
    fmt.Printf("访问密钥创建成功:\n")
    fmt.Printf("  Access Key ID: %s\n", accessKeyID)
    fmt.Printf("  Secret Access Key: %s\n", secretAccessKey)
    fmt.Printf("  过期时间: %s\n", createResp.AccessKey.ExpiresAt.AsTime().Format(time.RFC3339))
    
    // 2. 列出用户的访问密钥
    fmt.Println("\n2. 列出访问密钥...")
    listResp, err := client.ListAccessKeys(ctx, &iamv1.ListAccessKeysRequest{
        UserName: userName,
        Page:     1,
        PageSize: 10,
    })
    if err != nil {
        log.Fatalf("列出访问密钥失败: %v", err)
    }
    
    fmt.Printf("找到 %d 个访问密钥:\n", len(listResp.AccessKeys))
    for i, key := range listResp.AccessKeys {
        fmt.Printf("  %d. %s - %s (%s)\n", i+1, key.AccessKeyId, key.Description, key.Status)
    }
    
    // 3. 禁用访问密钥
    fmt.Println("\n3. 禁用访问密钥...")
    updateResp, err := client.UpdateAccessKey(ctx, &iamv1.UpdateAccessKeyRequest{
        AccessKeyId: accessKeyID,
        Status:      iamv1.AccessKeyStatus_ACCESS_KEY_STATUS_INACTIVE,
        UpdateMask: &fieldmaskpb.FieldMask{
            Paths: []string{"status"},
        },
    })
    if err != nil {
        log.Fatalf("更新访问密钥失败: %v", err)
    }
    
    fmt.Printf("访问密钥状态更新为: %s\n", updateResp.AccessKey.Status)
    
    // 4. 重新启用访问密钥
    fmt.Println("\n4. 重新启用访问密钥...")
    _, err = client.UpdateAccessKey(ctx, &iamv1.UpdateAccessKeyRequest{
        AccessKeyId: accessKeyID,
        Status:      iamv1.AccessKeyStatus_ACCESS_KEY_STATUS_ACTIVE,
        Description: "重新启用的测试API密钥",
        UpdateMask: &fieldmaskpb.FieldMask{
            Paths: []string{"status", "description"},
        },
    })
    if err != nil {
        log.Fatalf("更新访问密钥失败: %v", err)
    }
    
    fmt.Println("访问密钥已重新启用")
    
    // 5. 删除访问密钥
    fmt.Println("\n5. 删除访问密钥...")
    _, err = client.DeleteAccessKey(ctx, &iamv1.DeleteAccessKeyRequest{
        AccessKeyId: accessKeyID,
    })
    if err != nil {
        log.Fatalf("删除访问密钥失败: %v", err)
    }
    
    fmt.Println("访问密钥删除成功")
    
    // 6. 验证删除
    fmt.Println("\n6. 验证删除结果...")
    listResp2, err := client.ListAccessKeys(ctx, &iamv1.ListAccessKeysRequest{
        UserName: userName,
        Page:     1,
        PageSize: 10,
    })
    if err != nil {
        log.Fatalf("列出访问密钥失败: %v", err)
    }
    
    fmt.Printf("剩余访问密钥数量: %d\n", len(listResp2.AccessKeys))
}
```

### 批量访问密钥管理脚本

```bash
#!/bin/bash

# 批量访问密钥管理脚本
SERVER="localhost:50051"
USERS_FILE="users.txt"
OUTPUT_FILE="access_keys.csv"

# 创建CSV头部
echo "用户名,访问密钥ID,秘密访问密钥,描述,状态,创建时间" > "$OUTPUT_FILE"

# 为每个用户创建访问密钥
while IFS= read -r username; do
    echo "为用户 $username 创建访问密钥..."
    
    # 创建访问密钥
    result=$(grpcurl -plaintext -d "{
        \"user_name\": \"$username\",
        \"description\": \"批量创建的API密钥\"
    }" "$SERVER" iam.v1.IAM/CreateAccessKey 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # 解析结果
        access_key_id=$(echo "$result" | jq -r '.access_key.access_key_id')
        secret_access_key=$(echo "$result" | jq -r '.access_key.secret_access_key')
        description=$(echo "$result" | jq -r '.access_key.description')
        status=$(echo "$result" | jq -r '.access_key.status')
        created_at=$(echo "$result" | jq -r '.access_key.created_at')
        
        # 写入CSV文件
        echo "$username,$access_key_id,$secret_access_key,$description,$status,$created_at" >> "$OUTPUT_FILE"
        
        echo "  成功: $access_key_id"
    else
        echo "  失败: 无法为用户 $username 创建访问密钥"
    fi
    
    sleep 0.1  # 避免过快请求
done < "$USERS_FILE"

echo "批量创建完成，结果保存在 $OUTPUT_FILE"
```

### 访问密钥轮换脚本

```bash
#!/bin/bash

# 访问密钥轮换脚本
SERVER="localhost:50051"
USER_NAME="$1"

if [ -z "$USER_NAME" ]; then
    echo "用法: $0 <用户名>"
    exit 1
fi

echo "开始为用户 $USER_NAME 轮换访问密钥..."

# 1. 获取当前活跃的访问密钥
echo "1. 获取当前访问密钥..."
current_keys=$(grpcurl -plaintext -d "{
    \"user_name\": \"$USER_NAME\",
    \"status\": \"ACCESS_KEY_STATUS_ACTIVE\"
}" "$SERVER" iam.v1.IAM/ListAccessKeys)

if [ $? -ne 0 ]; then
    echo "错误: 无法获取当前访问密钥"
    exit 1
fi

# 2. 创建新的访问密钥
echo "2. 创建新的访问密钥..."
new_key=$(grpcurl -plaintext -d "{
    \"user_name\": \"$USER_NAME\",
    \"description\": \"轮换生成的访问密钥 $(date)\"
}" "$SERVER" iam.v1.IAM/CreateAccessKey)

if [ $? -ne 0 ]; then
    echo "错误: 无法创建新的访问密钥"
    exit 1
fi

new_access_key_id=$(echo "$new_key" | jq -r '.access_key.access_key_id')
new_secret_access_key=$(echo "$new_key" | jq -r '.access_key.secret_access_key')

echo "新访问密钥创建成功:"
echo "  Access Key ID: $new_access_key_id"
echo "  Secret Access Key: $new_secret_access_key"

# 3. 等待用户确认更新应用配置
echo
echo "请更新您的应用配置以使用新的访问密钥，然后按回车键继续..."
read -r

# 4. 禁用旧的访问密钥
echo "3. 禁用旧的访问密钥..."
old_keys=$(echo "$current_keys" | jq -r '.access_keys[].access_key_id')

for old_key_id in $old_keys; do
    if [ "$old_key_id" != "$new_access_key_id" ]; then
        echo "  禁用密钥: $old_key_id"
        grpcurl -plaintext -d "{
            \"access_key_id\": \"$old_key_id\",
            \"status\": \"ACCESS_KEY_STATUS_INACTIVE\",
            \"update_mask\": {
                \"paths\": [\"status\"]
            }
        }" "$SERVER" iam.v1.IAM/UpdateAccessKey > /dev/null
    fi
done

# 5. 等待确认后删除旧密钥
echo
echo "旧访问密钥已禁用。如果新密钥工作正常，按回车键删除旧密钥..."
read -r

echo "4. 删除旧的访问密钥..."
for old_key_id in $old_keys; do
    if [ "$old_key_id" != "$new_access_key_id" ]; then
        echo "  删除密钥: $old_key_id"
        grpcurl -plaintext -d "{
            \"access_key_id\": \"$old_key_id\"
        }" "$SERVER" iam.v1.IAM/DeleteAccessKey > /dev/null
    fi
done

echo "访问密钥轮换完成！"
```

## 🔍 最佳实践

### 1. 访问密钥安全

#### 安全存储
```bash
# 使用环境变量
export AWS_ACCESS_KEY_ID="AKIA1234567890EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# 使用配置文件（设置适当权限）
chmod 600 ~/.aws/credentials
```

#### 避免硬编码
```go
// 错误做法
const (
    AccessKeyID     = "AKIA1234567890EXAMPLE"
    SecretAccessKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
)

// 正确做法
func getCredentials() (*Credentials, error) {
    accessKeyID := os.Getenv("AWS_ACCESS_KEY_ID")
    secretAccessKey := os.Getenv("AWS_SECRET_ACCESS_KEY")
    
    if accessKeyID == "" || secretAccessKey == "" {
        return nil, fmt.Errorf("缺少访问密钥配置")
    }
    
    return &Credentials{
        AccessKeyID:     accessKeyID,
        SecretAccessKey: secretAccessKey,
    }, nil
}
```

### 2. 密钥轮换策略

```go
// 定期轮换访问密钥
func rotateAccessKeys(client iamv1.IAMClient, userName string) error {
    ctx := context.Background()
    
    // 1. 创建新密钥
    newKey, err := client.CreateAccessKey(ctx, &iamv1.CreateAccessKeyRequest{
        UserName:    userName,
        Description: fmt.Sprintf("轮换密钥 %s", time.Now().Format("2006-01-02")),
    })
    if err != nil {
        return fmt.Errorf("创建新密钥失败: %v", err)
    }
    
    // 2. 更新应用配置（这里需要根据实际情况实现）
    if err := updateApplicationConfig(newKey.AccessKey); err != nil {
        return fmt.Errorf("更新应用配置失败: %v", err)
    }
    
    // 3. 等待配置生效
    time.Sleep(30 * time.Second)
    
    // 4. 删除旧密钥
    oldKeys, err := client.ListAccessKeys(ctx, &iamv1.ListAccessKeysRequest{
        UserName: userName,
        Status:   iamv1.AccessKeyStatus_ACCESS_KEY_STATUS_ACTIVE,
    })
    if err != nil {
        return fmt.Errorf("获取旧密钥失败: %v", err)
    }
    
    for _, key := range oldKeys.AccessKeys {
        if key.AccessKeyId != newKey.AccessKey.AccessKeyId {
            _, err := client.DeleteAccessKey(ctx, &iamv1.DeleteAccessKeyRequest{
                AccessKeyId: key.AccessKeyId,
            })
            if err != nil {
                log.Printf("删除旧密钥失败: %v", err)
            }
        }
    }
    
    return nil
}
```

### 3. 密钥使用监控

```go
// 监控访问密钥使用情况
func monitorAccessKeyUsage(client iamv1.IAMClient, userName string) {
    ctx := context.Background()
    
    keys, err := client.ListAccessKeys(ctx, &iamv1.ListAccessKeysRequest{
        UserName: userName,
    })
    if err != nil {
        log.Printf("获取访问密钥失败: %v", err)
        return
    }
    
    for _, key := range keys.AccessKeys {
        // 检查最后使用时间
        if key.LastUsedAt != nil {
            lastUsed := key.LastUsedAt.AsTime()
            if time.Since(lastUsed) > 30*24*time.Hour { // 30天未使用
                log.Printf("警告: 访问密钥 %s 已超过30天未使用", key.AccessKeyId)
            }
        }
        
        // 检查过期时间
        if key.ExpiresAt != nil {
            expiresAt := key.ExpiresAt.AsTime()
            if time.Until(expiresAt) < 7*24*time.Hour { // 7天内过期
                log.Printf("警告: 访问密钥 %s 将在7天内过期", key.AccessKeyId)
            }
        }
    }
}
```

### 4. 错误处理和重试

```go
// 带重试的访问密钥操作
func createAccessKeyWithRetry(client iamv1.IAMClient, req *iamv1.CreateAccessKeyRequest, maxRetries int) (*iamv1.CreateAccessKeyResponse, error) {
    var lastErr error
    
    for i := 0; i < maxRetries; i++ {
        resp, err := client.CreateAccessKey(context.Background(), req)
        if err == nil {
            return resp, nil
        }
        
        lastErr = err
        
        // 检查是否为可重试错误
        if status.Code(err) == codes.ResourceExhausted {
            // 达到密钥数量限制，不重试
            break
        }
        
        // 指数退避
        backoff := time.Duration(math.Pow(2, float64(i))) * time.Second
        time.Sleep(backoff)
    }
    
    return nil, fmt.Errorf("创建访问密钥失败，已重试%d次: %v", maxRetries, lastErr)
}
```

### 5. 访问密钥审计

```bash
#!/bin/bash

# 访问密钥审计脚本
SERVER="localhost:50051"
REPORT_FILE="access_key_audit_$(date +%Y%m%d).txt"

echo "=== 访问密钥审计报告 ===" > "$REPORT_FILE"
echo "生成时间: $(date)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# 获取所有用户
users=$(grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 1000
}' "$SERVER" iam.v1.IAM/ListUsers | jq -r '.users[].name')

echo "1. 用户访问密钥统计" >> "$REPORT_FILE"
echo "用户名,活跃密钥数,非活跃密钥数,总数" >> "$REPORT_FILE"

for user in $users; do
    # 获取用户的访问密钥
    keys=$(grpcurl -plaintext -d "{
        \"user_name\": \"$user\"
    }" "$SERVER" iam.v1.IAM/ListAccessKeys)
    
    active_count=$(echo "$keys" | jq '[.access_keys[] | select(.status == "ACCESS_KEY_STATUS_ACTIVE")] | length')
    inactive_count=$(echo "$keys" | jq '[.access_keys[] | select(.status == "ACCESS_KEY_STATUS_INACTIVE")] | length')
    total_count=$(echo "$keys" | jq '.access_keys | length')
    
    echo "$user,$active_count,$inactive_count,$total_count" >> "$REPORT_FILE"
done

echo >> "$REPORT_FILE"
echo "2. 长期未使用的访问密钥" >> "$REPORT_FILE"
echo "用户名,访问密钥ID,最后使用时间,天数" >> "$REPORT_FILE"

# 查找长期未使用的密钥（超过30天）
for user in $users; do
    keys=$(grpcurl -plaintext -d "{
        \"user_name\": \"$user\"
    }" "$SERVER" iam.v1.IAM/ListAccessKeys)
    
    echo "$keys" | jq -r --arg user "$user" '
        .access_keys[] | 
        select(.last_used_at != null) |
        select((now - (.last_used_at | fromdateiso8601)) > (30 * 24 * 3600)) |
        "\($user),\(.access_key_id),\(.last_used_at),\((now - (.last_used_at | fromdateiso8601)) / (24 * 3600) | floor)"
    ' >> "$REPORT_FILE"
done

echo "审计报告已生成: $REPORT_FILE"
```

## 🚨 注意事项

### 安全考虑

1. **密钥保护**：
   - 永远不要在代码中硬编码访问密钥
   - 使用环境变量或安全的配置管理系统
   - 设置适当的文件权限（600）

2. **密钥轮换**：
   - 定期轮换访问密钥（建议90天）
   - 监控密钥使用情况
   - 及时删除不使用的密钥

3. **访问控制**：
   - 遵循最小权限原则
   - 为不同用途创建不同的密钥
   - 定期审查密钥权限

### 性能优化

1. **连接复用**：
   - 使用连接池
   - 避免频繁创建连接
   - 设置合适的超时时间

2. **批量操作**：
   - 避免循环调用API
   - 使用分页查询大量数据
   - 合理控制并发数

### 错误处理

1. **重试策略**：
   - 实现指数退避重试
   - 区分可重试和不可重试错误
   - 设置最大重试次数

2. **监控告警**：
   - 监控API调用成功率
   - 设置密钥过期告警
   - 监控异常使用模式

---

::: tip 提示
建议为每个应用或服务创建独立的访问密钥，便于管理和审计。
:::

::: warning 注意
访问密钥的秘密部分只在创建时返回一次，请务必妥善保存。如果丢失，需要重新创建新的密钥。
:::