<template><div><h1 id="权限验证-api" tabindex="-1"><a class="header-anchor" href="#权限验证-api">#</a> 权限验证 API</h1>
<p>权限验证API是VGO微服务的核心功能，提供了灵活强大的权限验证机制。支持基于策略的访问控制（PBAC），可以验证用户对特定资源的操作权限。</p>
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
<td><code v-pre>CheckPermission</code></td>
<td>检查单个权限</td>
<td><code v-pre>iam:CheckPermission</code></td>
</tr>
<tr>
<td><code v-pre>CheckPermissions</code></td>
<td>批量检查权限</td>
<td><code v-pre>iam:CheckPermissions</code></td>
</tr>
<tr>
<td><code v-pre>GetEffectivePermissions</code></td>
<td>获取有效权限</td>
<td><code v-pre>iam:GetEffectivePermissions</code></td>
</tr>
<tr>
<td><code v-pre>SimulatePermission</code></td>
<td>模拟权限检查</td>
<td><code v-pre>iam:SimulatePermission</code></td>
</tr>
</tbody>
</table>
<h2 id="🔧-api-详情" tabindex="-1"><a class="header-anchor" href="#🔧-api-详情">#</a> 🔧 API 详情</h2>
<h3 id="checkpermission-检查单个权限" tabindex="-1"><a class="header-anchor" href="#checkpermission-检查单个权限">#</a> CheckPermission - 检查单个权限</h3>
<p>检查指定用户是否有权限执行特定操作。</p>
<h4 id="请求" tabindex="-1"><a class="header-anchor" href="#请求">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CheckPermissionRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> action <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>            <span class="token comment">// 操作动作（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> resource <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>          <span class="token comment">// 资源ARN（必需）</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>  <span class="token comment">// 上下文信息（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应" tabindex="-1"><a class="header-anchor" href="#响应">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CheckPermissionResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">bool</span> allowed <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>             <span class="token comment">// 是否允许</span></span>
<span class="line">  <span class="token builtin">string</span> decision <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 决策结果（Allow/Deny/NotApplicable）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> matched_policies <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>  <span class="token comment">// 匹配的策略列表</span></span>
<span class="line">  <span class="token builtin">string</span> reason <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>            <span class="token comment">// 决策原因</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>      <span class="token comment">// 评估上下文</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例" tabindex="-1"><a class="header-anchor" href="#示例">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查用户读取文件权限</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "action": "s3:GetObject",</span>
<span class="line">  "resource": "arn:aws:s3:::my-bucket/documents/file.txt"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermission</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 带上下文的权限检查</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "action": "iam:UpdateUser",</span>
<span class="line">  "resource": "arn:iam::user/jane_doe",</span>
<span class="line">  "context": {</span>
<span class="line">    "aws:RequestedRegion": "us-east-1",</span>
<span class="line">    "aws:CurrentTime": "2024-01-15T10:30:00Z",</span>
<span class="line">    "aws:SourceIp": "192.168.1.100"</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermission</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例" tabindex="-1"><a class="header-anchor" href="#响应示例">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"matched_policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"DocumentAccessPolicy"</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"用户具有S3读取权限，且资源匹配策略条件"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"context"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"evaluated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"policy_version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"evaluation_time_ms"</span><span class="token operator">:</span> <span class="token string">"15"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况" tabindex="-1"><a class="header-anchor" href="#错误情况">#</a> 错误情况</h4>
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
<td>无效的资源ARN</td>
<td>检查ARN格式</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>无效的操作动作</td>
<td>使用有效的操作名称</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无权限验证权限</td>
<td>确保有<code v-pre>iam:CheckPermission</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="checkpermissions-批量检查权限" tabindex="-1"><a class="header-anchor" href="#checkpermissions-批量检查权限">#</a> CheckPermissions - 批量检查权限</h3>
<p>一次性检查多个权限，提高效率。</p>
<h4 id="请求-1" tabindex="-1"><a class="header-anchor" href="#请求-1">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CheckPermissionsRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">PermissionCheck</span> checks <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>  <span class="token comment">// 权限检查列表</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>      <span class="token comment">// 全局上下文信息（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">PermissionCheck</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> action <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>            <span class="token comment">// 操作动作</span></span>
<span class="line">  <span class="token builtin">string</span> resource <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 资源ARN</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>      <span class="token comment">// 特定上下文（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-1" tabindex="-1"><a class="header-anchor" href="#响应-1">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CheckPermissionsResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">PermissionResult</span> results <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>  <span class="token comment">// 权限检查结果列表</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>        <span class="token comment">// 评估上下文</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">PermissionResult</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> action <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>            <span class="token comment">// 操作动作</span></span>
<span class="line">  <span class="token builtin">string</span> resource <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 资源ARN</span></span>
<span class="line">  <span class="token builtin">bool</span> allowed <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>             <span class="token comment">// 是否允许</span></span>
<span class="line">  <span class="token builtin">string</span> decision <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>          <span class="token comment">// 决策结果</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> matched_policies <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>  <span class="token comment">// 匹配的策略</span></span>
<span class="line">  <span class="token builtin">string</span> reason <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>            <span class="token comment">// 决策原因</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-1" tabindex="-1"><a class="header-anchor" href="#示例-1">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 批量检查多个权限</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "checks": [</span>
<span class="line">    {</span>
<span class="line">      "action": "s3:GetObject",</span>
<span class="line">      "resource": "arn:aws:s3:::my-bucket/file1.txt"</span>
<span class="line">    },</span>
<span class="line">    {</span>
<span class="line">      "action": "s3:PutObject",</span>
<span class="line">      "resource": "arn:aws:s3:::my-bucket/file2.txt"</span>
<span class="line">    },</span>
<span class="line">    {</span>
<span class="line">      "action": "iam:ListUsers",</span>
<span class="line">      "resource": "arn:iam::user/*"</span>
<span class="line">    }</span>
<span class="line">  ],</span>
<span class="line">  "context": {</span>
<span class="line">    "aws:RequestedRegion": "us-east-1",</span>
<span class="line">    "aws:SourceIp": "192.168.1.100"</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermissions</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-1" tabindex="-1"><a class="header-anchor" href="#响应示例-1">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"results"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::my-bucket/file1.txt"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"matched_policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"用户具有S3读取权限"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::my-bucket/file2.txt"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Deny"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"matched_policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"用户没有S3写入权限"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"iam:ListUsers"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:iam::user/*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"matched_policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"IAMReadOnlyPolicy"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"用户具有IAM只读权限"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"context"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"evaluated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_checks"</span><span class="token operator">:</span> <span class="token string">"3"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"evaluation_time_ms"</span><span class="token operator">:</span> <span class="token string">"25"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-1" tabindex="-1"><a class="header-anchor" href="#错误情况-1">#</a> 错误情况</h4>
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
<td>检查列表为空</td>
<td>提供至少一个权限检查</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>检查数量超限</td>
<td>减少单次检查的数量（最大100个）</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无权限验证权限</td>
<td>确保有<code v-pre>iam:CheckPermissions</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="geteffectivepermissions-获取有效权限" tabindex="-1"><a class="header-anchor" href="#geteffectivepermissions-获取有效权限">#</a> GetEffectivePermissions - 获取有效权限</h3>
<p>获取用户对特定资源的所有有效权限。</p>
<h4 id="请求-2" tabindex="-1"><a class="header-anchor" href="#请求-2">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetEffectivePermissionsRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> resource_prefix <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>   <span class="token comment">// 资源前缀（可选）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> actions <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>  <span class="token comment">// 操作过滤（可选）</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>  <span class="token comment">// 上下文信息（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-2" tabindex="-1"><a class="header-anchor" href="#响应-2">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetEffectivePermissionsResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">EffectivePermission</span> permissions <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>  <span class="token comment">// 有效权限列表</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> policies <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                  <span class="token comment">// 相关策略列表</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>               <span class="token comment">// 评估上下文</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">EffectivePermission</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> action <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>            <span class="token comment">// 操作动作</span></span>
<span class="line">  <span class="token builtin">string</span> resource <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 资源ARN</span></span>
<span class="line">  <span class="token builtin">string</span> effect <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>            <span class="token comment">// 效果（Allow/Deny）</span></span>
<span class="line">  <span class="token builtin">string</span> source_policy <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>     <span class="token comment">// 来源策略</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> conditions <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>  <span class="token comment">// 条件列表</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-2" tabindex="-1"><a class="header-anchor" href="#示例-2">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取用户对S3的所有权限</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "resource_prefix": "arn:aws:s3:::",</span>
<span class="line">  "actions": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetEffectivePermissions</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取用户的所有IAM权限</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "admin_user",</span>
<span class="line">  "resource_prefix": "arn:iam::"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetEffectivePermissions</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-2" tabindex="-1"><a class="header-anchor" href="#响应示例-2">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"permissions"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::my-bucket/*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"source_policy"</span><span class="token operator">:</span> <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"conditions"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"StringEquals: aws:RequestedRegion = us-east-1"</span></span>
<span class="line">      <span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::my-bucket/uploads/*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"source_policy"</span><span class="token operator">:</span> <span class="token string">"S3UploadPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"conditions"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"StringLike: aws:userid = john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"DateGreaterThan: aws:CurrentTime = 2024-01-01T00:00:00Z"</span></span>
<span class="line">      <span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:DeleteObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::my-bucket/sensitive/*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"Deny"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"source_policy"</span><span class="token operator">:</span> <span class="token string">"S3ProtectionPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"conditions"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"S3UploadPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"S3ProtectionPolicy"</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"context"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"evaluated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_permissions"</span><span class="token operator">:</span> <span class="token string">"3"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"evaluation_time_ms"</span><span class="token operator">:</span> <span class="token string">"45"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-2" tabindex="-1"><a class="header-anchor" href="#错误情况-2">#</a> 错误情况</h4>
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
<td>无效的资源前缀</td>
<td>检查ARN前缀格式</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无获取权限权限</td>
<td>确保有<code v-pre>iam:GetEffectivePermissions</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="simulatepermission-模拟权限检查" tabindex="-1"><a class="header-anchor" href="#simulatepermission-模拟权限检查">#</a> SimulatePermission - 模拟权限检查</h3>
<p>模拟权限检查，用于测试和调试策略。</p>
<h4 id="请求-3" tabindex="-1"><a class="header-anchor" href="#请求-3">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">SimulatePermissionRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>         <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> policy_arns <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 策略ARN列表（可选）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">PermissionCheck</span> checks <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>  <span class="token comment">// 权限检查列表</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>      <span class="token comment">// 上下文信息（可选）</span></span>
<span class="line">  <span class="token builtin">bool</span> detailed_evaluation <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>         <span class="token comment">// 详细评估信息（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-3" tabindex="-1"><a class="header-anchor" href="#响应-3">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">SimulatePermissionResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">SimulationResult</span> results <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>  <span class="token comment">// 模拟结果列表</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> evaluated_policies <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span> <span class="token comment">// 评估的策略列表</span></span>
<span class="line">  <span class="token map class-name">map<span class="token punctuation">&lt;</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">string</span><span class="token punctuation">></span></span> context <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>        <span class="token comment">// 评估上下文</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">SimulationResult</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> action <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>            <span class="token comment">// 操作动作</span></span>
<span class="line">  <span class="token builtin">string</span> resource <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>          <span class="token comment">// 资源ARN</span></span>
<span class="line">  <span class="token builtin">bool</span> allowed <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>             <span class="token comment">// 是否允许</span></span>
<span class="line">  <span class="token builtin">string</span> decision <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>          <span class="token comment">// 决策结果</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token positional-class-name class-name">PolicyEvaluation</span> policy_evaluations <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>  <span class="token comment">// 策略评估详情</span></span>
<span class="line">  <span class="token builtin">string</span> reason <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>            <span class="token comment">// 决策原因</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">message</span> <span class="token class-name">PolicyEvaluation</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> policy_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>       <span class="token comment">// 策略名称</span></span>
<span class="line">  <span class="token builtin">string</span> effect <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>            <span class="token comment">// 效果（Allow/Deny/NotApplicable）</span></span>
<span class="line">  <span class="token builtin">bool</span> matched <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>             <span class="token comment">// 是否匹配</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> matched_statements <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>  <span class="token comment">// 匹配的语句</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> condition_results <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>   <span class="token comment">// 条件评估结果</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-3" tabindex="-1"><a class="header-anchor" href="#示例-3">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 模拟权限检查</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "policy_arns": [</span>
<span class="line">    "arn:iam::policy/S3ReadOnlyPolicy",</span>
<span class="line">    "arn:iam::policy/S3WritePolicy"</span>
<span class="line">  ],</span>
<span class="line">  "checks": [</span>
<span class="line">    {</span>
<span class="line">      "action": "s3:GetObject",</span>
<span class="line">      "resource": "arn:aws:s3:::test-bucket/file.txt"</span>
<span class="line">    },</span>
<span class="line">    {</span>
<span class="line">      "action": "s3:PutObject",</span>
<span class="line">      "resource": "arn:aws:s3:::test-bucket/upload.txt"</span>
<span class="line">    }</span>
<span class="line">  ],</span>
<span class="line">  "detailed_evaluation": true</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/SimulatePermission</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-3" tabindex="-1"><a class="header-anchor" href="#响应示例-3">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"results"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::test-bucket/file.txt"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"policy_evaluations"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"policy_name"</span><span class="token operator">:</span> <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched_statements"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"Statement1"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"condition_results"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">            <span class="token string">"StringEquals: s3:prefix = test-bucket/* -> true"</span></span>
<span class="line">          <span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"policy_name"</span><span class="token operator">:</span> <span class="token string">"S3WritePolicy"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"NotApplicable"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched_statements"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"condition_results"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"S3ReadOnlyPolicy允许读取操作"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"action"</span><span class="token operator">:</span> <span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"resource"</span><span class="token operator">:</span> <span class="token string">"arn:aws:s3:::test-bucket/upload.txt"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"allowed"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"decision"</span><span class="token operator">:</span> <span class="token string">"Deny"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"policy_evaluations"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"policy_name"</span><span class="token operator">:</span> <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"NotApplicable"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched_statements"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"condition_results"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"policy_name"</span><span class="token operator">:</span> <span class="token string">"S3WritePolicy"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"effect"</span><span class="token operator">:</span> <span class="token string">"Deny"</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"matched_statements"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"Statement2"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token property">"condition_results"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">            <span class="token string">"StringNotEquals: s3:prefix = uploads/* -> false"</span></span>
<span class="line">          <span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"reason"</span><span class="token operator">:</span> <span class="token string">"S3WritePolicy拒绝写入到非uploads目录"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"evaluated_policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token string">"S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"S3WritePolicy"</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"context"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"simulation_time"</span><span class="token operator">:</span> <span class="token string">"2024-01-15T10:30:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_checks"</span><span class="token operator">:</span> <span class="token string">"2"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"evaluation_time_ms"</span><span class="token operator">:</span> <span class="token string">"35"</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-3" tabindex="-1"><a class="header-anchor" href="#错误情况-3">#</a> 错误情况</h4>
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
<td>用户或策略不存在</td>
<td>确认用户名和策略ARN正确</td>
</tr>
<tr>
<td><code v-pre>INVALID_ARGUMENT</code></td>
<td>检查列表为空</td>
<td>提供至少一个权限检查</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无模拟权限权限</td>
<td>确保有<code v-pre>iam:SimulatePermission</code>权限</td>
</tr>
</tbody>
</table>
<h2 id="📊-权限决策逻辑" tabindex="-1"><a class="header-anchor" href="#📊-权限决策逻辑">#</a> 📊 权限决策逻辑</h2>
<h3 id="决策流程" tabindex="-1"><a class="header-anchor" href="#决策流程">#</a> 决策流程</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">flowchart</span> TD</span>
<span class="line">    A<span class="token text string">[开始权限检查]</span> <span class="token arrow operator">--></span> B<span class="token text string">[获取用户策略]</span></span>
<span class="line">    B <span class="token arrow operator">--></span> C<span class="token text string">[遍历策略语句]</span></span>
<span class="line">    C <span class="token arrow operator">--></span> D<span class="token text string">{语句匹配?}</span></span>
<span class="line">    D <span class="token arrow operator">--></span><span class="token label property">|否|</span> E<span class="token text string">[下一个语句]</span></span>
<span class="line">    D <span class="token arrow operator">--></span><span class="token label property">|是|</span> F<span class="token text string">{条件满足?}</span></span>
<span class="line">    F <span class="token arrow operator">--></span><span class="token label property">|否|</span> E</span>
<span class="line">    F <span class="token arrow operator">--></span><span class="token label property">|是|</span> G<span class="token text string">{效果类型?}</span></span>
<span class="line">    G <span class="token arrow operator">--></span><span class="token label property">|Allow|</span> H<span class="token text string">[记录Allow]</span></span>
<span class="line">    G <span class="token arrow operator">--></span><span class="token label property">|Deny|</span> I<span class="token text string">[记录Deny]</span></span>
<span class="line">    H <span class="token arrow operator">--></span> E</span>
<span class="line">    I <span class="token arrow operator">--></span> E</span>
<span class="line">    E <span class="token arrow operator">--></span> J<span class="token text string">{还有语句?}</span></span>
<span class="line">    J <span class="token arrow operator">--></span><span class="token label property">|是|</span> C</span>
<span class="line">    J <span class="token arrow operator">--></span><span class="token label property">|否|</span> K<span class="token text string">{有Deny?}</span></span>
<span class="line">    K <span class="token arrow operator">--></span><span class="token label property">|是|</span> L<span class="token text string">[返回Deny]</span></span>
<span class="line">    K <span class="token arrow operator">--></span><span class="token label property">|否|</span> M<span class="token text string">{有Allow?}</span></span>
<span class="line">    M <span class="token arrow operator">--></span><span class="token label property">|是|</span> N<span class="token text string">[返回Allow]</span></span>
<span class="line">    M <span class="token arrow operator">--></span><span class="token label property">|否|</span> O<span class="token text string">[返回Deny默认]</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="决策优先级" tabindex="-1"><a class="header-anchor" href="#决策优先级">#</a> 决策优先级</h3>
<ol>
<li><strong>显式拒绝（Explicit Deny）</strong>：最高优先级</li>
<li><strong>显式允许（Explicit Allow）</strong>：中等优先级</li>
<li><strong>隐式拒绝（Implicit Deny）</strong>：默认行为</li>
</ol>
<h3 id="策略评估顺序" tabindex="-1"><a class="header-anchor" href="#策略评估顺序">#</a> 策略评估顺序</h3>
<ol>
<li><strong>用户直接绑定的策略</strong></li>
<li><strong>用户组策略</strong>（如果支持）</li>
<li><strong>角色策略</strong>（如果支持）</li>
<li><strong>资源策略</strong>（如果支持）</li>
</ol>
<h2 id="🔐-权限要求" tabindex="-1"><a class="header-anchor" href="#🔐-权限要求">#</a> 🔐 权限要求</h2>
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
<td>检查权限</td>
<td><code v-pre>iam:CheckPermission</code></td>
<td><code v-pre>arn:iam::user/*</code></td>
</tr>
<tr>
<td>批量检查权限</td>
<td><code v-pre>iam:CheckPermissions</code></td>
<td><code v-pre>arn:iam::user/*</code></td>
</tr>
<tr>
<td>获取有效权限</td>
<td><code v-pre>iam:GetEffectivePermissions</code></td>
<td><code v-pre>arn:iam::user/*</code></td>
</tr>
<tr>
<td>模拟权限</td>
<td><code v-pre>iam:SimulatePermission</code></td>
<td><code v-pre>arn:iam::user/*</code> 和 <code v-pre>arn:iam::policy/*</code></td>
</tr>
</tbody>
</table>
<h3 id="策略示例" tabindex="-1"><a class="header-anchor" href="#策略示例">#</a> 策略示例</h3>
<h4 id="权限验证服务策略" tabindex="-1"><a class="header-anchor" href="#权限验证服务策略">#</a> 权限验证服务策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CheckPermission"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:CheckPermissions"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="权限管理员策略" tabindex="-1"><a class="header-anchor" href="#权限管理员策略">#</a> 权限管理员策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:CheckPermission"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:CheckPermissions"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:GetEffectivePermissions"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:SimulatePermission"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛠️-使用示例" tabindex="-1"><a class="header-anchor" href="#🛠️-使用示例">#</a> 🛠️ 使用示例</h2>
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
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限检查器</span></span>
<span class="line"><span class="token keyword">type</span> PermissionChecker <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    client iamv1<span class="token punctuation">.</span>IAMClient</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewPermissionChecker</span><span class="token punctuation">(</span>client iamv1<span class="token punctuation">.</span>IAMClient<span class="token punctuation">)</span> <span class="token operator">*</span>PermissionChecker <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>PermissionChecker<span class="token punctuation">{</span>client<span class="token punctuation">:</span> client<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 检查单个权限</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource <span class="token builtin">string</span><span class="token punctuation">,</span> context <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> pc<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CheckPermissionRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">        Action<span class="token punctuation">:</span>   action<span class="token punctuation">,</span></span>
<span class="line">        Resource<span class="token punctuation">:</span> resource<span class="token punctuation">,</span></span>
<span class="line">        Context<span class="token punctuation">:</span>  context<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"权限检查失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> resp<span class="token punctuation">.</span>Allowed<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 批量检查权限</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">CheckPermissions</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userName <span class="token builtin">string</span><span class="token punctuation">,</span> checks <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>PermissionCheck<span class="token punctuation">,</span> context <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>PermissionResult<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> pc<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">CheckPermissions</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CheckPermissionsRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">        Checks<span class="token punctuation">:</span>   checks<span class="token punctuation">,</span></span>
<span class="line">        Context<span class="token punctuation">:</span>  context<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"批量权限检查失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> resp<span class="token punctuation">.</span>Results<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限装饰器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">RequirePermission</span><span class="token punctuation">(</span>checker <span class="token operator">*</span>PermissionChecker<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>HandlerFunc<span class="token punctuation">)</span> http<span class="token punctuation">.</span>HandlerFunc <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>HandlerFunc<span class="token punctuation">)</span> http<span class="token punctuation">.</span>HandlerFunc <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 从请求中获取用户信息</span></span>
<span class="line">            userName <span class="token operator">:=</span> <span class="token function">getUserFromRequest</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> userName <span class="token operator">==</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">                http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"未认证"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusUnauthorized<span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 构造上下文</span></span>
<span class="line">            context <span class="token operator">:=</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">                <span class="token string">"aws:SourceIp"</span><span class="token punctuation">:</span>        <span class="token function">getClientIP</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token string">"aws:RequestedRegion"</span><span class="token punctuation">:</span> <span class="token string">"us-east-1"</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token string">"aws:CurrentTime"</span><span class="token punctuation">:</span>     time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>RFC3339<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 检查权限</span></span>
<span class="line">            allowed<span class="token punctuation">,</span> err <span class="token operator">:=</span> checker<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span><span class="token function">Context</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> context<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"权限检查错误: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">                http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"权限检查失败"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusInternalServerError<span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">if</span> <span class="token operator">!</span>allowed <span class="token punctuation">{</span></span>
<span class="line">                http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"权限不足"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusForbidden<span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 权限检查通过，继续处理请求</span></span>
<span class="line">            <span class="token function">next</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
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
<span class="line">    checker <span class="token operator">:=</span> <span class="token function">NewPermissionChecker</span><span class="token punctuation">(</span>client<span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 1. 单个权限检查</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"1. 检查单个权限..."</span><span class="token punctuation">)</span></span>
<span class="line">    allowed<span class="token punctuation">,</span> err <span class="token operator">:=</span> checker<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span> <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/file.txt"</span><span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"权限检查失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"权限检查结果: %t\n"</span><span class="token punctuation">,</span> allowed<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 批量权限检查</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n2. 批量权限检查..."</span><span class="token punctuation">)</span></span>
<span class="line">    checks <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>PermissionCheck<span class="token punctuation">{</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            Action<span class="token punctuation">:</span>   <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span></span>
<span class="line">            Resource<span class="token punctuation">:</span> <span class="token string">"arn:aws:s3:::my-bucket/file1.txt"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            Action<span class="token punctuation">:</span>   <span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span></span>
<span class="line">            Resource<span class="token punctuation">:</span> <span class="token string">"arn:aws:s3:::my-bucket/file2.txt"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            Action<span class="token punctuation">:</span>   <span class="token string">"iam:ListUsers"</span><span class="token punctuation">,</span></span>
<span class="line">            Resource<span class="token punctuation">:</span> <span class="token string">"arn:iam::user/*"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    results<span class="token punctuation">,</span> err <span class="token operator">:=</span> checker<span class="token punctuation">.</span><span class="token function">CheckPermissions</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span> checks<span class="token punctuation">,</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"aws:RequestedRegion"</span><span class="token punctuation">:</span> <span class="token string">"us-east-1"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"批量权限检查失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"批量检查结果:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> result <span class="token operator">:=</span> <span class="token keyword">range</span> results <span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  %d. %s on %s: %t (%s)\n"</span><span class="token punctuation">,</span> i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> result<span class="token punctuation">.</span>Action<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Allowed<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Decision<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 获取有效权限</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n3. 获取有效权限..."</span><span class="token punctuation">)</span></span>
<span class="line">    effectiveResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">GetEffectivePermissions</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>GetEffectivePermissionsRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>       <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">        ResourcePrefix<span class="token punctuation">:</span> <span class="token string">"arn:aws:s3:::"</span><span class="token punctuation">,</span></span>
<span class="line">        Actions<span class="token punctuation">:</span>        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"s3:PutObject"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"获取有效权限失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"有效权限 (%d 个):\n"</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>effectiveResp<span class="token punctuation">.</span>Permissions<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> perm <span class="token operator">:=</span> <span class="token keyword">range</span> effectiveResp<span class="token punctuation">.</span>Permissions <span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  %d. %s on %s: %s (来源: %s)\n"</span><span class="token punctuation">,</span> i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> perm<span class="token punctuation">.</span>Action<span class="token punctuation">,</span> perm<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span> perm<span class="token punctuation">.</span>Effect<span class="token punctuation">,</span> perm<span class="token punctuation">.</span>SourcePolicy<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 模拟权限检查</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"\n4. 模拟权限检查..."</span><span class="token punctuation">)</span></span>
<span class="line">    simulateResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">SimulatePermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>SimulatePermissionRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span> <span class="token string">"john_doe"</span><span class="token punctuation">,</span></span>
<span class="line">        PolicyArns<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">            <span class="token string">"arn:iam::policy/S3ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        Checks<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>PermissionCheck<span class="token punctuation">{</span></span>
<span class="line">            <span class="token punctuation">{</span></span>
<span class="line">                Action<span class="token punctuation">:</span>   <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span></span>
<span class="line">                Resource<span class="token punctuation">:</span> <span class="token string">"arn:aws:s3:::test-bucket/file.txt"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        DetailedEvaluation<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"模拟权限检查失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"模拟结果:\n"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> result <span class="token operator">:=</span> <span class="token keyword">range</span> simulateResp<span class="token punctuation">.</span>Results <span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"  %d. %s on %s: %t\n"</span><span class="token punctuation">,</span> i<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> result<span class="token punctuation">.</span>Action<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Allowed<span class="token punctuation">)</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"     原因: %s\n"</span><span class="token punctuation">,</span> result<span class="token punctuation">.</span>Reason<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">for</span> j<span class="token punctuation">,</span> eval <span class="token operator">:=</span> <span class="token keyword">range</span> result<span class="token punctuation">.</span>PolicyEvaluations <span class="token punctuation">{</span></span>
<span class="line">            fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"     策略%d: %s - %s (匹配: %t)\n"</span><span class="token punctuation">,</span> j<span class="token operator">+</span><span class="token number">1</span><span class="token punctuation">,</span> eval<span class="token punctuation">.</span>PolicyName<span class="token punctuation">,</span> eval<span class="token punctuation">.</span>Effect<span class="token punctuation">,</span> eval<span class="token punctuation">.</span>Matched<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 辅助函数</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getUserFromRequest</span><span class="token punctuation">(</span>r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 从JWT token、session或其他方式获取用户名</span></span>
<span class="line">    <span class="token keyword">return</span> r<span class="token punctuation">.</span>Header<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"X-User-Name"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getClientIP</span><span class="token punctuation">(</span>r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 获取客户端IP</span></span>
<span class="line">    forwarded <span class="token operator">:=</span> r<span class="token punctuation">.</span>Header<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"X-Forwarded-For"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> forwarded <span class="token operator">!=</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> strings<span class="token punctuation">.</span><span class="token function">Split</span><span class="token punctuation">(</span>forwarded<span class="token punctuation">,</span> <span class="token string">","</span><span class="token punctuation">)</span><span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> r<span class="token punctuation">.</span>RemoteAddr</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="权限中间件示例" tabindex="-1"><a class="header-anchor" href="#权限中间件示例">#</a> 权限中间件示例</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> middleware</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"encoding/json"</span></span>
<span class="line">    <span class="token string">"net/http"</span></span>
<span class="line">    <span class="token string">"strings"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限中间件配置</span></span>
<span class="line"><span class="token keyword">type</span> PermissionMiddlewareConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    IAMClient    iamv1<span class="token punctuation">.</span>IAMClient</span>
<span class="line">    SkipPaths    <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span></span>
<span class="line">    ErrorHandler <span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">,</span> err <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">PermissionMiddleware</span><span class="token punctuation">(</span>config PermissionMiddlewareConfig<span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 检查是否跳过权限验证</span></span>
<span class="line">            <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> path <span class="token operator">:=</span> <span class="token keyword">range</span> config<span class="token punctuation">.</span>SkipPaths <span class="token punctuation">{</span></span>
<span class="line">                <span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">,</span> path<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                    next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">                    <span class="token keyword">return</span></span>
<span class="line">                <span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 获取用户信息</span></span>
<span class="line">            userName <span class="token operator">:=</span> <span class="token function">getUserFromContext</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span><span class="token function">Context</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> userName <span class="token operator">==</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">                http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"未认证"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusUnauthorized<span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 构造权限检查参数</span></span>
<span class="line">            action <span class="token operator">:=</span> <span class="token function">getActionFromRequest</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span></span>
<span class="line">            resource <span class="token operator">:=</span> <span class="token function">getResourceFromRequest</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span></span>
<span class="line">            context <span class="token operator">:=</span> <span class="token function">getContextFromRequest</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 检查权限</span></span>
<span class="line">            resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> config<span class="token punctuation">.</span>IAMClient<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span><span class="token function">Context</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CheckPermissionRequest<span class="token punctuation">{</span></span>
<span class="line">                UserName<span class="token punctuation">:</span> userName<span class="token punctuation">,</span></span>
<span class="line">                Action<span class="token punctuation">:</span>   action<span class="token punctuation">,</span></span>
<span class="line">                Resource<span class="token punctuation">:</span> resource<span class="token punctuation">,</span></span>
<span class="line">                Context<span class="token punctuation">:</span>  context<span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token keyword">if</span> config<span class="token punctuation">.</span>ErrorHandler <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                    config<span class="token punctuation">.</span><span class="token function">ErrorHandler</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">                <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">                    http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"权限检查失败"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusInternalServerError<span class="token punctuation">)</span></span>
<span class="line">                <span class="token punctuation">}</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">if</span> <span class="token operator">!</span>resp<span class="token punctuation">.</span>Allowed <span class="token punctuation">{</span></span>
<span class="line">                <span class="token comment">// 记录权限拒绝日志</span></span>
<span class="line">                <span class="token function">logPermissionDenied</span><span class="token punctuation">(</span>userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>Reason<span class="token punctuation">)</span></span>
<span class="line">                </span>
<span class="line">                w<span class="token punctuation">.</span><span class="token function">Header</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Content-Type"</span><span class="token punctuation">,</span> <span class="token string">"application/json"</span><span class="token punctuation">)</span></span>
<span class="line">                w<span class="token punctuation">.</span><span class="token function">WriteHeader</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusForbidden<span class="token punctuation">)</span></span>
<span class="line">                json<span class="token punctuation">.</span><span class="token function">NewEncoder</span><span class="token punctuation">(</span>w<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Encode</span><span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">                    <span class="token string">"error"</span><span class="token punctuation">:</span>   <span class="token string">"权限不足"</span><span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"action"</span><span class="token punctuation">:</span>  action<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"resource"</span><span class="token punctuation">:</span> resource<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"reason"</span><span class="token punctuation">:</span>  resp<span class="token punctuation">.</span>Reason<span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 权限检查通过，添加权限信息到上下文</span></span>
<span class="line">            ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">WithValue</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span><span class="token function">Context</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">"permission_check"</span><span class="token punctuation">,</span> resp<span class="token punctuation">)</span></span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">.</span><span class="token function">WithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 从请求构造操作动作</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getActionFromRequest</span><span class="token punctuation">(</span>r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    method <span class="token operator">:=</span> r<span class="token punctuation">.</span>Method</span>
<span class="line">    path <span class="token operator">:=</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 根据HTTP方法和路径构造操作</span></span>
<span class="line">    <span class="token keyword">switch</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"GET"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"iam:ListUsers"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"GET"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users/"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"iam:GetUser"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"POST"</span> <span class="token operator">&amp;&amp;</span> path <span class="token operator">==</span> <span class="token string">"/api/users"</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"iam:CreateUser"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"PUT"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users/"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"iam:UpdateUser"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"DELETE"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users/"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"iam:DeleteUser"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"GET"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/files"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"s3:GetObject"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"POST"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/files"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"s3:PutObject"</span></span>
<span class="line">    <span class="token keyword">case</span> method <span class="token operator">==</span> <span class="token string">"DELETE"</span> <span class="token operator">&amp;&amp;</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/files"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"s3:DeleteObject"</span></span>
<span class="line">    <span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"unknown:Action"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 从请求构造资源ARN</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getResourceFromRequest</span><span class="token punctuation">(</span>r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    path <span class="token operator">:=</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">switch</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">case</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/users/"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 提取用户名</span></span>
<span class="line">            parts <span class="token operator">:=</span> strings<span class="token punctuation">.</span><span class="token function">Split</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/"</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>parts<span class="token punctuation">)</span> <span class="token operator">>=</span> <span class="token number">4</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token keyword">return</span> <span class="token string">"arn:iam::user/"</span> <span class="token operator">+</span> parts<span class="token punctuation">[</span><span class="token number">3</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"arn:iam::user/*"</span></span>
<span class="line">    <span class="token keyword">case</span> strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/files"</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token comment">// 提取文件路径</span></span>
<span class="line">        filePath <span class="token operator">:=</span> strings<span class="token punctuation">.</span><span class="token function">TrimPrefix</span><span class="token punctuation">(</span>path<span class="token punctuation">,</span> <span class="token string">"/api/files/"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"arn:aws:s3:::my-bucket/"</span> <span class="token operator">+</span> filePath</span>
<span class="line">    <span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">"arn:unknown::resource/*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 从请求构造上下文</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getContextFromRequest</span><span class="token punctuation">(</span>r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"aws:SourceIp"</span><span class="token punctuation">:</span>        <span class="token function">getClientIP</span><span class="token punctuation">(</span>r<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"aws:RequestedRegion"</span><span class="token punctuation">:</span> <span class="token string">"us-east-1"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"aws:CurrentTime"</span><span class="token punctuation">:</span>     time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>RFC3339<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"http:Method"</span><span class="token punctuation">:</span>         r<span class="token punctuation">.</span>Method<span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"http:UserAgent"</span><span class="token punctuation">:</span>      r<span class="token punctuation">.</span><span class="token function">UserAgent</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 记录权限拒绝日志</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">logPermissionDenied</span><span class="token punctuation">(</span>userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> reason <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"权限拒绝: 用户=%s, 操作=%s, 资源=%s, 原因=%s"</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> reason<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="python-客户端示例" tabindex="-1"><a class="header-anchor" href="#python-客户端示例">#</a> Python 客户端示例</h3>
<div class="language-python line-numbers-mode" data-highlighter="prismjs" data-ext="py"><pre v-pre><code class="language-python"><span class="line"><span class="token keyword">import</span> grpc</span>
<span class="line"><span class="token keyword">import</span> asyncio</span>
<span class="line"><span class="token keyword">from</span> typing <span class="token keyword">import</span> List<span class="token punctuation">,</span> Dict<span class="token punctuation">,</span> Optional<span class="token punctuation">,</span> Tuple</span>
<span class="line"><span class="token keyword">from</span> dataclasses <span class="token keyword">import</span> dataclass</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 假设已生成的Python gRPC客户端</span></span>
<span class="line"><span class="token keyword">from</span> iam<span class="token punctuation">.</span>v1 <span class="token keyword">import</span> iam_pb2<span class="token punctuation">,</span> iam_pb2_grpc</span>
<span class="line"></span>
<span class="line"><span class="token decorator annotation punctuation">@dataclass</span></span>
<span class="line"><span class="token keyword">class</span> <span class="token class-name">PermissionCheck</span><span class="token punctuation">:</span></span>
<span class="line">    action<span class="token punctuation">:</span> <span class="token builtin">str</span></span>
<span class="line">    resource<span class="token punctuation">:</span> <span class="token builtin">str</span></span>
<span class="line">    context<span class="token punctuation">:</span> Optional<span class="token punctuation">[</span>Dict<span class="token punctuation">[</span><span class="token builtin">str</span><span class="token punctuation">,</span> <span class="token builtin">str</span><span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token boolean">None</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">class</span> <span class="token class-name">PermissionChecker</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token keyword">def</span> <span class="token function">__init__</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> channel<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        self<span class="token punctuation">.</span>client <span class="token operator">=</span> iam_pb2_grpc<span class="token punctuation">.</span>IAMStub<span class="token punctuation">(</span>channel<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">check_permission</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_name<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> action<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> resource<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> </span>
<span class="line">                             context<span class="token punctuation">:</span> Optional<span class="token punctuation">[</span>Dict<span class="token punctuation">[</span><span class="token builtin">str</span><span class="token punctuation">,</span> <span class="token builtin">str</span><span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token boolean">None</span><span class="token punctuation">)</span> <span class="token operator">-</span><span class="token operator">></span> Tuple<span class="token punctuation">[</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">str</span><span class="token punctuation">]</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""检查单个权限"""</span></span>
<span class="line">        request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>CheckPermissionRequest<span class="token punctuation">(</span></span>
<span class="line">            user_name<span class="token operator">=</span>user_name<span class="token punctuation">,</span></span>
<span class="line">            action<span class="token operator">=</span>action<span class="token punctuation">,</span></span>
<span class="line">            resource<span class="token operator">=</span>resource<span class="token punctuation">,</span></span>
<span class="line">            context<span class="token operator">=</span>context <span class="token keyword">or</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">try</span><span class="token punctuation">:</span></span>
<span class="line">            response <span class="token operator">=</span> <span class="token keyword">await</span> self<span class="token punctuation">.</span>client<span class="token punctuation">.</span>CheckPermission<span class="token punctuation">(</span>request<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">return</span> response<span class="token punctuation">.</span>allowed<span class="token punctuation">,</span> response<span class="token punctuation">.</span>reason</span>
<span class="line">        <span class="token keyword">except</span> grpc<span class="token punctuation">.</span>RpcError <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">raise</span> Exception<span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"权限检查失败: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">.</span>details<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">check_permissions</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_name<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> checks<span class="token punctuation">:</span> List<span class="token punctuation">[</span>PermissionCheck<span class="token punctuation">]</span><span class="token punctuation">,</span> </span>
<span class="line">                              context<span class="token punctuation">:</span> Optional<span class="token punctuation">[</span>Dict<span class="token punctuation">[</span><span class="token builtin">str</span><span class="token punctuation">,</span> <span class="token builtin">str</span><span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token boolean">None</span><span class="token punctuation">)</span> <span class="token operator">-</span><span class="token operator">></span> List<span class="token punctuation">[</span>Dict<span class="token punctuation">]</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""批量检查权限"""</span></span>
<span class="line">        grpc_checks <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token keyword">for</span> check <span class="token keyword">in</span> checks<span class="token punctuation">:</span></span>
<span class="line">            grpc_check <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>PermissionCheck<span class="token punctuation">(</span></span>
<span class="line">                action<span class="token operator">=</span>check<span class="token punctuation">.</span>action<span class="token punctuation">,</span></span>
<span class="line">                resource<span class="token operator">=</span>check<span class="token punctuation">.</span>resource<span class="token punctuation">,</span></span>
<span class="line">                context<span class="token operator">=</span>check<span class="token punctuation">.</span>context <span class="token keyword">or</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">            grpc_checks<span class="token punctuation">.</span>append<span class="token punctuation">(</span>grpc_check<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>CheckPermissionsRequest<span class="token punctuation">(</span></span>
<span class="line">            user_name<span class="token operator">=</span>user_name<span class="token punctuation">,</span></span>
<span class="line">            checks<span class="token operator">=</span>grpc_checks<span class="token punctuation">,</span></span>
<span class="line">            context<span class="token operator">=</span>context <span class="token keyword">or</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">try</span><span class="token punctuation">:</span></span>
<span class="line">            response <span class="token operator">=</span> <span class="token keyword">await</span> self<span class="token punctuation">.</span>client<span class="token punctuation">.</span>CheckPermissions<span class="token punctuation">(</span>request<span class="token punctuation">)</span></span>
<span class="line">            results <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token keyword">for</span> result <span class="token keyword">in</span> response<span class="token punctuation">.</span>results<span class="token punctuation">:</span></span>
<span class="line">                results<span class="token punctuation">.</span>append<span class="token punctuation">(</span><span class="token punctuation">{</span></span>
<span class="line">                    <span class="token string">'action'</span><span class="token punctuation">:</span> result<span class="token punctuation">.</span>action<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'resource'</span><span class="token punctuation">:</span> result<span class="token punctuation">.</span>resource<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'allowed'</span><span class="token punctuation">:</span> result<span class="token punctuation">.</span>allowed<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'decision'</span><span class="token punctuation">:</span> result<span class="token punctuation">.</span>decision<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'reason'</span><span class="token punctuation">:</span> result<span class="token punctuation">.</span>reason<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'matched_policies'</span><span class="token punctuation">:</span> <span class="token builtin">list</span><span class="token punctuation">(</span>result<span class="token punctuation">.</span>matched_policies<span class="token punctuation">)</span></span>
<span class="line">                <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">return</span> results</span>
<span class="line">        <span class="token keyword">except</span> grpc<span class="token punctuation">.</span>RpcError <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">raise</span> Exception<span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"批量权限检查失败: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">.</span>details<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">get_effective_permissions</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_name<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> </span>
<span class="line">                                      resource_prefix<span class="token punctuation">:</span> Optional<span class="token punctuation">[</span><span class="token builtin">str</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token boolean">None</span><span class="token punctuation">,</span></span>
<span class="line">                                      actions<span class="token punctuation">:</span> Optional<span class="token punctuation">[</span>List<span class="token punctuation">[</span><span class="token builtin">str</span><span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token boolean">None</span><span class="token punctuation">)</span> <span class="token operator">-</span><span class="token operator">></span> List<span class="token punctuation">[</span>Dict<span class="token punctuation">]</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""获取有效权限"""</span></span>
<span class="line">        request <span class="token operator">=</span> iam_pb2<span class="token punctuation">.</span>GetEffectivePermissionsRequest<span class="token punctuation">(</span></span>
<span class="line">            user_name<span class="token operator">=</span>user_name<span class="token punctuation">,</span></span>
<span class="line">            resource_prefix<span class="token operator">=</span>resource_prefix <span class="token keyword">or</span> <span class="token string">""</span><span class="token punctuation">,</span></span>
<span class="line">            actions<span class="token operator">=</span>actions <span class="token keyword">or</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">try</span><span class="token punctuation">:</span></span>
<span class="line">            response <span class="token operator">=</span> <span class="token keyword">await</span> self<span class="token punctuation">.</span>client<span class="token punctuation">.</span>GetEffectivePermissions<span class="token punctuation">(</span>request<span class="token punctuation">)</span></span>
<span class="line">            permissions <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token keyword">for</span> perm <span class="token keyword">in</span> response<span class="token punctuation">.</span>permissions<span class="token punctuation">:</span></span>
<span class="line">                permissions<span class="token punctuation">.</span>append<span class="token punctuation">(</span><span class="token punctuation">{</span></span>
<span class="line">                    <span class="token string">'action'</span><span class="token punctuation">:</span> perm<span class="token punctuation">.</span>action<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'resource'</span><span class="token punctuation">:</span> perm<span class="token punctuation">.</span>resource<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'effect'</span><span class="token punctuation">:</span> perm<span class="token punctuation">.</span>effect<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'source_policy'</span><span class="token punctuation">:</span> perm<span class="token punctuation">.</span>source_policy<span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">'conditions'</span><span class="token punctuation">:</span> <span class="token builtin">list</span><span class="token punctuation">(</span>perm<span class="token punctuation">.</span>conditions<span class="token punctuation">)</span></span>
<span class="line">                <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">return</span> permissions</span>
<span class="line">        <span class="token keyword">except</span> grpc<span class="token punctuation">.</span>RpcError <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">raise</span> Exception<span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"获取有效权限失败: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">.</span>details<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 权限装饰器</span></span>
<span class="line"><span class="token keyword">def</span> <span class="token function">require_permission</span><span class="token punctuation">(</span>action<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">,</span> resource<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token triple-quoted-string string">"""权限检查装饰器"""</span></span>
<span class="line">    <span class="token keyword">def</span> <span class="token function">decorator</span><span class="token punctuation">(</span>func<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">wrapper</span><span class="token punctuation">(</span><span class="token operator">*</span>args<span class="token punctuation">,</span> <span class="token operator">**</span>kwargs<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token comment"># 假设从某处获取用户信息和权限检查器</span></span>
<span class="line">            user_name <span class="token operator">=</span> get_current_user<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            checker <span class="token operator">=</span> get_permission_checker<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">if</span> <span class="token keyword">not</span> user_name<span class="token punctuation">:</span></span>
<span class="line">                <span class="token keyword">raise</span> Exception<span class="token punctuation">(</span><span class="token string">"未认证"</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment"># 检查权限</span></span>
<span class="line">            allowed<span class="token punctuation">,</span> reason <span class="token operator">=</span> <span class="token keyword">await</span> checker<span class="token punctuation">.</span>check_permission<span class="token punctuation">(</span>user_name<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> <span class="token keyword">not</span> allowed<span class="token punctuation">:</span></span>
<span class="line">                <span class="token keyword">raise</span> Exception<span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"权限不足: </span><span class="token interpolation"><span class="token punctuation">{</span>reason<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment"># 权限检查通过，执行原函数</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token keyword">await</span> func<span class="token punctuation">(</span><span class="token operator">*</span>args<span class="token punctuation">,</span> <span class="token operator">**</span>kwargs<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> wrapper</span>
<span class="line">    <span class="token keyword">return</span> decorator</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 使用示例</span></span>
<span class="line"><span class="token keyword">class</span> <span class="token class-name">UserService</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token keyword">def</span> <span class="token function">__init__</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> permission_checker<span class="token punctuation">:</span> PermissionChecker<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        self<span class="token punctuation">.</span>permission_checker <span class="token operator">=</span> permission_checker</span>
<span class="line">    </span>
<span class="line">    <span class="token decorator annotation punctuation">@require_permission</span><span class="token punctuation">(</span><span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span> <span class="token string">"arn:iam::user/*"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">get_user</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_id<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""获取用户信息"""</span></span>
<span class="line">        <span class="token comment"># 实际的用户获取逻辑</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">{</span><span class="token string">"id"</span><span class="token punctuation">:</span> user_id<span class="token punctuation">,</span> <span class="token string">"name"</span><span class="token punctuation">:</span> <span class="token string">"John Doe"</span><span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token decorator annotation punctuation">@require_permission</span><span class="token punctuation">(</span><span class="token string">"iam:CreateUser"</span><span class="token punctuation">,</span> <span class="token string">"arn:iam::user/*"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">create_user</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_data<span class="token punctuation">:</span> Dict<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""创建用户"""</span></span>
<span class="line">        <span class="token comment"># 实际的用户创建逻辑</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">{</span><span class="token string">"id"</span><span class="token punctuation">:</span> <span class="token string">"new_user_id"</span><span class="token punctuation">,</span> <span class="token string">"name"</span><span class="token punctuation">:</span> user_data<span class="token punctuation">[</span><span class="token string">"name"</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">check_user_permissions</span><span class="token punctuation">(</span>self<span class="token punctuation">,</span> user_name<span class="token punctuation">:</span> <span class="token builtin">str</span><span class="token punctuation">)</span> <span class="token operator">-</span><span class="token operator">></span> Dict<span class="token punctuation">:</span></span>
<span class="line">        <span class="token triple-quoted-string string">"""检查用户的多个权限"""</span></span>
<span class="line">        checks <span class="token operator">=</span> <span class="token punctuation">[</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"arn:iam::user/</span><span class="token interpolation"><span class="token punctuation">{</span>user_name<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"iam:UpdateUser"</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"arn:iam::user/</span><span class="token interpolation"><span class="token punctuation">{</span>user_name<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"iam:DeleteUser"</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"arn:iam::user/</span><span class="token interpolation"><span class="token punctuation">{</span>user_name<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/*"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/*"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">]</span></span>
<span class="line">        </span>
<span class="line">        results <span class="token operator">=</span> <span class="token keyword">await</span> self<span class="token punctuation">.</span>permission_checker<span class="token punctuation">.</span>check_permissions<span class="token punctuation">(</span>user_name<span class="token punctuation">,</span> checks<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 整理结果</span></span>
<span class="line">        permissions <span class="token operator">=</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">for</span> result <span class="token keyword">in</span> results<span class="token punctuation">:</span></span>
<span class="line">            permissions<span class="token punctuation">[</span>result<span class="token punctuation">[</span><span class="token string">'action'</span><span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token string">'allowed'</span><span class="token punctuation">:</span> result<span class="token punctuation">[</span><span class="token string">'allowed'</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token string">'reason'</span><span class="token punctuation">:</span> result<span class="token punctuation">[</span><span class="token string">'reason'</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">return</span> permissions</span>
<span class="line"></span>
<span class="line"><span class="token keyword">async</span> <span class="token keyword">def</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 连接到服务</span></span>
<span class="line">    <span class="token keyword">async</span> <span class="token keyword">with</span> grpc<span class="token punctuation">.</span>aio<span class="token punctuation">.</span>insecure_channel<span class="token punctuation">(</span><span class="token string">'localhost:50051'</span><span class="token punctuation">)</span> <span class="token keyword">as</span> channel<span class="token punctuation">:</span></span>
<span class="line">        checker <span class="token operator">=</span> PermissionChecker<span class="token punctuation">(</span>channel<span class="token punctuation">)</span></span>
<span class="line">        user_service <span class="token operator">=</span> UserService<span class="token punctuation">(</span>checker<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 1. 检查单个权限</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"1. 检查单个权限..."</span><span class="token punctuation">)</span></span>
<span class="line">        allowed<span class="token punctuation">,</span> reason <span class="token operator">=</span> <span class="token keyword">await</span> checker<span class="token punctuation">.</span>check_permission<span class="token punctuation">(</span></span>
<span class="line">            <span class="token string">"john_doe"</span><span class="token punctuation">,</span> <span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/file.txt"</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"权限检查结果: </span><span class="token interpolation"><span class="token punctuation">{</span>allowed<span class="token punctuation">}</span></span><span class="token string">, 原因: </span><span class="token interpolation"><span class="token punctuation">{</span>reason<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 2. 批量检查权限</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n2. 批量检查权限..."</span><span class="token punctuation">)</span></span>
<span class="line">        checks <span class="token operator">=</span> <span class="token punctuation">[</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/file1.txt"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"s3:PutObject"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::my-bucket/file2.txt"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            PermissionCheck<span class="token punctuation">(</span><span class="token string">"iam:ListUsers"</span><span class="token punctuation">,</span> <span class="token string">"arn:iam::user/*"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">]</span></span>
<span class="line">        </span>
<span class="line">        results <span class="token operator">=</span> <span class="token keyword">await</span> checker<span class="token punctuation">.</span>check_permissions<span class="token punctuation">(</span><span class="token string">"john_doe"</span><span class="token punctuation">,</span> checks<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"批量检查结果:"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">for</span> i<span class="token punctuation">,</span> result <span class="token keyword">in</span> <span class="token builtin">enumerate</span><span class="token punctuation">(</span>results<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  </span><span class="token interpolation"><span class="token punctuation">{</span>i<span class="token punctuation">}</span></span><span class="token string">. </span><span class="token interpolation"><span class="token punctuation">{</span>result<span class="token punctuation">[</span><span class="token string">'action'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string"> on </span><span class="token interpolation"><span class="token punctuation">{</span>result<span class="token punctuation">[</span><span class="token string">'resource'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string">: </span><span class="token interpolation"><span class="token punctuation">{</span>result<span class="token punctuation">[</span><span class="token string">'allowed'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 3. 获取有效权限</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n3. 获取有效权限..."</span><span class="token punctuation">)</span></span>
<span class="line">        permissions <span class="token operator">=</span> <span class="token keyword">await</span> checker<span class="token punctuation">.</span>get_effective_permissions<span class="token punctuation">(</span></span>
<span class="line">            <span class="token string">"john_doe"</span><span class="token punctuation">,</span> <span class="token string">"arn:aws:s3:::"</span><span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token string">"s3:GetObject"</span><span class="token punctuation">,</span> <span class="token string">"s3:PutObject"</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"有效权限 (</span><span class="token interpolation"><span class="token punctuation">{</span><span class="token builtin">len</span><span class="token punctuation">(</span>permissions<span class="token punctuation">)</span><span class="token punctuation">}</span></span><span class="token string"> 个):"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">for</span> i<span class="token punctuation">,</span> perm <span class="token keyword">in</span> <span class="token builtin">enumerate</span><span class="token punctuation">(</span>permissions<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  </span><span class="token interpolation"><span class="token punctuation">{</span>i<span class="token punctuation">}</span></span><span class="token string">. </span><span class="token interpolation"><span class="token punctuation">{</span>perm<span class="token punctuation">[</span><span class="token string">'action'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string"> on </span><span class="token interpolation"><span class="token punctuation">{</span>perm<span class="token punctuation">[</span><span class="token string">'resource'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string">: </span><span class="token interpolation"><span class="token punctuation">{</span>perm<span class="token punctuation">[</span><span class="token string">'effect'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 4. 使用服务方法</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n4. 使用服务方法..."</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">try</span><span class="token punctuation">:</span></span>
<span class="line">            user <span class="token operator">=</span> <span class="token keyword">await</span> user_service<span class="token punctuation">.</span>get_user<span class="token punctuation">(</span><span class="token string">"john_doe"</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"获取用户成功: </span><span class="token interpolation"><span class="token punctuation">{</span>user<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">except</span> Exception <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"获取用户失败: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 5. 检查用户的多个权限</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"\n5. 检查用户的多个权限..."</span><span class="token punctuation">)</span></span>
<span class="line">        user_permissions <span class="token operator">=</span> <span class="token keyword">await</span> user_service<span class="token punctuation">.</span>check_user_permissions<span class="token punctuation">(</span><span class="token string">"john_doe"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string">"用户权限:"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">for</span> action<span class="token punctuation">,</span> perm <span class="token keyword">in</span> user_permissions<span class="token punctuation">.</span>items<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"  </span><span class="token interpolation"><span class="token punctuation">{</span>action<span class="token punctuation">}</span></span><span class="token string">: </span><span class="token interpolation"><span class="token punctuation">{</span>perm<span class="token punctuation">[</span><span class="token string">'allowed'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string"> (</span><span class="token interpolation"><span class="token punctuation">{</span>perm<span class="token punctuation">[</span><span class="token string">'reason'</span><span class="token punctuation">]</span><span class="token punctuation">}</span></span><span class="token string">)"</span></span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> __name__ <span class="token operator">==</span> <span class="token string">"__main__"</span><span class="token punctuation">:</span></span>
<span class="line">    asyncio<span class="token punctuation">.</span>run<span class="token punctuation">(</span>main<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔍-最佳实践">#</a> 🔍 最佳实践</h2>
<h3 id="_1-权限检查优化" tabindex="-1"><a class="header-anchor" href="#_1-权限检查优化">#</a> 1. 权限检查优化</h3>
<h4 id="缓存权限结果" tabindex="-1"><a class="header-anchor" href="#缓存权限结果">#</a> 缓存权限结果</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">type</span> PermissionCache <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    cache <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>CacheEntry</span>
<span class="line">    mutex sync<span class="token punctuation">.</span>RWMutex</span>
<span class="line">    ttl   time<span class="token punctuation">.</span>Duration</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> CacheEntry <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    allowed   <span class="token builtin">bool</span></span>
<span class="line">    timestamp time<span class="token punctuation">.</span>Time</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionCache<span class="token punctuation">)</span> <span class="token function">Get</span><span class="token punctuation">(</span>key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">bool</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    pc<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">RLock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> pc<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">RUnlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    entry<span class="token punctuation">,</span> exists <span class="token operator">:=</span> pc<span class="token punctuation">.</span>cache<span class="token punctuation">[</span>key<span class="token punctuation">]</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token operator">!</span>exists <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span><span class="token punctuation">,</span> <span class="token boolean">false</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>entry<span class="token punctuation">.</span>timestamp<span class="token punctuation">)</span> <span class="token operator">></span> pc<span class="token punctuation">.</span>ttl <span class="token punctuation">{</span></span>
<span class="line">        <span class="token function">delete</span><span class="token punctuation">(</span>pc<span class="token punctuation">.</span>cache<span class="token punctuation">,</span> key<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span><span class="token punctuation">,</span> <span class="token boolean">false</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> entry<span class="token punctuation">.</span>allowed<span class="token punctuation">,</span> <span class="token boolean">true</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionCache<span class="token punctuation">)</span> <span class="token function">Set</span><span class="token punctuation">(</span>key <span class="token builtin">string</span><span class="token punctuation">,</span> allowed <span class="token builtin">bool</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    pc<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> pc<span class="token punctuation">.</span>mutex<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    pc<span class="token punctuation">.</span>cache<span class="token punctuation">[</span>key<span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token operator">&amp;</span>CacheEntry<span class="token punctuation">{</span></span>
<span class="line">        allowed<span class="token punctuation">:</span>   allowed<span class="token punctuation">,</span></span>
<span class="line">        timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 带缓存的权限检查</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">CheckPermissionWithCache</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 构造缓存键</span></span>
<span class="line">    cacheKey <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:%s:%s"</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 检查缓存</span></span>
<span class="line">    <span class="token keyword">if</span> allowed<span class="token punctuation">,</span> found <span class="token operator">:=</span> pc<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>cacheKey<span class="token punctuation">)</span><span class="token punctuation">;</span> found <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> allowed<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 缓存未命中，调用API</span></span>
<span class="line">    allowed<span class="token punctuation">,</span> err <span class="token operator">:=</span> pc<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 缓存结果</span></span>
<span class="line">    pc<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>cacheKey<span class="token punctuation">,</span> allowed<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> allowed<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="批量权限检查" tabindex="-1"><a class="header-anchor" href="#批量权限检查">#</a> 批量权限检查</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 智能批量权限检查</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">SmartCheckPermissions</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userName <span class="token builtin">string</span><span class="token punctuation">,</span> checks <span class="token punctuation">[</span><span class="token punctuation">]</span>PermissionCheck<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    results <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">bool</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">var</span> uncachedChecks <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>iamv1<span class="token punctuation">.</span>PermissionCheck</span>
<span class="line">    <span class="token keyword">var</span> uncachedKeys <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 检查缓存</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> check <span class="token operator">:=</span> <span class="token keyword">range</span> checks <span class="token punctuation">{</span></span>
<span class="line">        key <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:%s:%s"</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> check<span class="token punctuation">.</span>Action<span class="token punctuation">,</span> check<span class="token punctuation">.</span>Resource<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> allowed<span class="token punctuation">,</span> found <span class="token operator">:=</span> pc<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>key<span class="token punctuation">)</span><span class="token punctuation">;</span> found <span class="token punctuation">{</span></span>
<span class="line">            results<span class="token punctuation">[</span>key<span class="token punctuation">]</span> <span class="token operator">=</span> allowed</span>
<span class="line">        <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">            uncachedChecks <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>uncachedChecks<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>PermissionCheck<span class="token punctuation">{</span></span>
<span class="line">                Action<span class="token punctuation">:</span>   check<span class="token punctuation">.</span>Action<span class="token punctuation">,</span></span>
<span class="line">                Resource<span class="token punctuation">:</span> check<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span></span>
<span class="line">                Context<span class="token punctuation">:</span>  check<span class="token punctuation">.</span>Context<span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">            uncachedKeys <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>uncachedKeys<span class="token punctuation">,</span> key<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 批量检查未缓存的权限</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>uncachedChecks<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        batchResults<span class="token punctuation">,</span> err <span class="token operator">:=</span> pc<span class="token punctuation">.</span><span class="token function">CheckPermissions</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> uncachedChecks<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 缓存结果</span></span>
<span class="line">        <span class="token keyword">for</span> i<span class="token punctuation">,</span> result <span class="token operator">:=</span> <span class="token keyword">range</span> batchResults <span class="token punctuation">{</span></span>
<span class="line">            key <span class="token operator">:=</span> uncachedKeys<span class="token punctuation">[</span>i<span class="token punctuation">]</span></span>
<span class="line">            results<span class="token punctuation">[</span>key<span class="token punctuation">]</span> <span class="token operator">=</span> result<span class="token punctuation">.</span>Allowed</span>
<span class="line">            pc<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Allowed<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> results<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-权限策略设计" tabindex="-1"><a class="header-anchor" href="#_2-权限策略设计">#</a> 2. 权限策略设计</h3>
<h4 id="最小权限原则" tabindex="-1"><a class="header-anchor" href="#最小权限原则">#</a> 最小权限原则</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"s3:GetObject"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"arn:aws:s3:::my-bucket/users/${aws:username}/*"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"StringEquals"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"s3:ExistingObjectTag/Owner"</span><span class="token operator">:</span> <span class="token string">"${aws:username}"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="时间限制策略" tabindex="-1"><a class="header-anchor" href="#时间限制策略">#</a> 时间限制策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:*"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"DateGreaterThan"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:CurrentTime"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"DateLessThan"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:CurrentTime"</span><span class="token operator">:</span> <span class="token string">"2024-12-31T23:59:59Z"</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"IpAddress"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:SourceIp"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"192.168.1.0/24"</span><span class="token punctuation">,</span> <span class="token string">"10.0.0.0/8"</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-错误处理和监控" tabindex="-1"><a class="header-anchor" href="#_3-错误处理和监控">#</a> 3. 错误处理和监控</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 权限检查监控</span></span>
<span class="line"><span class="token keyword">type</span> PermissionMetrics <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    totalChecks    <span class="token builtin">int64</span></span>
<span class="line">    allowedChecks  <span class="token builtin">int64</span></span>
<span class="line">    deniedChecks   <span class="token builtin">int64</span></span>
<span class="line">    errorChecks    <span class="token builtin">int64</span></span>
<span class="line">    cacheHits      <span class="token builtin">int64</span></span>
<span class="line">    cacheMisses    <span class="token builtin">int64</span></span>
<span class="line">    avgLatency     time<span class="token punctuation">.</span>Duration</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">CheckPermissionWithMetrics</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        pc<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span>avgLatency <span class="token operator">=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">        atomic<span class="token punctuation">.</span><span class="token function">AddInt64</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>pc<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span>totalChecks<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 检查权限</span></span>
<span class="line">    allowed<span class="token punctuation">,</span> err <span class="token operator">:=</span> pc<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        atomic<span class="token punctuation">.</span><span class="token function">AddInt64</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>pc<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span>errorChecks<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token comment">// 记录错误日志</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"权限检查错误: 用户=%s, 操作=%s, 资源=%s, 错误=%v"</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> allowed <span class="token punctuation">{</span></span>
<span class="line">        atomic<span class="token punctuation">.</span><span class="token function">AddInt64</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>pc<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span>allowedChecks<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">        atomic<span class="token punctuation">.</span><span class="token function">AddInt64</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>pc<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span>deniedChecks<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token comment">// 记录权限拒绝日志</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"权限拒绝: 用户=%s, 操作=%s, 资源=%s"</span><span class="token punctuation">,</span> userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> allowed<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限审计日志</span></span>
<span class="line"><span class="token keyword">type</span> PermissionAuditLog <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Timestamp    time<span class="token punctuation">.</span>Time <span class="token string">`json:"timestamp"`</span></span>
<span class="line">    UserName     <span class="token builtin">string</span>    <span class="token string">`json:"user_name"`</span></span>
<span class="line">    Action       <span class="token builtin">string</span>    <span class="token string">`json:"action"`</span></span>
<span class="line">    Resource     <span class="token builtin">string</span>    <span class="token string">`json:"resource"`</span></span>
<span class="line">    Allowed      <span class="token builtin">bool</span>      <span class="token string">`json:"allowed"`</span></span>
<span class="line">    Decision     <span class="token builtin">string</span>    <span class="token string">`json:"decision"`</span></span>
<span class="line">    Policies     <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span>  <span class="token string">`json:"policies"`</span></span>
<span class="line">    Reason       <span class="token builtin">string</span>    <span class="token string">`json:"reason"`</span></span>
<span class="line">    Context      <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"context"`</span></span>
<span class="line">    SourceIP     <span class="token builtin">string</span>    <span class="token string">`json:"source_ip"`</span></span>
<span class="line">    UserAgent    <span class="token builtin">string</span>    <span class="token string">`json:"user_agent"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>pc <span class="token operator">*</span>PermissionChecker<span class="token punctuation">)</span> <span class="token function">AuditPermissionCheck</span><span class="token punctuation">(</span>userName<span class="token punctuation">,</span> action<span class="token punctuation">,</span> resource <span class="token builtin">string</span><span class="token punctuation">,</span> result <span class="token operator">*</span>iamv1<span class="token punctuation">.</span>CheckPermissionResponse<span class="token punctuation">,</span> context <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    auditLog <span class="token operator">:=</span> PermissionAuditLog<span class="token punctuation">{</span></span>
<span class="line">        Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>  userName<span class="token punctuation">,</span></span>
<span class="line">        Action<span class="token punctuation">:</span>    action<span class="token punctuation">,</span></span>
<span class="line">        Resource<span class="token punctuation">:</span>  resource<span class="token punctuation">,</span></span>
<span class="line">        Allowed<span class="token punctuation">:</span>   result<span class="token punctuation">.</span>Allowed<span class="token punctuation">,</span></span>
<span class="line">        Decision<span class="token punctuation">:</span>  result<span class="token punctuation">.</span>Decision<span class="token punctuation">,</span></span>
<span class="line">        Policies<span class="token punctuation">:</span>  result<span class="token punctuation">.</span>MatchedPolicies<span class="token punctuation">,</span></span>
<span class="line">        Reason<span class="token punctuation">:</span>    result<span class="token punctuation">.</span>Reason<span class="token punctuation">,</span></span>
<span class="line">        Context<span class="token punctuation">:</span>   context<span class="token punctuation">,</span></span>
<span class="line">        SourceIP<span class="token punctuation">:</span>  context<span class="token punctuation">[</span><span class="token string">"aws:SourceIp"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        UserAgent<span class="token punctuation">:</span> context<span class="token punctuation">[</span><span class="token string">"http:UserAgent"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 发送到审计日志系统</span></span>
<span class="line">    pc<span class="token punctuation">.</span>auditLogger<span class="token punctuation">.</span><span class="token function">Log</span><span class="token punctuation">(</span>auditLog<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-注意事项" tabindex="-1"><a class="header-anchor" href="#🚨-注意事项">#</a> 🚨 注意事项</h2>
<h3 id="安全考虑" tabindex="-1"><a class="header-anchor" href="#安全考虑">#</a> 安全考虑</h3>
<ol>
<li>
<p><strong>权限检查不能绕过</strong>：</p>
<ul>
<li>在所有关键操作前进行权限检查</li>
<li>不要依赖客户端的权限验证</li>
<li>使用白名单而非黑名单</li>
</ul>
</li>
<li>
<p><strong>上下文信息验证</strong>：</p>
<ul>
<li>验证IP地址、时间等上下文信息</li>
<li>防止上下文信息被伪造</li>
<li>记录详细的审计日志</li>
</ul>
</li>
<li>
<p><strong>权限提升防护</strong>：</p>
<ul>
<li>防止权限提升攻击</li>
<li>定期审查权限分配</li>
<li>监控异常权限使用</li>
</ul>
</li>
</ol>
<h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<ol>
<li>
<p><strong>缓存策略</strong>：</p>
<ul>
<li>合理设置缓存TTL</li>
<li>监控缓存命中率</li>
<li>及时清理过期缓存</li>
</ul>
</li>
<li>
<p><strong>批量操作</strong>：</p>
<ul>
<li>尽量使用批量权限检查</li>
<li>避免循环调用单个权限检查</li>
<li>合理控制批量大小</li>
</ul>
</li>
<li>
<p><strong>异步处理</strong>：</p>
<ul>
<li>对于非关键路径，考虑异步权限检查</li>
<li>使用权限预检查机制</li>
<li>实现权限检查的降级策略</li>
</ul>
</li>
</ol>
<h3 id="监控和运维" tabindex="-1"><a class="header-anchor" href="#监控和运维">#</a> 监控和运维</h3>
<ol>
<li>
<p><strong>指标监控</strong>：</p>
<ul>
<li>监控权限检查成功率</li>
<li>监控权限检查延迟</li>
<li>监控权限拒绝率</li>
</ul>
</li>
<li>
<p><strong>告警设置</strong>：</p>
<ul>
<li>设置权限检查失败告警</li>
<li>设置异常权限使用告警</li>
<li>设置权限策略变更告警</li>
</ul>
</li>
<li>
<p><strong>审计合规</strong>：</p>
<ul>
<li>保留完整的权限审计日志</li>
<li>定期进行权限审计</li>
<li>满足合规要求</li>
</ul>
</li>
</ol>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>权限检查是安全的最后一道防线，建议在应用的多个层次都进行权限验证。</p>
</div>
<h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/api/policy-management.html">策略管理 API</RouteLink> - 了解如何创建和管理权限策略</li>
<li><RouteLink to="/api/user-management.html">用户管理 API</RouteLink> - 了解如何管理用户和绑定策略</li>
<li><RouteLink to="/api/access-keys.html">访问密钥 API</RouteLink> - 了解如何管理API访问密钥</li>
<li><RouteLink to="/guide/">快速开始指南</RouteLink> - 快速上手VGO微服务</li>
<li><RouteLink to="/guide/configuration.html">配置指南</RouteLink> - 了解系统配置选项</li>
</ul>
</div></template>


