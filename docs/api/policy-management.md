# 策略管理 API

策略管理API提供了完整的权限策略生命周期管理功能，包括策略的创建、查询、更新、删除以及策略与用户的绑定关系管理。

## 📋 API 概览

| 方法 | 描述 | 权限要求 |
|------|------|----------|
| `CreatePolicy` | 创建新策略 | `iam:CreatePolicy` |
| `GetPolicy` | 获取策略信息 | `iam:GetPolicy` |
| `UpdatePolicy` | 更新策略信息 | `iam:UpdatePolicy` |
| `DeletePolicy` | 删除策略 | `iam:DeletePolicy` |
| `ListPolicies` | 获取策略列表 | `iam:ListPolicies` |
| `AttachUserPolicy` | 绑定策略到用户 | `iam:AttachUserPolicy` |
| `DetachUserPolicy` | 解绑用户策略 | `iam:DetachUserPolicy` |

## 🔧 API 详情

### CreatePolicy - 创建策略

创建一个新的权限策略。

#### 请求

```protobuf
message CreatePolicyRequest {
  string name = 1;              // 策略名称（必需，唯一）
  string description = 2;       // 策略描述（可选）
  string policy_document = 3;   // 策略文档JSON（必需）
  repeated string tags = 4;     // 策略标签（可选）
}
```

#### 响应

```protobuf
message CreatePolicyResponse {
  Policy policy = 1;            // 创建的策略信息
}
```

#### 示例

```bash
# 创建只读策略
grpcurl -plaintext -d '{
  "name": "ReadOnlyPolicy",
  "description": "只读权限策略",
  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}",
  "tags": ["readonly", "basic"]
}' localhost:50051 iam.v1.IAM/CreatePolicy
```

```bash
# 创建管理员策略
grpcurl -plaintext -d '{
  "name": "AdminPolicy",
  "description": "管理员完全权限策略",
  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"*\"],\"Resource\":[\"*\"]}]}",
  "tags": ["admin", "full-access"]
}' localhost:50051 iam.v1.IAM/CreatePolicy
```

#### 响应示例

```json
{
  "policy": {
    "id": "pol-123456",
    "name": "ReadOnlyPolicy",
    "description": "只读权限策略",
    "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}",
    "tags": ["readonly", "basic"],
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 策略名称为空或策略文档格式错误 | 提供有效的策略名称和JSON文档 |
| `ALREADY_EXISTS` | 策略名称已存在 | 使用不同的策略名称 |
| `PERMISSION_DENIED` | 无创建策略权限 | 确保有`iam:CreatePolicy`权限 |

---

### GetPolicy - 获取策略信息

根据策略名称或策略ID获取策略详细信息。

#### 请求

```protobuf
message GetPolicyRequest {
  oneof identifier {
    string name = 1;    // 策略名称
    string id = 2;      // 策略ID
  }
}
```

#### 响应

```protobuf
message GetPolicyResponse {
  Policy policy = 1;        // 策略信息
}
```

#### 示例

```bash
# 通过策略名称获取
grpcurl -plaintext -d '{
  "name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/GetPolicy
```

```bash
# 通过策略ID获取
grpcurl -plaintext -d '{
  "id": "pol-123456"
}' localhost:50051 iam.v1.IAM/GetPolicy
```

#### 响应示例

```json
{
  "policy": {
    "id": "pol-123456",
    "name": "ReadOnlyPolicy",
    "description": "只读权限策略",
    "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}",
    "tags": ["readonly", "basic"],
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "attached_users_count": 5
  }
}
```

---

### UpdatePolicy - 更新策略信息

更新现有策略的信息。

#### 请求

```protobuf
message UpdatePolicyRequest {
  oneof identifier {
    string name = 1;              // 策略名称
    string id = 2;                // 策略ID
  }
  string description = 3;         // 新的描述（可选）
  string policy_document = 4;     // 新的策略文档（可选）
  repeated string tags = 5;       // 新的标签（可选）
  google.protobuf.FieldMask update_mask = 6;  // 更新字段掩码
}
```

#### 响应

```protobuf
message UpdatePolicyResponse {
  Policy policy = 1;              // 更新后的策略信息
}
```

#### 示例

```bash
# 更新策略描述
grpcurl -plaintext -d '{
  "name": "ReadOnlyPolicy",
  "description": "更新后的只读权限策略描述",
  "update_mask": {
    "paths": ["description"]
  }
}' localhost:50051 iam.v1.IAM/UpdatePolicy
```

```bash
# 更新策略文档
grpcurl -plaintext -d '{
  "id": "pol-123456",
  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\",\"iam:GetApplication\"],\"Resource\":[\"*\"]}]}",
  "update_mask": {
    "paths": ["policy_document"]
  }
}' localhost:50051 iam.v1.IAM/UpdatePolicy
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `INVALID_ARGUMENT` | 无效的策略文档格式 | 检查JSON语法和策略结构 |
| `NOT_FOUND` | 策略不存在 | 确认策略标识符正确 |
| `PERMISSION_DENIED` | 无更新策略权限 | 确保有`iam:UpdatePolicy`权限 |

