#!/bin/bash

# VGO微服务 - Submodule初始化脚本
# 用于初始化和更新所有Git submodule

set -e

echo "🚀 初始化Git submodules..."

# 初始化submodule
git submodule init

# 更新submodule到最新提交
git submodule update --recursive

echo "✅ Submodule初始化完成！"

# 显示submodule状态
echo "📊 Submodule状态："
git submodule status

echo ""
echo "💡 提示："
echo "  - 使用 'git submodule update --remote' 更新submodule到远程最新版本"
echo "  - 使用 'git submodule foreach git pull origin main' 拉取所有submodule的最新更改"
echo "  - 使用 './scripts/submodule-update.sh' 更新所有submodule"