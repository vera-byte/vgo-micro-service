<template><div><h1 id="用户管理-api" tabindex="-1"><a class="header-anchor" href="#用户管理-api">#</a> 用户管理 API</h1>
<p>用户管理API提供了完整的用户生命周期管理功能，包括用户的创建、查询、更新、删除和列表操作。</p>
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
<td><code v-pre>CreateUser</code></td>
<td>创建新用户</td>
<td><code v-pre>iam:CreateUser</code></td>
</tr>
<tr>
<td><code v-pre>GetUser</code></td>
<td>获取用户信息</td>
<td><code v-pre>iam:GetUser</code></td>
</tr>
<tr>
<td><code v-pre>UpdateUser</code></td>
<td>更新用户信息</td>
<td><code v-pre>iam:UpdateUser</code></td>
</tr>
<tr>
<td><code v-pre>DeleteUser</code></td>
<td>删除用户</td>
<td><code v-pre>iam:DeleteUser</code></td>
</tr>
<tr>
<td><code v-pre>ListUsers</code></td>
<td>获取用户列表</td>
<td><code v-pre>iam:ListUsers</code></td>
</tr>
</tbody>
</table>
<h2 id="🔧-api-详情" tabindex="-1"><a class="header-anchor" href="#🔧-api-详情">#</a> 🔧 API 详情</h2>
<h3 id="createuser-创建用户" tabindex="-1"><a class="header-anchor" href="#createuser-创建用户">#</a> CreateUser - 创建用户</h3>
<p>创建一个新的用户账户。</p>
<h4 id="请求" tabindex="-1"><a class="header-anchor" href="#请求">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateUserRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>          <span class="token comment">// 用户名（必需，唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> display_name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>  <span class="token comment">// 显示名称（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> email <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>         <span class="token comment">// 邮箱地址（必需，唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> password <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>      <span class="token comment">// 密码（可选，如果不提供将生成随机密码）</span></span>
<span class="line">  <span class="token positional-class-name class-name">UserStatus</span> status <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>    <span class="token comment">// 用户状态（可选，默认为ACTIVE）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应" tabindex="-1"><a class="header-anchor" href="#响应">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreateUserResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">User</span> user <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>           <span class="token comment">// 创建的用户信息</span></span>
<span class="line">  <span class="token builtin">string</span> password <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>     <span class="token comment">// 生成的密码（如果未提供密码）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例" tabindex="-1"><a class="header-anchor" href="#示例">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建用户（提供密码）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe",</span>
<span class="line">  "display_name": "John Doe",</span>
<span class="line">  "email": "john@example.com",</span>
<span class="line">  "password": "SecurePassword123!"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建用户（自动生成密码）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "jane_smith",</span>
<span class="line">  "display_name": "Jane Smith",</span>
<span class="line">  "email": "jane@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例" tabindex="-1"><a class="header-anchor" href="#响应示例">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"user"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"USER_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况" tabindex="-1"><a class="header-anchor" href="#错误情况">#</a> 错误情况</h4>
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
<td>用户名或邮箱为空</td>
<td>提供有效的用户名和邮箱</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>用户名或邮箱已存在</td>
<td>使用不同的用户名或邮箱</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无创建用户权限</td>
<td>确保有<code v-pre>iam:CreateUser</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="getuser-获取用户信息" tabindex="-1"><a class="header-anchor" href="#getuser-获取用户信息">#</a> GetUser - 获取用户信息</h3>
<p>根据用户名或用户ID获取用户详细信息。</p>
<h4 id="请求-1" tabindex="-1"><a class="header-anchor" href="#请求-1">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetUserRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>    <span class="token comment">// 用户名</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 用户ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-1" tabindex="-1"><a class="header-anchor" href="#响应-1">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetUserResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">User</span> user <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>        <span class="token comment">// 用户信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-1" tabindex="-1"><a class="header-anchor" href="#示例-1">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过用户名获取</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过用户ID获取</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "123"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-1" tabindex="-1"><a class="header-anchor" href="#响应示例-1">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"user"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"USER_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"last_login_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-1" tabindex="-1"><a class="header-anchor" href="#错误情况-1">#</a> 错误情况</h4>
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
<td>未提供用户名或ID</td>
<td>提供有效的标识符</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>用户不存在</td>
<td>确认用户名或ID正确</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无查看用户权限</td>
<td>确保有<code v-pre>iam:GetUser</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="updateuser-更新用户信息" tabindex="-1"><a class="header-anchor" href="#updateuser-更新用户信息">#</a> UpdateUser - 更新用户信息</h3>
<p>更新现有用户的信息。</p>
<h4 id="请求-2" tabindex="-1"><a class="header-anchor" href="#请求-2">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateUserRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>          <span class="token comment">// 用户名</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>            <span class="token comment">// 用户ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line">  <span class="token builtin">string</span> display_name <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>    <span class="token comment">// 新的显示名称（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> email <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>           <span class="token comment">// 新的邮箱地址（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> password <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>        <span class="token comment">// 新密码（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">UserStatus</span> status <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>      <span class="token comment">// 新状态（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>FieldMask</span> update_mask <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>  <span class="token comment">// 更新字段掩码</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-2" tabindex="-1"><a class="header-anchor" href="#响应-2">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdateUserResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">User</span> user <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 更新后的用户信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-2" tabindex="-1"><a class="header-anchor" href="#示例-2">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新显示名称和邮箱</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe",</span>
<span class="line">  "display_name": "John Smith",</span>
<span class="line">  "email": "john.smith@example.com",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["display_name", "email"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新用户状态</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "123",</span>
<span class="line">  "status": "USER_STATUS_SUSPENDED",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["status"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 重置密码</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe",</span>
<span class="line">  "password": "NewSecurePassword456!",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["password"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-2" tabindex="-1"><a class="header-anchor" href="#响应示例-2">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"user"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"John Smith"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john.smith@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"USER_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T14:30:00Z"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-2" tabindex="-1"><a class="header-anchor" href="#错误情况-2">#</a> 错误情况</h4>
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
<td>无效的更新字段</td>
<td>检查update_mask和字段值</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>用户不存在</td>
<td>确认用户标识符正确</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>邮箱已被其他用户使用</td>
<td>使用不同的邮箱地址</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无更新用户权限</td>
<td>确保有<code v-pre>iam:UpdateUser</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="deleteuser-删除用户" tabindex="-1"><a class="header-anchor" href="#deleteuser-删除用户">#</a> DeleteUser - 删除用户</h3>
<p>删除指定的用户账户。</p>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>删除用户是不可逆操作，会同时删除用户的所有关联数据（访问密钥、策略绑定等）。</p>
</div>
<h4 id="请求-3" tabindex="-1"><a class="header-anchor" href="#请求-3">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteUserRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>    <span class="token comment">// 用户名</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 用户ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line">  <span class="token builtin">bool</span> force <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>       <span class="token comment">// 强制删除（即使有关联资源）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-3" tabindex="-1"><a class="header-anchor" href="#响应-3">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeleteUserResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-3" tabindex="-1"><a class="header-anchor" href="#示例-3">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 删除用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "john_doe"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 强制删除用户（包括关联资源）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "123",</span>
<span class="line">  "force": true</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteUser</span>
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
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>未提供用户标识符</td>
<td>提供用户名或ID</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>用户不存在</td>
<td>确认用户标识符正确</td>
</tr>
<tr>
<td><code v-pre>FAILED_PRECONDITION</code></td>
<td>用户有关联资源且未设置force</td>
<td>设置force=true或先删除关联资源</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无删除用户权限</td>
<td>确保有<code v-pre>iam:DeleteUser</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="listusers-获取用户列表" tabindex="-1"><a class="header-anchor" href="#listusers-获取用户列表">#</a> ListUsers - 获取用户列表</h3>
<p>获取系统中的用户列表，支持分页和过滤。</p>
<h4 id="请求-4" tabindex="-1"><a class="header-anchor" href="#请求-4">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListUsersRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">int32</span> page <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>           <span class="token comment">// 页码（从1开始）</span></span>
<span class="line">  <span class="token builtin">int32</span> page_size <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 每页大小（最大100）</span></span>
<span class="line">  <span class="token builtin">string</span> filter <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>        <span class="token comment">// 过滤条件</span></span>
<span class="line">  <span class="token builtin">string</span> order_by <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>      <span class="token comment">// 排序字段</span></span>
<span class="line">  <span class="token builtin">bool</span> desc <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>            <span class="token comment">// 是否降序</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="过滤条件" tabindex="-1"><a class="header-anchor" href="#过滤条件">#</a> 过滤条件</h4>
<p>支持的过滤字段：</p>
<ul>
<li><code v-pre>status</code>: 用户状态（active, inactive, suspended）</li>
<li><code v-pre>email</code>: 邮箱地址（支持模糊匹配）</li>
<li><code v-pre>name</code>: 用户名（支持模糊匹配）</li>
<li><code v-pre>created_after</code>: 创建时间之后</li>
<li><code v-pre>created_before</code>: 创建时间之前</li>
</ul>
<h4 id="排序字段" tabindex="-1"><a class="header-anchor" href="#排序字段">#</a> 排序字段</h4>
<p>支持的排序字段：</p>
<ul>
<li><code v-pre>name</code>: 用户名</li>
<li><code v-pre>email</code>: 邮箱</li>
<li><code v-pre>created_at</code>: 创建时间</li>
<li><code v-pre>updated_at</code>: 更新时间</li>
<li><code v-pre>last_login_at</code>: 最后登录时间</li>
</ul>
<h4 id="响应-4" tabindex="-1"><a class="header-anchor" href="#响应-4">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListUsersResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">User</span> users <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>      <span class="token comment">// 用户列表</span></span>
<span class="line">  <span class="token positional-class-name class-name">Pagination</span> pagination <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>    <span class="token comment">// 分页信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">Pagination</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">int32</span> page <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 当前页码</span></span>
<span class="line">  <span class="token builtin">int32</span> page_size <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>         <span class="token comment">// 每页大小</span></span>
<span class="line">  <span class="token builtin">int32</span> total_count <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>       <span class="token comment">// 总记录数</span></span>
<span class="line">  <span class="token builtin">int32</span> total_pages <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>       <span class="token comment">// 总页数</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-4" tabindex="-1"><a class="header-anchor" href="#示例-4">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取第一页用户（默认20条）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 20</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取活跃用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10,</span>
<span class="line">  "filter": "status=active"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 按创建时间降序排列</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10,</span>
<span class="line">  "order_by": "created_at",</span>
<span class="line">  "desc": true</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 复合过滤条件</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10,</span>
<span class="line">  "filter": "status=active AND email LIKE %@example.com AND created_after=2024-01-01T00:00:00Z"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListUsers</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-4" tabindex="-1"><a class="header-anchor" href="#响应示例-4">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"users"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"123"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"john@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"USER_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"last_login_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"124"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"jane_smith"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"display_name"</span><span class="token operator">:</span> <span class="token string">"Jane Smith"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"email"</span><span class="token operator">:</span> <span class="token string">"jane@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"status"</span><span class="token operator">:</span> <span class="token string">"USER_STATUS_ACTIVE"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-02T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-02T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"last_login_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-14T15:45:00Z"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"pagination"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"page"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"page_size"</span><span class="token operator">:</span> <span class="token number">20</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_count"</span><span class="token operator">:</span> <span class="token number">150</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_pages"</span><span class="token operator">:</span> <span class="token number">8</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-4" tabindex="-1"><a class="header-anchor" href="#错误情况-4">#</a> 错误情况</h4>
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
<td>无效的过滤条件</td>
<td>检查filter语法</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无列表用户权限</td>
<td>确保有<code v-pre>iam:ListUsers</code>权限</td>
</tr>
</tbody>
</table>
<h2 id="📊-数据模型" tabindex="-1"><a class="header-anchor" href="#📊-数据模型">#</a> 📊 数据模型</h2>
<h3 id="user-对象" tabindex="-1"><a class="header-anchor" href="#user-对象">#</a> User 对象</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">User</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                    <span class="token comment">// 用户ID（系统生成）</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                  <span class="token comment">// 用户名（唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> display_name <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>          <span class="token comment">// 显示名称</span></span>
<span class="line">  <span class="token builtin">string</span> email <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>                 <span class="token comment">// 邮箱地址（唯一）</span></span>
<span class="line">  <span class="token positional-class-name class-name">UserStatus</span> status <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>            <span class="token comment">// 用户状态</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> created_at <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>     <span class="token comment">// 创建时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> updated_at <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>     <span class="token comment">// 更新时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> last_login_at <span class="token operator">=</span> <span class="token number">8</span><span class="token punctuation">;</span>  <span class="token comment">// 最后登录时间</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> metadata <span class="token operator">=</span> <span class="token number">9</span><span class="token punctuation">;</span> <span class="token comment">// 用户元数据</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="userstatus-枚举" tabindex="-1"><a class="header-anchor" href="#userstatus-枚举">#</a> UserStatus 枚举</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">enum</span> <span class="token class-name">UserStatus</span> <span class="token punctuation">{</span></span>
<span class="line">  USER_STATUS_UNSPECIFIED <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span>  <span class="token comment">// 未指定</span></span>
<span class="line">  USER_STATUS_ACTIVE <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>       <span class="token comment">// 活跃</span></span>
<span class="line">  USER_STATUS_INACTIVE <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>     <span class="token comment">// 非活跃</span></span>
<span class="line">  USER_STATUS_SUSPENDED <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>    <span class="token comment">// 已暂停</span></span>
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
<td>创建用户</td>
<td><code v-pre>iam:CreateUser</code></td>
<td><code v-pre>*</code></td>
</tr>
<tr>
<td>获取用户</td>
<td><code v-pre>iam:GetUser</code></td>
<td><code v-pre>arn:iam::user/*</code> 或 <code v-pre>arn:iam::user/${aws:username}</code></td>
</tr>
<tr>
<td>更新用户</td>
<td><code v-pre>iam:UpdateUser</code></td>
<td><code v-pre>arn:iam::user/*</code> 或 <code v-pre>arn:iam::user/${aws:username}</code></td>
</tr>
<tr>
<td>删除用户</td>
<td><code v-pre>iam:DeleteUser</code></td>
<td><code v-pre>arn:iam::user/*</code></td>
</tr>
<tr>
<td>列表用户</td>
<td><code v-pre>iam:ListUsers</code></td>
<td><code v-pre>*</code></td>
</tr>
</tbody>
</table>
<h3 id="策略示例" tabindex="-1"><a class="header-anchor" href="#策略示例">#</a> 策略示例</h3>
<h4 id="管理员策略" tabindex="-1"><a class="header-anchor" href="#管理员策略">#</a> 管理员策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CreateUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:DeleteUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListUsers"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="用户自管理策略" tabindex="-1"><a class="header-anchor" href="#用户自管理策略">#</a> 用户自管理策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:UpdateUser"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"arn:iam::user/${aws:username}"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="只读策略" tabindex="-1"><a class="header-anchor" href="#只读策略">#</a> 只读策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListUsers"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
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
<span class="line">    <span class="token comment">// 创建用户</span></span>
<span class="line">    createResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>        <span class="token string">"test_user"</span><span class="token punctuation">,</span></span>
<span class="line">        DisplayName<span class="token punctuation">:</span> <span class="token string">"Test User"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>       <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">        Password<span class="token punctuation">:</span>    <span class="token string">"SecurePassword123!"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"创建用户失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"用户创建成功: %v\n"</span><span class="token punctuation">,</span> createResp<span class="token punctuation">.</span>User<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 获取用户</span></span>
<span class="line">    getResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>GetUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Identifier<span class="token punctuation">:</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>GetUserRequest_Name<span class="token punctuation">{</span>Name<span class="token punctuation">:</span> <span class="token string">"test_user"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"获取用户失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"用户信息: %v\n"</span><span class="token punctuation">,</span> getResp<span class="token punctuation">.</span>User<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 更新用户</span></span>
<span class="line">    updateResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">UpdateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>UpdateUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Identifier<span class="token punctuation">:</span>  <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>UpdateUserRequest_Name<span class="token punctuation">{</span>Name<span class="token punctuation">:</span> <span class="token string">"test_user"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        DisplayName<span class="token punctuation">:</span> <span class="token string">"Updated Test User"</span><span class="token punctuation">,</span></span>
<span class="line">        UpdateMask<span class="token punctuation">:</span> <span class="token operator">&amp;</span>fieldmaskpb<span class="token punctuation">.</span>FieldMask<span class="token punctuation">{</span></span>
<span class="line">            Paths<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"display_name"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"更新用户失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"用户更新成功: %v\n"</span><span class="token punctuation">,</span> updateResp<span class="token punctuation">.</span>User<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 获取用户列表</span></span>
<span class="line">    listResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListUsers</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListUsersRequest<span class="token punctuation">{</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">        Filter<span class="token punctuation">:</span>   <span class="token string">"status=active"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"获取用户列表失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"用户列表: %v\n"</span><span class="token punctuation">,</span> listResp<span class="token punctuation">.</span>Users<span class="token punctuation">)</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"分页信息: %v\n"</span><span class="token punctuation">,</span> listResp<span class="token punctuation">.</span>Pagination<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 删除用户</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DeleteUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Identifier<span class="token punctuation">:</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeleteUserRequest_Name<span class="token punctuation">{</span>Name<span class="token punctuation">:</span> <span class="token string">"test_user"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"删除用户失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"用户删除成功"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="python-客户端示例" tabindex="-1"><a class="header-anchor" href="#python-客户端示例">#</a> Python 客户端示例</h3>
<div class="language-python line-numbers-mode" data-highlighter="prismjs" data-ext="py"><pre v-pre><code class="language-python"><span class="line"><span class="token keyword">import</span> grpc</span>
<span class="line"><span class="token keyword">from</span> google<span class="token punctuation">.</span>protobuf <span class="token keyword">import</span> field_mask_pb2</span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2</span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2_grpc</span>
<span class="line"></span>
<span class="line"><span class="token keyword">def</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 连接到服务</span></span>
<span class="line">    <span class="token keyword">with</span> grpc<span class="token punctuation">.</span>insecure_channel<span class="token punctuation">(</span><span class="token string">'localhost:50051'</span><span class="token punctuation">)</span> <span class="token keyword">as</span> channel<span class="token punctuation">:</span></span>
<span class="line">        client <span class="token operator">=</span> iam_pb2_grpc<span class="token punctuation">.</span>IAMStub<span class="token punctuation">(</span>channel<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 创建用户</span></span>
<span class="line">        create_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">(</span></span>
<span class="line">            name<span class="token operator">=</span><span class="token string">'test_user'</span><span class="token punctuation">,</span></span>
<span class="line">            display_name<span class="token operator">=</span><span class="token string">'Test User'</span><span class="token punctuation">,</span></span>
<span class="line">            email<span class="token operator">=</span><span class="token string">'test@example.com'</span><span class="token punctuation">,</span></span>
<span class="line">            password<span class="token operator">=</span><span class="token string">'SecurePassword123!'</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        create_response <span class="token operator">=</span> client<span class="token punctuation">.</span>CreateUser<span class="token punctuation">(</span>create_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'用户创建成功: </span><span class="token interpolation"><span class="token punctuation">{</span>create_response<span class="token punctuation">.</span>user<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 获取用户</span></span>
<span class="line">        get_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>GetUserRequest<span class="token punctuation">(</span>name<span class="token operator">=</span><span class="token string">'test_user'</span><span class="token punctuation">)</span></span>
<span class="line">        get_response <span class="token operator">=</span> client<span class="token punctuation">.</span>GetUser<span class="token punctuation">(</span>get_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'用户信息: </span><span class="token interpolation"><span class="token punctuation">{</span>get_response<span class="token punctuation">.</span>user<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 更新用户</span></span>
<span class="line">        update_mask <span class="token operator">=</span> field_mask_pb2<span class="token punctuation">.</span>FieldMask<span class="token punctuation">(</span>paths<span class="token operator">=</span><span class="token punctuation">[</span><span class="token string">'display_name'</span><span class="token punctuation">]</span><span class="token punctuation">)</span></span>
<span class="line">        update_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>UpdateUserRequest<span class="token punctuation">(</span></span>
<span class="line">            name<span class="token operator">=</span><span class="token string">'test_user'</span><span class="token punctuation">,</span></span>
<span class="line">            display_name<span class="token operator">=</span><span class="token string">'Updated Test User'</span><span class="token punctuation">,</span></span>
<span class="line">            update_mask<span class="token operator">=</span>update_mask</span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        update_response <span class="token operator">=</span> client<span class="token punctuation">.</span>UpdateUser<span class="token punctuation">(</span>update_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'用户更新成功: </span><span class="token interpolation"><span class="token punctuation">{</span>update_response<span class="token punctuation">.</span>user<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 获取用户列表</span></span>
<span class="line">        list_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>ListUsersRequest<span class="token punctuation">(</span></span>
<span class="line">            page<span class="token operator">=</span><span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">            page_size<span class="token operator">=</span><span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token builtin">filter</span><span class="token operator">=</span><span class="token string">'status=active'</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        list_response <span class="token operator">=</span> client<span class="token punctuation">.</span>ListUsers<span class="token punctuation">(</span>list_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'用户列表: </span><span class="token interpolation"><span class="token punctuation">{</span>list_response<span class="token punctuation">.</span>users<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f'分页信息: </span><span class="token interpolation"><span class="token punctuation">{</span>list_response<span class="token punctuation">.</span>pagination<span class="token punctuation">}</span></span><span class="token string">'</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 删除用户</span></span>
<span class="line">        delete_request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>DeleteUserRequest<span class="token punctuation">(</span>name<span class="token operator">=</span><span class="token string">'test_user'</span><span class="token punctuation">)</span></span>
<span class="line">        client<span class="token punctuation">.</span>DeleteUser<span class="token punctuation">(</span>delete_request<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">'用户删除成功'</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> __name__ <span class="token operator">==</span> <span class="token string">'__main__'</span><span class="token punctuation">:</span></span>
<span class="line">    main<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔍-最佳实践">#</a> 🔍 最佳实践</h2>
<h3 id="_1-用户名规范" tabindex="-1"><a class="header-anchor" href="#_1-用户名规范">#</a> 1. 用户名规范</h3>
<ul>
<li>使用小写字母、数字和下划线</li>
<li>长度在3-32个字符之间</li>
<li>避免使用保留词（admin、root、system等）</li>
</ul>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 好的用户名示例</span></span>
<span class="line"><span class="token string">"john_doe"</span></span>
<span class="line"><span class="token string">"user_123"</span></span>
<span class="line"><span class="token string">"service_account"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 避免的用户名</span></span>
<span class="line"><span class="token string">"Admin"</span></span>
<span class="line"><span class="token string">"root"</span></span>
<span class="line"><span class="token string">"123"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-密码策略" tabindex="-1"><a class="header-anchor" href="#_2-密码策略">#</a> 2. 密码策略</h3>
<ul>
<li>最少8个字符</li>
<li>包含大小写字母、数字和特殊字符</li>
<li>定期更换密码</li>
</ul>
<h3 id="_3-邮箱验证" tabindex="-1"><a class="header-anchor" href="#_3-邮箱验证">#</a> 3. 邮箱验证</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建用户后发送验证邮件</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "new_user",</span>
<span class="line">  "display_name": "New User",</span>
<span class="line">  "email": "new@example.com",</span>
<span class="line">  "status": "USER_STATUS_INACTIVE"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-批量操作" tabindex="-1"><a class="header-anchor" href="#_4-批量操作">#</a> 4. 批量操作</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量创建用户脚本</span></span>
<span class="line"><span class="token assign-left variable">users_file</span><span class="token operator">=</span><span class="token string">"users.txt"</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">while</span> <span class="token assign-left variable"><span class="token environment constant">IFS</span></span><span class="token operator">=</span><span class="token string">','</span> <span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span> name display_name email<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$name</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>display_name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$display_name</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>email<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">$email</span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"Created user: <span class="token variable">$name</span>"</span></span>
<span class="line">    <span class="token function">sleep</span> <span class="token number">0.1</span>  <span class="token comment"># 避免过快请求</span></span>
<span class="line"><span class="token keyword">done</span> <span class="token operator">&lt;</span> <span class="token string">"<span class="token variable">$users_file</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_5-错误处理" tabindex="-1"><a class="header-anchor" href="#_5-错误处理">#</a> 5. 错误处理</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 带重试的用户创建</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">createUserWithRetry</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">,</span> req <span class="token operator">*</span>iamv1<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">,</span> maxRetries <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>CreateUserResponse<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> maxRetries<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> resp<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 检查是否为可重试错误</span></span>
<span class="line">        <span class="token keyword">if</span> status<span class="token punctuation">.</span><span class="token function">Code</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span> <span class="token operator">==</span> codes<span class="token punctuation">.</span>AlreadyExists <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err <span class="token comment">// 不重试</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span>i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"达到最大重试次数"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-注意事项" tabindex="-1"><a class="header-anchor" href="#🚨-注意事项">#</a> 🚨 注意事项</h2>
<h3 id="安全考虑" tabindex="-1"><a class="header-anchor" href="#安全考虑">#</a> 安全考虑</h3>
<ol>
<li>
<p><strong>密码安全</strong>：</p>
<ul>
<li>不要在日志中记录密码</li>
<li>使用强密码策略</li>
<li>定期轮换密码</li>
</ul>
</li>
<li>
<p><strong>权限控制</strong>：</p>
<ul>
<li>遵循最小权限原则</li>
<li>定期审查用户权限</li>
<li>使用资源级权限控制</li>
</ul>
</li>
<li>
<p><strong>数据保护</strong>：</p>
<ul>
<li>敏感信息加密存储</li>
<li>审计用户操作</li>
<li>定期备份用户数据</li>
</ul>
</li>
</ol>
<h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<ol>
<li>
<p><strong>分页查询</strong>：</p>
<ul>
<li>使用合适的页面大小</li>
<li>避免查询过大的数据集</li>
<li>使用索引优化查询</li>
</ul>
</li>
<li>
<p><strong>缓存策略</strong>：</p>
<ul>
<li>缓存频繁访问的用户信息</li>
<li>设置合适的缓存过期时间</li>
<li>及时更新缓存</li>
</ul>
</li>
<li>
<p><strong>连接管理</strong>：</p>
<ul>
<li>使用连接池</li>
<li>设置合适的超时时间</li>
<li>处理连接异常</li>
</ul>
</li>
</ol>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议在生产环境中启用用户操作审计，记录所有用户管理操作的详细日志。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>删除用户操作不可逆，请谨慎操作。建议先将用户状态设置为SUSPENDED，确认无影响后再删除。</p>
</div>
</div></template>