---

### DeletePolicy - 删除策略

删除指定的策略。

::: warning 注意
删除策略前会自动解绑所有关联的用户。
:::

#### 请求

```protobuf
message DeletePolicyRequest {
  oneof identifier {
    string name = 1;    // 策略名称
    string id = 2;      // 策略ID
  }
  bool force = 3;       // 强制删除（即使有用户绑定）
}
```

#### 响应

```protobuf
message DeletePolicyResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 删除策略
grpcurl -plaintext -d '{
  "name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/DeletePolicy
```

```bash
# 强制删除策略（自动解绑用户）
grpcurl -plaintext -d '{
  "id": "pol-123456",
  "force": true
}' localhost:50051 iam.v1.IAM/DeletePolicy
```

---

### ListPolicies - 获取策略列表

获取系统中的策略列表，支持分页和过滤。

#### 请求

```protobuf
message ListPoliciesRequest {
  int32 page = 1;           // 页码（从1开始）
  int32 page_size = 2;      // 每页大小（最大100）
  string filter = 3;        // 过滤条件
  string order_by = 4;      // 排序字段
  bool desc = 5;            // 是否降序
}
```

#### 过滤条件

支持的过滤字段：
- `name`: 策略名称（支持模糊匹配）
- `description`: 策略描述（支持模糊匹配）
- `tags`: 策略标签
- `created_after`: 创建时间之后
- `created_before`: 创建时间之前

#### 示例

```bash
# 获取所有策略
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 20
}' localhost:50051 iam.v1.IAM/ListPolicies
```

```bash
# 按标签过滤
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 10,
  "filter": "tags CONTAINS readonly"
}' localhost:50051 iam.v1.IAM/ListPolicies
```

#### 响应示例

```json
{
  "policies": [
    {
      "id": "pol-123456",
      "name": "ReadOnlyPolicy",
      "description": "只读权限策略",
      "tags": ["readonly", "basic"],
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "attached_users_count": 5
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_count": 10,
    "total_pages": 1
  }
}
```

---

### AttachUserPolicy - 绑定策略到用户

将策略绑定到指定用户。

#### 请求

```protobuf
message AttachUserPolicyRequest {
  string user_name = 1;     // 用户名（必需）
  string policy_name = 2;   // 策略名称（必需）
}
```

#### 响应

```protobuf
message AttachUserPolicyResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 绑定只读策略到用户
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "policy_name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/AttachUserPolicy
```

```bash
# 绑定管理员策略到用户
grpcurl -plaintext -d '{
  "user_name": "admin_user",
  "policy_name": "AdminPolicy"
}' localhost:50051 iam.v1.IAM/AttachUserPolicy
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 用户或策略不存在 | 确认用户名和策略名正确 |
| `ALREADY_EXISTS` | 策略已绑定到用户 | 无需重复绑定 |
| `PERMISSION_DENIED` | 无绑定策略权限 | 确保有`iam:AttachUserPolicy`权限 |

---

### DetachUserPolicy - 解绑用户策略

从用户解绑指定策略。

#### 请求

```protobuf
message DetachUserPolicyRequest {
  string user_name = 1;     // 用户名（必需）
  string policy_name = 2;   // 策略名称（必需）
}
```

#### 响应

```protobuf
message DetachUserPolicyResponse {
  // 空响应，成功时无返回内容
}
```

#### 示例

```bash
# 解绑用户策略
grpcurl -plaintext -d '{
  "user_name": "john_doe",
  "policy_name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/DetachUserPolicy
