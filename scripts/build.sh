#!/bin/bash

# 构建脚本 - 自动注入版本信息
# 功能：获取git信息并构建Docker镜像
# 参数：无
# 返回值：构建成功返回0，失败返回1

set -e

# 获取版本信息
VERSION=${VERSION:-$(git describe --tags --always --dirty 2>/dev/null || echo "v1.0.0")}
COMMIT=${COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")}
BUILD_TIME=${BUILD_TIME:-$(date -u '+%Y-%m-%d %H:%M:%S UTC')}

echo "构建信息:"
echo "  版本: $VERSION"
echo "  提交: $COMMIT"
echo "  构建时间: $BUILD_TIME"
echo ""

# 导出环境变量
export VERSION
export COMMIT
export BUILD_TIME

# 构建Docker镜像
echo "开始构建Docker镜像..."
docker-compose build vgo-iam

echo "构建完成！"
echo "使用以下命令启动服务:"
echo "  docker-compose up -d"