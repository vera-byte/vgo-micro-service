# 国际化 (i18n) 使用指南

本指南介绍如何在 VGO IAM 服务中使用国际化功能。

## 概述

VGO IAM 服务支持多语言国际化，目前支持以下语言：

- 英语 (en) - 默认语言
- 中文 (zh)
- 日语 (ja)
- 韩语 (ko)

## 功能特性

### 1. 自动语言检测

服务会自动从以下来源检测客户端语言偏好：

- gRPC metadata 中的 `accept-language` 头部
- HTTP Accept-Language 头部（如果通过网关访问）

### 2. 错误消息国际化

所有 API 错误消息都支持多语言，包括：

- 用户相关错误（用户不存在、用户已存在等）
- 策略相关错误（策略不存在、策略无效等）
- 访问密钥相关错误（密钥无效、密钥过期等）
- 权限相关错误（权限拒绝、无效操作等）

### 3. 成功消息国际化

API 成功响应消息也支持多语言，包括：

- 用户创建成功
- 策略创建成功
- 访问密钥创建成功
- 等等

## 使用方法

### 客户端设置语言

#### gRPC 客户端

```go
package main

import (
    "context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/metadata"
)

func main() {
    // 创建连接
    conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()
    
    // 设置语言偏好
    ctx := metadata.AppendToOutgoingContext(
        context.Background(),
        "accept-language", "zh-CN,zh;q=0.9,en;q=0.8",
    )
    
    // 调用 API
    client := iamv1.NewIAMClient(conn)
    resp, err := client.GetUser(ctx, &iamv1.GetUserRequest{
        UserName: "testuser",
    })
    
    // 错误消息将以中文返回
    if err != nil {
        log.Printf("错误: %v", err)
    }
}
```

#### HTTP 客户端（通过网关）

```bash
# 设置 Accept-Language 头部
curl -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" \
     -X GET http://localhost:8080/api/v1/users/testuser
```

### 支持的语言代码

| 语言 | 代码 | Accept-Language 示例 |
|------|------|----------------------|
| 英语 | en   | `en-US,en;q=0.9` |
| 中文 | zh   | `zh-CN,zh;q=0.9` |
| 日语 | ja   | `ja-JP,ja;q=0.9` |
| 韩语 | ko   | `ko-KR,ko;q=0.9` |

## 翻译文件结构

翻译文件位于 `locales/` 目录下，采用 JSON 格式：

```
locales/
├── en.json    # 英语翻译
├── zh.json    # 中文翻译
├── ja.json    # 日语翻译
└── ko.json    # 韩语翻译
```

### 翻译文件格式

```json
{
  "success": {
    "user_created": "用户创建成功",
    "policy_created": "策略创建成功"
  },
  "error.user.not_found": "用户不存在",
  "error.user.already_exists": "用户已存在",
  "error.policy.invalid": "无效的策略文档"
}
```

## 开发指南

### 添加新的翻译键

1. 在所有语言文件中添加新的翻译键
2. 在代码中使用翻译键而不是硬编码文本

```go
// 错误示例 - 硬编码文本
return status.Error(codes.NotFound, "User not found")

// 正确示例 - 使用翻译键
return s.translateError(ctx, codes.NotFound, "error.user.not_found")
```

### 添加新语言支持

1. 在 `vgo-kit/i18n/i18n.go` 中添加新的语言常量：

```go
const (
    LanguageFrench SupportedLanguage = "fr"
)
```

2. 更新 `ParseAcceptLanguage` 函数以支持新语言

3. 创建新的翻译文件 `locales/fr.json`

4. 在 `LoadTranslations` 函数中添加新语言到支持列表

### 测试国际化功能

运行国际化测试：

```bash
cd vgo-iam
go test ./test/i18n_test.go -v
```

测试包括：
- 翻译功能测试
- 语言检测测试
- 上下文语言传递测试

## 最佳实践

### 1. 翻译键命名规范

- 使用点号分隔的层次结构：`error.user.not_found`
- 使用描述性名称：`validation.min_length`
- 保持一致的命名模式

### 2. 错误处理

- 始终使用翻译键而不是硬编码文本
- 为所有支持的语言提供翻译
- 提供有意义的错误上下文

### 3. 回退机制

- 如果请求的语言不支持，自动回退到英语
- 如果翻译键不存在，返回键本身作为回退

## 故障排除

### 常见问题

1. **翻译不生效**
   - 检查 Accept-Language 头部格式
   - 确认翻译文件存在且格式正确
   - 验证翻译键是否正确

2. **语言检测失败**
   - 确认客户端正确设置了 Accept-Language 头部
   - 检查语言代码是否在支持列表中

3. **翻译文件加载失败**
   - 检查文件路径和权限
   - 验证 JSON 格式是否正确
   - 查看服务启动日志

### 调试技巧

1. 启用详细日志查看翻译加载过程
2. 使用测试工具验证不同语言的响应
3. 检查 gRPC metadata 是否正确传递

## 性能考虑

- 翻译文件在服务启动时一次性加载到内存
- 翻译查找是 O(1) 时间复杂度
- 支持并发访问，使用读写锁保护

## 安全注意事项

- 翻译文件不应包含敏感信息
- 验证用户输入的语言代码以防止注入攻击
- 限制支持的语言列表以减少攻击面