```

#### 错误情况

| 错误码 | 说明 | 解决方案 |
|--------|------|----------|
| `NOT_FOUND` | 用户、策略不存在或未绑定 | 确认绑定关系存在 |
| `PERMISSION_DENIED` | 无解绑策略权限 | 确保有`iam:DetachUserPolicy`权限 |

## 📊 数据模型

### Policy 对象

```protobuf
message Policy {
  string id = 1;                    // 策略ID（系统生成）
  string name = 2;                  // 策略名称（唯一）
  string description = 3;           // 策略描述
  string policy_document = 4;       // 策略文档JSON
  repeated string tags = 5;         // 策略标签
  google.protobuf.Timestamp created_at = 6;     // 创建时间
  google.protobuf.Timestamp updated_at = 7;     // 更新时间
  int32 attached_users_count = 8;   // 绑定用户数量
}
```

## 🔐 策略文档语法

### 基本结构

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
      "Resource": ["*"],
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    }
  ]
}
```

### 字段说明

#### Version
策略语言版本，当前支持 `"2025-01-01"`。

#### Statement
权限声明数组，每个声明包含以下字段：

- **Effect**: 权限效果
  - `"Allow"`: 允许
  - `"Deny"`: 拒绝

- **Action**: 操作列表
  - 支持通配符 `*`
  - 支持前缀匹配 `iam:*`
  - 具体操作 `iam:GetUser`

- **Resource**: 资源列表
  - 支持通配符 `*`
  - ARN格式 `arn:iam::user/john_doe`
  - 变量替换 `arn:iam::user/${aws:username}`

- **Condition**: 条件约束（可选）
  - 支持多种条件操作符
  - 支持上下文变量

### 常用策略模板

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
        "iam:Get*",
        "iam:List*"
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
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:ApplicationOwner": "${aws:username}"
        }
      }
    }
  ]
}
```

#### 5. 时间限制策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*",
      "Condition": {
        "DateGreaterThan": {
          "aws:CurrentTime": "2024-01-01T00:00:00Z"
        },
        "DateLessThan": {
          "aws:CurrentTime": "2024-12-31T23:59:59Z"
        }
      }
    }
  ]
}
```

#### 6. IP限制策略

```json
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "192.168.1.0/24",
            "10.0.0.0/8"
          ]
        }
      }
    }
  ]
}
```

### 条件操作符

| 操作符 | 说明 | 示例 |
|--------|------|------|
| `StringEquals` | 字符串相等 | `"aws:username": "john"` |
| `StringLike` | 字符串模式匹配 | `"aws:userid": "user-*"` |
| `NumericEquals` | 数值相等 | `"aws:TokenIssueTime": "1234567890"` |
| `NumericLessThan` | 数值小于 | `"aws:MultiFactorAuthAge": "3600"` |
| `DateGreaterThan` | 日期大于 | `"aws:CurrentTime": "2024-01-01T00:00:00Z"` |
| `DateLessThan` | 日期小于 | `"aws:CurrentTime": "2024-12-31T23:59:59Z"` |
| `IpAddress` | IP地址匹配 | `"aws:SourceIp": "192.168.1.0/24"` |
| `Bool` | 布尔值 | `"aws:SecureTransport": "true"` |

### 上下文变量

| 变量 | 说明 | 示例值 |
|------|------|--------|
| `${aws:username}` | 当前用户名 | `john_doe` |
| `${aws:userid}` | 当前用户ID | `user-123456` |
| `${aws:SourceIp}` | 请求来源IP | `192.168.1.100` |
| `${aws:CurrentTime}` | 当前时间 | `2024-01-01T12:00:00Z` |
| `${aws:SecureTransport}` | 是否使用HTTPS | `true` |
| `${aws:RequestedRegion}` | 请求区域 | `us-east-1` |

## 🛠️ 使用示例

### Go 客户端示例

