#!/bin/bash

# VGO微服务 - Submodule同步脚本
# 用于同步所有submodule的更改并推送到远程仓库

set -e

echo "🔄 同步所有submodule更改..."

# 遍历所有submodule
git submodule foreach '
    echo "📦 处理submodule: $name"
    
    # 检查是否有未提交的更改
    if ! git diff --quiet || ! git diff --staged --quiet; then
        echo "⚠️  发现未提交的更改，请先提交或暂存更改"
        git status --short
        exit 1
    fi
    
    # 拉取最新更改
    echo "⬇️  拉取最新更改..."
    git pull origin $(git branch --show-current)
    
    # 推送更改（如果有的话）
    if git log origin/$(git branch --show-current)..HEAD --oneline | grep -q "."; then
        echo "⬆️  推送本地更改..."
        git push origin $(git branch --show-current)
    else
        echo "✅ 无需推送，已是最新版本"
    fi
'

echo ""
echo "🔧 更新主仓库的submodule引用..."
git submodule update --remote --recursive

# 同步go.work
echo "🔧 同步Go workspace..."
go work sync

echo "✅ 所有submodule同步完成！"

# 检查主仓库是否需要提交submodule更新
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo ""
    echo "📝 主仓库有submodule更新需要提交："
    git status --short
    echo ""
    echo "💡 提示：运行以下命令提交submodule更新："
    echo "  git add ."
    echo "  git commit -m 'Update submodules to latest versions'"
    echo "  git push origin main"
else
    echo "✅ 主仓库无需更新"
fi