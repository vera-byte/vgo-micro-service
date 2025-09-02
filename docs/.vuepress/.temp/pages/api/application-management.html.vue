<template><div><h1 id="应用管理-api" tabindex="-1"><a class="header-anchor" href="#应用管理-api">#</a> 应用管理 API</h1>
<p>应用管理API提供了完整的应用生命周期管理功能，包括应用的创建、查询、更新和删除操作。应用是VGO系统中的重要概念，用于组织和管理相关的用户、策略和访问密钥。</p>
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
<td><code v-pre>CreateApplication</code></td>
<td>创建应用</td>
<td><code v-pre>iam:CreateApplication</code></td>
</tr>
<tr>
<td><code v-pre>GetApplication</code></td>
<td>获取应用详情</td>
<td><code v-pre>iam:GetApplication</code></td>
</tr>
<tr>
<td><code v-pre>UpdateApplication</code></td>
<td>更新应用信息</td>
<td><code v-pre>iam:UpdateApplication</code></td>
</tr>
<tr>
<td><code v-pre>DeleteApplication</code></td>
<td>删除应用</td>
<td><code v-pre>iam:DeleteApplication</code></td>
</tr>
<tr>
<td><code v-pre>ListApplications</code></td>
<td>获取应用列表</td>
<td><code v-pre>iam:ListApplications</code></td>
</tr>
</tbody>
</table>
<h2 id="🔧-api-详情" tabindex="-1"><a class="header-anchor" href="#🔧-api-详情">#</a> 🔧 API 详情</h2>
<h3 id="createapplication-创建应用" tabindex="-1"><a class="header-anchor" href="#createapplication-创建应用">#</a> CreateApplication - 创建应用</h3>
<p>创建一个新的应用实例。</p>
<h4 id="请求" tabindex="-1"><a class="header-anchor" href="#请求">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateApplicationRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 应用名称（必需，唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>       <span class="token comment">// 应用描述（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> homepage_url <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>      <span class="token comment">// 主页URL（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> callback_url <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>      <span class="token comment">// 回调URL（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationType</span> type <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>     <span class="token comment">// 应用类型（必需）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> scopes <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>   <span class="token comment">// 权限范围（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应" tabindex="-1"><a class="header-anchor" href="#响应">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateApplicationResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Application</span> application <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>   <span class="token comment">// 创建的应用信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例" tabindex="-1"><a class="header-anchor" href="#示例">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建Web应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "my-web-app",</span>
<span class="line">  "description": "我的Web应用",</span>
<span class="line">  "homepage_url": "https://example.com",</span>
<span class="line">  "callback_url": "https://example.com/callback",</span>
<span class="line">  "type": "APPLICATION_TYPE_WEB",</span>
<span class="line">  "scopes": ["read", "write"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建移动应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "my-mobile-app",</span>
<span class="line">  "description": "我的移动应用",</span>
<span class="line">  "type": "APPLICATION_TYPE_MOBILE",</span>
<span class="line">  "scopes": ["read", "write", "offline_access"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例" tabindex="-1"><a class="header-anchor" href="#响应示例">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"application"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"app-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"my-web-app"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"我的Web应用"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"homepage_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"callback_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com/callback"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_WEB"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"client_id"</span><span class="token operator">:</span> <span class="token string">"client_1234567890abcdef"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"client_secret"</span><span class="token operator">:</span> <span class="token string">"secret_abcdef1234567890"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="hint-container warning">
<p class="hint-container-title">重要提示</p>
<p><code v-pre>client_secret</code> 只在创建时返回一次，请妥善保存。后续无法再次获取。</p>
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
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>应用名称已存在</td>
<td>使用不同的应用名称</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的URL格式</td>
<td>检查URL格式是否正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的应用类型</td>
<td>使用有效的应用类型</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无创建应用权限</td>
<td>确保有<code v-pre>iam:CreateApplication</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="getapplication-获取应用详情" tabindex="-1"><a class="header-anchor" href="#getapplication-获取应用详情">#</a> GetApplication - 获取应用详情</h3>
<p>根据应用ID或名称获取应用的详细信息。</p>
<h4 id="请求-1" tabindex="-1"><a class="header-anchor" href="#请求-1">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetApplicationRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 应用ID</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>            <span class="token comment">// 应用名称</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-1" tabindex="-1"><a class="header-anchor" href="#响应-1">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetApplicationResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Application</span> application <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>   <span class="token comment">// 应用信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-1" tabindex="-1"><a class="header-anchor" href="#示例-1">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过ID获取应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过名称获取应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "my-web-app"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-1" tabindex="-1"><a class="header-anchor" href="#响应示例-1">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"application"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"app-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"my-web-app"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"我的Web应用"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"homepage_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"callback_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com/callback"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_WEB"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"client_id"</span><span class="token operator">:</span> <span class="token string">"client_1234567890abcdef"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"last_used_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_count"</span><span class="token operator">:</span> <span class="token number">150</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"access_key_count"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>出于安全考虑，获取接口不返回 <code v-pre>client_secret</code> 字段。</p>
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
<td>应用不存在</td>
<td>确认应用ID或名称正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>缺少标识符</td>
<td>提供应用ID或名称</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无查看应用权限</td>
<td>确保有<code v-pre>iam:GetApplication</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="updateapplication-更新应用信息" tabindex="-1"><a class="header-anchor" href="#updateapplication-更新应用信息">#</a> UpdateApplication - 更新应用信息</h3>
<p>更新应用的基本信息、状态或配置。</p>
<h4 id="请求-2" tabindex="-1"><a class="header-anchor" href="#请求-2">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateApplicationRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                        <span class="token comment">// 应用ID（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                      <span class="token comment">// 新名称（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>               <span class="token comment">// 新描述（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> homepage_url <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>              <span class="token comment">// 新主页URL（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> callback_url <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>              <span class="token comment">// 新回调URL（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationStatus</span> status <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>         <span class="token comment">// 新状态（可选）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> scopes <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>           <span class="token comment">// 新权限范围（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>FieldMask</span> update_mask <span class="token operator">=</span> <span class="token number">8</span><span class="token punctuation">;</span>  <span class="token comment">// 更新字段掩码</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-2" tabindex="-1"><a class="header-anchor" href="#响应-2">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateApplicationResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Application</span> application <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>          <span class="token comment">// 更新后的应用信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-2" tabindex="-1"><a class="header-anchor" href="#示例-2">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新应用描述</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456",</span>
<span class="line">  "description": "更新后的应用描述",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["description"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 禁用应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456",</span>
<span class="line">  "status": "APPLICATION_STATUS_INACTIVE",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["status"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新多个字段</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456",</span>
<span class="line">  "description": "全新的应用描述",</span>
<span class="line">  "homepage_url": "https://newdomain.com",</span>
<span class="line">  "scopes": ["read", "write", "admin"],</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["description", "homepage_url", "scopes"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-2" tabindex="-1"><a class="header-anchor" href="#响应示例-2">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"application"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"app-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"my-web-app"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"更新后的应用描述"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"homepage_url"</span><span class="token operator">:</span> <span class="token string">"https://newdomain.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"callback_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com/callback"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_WEB"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"client_id"</span><span class="token operator">:</span> <span class="token string">"client_1234567890abcdef"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T14:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"last_used_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"user_count"</span><span class="token operator">:</span> <span class="token number">150</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"access_key_count"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-2" tabindex="-1"><a class="header-anchor" href="#错误情况-2">#</a> 错误情况</h4>
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
<td>应用不存在</td>
<td>确认应用ID正确</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>新名称已被使用</td>
<td>使用不同的应用名称</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的URL格式</td>
<td>检查URL格式是否正确</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无更新应用权限</td>
<td>确保有<code v-pre>iam:UpdateApplication</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="deleteapplication-删除应用" tabindex="-1"><a class="header-anchor" href="#deleteapplication-删除应用">#</a> DeleteApplication - 删除应用</h3>
<p>删除指定的应用。</p>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>删除应用是不可逆操作，会同时删除关联的访问密钥和用户绑定关系。</p>
</div>
<h4 id="请求-3" tabindex="-1"><a class="header-anchor" href="#请求-3">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteApplicationRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                <span class="token comment">// 应用ID（必需）</span></span>
<span class="line">  <span class="token builtin">bool</span> force <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>               <span class="token comment">// 强制删除（可选，默认false）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-3" tabindex="-1"><a class="header-anchor" href="#响应-3">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteApplicationResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-3" tabindex="-1"><a class="header-anchor" href="#示例-3">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 删除应用（如果有关联资源会失败）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 强制删除应用（删除所有关联资源）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "app-123456",</span>
<span class="line">  "force": true</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteApplication</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-3" tabindex="-1"><a class="header-anchor" href="#响应示例-3">#</a> 响应示例</h4>
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
<td>应用不存在</td>
<td>确认应用ID正确</td>
</tr>
<tr>
<td><code v-pre>FAILED_PRECONDITION</code></td>
<td>应用有关联资源</td>
<td>先删除关联资源或使用force=true</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无删除应用权限</td>
<td>确保有<code v-pre>iam:DeleteApplication</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="listapplications-获取应用列表" tabindex="-1"><a class="header-anchor" href="#listapplications-获取应用列表">#</a> ListApplications - 获取应用列表</h3>
<p>获取应用列表，支持分页和过滤。</p>
<h4 id="请求-4" tabindex="-1"><a class="header-anchor" href="#请求-4">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListApplicationsRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationType</span> type <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 应用类型过滤（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationStatus</span> status <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span> <span class="token comment">// 应用状态过滤（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> name_filter <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>       <span class="token comment">// 名称过滤（支持模糊匹配）</span></span>
<span class="line">  <span class="token builtin">int32</span> page <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>              <span class="token comment">// 页码（从1开始）</span></span>
<span class="line">  <span class="token builtin">int32</span> page_size <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>         <span class="token comment">// 每页大小（最大100）</span></span>
<span class="line">  <span class="token builtin">string</span> sort_by <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>          <span class="token comment">// 排序字段（name, created_at, updated_at）</span></span>
<span class="line">  <span class="token builtin">bool</span> sort_desc <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>          <span class="token comment">// 是否降序排列</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-4" tabindex="-1"><a class="header-anchor" href="#响应-4">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListApplicationsResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">Application</span> applications <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>  <span class="token comment">// 应用列表</span></span>
<span class="line">  <span class="token positional-class-name class-name">Pagination</span> pagination <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>              <span class="token comment">// 分页信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-4" tabindex="-1"><a class="header-anchor" href="#示例-4">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取所有应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListApplications</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取Web应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "type": "APPLICATION_TYPE_WEB",</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListApplications</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 搜索应用名称包含"api"的应用</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name_filter": "api",</span>
<span class="line">  "sort_by": "created_at",</span>
<span class="line">  "sort_desc": true,</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 20</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListApplications</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-4" tabindex="-1"><a class="header-anchor" href="#响应示例-4">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"applications"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"app-123456"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"my-web-app"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"我的Web应用"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"homepage_url"</span><span class="token operator">:</span> <span class="token string">"https://example.com"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_WEB"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"client_id"</span><span class="token operator">:</span> <span class="token string">"client_1234567890abcdef"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T14:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"last_used_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_count"</span><span class="token operator">:</span> <span class="token number">150</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"access_key_count"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"app-789012"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"my-api-service"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"API服务应用"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_SERVICE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"client_id"</span><span class="token operator">:</span> <span class="token string">"client_0987654321fedcba"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-10T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-10T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"user_count"</span><span class="token operator">:</span> <span class="token number">25</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"access_key_count"</span><span class="token operator">:</span> <span class="token number">2</span></span>
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
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-4" tabindex="-1"><a class="header-anchor" href="#错误情况-4">#</a> 错误情况</h4>
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
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的分页参数</td>
<td>检查page和page_size值</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的排序字段</td>
<td>使用有效的排序字段</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无查看应用列表权限</td>
<td>确保有<code v-pre>iam:ListApplications</code>权限</td>
</tr>
</tbody>
</table>
<h2 id="📊-数据模型" tabindex="-1"><a class="header-anchor" href="#📊-数据模型">#</a> 📊 数据模型</h2>
<h3 id="application-对象" tabindex="-1"><a class="header-anchor" href="#application-对象">#</a> Application 对象</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">Application</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                        <span class="token comment">// 应用ID（系统生成）</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                      <span class="token comment">// 应用名称（唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>               <span class="token comment">// 应用描述</span></span>
<span class="line">  <span class="token builtin">string</span> homepage_url <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>              <span class="token comment">// 主页URL</span></span>
<span class="line">  <span class="token builtin">string</span> callback_url <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>              <span class="token comment">// 回调URL</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationType</span> type <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>             <span class="token comment">// 应用类型</span></span>
<span class="line">  <span class="token positional-class-name class-name">ApplicationStatus</span> status <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>         <span class="token comment">// 应用状态</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> scopes <span class="token operator">=</span> <span class="token number">8</span><span class="token punctuation">;</span>           <span class="token comment">// 权限范围</span></span>
<span class="line">  <span class="token builtin">string</span> client_id <span class="token operator">=</span> <span class="token number">9</span><span class="token punctuation">;</span>                 <span class="token comment">// 客户端ID</span></span>
<span class="line">  <span class="token builtin">string</span> client_secret <span class="token operator">=</span> <span class="token number">10</span><span class="token punctuation">;</span>            <span class="token comment">// 客户端密钥（仅创建时返回）</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> created_at <span class="token operator">=</span> <span class="token number">11</span><span class="token punctuation">;</span>    <span class="token comment">// 创建时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> updated_at <span class="token operator">=</span> <span class="token number">12</span><span class="token punctuation">;</span>    <span class="token comment">// 更新时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> last_used_at <span class="token operator">=</span> <span class="token number">13</span><span class="token punctuation">;</span>  <span class="token comment">// 最后使用时间</span></span>
<span class="line">  <span class="token builtin">int32</span> user_count <span class="token operator">=</span> <span class="token number">14</span><span class="token punctuation">;</span>                <span class="token comment">// 关联用户数</span></span>
<span class="line">  <span class="token builtin">int32</span> access_key_count <span class="token operator">=</span> <span class="token number">15</span><span class="token punctuation">;</span>          <span class="token comment">// 访问密钥数</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="applicationtype-枚举" tabindex="-1"><a class="header-anchor" href="#applicationtype-枚举">#</a> ApplicationType 枚举</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">ApplicationType</span> <span class="token punctuation">{</span></span>
<span class="line">  APPLICATION_TYPE_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span>     <span class="token comment">// 未指定</span></span>
<span class="line">  APPLICATION_TYPE_WEB <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>             <span class="token comment">// Web应用</span></span>
<span class="line">  APPLICATION_TYPE_MOBILE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 移动应用</span></span>
<span class="line">  APPLICATION_TYPE_DESKTOP <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>         <span class="token comment">// 桌面应用</span></span>
<span class="line">  APPLICATION_TYPE_SERVICE <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>         <span class="token comment">// 服务应用</span></span>
<span class="line">  APPLICATION_TYPE_SPA <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>             <span class="token comment">// 单页应用</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="applicationstatus-枚举" tabindex="-1"><a class="header-anchor" href="#applicationstatus-枚举">#</a> ApplicationStatus 枚举</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">ApplicationStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  APPLICATION_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span>   <span class="token comment">// 未指定</span></span>
<span class="line">  APPLICATION_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>        <span class="token comment">// 活跃</span></span>
<span class="line">  APPLICATION_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 非活跃</span></span>
<span class="line">  APPLICATION_STATUS_SUSPENDED <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>     <span class="token comment">// 暂停</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-权限要求" tabindex="-1"><a class="header-anchor" href="#🔐-权限要求">#</a> 🔐 权限要求</h2>
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
<td>创建应用</td>
<td><code v-pre>iam:CreateApplication</code></td>
<td><code v-pre>arn:iam::application/*</code></td>
</tr>
<tr>
<td>获取应用</td>
<td><code v-pre>iam:GetApplication</code></td>
<td><code v-pre>arn:iam::application/*</code> 或 <code v-pre>arn:iam::application/${app:id}</code></td>
</tr>
<tr>
<td>更新应用</td>
<td><code v-pre>iam:UpdateApplication</code></td>
<td><code v-pre>arn:iam::application/*</code> 或 <code v-pre>arn:iam::application/${app:id}</code></td>
</tr>
<tr>
<td>删除应用</td>
<td><code v-pre>iam:DeleteApplication</code></td>
<td><code v-pre>arn:iam::application/*</code> 或 <code v-pre>arn:iam::application/${app:id}</code></td>
</tr>
<tr>
<td>列表应用</td>
<td><code v-pre>iam:ListApplications</code></td>
<td><code v-pre>arn:iam::application/*</code></td>
</tr>
</tbody>
</table>
<h3 id="策略示例" tabindex="-1"><a class="header-anchor" href="#策略示例">#</a> 策略示例</h3>
<h4 id="应用开发者策略" tabindex="-1"><a class="header-anchor" href="#应用开发者策略">#</a> 应用开发者策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CreateApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListApplications"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"arn:iam::application/*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"StringEquals"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"iam:ApplicationOwner"</span><span class="token operator">:</span> <span class="token string">"${aws:username}"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="应用管理员策略" tabindex="-1"><a class="header-anchor" href="#应用管理员策略">#</a> 应用管理员策略</h4>
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
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="只读访问策略" tabindex="-1"><a class="header-anchor" href="#只读访问策略">#</a> 只读访问策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetApplication"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListApplications"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"arn:iam::application/*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛠️-使用示例" tabindex="-1"><a class="header-anchor" href="#🛠️-使用示例">#</a> 🛠️ 使用示例</h2>
<h3 id="go-客户端示例" tabindex="-1"><a class="header-anchor" href="#go-客户端示例">#</a> Go 客户端示例</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"log"</span></span>
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
<span class="line">    <span class="token comment">// 1. 创建应用</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"1. 创建应用..."</span><span class="token punctuation">)</span></span>
<span class="line">    createResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"my-test-app"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"测试应用"</span><span class="token punctuation">,</span></span>
<span class="line">        HomepageUrl<span class="token punctuation">:</span> <span class="token string">"https://example.com"</span><span class="token punctuation">,</span></span>
<span class="line">        CallbackUrl<span class="token punctuation">:</span> <span class="token string">"https://example.com/callback"</span><span class="token punctuation">,</span></span>
<span class="line">        Type<span class="token punctuation">:</span>        iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_WEB<span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"创建应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    appID <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Id</span>
<span class="line">    clientID <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>ClientId</span>
<span class="line">    clientSecret <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>ClientSecret</span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"应用创建成功:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  应用ID: %s\n"</span><span class="token punctuation">,</span> appID<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  客户端ID: %s\n"</span><span class="token punctuation">,</span> clientID<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  客户端密钥: %s\n"</span><span class="token punctuation">,</span> clientSecret<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 获取应用详情</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n2. 获取应用详情..."</span><span class="token punctuation">)</span></span>
<span class="line">    getResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">GetApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>GetApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Id<span class="token punctuation">:</span> appID<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"获取应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"应用详情:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  名称: %s\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Name<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  描述: %s\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Description<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  类型: %s\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Type<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  状态: %s\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Status<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  权限范围: %v\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Scopes<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 更新应用</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n3. 更新应用..."</span><span class="token punctuation">)</span></span>
<span class="line">    updateResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">UpdateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>UpdateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Id<span class="token punctuation">:</span>          appID<span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"更新后的测试应用"</span><span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        UpdateMask<span class="token punctuation">:</span> <span class="token operator">&amp;</span>fieldmaskpb<span class="token punctuation">.</span>FieldMask<span class="token punctuation">{</span></span>
<span class="line">            Paths<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"description"</span><span class="token punctuation">,</span> <span class="token string">"scopes"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"更新应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"应用更新成功:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  新描述: %s\n"</span><span class="token punctuation">,</span> updateResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Description<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  新权限范围: %v\n"</span><span class="token punctuation">,</span> updateResp<span class="token punctuation">.</span>Application<span class="token punctuation">.</span>Scopes<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 列出应用</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n4. 列出应用..."</span><span class="token punctuation">)</span></span>
<span class="line">    listResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListApplications</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListApplicationsRequest<span class="token punctuation">{</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">        SortBy<span class="token punctuation">:</span>   <span class="token string">"created_at"</span><span class="token punctuation">,</span></span>
<span class="line">        SortDesc<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"列出应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"找到 %d 个应用:\n"</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>listResp<span class="token punctuation">.</span>Applications<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> app <span class="token operator">:=</span> <span class="token keyword">range</span> listResp<span class="token punctuation">.</span>Applications <span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  %d. %s (%s) - %s\n"</span><span class="token punctuation">,</span> i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> app<span class="token punctuation">.</span>Name<span class="token punctuation">,</span> app<span class="token punctuation">.</span>Type<span class="token punctuation">,</span> app<span class="token punctuation">.</span>Status<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 5. 删除应用</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n5. 删除应用..."</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DeleteApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Id<span class="token punctuation">:</span> appID<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"删除应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"应用删除成功"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="python-客户端示例" tabindex="-1"><a class="header-anchor" href="#python-客户端示例">#</a> Python 客户端示例</h3>
<div class="language-python line-numbers-mode" data-highlighter="prismjs" data-ext="py"><pre v-pre><code class="language-python"><span class="line"><span class="token keyword">import</span> grpc</span>
<span class="line"><span class="token keyword">from</span> google<span class="token punctuation">.</span>protobuf <span class="token keyword">import</span> field_mask_pb2</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 假设已生成的Python gRPC客户端</span></span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2<span class="token punctuation">,</span> iam_pb2_grpc</span>
<span class="line"></span>
<span class="line"><span class="token keyword">def</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 连接到服务</span></span>
<span class="line">    <span class="token keyword">with</span> grpc<span class="token punctuation">.</span>insecure_channel<span class="token punctuation">(</span><span class="token string">'localhost:50051'</span><span class="token punctuation">)</span> <span class="token keyword">as</span> channel<span class="token punctuation">:</span></span>
<span class="line">        client <span class="token operator">=</span> iam_pb2_grpc<span class="token punctuation">.</span>IAMStub<span class="token punctuation">(</span>channel<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 1. 创建应用</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"1. 创建应用..."</span><span class="token punctuation">)</span></span>
<span class="line">        create_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">(</span></span>
<span class="line">            name<span class="token operator">=</span><span class="token string">"my-python-app"</span><span class="token punctuation">,</span></span>
<span class="line">            description<span class="token operator">=</span><span class="token string">"Python测试应用"</span><span class="token punctuation">,</span></span>
<span class="line">            homepage_url<span class="token operator">=</span><span class="token string">"https://python-app.com"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token builtin">type</span><span class="token operator">=</span>iam_pb2<span class="token punctuation">.</span>APPLICATION_TYPE_DESKTOP<span class="token punctuation">,</span></span>
<span class="line">            scopes<span class="token operator">=</span><span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        create_response <span class="token operator">=</span> client<span class="token punctuation">.</span>CreateApplication<span class="token punctuation">(</span>create_request<span class="token punctuation">)</span></span>
<span class="line">        app_id <span class="token operator">=</span> create_response<span class="token punctuation">.</span>application<span class="token punctuation">.</span><span class="token builtin">id</span></span>
<span class="line">        client_id <span class="token operator">=</span> create_response<span class="token punctuation">.</span>application<span class="token punctuation">.</span>client_id</span>
<span class="line">        client_secret <span class="token operator">=</span> create_response<span class="token punctuation">.</span>application<span class="token punctuation">.</span>client_secret</span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"应用创建成功:"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  应用ID: </span><span class="token interpolation"><span class="token punctuation">{</span>app_id<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  客户端ID: </span><span class="token interpolation"><span class="token punctuation">{</span>client_id<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  客户端密钥: </span><span class="token interpolation"><span class="token punctuation">{</span>client_secret<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 2. 获取应用详情</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n2. 获取应用详情..."</span><span class="token punctuation">)</span></span>
<span class="line">        get_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>GetApplicationRequest<span class="token punctuation">(</span><span class="token builtin">id</span><span class="token operator">=</span>app_id<span class="token punctuation">)</span></span>
<span class="line">        get_response <span class="token operator">=</span> client<span class="token punctuation">.</span>GetApplication<span class="token punctuation">(</span>get_request<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        app <span class="token operator">=</span> get_response<span class="token punctuation">.</span>application</span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"应用详情:"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  名称: </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span>name<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  描述: </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span>description<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  类型: </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span><span class="token builtin">type</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  状态: </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span>status<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  权限范围: </span><span class="token interpolation"><span class="token punctuation">{</span><span class="token builtin">list</span><span class="token punctuation">(</span>app<span class="token punctuation">.</span>scopes<span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 3. 更新应用</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n3. 更新应用..."</span><span class="token punctuation">)</span></span>
<span class="line">        update_mask <span class="token operator">=</span> field_mask_pb2<span class="token punctuation">.</span>FieldMask<span class="token punctuation">(</span>paths<span class="token operator">=</span><span class="token punctuation">[</span><span class="token string">"description"</span><span class="token punctuation">,</span> <span class="token string">"status"</span><span class="token punctuation">]</span><span class="token punctuation">)</span></span>
<span class="line">        update_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>UpdateApplicationRequest<span class="token punctuation">(</span></span>
<span class="line">            <span class="token builtin">id</span><span class="token operator">=</span>app_id<span class="token punctuation">,</span></span>
<span class="line">            description<span class="token operator">=</span><span class="token string">"更新后的Python应用"</span><span class="token punctuation">,</span></span>
<span class="line">            status<span class="token operator">=</span>iam_pb2<span class="token punctuation">.</span>APPLICATION_STATUS_INACTIVE<span class="token punctuation">,</span></span>
<span class="line">            update_mask<span class="token operator">=</span>update_mask</span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        update_response <span class="token operator">=</span> client<span class="token punctuation">.</span>UpdateApplication<span class="token punctuation">(</span>update_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"应用更新成功:"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  新描述: </span><span class="token interpolation"><span class="token punctuation">{</span>update_response<span class="token punctuation">.</span>application<span class="token punctuation">.</span>description<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  新状态: </span><span class="token interpolation"><span class="token punctuation">{</span>update_response<span class="token punctuation">.</span>application<span class="token punctuation">.</span>status<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 4. 列出应用</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n4. 列出应用..."</span><span class="token punctuation">)</span></span>
<span class="line">        list_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>ListApplicationsRequest<span class="token punctuation">(</span></span>
<span class="line">            <span class="token builtin">type</span><span class="token operator">=</span>iam_pb2<span class="token punctuation">.</span>APPLICATION_TYPE_DESKTOP<span class="token punctuation">,</span></span>
<span class="line">            page<span class="token operator">=</span><span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">            page_size<span class="token operator">=</span><span class="token number">10</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        list_response <span class="token operator">=</span> client<span class="token punctuation">.</span>ListApplications<span class="token punctuation">(</span>list_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"找到 </span><span class="token interpolation"><span class="token punctuation">{</span><span class="token builtin">len</span><span class="token punctuation">(</span>list_response<span class="token punctuation">.</span>applications<span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string"> 个桌面应用:"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">for</span> i<span class="token punctuation">,</span> app <span class="token keyword">in</span> <span class="token builtin">enumerate</span><span class="token punctuation">(</span>list_response<span class="token punctuation">.</span>applications<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  </span><span class="token interpolation"><span class="token punctuation">{</span>i<span class="token punctuation">}</span></span><span class="token string">. </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span>name<span class="token punctuation">}</span></span><span class="token string"> - </span><span class="token interpolation"><span class="token punctuation">{</span>app<span class="token punctuation">.</span>status<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 5. 删除应用</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n5. 删除应用..."</span><span class="token punctuation">)</span></span>
<span class="line">        delete_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>DeleteApplicationRequest<span class="token punctuation">(</span><span class="token builtin">id</span><span class="token operator">=</span>app_id<span class="token punctuation">)</span></span>
<span class="line">        client<span class="token punctuation">.</span>DeleteApplication<span class="token punctuation">(</span>delete_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"应用删除成功"</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> __name__ <span class="token operator">==</span> <span class="token string">"__main__"</span><span class="token punctuation">:</span></span>
<span class="line">    main<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="批量应用管理脚本" tabindex="-1"><a class="header-anchor" href="#批量应用管理脚本">#</a> 批量应用管理脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量应用管理脚本</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"><span class="token assign-left variable">APPS_CONFIG</span><span class="token operator">=</span><span class="token string">"apps_config.json"</span></span>
<span class="line"><span class="token assign-left variable">OUTPUT_FILE</span><span class="token operator">=</span><span class="token string">"applications_report.csv"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建CSV头部</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"应用名称,应用ID,客户端ID,客户端密钥,类型,状态,创建时间"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 从配置文件读取应用配置并批量创建</span></span>
<span class="line">jq <span class="token parameter variable">-c</span> <span class="token string">'.applications[]'</span> <span class="token string">"<span class="token variable">$APPS_CONFIG</span>"</span> <span class="token operator">|</span> <span class="token keyword">while</span> <span class="token builtin class-name">read</span> app_config<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token assign-left variable">name</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_config</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.name'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">description</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_config</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.description'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">type</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_config</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.type'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">scopes</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_config</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.scopes | join(",")'</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"创建应用: <span class="token variable">$name</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 构造创建请求</span></span>
<span class="line">    <span class="token assign-left variable">create_request</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_config</span>"</span> <span class="token operator">|</span> jq <span class="token string">'{</span>
<span class="line">        name: .name,</span>
<span class="line">        description: .description,</span>
<span class="line">        homepage_url: .homepage_url,</span>
<span class="line">        callback_url: .callback_url,</span>
<span class="line">        type: .type,</span>
<span class="line">        scopes: .scopes</span>
<span class="line">    }'</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 创建应用</span></span>
<span class="line">    <span class="token assign-left variable">result</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"<span class="token variable">$create_request</span>"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/CreateApplication <span class="token operator"><span class="token file-descriptor important">2</span>></span>/dev/null<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token comment"># 解析结果</span></span>
<span class="line">        <span class="token assign-left variable">app_id</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.id'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">client_id</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.client_id'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">client_secret</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.client_secret'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">app_type</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.type'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">status</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.status'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">created_at</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$result</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.created_at'</span><span class="token variable">)</span></span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 写入CSV文件</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$name</span>,<span class="token variable">$app_id</span>,<span class="token variable">$client_id</span>,<span class="token variable">$client_secret</span>,<span class="token variable">$app_type</span>,<span class="token variable">$status</span>,<span class="token variable">$created_at</span>"</span> <span class="token operator">>></span> <span class="token string">"<span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line">        </span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  成功: <span class="token variable">$app_id</span>"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  失败: 无法创建应用 <span class="token variable">$name</span>"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token function">sleep</span> <span class="token number">0.1</span>  <span class="token comment"># 避免过快请求</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"批量创建完成，结果保存在 <span class="token variable">$OUTPUT_FILE</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>配置文件示例 (<code v-pre>apps_config.json</code>)：</p>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"applications"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"web-frontend"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"Web前端应用"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"homepage_url"</span><span class="token operator">:</span> <span class="token string">"https://web.example.com"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"callback_url"</span><span class="token operator">:</span> <span class="token string">"https://web.example.com/callback"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_WEB"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"mobile-app"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"移动应用"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_MOBILE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"offline_access"</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"api-service"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"API服务"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"APPLICATION_TYPE_SERVICE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"scopes"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔍-最佳实践">#</a> 🔍 最佳实践</h2>
<h3 id="_1-应用设计原则" tabindex="-1"><a class="header-anchor" href="#_1-应用设计原则">#</a> 1. 应用设计原则</h3>
<h4 id="单一职责" tabindex="-1"><a class="header-anchor" href="#单一职责">#</a> 单一职责</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 为不同用途创建不同的应用</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">createApplications</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Web前端应用</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"web-frontend"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"Web前端应用"</span><span class="token punctuation">,</span></span>
<span class="line">        Type<span class="token punctuation">:</span>        iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_WEB<span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 移动应用</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">CreateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"mobile-app"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"移动应用"</span><span class="token punctuation">,</span></span>
<span class="line">        Type<span class="token punctuation">:</span>        iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_MOBILE<span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"offline_access"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 后台服务</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">CreateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"backend-service"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> <span class="token string">"后台服务应用"</span><span class="token punctuation">,</span></span>
<span class="line">        Type<span class="token punctuation">:</span>        iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_SERVICE<span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="权限最小化" tabindex="-1"><a class="header-anchor" href="#权限最小化">#</a> 权限最小化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 根据应用类型设置合适的权限范围</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getScopesForApplicationType</span><span class="token punctuation">(</span>appType iamv1<span class="token punctuation">.</span>ApplicationType<span class="token punctuation">)</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">switch</span> appType <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">case</span> iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_WEB<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">case</span> iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_MOBILE<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"offline_access"</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">case</span> iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_SERVICE<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">,</span> <span class="token string">"write"</span><span class="token punctuation">,</span> <span class="token string">"admin"</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">case</span> iamv1<span class="token punctuation">.</span>ApplicationType_APPLICATION_TYPE_SPA<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">}</span> <span class="token comment">// 单页应用通常只需要读权限</span></span>
<span class="line">    <span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"read"</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-客户端密钥管理" tabindex="-1"><a class="header-anchor" href="#_2-客户端密钥管理">#</a> 2. 客户端密钥管理</h3>
<h4 id="安全存储" tabindex="-1"><a class="header-anchor" href="#安全存储">#</a> 安全存储</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 安全存储客户端密钥</span></span>
<span class="line"><span class="token keyword">type</span> ApplicationCredentials <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    ClientID     <span class="token builtin">string</span> <span class="token string">`json:"client_id"`</span></span>
<span class="line">    ClientSecret <span class="token builtin">string</span> <span class="token string">`json:"-"`</span> <span class="token comment">// 不序列化到JSON</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>ac <span class="token operator">*</span>ApplicationCredentials<span class="token punctuation">)</span> <span class="token function">StoreSecurely</span><span class="token punctuation">(</span>keyring <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 使用系统密钥环存储客户端密钥</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token function">storeInKeyring</span><span class="token punctuation">(</span>keyring<span class="token punctuation">,</span> ac<span class="token punctuation">.</span>ClientID<span class="token punctuation">,</span> ac<span class="token punctuation">.</span>ClientSecret<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>ac <span class="token operator">*</span>ApplicationCredentials<span class="token punctuation">)</span> <span class="token function">LoadSecurely</span><span class="token punctuation">(</span>keyring <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 从系统密钥环加载客户端密钥</span></span>
<span class="line">    secret<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">loadFromKeyring</span><span class="token punctuation">(</span>keyring<span class="token punctuation">,</span> ac<span class="token punctuation">.</span>ClientID<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    ac<span class="token punctuation">.</span>ClientSecret <span class="token operator">=</span> secret</span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="密钥轮换" tabindex="-1"><a class="header-anchor" href="#密钥轮换">#</a> 密钥轮换</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 客户端密钥轮换（需要重新创建应用）</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">rotateApplicationCredentials</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">,</span> appID <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>Application<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 1. 获取当前应用信息</span></span>
<span class="line">    getResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">GetApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>GetApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Id<span class="token punctuation">:</span> appID<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"获取应用信息失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    oldApp <span class="token operator">:=</span> getResp<span class="token punctuation">.</span>Application</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 创建新应用（相同配置）</span></span>
<span class="line">    newApp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        oldApp<span class="token punctuation">.</span>Name <span class="token operator">+</span> <span class="token string">"-new"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span> oldApp<span class="token punctuation">.</span>Description <span class="token operator">+</span> <span class="token string">" (轮换后)"</span><span class="token punctuation">,</span></span>
<span class="line">        HomepageUrl<span class="token punctuation">:</span> oldApp<span class="token punctuation">.</span>HomepageUrl<span class="token punctuation">,</span></span>
<span class="line">        CallbackUrl<span class="token punctuation">:</span> oldApp<span class="token punctuation">.</span>CallbackUrl<span class="token punctuation">,</span></span>
<span class="line">        Type<span class="token punctuation">:</span>        oldApp<span class="token punctuation">.</span>Type<span class="token punctuation">,</span></span>
<span class="line">        Scopes<span class="token punctuation">:</span>      oldApp<span class="token punctuation">.</span>Scopes<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"创建新应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 更新应用配置（这里需要根据实际情况实现）</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> <span class="token function">updateApplicationConfig</span><span class="token punctuation">(</span>newApp<span class="token punctuation">.</span>Application<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"更新应用配置失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 等待配置生效</span></span>
<span class="line">    time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span><span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 5. 删除旧应用</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DeleteApplication</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteApplicationRequest<span class="token punctuation">{</span></span>
<span class="line">        Id<span class="token punctuation">:</span>    appID<span class="token punctuation">,</span></span>
<span class="line">        Force<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"删除旧应用失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> newApp<span class="token punctuation">.</span>Application<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-应用监控和审计" tabindex="-1"><a class="header-anchor" href="#_3-应用监控和审计">#</a> 3. 应用监控和审计</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 应用使用情况监控</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">monitorApplicationUsage</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    apps<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListApplications</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListApplicationsRequest<span class="token punctuation">{</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">100</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"获取应用列表失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> app <span class="token operator">:=</span> <span class="token keyword">range</span> apps<span class="token punctuation">.</span>Applications <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 检查最后使用时间</span></span>
<span class="line">        <span class="token keyword">if</span> app<span class="token punctuation">.</span>LastUsedAt <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            lastUsed <span class="token operator">:=</span> app<span class="token punctuation">.</span>LastUsedAt<span class="token punctuation">.</span><span class="token function">AsTime</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>lastUsed<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">30</span><span class="token operator">*</span><span class="token number">24</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Hour <span class="token punctuation">{</span> <span class="token comment">// 30天未使用</span></span>
<span class="line">                log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"警告: 应用 %s 已超过30天未使用"</span><span class="token punctuation">,</span> app<span class="token punctuation">.</span>Name<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 检查用户数量</span></span>
<span class="line">        <span class="token keyword">if</span> app<span class="token punctuation">.</span>UserCount <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">            log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"警告: 应用 %s 没有关联用户"</span><span class="token punctuation">,</span> app<span class="token punctuation">.</span>Name<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 检查访问密钥数量</span></span>
<span class="line">        <span class="token keyword">if</span> app<span class="token punctuation">.</span>AccessKeyCount <span class="token operator">></span> <span class="token number">10</span> <span class="token punctuation">{</span></span>
<span class="line">            log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"警告: 应用 %s 的访问密钥数量过多 (%d)"</span><span class="token punctuation">,</span> app<span class="token punctuation">.</span>Name<span class="token punctuation">,</span> app<span class="token punctuation">.</span>AccessKeyCount<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-应用生命周期管理" tabindex="-1"><a class="header-anchor" href="#_4-应用生命周期管理">#</a> 4. 应用生命周期管理</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 应用生命周期管理脚本</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 应用健康检查</span></span>
<span class="line"><span class="token function-name function">check_application_health</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin class-name">local</span> <span class="token assign-left variable">app_id</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$1</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"检查应用健康状态: <span class="token variable">$app_id</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 获取应用详情</span></span>
<span class="line">    <span class="token assign-left variable">app_info</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>id<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$app_id</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/GetApplication<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-ne</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"错误: 无法获取应用信息"</span></span>
<span class="line">        <span class="token builtin class-name">return</span> <span class="token number">1</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 检查应用状态</span></span>
<span class="line">    <span class="token assign-left variable">status</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_info</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.status'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$status</span>"</span> <span class="token operator">!=</span> <span class="token string">"APPLICATION_STATUS_ACTIVE"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"警告: 应用状态异常 - <span class="token variable">$status</span>"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 检查最后使用时间</span></span>
<span class="line">    <span class="token assign-left variable">last_used</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_info</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.last_used_at'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$last_used</span>"</span> <span class="token operator">!=</span> <span class="token string">"null"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token comment"># 计算天数差异（简化计算）</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"最后使用时间: <span class="token variable">$last_used</span>"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"警告: 应用从未被使用"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 检查关联资源</span></span>
<span class="line">    <span class="token assign-left variable">user_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_info</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.user_count'</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">access_key_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app_info</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.application.access_key_count'</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"关联用户数: <span class="token variable">$user_count</span>"</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"访问密钥数: <span class="token variable">$access_key_count</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$user_count</span>"</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span> <span class="token operator">&amp;&amp;</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$access_key_count</span>"</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"警告: 应用没有关联任何资源，可能需要清理"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清理未使用的应用</span></span>
<span class="line"><span class="token function-name function">cleanup_unused_applications</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"开始清理未使用的应用..."</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 获取所有应用</span></span>
<span class="line">    <span class="token assign-left variable">apps</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">        "page": 1,</span>
<span class="line">        "page_size": 1000</span>
<span class="line">    }'</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListApplications<span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 检查每个应用</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$apps</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-c</span> <span class="token string">'.applications[]'</span> <span class="token operator">|</span> <span class="token keyword">while</span> <span class="token builtin class-name">read</span> app<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">        <span class="token assign-left variable">app_id</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.id'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">app_name</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.name'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">user_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.user_count'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">access_key_count</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.access_key_count'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">last_used</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$app</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-r</span> <span class="token string">'.last_used_at'</span><span class="token variable">)</span></span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 如果应用没有关联资源且从未使用，标记为可删除</span></span>
<span class="line">        <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$user_count</span>"</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span> <span class="token operator">&amp;&amp;</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$access_key_count</span>"</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span> <span class="token operator">&amp;&amp;</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$last_used</span>"</span> <span class="token operator">=</span> <span class="token string">"null"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">            <span class="token builtin class-name">echo</span> <span class="token string">"发现未使用的应用: <span class="token variable">$app_name</span> (<span class="token variable">$app_id</span>)"</span></span>
<span class="line">            <span class="token builtin class-name">echo</span> <span class="token string">"是否删除此应用? (y/N)"</span></span>
<span class="line">            <span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span> confirm</span>
<span class="line">            <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$confirm</span>"</span> <span class="token operator">=</span> <span class="token string">"y"</span> <span class="token punctuation">]</span> <span class="token operator">||</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$confirm</span>"</span> <span class="token operator">=</span> <span class="token string">"Y"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">                grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">                    <span class="token entity" title="\&quot;">\"</span>id<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$app_id</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">                }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/DeleteApplication</span>
<span class="line">                <span class="token builtin class-name">echo</span> <span class="token string">"应用 <span class="token variable">$app_name</span> 已删除"</span></span>
<span class="line">            <span class="token keyword">fi</span></span>
<span class="line">        <span class="token keyword">fi</span></span>
<span class="line">    <span class="token keyword">done</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 应用备份</span></span>
<span class="line"><span class="token function-name function">backup_applications</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin class-name">local</span> <span class="token assign-left variable">backup_file</span><span class="token operator">=</span><span class="token string">"applications_backup_<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span>.json"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"备份应用配置到: <span class="token variable">$backup_file</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 获取所有应用</span></span>
<span class="line">    grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">        "page": 1,</span>
<span class="line">        "page_size": 1000</span>
<span class="line">    }'</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/ListApplications <span class="token operator">></span> <span class="token string">"<span class="token variable">$backup_file</span>"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"备份完成"</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 主函数</span></span>
<span class="line"><span class="token keyword">case</span> <span class="token string">"<span class="token variable">$1</span>"</span> <span class="token keyword">in</span></span>
<span class="line">    <span class="token string">"health"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-z</span> <span class="token string">"<span class="token variable">$2</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">            <span class="token builtin class-name">echo</span> <span class="token string">"用法: <span class="token variable">$0</span> health &lt;应用ID>"</span></span>
<span class="line">            <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line">        <span class="token keyword">fi</span></span>
<span class="line">        check_application_health <span class="token string">"<span class="token variable">$2</span>"</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token string">"cleanup"</span><span class="token punctuation">)</span></span>
<span class="line">        cleanup_unused_applications</span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token string">"backup"</span><span class="token punctuation">)</span></span>
<span class="line">        backup_applications</span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    *<span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"用法: <span class="token variable">$0</span> {health|cleanup|backup} [应用ID]"</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  health &lt;应用ID>  - 检查应用健康状态"</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  cleanup          - 清理未使用的应用"</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"  backup           - 备份应用配置"</span></span>
<span class="line">        <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">esac</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-注意事项" tabindex="-1"><a class="header-anchor" href="#🚨-注意事项">#</a> 🚨 注意事项</h2>
<h3 id="安全考虑" tabindex="-1"><a class="header-anchor" href="#安全考虑">#</a> 安全考虑</h3>
<ol>
<li>
<p><strong>客户端密钥保护</strong>：</p>
<ul>
<li>永远不要在代码中硬编码客户端密钥</li>
<li>使用环境变量或安全的配置管理系统</li>
<li>定期轮换客户端密钥</li>
</ul>
</li>
<li>
<p><strong>权限控制</strong>：</p>
<ul>
<li>遵循最小权限原则</li>
<li>为不同用途创建不同的应用</li>
<li>定期审查应用权限</li>
</ul>
</li>
<li>
<p><strong>访问控制</strong>：</p>
<ul>
<li>限制应用创建权限</li>
<li>监控应用使用情况</li>
<li>及时删除不使用的应用</li>
</ul>
</li>
</ol>
<h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<ol>
<li>
<p><strong>批量操作</strong>：</p>
<ul>
<li>避免循环调用API</li>
<li>使用分页查询大量数据</li>
<li>合理控制并发数</li>
</ul>
</li>
<li>
<p><strong>缓存策略</strong>：</p>
<ul>
<li>缓存应用基本信息</li>
<li>设置合适的缓存过期时间</li>
<li>监控缓存命中率</li>
</ul>
</li>
</ol>
<h3 id="运维管理" tabindex="-1"><a class="header-anchor" href="#运维管理">#</a> 运维管理</h3>
<ol>
<li>
<p><strong>监控告警</strong>：</p>
<ul>
<li>监控应用创建和删除操作</li>
<li>设置应用数量告警</li>
<li>监控异常使用模式</li>
</ul>
</li>
<li>
<p><strong>备份恢复</strong>：</p>
<ul>
<li>定期备份应用配置</li>
<li>测试恢复流程</li>
<li>保留历史备份</li>
</ul>
</li>
</ol>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议为每个环境（开发、测试、生产）创建独立的应用，便于管理和隔离。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>应用的客户端密钥只在创建时返回一次，请务必妥善保存。如果丢失，需要重新创建应用。</p>
</div>
</div></template>


