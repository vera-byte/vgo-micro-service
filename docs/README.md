---
home: true
heroImage: /logo.png
heroText: VGO微服务
tagline: 企业级微服务架构解决方案
actionText: 快速开始 →
actionLink: /guide/
features:
- title: 🚀 高性能
  details: 基于Go语言开发，采用gRPC通信协议，提供高性能的微服务解决方案
- title: 🔒 安全可靠
  details: 完整的IAM身份认证与授权系统，支持细粒度权限控制和访问密钥管理
- title: 📊 可观测性
  details: 集成Prometheus监控、Jaeger链路追踪和结构化日志，提供全方位的系统观测能力
- title: 🐳 云原生
  details: 支持Docker容器化部署和Kubernetes编排，完美适配云原生环境
- title: 🔧 易于扩展
  details: 模块化设计，支持水平扩展，可根据业务需求灵活调整服务规模
- title: 📱 多端支持
  details: 支持Web、移动端、API等多种应用类型，提供统一的身份认证服务
footer: MIT Licensed | Copyright © 2024 VGO Team
---

## 🎯 项目概述

VGO是一个现代化的微服务架构解决方案，专注于提供企业级的身份认证与授权管理（IAM）服务。项目采用Go语言开发，基于gRPC协议提供高性能的服务间通信，支持云原生部署。

## ✨ 核心特性

### 🔐 身份认证与授权
- **用户管理**: 完整的用户生命周期管理
- **策略管理**: 灵活的权限策略配置
- **访问密钥**: 安全的API访问密钥管理
- **应用管理**: OAuth2应用注册与管理
- **开发者认证**: 个人和企业开发者身份验证

### 🏗️ 技术架构
- **微服务架构**: 模块化设计，服务间解耦
- **gRPC通信**: 高性能的服务间通信协议
- **PostgreSQL**: 可靠的关系型数据库存储
- **Redis缓存**: 高性能的缓存解决方案
- **容器化部署**: Docker和Kubernetes支持

### 📈 监控与运维
- **Prometheus监控**: 全面的系统指标监控
- **Jaeger追踪**: 分布式链路追踪
- **结构化日志**: 便于分析的日志格式
- **健康检查**: 服务健康状态监控

## 🚀 快速体验

```bash
# 克隆项目
git clone https://github.com/vera-byte/vgo_micro_service.git
cd vgo_micro_service

# 启动服务
docker-compose up -d

# 访问调试界面
open http://localhost:8080
```

## 📚 文档导航

- [快速开始](/guide/) - 了解如何安装和配置VGO
- [API文档](/api/) - 详细的API接口说明
- [部署指南](/deployment/) - 生产环境部署指导
- [开发指南](/development/) - 参与项目开发的指南

## 🤝 社区支持

- **GitHub**: [https://github.com/vera-byte/vgo_micro_service](https://github.com/vera-byte/vgo_micro_service)
- **Issues**: 问题反馈和功能建议
- **Discussions**: 技术讨论和经验分享

---

::: tip 提示
本文档基于VGO v1.2.0版本编写，如果您使用的是其他版本，请参考对应版本的文档。
:::