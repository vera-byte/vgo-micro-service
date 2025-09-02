<template><div><h2 id="🎯-项目概述" tabindex="-1"><a class="header-anchor" href="#🎯-项目概述">#</a> 🎯 项目概述</h2>
<p>VGO是一个现代化的微服务架构解决方案，专注于提供企业级的身份认证与授权管理（IAM）服务。项目采用Go语言开发，基于gRPC协议提供高性能的服务间通信，支持云原生部署。</p>
<h2 id="✨-核心特性" tabindex="-1"><a class="header-anchor" href="#✨-核心特性">#</a> ✨ 核心特性</h2>
<h3 id="🔐-身份认证与授权" tabindex="-1"><a class="header-anchor" href="#🔐-身份认证与授权">#</a> 🔐 身份认证与授权</h3>
<ul>
<li><strong>用户管理</strong>: 完整的用户生命周期管理</li>
<li><strong>策略管理</strong>: 灵活的权限策略配置</li>
<li><strong>访问密钥</strong>: 安全的API访问密钥管理</li>
<li><strong>应用管理</strong>: OAuth2应用注册与管理</li>
<li><strong>开发者认证</strong>: 个人和企业开发者身份验证</li>
</ul>
<h3 id="🏗️-技术架构" tabindex="-1"><a class="header-anchor" href="#🏗️-技术架构">#</a> 🏗️ 技术架构</h3>
<ul>
<li><strong>微服务架构</strong>: 模块化设计，服务间解耦</li>
<li><strong>gRPC通信</strong>: 高性能的服务间通信协议</li>
<li><strong>PostgreSQL</strong>: 可靠的关系型数据库存储</li>
<li><strong>Redis缓存</strong>: 高性能的缓存解决方案</li>
<li><strong>容器化部署</strong>: Docker和Kubernetes支持</li>
</ul>
<h3 id="📈-监控与运维" tabindex="-1"><a class="header-anchor" href="#📈-监控与运维">#</a> 📈 监控与运维</h3>
<ul>
<li><strong>Prometheus监控</strong>: 全面的系统指标监控</li>
<li><strong>Jaeger追踪</strong>: 分布式链路追踪</li>
<li><strong>结构化日志</strong>: 便于分析的日志格式</li>
<li><strong>健康检查</strong>: 服务健康状态监控</li>
</ul>
<h2 id="🚀-快速体验" tabindex="-1"><a class="header-anchor" href="#🚀-快速体验">#</a> 🚀 快速体验</h2>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 克隆项目</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/vera-byte/vgo_micro_service.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动服务</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问调试界面</span></span>
<span class="line"><span class="token function">open</span> http://localhost:8080</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-文档导航" tabindex="-1"><a class="header-anchor" href="#📚-文档导航">#</a> 📚 文档导航</h2>
<ul>
<li><a href="/guide/" target="_blank" rel="noopener noreferrer">快速开始</a> - 了解如何安装和配置VGO</li>
<li><a href="/api/" target="_blank" rel="noopener noreferrer">API文档</a> - 详细的API接口说明</li>
<li><a href="/deployment/" target="_blank" rel="noopener noreferrer">部署指南</a> - 生产环境部署指导</li>
<li><a href="/development/" target="_blank" rel="noopener noreferrer">开发指南</a> - 参与项目开发的指南</li>
</ul>
<h2 id="🤝-社区支持" tabindex="-1"><a class="header-anchor" href="#🤝-社区支持">#</a> 🤝 社区支持</h2>
<ul>
<li><strong>GitHub</strong>: <a href="https://github.com/vera-byte/vgo_micro_service" target="_blank" rel="noopener noreferrer">https://github.com/vera-byte/vgo_micro_service</a></li>
<li><strong>Issues</strong>: 问题反馈和功能建议</li>
<li><strong>Discussions</strong>: 技术讨论和经验分享</li>
</ul>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>本文档基于VGO v1.2.0版本编写，如果您使用的是其他版本，请参考对应版本的文档。</p>
</div>
</div></template>


