# VGO微服务 CI/CD 发布脚本

本目录包含VGO微服务项目的版本发布脚本和配置文件，用于统一管理 `vgo-kit`、`vgo-iam` 和 `vgo-gateway` 三个微服务的版本发布。

## 📁 文件结构

```
scripts/
├── release.sh          # 主发布脚本
├── release.config      # 发布配置文件
└── README.md          # 使用说明（本文件）
```

## 🚀 快速开始

### 1. 检查所有项目状态

```bash
./scripts/release.sh check-all
```

### 2. 发布单个项目

```bash
# 发布vgo-kit v1.0.0版本
./scripts/release.sh release vgo-kit v1.0.0

# 发布vgo-iam v1.0.0版本
./scripts/release.sh release vgo-iam v1.0.0

# 发布vgo-gateway v1.0.0版本
./scripts/release.sh release vgo-gateway v1.0.0
```

### 3. 发布所有项目

```bash
# 发布所有项目v1.0.0版本
./scripts/release.sh release-all v1.0.0
```

### 4. 列出所有项目

```bash
./scripts/release.sh list
```

## 📋 命令详解

### 基本命令

| 命令 | 描述 | 示例 |
|------|------|------|
| `release <project> <version>` | 发布指定项目的版本 | `./scripts/release.sh release vgo-kit v1.0.0` |
| `release-all <version>` | 发布所有项目的版本 | `./scripts/release.sh release-all v1.0.0` |
| `check <project>` | 检查指定项目状态 | `./scripts/release.sh check vgo-iam` |
| `check-all` | 检查所有项目状态 | `./scripts/release.sh check-all` |
| `list` | 列出所有项目及其状态 | `./scripts/release.sh list` |
| `help` | 显示帮助信息 | `./scripts/release.sh help` |

### 选项参数

| 选项 | 描述 | 示例 |
|------|------|------|
| `-h, --help` | 显示帮助信息 | `./scripts/release.sh --help` |
| `-v, --verbose` | 详细输出 | `./scripts/release.sh -v release-all v1.0.0` |
| `-d, --dry-run` | 模拟运行，不执行实际操作 | `./scripts/release.sh -d release vgo-kit v1.0.0` |
| `-f, --force` | 强制执行，跳过确认 | `./scripts/release.sh -f release-all v1.0.0` |

## 🔧 版本格式

支持的版本格式：
- `v1.0.0` - 正式版本
- `v1.0.0-beta` - Beta版本
- `v1.0.0-alpha.1` - Alpha版本
- `v1.0.0-rc.1` - Release Candidate版本

## 📦 发布流程

### 自动发布流程

1. **状态检查**
   - 检查Git工作目录是否干净
   - 检查是否在main分支
   - 检查是否与远程同步
   - 验证Go模块
   - 运行测试

2. **创建标签**
   - 创建Git标签
   - 推送标签到远程仓库

3. **触发CI/CD**
   - GitHub Actions自动触发
   - 运行测试和代码质量检查
   - 构建Docker镜像（vgo-iam和vgo-gateway）
   - 推送镜像到容器注册表
   - 创建GitHub Release

### 发布顺序

**重要：** 由于依赖关系，必须按以下顺序发布：

1. **vgo-kit** - 基础库，其他项目依赖它
2. **vgo-iam** - 身份认证服务
3. **vgo-gateway** - API网关服务

使用 `release-all` 命令会自动按正确顺序发布。

## 🐳 Docker镜像

发布成功后，Docker镜像将推送到GitHub Container Registry：

- `ghcr.io/vera-byte/vgo-iam:v1.0.0`
- `ghcr.io/vera-byte/vgo-gateway:v1.0.0`

注意：`vgo-kit` 是基础库，不构建Docker镜像。

## 🔍 GitHub Actions工作流

每个项目都有独立的CI/CD工作流：

### vgo-kit
- **CI**: `.github/workflows/ci.yml`
- **Release**: `.github/workflows/release.yml`
- 功能：测试、代码质量检查、安全扫描

### vgo-iam
- **CI**: `.github/workflows/ci.yml`
- **Release**: `.github/workflows/release.yml`
- 功能：测试、构建、Docker镜像构建和推送
- 依赖：PostgreSQL、Redis

### vgo-gateway
- **CI**: `.github/workflows/ci.yml`
- **Release**: `.github/workflows/release.yml`
- 功能：测试、构建、Docker镜像构建和推送
- 依赖：Redis

### 统一发布工作流
- **Release All**: `.github/workflows/release-all.yml`
- 功能：协调所有服务的发布，确保正确的发布顺序

## 🛠️ 使用GitHub Actions统一发布

### 方式1：推送release分支

```bash
# 创建release分支
git checkout -b release/v1.0.0
git push origin release/v1.0.0
```

### 方式2：手动触发

1. 访问GitHub仓库的Actions页面
2. 选择"Release All Services"工作流
3. 点击"Run workflow"
4. 填写参数：
   - **Version**: `v1.0.0`
   - **Services**: `all` 或 `vgo-kit,vgo-iam`
   - **Skip tests**: `false`
   - **Dry run**: `false`

## ⚠️ 注意事项

### 发布前检查

1. **确保所有更改已提交并推送**
   ```bash
   git status
   git push origin main
   ```

2. **确保在main分支**
   ```bash
   git branch --show-current
   ```

3. **确保测试通过**
   ```bash
   ./scripts/release.sh check-all
   ```

### 依赖关系

- `vgo-iam` 和 `vgo-gateway` 依赖 `vgo-kit`
- 必须先发布 `vgo-kit`，再发布其他服务
- 使用 `release-all` 命令可自动处理依赖顺序

### 回滚

如果发布出现问题，可以：

1. **删除错误的标签**
   ```bash
   git tag -d v1.0.0
   git push origin :refs/tags/v1.0.0
   ```

2. **停止GitHub Actions工作流**
   - 访问Actions页面
   - 取消正在运行的工作流

3. **回滚Docker镜像**
   - 使用之前的镜像版本重新部署

## 🔧 配置文件

`release.config` 文件包含发布脚本的默认配置，可以根据需要修改：

- 项目列表和发布顺序
- Git和Docker配置
- 通知设置
- 超时和重试配置
- 安全和监控配置

## 📞 支持

如果在使用过程中遇到问题：

1. 查看脚本的详细输出：`./scripts/release.sh -v <command>`
2. 使用模拟模式测试：`./scripts/release.sh -d <command>`
3. 查看GitHub Actions的日志
4. 联系开发团队

## 📝 更新日志

- **v1.0.0** - 初始版本，支持基本的发布功能
  - 支持单个项目和批量发布
  - 集成GitHub Actions
  - 支持Docker镜像构建和推送
  - 完整的状态检查和验证