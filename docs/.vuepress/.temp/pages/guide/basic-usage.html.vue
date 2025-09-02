<template><div><h1 id="基本使用" tabindex="-1"><a class="header-anchor" href="#基本使用">#</a> 基本使用</h1>
<p>本指南将带您了解VGO微服务的核心功能和基本使用方法，包括用户管理、权限控制、应用管理等核心特性。</p>
<h2 id="🎯-功能概览" tabindex="-1"><a class="header-anchor" href="#🎯-功能概览">#</a> 🎯 功能概览</h2>
<p>VGO微服务提供以下核心功能：</p>
<ul>
<li><strong>用户管理</strong>: 创建、查询、更新、删除用户</li>
<li><strong>策略管理</strong>: 定义和管理权限策略</li>
<li><strong>访问密钥管理</strong>: 生成和管理API访问密钥</li>
<li><strong>应用管理</strong>: OAuth2应用注册和管理</li>
<li><strong>权限验证</strong>: 细粒度的权限检查</li>
<li><strong>开发者认证</strong>: 个人和企业开发者身份验证</li>
</ul>
<h2 id="🖥️-使用调试界面" tabindex="-1"><a class="header-anchor" href="#🖥️-使用调试界面">#</a> 🖥️ 使用调试界面</h2>
<h3 id="访问调试界面" tabindex="-1"><a class="header-anchor" href="#访问调试界面">#</a> 访问调试界面</h3>
<p>启动服务后，打开浏览器访问调试界面：</p>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">http://localhost:8080</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><p>调试界面提供了友好的Web界面来管理所有功能，包括：</p>
<ul>
<li><strong>用户管理页面</strong>: 创建、编辑、删除用户</li>
<li><strong>策略管理页面</strong>: 管理权限策略</li>
<li><strong>访问密钥页面</strong>: 生成和管理API密钥</li>
<li><strong>应用管理页面</strong>: 注册和管理OAuth2应用</li>
<li><strong>权限检查页面</strong>: 测试权限验证</li>
</ul>
<h3 id="界面功能说明" tabindex="-1"><a class="header-anchor" href="#界面功能说明">#</a> 界面功能说明</h3>
<h4 id="_1-用户管理" tabindex="-1"><a class="header-anchor" href="#_1-用户管理">#</a> 1. 用户管理</h4>
<ul>
<li><strong>创建用户</strong>: 填写用户名、显示名称、邮箱等信息</li>
<li><strong>查看用户列表</strong>: 支持分页和搜索</li>
<li><strong>编辑用户</strong>: 修改用户基本信息</li>
<li><strong>删除用户</strong>: 删除不需要的用户账户</li>
</ul>
<h4 id="_2-策略管理" tabindex="-1"><a class="header-anchor" href="#_2-策略管理">#</a> 2. 策略管理</h4>
<ul>
<li><strong>创建策略</strong>: 定义JSON格式的权限策略</li>
<li><strong>策略模板</strong>: 提供常用策略模板</li>
<li><strong>策略绑定</strong>: 将策略绑定到用户</li>
<li><strong>策略验证</strong>: 验证策略语法正确性</li>
</ul>
<h4 id="_3-访问密钥管理" tabindex="-1"><a class="header-anchor" href="#_3-访问密钥管理">#</a> 3. 访问密钥管理</h4>
<ul>
<li><strong>生成密钥</strong>: 为用户生成API访问密钥</li>
<li><strong>密钥状态</strong>: 启用/禁用访问密钥</li>
<li><strong>密钥轮换</strong>: 定期更新访问密钥</li>
<li><strong>使用统计</strong>: 查看密钥使用情况</li>
</ul>
<h4 id="_4-应用管理" tabindex="-1"><a class="header-anchor" href="#_4-应用管理">#</a> 4. 应用管理</h4>
<ul>
<li><strong>注册应用</strong>: 创建OAuth2应用</li>
<li><strong>应用配置</strong>: 设置回调URL、允许来源等</li>
<li><strong>应用类型</strong>: 支持Web、移动、API、SPA等类型</li>
<li><strong>应用状态</strong>: 管理应用的激活状态</li>
</ul>
<h2 id="🔧-使用grpc-api" tabindex="-1"><a class="header-anchor" href="#🔧-使用grpc-api">#</a> 🔧 使用gRPC API</h2>
<h3 id="安装grpcurl工具" tabindex="-1"><a class="header-anchor" href="#安装grpcurl工具">#</a> 安装grpcurl工具</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 使用Go安装</span></span>
<span class="line">go <span class="token function">install</span> github.com/fullstorydev/grpcurl/cmd/grpcurl@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或使用包管理器</span></span>
<span class="line"><span class="token comment"># macOS</span></span>
<span class="line">brew <span class="token function">install</span> grpcurl</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Ubuntu/Debian</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt</span> <span class="token function">install</span> grpcurl</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="用户管理api" tabindex="-1"><a class="header-anchor" href="#用户管理api">#</a> 用户管理API</h3>
<h4 id="创建用户" tabindex="-1"><a class="header-anchor" href="#创建用户">#</a> 创建用户</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe",</span>
<span class="line">  "display_name": "John Doe",</span>
<span class="line">  "email": "john@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>响应示例：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"user"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"1"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取用户信息" tabindex="-1"><a class="header-anchor" href="#获取用户信息">#</a> 获取用户信息</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="更新用户信息" tabindex="-1"><a class="header-anchor" href="#更新用户信息">#</a> 更新用户信息</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe",</span>
<span class="line">  "display_name": "John Smith",</span>
<span class="line">  "email": "john.smith@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="删除用户" tabindex="-1"><a class="header-anchor" href="#删除用户">#</a> 删除用户</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取用户列表" tabindex="-1"><a class="header-anchor" href="#获取用户列表">#</a> 获取用户列表</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="策略管理api" tabindex="-1"><a class="header-anchor" href="#策略管理api">#</a> 策略管理API</h3>
<h4 id="创建策略" tabindex="-1"><a class="header-anchor" href="#创建策略">#</a> 创建策略</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "read_only_policy",</span>
<span class="line">  "description": "只读权限策略",</span>
<span class="line">  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\"],\"Resource\":[\"*\"]}]}"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取策略" tabindex="-1"><a class="header-anchor" href="#获取策略">#</a> 获取策略</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "read_only_policy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="绑定策略到用户" tabindex="-1"><a class="header-anchor" href="#绑定策略到用户">#</a> 绑定策略到用户</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "policy_name": "read_only_policy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/AttachUserPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="解绑用户策略" tabindex="-1"><a class="header-anchor" href="#解绑用户策略">#</a> 解绑用户策略</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "policy_name": "read_only_policy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DetachUserPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="访问密钥管理api" tabindex="-1"><a class="header-anchor" href="#访问密钥管理api">#</a> 访问密钥管理API</h3>
<h4 id="创建访问密钥" tabindex="-1"><a class="header-anchor" href="#创建访问密钥">#</a> 创建访问密钥</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "description": "API访问密钥"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>响应示例：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"access_key"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"access_key_id"</span><span class="token operator">:</span> <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"secret_access_key"</span><span class="token operator">:</span> <span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"active"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取访问密钥列表" tabindex="-1"><a class="header-anchor" href="#获取访问密钥列表">#</a> 获取访问密钥列表</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListAccessKeys</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="更新访问密钥状态" tabindex="-1"><a class="header-anchor" href="#更新访问密钥状态">#</a> 更新访问密钥状态</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "access_key_id": "AKIA1234567890EXAMPLE",</span>
<span class="line">  "status": "inactive"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="删除访问密钥" tabindex="-1"><a class="header-anchor" href="#删除访问密钥">#</a> 删除访问密钥</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "access_key_id": "AKIA1234567890EXAMPLE"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="应用管理api" tabindex="-1"><a class="header-anchor" href="#应用管理api">#</a> 应用管理API</h3>
<h4 id="创建应用" tabindex="-1"><a class="header-anchor" href="#创建应用">#</a> 创建应用</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "app_name": "MyWebApp",</span>
<span class="line">  "app_description": "我的Web应用",</span>
<span class="line">  "app_type": "web",</span>
<span class="line">  "app_website": "https://myapp.example.com",</span>
<span class="line">  "callback_urls": ["https://myapp.example.com/callback"],</span>
<span class="line">  "allowed_origins": ["https://myapp.example.com"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取应用信息" tabindex="-1"><a class="header-anchor" href="#获取应用信息">#</a> 获取应用信息</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "app_id": 1</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="更新应用" tabindex="-1"><a class="header-anchor" href="#更新应用">#</a> 更新应用</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "app_id": 1,</span>
<span class="line">  "app_name": "UpdatedWebApp",</span>
<span class="line">  "app_description": "更新后的Web应用",</span>
<span class="line">  "app_type": "spa"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="获取应用列表" tabindex="-1"><a class="header-anchor" href="#获取应用列表">#</a> 获取应用列表</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "status": "active",</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListApplications</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="删除应用" tabindex="-1"><a class="header-anchor" href="#删除应用">#</a> 删除应用</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "app_id": 1</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="权限验证api" tabindex="-1"><a class="header-anchor" href="#权限验证api">#</a> 权限验证API</h3>
<h4 id="检查权限" tabindex="-1"><a class="header-anchor" href="#检查权限">#</a> 检查权限</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "action": "iam:GetUser",</span>
<span class="line">  "resource": "*"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermission</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>响应示例：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"User has required permissions"</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-权限策略语法" tabindex="-1"><a class="header-anchor" href="#🔐-权限策略语法">#</a> 🔐 权限策略语法</h2>
<h3 id="策略文档结构" tabindex="-1"><a class="header-anchor" href="#策略文档结构">#</a> 策略文档结构</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListUsers"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"*"</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="策略元素说明" tabindex="-1"><a class="header-anchor" href="#策略元素说明">#</a> 策略元素说明</h3>
<ul>
<li><strong>Version</strong>: 策略语言版本</li>
<li><strong>Statement</strong>: 权限声明数组</li>
<li><strong>Effect</strong>: 权限效果（Allow/Deny）</li>
<li><strong>Action</strong>: 允许或拒绝的操作</li>
<li><strong>Resource</strong>: 操作的资源范围</li>
</ul>
<h3 id="常用策略示例" tabindex="-1"><a class="header-anchor" href="#常用策略示例">#</a> 常用策略示例</h3>
<h4 id="_1-管理员策略" tabindex="-1"><a class="header-anchor" href="#_1-管理员策略">#</a> 1. 管理员策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token string">"*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-只读策略" tabindex="-1"><a class="header-anchor" href="#_2-只读策略">#</a> 2. 只读策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListUsers"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListPolicies"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListApplications"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-用户自管理策略" tabindex="-1"><a class="header-anchor" href="#_3-用户自管理策略">#</a> 3. 用户自管理策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:CreateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListAccessKeys"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:DeleteAccessKey"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"arn:iam::user/${aws:username}"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_4-应用管理策略" tabindex="-1"><a class="header-anchor" href="#_4-应用管理策略">#</a> 4. 应用管理策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CreateApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:DeleteApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListApplications"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔑-api认证" tabindex="-1"><a class="header-anchor" href="#🔑-api认证">#</a> 🔑 API认证</h2>
<h3 id="使用访问密钥认证" tabindex="-1"><a class="header-anchor" href="#使用访问密钥认证">#</a> 使用访问密钥认证</h3>
<p>在调用API时，需要使用访问密钥进行认证：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 设置认证头</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">ACCESS_KEY_ID</span><span class="token operator">=</span><span class="token string">"your_access_key_id"</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">SECRET_ACCESS_KEY</span><span class="token operator">=</span><span class="token string">"your_secret_access_key"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 使用认证调用API</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-H</span> <span class="token string">"Authorization: AWS4-HMAC-SHA256 Credential=<span class="token variable">$ACCESS_KEY_ID</span>/..."</span> <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-d</span> <span class="token string">'{"name":"john_doe"}'</span> <span class="token punctuation">\</span></span>
<span class="line">  localhost:50051 iam.v1.IAM/GetUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="签名计算" tabindex="-1"><a class="header-anchor" href="#签名计算">#</a> 签名计算</h3>
<p>VGO使用AWS Signature Version 4算法进行API签名验证。您可以使用官方SDK或自行实现签名算法。</p>
<h2 id="📊-监控和日志" tabindex="-1"><a class="header-anchor" href="#📊-监控和日志">#</a> 📊 监控和日志</h2>
<h3 id="查看服务状态" tabindex="-1"><a class="header-anchor" href="#查看服务状态">#</a> 查看服务状态</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查服务健康状态</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8080/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看Prometheus指标</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:9090/metrics</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="查看日志" tabindex="-1"><a class="header-anchor" href="#查看日志">#</a> 查看日志</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># Docker Compose环境</span></span>
<span class="line"><span class="token function">docker-compose</span> logs <span class="token parameter variable">-f</span> vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 直接运行</span></span>
<span class="line"><span class="token function">tail</span> <span class="token parameter variable">-f</span> logs/iam.log</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-常用操作脚本" tabindex="-1"><a class="header-anchor" href="#🔧-常用操作脚本">#</a> 🔧 常用操作脚本</h2>
<h3 id="批量创建用户" tabindex="-1"><a class="header-anchor" href="#批量创建用户">#</a> 批量创建用户</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量创建用户脚本</span></span>
<span class="line"><span class="token assign-left variable">users</span><span class="token operator">=</span><span class="token punctuation">(</span></span>
<span class="line">  <span class="token string">"alice:Alice Smith:alice@example.com"</span></span>
<span class="line">  <span class="token string">"bob:Bob Johnson:bob@example.com"</span></span>
<span class="line">  <span class="token string">"charlie:Charlie Brown:charlie@example.com"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">user</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">${users<span class="token punctuation">[</span>@<span class="token punctuation">]</span>}</span>"</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">  <span class="token assign-left variable"><span class="token environment constant">IFS</span></span><span class="token operator">=</span><span class="token string">':'</span> <span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span> name display_name email <span class="token operator">&lt;&lt;&lt;</span> <span class="token string">"<span class="token variable">$user</span>"</span></span>
<span class="line">  </span>
<span class="line">  grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$name</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>display_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$display_name</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>email<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$email</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">  }"</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line">  </span>
<span class="line">  <span class="token builtin class-name">echo</span> <span class="token string">"Created user: <span class="token variable">$name</span>"</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="批量绑定策略" tabindex="-1"><a class="header-anchor" href="#批量绑定策略">#</a> 批量绑定策略</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量绑定策略脚本</span></span>
<span class="line"><span class="token assign-left variable">users</span><span class="token operator">=</span><span class="token punctuation">(</span><span class="token string">"alice"</span> <span class="token string">"bob"</span> <span class="token string">"charlie"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token assign-left variable">policy</span><span class="token operator">=</span><span class="token string">"read_only_policy"</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">user</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">${users<span class="token punctuation">[</span>@<span class="token punctuation">]</span>}</span>"</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">  grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$user</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>policy_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$policy</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">  }"</span> localhost:50051 iam.v1.IAM/AttachUserPolicy</span>
<span class="line">  </span>
<span class="line">  <span class="token builtin class-name">echo</span> <span class="token string">"Attached policy <span class="token variable">$policy</span> to user: <span class="token variable">$user</span>"</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-故障排除" tabindex="-1"><a class="header-anchor" href="#🚨-故障排除">#</a> 🚨 故障排除</h2>
<h3 id="常见错误" tabindex="-1"><a class="header-anchor" href="#常见错误">#</a> 常见错误</h3>
<h4 id="_1-权限被拒绝" tabindex="-1"><a class="header-anchor" href="#_1-权限被拒绝">#</a> 1. 权限被拒绝</h4>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">Error: permission denied</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><p>解决方案：</p>
<ul>
<li>检查用户是否有相应权限</li>
<li>验证策略配置是否正确</li>
<li>确认访问密钥状态为active</li>
</ul>
<h4 id="_2-用户不存在" tabindex="-1"><a class="header-anchor" href="#_2-用户不存在">#</a> 2. 用户不存在</h4>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">Error: user not found</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><p>解决方案：</p>
<ul>
<li>确认用户名拼写正确</li>
<li>检查用户是否已创建</li>
<li>验证数据库连接正常</li>
</ul>
<h4 id="_3-策略语法错误" tabindex="-1"><a class="header-anchor" href="#_3-策略语法错误">#</a> 3. 策略语法错误</h4>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">Error: invalid policy document</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><p>解决方案：</p>
<ul>
<li>检查JSON语法是否正确</li>
<li>验证策略字段是否完整</li>
<li>使用策略验证工具检查</li>
</ul>
<h3 id="调试技巧" tabindex="-1"><a class="header-anchor" href="#调试技巧">#</a> 调试技巧</h3>
<ol>
<li>
<p><strong>启用调试日志</strong>：</p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">log</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">level</span><span class="token punctuation">:</span> debug</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div></div></div></li>
<li>
<p><strong>使用健康检查</strong>：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token function">curl</span> http://localhost:8080/health</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div></li>
<li>
<p><strong>查看详细错误</strong>：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-v</span> localhost:50051 list</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div></li>
</ol>
<h2 id="📚-下一步" tabindex="-1"><a class="header-anchor" href="#📚-下一步">#</a> 📚 下一步</h2>
<p>现在您已经了解了VGO的基本使用方法，可以继续学习：</p>
<ul>
<li><a href="/api/" target="_blank" rel="noopener noreferrer">API文档</a> - 详细的API接口说明</li>
<li><a href="/deployment/" target="_blank" rel="noopener noreferrer">部署指南</a> - 生产环境部署</li>
<li><a href="/development/" target="_blank" rel="noopener noreferrer">开发指南</a> - 参与项目开发</li>
</ul>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议在开发环境中先熟悉各项功能，然后再部署到生产环境。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>在生产环境中使用时，请确保：</p>
<ul>
<li>使用强密码和安全的访问密钥</li>
<li>定期轮换访问密钥</li>
<li>配置适当的权限策略</li>
<li>启用监控和日志记录</li>
</ul>
</div>
</div></template>


