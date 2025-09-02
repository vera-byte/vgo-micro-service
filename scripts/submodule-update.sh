#!/bin/bash

# VGO微服务 - Submodule更新脚本
# 用于更新所有Git submodule到最新版本

set -e

echo "🔄 更新Git submodules..."

# 更新submodule到远程最新版本
git submodule update --remote --recursive

# 同步go.work
echo "🔧 同步Go workspace..."
go work sync

echo "✅ Submodule更新完成！"

# 显示submodule状态
echo "📊 Submodule状态："
git submodule status

# 检查是否有未提交的更改
echo ""
echo "🔍 检查主仓库状态："
if git diff --quiet && git diff --staged --quiet; then
    echo "✅ 主仓库工作区干净"
else
    echo "⚠️  主仓库有未提交的更改："
    git status --short
    echo ""
    echo "💡 提示：如果submodule更新后需要提交更改，请运行："
    echo "  git add ."
    echo "  git commit -m 'Update submodules'"
fi