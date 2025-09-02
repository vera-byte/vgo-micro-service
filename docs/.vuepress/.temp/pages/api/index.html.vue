<template><div><h1 id="api-文档" tabindex="-1"><a class="header-anchor" href="#api-文档">#</a> API 文档</h1>
<p>VGO微服务提供完整的gRPC API接口，支持用户管理、权限控制、应用管理等核心功能。本文档详细介绍了所有可用的API接口、参数说明和使用示例。</p>
<h2 id="📋-api-概览" tabindex="-1"><a class="header-anchor" href="#📋-api-概览">#</a> 📋 API 概览</h2>
<h3 id="服务信息" tabindex="-1"><a class="header-anchor" href="#服务信息">#</a> 服务信息</h3>
<ul>
<li><strong>服务名称</strong>: <code v-pre>iam.v1.IAM</code></li>
<li><strong>协议</strong>: gRPC</li>
<li><strong>端口</strong>: <code v-pre>50051</code></li>
<li><strong>认证方式</strong>: AWS Signature Version 4</li>
<li><strong>数据格式</strong>: Protocol Buffers</li>
</ul>
<h3 id="api-分类" tabindex="-1"><a class="header-anchor" href="#api-分类">#</a> API 分类</h3>
<table>
<thead>
<tr>
<th>分类</th>
<th>功能</th>
<th>接口数量</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="/api/user-management" target="_blank" rel="noopener noreferrer">用户管理</a></td>
<td>用户CRUD操作</td>
<td>5个</td>
</tr>
<tr>
<td><a href="/api/policy-management" target="_blank" rel="noopener noreferrer">策略管理</a></td>
<td>权限策略管理</td>
<td>6个</td>
</tr>
<tr>
<td><a href="/api/access-keys" target="_blank" rel="noopener noreferrer">访问密钥</a></td>
<td>API密钥管理</td>
<td>4个</td>
</tr>
<tr>
<td><a href="/api/applications" target="_blank" rel="noopener noreferrer">应用管理</a></td>
<td>OAuth2应用管理</td>
<td>5个</td>
</tr>
<tr>
<td><a href="/api/permissions" target="_blank" rel="noopener noreferrer">权限验证</a></td>
<td>权限检查</td>
<td>1个</td>
</tr>
<tr>
<td><a href="/api/developer-verification" target="_blank" rel="noopener noreferrer">开发者认证</a></td>
<td>开发者身份验证</td>
<td>4个</td>
</tr>
</tbody>
</table>
<h2 id="🚀-快速开始" tabindex="-1"><a class="header-anchor" href="#🚀-快速开始">#</a> 🚀 快速开始</h2>
<h3 id="_1-安装grpc客户端工具" tabindex="-1"><a class="header-anchor" href="#_1-安装grpc客户端工具">#</a> 1. 安装gRPC客户端工具</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装grpcurl</span></span>
<span class="line">go <span class="token function">install</span> github.com/fullstorydev/grpcurl/cmd/grpcurl@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或使用包管理器</span></span>
<span class="line">brew <span class="token function">install</span> grpcurl  <span class="token comment"># macOS</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt</span> <span class="token function">install</span> grpcurl  <span class="token comment"># Ubuntu</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-查看可用服务" tabindex="-1"><a class="header-anchor" href="#_2-查看可用服务">#</a> 2. 查看可用服务</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 列出所有服务</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看IAM服务的方法</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list iam.v1.IAM</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-查看方法详情" tabindex="-1"><a class="header-anchor" href="#_3-查看方法详情">#</a> 3. 查看方法详情</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看CreateUser方法的详细信息</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 describe iam.v1.IAM.CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-调用api示例" tabindex="-1"><a class="header-anchor" href="#_4-调用api示例">#</a> 4. 调用API示例</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_user",</span>
<span class="line">  "display_name": "Test User",</span>
<span class="line">  "email": "test@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-认证方式" tabindex="-1"><a class="header-anchor" href="#🔐-认证方式">#</a> 🔐 认证方式</h2>
<h3 id="aws-signature-version-4" tabindex="-1"><a class="header-anchor" href="#aws-signature-version-4">#</a> AWS Signature Version 4</h3>
<p>VGO使用AWS Signature Version 4算法进行API认证。您需要：</p>
<ol>
<li><strong>获取访问密钥</strong>：通过管理界面或API创建访问密钥</li>
<li><strong>计算签名</strong>：使用AWS SigV4算法计算请求签名</li>
<li><strong>添加认证头</strong>：在请求中包含Authorization头</li>
</ol>
<h3 id="认证头格式" tabindex="-1"><a class="header-anchor" href="#认证头格式">#</a> 认证头格式</h3>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20230101/us-east-1/iam/aws4_request, SignedHeaders=host;x-amz-date, Signature=calculated_signature</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><h3 id="使用sdk" tabindex="-1"><a class="header-anchor" href="#使用sdk">#</a> 使用SDK</h3>
<p>推荐使用官方SDK来处理签名计算：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// Go SDK示例</span></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/aws/credentials"</span></span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/aws/signer/v4"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">creds <span class="token operator">:=</span> credentials<span class="token punctuation">.</span><span class="token function">NewStaticCredentials</span><span class="token punctuation">(</span>accessKeyID<span class="token punctuation">,</span> secretAccessKey<span class="token punctuation">,</span> <span class="token string">""</span><span class="token punctuation">)</span></span>
<span class="line">signer <span class="token operator">:=</span> v4<span class="token punctuation">.</span><span class="token function">NewSigner</span><span class="token punctuation">(</span>creds<span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-响应格式" tabindex="-1"><a class="header-anchor" href="#📊-响应格式">#</a> 📊 响应格式</h2>
<h3 id="成功响应" tabindex="-1"><a class="header-anchor" href="#成功响应">#</a> 成功响应</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"user"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"1"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"test_user"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"Test User"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="错误响应" tabindex="-1"><a class="header-anchor" href="#错误响应">#</a> 错误响应</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"error"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"code"</span><span class="token operator">:</span> <span class="token string">"INVALID_ARGUMENT"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"message"</span><span class="token operator">:</span> <span class="token string">"用户名不能为空"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"details"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"field"</span><span class="token operator">:</span> <span class="token string">"name"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"name字段是必需的"</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">]</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="状态码说明" tabindex="-1"><a class="header-anchor" href="#状态码说明">#</a> 状态码说明</h3>
<table>
<thead>
<tr>
<th>状态码</th>
<th>说明</th>
<th>示例场景</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>OK</code></td>
<td>请求成功</td>
<td>正常操作完成</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>参数错误</td>
<td>缺少必需字段</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>资源不存在</td>
<td>用户不存在</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>资源已存在</td>
<td>用户名重复</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>权限不足</td>
<td>无操作权限</td>
</tr>
<tr>
<td><code v-pre>UNAUTHENTICATED</code></td>
<td>认证失败</td>
<td>签名错误</td>
</tr>
<tr>
<td><code v-pre>INTERNAL</code></td>
<td>内部错误</td>
<td>服务器异常</td>
</tr>
</tbody>
</table>
<h2 id="🔄-分页和过滤" tabindex="-1"><a class="header-anchor" href="#🔄-分页和过滤">#</a> 🔄 分页和过滤</h2>
<h3 id="分页参数" tabindex="-1"><a class="header-anchor" href="#分页参数">#</a> 分页参数</h3>
<p>大多数列表API支持分页：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"page"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"page_size"</span><span class="token operator">:</span> <span class="token number">20</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="分页响应" tabindex="-1"><a class="header-anchor" href="#分页响应">#</a> 分页响应</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"users"</span><span class="token operator">:</span> <span class="token punctuation">[</span>...<span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"pagination"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"page"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"page_size"</span><span class="token operator">:</span> <span class="token number">20</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_count"</span><span class="token operator">:</span> <span class="token number">100</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_pages"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="过滤参数" tabindex="-1"><a class="header-anchor" href="#过滤参数">#</a> 过滤参数</h3>
<p>支持的过滤条件：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"filter"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"active"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_after"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_before"</span><span class="token operator">:</span> <span class="token string">"2024-12-31T23:59:59Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📝-数据类型" tabindex="-1"><a class="header-anchor" href="#📝-数据类型">#</a> 📝 数据类型</h2>
<h3 id="基础类型" tabindex="-1"><a class="header-anchor" href="#基础类型">#</a> 基础类型</h3>
<table>
<thead>
<tr>
<th>类型</th>
<th>说明</th>
<th>示例</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>string</code></td>
<td>字符串</td>
<td><code v-pre>&quot;example&quot;</code></td>
</tr>
<tr>
<td><code v-pre>int32</code></td>
<td>32位整数</td>
<td><code v-pre>123</code></td>
</tr>
<tr>
<td><code v-pre>int64</code></td>
<td>64位整数</td>
<td><code v-pre>1234567890</code></td>
</tr>
<tr>
<td><code v-pre>bool</code></td>
<td>布尔值</td>
<td><code v-pre>true</code></td>
</tr>
<tr>
<td><code v-pre>timestamp</code></td>
<td>时间戳</td>
<td><code v-pre>&quot;2024-01-01T00:00:00Z&quot;</code></td>
</tr>
</tbody>
</table>
<h3 id="枚举类型" tabindex="-1"><a class="header-anchor" href="#枚举类型">#</a> 枚举类型</h3>
<h4 id="userstatus" tabindex="-1"><a class="header-anchor" href="#userstatus">#</a> UserStatus</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">UserStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  USER_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span></span>
<span class="line">  USER_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span></span>
<span class="line">  USER_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span></span>
<span class="line">  USER_STATUS_SUSPENDED <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="accesskeystatus" tabindex="-1"><a class="header-anchor" href="#accesskeystatus">#</a> AccessKeyStatus</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">AccessKeyStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  ACCESS_KEY_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span></span>
<span class="line">  ACCESS_KEY_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span></span>
<span class="line">  ACCESS_KEY_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="applicationtype" tabindex="-1"><a class="header-anchor" href="#applicationtype">#</a> ApplicationType</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">ApplicationType</span> <span class="token punctuation">{</span></span>
<span class="line">  APPLICATION_TYPE_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_TYPE_WEB <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_TYPE_MOBILE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_TYPE_API <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_TYPE_SPA <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="applicationstatus" tabindex="-1"><a class="header-anchor" href="#applicationstatus">#</a> ApplicationStatus</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">ApplicationStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  APPLICATION_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span></span>
<span class="line">  APPLICATION_STATUS_SUSPENDED <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛠️-开发工具" tabindex="-1"><a class="header-anchor" href="#🛠️-开发工具">#</a> 🛠️ 开发工具</h2>
<h3 id="protocol-buffers定义" tabindex="-1"><a class="header-anchor" href="#protocol-buffers定义">#</a> Protocol Buffers定义</h3>
<p>完整的protobuf定义文件：</p>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">syntax</span> <span class="token operator">=</span> <span class="token string">"proto3"</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">package</span> iam<span class="token punctuation">.</span>v1<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">option</span> go_package <span class="token operator">=</span> <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// IAM服务定义</span></span>
<span class="line"><span class="token keyword">service</span> <span class="token class-name">IAM</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 用户管理</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CreateUser</span><span class="token punctuation">(</span><span class="token class-name">CreateUserRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CreateUserResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">GetUser</span><span class="token punctuation">(</span><span class="token class-name">GetUserRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">GetUserResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">UpdateUser</span><span class="token punctuation">(</span><span class="token class-name">UpdateUserRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">UpdateUserResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">DeleteUser</span><span class="token punctuation">(</span><span class="token class-name">DeleteUserRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">DeleteUserResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">ListUsers</span><span class="token punctuation">(</span><span class="token class-name">ListUsersRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">ListUsersResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment">// 策略管理</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CreatePolicy</span><span class="token punctuation">(</span><span class="token class-name">CreatePolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CreatePolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">GetPolicy</span><span class="token punctuation">(</span><span class="token class-name">GetPolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">GetPolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">UpdatePolicy</span><span class="token punctuation">(</span><span class="token class-name">UpdatePolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">UpdatePolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">DeletePolicy</span><span class="token punctuation">(</span><span class="token class-name">DeletePolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">DeletePolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">ListPolicies</span><span class="token punctuation">(</span><span class="token class-name">ListPoliciesRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">ListPoliciesResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">AttachUserPolicy</span><span class="token punctuation">(</span><span class="token class-name">AttachUserPolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">AttachUserPolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">DetachUserPolicy</span><span class="token punctuation">(</span><span class="token class-name">DetachUserPolicyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">DetachUserPolicyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment">// 访问密钥管理</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CreateAccessKey</span><span class="token punctuation">(</span><span class="token class-name">CreateAccessKeyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CreateAccessKeyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">ListAccessKeys</span><span class="token punctuation">(</span><span class="token class-name">ListAccessKeysRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">ListAccessKeysResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">UpdateAccessKey</span><span class="token punctuation">(</span><span class="token class-name">UpdateAccessKeyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">UpdateAccessKeyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">DeleteAccessKey</span><span class="token punctuation">(</span><span class="token class-name">DeleteAccessKeyRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">DeleteAccessKeyResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment">// 应用管理</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CreateApplication</span><span class="token punctuation">(</span><span class="token class-name">CreateApplicationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CreateApplicationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">GetApplication</span><span class="token punctuation">(</span><span class="token class-name">GetApplicationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">GetApplicationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">UpdateApplication</span><span class="token punctuation">(</span><span class="token class-name">UpdateApplicationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">UpdateApplicationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">DeleteApplication</span><span class="token punctuation">(</span><span class="token class-name">DeleteApplicationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">DeleteApplicationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">ListApplications</span><span class="token punctuation">(</span><span class="token class-name">ListApplicationsRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">ListApplicationsResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment">// 权限验证</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CheckPermission</span><span class="token punctuation">(</span><span class="token class-name">CheckPermissionRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CheckPermissionResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment">// 开发者认证</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">CreateDeveloperVerification</span><span class="token punctuation">(</span><span class="token class-name">CreateDeveloperVerificationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">CreateDeveloperVerificationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">GetDeveloperVerification</span><span class="token punctuation">(</span><span class="token class-name">GetDeveloperVerificationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">GetDeveloperVerificationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">UpdateDeveloperVerification</span><span class="token punctuation">(</span><span class="token class-name">UpdateDeveloperVerificationRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">UpdateDeveloperVerificationResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">  <span class="token keyword">rpc</span> <span class="token function">ListDeveloperVerifications</span><span class="token punctuation">(</span><span class="token class-name">ListDeveloperVerificationsRequest</span><span class="token punctuation">)</span> <span class="token keyword">returns</span> <span class="token punctuation">(</span><span class="token class-name">ListDeveloperVerificationsResponse</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="客户端sdk" tabindex="-1"><a class="header-anchor" href="#客户端sdk">#</a> 客户端SDK</h3>
<h4 id="go客户端" tabindex="-1"><a class="header-anchor" href="#go客户端">#</a> Go客户端</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"log"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/credentials/insecure"</span></span>
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 连接到gRPC服务</span></span>
<span class="line">    conn<span class="token punctuation">,</span> err <span class="token operator">:=</span> grpc<span class="token punctuation">.</span><span class="token function">Dial</span><span class="token punctuation">(</span><span class="token string">"localhost:50051"</span><span class="token punctuation">,</span> grpc<span class="token punctuation">.</span><span class="token function">WithTransportCredentials</span><span class="token punctuation">(</span>insecure<span class="token punctuation">.</span><span class="token function">NewCredentials</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"连接失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> conn<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建客户端</span></span>
<span class="line">    client <span class="token operator">:=</span> iamv1<span class="token punctuation">.</span><span class="token function">NewIAMClient</span><span class="token punctuation">(</span>conn<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 调用API</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"test_user"</span><span class="token punctuation">,</span></span>
<span class="line">        DisplayName<span class="token punctuation">:</span> <span class="token string">"Test User"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>       <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"创建用户失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"用户创建成功: %v"</span><span class="token punctuation">,</span> resp<span class="token punctuation">.</span>User<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="python客户端" tabindex="-1"><a class="header-anchor" href="#python客户端">#</a> Python客户端</h4>
<div class="language-python line-numbers-mode" data-highlighter="prismjs" data-ext="py"><pre v-pre><code class="language-python"><span class="line"><span class="token keyword">import</span> grpc</span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2</span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2_grpc</span>
<span class="line"></span>
<span class="line"><span class="token keyword">def</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 连接到gRPC服务</span></span>
<span class="line">    <span class="token keyword">with</span> grpc<span class="token punctuation">.</span>insecure_channel<span class="token punctuation">(</span><span class="token string">'localhost:50051'</span><span class="token punctuation">)</span> <span class="token keyword">as</span> channel<span class="token punctuation">:</span></span>
<span class="line">        <span class="token comment"># 创建客户端</span></span>
<span class="line">        stub <span class="token operator">=</span> iam_pb2_grpc<span class="token punctuation">.</span>IAMStub<span class="token punctuation">(</span>channel<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 调用API</span></span>
<span class="line">        request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">(</span></span>
<span class="line">            name<span class="token operator">=</span><span class="token string">'test_user'</span><span class="token punctuation">,</span></span>
<span class="line">            display_name<span class="token operator">=</span><span class="token string">'Test User'</span><span class="token punctuation">,</span></span>
<span class="line">            email<span class="token operator">=</span><span class="token string">'test@example.com'</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        response <span class="token operator">=</span> stub<span class="token punctuation">.</span>CreateUser<span class="token punctuation">(</span>request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'用户创建成功: </span><span class="token interpolation"><span class="token punctuation">{</span>response<span class="token punctuation">.</span>user<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> __name__ <span class="token operator">==</span> <span class="token string">'__main__'</span><span class="token punctuation">:</span></span>
<span class="line">    main<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-详细文档" tabindex="-1"><a class="header-anchor" href="#📚-详细文档">#</a> 📚 详细文档</h2>
<p>点击以下链接查看各模块的详细API文档：</p>
<ul>
<li><a href="/api/user-management" target="_blank" rel="noopener noreferrer">用户管理API</a> - 用户的创建、查询、更新、删除操作</li>
<li><a href="/api/policy-management" target="_blank" rel="noopener noreferrer">策略管理API</a> - 权限策略的管理和绑定</li>
<li><a href="/api/access-keys" target="_blank" rel="noopener noreferrer">访问密钥API</a> - API访问密钥的生命周期管理</li>
<li><a href="/api/applications" target="_blank" rel="noopener noreferrer">应用管理API</a> - OAuth2应用的注册和管理</li>
<li><a href="/api/permissions" target="_blank" rel="noopener noreferrer">权限验证API</a> - 权限检查和验证</li>
<li><a href="/api/developer-verification" target="_blank" rel="noopener noreferrer">开发者认证API</a> - 开发者身份验证流程</li>
</ul>
<h2 id="🔧-测试工具" tabindex="-1"><a class="header-anchor" href="#🔧-测试工具">#</a> 🔧 测试工具</h2>
<h3 id="postman集合" tabindex="-1"><a class="header-anchor" href="#postman集合">#</a> Postman集合</h3>
<p>我们提供了完整的Postman集合，包含所有API的示例请求：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"info"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"VGO IAM API"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"VGO微服务IAM API集合"</span></span>
<span class="line">  <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"item"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"用户管理"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"item"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"创建用户"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"request"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"method"</span><span class="token operator">:</span> <span class="token string">"POST"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"header"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"body"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"raw"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"raw"</span><span class="token operator">:</span> <span class="token string">"{\n  \"name\": \"test_user\",\n  \"display_name\": \"Test User\",\n  \"email\": \"test@example.com\"\n}"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"url"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"raw"</span><span class="token operator">:</span> <span class="token string">"{{base_url}}/iam.v1.IAM/CreateUser"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"host"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"{{base_url}}"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"path"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"iam.v1.IAM"</span><span class="token punctuation">,</span> <span class="token string">"CreateUser"</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="自动化测试" tabindex="-1"><a class="header-anchor" href="#自动化测试">#</a> 自动化测试</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># API测试脚本</span></span>
<span class="line"><span class="token assign-left variable">BASE_URL</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试创建用户</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"测试创建用户..."</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_user",</span>
<span class="line">  "display_name": "Test User",</span>
<span class="line">  "email": "test@example.com"</span>
<span class="line">}'</span> <span class="token variable">$BASE_URL</span> iam.v1.IAM/CreateUser</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试获取用户</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"测试获取用户..."</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_user"</span>
<span class="line">}'</span> <span class="token variable">$BASE_URL</span> iam.v1.IAM/GetUser</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试删除用户</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"测试删除用户..."</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_user"</span>
<span class="line">}'</span> <span class="token variable">$BASE_URL</span> iam.v1.IAM/DeleteUser</span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"测试完成"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-错误处理" tabindex="-1"><a class="header-anchor" href="#🚨-错误处理">#</a> 🚨 错误处理</h2>
<h3 id="错误码对照表" tabindex="-1"><a class="header-anchor" href="#错误码对照表">#</a> 错误码对照表</h3>
<table>
<thead>
<tr>
<th>错误码</th>
<th>HTTP状态码</th>
<th>说明</th>
<th>解决方案</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>OK</code></td>
<td>200</td>
<td>成功</td>
<td>-</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>400</td>
<td>参数错误</td>
<td>检查请求参数</td>
</tr>
<tr>
<td><code v-pre>UNAUTHENTICATED</code></td>
<td>401</td>
<td>认证失败</td>
<td>检查访问密钥</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>403</td>
<td>权限不足</td>
<td>检查用户权限</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>404</td>
<td>资源不存在</td>
<td>确认资源ID</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>409</td>
<td>资源已存在</td>
<td>使用不同的标识符</td>
</tr>
<tr>
<td><code v-pre>INTERNAL</code></td>
<td>500</td>
<td>内部错误</td>
<td>联系技术支持</td>
</tr>
<tr>
<td><code v-pre>UNAVAILABLE</code></td>
<td>503</td>
<td>服务不可用</td>
<td>稍后重试</td>
</tr>
</tbody>
</table>
<h3 id="重试策略" tabindex="-1"><a class="header-anchor" href="#重试策略">#</a> 重试策略</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 指数退避重试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">retryWithBackoff</span><span class="token punctuation">(</span>fn <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span><span class="token punctuation">,</span> maxRetries <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> maxRetries<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> <span class="token function">fn</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 指数退避</span></span>
<span class="line">        time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span>math<span class="token punctuation">.</span><span class="token function">Pow</span><span class="token punctuation">(</span><span class="token number">2</span><span class="token punctuation">,</span> <span class="token function">float64</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"达到最大重试次数"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-性能优化" tabindex="-1"><a class="header-anchor" href="#📈-性能优化">#</a> 📈 性能优化</h2>
<h3 id="连接池" tabindex="-1"><a class="header-anchor" href="#连接池">#</a> 连接池</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// gRPC连接池</span></span>
<span class="line"><span class="token keyword">type</span> ConnectionPool <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    connections <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn</span>
<span class="line">    current     <span class="token builtin">int</span></span>
<span class="line">    mutex       sync<span class="token punctuation">.</span>Mutex</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>ConnectionPool<span class="token punctuation">)</span> <span class="token function">GetConnection</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> p<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    conn <span class="token operator">:=</span> p<span class="token punctuation">.</span>connections<span class="token punctuation">[</span>p<span class="token punctuation">.</span>current<span class="token punctuation">]</span></span>
<span class="line">    p<span class="token punctuation">.</span>current <span class="token operator">=</span> <span class="token punctuation">(</span>p<span class="token punctuation">.</span>current <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">%</span> <span class="token function">len</span><span class="token punctuation">(</span>p<span class="token punctuation">.</span>connections<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> conn</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="批量操作" tabindex="-1"><a class="header-anchor" href="#批量操作">#</a> 批量操作</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 批量创建用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "users": [</span>
<span class="line">    {"name": "user1", "email": "user1@example.com"},</span>
<span class="line">    {"name": "user2", "email": "user2@example.com"},</span>
<span class="line">    {"name": "user3", "email": "user3@example.com"}</span>
<span class="line">  ]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/BatchCreateUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-监控和调试" tabindex="-1"><a class="header-anchor" href="#🔍-监控和调试">#</a> 🔍 监控和调试</h2>
<h3 id="启用grpc日志" tabindex="-1"><a class="header-anchor" href="#启用grpc日志">#</a> 启用gRPC日志</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 设置gRPC日志级别</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">GRPC_GO_LOG_VERBOSITY_LEVEL</span><span class="token operator">=</span><span class="token number">99</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">GRPC_GO_LOG_SEVERITY_LEVEL</span><span class="token operator">=</span>info</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="使用grpc反射" tabindex="-1"><a class="header-anchor" href="#使用grpc反射">#</a> 使用gRPC反射</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启用反射后可以动态发现服务</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list</span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 describe iam.v1.IAM</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="性能指标" tabindex="-1"><a class="header-anchor" href="#性能指标">#</a> 性能指标</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看gRPC指标</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:9090/metrics <span class="token operator">|</span> <span class="token function">grep</span> grpc</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div></div></div><hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议在开发过程中使用grpcurl进行API测试，在生产环境中使用官方SDK。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<ul>
<li>所有API调用都需要正确的认证</li>
<li>注意API的速率限制</li>
<li>生产环境请使用TLS加密</li>
</ul>
</div>
</div></template>