```go
package main

import (
    "context"
    "encoding/json"
    "fmt"
    "log"
    
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
    
    iamv1 "github.com/your-org/vgo/api/iam/v1"
)

type PolicyDocument struct {
    Version   string      `json:"Version"`
    Statement []Statement `json:"Statement"`
}

type Statement struct {
    Effect   string   `json:"Effect"`
    Action   []string `json:"Action"`
    Resource []string `json:"Resource"`
}

func main() {
    // 连接到服务
    conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        log.Fatalf("连接失败: %v", err)
    }
    defer conn.Close()
    
    client := iamv1.NewIAMClient(conn)
    ctx := context.Background()
    
    // 创建策略文档
    policyDoc := PolicyDocument{
        Version: "2025-01-01",
        Statement: []Statement{
            {
                Effect:   "Allow",
                Action:   []string{"iam:GetUser", "iam:ListUsers"},
                Resource: []string{"*"},
            },
        },
    }
    
    policyJSON, err := json.Marshal(policyDoc)
    if err != nil {
        log.Fatalf("序列化策略文档失败: %v", err)
    }
    
    // 创建策略
    createResp, err := client.CreatePolicy(ctx, &iamv1.CreatePolicyRequest{
        Name:           "TestReadOnlyPolicy",
        Description:    "测试只读策略",
        PolicyDocument: string(policyJSON),
        Tags:           []string{"test", "readonly"},
    })
    if err != nil {
        log.Fatalf("创建策略失败: %v", err)
    }
    fmt.Printf("策略创建成功: %v\n", createResp.Policy)
    
    // 绑定策略到用户
    _, err = client.AttachUserPolicy(ctx, &iamv1.AttachUserPolicyRequest{
        UserName:   "test_user",
        PolicyName: "TestReadOnlyPolicy",
    })
    if err != nil {
        log.Fatalf("绑定策略失败: %v", err)
    }
    fmt.Println("策略绑定成功")
    
    // 获取策略列表
    listResp, err := client.ListPolicies(ctx, &iamv1.ListPoliciesRequest{
        Page:     1,
        PageSize: 10,
        Filter:   "tags CONTAINS test",
    })
    if err != nil {
        log.Fatalf("获取策略列表失败: %v", err)
    }
    fmt.Printf("策略列表: %v\n", listResp.Policies)
    
    // 解绑策略
    _, err = client.DetachUserPolicy(ctx, &iamv1.DetachUserPolicyRequest{
        UserName:   "test_user",
        PolicyName: "TestReadOnlyPolicy",
    })
    if err != nil {
        log.Fatalf("解绑策略失败: %v", err)
    }
    fmt.Println("策略解绑成功")
    
    // 删除策略
    _, err = client.DeletePolicy(ctx, &iamv1.DeletePolicyRequest{
        Identifier: &iamv1.DeletePolicyRequest_Name{Name: "TestReadOnlyPolicy"},
    })
    if err != nil {
        log.Fatalf("删除策略失败: %v", err)
    }
    fmt.Println("策略删除成功")
}
```

### 批量策略管理脚本

```bash
#!/bin/bash

# 批量创建策略脚本
POLICIES_DIR="policies"
SERVER="localhost:50051"

# 创建策略目录
mkdir -p "$POLICIES_DIR"

# 创建只读策略文件
cat > "$POLICIES_DIR/readonly.json" << 'EOF'
{
  "Version": "2025-01-01",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:Get*",
        "iam:List*"
      ],
      "Resource": "*"
    }
  ]
}
EOF

# 创建用户管理策略文件
cat > "$POLICIES_DIR/user-management.json" << 'EOF'
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
EOF

# 批量创建策略
for policy_file in "$POLICIES_DIR"/*.json; do
    policy_name=$(basename "$policy_file" .json)
    policy_content=$(cat "$policy_file" | jq -c .)
    
    echo "创建策略: $policy_name"
    grpcurl -plaintext -d "{
        \"name\": \"${policy_name}\",
        \"description\": \"从文件 ${policy_file} 创建的策略\",
        \"policy_document\": \"$(echo $policy_content | sed 's/"/\\"/g')\"
    }" "$SERVER" iam.v1.IAM/CreatePolicy
    
    if [ $? -eq 0 ]; then
        echo "策略 $policy_name 创建成功"
    else
        echo "策略 $policy_name 创建失败"
    fi
    
    sleep 0.1
done

echo "批量策略创建完成"
```

### 策略验证工具

```python
import json
import jsonschema
from jsonschema import validate

# 策略文档JSON Schema
policy_schema = {
    "type": "object",
    "properties": {
        "Version": {
            "type": "string",
            "enum": ["2025-01-01"]
        },
        "Statement": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "Effect": {
                        "type": "string",
                        "enum": ["Allow", "Deny"]
                    },
                    "Action": {
                        "oneOf": [
                            {"type": "string"},
                            {
                                "type": "array",
                                "items": {"type": "string"}
                            }
                        ]
                    },
                    "Resource": {
                        "oneOf": [
                            {"type": "string"},
                            {
                                "type": "array",
                                "items": {"type": "string"}
                            }
                        ]
                    },
                    "Condition": {
                        "type": "object"
                    }
                },
                "required": ["Effect", "Action", "Resource"]
            }
        }
    },
    "required": ["Version", "Statement"]
}

def validate_policy(policy_document):
    """验证策略文档格式"""
    try:
        policy = json.loads(policy_document)
        validate(instance=policy, schema=policy_schema)
        return True, "策略文档格式正确"
    except json.JSONDecodeError as e:
        return False, f"JSON格式错误: {e}"
    except jsonschema.exceptions.ValidationError as e:
        return False, f"策略格式错误: {e.message}"
    except Exception as e:
        return False, f"验证失败: {e}"

# 使用示例
if __name__ == "__main__":
    # 测试策略文档
    test_policy = '''
    {
        "Version": "2025-01-01",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": ["iam:GetUser", "iam:ListUsers"],
                "Resource": "*"
            }
        ]
    }
    '''
    
    is_valid, message = validate_policy(test_policy)
    print(f"验证结果: {message}")
```

