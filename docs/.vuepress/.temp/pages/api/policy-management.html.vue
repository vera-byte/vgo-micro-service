<template><div><h1 id="策略管理-api" tabindex="-1"><a class="header-anchor" href="#策略管理-api">#</a> 策略管理 API</h1>
<p>策略管理API提供了完整的权限策略生命周期管理功能，包括策略的创建、查询、更新、删除以及策略与用户的绑定关系管理。</p>
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
<td><code v-pre>CreatePolicy</code></td>
<td>创建新策略</td>
<td><code v-pre>iam:CreatePolicy</code></td>
</tr>
<tr>
<td><code v-pre>GetPolicy</code></td>
<td>获取策略信息</td>
<td><code v-pre>iam:GetPolicy</code></td>
</tr>
<tr>
<td><code v-pre>UpdatePolicy</code></td>
<td>更新策略信息</td>
<td><code v-pre>iam:UpdatePolicy</code></td>
</tr>
<tr>
<td><code v-pre>DeletePolicy</code></td>
<td>删除策略</td>
<td><code v-pre>iam:DeletePolicy</code></td>
</tr>
<tr>
<td><code v-pre>ListPolicies</code></td>
<td>获取策略列表</td>
<td><code v-pre>iam:ListPolicies</code></td>
</tr>
<tr>
<td><code v-pre>AttachUserPolicy</code></td>
<td>绑定策略到用户</td>
<td><code v-pre>iam:AttachUserPolicy</code></td>
</tr>
<tr>
<td><code v-pre>DetachUserPolicy</code></td>
<td>解绑用户策略</td>
<td><code v-pre>iam:DetachUserPolicy</code></td>
</tr>
</tbody>
</table>
<h2 id="🔧-api-详情" tabindex="-1"><a class="header-anchor" href="#🔧-api-详情">#</a> 🔧 API 详情</h2>
<h3 id="createpolicy-创建策略" tabindex="-1"><a class="header-anchor" href="#createpolicy-创建策略">#</a> CreatePolicy - 创建策略</h3>
<p>创建一个新的权限策略。</p>
<h4 id="请求" tabindex="-1"><a class="header-anchor" href="#请求">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreatePolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 策略名称（必需，唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>       <span class="token comment">// 策略描述（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> policy_document <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>   <span class="token comment">// 策略文档JSON（必需）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> tags <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>     <span class="token comment">// 策略标签（可选）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应" tabindex="-1"><a class="header-anchor" href="#响应">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">CreatePolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Policy</span> policy <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>            <span class="token comment">// 创建的策略信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例" tabindex="-1"><a class="header-anchor" href="#示例">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建只读策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "ReadOnlyPolicy",</span>
<span class="line">  "description": "只读权限策略",</span>
<span class="line">  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}",</span>
<span class="line">  "tags": ["readonly", "basic"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建管理员策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "AdminPolicy",</span>
<span class="line">  "description": "管理员完全权限策略",</span>
<span class="line">  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"*\"],\"Resource\":[\"*\"]}]}",</span>
<span class="line">  "tags": ["admin", "full-access"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例" tabindex="-1"><a class="header-anchor" href="#响应示例">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"policy"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"pol-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"只读权限策略"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"policy_document"</span><span class="token operator">:</span> <span class="token string">"{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"tags"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"readonly"</span><span class="token punctuation">,</span> <span class="token string">"basic"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
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
<td>策略名称为空或策略文档格式错误</td>
<td>提供有效的策略名称和JSON文档</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>策略名称已存在</td>
<td>使用不同的策略名称</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无创建策略权限</td>
<td>确保有<code v-pre>iam:CreatePolicy</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="getpolicy-获取策略信息" tabindex="-1"><a class="header-anchor" href="#getpolicy-获取策略信息">#</a> GetPolicy - 获取策略信息</h3>
<p>根据策略名称或策略ID获取策略详细信息。</p>
<h4 id="请求-1" tabindex="-1"><a class="header-anchor" href="#请求-1">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetPolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>    <span class="token comment">// 策略名称</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 策略ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-1" tabindex="-1"><a class="header-anchor" href="#响应-1">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">GetPolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Policy</span> policy <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>        <span class="token comment">// 策略信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-1" tabindex="-1"><a class="header-anchor" href="#示例-1">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过策略名称获取</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 通过策略ID获取</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "pol-123456"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/GetPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-1" tabindex="-1"><a class="header-anchor" href="#响应示例-1">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"policy"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"pol-123456"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"只读权限策略"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"policy_document"</span><span class="token operator">:</span> <span class="token string">"{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\"],\"Resource\":[\"*\"]}]}"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"tags"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"readonly"</span><span class="token punctuation">,</span> <span class="token string">"basic"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"attached_users_count"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><hr>
<h3 id="updatepolicy-更新策略信息" tabindex="-1"><a class="header-anchor" href="#updatepolicy-更新策略信息">#</a> UpdatePolicy - 更新策略信息</h3>
<p>更新现有策略的信息。</p>
<h4 id="请求-2" tabindex="-1"><a class="header-anchor" href="#请求-2">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdatePolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 策略名称</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                <span class="token comment">// 策略ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>         <span class="token comment">// 新的描述（可选）</span></span>
<span class="line">  <span class="token builtin">string</span> policy_document <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>     <span class="token comment">// 新的策略文档（可选）</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> tags <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>       <span class="token comment">// 新的标签（可选）</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>FieldMask</span> update_mask <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>  <span class="token comment">// 更新字段掩码</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-2" tabindex="-1"><a class="header-anchor" href="#响应-2">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">UpdatePolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token positional-class-name class-name">Policy</span> policy <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>              <span class="token comment">// 更新后的策略信息</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-2" tabindex="-1"><a class="header-anchor" href="#示例-2">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新策略描述</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "ReadOnlyPolicy",</span>
<span class="line">  "description": "更新后的只读权限策略描述",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["description"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新策略文档</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "pol-123456",</span>
<span class="line">  "policy_document": "{\"Version\":\"2025-01-01\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"iam:GetUser\",\"iam:ListUsers\",\"iam:GetPolicy\",\"iam:ListPolicies\",\"iam:GetApplication\"],\"Resource\":[\"*\"]}]}",</span>
<span class="line">  "update_mask": {</span>
<span class="line">    "paths": ["policy_document"]</span>
<span class="line">  }</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/UpdatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-1" tabindex="-1"><a class="header-anchor" href="#错误情况-1">#</a> 错误情况</h4>
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
<td>无效的策略文档格式</td>
<td>检查JSON语法和策略结构</td>
</tr>
<tr>
<td><code v-pre>NOT_FOUND</code></td>
<td>策略不存在</td>
<td>确认策略标识符正确</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无更新策略权限</td>
<td>确保有<code v-pre>iam:UpdatePolicy</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="deletepolicy-删除策略" tabindex="-1"><a class="header-anchor" href="#deletepolicy-删除策略">#</a> DeletePolicy - 删除策略</h3>
<p>删除指定的策略。</p>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>删除策略前会自动解绑所有关联的用户。</p>
</div>
<h4 id="请求-3" tabindex="-1"><a class="header-anchor" href="#请求-3">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeletePolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token keyword">oneof</span> identifier <span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>    <span class="token comment">// 策略名称</span></span>
<span class="line">    <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>      <span class="token comment">// 策略ID</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line">  <span class="token builtin">bool</span> force <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>       <span class="token comment">// 强制删除（即使有用户绑定）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-3" tabindex="-1"><a class="header-anchor" href="#响应-3">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DeletePolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-3" tabindex="-1"><a class="header-anchor" href="#示例-3">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 删除策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeletePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 强制删除策略（自动解绑用户）</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "id": "pol-123456",</span>
<span class="line">  "force": true</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeletePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><hr>
<h3 id="listpolicies-获取策略列表" tabindex="-1"><a class="header-anchor" href="#listpolicies-获取策略列表">#</a> ListPolicies - 获取策略列表</h3>
<p>获取系统中的策略列表，支持分页和过滤。</p>
<h4 id="请求-4" tabindex="-1"><a class="header-anchor" href="#请求-4">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">ListPoliciesRequest</span> <span class="token punctuation">{</span></span>
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
<li><code v-pre>name</code>: 策略名称（支持模糊匹配）</li>
<li><code v-pre>description</code>: 策略描述（支持模糊匹配）</li>
<li><code v-pre>tags</code>: 策略标签</li>
<li><code v-pre>created_after</code>: 创建时间之后</li>
<li><code v-pre>created_before</code>: 创建时间之前</li>
</ul>
<h4 id="示例-4" tabindex="-1"><a class="header-anchor" href="#示例-4">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取所有策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 20</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListPolicies</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 按标签过滤</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 10,</span>
<span class="line">  "filter": "tags CONTAINS readonly"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListPolicies</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应示例-2" tabindex="-1"><a class="header-anchor" href="#响应示例-2">#</a> 响应示例</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"policies"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"id"</span><span class="token operator">:</span> <span class="token string">"pol-123456"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"ReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"description"</span><span class="token operator">:</span> <span class="token string">"只读权限策略"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"tags"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"readonly"</span><span class="token punctuation">,</span> <span class="token string">"basic"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"created_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"updated_at"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"attached_users_count"</span><span class="token operator">:</span> <span class="token number">5</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"pagination"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"page"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"page_size"</span><span class="token operator">:</span> <span class="token number">20</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_count"</span><span class="token operator">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"total_pages"</span><span class="token operator">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><hr>
<h3 id="attachuserpolicy-绑定策略到用户" tabindex="-1"><a class="header-anchor" href="#attachuserpolicy-绑定策略到用户">#</a> AttachUserPolicy - 绑定策略到用户</h3>
<p>将策略绑定到指定用户。</p>
<h4 id="请求-5" tabindex="-1"><a class="header-anchor" href="#请求-5">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">AttachUserPolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> policy_name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>   <span class="token comment">// 策略名称（必需）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-4" tabindex="-1"><a class="header-anchor" href="#响应-4">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">AttachUserPolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-5" tabindex="-1"><a class="header-anchor" href="#示例-5">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 绑定只读策略到用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "policy_name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/AttachUserPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 绑定管理员策略到用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "admin_user",</span>
<span class="line">  "policy_name": "AdminPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/AttachUserPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-2" tabindex="-1"><a class="header-anchor" href="#错误情况-2">#</a> 错误情况</h4>
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
<td>确认用户名和策略名正确</td>
</tr>
<tr>
<td><code v-pre>ALREADY_EXISTS</code></td>
<td>策略已绑定到用户</td>
<td>无需重复绑定</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无绑定策略权限</td>
<td>确保有<code v-pre>iam:AttachUserPolicy</code>权限</td>
</tr>
</tbody>
</table>
<hr>
<h3 id="detachuserpolicy-解绑用户策略" tabindex="-1"><a class="header-anchor" href="#detachuserpolicy-解绑用户策略">#</a> DetachUserPolicy - 解绑用户策略</h3>
<p>从用户解绑指定策略。</p>
<h4 id="请求-6" tabindex="-1"><a class="header-anchor" href="#请求-6">#</a> 请求</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DetachUserPolicyRequest</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> user_name <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>     <span class="token comment">// 用户名（必需）</span></span>
<span class="line">  <span class="token builtin">string</span> policy_name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>   <span class="token comment">// 策略名称（必需）</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="响应-5" tabindex="-1"><a class="header-anchor" href="#响应-5">#</a> 响应</h4>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">DetachUserPolicyResponse</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token comment">// 空响应，成功时无返回内容</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="示例-6" tabindex="-1"><a class="header-anchor" href="#示例-6">#</a> 示例</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 解绑用户策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "john_doe",</span>
<span class="line">  "policy_name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DetachUserPolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误情况-3" tabindex="-1"><a class="header-anchor" href="#错误情况-3">#</a> 错误情况</h4>
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
<td>用户、策略不存在或未绑定</td>
<td>确认绑定关系存在</td>
</tr>
<tr>
<td><code v-pre>PERMISSION_DENIED</code></td>
<td>无解绑策略权限</td>
<td>确保有<code v-pre>iam:DetachUserPolicy</code>权限</td>
</tr>
</tbody>
</table>
<h2 id="📊-数据模型" tabindex="-1"><a class="header-anchor" href="#📊-数据模型">#</a> 📊 数据模型</h2>
<h3 id="policy-对象" tabindex="-1"><a class="header-anchor" href="#policy-对象">#</a> Policy 对象</h3>
<div class="language-protobuf line-numbers-mode" data-highlighter="prismjs" data-ext="protobuf"><pre v-pre><code class="language-protobuf"><span class="line"><span class="token keyword">message</span> <span class="token class-name">Policy</span> <span class="token punctuation">{</span></span>
<span class="line">  <span class="token builtin">string</span> id <span class="token operator">=</span> <span class="token number">1</span><span class="token punctuation">;</span>                    <span class="token comment">// 策略ID（系统生成）</span></span>
<span class="line">  <span class="token builtin">string</span> name <span class="token operator">=</span> <span class="token number">2</span><span class="token punctuation">;</span>                  <span class="token comment">// 策略名称（唯一）</span></span>
<span class="line">  <span class="token builtin">string</span> description <span class="token operator">=</span> <span class="token number">3</span><span class="token punctuation">;</span>           <span class="token comment">// 策略描述</span></span>
<span class="line">  <span class="token builtin">string</span> policy_document <span class="token operator">=</span> <span class="token number">4</span><span class="token punctuation">;</span>       <span class="token comment">// 策略文档JSON</span></span>
<span class="line">  <span class="token keyword">repeated</span> <span class="token builtin">string</span> tags <span class="token operator">=</span> <span class="token number">5</span><span class="token punctuation">;</span>         <span class="token comment">// 策略标签</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> created_at <span class="token operator">=</span> <span class="token number">6</span><span class="token punctuation">;</span>     <span class="token comment">// 创建时间</span></span>
<span class="line">  <span class="token positional-class-name class-name">google<span class="token punctuation">.</span>protobuf<span class="token punctuation">.</span>Timestamp</span> updated_at <span class="token operator">=</span> <span class="token number">7</span><span class="token punctuation">;</span>     <span class="token comment">// 更新时间</span></span>
<span class="line">  <span class="token builtin">int32</span> attached_users_count <span class="token operator">=</span> <span class="token number">8</span><span class="token punctuation">;</span>   <span class="token comment">// 绑定用户数量</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-策略文档语法" tabindex="-1"><a class="header-anchor" href="#🔐-策略文档语法">#</a> 🔐 策略文档语法</h2>
<h3 id="基本结构" tabindex="-1"><a class="header-anchor" href="#基本结构">#</a> 基本结构</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:ListUsers"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"*"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"StringEquals"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:RequestedRegion"</span><span class="token operator">:</span> <span class="token string">"us-east-1"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="字段说明" tabindex="-1"><a class="header-anchor" href="#字段说明">#</a> 字段说明</h3>
<h4 id="version" tabindex="-1"><a class="header-anchor" href="#version">#</a> Version</h4>
<p>策略语言版本，当前支持 <code v-pre>&quot;2025-01-01&quot;</code>。</p>
<h4 id="statement" tabindex="-1"><a class="header-anchor" href="#statement">#</a> Statement</h4>
<p>权限声明数组，每个声明包含以下字段：</p>
<ul>
<li>
<p><strong>Effect</strong>: 权限效果</p>
<ul>
<li><code v-pre>&quot;Allow&quot;</code>: 允许</li>
<li><code v-pre>&quot;Deny&quot;</code>: 拒绝</li>
</ul>
</li>
<li>
<p><strong>Action</strong>: 操作列表</p>
<ul>
<li>支持通配符 <code v-pre>*</code></li>
<li>支持前缀匹配 <code v-pre>iam:*</code></li>
<li>具体操作 <code v-pre>iam:GetUser</code></li>
</ul>
</li>
<li>
<p><strong>Resource</strong>: 资源列表</p>
<ul>
<li>支持通配符 <code v-pre>*</code></li>
<li>ARN格式 <code v-pre>arn:iam::user/john_doe</code></li>
<li>变量替换 <code v-pre>arn:iam::user/${aws:username}</code></li>
</ul>
</li>
<li>
<p><strong>Condition</strong>: 条件约束（可选）</p>
<ul>
<li>支持多种条件操作符</li>
<li>支持上下文变量</li>
</ul>
</li>
</ul>
<h3 id="常用策略模板" tabindex="-1"><a class="header-anchor" href="#常用策略模板">#</a> 常用策略模板</h3>
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
<span class="line">        <span class="token string">"iam:Get*"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"iam:List*"</span></span>
<span class="line">      <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-用户自管理策略" tabindex="-1"><a class="header-anchor" href="#_3-用户自管理策略">#</a> 3. 用户自管理策略</h4>
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
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"StringEquals"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"iam:ApplicationOwner"</span><span class="token operator">:</span> <span class="token string">"${aws:username}"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_5-时间限制策略" tabindex="-1"><a class="header-anchor" href="#_5-时间限制策略">#</a> 5. 时间限制策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token string">"iam:*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"DateGreaterThan"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:CurrentTime"</span><span class="token operator">:</span> <span class="token string">"2024-01-01T00:00:00Z"</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"DateLessThan"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:CurrentTime"</span><span class="token operator">:</span> <span class="token string">"2024-12-31T23:59:59Z"</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_6-ip限制策略" tabindex="-1"><a class="header-anchor" href="#_6-ip限制策略">#</a> 6. IP限制策略</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"Version"</span><span class="token operator">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">  <span class="token property">"Statement"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">    <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"Effect"</span><span class="token operator">:</span> <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Action"</span><span class="token operator">:</span> <span class="token string">"iam:*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Resource"</span><span class="token operator">:</span> <span class="token string">"*"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"Condition"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"IpAddress"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"aws:SourceIp"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">            <span class="token string">"192.168.1.0/24"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"10.0.0.0/8"</span></span>
<span class="line">          <span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">  <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="条件操作符" tabindex="-1"><a class="header-anchor" href="#条件操作符">#</a> 条件操作符</h3>
<table>
<thead>
<tr>
<th>操作符</th>
<th>说明</th>
<th>示例</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>StringEquals</code></td>
<td>字符串相等</td>
<td><code v-pre>&quot;aws:username&quot;: &quot;john&quot;</code></td>
</tr>
<tr>
<td><code v-pre>StringLike</code></td>
<td>字符串模式匹配</td>
<td><code v-pre>&quot;aws:userid&quot;: &quot;user-*&quot;</code></td>
</tr>
<tr>
<td><code v-pre>NumericEquals</code></td>
<td>数值相等</td>
<td><code v-pre>&quot;aws:TokenIssueTime&quot;: &quot;1234567890&quot;</code></td>
</tr>
<tr>
<td><code v-pre>NumericLessThan</code></td>
<td>数值小于</td>
<td><code v-pre>&quot;aws:MultiFactorAuthAge&quot;: &quot;3600&quot;</code></td>
</tr>
<tr>
<td><code v-pre>DateGreaterThan</code></td>
<td>日期大于</td>
<td><code v-pre>&quot;aws:CurrentTime&quot;: &quot;2024-01-01T00:00:00Z&quot;</code></td>
</tr>
<tr>
<td><code v-pre>DateLessThan</code></td>
<td>日期小于</td>
<td><code v-pre>&quot;aws:CurrentTime&quot;: &quot;2024-12-31T23:59:59Z&quot;</code></td>
</tr>
<tr>
<td><code v-pre>IpAddress</code></td>
<td>IP地址匹配</td>
<td><code v-pre>&quot;aws:SourceIp&quot;: &quot;192.168.1.0/24&quot;</code></td>
</tr>
<tr>
<td><code v-pre>Bool</code></td>
<td>布尔值</td>
<td><code v-pre>&quot;aws:SecureTransport&quot;: &quot;true&quot;</code></td>
</tr>
</tbody>
</table>
<h3 id="上下文变量" tabindex="-1"><a class="header-anchor" href="#上下文变量">#</a> 上下文变量</h3>
<table>
<thead>
<tr>
<th>变量</th>
<th>说明</th>
<th>示例值</th>
</tr>
</thead>
<tbody>
<tr>
<td><code v-pre>${aws:username}</code></td>
<td>当前用户名</td>
<td><code v-pre>john_doe</code></td>
</tr>
<tr>
<td><code v-pre>${aws:userid}</code></td>
<td>当前用户ID</td>
<td><code v-pre>user-123456</code></td>
</tr>
<tr>
<td><code v-pre>${aws:SourceIp}</code></td>
<td>请求来源IP</td>
<td><code v-pre>192.168.1.100</code></td>
</tr>
<tr>
<td><code v-pre>${aws:CurrentTime}</code></td>
<td>当前时间</td>
<td><code v-pre>2024-01-01T12:00:00Z</code></td>
</tr>
<tr>
<td><code v-pre>${aws:SecureTransport}</code></td>
<td>是否使用HTTPS</td>
<td><code v-pre>true</code></td>
</tr>
<tr>
<td><code v-pre>${aws:RequestedRegion}</code></td>
<td>请求区域</td>
<td><code v-pre>us-east-1</code></td>
</tr>
</tbody>
</table>
<h2 id="🛠️-使用示例" tabindex="-1"><a class="header-anchor" href="#🛠️-使用示例">#</a> 🛠️ 使用示例</h2>
<h3 id="go-客户端示例" tabindex="-1"><a class="header-anchor" href="#go-客户端示例">#</a> Go 客户端示例</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> main</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"encoding/json"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"log"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/credentials/insecure"</span></span>
<span class="line">    </span>
<span class="line">    iamv1 <span class="token string">"github.com/your-org/vgo/api/iam/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> PolicyDocument <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Version   <span class="token builtin">string</span>      <span class="token string">`json:"Version"`</span></span>
<span class="line">    Statement <span class="token punctuation">[</span><span class="token punctuation">]</span>Statement <span class="token string">`json:"Statement"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Statement <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Effect   <span class="token builtin">string</span>   <span class="token string">`json:"Effect"`</span></span>
<span class="line">    Action   <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"Action"`</span></span>
<span class="line">    Resource <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"Resource"`</span></span>
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
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建策略文档</span></span>
<span class="line">    policyDoc <span class="token operator">:=</span> PolicyDocument<span class="token punctuation">{</span></span>
<span class="line">        Version<span class="token punctuation">:</span> <span class="token string">"2025-01-01"</span><span class="token punctuation">,</span></span>
<span class="line">        Statement<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span>Statement<span class="token punctuation">{</span></span>
<span class="line">            <span class="token punctuation">{</span></span>
<span class="line">                Effect<span class="token punctuation">:</span>   <span class="token string">"Allow"</span><span class="token punctuation">,</span></span>
<span class="line">                Action<span class="token punctuation">:</span>   <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"iam:GetUser"</span><span class="token punctuation">,</span> <span class="token string">"iam:ListUsers"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                Resource<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"*"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    policyJSON<span class="token punctuation">,</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>policyDoc<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"序列化策略文档失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建策略</span></span>
<span class="line">    createResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">CreatePolicy</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>CreatePolicyRequest<span class="token punctuation">{</span></span>
<span class="line">        Name<span class="token punctuation">:</span>           <span class="token string">"TestReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">        Description<span class="token punctuation">:</span>    <span class="token string">"测试只读策略"</span><span class="token punctuation">,</span></span>
<span class="line">        PolicyDocument<span class="token punctuation">:</span> <span class="token function">string</span><span class="token punctuation">(</span>policyJSON<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        Tags<span class="token punctuation">:</span>           <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"test"</span><span class="token punctuation">,</span> <span class="token string">"readonly"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"创建策略失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"策略创建成功: %v\n"</span><span class="token punctuation">,</span> createResp<span class="token punctuation">.</span>Policy<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 绑定策略到用户</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">AttachUserPolicy</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>AttachUserPolicyRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>   <span class="token string">"test_user"</span><span class="token punctuation">,</span></span>
<span class="line">        PolicyName<span class="token punctuation">:</span> <span class="token string">"TestReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"绑定策略失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"策略绑定成功"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 获取策略列表</span></span>
<span class="line">    listResp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">ListPolicies</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>ListPoliciesRequest<span class="token punctuation">{</span></span>
<span class="line">        Page<span class="token punctuation">:</span>     <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        PageSize<span class="token punctuation">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">        Filter<span class="token punctuation">:</span>   <span class="token string">"tags CONTAINS test"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"获取策略列表失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"策略列表: %v\n"</span><span class="token punctuation">,</span> listResp<span class="token punctuation">.</span>Policies<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 解绑策略</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DetachUserPolicy</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DetachUserPolicyRequest<span class="token punctuation">{</span></span>
<span class="line">        UserName<span class="token punctuation">:</span>   <span class="token string">"test_user"</span><span class="token punctuation">,</span></span>
<span class="line">        PolicyName<span class="token punctuation">:</span> <span class="token string">"TestReadOnlyPolicy"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"解绑策略失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"策略解绑成功"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 删除策略</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> client<span class="token punctuation">.</span><span class="token function">DeletePolicy</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeletePolicyRequest<span class="token punctuation">{</span></span>
<span class="line">        Identifier<span class="token punctuation">:</span> <span class="token operator">&amp;</span>iamv1<span class="token punctuation">.</span>DeletePolicyRequest_Name<span class="token punctuation">{</span>Name<span class="token punctuation">:</span> <span class="token string">"TestReadOnlyPolicy"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        log<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"删除策略失败: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    fmt<span class="token punctuation">.</span><span class="token function">Println</span><span class="token punctuation">(</span><span class="token string">"策略删除成功"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="批量策略管理脚本" tabindex="-1"><a class="header-anchor" href="#批量策略管理脚本">#</a> 批量策略管理脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量创建策略脚本</span></span>
<span class="line"><span class="token assign-left variable">POLICIES_DIR</span><span class="token operator">=</span><span class="token string">"policies"</span></span>
<span class="line"><span class="token assign-left variable">SERVER</span><span class="token operator">=</span><span class="token string">"localhost:50051"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建策略目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token string">"<span class="token variable">$POLICIES_DIR</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建只读策略文件</span></span>
<span class="line"><span class="token function">cat</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$POLICIES_DIR</span>/readonly.json"</span> <span class="token operator">&lt;&lt;</span> <span class="token string">'EOF'</span>
<span class="line">{</span>
<span class="line">  "Version": "2025-01-01",</span>
<span class="line">  "Statement": [</span>
<span class="line">    {</span>
<span class="line">      "Effect": "Allow",</span>
<span class="line">      "Action": [</span>
<span class="line">        "iam:Get*",</span>
<span class="line">        "iam:List*"</span>
<span class="line">      ],</span>
<span class="line">      "Resource": "*"</span>
<span class="line">    }</span>
<span class="line">  ]</span>
<span class="line">}</span>
<span class="line">EOF</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建用户管理策略文件</span></span>
<span class="line"><span class="token function">cat</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$POLICIES_DIR</span>/user-management.json"</span> <span class="token operator">&lt;&lt;</span> <span class="token string">'EOF'</span>
<span class="line">{</span>
<span class="line">  "Version": "2025-01-01",</span>
<span class="line">  "Statement": [</span>
<span class="line">    {</span>
<span class="line">      "Effect": "Allow",</span>
<span class="line">      "Action": [</span>
<span class="line">        "iam:CreateUser",</span>
<span class="line">        "iam:GetUser",</span>
<span class="line">        "iam:UpdateUser",</span>
<span class="line">        "iam:DeleteUser",</span>
<span class="line">        "iam:ListUsers"</span>
<span class="line">      ],</span>
<span class="line">      "Resource": "*"</span>
<span class="line">    }</span>
<span class="line">  ]</span>
<span class="line">}</span>
<span class="line">EOF</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 批量创建策略</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">policy_file</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">$POLICIES_DIR</span>"</span>/*.json<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token assign-left variable">policy_name</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">basename</span> <span class="token string">"<span class="token variable">$policy_file</span>"</span> .json<span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">policy_content</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">cat</span> <span class="token string">"<span class="token variable">$policy_file</span>"</span> <span class="token operator">|</span> jq <span class="token parameter variable">-c</span> <span class="token builtin class-name">.</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"创建策略: <span class="token variable">$policy_name</span>"</span></span>
<span class="line">    grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">"{</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>name<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable">${policy_name}</span><span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>description<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span>从文件 <span class="token variable">${policy_file}</span> 创建的策略<span class="token entity" title="\&quot;">\"</span>,</span>
<span class="line">        <span class="token entity" title="\&quot;">\"</span>policy_document<span class="token entity" title="\&quot;">\"</span>: <span class="token entity" title="\&quot;">\"</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> $policy_content <span class="token operator">|</span> <span class="token function">sed</span> <span class="token string">'s/"/\\"/g'</span><span class="token variable">)</span></span><span class="token entity" title="\&quot;">\"</span></span>
<span class="line">    }"</span> <span class="token string">"<span class="token variable">$SERVER</span>"</span> iam.v1.IAM/CreatePolicy</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$?</span> <span class="token parameter variable">-eq</span> <span class="token number">0</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"策略 <span class="token variable">$policy_name</span> 创建成功"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"策略 <span class="token variable">$policy_name</span> 创建失败"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line">    </span>
<span class="line">    <span class="token function">sleep</span> <span class="token number">0.1</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"批量策略创建完成"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="策略验证工具" tabindex="-1"><a class="header-anchor" href="#策略验证工具">#</a> 策略验证工具</h3>
<div class="language-python line-numbers-mode" data-highlighter="prismjs" data-ext="py"><pre v-pre><code class="language-python"><span class="line"><span class="token keyword">import</span> json</span>
<span class="line"><span class="token keyword">import</span> jsonschema</span>
<span class="line"><span class="token keyword">from</span> jsonschema <span class="token keyword">import</span> validate</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 策略文档JSON Schema</span></span>
<span class="line">policy_schema <span class="token operator">=</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"object"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"properties"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"Version"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"enum"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"2025-01-01"</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"Statement"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"array"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"items"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"object"</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token string">"properties"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                    <span class="token string">"Effect"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                        <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">,</span></span>
<span class="line">                        <span class="token string">"enum"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"Allow"</span><span class="token punctuation">,</span> <span class="token string">"Deny"</span><span class="token punctuation">]</span></span>
<span class="line">                    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"Action"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                        <span class="token string">"oneOf"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span></span>
<span class="line">                            <span class="token punctuation">{</span><span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                            <span class="token punctuation">{</span></span>
<span class="line">                                <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"array"</span><span class="token punctuation">,</span></span>
<span class="line">                                <span class="token string">"items"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">}</span></span>
<span class="line">                            <span class="token punctuation">}</span></span>
<span class="line">                        <span class="token punctuation">]</span></span>
<span class="line">                    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"Resource"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                        <span class="token string">"oneOf"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span></span>
<span class="line">                            <span class="token punctuation">{</span><span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                            <span class="token punctuation">{</span></span>
<span class="line">                                <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"array"</span><span class="token punctuation">,</span></span>
<span class="line">                                <span class="token string">"items"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"string"</span><span class="token punctuation">}</span></span>
<span class="line">                            <span class="token punctuation">}</span></span>
<span class="line">                        <span class="token punctuation">]</span></span>
<span class="line">                    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                    <span class="token string">"Condition"</span><span class="token punctuation">:</span> <span class="token punctuation">{</span></span>
<span class="line">                        <span class="token string">"type"</span><span class="token punctuation">:</span> <span class="token string">"object"</span></span>
<span class="line">                    <span class="token punctuation">}</span></span>
<span class="line">                <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token string">"required"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"Effect"</span><span class="token punctuation">,</span> <span class="token string">"Action"</span><span class="token punctuation">,</span> <span class="token string">"Resource"</span><span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token string">"required"</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"Version"</span><span class="token punctuation">,</span> <span class="token string">"Statement"</span><span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">def</span> <span class="token function">validate_policy</span><span class="token punctuation">(</span>policy_document<span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token triple-quoted-string string">"""验证策略文档格式"""</span></span>
<span class="line">    <span class="token keyword">try</span><span class="token punctuation">:</span></span>
<span class="line">        policy <span class="token operator">=</span> json<span class="token punctuation">.</span>loads<span class="token punctuation">(</span>policy_document<span class="token punctuation">)</span></span>
<span class="line">        validate<span class="token punctuation">(</span>instance<span class="token operator">=</span>policy<span class="token punctuation">,</span> schema<span class="token operator">=</span>policy_schema<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">True</span><span class="token punctuation">,</span> <span class="token string">"策略文档格式正确"</span></span>
<span class="line">    <span class="token keyword">except</span> json<span class="token punctuation">.</span>JSONDecodeError <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">False</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"JSON格式错误: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">}</span></span><span class="token string">"</span></span></span>
<span class="line">    <span class="token keyword">except</span> jsonschema<span class="token punctuation">.</span>exceptions<span class="token punctuation">.</span>ValidationError <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">False</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"策略格式错误: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">.</span>message<span class="token punctuation">}</span></span><span class="token string">"</span></span></span>
<span class="line">    <span class="token keyword">except</span> Exception <span class="token keyword">as</span> e<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">False</span><span class="token punctuation">,</span> <span class="token string-interpolation"><span class="token string">f"验证失败: </span><span class="token interpolation"><span class="token punctuation">{</span>e<span class="token punctuation">}</span></span><span class="token string">"</span></span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 使用示例</span></span>
<span class="line"><span class="token keyword">if</span> __name__ <span class="token operator">==</span> <span class="token string">"__main__"</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 测试策略文档</span></span>
<span class="line">    test_policy <span class="token operator">=</span> <span class="token triple-quoted-string string">'''</span>
<span class="line">    {</span>
<span class="line">        "Version": "2025-01-01",</span>
<span class="line">        "Statement": [</span>
<span class="line">            {</span>
<span class="line">                "Effect": "Allow",</span>
<span class="line">                "Action": ["iam:GetUser", "iam:ListUsers"],</span>
<span class="line">                "Resource": "*"</span>
<span class="line">            }</span>
<span class="line">        ]</span>
<span class="line">    }</span>
<span class="line">    '''</span></span>
<span class="line">    </span>
<span class="line">    is_valid<span class="token punctuation">,</span> message <span class="token operator">=</span> validate_policy<span class="token punctuation">(</span>test_policy<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">print</span><span class="token punctuation">(</span><span class="token string-interpolation"><span class="token string">f"验证结果: </span><span class="token interpolation"><span class="token punctuation">{</span>message<span class="token punctuation">}</span></span><span class="token string">"</span></span><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔍-最佳实践">#</a> 🔍 最佳实践</h2>
<h3 id="_1-策略命名规范" tabindex="-1"><a class="header-anchor" href="#_1-策略命名规范">#</a> 1. 策略命名规范</h3>
<ul>
<li>使用描述性名称</li>
<li>遵循一致的命名约定</li>
<li>包含策略用途和范围</li>
</ul>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 好的策略名称示例</span></span>
<span class="line"><span class="token string">"ReadOnlyPolicy"</span></span>
<span class="line"><span class="token string">"UserManagementPolicy"</span></span>
<span class="line"><span class="token string">"ApplicationDeveloperPolicy"</span></span>
<span class="line"><span class="token string">"AdminFullAccessPolicy"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 避免的策略名称</span></span>
<span class="line"><span class="token string">"Policy1"</span></span>
<span class="line"><span class="token string">"Test"</span></span>
<span class="line"><span class="token string">"Temp"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-最小权限原则" tabindex="-1"><a class="header-anchor" href="#_2-最小权限原则">#</a> 2. 最小权限原则</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token comment">// 好的做法：具体的权限</span></span>
<span class="line"><span class="token punctuation">{</span></span>
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
<span class="line"></span>
<span class="line"><span class="token comment">// 避免：过于宽泛的权限</span></span>
<span class="line"><span class="token punctuation">{</span></span>
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
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-策略版本管理" tabindex="-1"><a class="header-anchor" href="#_3-策略版本管理">#</a> 3. 策略版本管理</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建策略时包含版本信息</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "ReadOnlyPolicy_v2",</span>
<span class="line">  "description": "只读策略 v2.0 - 增加应用查看权限",</span>
<span class="line">  "policy_document": "...",</span>
<span class="line">  "tags": ["readonly", "v2"]</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreatePolicy</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-策略测试" tabindex="-1"><a class="header-anchor" href="#_4-策略测试">#</a> 4. 策略测试</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建测试用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_policy_user",</span>
<span class="line">  "display_name": "Policy Test User",</span>
<span class="line">  "email": "test@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 绑定策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "test_policy_user",</span>
<span class="line">  "policy_name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/AttachUserPolicy</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试权限</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "test_policy_user",</span>
<span class="line">  "action": "iam:GetUser",</span>
<span class="line">  "resource": "*"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermission</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清理测试数据</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name": "test_policy_user",</span>
<span class="line">  "policy_name": "ReadOnlyPolicy"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DetachUserPolicy</span>
<span class="line"></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name": "test_policy_user"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/DeleteUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_5-策略审计" tabindex="-1"><a class="header-anchor" href="#_5-策略审计">#</a> 5. 策略审计</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 策略审计脚本</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== 策略审计报告 ==="</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"生成时间: <span class="token variable"><span class="token variable">$(</span><span class="token function">date</span><span class="token variable">)</span></span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 获取所有策略</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"1. 策略总数统计"</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 1000</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListPolicies <span class="token operator">|</span> jq <span class="token string">'.pagination.total_count'</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"2. 未绑定用户的策略"</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 1000</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListPolicies <span class="token operator">|</span> jq <span class="token string">'.policies[] | select(.attached_users_count == 0) | .name'</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"3. 使用通配符权限的策略"</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "page": 1,</span>
<span class="line">  "page_size": 1000</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/ListPolicies <span class="token operator">|</span> jq <span class="token string">'.policies[] | select(.policy_document | contains("\"*\"")) | .name'</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"审计完成"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-注意事项" tabindex="-1"><a class="header-anchor" href="#🚨-注意事项">#</a> 🚨 注意事项</h2>
<h3 id="安全考虑" tabindex="-1"><a class="header-anchor" href="#安全考虑">#</a> 安全考虑</h3>
<ol>
<li>
<p><strong>策略文档安全</strong>：</p>
<ul>
<li>避免在策略中硬编码敏感信息</li>
<li>使用变量替换而非具体值</li>
<li>定期审查策略权限</li>
</ul>
</li>
<li>
<p><strong>权限控制</strong>：</p>
<ul>
<li>遵循最小权限原则</li>
<li>避免使用过于宽泛的通配符</li>
<li>定期清理不使用的策略</li>
</ul>
</li>
<li>
<p><strong>策略冲突</strong>：</p>
<ul>
<li>Deny优先于Allow</li>
<li>明确的权限优先于通配符</li>
<li>避免策略间的冲突</li>
</ul>
</li>
</ol>
<h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<ol>
<li>
<p><strong>策略缓存</strong>：</p>
<ul>
<li>缓存频繁使用的策略</li>
<li>设置合适的缓存过期时间</li>
<li>及时更新缓存</li>
</ul>
</li>
<li>
<p><strong>批量操作</strong>：</p>
<ul>
<li>使用批量绑定/解绑操作</li>
<li>避免频繁的单个操作</li>
<li>合理控制并发数</li>
</ul>
</li>
</ol>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议为不同角色创建标准化的策略模板，便于统一管理和维护。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>策略更新会立即生效，请在生产环境中谨慎操作，建议先在测试环境验证。</p>
</div>
</div></template>


