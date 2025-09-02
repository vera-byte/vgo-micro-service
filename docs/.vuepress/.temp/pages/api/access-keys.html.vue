<template><div><h1 id="访问密钥管理-api" tabindex="-1"><a class="header-anchor" href="#访问密钥管理-api">#</a> 访问密钥管理 API</h1>
<p>访问密钥管理API提供了完整的API访问密钥生命周期管理功能，包括密钥的创建、查询、更新状态和删除操作。</p>
<h2 id="📋-api-概览" tabindex="-1"><a class="header-anchor" href="#📋-api-概览">#</a> 📋 API 概览</h2>
<table>
<thead>
<tr>
<th>方法</th>
<th>描述</th>
<th>权限要求</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>CreateAccessKey</code></td>
<td>创建访问密钥</td>
<td><code v-pre>iam:CreateAccessKey</code></td>
</tr>
<tr>
<td><code v-pre>ListAccessKeys</code></td>
<td>获取访问密钥列表</td>
<td><code v-pre>iam:ListAccessKeys</code></td>
</tr>
<tr>
<td><code v-pre>UpdateAccessKey</code></td>
<td>更新访问密钥状态</td>
<td><code v-pre>iam:UpdateAccessKey</code></td>
</tr>
<tr>
<td><code v-pre>DeleteAccessKey</code></td>
<td>删除访问密钥</td>
<td><code v-pre>iam:DeleteAccessKey</code></td>
</tr>
</tbody>
</table>
<h2 id="🔧-api-详情" tabindex="-1"><a class="header-anchor" href="#🔧-api-详情">#</a> 🔧 API 详情</h2>
<h3 id="createaccesskey-创建访问密钥" tabindex="-1"><a class="header-anchor" href="#createaccesskey-创建访问密钥">#</a> CreateAccessKey - 创建访问密钥</h3>
<p>为指定用户创建新的API访问密钥。</p>
<h4 id="请求" tabindex="-1"><a class="header-anchor" href="#请求">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateAccessKeyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>       <span class="token comment">// 密钥描述（可选）</span></span>
<span class="line">  <span class="token builtin">int32</span> app_id <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>            <span class="token comment">// 关联应用ID（可选）</span></span>
<span class="line">  <span class="token builtin">int32</span> expires_in_days <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>   <span class="token comment">// 过期天数（可选，默认永不过期）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应" tabindex="-1"><a class="header-anchor" href="#响应">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateAccessKeyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">AccessKey</span> access_key <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 创建的访问密钥信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例" tabindex="-1"><a class="header-anchor" href="#示例">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 为用户创建访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "description": "API访问密钥"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建关联应用的访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "description": "移动应用API密钥",</span>
<span class="line">  "app_id": 123,</span>
<span class="line">  "expires_in_days": 90</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例" tabindex="-1"><a class="header-anchor" href="#响应示例">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"access_key"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"ak-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"access_key_id"</span><span class="token operator">:</span> <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"secret_access_key"</span><span class="token operator">:</span> <span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_id"</span><span class="token operator">:</span> <span class="token string">"user-789"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"API访问密钥"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"ACCESS_KEY_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"app_id"</span><span class="token operator">:</span> <span class="token number">123</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"expires_at"</span><span class="token operator">:</span> <span class="token string">"2024-04-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="hint-container warning">
<p class="hint-container-title">重要提示</p>
<p><code v-pre>secret_access_key</code> 只在创建时返回一次，请妥善保存。后续无法再次获取。</p>
</div>
<h4 id="错误情况" tabindex="-1"><a class="header-anchor" href="#错误情况">#</a> 错误情况</h4>
<table>
<thead>
<tr>
<th>错误码</th>
<th>说明</th>
<th>解决方案</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>用户不存在</td>
<td>确认用户名正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的过期天数</td>
<td>设置合理的过期时间</td>
</tr>
<tr>
<td><code v-pre>RESOURCE_EXHAUSTED</code></td>
<td>用户访问密钥数量达到上限</td>
<td>删除不使用的密钥</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无创建访问密钥权限</td>
<td>确保有<code v-pre>iam:CreateAccessKey</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="listaccesskeys-获取访问密钥列表" tabindex="-1"><a class="header-anchor" href="#listaccesskeys-获取访问密钥列表">#</a> ListAccessKeys - 获取访问密钥列表</h3>
<p>获取指定用户的访问密钥列表。</p>
<h4 id="请求-1" tabindex="-1"><a class="header-anchor" href="#请求-1">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListAccessKeysRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token positional-class-name class-name">AccessKeyStatus</span> status <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>   <span class="token comment">// 密钥状态过滤（可选）</span></span>
<span class="line">  <span class="token builtin">int32</span> page <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>              <span class="token comment">// 页码（从1开始）</span></span>
<span class="line">  <span class="token builtin">int32</span> page_size <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>         <span class="token comment">// 每页大小（最大100）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-1" tabindex="-1"><a class="header-anchor" href="#响应-1">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListAccessKeysResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">AccessKey</span> access_keys <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>   <span class="token comment">// 访问密钥列表</span></span>
<span class="line">  <span class="token positional-class-name class-name">Pagination</span> pagination <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>            <span class="token comment">// 分页信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-1" tabindex="-1"><a class="header-anchor" href="#示例-1">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取用户的所有访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListAccessKeys</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 只获取活跃的访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "status": "ACCESS_KEY_STATUS_ACTIVE",</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListAccessKeys</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-1" tabindex="-1"><a class="header-anchor" href="#响应示例-1">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"access_keys"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"ak-123456"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"access_key_id"</span><span class="token operator">:</span> <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_id"</span><span class="token operator">:</span> <span class="token string">"user-789"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"API访问密钥"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"ACCESS_KEY_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"app_id"</span><span class="token operator">:</span> <span class="token number">123</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"last_used_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"expires_at"</span><span class="token operator">:</span> <span class="token string">"2024-04-01T00:00:00Z"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"ak-789012"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"access_key_id"</span><span class="token operator">:</span> <span class="token string">"AKIA0987654321EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_id"</span><span class="token operator">:</span> <span class="token string">"user-789"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"移动应用密钥"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"ACCESS_KEY_STATUS_INACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-10T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-12T00:00:00Z"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"pagination"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"page"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"page_size"</span><span class="token operator">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_count"</span><span class="token operator">:</span> <span class="token number">2</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_pages"</span><span class="token operator">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>出于安全考虑，列表接口不返回 <code v-pre>secret_access_key</code> 字段。</p>
</div>
<h4 id="错误情况-1" tabindex="-1"><a class="header-anchor" href="#错误情况-1">#</a> 错误情况</h4>
<table>
<thead>
<tr>
<th>错误码</th>
<th>说明</th>
<th>解决方案</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>用户不存在</td>
<td>确认用户名正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的分页参数</td>
<td>检查page和page_size值</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无查看访问密钥权限</td>
<td>确保有<code v-pre>iam:ListAccessKeys</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="updateaccesskey-更新访问密钥状态" tabindex="-1"><a class="header-anchor" href="#updateaccesskey-更新访问密钥状态">#</a> UpdateAccessKey - 更新访问密钥状态</h3>
<p>更新访问密钥的状态或描述信息。</p>
<h4 id="请求-2" tabindex="-1"><a class="header-anchor" href="#请求-2">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateAccessKeyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> access_key_id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 访问密钥ID（必需）</span></span>
<span class="line">  <span class="token positional-class-name class-name">AccessKeyStatus</span> status <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>   <span class="token comment">// 新状态（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>       <span class="token comment">// 新描述（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>FieldMask</span> update_mask <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>  <span class="token comment">// 更新字段掩码</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-2" tabindex="-1"><a class="header-anchor" href="#响应-2">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateAccessKeyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">AccessKey</span> access_key <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 更新后的访问密钥信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-2" tabindex="-1"><a class="header-anchor" href="#示例-2">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 禁用访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "access_key_id": "AKIA1234567890EXAMPLE",</span>
<span class="line">  "status": "ACCESS_KEY_STATUS_INACTIVE",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["status"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启用访问密钥并更新描述</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "access_key_id": "AKIA1234567890EXAMPLE",</span>
<span class="line">  "status": "ACCESS_KEY_STATUS_ACTIVE",</span>
<span class="line">  "description": "更新后的API访问密钥",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["status", "description"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-2" tabindex="-1"><a class="header-anchor" href="#响应示例-2">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"access_key"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"ak-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"access_key_id"</span><span class="token operator">:</span> <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_id"</span><span class="token operator">:</span> <span class="token string">"user-789"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"更新后的API访问密钥"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"ACCESS_KEY_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"app_id"</span><span class="token operator">:</span> <span class="token number">123</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T14:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"last_used_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"expires_at"</span><span class="token operator">:</span> <span class="token string">"2024-04-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-2" tabindex="-1"><a class="header-anchor" href="#错误情况-2">#</a> 错误情况</h4>
<table>
<thead>
<tr>
<th>错误码</th>
<th>说明</th>
<th>解决方案</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>访问密钥不存在</td>
<td>确认访问密钥ID正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的状态值</td>
<td>使用有效的状态枚举值</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无更新访问密钥权限</td>
<td>确保有<code v-pre>iam:UpdateAccessKey</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="deleteaccesskey-删除访问密钥" tabindex="-1"><a class="header-anchor" href="#deleteaccesskey-删除访问密钥">#</a> DeleteAccessKey - 删除访问密钥</h3>
<p>删除指定的访问密钥。</p>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>删除访问密钥是不可逆操作，删除后使用该密钥的API调用将失败。</p>
</div>
<h4 id="请求-3" tabindex="-1"><a class="header-anchor" href="#请求-3">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteAccessKeyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> access_key_id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 访问密钥ID（必需）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-3" tabindex="-1"><a class="header-anchor" href="#响应-3">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteAccessKeyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-3" tabindex="-1"><a class="header-anchor" href="#示例-3">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 删除访问密钥</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "access_key_id": "AKIA1234567890EXAMPLE"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteAccessKey</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-3" tabindex="-1"><a class="header-anchor" href="#响应示例-3">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><h4 id="错误情况-3" tabindex="-1"><a class="header-anchor" href="#错误情况-3">#</a> 错误情况</h4>
<table>
<thead>
<tr>
<th>错误码</th>
<th>说明</th>
<th>解决方案</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>访问密钥不存在</td>
<td>确认访问密钥ID正确</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无删除访问密钥权限</td>
<td>确保有<code v-pre>iam:DeleteAccessKey</code>权限</td>
</tr>
</tbody>
</table>
<h2 id="📊-数据模型" tabindex="-1"><a class="header-anchor" href="#📊-数据模型">#</a> 📊 数据模型</h2>
<h3 id="accesskey-对象" tabindex="-1"><a class="header-anchor" href="#accesskey-对象">#</a> AccessKey 对象</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">AccessKey</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                        <span class="token comment">// 内部ID（系统生成）</span></span>
<span class="line">  <span class="token builtin">string</span> access_key_id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>             <span class="token comment">// 访问密钥ID（公开标识符）</span></span>
<span class="line">  <span class="token builtin">string</span> secret_access_key <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>         <span class="token comment">// 秘密访问密钥（仅创建时返回）</span></span>
<span class="line">  <span class="token builtin">string</span> user_id <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>                   <span class="token comment">// 用户ID</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>                 <span class="token comment">// 用户名</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>               <span class="token comment">// 密钥描述</span></span>
<span class="line">  <span class="token positional-class-name class-name">AccessKeyStatus</span> status <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>           <span class="token comment">// 密钥状态</span></span>
<span class="line">  <span class="token builtin">int32</span> app_id <span class="token operator">=</span> <span class="token number">8</span><span class="token punctuation">;</span>                     <span class="token comment">// 关联应用ID</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> created_at <span class="token operator">=</span> <span class="token number">9</span><span class="token punctuation">;</span>     <span class="token comment">// 创建时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> updated_at <span class="token operator">=</span> <span class="token number">10</span><span class="token punctuation">;</span>    <span class="token comment">// 更新时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> last_used_at <span class="token operator">=</span> <span class="token number">11</span><span class="token punctuation">;</span>  <span class="token comment">// 最后使用时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> expires_at <span class="token operator">=</span> <span class="token number">12</span><span class="token punctuation">;</span>    <span class="token comment">// 过期时间</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="accesskeystatus-枚举" tabindex="-1"><a class="header-anchor" href="#accesskeystatus-枚举">#</a> AccessKeyStatus 枚举</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">AccessKeyStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  ACCESS_KEY_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span>    <span class="token comment">// 未指定</span></span>
<span class="line">  ACCESS_KEY_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 活跃</span></span>
<span class="line">  ACCESS_KEY_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>       <span class="token comment">// 非活跃</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-权限要求" tabindex="-1"><a class="header-anchor" href="#🔐-权限要求">#</a> 🔐 权限要求</h2>
<h3 id="所需权限" tabindex="-1"><a class="header-anchor" href="#所需权限">#</a> 所需权限</h3>
<table>
<thead>
<tr>
<th>操作</th>
<th>权限</th>
<th>资源</th>
</tr>
</thead>
<tbody>
<tr>
<td>创建访问密钥</td>
<td><code v-pre>iam:CreateAccessKey</code></td>
<td><code v-pre>arn:iam::user/*</code> 或 <code v-pre>arn:iam::user/${aws:username}</code></td>
</tr>
<tr>
<td>列表访问密钥</td>
<td><code v-pre>iam:ListAccessKeys</code></td>
<td><code v-pre>arn:iam::user/*</code> 或 <code v-pre>arn:iam::user/${aws:username}</code></td>
</tr>
<tr>
<td>更新访问密钥</td>
<td><code v-pre>iam:UpdateAccessKey</code></td>
<td><code v-pre>arn:iam::access-key/*</code></td>
</tr>
<tr>
<td>删除访问密钥</td>
<td><code v-pre>iam:DeleteAccessKey</code></td>
<td><code v-pre>arn:iam::access-key/*</code></td>
</tr>
</tbody>
</table>
<h3 id="策略示例" tabindex="-1"><a class="header-anchor" href="#策略示例">#</a> 策略示例</h3>
<h4 id="用户自管理访问密钥策略" tabindex="-1"><a class="header-anchor" href="#用户自管理访问密钥策略">#</a> 用户自管理访问密钥策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CreateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListAccessKeys"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:DeleteAccessKey"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"arn:iam::user/${aws:username}"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"arn:iam::access-key/*"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"StringEquals"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"iam:AccessKeyOwner"</span><span class="token operator">:</span> <span class="token string">"${aws:username}"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="管理员访问密钥管理策略" tabindex="-1"><a class="header-anchor" href="#管理员访问密钥管理策略">#</a> 管理员访问密钥管理策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CreateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListAccessKeys"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateAccessKey"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:DeleteAccessKey"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔑-访问密钥使用" tabindex="-1"><a class="header-anchor" href="#🔑-访问密钥使用">#</a> 🔑 访问密钥使用</h2>
<h3 id="aws-signature-version-4-认证" tabindex="-1"><a class="header-anchor" href="#aws-signature-version-4-认证">#</a> AWS Signature Version 4 认证</h3>
<p>VGO使用AWS Signature Version 4算法进行API认证。</p>
<h4 id="认证流程" tabindex="-1"><a class="header-anchor" href="#认证流程">#</a> 认证流程</h4>
<ol>
<li><strong>准备请求</strong>：构造HTTP请求</li>
<li><strong>创建规范请求</strong>：标准化请求格式</li>
<li><strong>创建待签名字符串</strong>：包含请求摘要</li>
<li><strong>计算签名</strong>：使用HMAC-SHA256算法</li>
<li><strong>添加认证头</strong>：包含签名信息</li>
</ol>
<h4 id="认证头格式" tabindex="-1"><a class="header-anchor" href="#认证头格式">#</a> 认证头格式</h4>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20230101/us-east-1/iam/aws4_request, SignedHeaders=host;x-amz-date, Signature=calculated_signature</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div></div></div><h4 id="go-sdk-示例" tabindex="-1"><a class="header-anchor" href="#go-sdk-示例">#</a> Go SDK 示例</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"crypto/hmac"</span></span>
<span class="line">    <span class="token string">"crypto/sha256"</span></span>
<span class="line">    <span class="token string">"encoding/hex"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/metadata"</span></span>
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Credentials <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    AccessKeyID     <span class="token builtin">string</span></span>
<span class="line">    SecretAccessKey <span class="token builtin">string</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>Credentials<span class="token punctuation">)</span> <span class="token function">Sign</span><span class="token punctuation">(</span>stringToSign <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    h <span class="token operator">:=</span> hmac<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span>sha256<span class="token punctuation">.</span>New<span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>c<span class="token punctuation">.</span>SecretAccessKey<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    h<span class="token punctuation">.</span><span class="token function">Write</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>stringToSign<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> hex<span class="token punctuation">.</span><span class="token function">EncodeToString</span><span class="token punctuation">(</span>h<span class="token punctuation">.</span><span class="token function">Sum</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">createAuthenticatedContext</span><span class="token punctuation">(</span>creds <span class="token operator">*</span>Credentials<span class="token punctuation">)</span> context<span class="token punctuation">.</span>Context <span class="token punctuation">{</span></span>
<span class="line">    now <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">UTC</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    dateStamp <span class="token operator">:=</span> now<span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span><span class="token string">"20060102"</span><span class="token punctuation">)</span></span>
<span class="line">    amzDate <span class="token operator">:=</span> now<span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span><span class="token string">"20060102T150405Z"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 构造认证头</span></span>
<span class="line">    credential <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s/%s/us-east-1/iam/aws4_request"</span><span class="token punctuation">,</span> creds<span class="token punctuation">.</span>AccessKeyID<span class="token punctuation">,</span> dateStamp<span class="token punctuation">)</span></span>
<span class="line">    signedHeaders <span class="token operator">:=</span> <span class="token string">"host;x-amz-date"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 简化的签名计算（实际应用中需要完整的SigV4实现）</span></span>
<span class="line">    stringToSign <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"AWS4-HMAC-SHA256\n%s\n%s/%s/us-east-1/iam/aws4_request\n%s"</span><span class="token punctuation">,</span></span>
<span class="line">        amzDate<span class="token punctuation">,</span> dateStamp<span class="token punctuation">,</span> <span class="token string">"iam"</span><span class="token punctuation">,</span> <span class="token string">"request_hash"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    signature <span class="token operator">:=</span> creds<span class="token punctuation">.</span><span class="token function">Sign</span><span class="token punctuation">(</span>stringToSign<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    authHeader <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"AWS4-HMAC-SHA256 Credential=%s, SignedHeaders=%s, Signature=%s"</span><span class="token punctuation">,</span></span>
<span class="line">        credential<span class="token punctuation">,</span> signedHeaders<span class="token punctuation">,</span> signature<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建带认证信息的context</span></span>
<span class="line">    md <span class="token operator">:=</span> metadata<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"authorization"</span><span class="token punctuation">:</span> authHeader<span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"x-amz-date"</span><span class="token punctuation">:</span>    amzDate<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> metadata<span class="token punctuation">.</span><span class="token function">NewOutgoingContext</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> md<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 连接到服务</span></span>
<span class="line">    conn<span class="token punctuation">,</span> err <span class="token operator">:=</span> grpc<span class="token punctuation">.</span><span class="token function">Dial</span><span class="token punctuation">(</span><span class="token string">"localhost:50051"</span><span class="token punctuation">,</span> grpc<span class="token punctuation">.</span><span class="token function">WithInsecure</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token function">panic</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> conn<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    client <span class="token operator">:=</span> iamv1<span class="token punctuation">.</span><span class="token function">NewIAMClient</span><span class="token punctuation">(</span>conn<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 使用访问密钥认证</span></span>
<span class="line">    creds <span class="token operator">:=</span> <span class="token operator">&amp;</span>Credentials<span class="token punctuation">{</span></span>
<span class="line">        AccessKeyID<span class="token punctuation">:</span>     <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">        SecretAccessKey<span class="token punctuation">:</span> <span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    ctx <span class="token operator">:=</span> <span class="token function">createAuthenticatedContext</span><span class="token punctuation">(</span>creds<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 调用API</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListAccessKeysRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token function">panic</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"访问密钥列表: %v\n"</span><span class="token punctuation">,</span> resp<span class="token punctuation">.</span>AccessKeys<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="使用官方aws-sdk" tabindex="-1"><a class="header-anchor" href="#使用官方aws-sdk">#</a> 使用官方AWS SDK</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/aws"</span></span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/aws/credentials"</span></span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/aws/session"</span></span>
<span class="line">    <span class="token string">"github.com/aws/aws-sdk-go/service/iam"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 创建AWS会话</span></span>
<span class="line">    sess <span class="token operator">:=</span> session<span class="token punctuation">.</span><span class="token function">Must</span><span class="token punctuation">(</span>session<span class="token punctuation">.</span><span class="token function">NewSession</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>aws<span class="token punctuation">.</span>Config<span class="token punctuation">{</span></span>
<span class="line">        Region<span class="token punctuation">:</span> aws<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"us-east-1"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        Credentials<span class="token punctuation">:</span> credentials<span class="token punctuation">.</span><span class="token function">NewStaticCredentials</span><span class="token punctuation">(</span></span>
<span class="line">            <span class="token string">"AKIA1234567890EXAMPLE"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">""</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        Endpoint<span class="token punctuation">:</span> aws<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"http://localhost:50051"</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token comment">// VGO服务端点</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建IAM客户端</span></span>
<span class="line">    svc <span class="token operator">:=</span> iam<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span>sess<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 列出访问密钥</span></span>
<span class="line">    result<span class="token punctuation">,</span> err <span class="token operator">:=</span> svc<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>iam<span class="token punctuation">.</span>ListAccessKeysInput<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> aws<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"john_doe"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token function">panic</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"访问密钥: %v\n"</span><span class="token punctuation">,</span> result<span class="token punctuation">.</span>AccessKeyMetadata<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛠️-使用示例" tabindex="-1"><a class="header-anchor" href="#🛠️-使用示例">#</a> 🛠️ 使用示例</h2>
<h3 id="完整的访问密钥管理示例" tabindex="-1"><a class="header-anchor" href="#完整的访问密钥管理示例">#</a> 完整的访问密钥管理示例</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"log"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/credentials/insecure"</span></span>
<span class="line">    <span class="token string">"google.golang.org/protobuf/types/known/fieldmaskpb"</span></span>
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 连接到服务</span></span>
<span class="line">    conn<span class="token punctuation">,</span> err <span class="token operator">:=</span> grpc<span class="token punctuation">.</span><span class="token function">Dial</span><span class="token punctuation">(</span><span class="token string">"localhost:50051"</span><span class="token punctuation">,</span> grpc<span class="token punctuation">.</span><span class="token function">WithTransportCredentials</span><span class="token punctuation">(</span>insecure<span class="token punctuation">.</span><span class="token function">NewCredentials</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"连接失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> conn<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    client <span class="token operator">:=</span> iamv1<span class="token punctuation">.</span><span class="token function">NewIAMClient</span><span class="token punctuation">(</span>conn<span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    userName <span class="token operator">:=</span> <span class="token string">"test_user"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 1. 创建访问密钥</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"1. 创建访问密钥..."</span><span class="token punctuation">)</span></span>
<span class="line">    createResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>      userName<span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span>   <span class="token string">"测试API密钥"</span><span class="token punctuation">,</span></span>
<span class="line">        ExpiresInDays<span class="token punctuation">:</span> <span class="token number">90</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"创建访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    accessKeyID <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>AccessKey<span class="token punctuation">.</span>AccessKeyId</span>
<span class="line">    secretAccessKey <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>AccessKey<span class="token punctuation">.</span>SecretAccessKey</span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"访问密钥创建成功:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  Access Key ID: %s\n"</span><span class="token punctuation">,</span> accessKeyID<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  Secret Access Key: %s\n"</span><span class="token punctuation">,</span> secretAccessKey<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  过期时间: %s\n"</span><span class="token punctuation">,</span> createResp<span class="token punctuation">.</span>AccessKey<span class="token punctuation">.</span>ExpiresAt<span class="token punctuation">.</span><span class="token function">AsTime</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>RFC3339<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 列出用户的访问密钥</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n2. 列出访问密钥..."</span><span class="token punctuation">)</span></span>
<span class="line">    listResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListAccessKeysRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"列出访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"找到 %d 个访问密钥:\n"</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>listResp<span class="token punctuation">.</span>AccessKeys<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> key <span class="token operator">:=</span> <span class="token keyword">range</span> listResp<span class="token punctuation">.</span>AccessKeys <span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  %d. %s - %s (%s)\n"</span><span class="token punctuation">,</span> i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> key<span class="token punctuation">.</span>AccessKeyId<span class="token punctuation">,</span> key<span class="token punctuation">.</span>Description<span class="token punctuation">,</span> key<span class="token punctuation">.</span>Status<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 禁用访问密钥</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n3. 禁用访问密钥..."</span><span class="token punctuation">)</span></span>
<span class="line">    updateResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">UpdateAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>UpdateAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">        AccessKeyId<span class="token punctuation">:</span> accessKeyID<span class="token punctuation">,</span></span>
<span class="line">        Status<span class="token punctuation">:</span>      iamv1<span class="token punctuation">.</span>AccessKeyStatus_ACCESS_KEY_STATUS_INACTIVE<span class="token punctuation">,</span></span>
<span class="line">        UpdateMask<span class="token punctuation">:</span> <span class="token operator">&amp;</span>fieldmaskpb<span class="token punctuation">.</span>FieldMask<span class="token punctuation">{</span></span>
<span class="line">            Paths<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"status"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"更新访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"访问密钥状态更新为: %s\n"</span><span class="token punctuation">,</span> updateResp<span class="token punctuation">.</span>AccessKey<span class="token punctuation">.</span>Status<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 重新启用访问密钥</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n4. 重新启用访问密钥..."</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">UpdateAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>UpdateAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">        AccessKeyId<span class="token punctuation">:</span> accessKeyID<span class="token punctuation">,</span></span>
<span class="line">        Status<span class="token punctuation">:</span>      iamv1<span class="token punctuation">.</span>AccessKeyStatus_ACCESS_KEY_STATUS_ACTIVE<span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"重新启用的测试API密钥"</span><span class="token punctuation">,</span></span>
<span class="line">        UpdateMask<span class="token punctuation">:</span> <span class="token operator">&amp;</span>fieldmaskpb<span class="token punctuation">.</span>FieldMask<span class="token punctuation">{</span></span>
<span class="line">            Paths<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"status"</span><span class="token punctuation">,</span> <span class="token string">"description"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"更新访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"访问密钥已重新启用"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 5. 删除访问密钥</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n5. 删除访问密钥..."</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DeleteAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">        AccessKeyId<span class="token punctuation">:</span> accessKeyID<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"删除访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"访问密钥删除成功"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 6. 验证删除</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n6. 验证删除结果..."</span><span class="token punctuation">)</span></span>
<span class="line">    listResp2<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListAccessKeysRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"列出访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"剩余访问密钥数量: %d\n"</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>listResp2<span class="token punctuation">.</span>AccessKeys<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="批量访问密钥管理脚本" tabindex="-1"><a class="header-anchor" href="#批量访问密钥管理脚本">#</a> 批量访问密钥管理脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量访问密钥管理脚本</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"><span class="token assign-left variable">USERS_FILE</span><span class="token operator">=</span><span class="token string">"users.txt"</span></span>
<span class="line"><span class="token assign-left variable">OUTPUT_FILE</span><span class="token operator">=</span><span class="token string">"access_keys.csv"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建CSV头部</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"用户名,访问密钥ID,秘密访问密钥,描述,状态,创建时间"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 为每个用户创建访问密钥</span></span>
<span class="line"><span class="token keyword">while</span> <span class="token assign-left variable"><span class="token environment constant">IFS</span></span><span class="token operator">=</span> <span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span> username<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"为用户 <span class="token variable">$username</span> 创建访问密钥..."</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 创建访问密钥</span></span>
<span class="line">    <span class="token assign-left variable">result</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$username</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>description<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span>批量创建的API密钥<span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/CreateAccessKey <span class="token operator"><span class="token file-descriptor important">2</span>></span>/dev/null<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token comment"># 解析结果</span></span>
<span class="line">        <span class="token assign-left variable">access_key_id</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.access_key_id'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">secret_access_key</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.secret_access_key'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">description</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.description'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">status</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.status'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">created_at</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.created_at'</span><span class="token variable">)</span></span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 写入CSV文件</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$username</span>,<span class="token variable">$access_key_id</span>,<span class="token variable">$secret_access_key</span>,<span class="token variable">$description</span>,<span class="token variable">$status</span>,<span class="token variable">$created_at</span>"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line">        </span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  成功: <span class="token variable">$access_key_id</span>"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  失败: 无法为用户 <span class="token variable">$username</span> 创建访问密钥"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token function">sleep</span> <span class="token number">0.1</span>  <span class="token comment"># 避免过快请求</span></span>
<span class="line"><span class="token keyword">done</span> <span class="token operator">&lt;</span> <span class="token string">"<span class="token variable">$USERS_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"批量创建完成，结果保存在 <span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="访问密钥轮换脚本" tabindex="-1"><a class="header-anchor" href="#访问密钥轮换脚本">#</a> 访问密钥轮换脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问密钥轮换脚本</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"><span class="token assign-left variable">USER_NAME</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$1</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-z</span> <span class="token string">"<span class="token variable">$USER_NAME</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"用法: <span class="token variable">$0</span> &lt;用户名>"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"开始为用户 <span class="token variable">$USER_NAME</span> 轮换访问密钥..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 1. 获取当前活跃的访问密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"1. 获取当前访问密钥..."</span></span>
<span class="line"><span class="token assign-left variable">current_keys</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$USER_NAME</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>status<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span>ACCESS_KEY_STATUS_ACTIVE<span class="token entity" title="\&quot;">\"</span></span>
<span class="line">}"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListAccessKeys<span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-ne</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"错误: 无法获取当前访问密钥"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 2. 创建新的访问密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"2. 创建新的访问密钥..."</span></span>
<span class="line"><span class="token assign-left variable">new_key</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$USER_NAME</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">    <span class="token entity" title="\&quot;">\"</span>description<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span>轮换生成的访问密钥 <span class="token variable"><span class="token variable">$(</span><span class="token function">date</span><span class="token variable">)</span></span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">}"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/CreateAccessKey<span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-ne</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"错误: 无法创建新的访问密钥"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">new_access_key_id</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$new_key</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.access_key_id'</span><span class="token variable">)</span></span></span>
<span class="line"><span class="token assign-left variable">new_secret_access_key</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$new_key</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key.secret_access_key'</span><span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"新访问密钥创建成功:"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  Access Key ID: <span class="token variable">$new_access_key_id</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  Secret Access Key: <span class="token variable">$new_secret_access_key</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 3. 等待用户确认更新应用配置</span></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"请更新您的应用配置以使用新的访问密钥，然后按回车键继续..."</span></span>
<span class="line"><span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 4. 禁用旧的访问密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"3. 禁用旧的访问密钥..."</span></span>
<span class="line"><span class="token assign-left variable">old_keys</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$current_keys</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_keys[].access_key_id'</span><span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">old_key_id</span> <span class="token keyword">in</span> <span class="token variable">$old_keys</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$old_key_id</span>"</span> <span class="token operator">!=</span> <span class="token string">"<span class="token variable">$new_access_key_id</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  禁用密钥: <span class="token variable">$old_key_id</span>"</span></span>
<span class="line">        grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">            <span class="token entity" title="\&quot;">\"</span>access_key_id<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$old_key_id</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">            <span class="token entity" title="\&quot;">\"</span>status<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span>ACCESS_KEY_STATUS_INACTIVE<span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">            <span class="token entity" title="\&quot;">\"</span>update_mask<span class="token entity" title="\&quot;">\"</span>: {</span>
<span class="line">                <span class="token entity" title="\&quot;">\"</span>paths<span class="token entity" title="\&quot;">\"</span>: [<span class="token entity" title="\&quot;">\"</span>status<span class="token entity" title="\&quot;">\"</span>]</span>
<span class="line">            }</span>
<span class="line">        }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/UpdateAccessKey <span class="token operator">></span> /dev/null</span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 5. 等待确认后删除旧密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"旧访问密钥已禁用。如果新密钥工作正常，按回车键删除旧密钥..."</span></span>
<span class="line"><span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"4. 删除旧的访问密钥..."</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">old_key_id</span> <span class="token keyword">in</span> <span class="token variable">$old_keys</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$old_key_id</span>"</span> <span class="token operator">!=</span> <span class="token string">"<span class="token variable">$new_access_key_id</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  删除密钥: <span class="token variable">$old_key_id</span>"</span></span>
<span class="line">        grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">            <span class="token entity" title="\&quot;">\"</span>access_key_id<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$old_key_id</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">        }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/DeleteAccessKey <span class="token operator">></span> /dev/null</span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"访问密钥轮换完成！"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔍-最佳实践">#</a> 🔍 最佳实践</h2>
<h3 id="_1-访问密钥安全" tabindex="-1"><a class="header-anchor" href="#_1-访问密钥安全">#</a> 1. 访问密钥安全</h3>
<h4 id="安全存储" tabindex="-1"><a class="header-anchor" href="#安全存储">#</a> 安全存储</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 使用环境变量</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">AWS_ACCESS_KEY_ID</span><span class="token operator">=</span><span class="token string">"AKIA1234567890EXAMPLE"</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">AWS_SECRET_ACCESS_KEY</span><span class="token operator">=</span><span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 使用配置文件（设置适当权限）</span></span>
<span class="line"><span class="token function">chmod</span> <span class="token number">600</span> ~/.aws/credentials</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="避免硬编码" tabindex="-1"><a class="header-anchor" href="#避免硬编码">#</a> 避免硬编码</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 错误做法</span></span>
<span class="line"><span class="token keyword">const</span> <span class="token punctuation">(</span></span>
<span class="line">    AccessKeyID     <span class="token operator">=</span> <span class="token string">"AKIA1234567890EXAMPLE"</span></span>
<span class="line">    SecretAccessKey <span class="token operator">=</span> <span class="token string">"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 正确做法</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getCredentials</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>Credentials<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    accessKeyID <span class="token operator">:=</span> os<span class="token punctuation">.</span><span class="token function">Getenv</span><span class="token punctuation">(</span><span class="token string">"AWS_ACCESS_KEY_ID"</span><span class="token punctuation">)</span></span>
<span class="line">    secretAccessKey <span class="token operator">:=</span> os<span class="token punctuation">.</span><span class="token function">Getenv</span><span class="token punctuation">(</span><span class="token string">"AWS_SECRET_ACCESS_KEY"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> accessKeyID <span class="token operator">==</span> <span class="token string">""</span> <span class="token operator">||</span> secretAccessKey <span class="token operator">==</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"缺少访问密钥配置"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>Credentials<span class="token punctuation">{</span></span>
<span class="line">        AccessKeyID<span class="token punctuation">:</span>     accessKeyID<span class="token punctuation">,</span></span>
<span class="line">        SecretAccessKey<span class="token punctuation">:</span> secretAccessKey<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-密钥轮换策略" tabindex="-1"><a class="header-anchor" href="#_2-密钥轮换策略">#</a> 2. 密钥轮换策略</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 定期轮换访问密钥</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">rotateAccessKeys</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">,</span> userName <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 1. 创建新密钥</span></span>
<span class="line">    newKey<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>    userName<span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"轮换密钥 %s"</span><span class="token punctuation">,</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span><span class="token string">"2006-01-02"</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"创建新密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 更新应用配置（这里需要根据实际情况实现）</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> <span class="token function">updateApplicationConfig</span><span class="token punctuation">(</span>newKey<span class="token punctuation">.</span>AccessKey<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"更新应用配置失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 等待配置生效</span></span>
<span class="line">    time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span><span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 删除旧密钥</span></span>
<span class="line">    oldKeys<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListAccessKeysRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">        Status<span class="token punctuation">:</span>   iamv1<span class="token punctuation">.</span>AccessKeyStatus_ACCESS_KEY_STATUS_ACTIVE<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"获取旧密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> key <span class="token operator">:=</span> <span class="token keyword">range</span> oldKeys<span class="token punctuation">.</span>AccessKeys <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> key<span class="token punctuation">.</span>AccessKeyId <span class="token operator">!=</span> newKey<span class="token punctuation">.</span>AccessKey<span class="token punctuation">.</span>AccessKeyId <span class="token punctuation">{</span></span>
<span class="line">            <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">DeleteAccessKey</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteAccessKeyRequest<span class="token punctuation">{</span></span>
<span class="line">                AccessKeyId<span class="token punctuation">:</span> key<span class="token punctuation">.</span>AccessKeyId<span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"删除旧密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-密钥使用监控" tabindex="-1"><a class="header-anchor" href="#_3-密钥使用监控">#</a> 3. 密钥使用监控</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 监控访问密钥使用情况</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">monitorAccessKeyUsage</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">,</span> userName <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    keys<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListAccessKeys</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListAccessKeysRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"获取访问密钥失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> key <span class="token operator">:=</span> <span class="token keyword">range</span> keys<span class="token punctuation">.</span>AccessKeys <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 检查最后使用时间</span></span>
<span class="line">        <span class="token keyword">if</span> key<span class="token punctuation">.</span>LastUsedAt <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            lastUsed <span class="token operator">:=</span> key<span class="token punctuation">.</span>LastUsedAt<span class="token punctuation">.</span><span class="token function">AsTime</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>lastUsed<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">30</span><span class="token operator">*</span><span class="token number">24</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Hour <span class="token punctuation">{</span> <span class="token comment">// 30天未使用</span></span>
<span class="line">                log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"警告: 访问密钥 %s 已超过30天未使用"</span><span class="token punctuation">,</span> key<span class="token punctuation">.</span>AccessKeyId<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 检查过期时间</span></span>
<span class="line">        <span class="token keyword">if</span> key<span class="token punctuation">.</span>ExpiresAt <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            expiresAt <span class="token operator">:=</span> key<span class="token punctuation">.</span>ExpiresAt<span class="token punctuation">.</span><span class="token function">AsTime</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> time<span class="token punctuation">.</span><span class="token function">Until</span><span class="token punctuation">(</span>expiresAt<span class="token punctuation">)</span> <span class="token operator">&lt;</span> <span class="token number">7</span><span class="token operator">*</span><span class="token number">24</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Hour <span class="token punctuation">{</span> <span class="token comment">// 7天内过期</span></span>
<span class="line">                log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"警告: 访问密钥 %s 将在7天内过期"</span><span class="token punctuation">,</span> key<span class="token punctuation">.</span>AccessKeyId<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-错误处理和重试" tabindex="-1"><a class="header-anchor" href="#_4-错误处理和重试">#</a> 4. 错误处理和重试</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 带重试的访问密钥操作</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">createAccessKeyWithRetry</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">,</span> req <span class="token operator">*</span>iamv1<span class="token punctuation">.</span>CreateAccessKeyRequest<span class="token punctuation">,</span> maxRetries <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>CreateAccessKeyResponse<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> lastErr <span class="token builtin">error</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> maxRetries<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateAccessKey</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> resp<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        lastErr <span class="token operator">=</span> err</span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 检查是否为可重试错误</span></span>
<span class="line">        <span class="token keyword">if</span> status<span class="token punctuation">.</span><span class="token function">Code</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span> <span class="token operator">==</span> codes<span class="token punctuation">.</span>ResourceExhausted <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 达到密钥数量限制，不重试</span></span>
<span class="line">            <span class="token keyword">break</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 指数退避</span></span>
<span class="line">        backoff <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span>math<span class="token punctuation">.</span><span class="token function">Pow</span><span class="token punctuation">(</span><span class="token number">2</span><span class="token punctuation">,</span> <span class="token function">float64</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second</span>
<span class="line">        time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span>backoff<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"创建访问密钥失败，已重试%d次: %v"</span><span class="token punctuation">,</span> maxRetries<span class="token punctuation">,</span> lastErr<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_5-访问密钥审计" tabindex="-1"><a class="header-anchor" href="#_5-访问密钥审计">#</a> 5. 访问密钥审计</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问密钥审计脚本</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"><span class="token assign-left variable">REPORT_FILE</span><span class="token operator">=</span><span class="token string">"access_key_audit_<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d<span class="token variable">)</span></span>.txt"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== 访问密钥审计报告 ==="</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"生成时间: <span class="token variable"><span class="token variable">$(</span><span class="token function">date</span><span class="token variable">)</span></span>"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 获取所有用户</span></span>
<span class="line"><span class="token assign-left variable">users</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 1000</span>
<span class="line">}'</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListUsers <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.users[].name'</span><span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"1. 用户访问密钥统计"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"用户名,活跃密钥数,非活跃密钥数,总数"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">user</span> <span class="token keyword">in</span> <span class="token variable">$users</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token comment"># 获取用户的访问密钥</span></span>
<span class="line">    <span class="token assign-left variable">keys</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$user</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListAccessKeys<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token assign-left variable">active_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$keys</span>"</span> <span class="token operator">|</span> jq <span class="token string">'[.access_keys[] | select(.status == "ACCESS_KEY_STATUS_ACTIVE")] | length'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">inactive_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$keys</span>"</span> <span class="token operator">|</span> jq <span class="token string">'[.access_keys[] | select(.status == "ACCESS_KEY_STATUS_INACTIVE")] | length'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">total_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$keys</span>"</span> <span class="token operator">|</span> jq <span class="token string">'.access_keys | length'</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$user</span>,<span class="token variable">$active_count</span>,<span class="token variable">$inactive_count</span>,<span class="token variable">$total_count</span>"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"2. 长期未使用的访问密钥"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"用户名,访问密钥ID,最后使用时间,天数"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查找长期未使用的密钥（超过30天）</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">user</span> <span class="token keyword">in</span> <span class="token variable">$users</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token assign-left variable">keys</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>user_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$user</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListAccessKeys<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$keys</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token parameter variable">--arg</span> user <span class="token string">"<span class="token variable">$user</span>"</span> <span class="token string">'</span>
<span class="line">        .access_keys[] | </span>
<span class="line">        select(.last_used_at != null) |</span>
<span class="line">        select((now - (.last_used_at | fromdateiso8601)) > (30 * 24 * 3600)) |</span>
<span class="line">        "\($user),\(.access_key_id),\(.last_used_at),\((now - (.last_used_at | fromdateiso8601)) / (24 * 3600) | floor)"</span>
<span class="line">    '</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"审计报告已生成: <span class="token variable">$REPORT_FILE</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-注意事项" tabindex="-1"><a class="header-anchor" href="#🚨-注意事项">#</a> 🚨 注意事项</h2>
<h3 id="安全考虑" tabindex="-1"><a class="header-anchor" href="#安全考虑">#</a> 安全考虑</h3>
<ol>
<li>
<p><strong>密钥保护</strong>：</p>
<ul>
<li>永远不要在代码中硬编码访问密钥</li>
<li>使用环境变量或安全的配置管理系统</li>
<li>设置适当的文件权限（600）</li>
</ul>
</li>
<li>
<p><strong>密钥轮换</strong>：</p>
<ul>
<li>定期轮换访问密钥（建议90天）</li>
<li>监控密钥使用情况</li>
<li>及时删除不使用的密钥</li>
</ul>
</li>
<li>
<p><strong>访问控制</strong>：</p>
<ul>
<li>遵循最小权限原则</li>
<li>为不同用途创建不同的密钥</li>
<li>定期审查密钥权限</li>
</ul>
</li>
</ol>
<h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<ol>
<li>
<p><strong>连接复用</strong>：</p>
<ul>
<li>使用连接池</li>
<li>避免频繁创建连接</li>
<li>设置合适的超时时间</li>
</ul>
</li>
<li>
<p><strong>批量操作</strong>：</p>
<ul>
<li>避免循环调用API</li>
<li>使用分页查询大量数据</li>
<li>合理控制并发数</li>
</ul>
</li>
</ol>
<h3 id="错误处理" tabindex="-1"><a class="header-anchor" href="#错误处理">#</a> 错误处理</h3>
<ol>
<li>
<p><strong>重试策略</strong>：</p>
<ul>
<li>实现指数退避重试</li>
<li>区分可重试和不可重试错误</li>
<li>设置最大重试次数</li>
</ul>
</li>
<li>
<p><strong>监控告警</strong>：</p>
<ul>
<li>监控API调用成功率</li>
<li>设置密钥过期告警</li>
<li>监控异常使用模式</li>
</ul>
</li>
</ol>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议为每个应用或服务创建独立的访问密钥，便于管理和审计。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>访问密钥的秘密部分只在创建时返回一次，请务必妥善保存。如果丢失，需要重新创建新的密钥。</p>
</div>
</div></template>