## 🔍 最佳实践

### 1. 策略命名规范

- 使用描述性名称
- 遵循一致的命名约定
- 包含策略用途和范围

```bash
# 好的策略名称示例
"ReadOnlyPolicy"
"UserManagementPolicy"
"ApplicationDeveloperPolicy"
"AdminFullAccessPolicy"

# 避免的策略名称
"Policy1"
"Test"
"Temp"
```

### 2. 最小权限原则

```json
// 好的做法：具体的权限
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

// 避免：过于宽泛的权限
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

### 3. 策略版本管理

```bash
# 创建策略时包含版本信息
grpcurl -plaintext -d '{
  "name": "ReadOnlyPolicy_v2",
  "description": "只读策略 v2.0 - 增加应用查看权限",
  "policy_document": "...",
  "tags": ["readonly", "v2"]
}' localhost:50051 iam.v1.IAM/CreatePolicy
```

### 4. 策略测试

```bash
# 创建测试用户
grpcurl -plaintext -d '{
  "name": "test_policy_user",
  "display_name": "Policy Test User",
  "email": "test@example.com"
}' localhost:50051 iam.v1.IAM/CreateUser

# 绑定策略
grpcurl -plaintext -d '{
  "user_name": "test_policy_user",
  "policy_name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/AttachUserPolicy

# 测试权限
grpcurl -plaintext -d '{
  "user_name": "test_policy_user",
  "action": "iam:GetUser",
  "resource": "*"
}' localhost:50051 iam.v1.IAM/CheckPermission

# 清理测试数据
grpcurl -plaintext -d '{
  "user_name": "test_policy_user",
  "policy_name": "ReadOnlyPolicy"
}' localhost:50051 iam.v1.IAM/DetachUserPolicy

grpcurl -plaintext -d '{
  "name": "test_policy_user"
}' localhost:50051 iam.v1.IAM/DeleteUser
```

### 5. 策略审计

```bash
#!/bin/bash

# 策略审计脚本
echo "=== 策略审计报告 ==="
echo "生成时间: $(date)"
echo

# 获取所有策略
echo "1. 策略总数统计"
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 1000
}' localhost:50051 iam.v1.IAM/ListPolicies | jq '.pagination.total_count'

echo
echo "2. 未绑定用户的策略"
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 1000
}' localhost:50051 iam.v1.IAM/ListPolicies | jq '.policies[] | select(.attached_users_count == 0) | .name'

echo
echo "3. 使用通配符权限的策略"
grpcurl -plaintext -d '{
  "page": 1,
  "page_size": 1000
}' localhost:50051 iam.v1.IAM/ListPolicies | jq '.policies[] | select(.policy_document | contains("\"*\"")) | .name'

echo
echo "审计完成"
```

## 🚨 注意事项

### 安全考虑

1. **策略文档安全**：
   - 避免在策略中硬编码敏感信息
   - 使用变量替换而非具体值
   - 定期审查策略权限

2. **权限控制**：
   - 遵循最小权限原则
   - 避免使用过于宽泛的通配符
   - 定期清理不使用的策略

3. **策略冲突**：
   - Deny优先于Allow
   - 明确的权限优先于通配符
   - 避免策略间的冲突

### 性能优化

1. **策略缓存**：
   - 缓存频繁使用的策略
   - 设置合适的缓存过期时间
   - 及时更新缓存

2. **批量操作**：
   - 使用批量绑定/解绑操作
   - 避免频繁的单个操作
   - 合理控制并发数

---

::: tip 提示
建议为不同角色创建标准化的策略模板，便于统一管理和维护。
:::

::: warning 注意
策略更新会立即生效，请在生产环境中谨慎操作，建议先在测试环境验证。
:::