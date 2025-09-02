<template><div><h1 id="安全配置" tabindex="-1"><a class="header-anchor" href="#安全配置">#</a> 安全配置</h1>
<p>VGO微服务的安全配置是生产环境部署的重要组成部分。本指南详细介绍了如何配置和加强VGO微服务的安全性，包括认证、授权、网络安全、数据保护等方面。</p>
<h2 id="🔒-安全架构" tabindex="-1"><a class="header-anchor" href="#🔒-安全架构">#</a> 🔒 安全架构</h2>
<h3 id="安全层次图" tabindex="-1"><a class="header-anchor" href="#安全层次图">#</a> 安全层次图</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"网络安全层"</span></span>
<span class="line">        A<span class="token text string">[防火墙]</span></span>
<span class="line">        B<span class="token text string">[负载均衡器]</span></span>
<span class="line">        C<span class="token text string">[WAF]</span></span>
<span class="line">        D<span class="token text string">[DDoS防护]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"传输安全层"</span></span>
<span class="line">        E<span class="token text string">[TLS/SSL]</span></span>
<span class="line">        F<span class="token text string">[证书管理]</span></span>
<span class="line">        G<span class="token text string">[mTLS]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"应用安全层"</span></span>
<span class="line">        H<span class="token text string">[身份认证]</span></span>
<span class="line">        I<span class="token text string">[访问控制]</span></span>
<span class="line">        J<span class="token text string">[API网关]</span></span>
<span class="line">        K<span class="token text string">[限流熔断]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据安全层"</span></span>
<span class="line">        L<span class="token text string">[数据加密]</span></span>
<span class="line">        M<span class="token text string">[密钥管理]</span></span>
<span class="line">        N<span class="token text string">[数据脱敏]</span></span>
<span class="line">        O<span class="token text string">[备份加密]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"运维安全层"</span></span>
<span class="line">        P<span class="token text string">[审计日志]</span></span>
<span class="line">        Q<span class="token text string">[安全监控]</span></span>
<span class="line">        R<span class="token text string">[漏洞扫描]</span></span>
<span class="line">        S<span class="token text string">[合规检查]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> B</span>
<span class="line">    B <span class="token arrow operator">--></span> C</span>
<span class="line">    C <span class="token arrow operator">--></span> E</span>
<span class="line">    E <span class="token arrow operator">--></span> H</span>
<span class="line">    H <span class="token arrow operator">--></span> I</span>
<span class="line">    I <span class="token arrow operator">--></span> L</span>
<span class="line">    L <span class="token arrow operator">--></span> P</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="安全威胁模型" tabindex="-1"><a class="header-anchor" href="#安全威胁模型">#</a> 安全威胁模型</h3>
<table>
<thead>
<tr>
<th>威胁类型</th>
<th>风险等级</th>
<th>防护措施</th>
<th>检测方法</th>
</tr>
</thead>
<tbody>
<tr>
<td>未授权访问</td>
<td>高</td>
<td>强认证、访问控制</td>
<td>登录监控、异常检测</td>
</tr>
<tr>
<td>数据泄露</td>
<td>高</td>
<td>数据加密、权限控制</td>
<td>数据访问审计</td>
</tr>
<tr>
<td>DDoS攻击</td>
<td>中</td>
<td>限流、负载均衡</td>
<td>流量监控</td>
</tr>
<tr>
<td>SQL注入</td>
<td>中</td>
<td>参数化查询、输入验证</td>
<td>WAF日志分析</td>
</tr>
<tr>
<td>中间人攻击</td>
<td>中</td>
<td>TLS加密、证书验证</td>
<td>证书监控</td>
</tr>
<tr>
<td>内部威胁</td>
<td>中</td>
<td>最小权限、审计日志</td>
<td>行为分析</td>
</tr>
</tbody>
</table>
<h2 id="🔐-身份认证与授权" tabindex="-1"><a class="header-anchor" href="#🔐-身份认证与授权">#</a> 🔐 身份认证与授权</h2>
<h3 id="_1-jwt配置" tabindex="-1"><a class="header-anchor" href="#_1-jwt配置">#</a> 1. JWT配置</h3>
<h4 id="jwt密钥管理" tabindex="-1"><a class="header-anchor" href="#jwt密钥管理">#</a> JWT密钥管理</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># config/security.yaml</span></span>
<span class="line"><span class="token key atrule">security</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">jwt</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token comment"># 使用强随机密钥，至少32字符</span></span>
<span class="line">    <span class="token key atrule">secret_key</span><span class="token punctuation">:</span> <span class="token string">"${JWT_SECRET_KEY}"</span></span>
<span class="line">    <span class="token comment"># Token有效期</span></span>
<span class="line">    <span class="token key atrule">access_token_ttl</span><span class="token punctuation">:</span> 15m</span>
<span class="line">    <span class="token key atrule">refresh_token_ttl</span><span class="token punctuation">:</span> 7d</span>
<span class="line">    <span class="token comment"># 签名算法</span></span>
<span class="line">    <span class="token key atrule">algorithm</span><span class="token punctuation">:</span> <span class="token string">"HS256"</span></span>
<span class="line">    <span class="token comment"># 发行者</span></span>
<span class="line">    <span class="token key atrule">issuer</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line">    <span class="token comment"># 受众</span></span>
<span class="line">    <span class="token key atrule">audience</span><span class="token punctuation">:</span> <span class="token string">"vgo-api"</span></span>
<span class="line">    <span class="token comment"># 时钟偏移容忍度</span></span>
<span class="line">    <span class="token key atrule">clock_skew</span><span class="token punctuation">:</span> 5m</span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 密钥轮换配置</span></span>
<span class="line">  <span class="token key atrule">key_rotation</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token comment"># 轮换间隔</span></span>
<span class="line">    <span class="token key atrule">interval</span><span class="token punctuation">:</span> 30d</span>
<span class="line">    <span class="token comment"># 保留旧密钥数量</span></span>
<span class="line">    <span class="token key atrule">keep_old_keys</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="jwt中间件配置" tabindex="-1"><a class="header-anchor" href="#jwt中间件配置">#</a> JWT中间件配置</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/middleware/auth.go</span></span>
<span class="line"><span class="token keyword">package</span> middleware</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"strings"</span></span>
<span class="line">	<span class="token string">"time"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"github.com/golang-jwt/jwt/v5"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/codes"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/metadata"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/status"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// JWTConfig JWT配置</span></span>
<span class="line"><span class="token keyword">type</span> JWTConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	SecretKey     <span class="token builtin">string</span>        <span class="token string">`yaml:"secret_key"`</span></span>
<span class="line">	AccessTTL     time<span class="token punctuation">.</span>Duration <span class="token string">`yaml:"access_token_ttl"`</span></span>
<span class="line">	RefreshTTL    time<span class="token punctuation">.</span>Duration <span class="token string">`yaml:"refresh_token_ttl"`</span></span>
<span class="line">	Algorithm     <span class="token builtin">string</span>        <span class="token string">`yaml:"algorithm"`</span></span>
<span class="line">	Issuer        <span class="token builtin">string</span>        <span class="token string">`yaml:"issuer"`</span></span>
<span class="line">	Audience      <span class="token builtin">string</span>        <span class="token string">`yaml:"audience"`</span></span>
<span class="line">	ClockSkew     time<span class="token punctuation">.</span>Duration <span class="token string">`yaml:"clock_skew"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Claims JWT声明</span></span>
<span class="line"><span class="token keyword">type</span> Claims <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	UserID      <span class="token builtin">string</span>   <span class="token string">`json:"user_id"`</span></span>
<span class="line">	Username    <span class="token builtin">string</span>   <span class="token string">`json:"username"`</span></span>
<span class="line">	Email       <span class="token builtin">string</span>   <span class="token string">`json:"email"`</span></span>
<span class="line">	Roles       <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"roles"`</span></span>
<span class="line">	Permissions <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"permissions"`</span></span>
<span class="line">	jwt<span class="token punctuation">.</span>RegisteredClaims</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// JWTAuthInterceptor JWT认证拦截器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">JWTAuthInterceptor</span><span class="token punctuation">(</span>config JWTConfig<span class="token punctuation">)</span> grpc<span class="token punctuation">.</span>UnaryServerInterceptor <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> info <span class="token operator">*</span>grpc<span class="token punctuation">.</span>UnaryServerInfo<span class="token punctuation">,</span> handler grpc<span class="token punctuation">.</span>UnaryHandler<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token comment">// 跳过健康检查和公开接口</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token function">isPublicMethod</span><span class="token punctuation">(</span>info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 提取Token</span></span>
<span class="line">		token<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">extractToken</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>Unauthenticated<span class="token punctuation">,</span> <span class="token string">"missing or invalid token: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 验证Token</span></span>
<span class="line">		claims<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">validateToken</span><span class="token punctuation">(</span>token<span class="token punctuation">,</span> config<span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>Unauthenticated<span class="token punctuation">,</span> <span class="token string">"invalid token: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 将用户信息添加到上下文</span></span>
<span class="line">		ctx <span class="token operator">=</span> context<span class="token punctuation">.</span><span class="token function">WithValue</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"user_id"</span><span class="token punctuation">,</span> claims<span class="token punctuation">.</span>UserID<span class="token punctuation">)</span></span>
<span class="line">		ctx <span class="token operator">=</span> context<span class="token punctuation">.</span><span class="token function">WithValue</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"username"</span><span class="token punctuation">,</span> claims<span class="token punctuation">.</span>Username<span class="token punctuation">)</span></span>
<span class="line">		ctx <span class="token operator">=</span> context<span class="token punctuation">.</span><span class="token function">WithValue</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"roles"</span><span class="token punctuation">,</span> claims<span class="token punctuation">.</span>Roles<span class="token punctuation">)</span></span>
<span class="line">		ctx <span class="token operator">=</span> context<span class="token punctuation">.</span><span class="token function">WithValue</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"permissions"</span><span class="token punctuation">,</span> claims<span class="token punctuation">.</span>Permissions<span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">		<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// extractToken 从请求中提取Token</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">extractToken</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	md<span class="token punctuation">,</span> ok <span class="token operator">:=</span> metadata<span class="token punctuation">.</span><span class="token function">FromIncomingContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"missing metadata"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	authorization <span class="token operator">:=</span> md<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"authorization"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>authorization<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"missing authorization header"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	token <span class="token operator">:=</span> authorization<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>strings<span class="token punctuation">.</span><span class="token function">HasPrefix</span><span class="token punctuation">(</span>token<span class="token punctuation">,</span> <span class="token string">"Bearer "</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"invalid authorization header format"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> strings<span class="token punctuation">.</span><span class="token function">TrimPrefix</span><span class="token punctuation">(</span>token<span class="token punctuation">,</span> <span class="token string">"Bearer "</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// validateToken 验证Token</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">validateToken</span><span class="token punctuation">(</span>tokenString <span class="token builtin">string</span><span class="token punctuation">,</span> config JWTConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>Claims<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	token<span class="token punctuation">,</span> err <span class="token operator">:=</span> jwt<span class="token punctuation">.</span><span class="token function">ParseWithClaims</span><span class="token punctuation">(</span>tokenString<span class="token punctuation">,</span> <span class="token operator">&amp;</span>Claims<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>token <span class="token operator">*</span>jwt<span class="token punctuation">.</span>Token<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token comment">// 验证签名算法</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token boolean">_</span><span class="token punctuation">,</span> ok <span class="token operator">:=</span> token<span class="token punctuation">.</span>Method<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>jwt<span class="token punctuation">.</span>SigningMethodHMAC<span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"unexpected signing method: %v"</span><span class="token punctuation">,</span> token<span class="token punctuation">.</span>Header<span class="token punctuation">[</span><span class="token string">"alg"</span><span class="token punctuation">]</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>SecretKey<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">	<span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	claims<span class="token punctuation">,</span> ok <span class="token operator">:=</span> token<span class="token punctuation">.</span>Claims<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>Claims<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token operator">||</span> <span class="token operator">!</span>token<span class="token punctuation">.</span>Valid <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"invalid token claims"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 验证发行者和受众</span></span>
<span class="line">	<span class="token keyword">if</span> claims<span class="token punctuation">.</span>Issuer <span class="token operator">!=</span> config<span class="token punctuation">.</span>Issuer <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"invalid issuer"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>claims<span class="token punctuation">.</span>Audience<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token operator">||</span> claims<span class="token punctuation">.</span>Audience<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span> <span class="token operator">!=</span> config<span class="token punctuation">.</span>Audience <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"invalid audience"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 验证时间</span></span>
<span class="line">	now <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> claims<span class="token punctuation">.</span>ExpiresAt <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token operator">&amp;&amp;</span> claims<span class="token punctuation">.</span>ExpiresAt<span class="token punctuation">.</span>Time<span class="token punctuation">.</span><span class="token function">Before</span><span class="token punctuation">(</span>now<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token operator">-</span>config<span class="token punctuation">.</span>ClockSkew<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"token expired"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> claims<span class="token punctuation">.</span>NotBefore <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token operator">&amp;&amp;</span> claims<span class="token punctuation">.</span>NotBefore<span class="token punctuation">.</span>Time<span class="token punctuation">.</span><span class="token function">After</span><span class="token punctuation">(</span>now<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>ClockSkew<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"token not valid yet"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> claims<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// isPublicMethod 检查是否为公开方法</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">isPublicMethod</span><span class="token punctuation">(</span>method <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	publicMethods <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">		<span class="token string">"/grpc.health.v1.Health/Check"</span><span class="token punctuation">,</span></span>
<span class="line">		<span class="token string">"/grpc.health.v1.Health/Watch"</span><span class="token punctuation">,</span></span>
<span class="line">		<span class="token string">"/vgo.iam.v1.AuthService/Login"</span><span class="token punctuation">,</span></span>
<span class="line">		<span class="token string">"/vgo.iam.v1.AuthService/RefreshToken"</span><span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> publicMethod <span class="token operator">:=</span> <span class="token keyword">range</span> publicMethods <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">if</span> method <span class="token operator">==</span> publicMethod <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">true</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-rbac权限控制" tabindex="-1"><a class="header-anchor" href="#_2-rbac权限控制">#</a> 2. RBAC权限控制</h3>
<h4 id="权限检查中间件" tabindex="-1"><a class="header-anchor" href="#权限检查中间件">#</a> 权限检查中间件</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/middleware/rbac.go</span></span>
<span class="line"><span class="token keyword">package</span> middleware</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"strings"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/codes"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/status"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Permission 权限定义</span></span>
<span class="line"><span class="token keyword">type</span> Permission <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Resource <span class="token builtin">string</span> <span class="token string">`json:"resource"`</span></span>
<span class="line">	Action   <span class="token builtin">string</span> <span class="token string">`json:"action"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// RBACConfig RBAC配置</span></span>
<span class="line"><span class="token keyword">type</span> RBACConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 方法权限映射</span></span>
<span class="line">	MethodPermissions <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span>Permission <span class="token string">`yaml:"method_permissions"`</span></span>
<span class="line">	<span class="token comment">// 超级管理员角色</span></span>
<span class="line">	SuperAdminRole <span class="token builtin">string</span> <span class="token string">`yaml:"super_admin_role"`</span></span>
<span class="line">	<span class="token comment">// 启用权限检查</span></span>
<span class="line">	Enabled <span class="token builtin">bool</span> <span class="token string">`yaml:"enabled"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// RBACInterceptor RBAC权限检查拦截器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">RBACInterceptor</span><span class="token punctuation">(</span>config RBACConfig<span class="token punctuation">)</span> grpc<span class="token punctuation">.</span>UnaryServerInterceptor <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> info <span class="token operator">*</span>grpc<span class="token punctuation">.</span>UnaryServerInfo<span class="token punctuation">,</span> handler grpc<span class="token punctuation">.</span>UnaryHandler<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>config<span class="token punctuation">.</span>Enabled <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 跳过公开方法</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token function">isPublicMethod</span><span class="token punctuation">(</span>info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 获取用户信息</span></span>
<span class="line">		userRoles<span class="token punctuation">,</span> ok <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"roles"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>PermissionDenied<span class="token punctuation">,</span> <span class="token string">"missing user roles"</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		userPermissions<span class="token punctuation">,</span> ok <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"permissions"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>PermissionDenied<span class="token punctuation">,</span> <span class="token string">"missing user permissions"</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 检查超级管理员权限</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token function">contains</span><span class="token punctuation">(</span>userRoles<span class="token punctuation">,</span> config<span class="token punctuation">.</span>SuperAdminRole<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 获取方法所需权限</span></span>
<span class="line">		requiredPermission<span class="token punctuation">,</span> exists <span class="token operator">:=</span> config<span class="token punctuation">.</span>MethodPermissions<span class="token punctuation">[</span>info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">]</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>exists <span class="token punctuation">{</span></span>
<span class="line">			<span class="token comment">// 如果没有配置权限，默认拒绝</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>PermissionDenied<span class="token punctuation">,</span> <span class="token string">"method not configured: %s"</span><span class="token punctuation">,</span> info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token comment">// 检查用户权限</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span><span class="token function">hasPermission</span><span class="token punctuation">(</span>userPermissions<span class="token punctuation">,</span> requiredPermission<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>PermissionDenied<span class="token punctuation">,</span> <span class="token string">"insufficient permissions for %s"</span><span class="token punctuation">,</span> info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// hasPermission 检查用户是否有指定权限</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">hasPermission</span><span class="token punctuation">(</span>userPermissions <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">,</span> required Permission<span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	requiredPerm <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:%s"</span><span class="token punctuation">,</span> required<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span> required<span class="token punctuation">.</span>Action<span class="token punctuation">)</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> perm <span class="token operator">:=</span> <span class="token keyword">range</span> userPermissions <span class="token punctuation">{</span></span>
<span class="line">		<span class="token comment">// 精确匹配</span></span>
<span class="line">		<span class="token keyword">if</span> perm <span class="token operator">==</span> requiredPerm <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">true</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 通配符匹配</span></span>
<span class="line">		<span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">HasSuffix</span><span class="token punctuation">(</span>perm<span class="token punctuation">,</span> <span class="token string">":*"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			resource <span class="token operator">:=</span> strings<span class="token punctuation">.</span><span class="token function">TrimSuffix</span><span class="token punctuation">(</span>perm<span class="token punctuation">,</span> <span class="token string">":*"</span><span class="token punctuation">)</span></span>
<span class="line">			<span class="token keyword">if</span> resource <span class="token operator">==</span> required<span class="token punctuation">.</span>Resource <span class="token punctuation">{</span></span>
<span class="line">				<span class="token keyword">return</span> <span class="token boolean">true</span></span>
<span class="line">			<span class="token punctuation">}</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 全局权限</span></span>
<span class="line">		<span class="token keyword">if</span> perm <span class="token operator">==</span> <span class="token string">"*:*"</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">true</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// contains 检查切片是否包含指定元素</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">contains</span><span class="token punctuation">(</span>slice <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">,</span> item <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> s <span class="token operator">:=</span> <span class="token keyword">range</span> slice <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">if</span> s <span class="token operator">==</span> item <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">true</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔒-tls-ssl配置" tabindex="-1"><a class="header-anchor" href="#🔒-tls-ssl配置">#</a> 🔒 TLS/SSL配置</h2>
<h3 id="_1-证书管理" tabindex="-1"><a class="header-anchor" href="#_1-证书管理">#</a> 1. 证书管理</h3>
<h4 id="自签名证书生成" tabindex="-1"><a class="header-anchor" href="#自签名证书生成">#</a> 自签名证书生成</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/generate-certs.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">CERT_DIR</span><span class="token operator">=</span><span class="token string">"certs"</span></span>
<span class="line"><span class="token assign-left variable">CA_KEY</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/ca-key.pem"</span></span>
<span class="line"><span class="token assign-left variable">CA_CERT</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/ca-cert.pem"</span></span>
<span class="line"><span class="token assign-left variable">SERVER_KEY</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/server-key.pem"</span></span>
<span class="line"><span class="token assign-left variable">SERVER_CERT</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/server-cert.pem"</span></span>
<span class="line"><span class="token assign-left variable">CLIENT_KEY</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/client-key.pem"</span></span>
<span class="line"><span class="token assign-left variable">CLIENT_CERT</span><span class="token operator">=</span><span class="token string">"<span class="token variable">$CERT_DIR</span>/client-cert.pem"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔐 生成TLS证书..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建证书目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token variable">$CERT_DIR</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成CA私钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📝 生成CA私钥..."</span></span>
<span class="line">openssl genrsa <span class="token parameter variable">-out</span> <span class="token variable">$CA_KEY</span> <span class="token number">4096</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成CA证书</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📜 生成CA证书..."</span></span>
<span class="line">openssl req <span class="token parameter variable">-new</span> <span class="token parameter variable">-x509</span> <span class="token parameter variable">-key</span> <span class="token variable">$CA_KEY</span> <span class="token parameter variable">-sha256</span> <span class="token parameter variable">-subj</span> <span class="token string">"/C=CN/ST=Beijing/L=Beijing/O=VGO/OU=Security/CN=VGO-CA"</span> <span class="token parameter variable">-days</span> <span class="token number">3650</span> <span class="token parameter variable">-out</span> <span class="token variable">$CA_CERT</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成服务器私钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔑 生成服务器私钥..."</span></span>
<span class="line">openssl genrsa <span class="token parameter variable">-out</span> <span class="token variable">$SERVER_KEY</span> <span class="token number">4096</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成服务器证书签名请求</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📋 生成服务器CSR..."</span></span>
<span class="line">openssl req <span class="token parameter variable">-new</span> <span class="token parameter variable">-key</span> <span class="token variable">$SERVER_KEY</span> <span class="token parameter variable">-subj</span> <span class="token string">"/C=CN/ST=Beijing/L=Beijing/O=VGO/OU=Server/CN=vgo-iam"</span> <span class="token parameter variable">-out</span> server.csr</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建服务器证书扩展文件</span></span>
<span class="line"><span class="token function">cat</span> <span class="token operator">></span> server.ext <span class="token operator">&lt;&lt;</span> <span class="token string">EOF</span>
<span class="line">authorityKeyIdentifier=keyid,issuer</span>
<span class="line">basicConstraints=CA:FALSE</span>
<span class="line">keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment</span>
<span class="line">subjectAltName = @alt_names</span>
<span class="line"></span>
<span class="line">[alt_names]</span>
<span class="line">DNS.1 = vgo-iam</span>
<span class="line">DNS.2 = localhost</span>
<span class="line">DNS.3 = *.vgo.local</span>
<span class="line">IP.1 = 127.0.0.1</span>
<span class="line">IP.2 = ::1</span>
<span class="line">EOF</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成服务器证书</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🏆 生成服务器证书..."</span></span>
<span class="line">openssl x509 <span class="token parameter variable">-req</span> <span class="token parameter variable">-in</span> server.csr <span class="token parameter variable">-CA</span> <span class="token variable">$CA_CERT</span> <span class="token parameter variable">-CAkey</span> <span class="token variable">$CA_KEY</span> <span class="token parameter variable">-CAcreateserial</span> <span class="token parameter variable">-out</span> <span class="token variable">$SERVER_CERT</span> <span class="token parameter variable">-days</span> <span class="token number">365</span> <span class="token parameter variable">-sha256</span> <span class="token parameter variable">-extfile</span> server.ext</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成客户端私钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔐 生成客户端私钥..."</span></span>
<span class="line">openssl genrsa <span class="token parameter variable">-out</span> <span class="token variable">$CLIENT_KEY</span> <span class="token number">4096</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成客户端证书签名请求</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📄 生成客户端CSR..."</span></span>
<span class="line">openssl req <span class="token parameter variable">-new</span> <span class="token parameter variable">-key</span> <span class="token variable">$CLIENT_KEY</span> <span class="token parameter variable">-subj</span> <span class="token string">"/C=CN/ST=Beijing/L=Beijing/O=VGO/OU=Client/CN=vgo-client"</span> <span class="token parameter variable">-out</span> client.csr</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建客户端证书扩展文件</span></span>
<span class="line"><span class="token function">cat</span> <span class="token operator">></span> client.ext <span class="token operator">&lt;&lt;</span> <span class="token string">EOF</span>
<span class="line">authorityKeyIdentifier=keyid,issuer</span>
<span class="line">basicConstraints=CA:FALSE</span>
<span class="line">keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment</span>
<span class="line">extendedKeyUsage = clientAuth</span>
<span class="line">EOF</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成客户端证书</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🎫 生成客户端证书..."</span></span>
<span class="line">openssl x509 <span class="token parameter variable">-req</span> <span class="token parameter variable">-in</span> client.csr <span class="token parameter variable">-CA</span> <span class="token variable">$CA_CERT</span> <span class="token parameter variable">-CAkey</span> <span class="token variable">$CA_KEY</span> <span class="token parameter variable">-CAcreateserial</span> <span class="token parameter variable">-out</span> <span class="token variable">$CLIENT_CERT</span> <span class="token parameter variable">-days</span> <span class="token number">365</span> <span class="token parameter variable">-sha256</span> <span class="token parameter variable">-extfile</span> client.ext</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清理临时文件</span></span>
<span class="line"><span class="token function">rm</span> <span class="token parameter variable">-f</span> server.csr client.csr server.ext client.ext ca-cert.srl</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 设置权限</span></span>
<span class="line"><span class="token function">chmod</span> <span class="token number">600</span> <span class="token variable">$CERT_DIR</span>/*.pem</span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"✅ 证书生成完成！"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📁 证书位置: <span class="token variable">$CERT_DIR</span>/"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📋 证书列表:"</span></span>
<span class="line"><span class="token function">ls</span> <span class="token parameter variable">-la</span> <span class="token variable">$CERT_DIR</span>/</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 验证证书</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 验证证书..."</span></span>
<span class="line">openssl x509 <span class="token parameter variable">-in</span> <span class="token variable">$SERVER_CERT</span> <span class="token parameter variable">-text</span> <span class="token parameter variable">-noout</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-A</span> <span class="token number">1</span> <span class="token string">"Subject:"</span></span>
<span class="line">openssl x509 <span class="token parameter variable">-in</span> <span class="token variable">$CLIENT_CERT</span> <span class="token parameter variable">-text</span> <span class="token parameter variable">-noout</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-A</span> <span class="token number">1</span> <span class="token string">"Subject:"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🎉 证书验证完成！"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="tls服务器配置" tabindex="-1"><a class="header-anchor" href="#tls服务器配置">#</a> TLS服务器配置</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/server/tls.go</span></span>
<span class="line"><span class="token keyword">package</span> server</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"crypto/tls"</span></span>
<span class="line">	<span class="token string">"crypto/x509"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"io/ioutil"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/credentials"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// TLSConfig TLS配置</span></span>
<span class="line"><span class="token keyword">type</span> TLSConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Enabled    <span class="token builtin">bool</span>   <span class="token string">`yaml:"enabled"`</span></span>
<span class="line">	CertFile   <span class="token builtin">string</span> <span class="token string">`yaml:"cert_file"`</span></span>
<span class="line">	KeyFile    <span class="token builtin">string</span> <span class="token string">`yaml:"key_file"`</span></span>
<span class="line">	CAFile     <span class="token builtin">string</span> <span class="token string">`yaml:"ca_file"`</span></span>
<span class="line">	ClientAuth <span class="token builtin">bool</span>   <span class="token string">`yaml:"client_auth"`</span></span>
<span class="line">	MinVersion <span class="token builtin">string</span> <span class="token string">`yaml:"min_version"`</span></span>
<span class="line">	MaxVersion <span class="token builtin">string</span> <span class="token string">`yaml:"max_version"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// LoadTLSCredentials 加载TLS凭据</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">LoadTLSCredentials</span><span class="token punctuation">(</span>config TLSConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span>credentials<span class="token punctuation">.</span>TransportCredentials<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>config<span class="token punctuation">.</span>Enabled <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"TLS not enabled"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 加载服务器证书</span></span>
<span class="line">	serverCert<span class="token punctuation">,</span> err <span class="token operator">:=</span> tls<span class="token punctuation">.</span><span class="token function">LoadX509KeyPair</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>CertFile<span class="token punctuation">,</span> config<span class="token punctuation">.</span>KeyFile<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to load server certificate: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// TLS配置</span></span>
<span class="line">	tlsConfig <span class="token operator">:=</span> <span class="token operator">&amp;</span>tls<span class="token punctuation">.</span>Config<span class="token punctuation">{</span></span>
<span class="line">		Certificates<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span>tls<span class="token punctuation">.</span>Certificate<span class="token punctuation">{</span>serverCert<span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">		MinVersion<span class="token punctuation">:</span>   <span class="token function">getTLSVersion</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>MinVersion<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		MaxVersion<span class="token punctuation">:</span>   <span class="token function">getTLSVersion</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>MaxVersion<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		CipherSuites<span class="token punctuation">:</span> <span class="token function">getSecureCipherSuites</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 客户端证书验证</span></span>
<span class="line">	<span class="token keyword">if</span> config<span class="token punctuation">.</span>ClientAuth <span class="token operator">&amp;&amp;</span> config<span class="token punctuation">.</span>CAFile <span class="token operator">!=</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">		caCert<span class="token punctuation">,</span> err <span class="token operator">:=</span> ioutil<span class="token punctuation">.</span><span class="token function">ReadFile</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>CAFile<span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to read CA certificate: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		caCertPool <span class="token operator">:=</span> x509<span class="token punctuation">.</span><span class="token function">NewCertPool</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>caCertPool<span class="token punctuation">.</span><span class="token function">AppendCertsFromPEM</span><span class="token punctuation">(</span>caCert<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to parse CA certificate"</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">		tlsConfig<span class="token punctuation">.</span>ClientAuth <span class="token operator">=</span> tls<span class="token punctuation">.</span>RequireAndVerifyClientCert</span>
<span class="line">		tlsConfig<span class="token punctuation">.</span>ClientCAs <span class="token operator">=</span> caCertPool</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> credentials<span class="token punctuation">.</span><span class="token function">NewTLS</span><span class="token punctuation">(</span>tlsConfig<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// getTLSVersion 获取TLS版本</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getTLSVersion</span><span class="token punctuation">(</span>version <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">uint16</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">switch</span> version <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">case</span> <span class="token string">"1.0"</span><span class="token punctuation">:</span></span>
<span class="line">		<span class="token keyword">return</span> tls<span class="token punctuation">.</span>VersionTLS10</span>
<span class="line">	<span class="token keyword">case</span> <span class="token string">"1.1"</span><span class="token punctuation">:</span></span>
<span class="line">		<span class="token keyword">return</span> tls<span class="token punctuation">.</span>VersionTLS11</span>
<span class="line">	<span class="token keyword">case</span> <span class="token string">"1.2"</span><span class="token punctuation">:</span></span>
<span class="line">		<span class="token keyword">return</span> tls<span class="token punctuation">.</span>VersionTLS12</span>
<span class="line">	<span class="token keyword">case</span> <span class="token string">"1.3"</span><span class="token punctuation">:</span></span>
<span class="line">		<span class="token keyword">return</span> tls<span class="token punctuation">.</span>VersionTLS13</span>
<span class="line">	<span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">		<span class="token keyword">return</span> tls<span class="token punctuation">.</span>VersionTLS12 <span class="token comment">// 默认使用TLS 1.2</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// getSecureCipherSuites 获取安全的密码套件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">getSecureCipherSuites</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">uint16</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">uint16</span><span class="token punctuation">{</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384<span class="token punctuation">,</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305<span class="token punctuation">,</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384<span class="token punctuation">,</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305<span class="token punctuation">,</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256<span class="token punctuation">,</span></span>
<span class="line">		tls<span class="token punctuation">.</span>TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256<span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-mtls配置" tabindex="-1"><a class="header-anchor" href="#_2-mtls配置">#</a> 2. mTLS配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># config/tls.yaml</span></span>
<span class="line"><span class="token key atrule">tls</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">cert_file</span><span class="token punctuation">:</span> <span class="token string">"certs/server-cert.pem"</span></span>
<span class="line">  <span class="token key atrule">key_file</span><span class="token punctuation">:</span> <span class="token string">"certs/server-key.pem"</span></span>
<span class="line">  <span class="token key atrule">ca_file</span><span class="token punctuation">:</span> <span class="token string">"certs/ca-cert.pem"</span></span>
<span class="line">  <span class="token key atrule">client_auth</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">min_version</span><span class="token punctuation">:</span> <span class="token string">"1.2"</span></span>
<span class="line">  <span class="token key atrule">max_version</span><span class="token punctuation">:</span> <span class="token string">"1.3"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 客户端配置</span></span>
<span class="line">  <span class="token key atrule">client</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">cert_file</span><span class="token punctuation">:</span> <span class="token string">"certs/client-cert.pem"</span></span>
<span class="line">    <span class="token key atrule">key_file</span><span class="token punctuation">:</span> <span class="token string">"certs/client-key.pem"</span></span>
<span class="line">    <span class="token key atrule">ca_file</span><span class="token punctuation">:</span> <span class="token string">"certs/ca-cert.pem"</span></span>
<span class="line">    <span class="token key atrule">server_name</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line">    <span class="token key atrule">insecure_skip_verify</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛡️-数据保护" tabindex="-1"><a class="header-anchor" href="#🛡️-数据保护">#</a> 🛡️ 数据保护</h2>
<h3 id="_1-数据加密" tabindex="-1"><a class="header-anchor" href="#_1-数据加密">#</a> 1. 数据加密</h3>
<h4 id="敏感数据加密" tabindex="-1"><a class="header-anchor" href="#敏感数据加密">#</a> 敏感数据加密</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/crypto/encryption.go</span></span>
<span class="line"><span class="token keyword">package</span> crypto</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"crypto/aes"</span></span>
<span class="line">	<span class="token string">"crypto/cipher"</span></span>
<span class="line">	<span class="token string">"crypto/rand"</span></span>
<span class="line">	<span class="token string">"crypto/sha256"</span></span>
<span class="line">	<span class="token string">"encoding/base64"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"io"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"golang.org/x/crypto/pbkdf2"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// EncryptionConfig 加密配置</span></span>
<span class="line"><span class="token keyword">type</span> EncryptionConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Key       <span class="token builtin">string</span> <span class="token string">`yaml:"key"`</span></span>
<span class="line">	Salt      <span class="token builtin">string</span> <span class="token string">`yaml:"salt"`</span></span>
<span class="line">	KeyLength <span class="token builtin">int</span>    <span class="token string">`yaml:"key_length"`</span></span>
<span class="line">	Iterations <span class="token builtin">int</span>   <span class="token string">`yaml:"iterations"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Encryptor 加密器</span></span>
<span class="line"><span class="token keyword">type</span> Encryptor <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	key <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// NewEncryptor 创建加密器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewEncryptor</span><span class="token punctuation">(</span>config EncryptionConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>Encryptor<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>Key<span class="token punctuation">)</span> <span class="token operator">&lt;</span> <span class="token number">32</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"encryption key must be at least 32 characters"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 使用PBKDF2派生密钥</span></span>
<span class="line">	key <span class="token operator">:=</span> pbkdf2<span class="token punctuation">.</span><span class="token function">Key</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>Key<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>Salt<span class="token punctuation">)</span><span class="token punctuation">,</span> config<span class="token punctuation">.</span>Iterations<span class="token punctuation">,</span> config<span class="token punctuation">.</span>KeyLength<span class="token punctuation">,</span> sha256<span class="token punctuation">.</span>New<span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token operator">&amp;</span>Encryptor<span class="token punctuation">{</span>key<span class="token punctuation">:</span> key<span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Encrypt 加密数据</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>e <span class="token operator">*</span>Encryptor<span class="token punctuation">)</span> <span class="token function">Encrypt</span><span class="token punctuation">(</span>plaintext <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	block<span class="token punctuation">,</span> err <span class="token operator">:=</span> aes<span class="token punctuation">.</span><span class="token function">NewCipher</span><span class="token punctuation">(</span>e<span class="token punctuation">.</span>key<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 生成随机IV</span></span>
<span class="line">	iv <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> aes<span class="token punctuation">.</span>BlockSize<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> io<span class="token punctuation">.</span><span class="token function">ReadFull</span><span class="token punctuation">(</span>rand<span class="token punctuation">.</span>Reader<span class="token punctuation">,</span> iv<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 使用GCM模式</span></span>
<span class="line">	gcm<span class="token punctuation">,</span> err <span class="token operator">:=</span> cipher<span class="token punctuation">.</span><span class="token function">NewGCM</span><span class="token punctuation">(</span>block<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 加密</span></span>
<span class="line">	ciphertext <span class="token operator">:=</span> gcm<span class="token punctuation">.</span><span class="token function">Seal</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">,</span> iv<span class="token punctuation">,</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>plaintext<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 将IV和密文组合</span></span>
<span class="line">	result <span class="token operator">:=</span> <span class="token function">append</span><span class="token punctuation">(</span>iv<span class="token punctuation">,</span> ciphertext<span class="token operator">...</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> base64<span class="token punctuation">.</span>StdEncoding<span class="token punctuation">.</span><span class="token function">EncodeToString</span><span class="token punctuation">(</span>result<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Decrypt 解密数据</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>e <span class="token operator">*</span>Encryptor<span class="token punctuation">)</span> <span class="token function">Decrypt</span><span class="token punctuation">(</span>ciphertext <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	data<span class="token punctuation">,</span> err <span class="token operator">:=</span> base64<span class="token punctuation">.</span>StdEncoding<span class="token punctuation">.</span><span class="token function">DecodeString</span><span class="token punctuation">(</span>ciphertext<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>data<span class="token punctuation">)</span> <span class="token operator">&lt;</span> aes<span class="token punctuation">.</span>BlockSize <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"ciphertext too short"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	block<span class="token punctuation">,</span> err <span class="token operator">:=</span> aes<span class="token punctuation">.</span><span class="token function">NewCipher</span><span class="token punctuation">(</span>e<span class="token punctuation">.</span>key<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	gcm<span class="token punctuation">,</span> err <span class="token operator">:=</span> cipher<span class="token punctuation">.</span><span class="token function">NewGCM</span><span class="token punctuation">(</span>block<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 分离IV和密文</span></span>
<span class="line">	iv <span class="token operator">:=</span> data<span class="token punctuation">[</span><span class="token punctuation">:</span>aes<span class="token punctuation">.</span>BlockSize<span class="token punctuation">]</span></span>
<span class="line">	cipherData <span class="token operator">:=</span> data<span class="token punctuation">[</span>aes<span class="token punctuation">.</span>BlockSize<span class="token punctuation">:</span><span class="token punctuation">]</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 解密</span></span>
<span class="line">	plaintext<span class="token punctuation">,</span> err <span class="token operator">:=</span> gcm<span class="token punctuation">.</span><span class="token function">Open</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">,</span> iv<span class="token punctuation">,</span> cipherData<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token function">string</span><span class="token punctuation">(</span>plaintext<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// HashPassword 密码哈希</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">HashPassword</span><span class="token punctuation">(</span>password <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 生成随机盐</span></span>
<span class="line">	salt <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token number">16</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> rand<span class="token punctuation">.</span><span class="token function">Read</span><span class="token punctuation">(</span>salt<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 使用PBKDF2哈希</span></span>
<span class="line">	hash <span class="token operator">:=</span> pbkdf2<span class="token punctuation">.</span><span class="token function">Key</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>password<span class="token punctuation">)</span><span class="token punctuation">,</span> salt<span class="token punctuation">,</span> <span class="token number">10000</span><span class="token punctuation">,</span> <span class="token number">32</span><span class="token punctuation">,</span> sha256<span class="token punctuation">.</span>New<span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 组合盐和哈希</span></span>
<span class="line">	result <span class="token operator">:=</span> <span class="token function">append</span><span class="token punctuation">(</span>salt<span class="token punctuation">,</span> hash<span class="token operator">...</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> base64<span class="token punctuation">.</span>StdEncoding<span class="token punctuation">.</span><span class="token function">EncodeToString</span><span class="token punctuation">(</span>result<span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// VerifyPassword 验证密码</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">VerifyPassword</span><span class="token punctuation">(</span>password<span class="token punctuation">,</span> hashedPassword <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	data<span class="token punctuation">,</span> err <span class="token operator">:=</span> base64<span class="token punctuation">.</span>StdEncoding<span class="token punctuation">.</span><span class="token function">DecodeString</span><span class="token punctuation">(</span>hashedPassword<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>data<span class="token punctuation">)</span> <span class="token operator">!=</span> <span class="token number">48</span> <span class="token punctuation">{</span> <span class="token comment">// 16字节盐 + 32字节哈希</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	salt <span class="token operator">:=</span> data<span class="token punctuation">[</span><span class="token punctuation">:</span><span class="token number">16</span><span class="token punctuation">]</span></span>
<span class="line">	hash <span class="token operator">:=</span> data<span class="token punctuation">[</span><span class="token number">16</span><span class="token punctuation">:</span><span class="token punctuation">]</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 计算输入密码的哈希</span></span>
<span class="line">	inputHash <span class="token operator">:=</span> pbkdf2<span class="token punctuation">.</span><span class="token function">Key</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>password<span class="token punctuation">)</span><span class="token punctuation">,</span> salt<span class="token punctuation">,</span> <span class="token number">10000</span><span class="token punctuation">,</span> <span class="token number">32</span><span class="token punctuation">,</span> sha256<span class="token punctuation">.</span>New<span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 比较哈希</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token function">compareHashes</span><span class="token punctuation">(</span>hash<span class="token punctuation">,</span> inputHash<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// compareHashes 安全比较哈希值</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">compareHashes</span><span class="token punctuation">(</span>a<span class="token punctuation">,</span> b <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>a<span class="token punctuation">)</span> <span class="token operator">!=</span> <span class="token function">len</span><span class="token punctuation">(</span>b<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	result <span class="token operator">:=</span> <span class="token function">byte</span><span class="token punctuation">(</span><span class="token number">0</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> <span class="token function">len</span><span class="token punctuation">(</span>a<span class="token punctuation">)</span><span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">		result <span class="token operator">|=</span> a<span class="token punctuation">[</span>i<span class="token punctuation">]</span> <span class="token operator">^</span> b<span class="token punctuation">[</span>i<span class="token punctuation">]</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> result <span class="token operator">==</span> <span class="token number">0</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-数据库安全" tabindex="-1"><a class="header-anchor" href="#_2-数据库安全">#</a> 2. 数据库安全</h3>
<h4 id="postgresql安全配置" tabindex="-1"><a class="header-anchor" href="#postgresql安全配置">#</a> PostgreSQL安全配置</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- scripts/security-setup.sql</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建只读用户</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">USER</span> vgo_readonly <span class="token keyword">WITH</span> PASSWORD <span class="token string">'readonly_password'</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">CONNECT</span> <span class="token keyword">ON</span> <span class="token keyword">DATABASE</span> vgo_db <span class="token keyword">TO</span> vgo_readonly<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">USAGE</span> <span class="token keyword">ON</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">TO</span> vgo_readonly<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">SELECT</span> <span class="token keyword">ON</span> <span class="token keyword">ALL</span> <span class="token keyword">TABLES</span> <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">TO</span> vgo_readonly<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">DEFAULT</span> <span class="token keyword">PRIVILEGES</span> <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">GRANT</span> <span class="token keyword">SELECT</span> <span class="token keyword">ON</span> <span class="token keyword">TABLES</span> <span class="token keyword">TO</span> vgo_readonly<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建应用用户（限制权限）</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">USER</span> vgo_app <span class="token keyword">WITH</span> PASSWORD <span class="token string">'app_password'</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">CONNECT</span> <span class="token keyword">ON</span> <span class="token keyword">DATABASE</span> vgo_db <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">USAGE</span> <span class="token keyword">ON</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">SELECT</span><span class="token punctuation">,</span> <span class="token keyword">INSERT</span><span class="token punctuation">,</span> <span class="token keyword">UPDATE</span><span class="token punctuation">,</span> <span class="token keyword">DELETE</span> <span class="token keyword">ON</span> <span class="token keyword">ALL</span> <span class="token keyword">TABLES</span> <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">GRANT</span> <span class="token keyword">USAGE</span><span class="token punctuation">,</span> <span class="token keyword">SELECT</span> <span class="token keyword">ON</span> <span class="token keyword">ALL</span> SEQUENCES <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">DEFAULT</span> <span class="token keyword">PRIVILEGES</span> <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">GRANT</span> <span class="token keyword">SELECT</span><span class="token punctuation">,</span> <span class="token keyword">INSERT</span><span class="token punctuation">,</span> <span class="token keyword">UPDATE</span><span class="token punctuation">,</span> <span class="token keyword">DELETE</span> <span class="token keyword">ON</span> <span class="token keyword">TABLES</span> <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">DEFAULT</span> <span class="token keyword">PRIVILEGES</span> <span class="token operator">IN</span> <span class="token keyword">SCHEMA</span> <span class="token keyword">public</span> <span class="token keyword">GRANT</span> <span class="token keyword">USAGE</span><span class="token punctuation">,</span> <span class="token keyword">SELECT</span> <span class="token keyword">ON</span> SEQUENCES <span class="token keyword">TO</span> vgo_app<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 启用行级安全</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">TABLE</span> users <span class="token keyword">ENABLE</span> <span class="token keyword">ROW</span> <span class="token keyword">LEVEL</span> SECURITY<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">TABLE</span> policies <span class="token keyword">ENABLE</span> <span class="token keyword">ROW</span> <span class="token keyword">LEVEL</span> SECURITY<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ALTER</span> <span class="token keyword">TABLE</span> access_keys <span class="token keyword">ENABLE</span> <span class="token keyword">ROW</span> <span class="token keyword">LEVEL</span> SECURITY<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建行级安全策略</span></span>
<span class="line"><span class="token keyword">CREATE</span> POLICY user_isolation <span class="token keyword">ON</span> users</span>
<span class="line">    <span class="token keyword">FOR</span> <span class="token keyword">ALL</span> <span class="token keyword">TO</span> vgo_app</span>
<span class="line">    <span class="token keyword">USING</span> <span class="token punctuation">(</span>created_by <span class="token operator">=</span> current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_id'</span><span class="token punctuation">)</span>::uuid <span class="token operator">OR</span> </span>
<span class="line">           current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_role'</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token string">'admin'</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">CREATE</span> POLICY policy_isolation <span class="token keyword">ON</span> policies</span>
<span class="line">    <span class="token keyword">FOR</span> <span class="token keyword">ALL</span> <span class="token keyword">TO</span> vgo_app</span>
<span class="line">    <span class="token keyword">USING</span> <span class="token punctuation">(</span>created_by <span class="token operator">=</span> current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_id'</span><span class="token punctuation">)</span>::uuid <span class="token operator">OR</span> </span>
<span class="line">           current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_role'</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token string">'admin'</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建审计表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> audit_log <span class="token punctuation">(</span></span>
<span class="line">    id <span class="token keyword">SERIAL</span> <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span><span class="token punctuation">,</span></span>
<span class="line">    table_name <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    operation <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">10</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    old_values JSONB<span class="token punctuation">,</span></span>
<span class="line">    new_values JSONB<span class="token punctuation">,</span></span>
<span class="line">    user_id UUID<span class="token punctuation">,</span></span>
<span class="line">    user_ip INET<span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建审计触发器函数</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token operator">OR</span> <span class="token keyword">REPLACE</span> <span class="token keyword">FUNCTION</span> audit_trigger_function<span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">RETURNS</span> <span class="token keyword">TRIGGER</span> <span class="token keyword">AS</span> $$</span>
<span class="line"><span class="token keyword">BEGIN</span></span>
<span class="line">    <span class="token keyword">IF</span> TG_OP <span class="token operator">=</span> <span class="token string">'DELETE'</span> <span class="token keyword">THEN</span></span>
<span class="line">        <span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> audit_log <span class="token punctuation">(</span>table_name<span class="token punctuation">,</span> operation<span class="token punctuation">,</span> old_values<span class="token punctuation">,</span> user_id<span class="token punctuation">,</span> user_ip<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">VALUES</span> <span class="token punctuation">(</span>TG_TABLE_NAME<span class="token punctuation">,</span> TG_OP<span class="token punctuation">,</span> row_to_json<span class="token punctuation">(</span>OLD<span class="token punctuation">)</span><span class="token punctuation">,</span> </span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_id'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::uuid<span class="token punctuation">,</span></span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_ip'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::inet<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token keyword">RETURN</span> OLD<span class="token punctuation">;</span></span>
<span class="line">    ELSIF TG_OP <span class="token operator">=</span> <span class="token string">'UPDATE'</span> <span class="token keyword">THEN</span></span>
<span class="line">        <span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> audit_log <span class="token punctuation">(</span>table_name<span class="token punctuation">,</span> operation<span class="token punctuation">,</span> old_values<span class="token punctuation">,</span> new_values<span class="token punctuation">,</span> user_id<span class="token punctuation">,</span> user_ip<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">VALUES</span> <span class="token punctuation">(</span>TG_TABLE_NAME<span class="token punctuation">,</span> TG_OP<span class="token punctuation">,</span> row_to_json<span class="token punctuation">(</span>OLD<span class="token punctuation">)</span><span class="token punctuation">,</span> row_to_json<span class="token punctuation">(</span>NEW<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_id'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::uuid<span class="token punctuation">,</span></span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_ip'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::inet<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token keyword">RETURN</span> NEW<span class="token punctuation">;</span></span>
<span class="line">    ELSIF TG_OP <span class="token operator">=</span> <span class="token string">'INSERT'</span> <span class="token keyword">THEN</span></span>
<span class="line">        <span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> audit_log <span class="token punctuation">(</span>table_name<span class="token punctuation">,</span> operation<span class="token punctuation">,</span> new_values<span class="token punctuation">,</span> user_id<span class="token punctuation">,</span> user_ip<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">VALUES</span> <span class="token punctuation">(</span>TG_TABLE_NAME<span class="token punctuation">,</span> TG_OP<span class="token punctuation">,</span> row_to_json<span class="token punctuation">(</span>NEW<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_id'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::uuid<span class="token punctuation">,</span></span>
<span class="line">                current_setting<span class="token punctuation">(</span><span class="token string">'app.current_user_ip'</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span>::inet<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token keyword">RETURN</span> NEW<span class="token punctuation">;</span></span>
<span class="line">    <span class="token keyword">END</span> <span class="token keyword">IF</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token keyword">RETURN</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">END</span><span class="token punctuation">;</span></span>
<span class="line">$$ <span class="token keyword">LANGUAGE</span> plpgsql<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 为敏感表创建审计触发器</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TRIGGER</span> users_audit_trigger</span>
<span class="line">    <span class="token keyword">AFTER</span> <span class="token keyword">INSERT</span> <span class="token operator">OR</span> <span class="token keyword">UPDATE</span> <span class="token operator">OR</span> <span class="token keyword">DELETE</span> <span class="token keyword">ON</span> users</span>
<span class="line">    <span class="token keyword">FOR EACH ROW</span> <span class="token keyword">EXECUTE</span> <span class="token keyword">FUNCTION</span> audit_trigger_function<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TRIGGER</span> policies_audit_trigger</span>
<span class="line">    <span class="token keyword">AFTER</span> <span class="token keyword">INSERT</span> <span class="token operator">OR</span> <span class="token keyword">UPDATE</span> <span class="token operator">OR</span> <span class="token keyword">DELETE</span> <span class="token keyword">ON</span> policies</span>
<span class="line">    <span class="token keyword">FOR EACH ROW</span> <span class="token keyword">EXECUTE</span> <span class="token keyword">FUNCTION</span> audit_trigger_function<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TRIGGER</span> access_keys_audit_trigger</span>
<span class="line">    <span class="token keyword">AFTER</span> <span class="token keyword">INSERT</span> <span class="token operator">OR</span> <span class="token keyword">UPDATE</span> <span class="token operator">OR</span> <span class="token keyword">DELETE</span> <span class="token keyword">ON</span> access_keys</span>
<span class="line">    <span class="token keyword">FOR EACH ROW</span> <span class="token keyword">EXECUTE</span> <span class="token keyword">FUNCTION</span> audit_trigger_function<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔥-防火墙和网络安全" tabindex="-1"><a class="header-anchor" href="#🔥-防火墙和网络安全">#</a> 🔥 防火墙和网络安全</h2>
<h3 id="_1-iptables配置" tabindex="-1"><a class="header-anchor" href="#_1-iptables配置">#</a> 1. iptables配置</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/setup-firewall.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔥 配置防火墙规则..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清空现有规则</span></span>
<span class="line">iptables <span class="token parameter variable">-F</span></span>
<span class="line">iptables <span class="token parameter variable">-X</span></span>
<span class="line">iptables <span class="token parameter variable">-t</span> nat <span class="token parameter variable">-F</span></span>
<span class="line">iptables <span class="token parameter variable">-t</span> nat <span class="token parameter variable">-X</span></span>
<span class="line">iptables <span class="token parameter variable">-t</span> mangle <span class="token parameter variable">-F</span></span>
<span class="line">iptables <span class="token parameter variable">-t</span> mangle <span class="token parameter variable">-X</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 设置默认策略</span></span>
<span class="line">iptables <span class="token parameter variable">-P</span> INPUT DROP</span>
<span class="line">iptables <span class="token parameter variable">-P</span> FORWARD DROP</span>
<span class="line">iptables <span class="token parameter variable">-P</span> OUTPUT ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许本地回环</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-i</span> lo <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> OUTPUT <span class="token parameter variable">-o</span> lo <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许已建立的连接</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-m</span> state <span class="token parameter variable">--state</span> ESTABLISHED,RELATED <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许SSH（请根据实际端口修改）</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">22</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许HTTP和HTTPS</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">80</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">443</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许VGO服务端口</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">8080</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># HTTP API</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">50051</span> <span class="token parameter variable">-j</span> ACCEPT <span class="token comment"># gRPC</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">8081</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># Health Check</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">8082</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># Metrics</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许数据库连接（仅限内网）</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">10.0</span>.0.0/8 <span class="token parameter variable">--dport</span> <span class="token number">5432</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">172.16</span>.0.0/12 <span class="token parameter variable">--dport</span> <span class="token number">5432</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">192.168</span>.0.0/16 <span class="token parameter variable">--dport</span> <span class="token number">5432</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许Redis连接（仅限内网）</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">10.0</span>.0.0/8 <span class="token parameter variable">--dport</span> <span class="token number">6379</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">172.16</span>.0.0/12 <span class="token parameter variable">--dport</span> <span class="token number">6379</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">192.168</span>.0.0/16 <span class="token parameter variable">--dport</span> <span class="token number">6379</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 允许监控端口（仅限内网）</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">10.0</span>.0.0/8 <span class="token parameter variable">--dport</span> <span class="token number">9090</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># Prometheus</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">10.0</span>.0.0/8 <span class="token parameter variable">--dport</span> <span class="token number">3000</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># Grafana</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-s</span> <span class="token number">10.0</span>.0.0/8 <span class="token parameter variable">--dport</span> <span class="token number">9093</span> <span class="token parameter variable">-j</span> ACCEPT  <span class="token comment"># AlertManager</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 防止DDoS攻击</span></span>
<span class="line"><span class="token comment"># 限制新连接速率</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">80</span> <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">25</span>/minute --limit-burst <span class="token number">100</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">443</span> <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">25</span>/minute --limit-burst <span class="token number">100</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">8080</span> <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">25</span>/minute --limit-burst <span class="token number">100</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">50051</span> <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">25</span>/minute --limit-burst <span class="token number">100</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 防止端口扫描</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-m</span> recent <span class="token parameter variable">--name</span> portscan <span class="token parameter variable">--rcheck</span> <span class="token parameter variable">--seconds</span> <span class="token number">86400</span> <span class="token parameter variable">-j</span> DROP</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-m</span> recent <span class="token parameter variable">--name</span> portscan <span class="token parameter variable">--remove</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-m</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">139</span> <span class="token parameter variable">-m</span> recent <span class="token parameter variable">--name</span> portscan <span class="token parameter variable">--set</span> <span class="token parameter variable">-j</span> LOG --log-prefix <span class="token string">"portscan:"</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">-m</span> tcp <span class="token parameter variable">--dport</span> <span class="token number">139</span> <span class="token parameter variable">-m</span> recent <span class="token parameter variable">--name</span> portscan <span class="token parameter variable">--set</span> <span class="token parameter variable">-j</span> DROP</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 防止SYN洪水攻击</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--syn</span> <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">1</span>/s --limit-burst <span class="token number">3</span> <span class="token parameter variable">-j</span> RETURN</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> tcp <span class="token parameter variable">--syn</span> <span class="token parameter variable">-j</span> DROP</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 防止ping洪水攻击</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> icmp --icmp-type echo-request <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">1</span>/s --limit-burst <span class="token number">1</span> <span class="token parameter variable">-j</span> ACCEPT</span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-p</span> icmp --icmp-type echo-request <span class="token parameter variable">-j</span> DROP</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 记录被丢弃的包</span></span>
<span class="line">iptables <span class="token parameter variable">-A</span> INPUT <span class="token parameter variable">-m</span> limit <span class="token parameter variable">--limit</span> <span class="token number">5</span>/min <span class="token parameter variable">-j</span> LOG --log-prefix <span class="token string">"iptables denied: "</span> --log-level <span class="token number">7</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 保存规则</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> iptables-save <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    iptables-save <span class="token operator">></span> /etc/iptables/rules.v4</span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"✅ 防火墙配置完成！"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📋 当前规则："</span></span>
<span class="line">iptables <span class="token parameter variable">-L</span> <span class="token parameter variable">-n</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-fail2ban配置" tabindex="-1"><a class="header-anchor" href="#_2-fail2ban配置">#</a> 2. fail2ban配置</h3>
<div class="language-ini line-numbers-mode" data-highlighter="prismjs" data-ext="ini"><pre v-pre><code class="language-ini"><span class="line"><span class="token comment"># /etc/fail2ban/jail.local</span></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">DEFAULT</span><span class="token punctuation">]</span></span></span>
<span class="line"><span class="token key attr-name">bantime</span> <span class="token punctuation">=</span> <span class="token value attr-value">3600</span></span>
<span class="line"><span class="token key attr-name">findtime</span> <span class="token punctuation">=</span> <span class="token value attr-value">600</span></span>
<span class="line"><span class="token key attr-name">maxretry</span> <span class="token punctuation">=</span> <span class="token value attr-value">5</span></span>
<span class="line"><span class="token key attr-name">backend</span> <span class="token punctuation">=</span> <span class="token value attr-value">systemd</span></span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">sshd</span><span class="token punctuation">]</span></span></span>
<span class="line"><span class="token key attr-name">enabled</span> <span class="token punctuation">=</span> <span class="token value attr-value">true</span></span>
<span class="line"><span class="token key attr-name">port</span> <span class="token punctuation">=</span> <span class="token value attr-value">ssh</span></span>
<span class="line"><span class="token key attr-name">logpath</span> <span class="token punctuation">=</span> <span class="token value attr-value">/var/log/auth.log</span></span>
<span class="line"><span class="token key attr-name">maxretry</span> <span class="token punctuation">=</span> <span class="token value attr-value">3</span></span>
<span class="line"><span class="token key attr-name">bantime</span> <span class="token punctuation">=</span> <span class="token value attr-value">86400</span></span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">vgo-auth</span><span class="token punctuation">]</span></span></span>
<span class="line"><span class="token key attr-name">enabled</span> <span class="token punctuation">=</span> <span class="token value attr-value">true</span></span>
<span class="line"><span class="token key attr-name">port</span> <span class="token punctuation">=</span> <span class="token value attr-value">8080,50051</span></span>
<span class="line"><span class="token key attr-name">logpath</span> <span class="token punctuation">=</span> <span class="token value attr-value">/var/log/vgo/auth.log</span></span>
<span class="line"><span class="token key attr-name">failregex</span> <span class="token punctuation">=</span> <span class="token value attr-value">.*authentication failed.*from &lt;HOST></span></span>
<span class="line"><span class="token key attr-name">maxretry</span> <span class="token punctuation">=</span> <span class="token value attr-value">5</span></span>
<span class="line"><span class="token key attr-name">bantime</span> <span class="token punctuation">=</span> <span class="token value attr-value">3600</span></span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">vgo-api</span><span class="token punctuation">]</span></span></span>
<span class="line"><span class="token key attr-name">enabled</span> <span class="token punctuation">=</span> <span class="token value attr-value">true</span></span>
<span class="line"><span class="token key attr-name">port</span> <span class="token punctuation">=</span> <span class="token value attr-value">8080,50051</span></span>
<span class="line"><span class="token key attr-name">logpath</span> <span class="token punctuation">=</span> <span class="token value attr-value">/var/log/vgo/access.log</span></span>
<span class="line"><span class="token key attr-name">failregex</span> <span class="token punctuation">=</span> <span class="token value attr-value">.*"(GET|POST|PUT|DELETE).*" (4[0-9]{2}|5[0-9]{2}) .*&lt;HOST></span></span>
<span class="line"><span class="token key attr-name">maxretry</span> <span class="token punctuation">=</span> <span class="token value attr-value">20</span></span>
<span class="line"><span class="token key attr-name">bantime</span> <span class="token punctuation">=</span> <span class="token value attr-value">1800</span></span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">nginx-http-auth</span><span class="token punctuation">]</span></span></span>
<span class="line"><span class="token key attr-name">enabled</span> <span class="token punctuation">=</span> <span class="token value attr-value">true</span></span>
<span class="line"><span class="token key attr-name">port</span> <span class="token punctuation">=</span> <span class="token value attr-value">http,https</span></span>
<span class="line"><span class="token key attr-name">logpath</span> <span class="token punctuation">=</span> <span class="token value attr-value">/var/log/nginx/error.log</span></span>
<span class="line"><span class="token key attr-name">failregex</span> <span class="token punctuation">=</span> <span class="token value attr-value">no user/password was provided for basic authentication.*client: &lt;HOST></span></span>
<span class="line">            user .* was not found in.*client: &lt;HOST></span>
<span class="line">            user .* password mismatch.*client: &lt;HOST></span>
<span class="line"><span class="token key attr-name">maxretry</span> <span class="token punctuation">=</span> <span class="token value attr-value">3</span></span>
<span class="line"><span class="token key attr-name">bantime</span> <span class="token punctuation">=</span> <span class="token value attr-value">3600</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-安全监控和审计" tabindex="-1"><a class="header-anchor" href="#🔍-安全监控和审计">#</a> 🔍 安全监控和审计</h2>
<h3 id="_1-安全事件监控" tabindex="-1"><a class="header-anchor" href="#_1-安全事件监控">#</a> 1. 安全事件监控</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/security/monitor.go</span></span>
<span class="line"><span class="token keyword">package</span> security</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"log"</span></span>
<span class="line">	<span class="token string">"net"</span></span>
<span class="line">	<span class="token string">"strings"</span></span>
<span class="line">	<span class="token string">"time"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/metadata"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/peer"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// SecurityEvent 安全事件</span></span>
<span class="line"><span class="token keyword">type</span> SecurityEvent <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Type        <span class="token builtin">string</span>            <span class="token string">`json:"type"`</span></span>
<span class="line">	Severity    <span class="token builtin">string</span>            <span class="token string">`json:"severity"`</span></span>
<span class="line">	Message     <span class="token builtin">string</span>            <span class="token string">`json:"message"`</span></span>
<span class="line">	UserID      <span class="token builtin">string</span>            <span class="token string">`json:"user_id,omitempty"`</span></span>
<span class="line">	ClientIP    <span class="token builtin">string</span>            <span class="token string">`json:"client_ip"`</span></span>
<span class="line">	UserAgent   <span class="token builtin">string</span>            <span class="token string">`json:"user_agent,omitempty"`</span></span>
<span class="line">	Method      <span class="token builtin">string</span>            <span class="token string">`json:"method"`</span></span>
<span class="line">	Timestamp   time<span class="token punctuation">.</span>Time         <span class="token string">`json:"timestamp"`</span></span>
<span class="line">	Metadata    <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"metadata,omitempty"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// SecurityMonitor 安全监控器</span></span>
<span class="line"><span class="token keyword">type</span> SecurityMonitor <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	events <span class="token keyword">chan</span> SecurityEvent</span>
<span class="line">	logger <span class="token operator">*</span>log<span class="token punctuation">.</span>Logger</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// NewSecurityMonitor 创建安全监控器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewSecurityMonitor</span><span class="token punctuation">(</span>logger <span class="token operator">*</span>log<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token operator">*</span>SecurityMonitor <span class="token punctuation">{</span></span>
<span class="line">	m <span class="token operator">:=</span> <span class="token operator">&amp;</span>SecurityMonitor<span class="token punctuation">{</span></span>
<span class="line">		events<span class="token punctuation">:</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> SecurityEvent<span class="token punctuation">,</span> <span class="token number">1000</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		logger<span class="token punctuation">:</span> logger<span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token comment">// 启动事件处理器</span></span>
<span class="line">	<span class="token keyword">go</span> m<span class="token punctuation">.</span><span class="token function">processEvents</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> m</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// SecurityMonitorInterceptor 安全监控拦截器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">SecurityMonitorInterceptor</span><span class="token punctuation">(</span><span class="token punctuation">)</span> grpc<span class="token punctuation">.</span>UnaryServerInterceptor <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> info <span class="token operator">*</span>grpc<span class="token punctuation">.</span>UnaryServerInfo<span class="token punctuation">,</span> handler grpc<span class="token punctuation">.</span>UnaryHandler<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 获取客户端信息</span></span>
<span class="line">		clientIP <span class="token operator">:=</span> m<span class="token punctuation">.</span><span class="token function">getClientIP</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">		userAgent <span class="token operator">:=</span> m<span class="token punctuation">.</span><span class="token function">getUserAgent</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">		userID <span class="token operator">:=</span> m<span class="token punctuation">.</span><span class="token function">getUserID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 检测可疑活动</span></span>
<span class="line">		m<span class="token punctuation">.</span><span class="token function">detectSuspiciousActivity</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">,</span> clientIP<span class="token punctuation">,</span> userID<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 执行请求</span></span>
<span class="line">		resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 记录安全事件</span></span>
<span class="line">		<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			m<span class="token punctuation">.</span><span class="token function">logSecurityEvent</span><span class="token punctuation">(</span>SecurityEvent<span class="token punctuation">{</span></span>
<span class="line">				Type<span class="token punctuation">:</span>      <span class="token string">"request_failed"</span><span class="token punctuation">,</span></span>
<span class="line">				Severity<span class="token punctuation">:</span>  <span class="token string">"warning"</span><span class="token punctuation">,</span></span>
<span class="line">				Message<span class="token punctuation">:</span>   fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"Request failed: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">				UserID<span class="token punctuation">:</span>    userID<span class="token punctuation">,</span></span>
<span class="line">				ClientIP<span class="token punctuation">:</span>  clientIP<span class="token punctuation">,</span></span>
<span class="line">				UserAgent<span class="token punctuation">:</span> userAgent<span class="token punctuation">,</span></span>
<span class="line">				Method<span class="token punctuation">:</span>    info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">,</span></span>
<span class="line">				Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">				Metadata<span class="token punctuation">:</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">					<span class="token string">"duration"</span><span class="token punctuation">:</span> duration<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">					<span class="token string">"error"</span><span class="token punctuation">:</span>    err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">				<span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">			<span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token keyword">return</span> resp<span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// detectSuspiciousActivity 检测可疑活动</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">detectSuspiciousActivity</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> method<span class="token punctuation">,</span> clientIP<span class="token punctuation">,</span> userID <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 检测暴力破解</span></span>
<span class="line">	<span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> <span class="token string">"Login"</span><span class="token punctuation">)</span> <span class="token operator">||</span> strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> <span class="token string">"Auth"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token comment">// 这里可以实现更复杂的检测逻辑</span></span>
<span class="line">		<span class="token comment">// 例如：检查IP的登录失败次数、频率等</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token comment">// 检测异常IP</span></span>
<span class="line">	<span class="token keyword">if</span> m<span class="token punctuation">.</span><span class="token function">isAnomalousIP</span><span class="token punctuation">(</span>clientIP<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		m<span class="token punctuation">.</span><span class="token function">logSecurityEvent</span><span class="token punctuation">(</span>SecurityEvent<span class="token punctuation">{</span></span>
<span class="line">			Type<span class="token punctuation">:</span>      <span class="token string">"anomalous_ip"</span><span class="token punctuation">,</span></span>
<span class="line">			Severity<span class="token punctuation">:</span>  <span class="token string">"warning"</span><span class="token punctuation">,</span></span>
<span class="line">			Message<span class="token punctuation">:</span>   fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"Request from anomalous IP: %s"</span><span class="token punctuation">,</span> clientIP<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			UserID<span class="token punctuation">:</span>    userID<span class="token punctuation">,</span></span>
<span class="line">			ClientIP<span class="token punctuation">:</span>  clientIP<span class="token punctuation">,</span></span>
<span class="line">			Method<span class="token punctuation">:</span>    method<span class="token punctuation">,</span></span>
<span class="line">			Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		<span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token comment">// 检测权限提升尝试</span></span>
<span class="line">	<span class="token keyword">if</span> m<span class="token punctuation">.</span><span class="token function">isPrivilegeEscalationAttempt</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> userID<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		m<span class="token punctuation">.</span><span class="token function">logSecurityEvent</span><span class="token punctuation">(</span>SecurityEvent<span class="token punctuation">{</span></span>
<span class="line">			Type<span class="token punctuation">:</span>      <span class="token string">"privilege_escalation"</span><span class="token punctuation">,</span></span>
<span class="line">			Severity<span class="token punctuation">:</span>  <span class="token string">"critical"</span><span class="token punctuation">,</span></span>
<span class="line">			Message<span class="token punctuation">:</span>   fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"Privilege escalation attempt detected"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			UserID<span class="token punctuation">:</span>    userID<span class="token punctuation">,</span></span>
<span class="line">			ClientIP<span class="token punctuation">:</span>  clientIP<span class="token punctuation">,</span></span>
<span class="line">			Method<span class="token punctuation">:</span>    method<span class="token punctuation">,</span></span>
<span class="line">			Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		<span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// getClientIP 获取客户端IP</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">getClientIP</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	p<span class="token punctuation">,</span> ok <span class="token operator">:=</span> peer<span class="token punctuation">.</span><span class="token function">FromContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">"unknown"</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">if</span> addr<span class="token punctuation">,</span> ok <span class="token operator">:=</span> p<span class="token punctuation">.</span>Addr<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>net<span class="token punctuation">.</span>TCPAddr<span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> addr<span class="token punctuation">.</span>IP<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> p<span class="token punctuation">.</span>Addr<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// getUserAgent 获取用户代理</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">getUserAgent</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	md<span class="token punctuation">,</span> ok <span class="token operator">:=</span> metadata<span class="token punctuation">.</span><span class="token function">FromIncomingContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	userAgent <span class="token operator">:=</span> md<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"user-agent"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>userAgent<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> userAgent<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// getUserID 获取用户ID</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">getUserID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> userID<span class="token punctuation">,</span> ok <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> userID</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// isAnomalousIP 检查是否为异常IP</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">isAnomalousIP</span><span class="token punctuation">(</span>ip <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 这里可以实现IP信誉检查、地理位置检查等</span></span>
<span class="line">	<span class="token comment">// 例如：检查是否来自已知的恶意IP段、Tor网络等</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// isPrivilegeEscalationAttempt 检查是否为权限提升尝试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">isPrivilegeEscalationAttempt</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> userID <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 检查用户是否尝试访问超出其权限的方法</span></span>
<span class="line">	<span class="token comment">// 这里需要结合用户角色和方法权限进行判断</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// logSecurityEvent 记录安全事件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">logSecurityEvent</span><span class="token punctuation">(</span>event SecurityEvent<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">case</span> m<span class="token punctuation">.</span>events <span class="token operator">&lt;-</span> event<span class="token punctuation">:</span></span>
<span class="line">	<span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">		m<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"Security event channel full, dropping event: %+v"</span><span class="token punctuation">,</span> event<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// processEvents 处理安全事件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">processEvents</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">for</span> event <span class="token operator">:=</span> <span class="token keyword">range</span> m<span class="token punctuation">.</span>events <span class="token punctuation">{</span></span>
<span class="line">		<span class="token comment">// 记录到日志</span></span>
<span class="line">		m<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"Security Event: %+v"</span><span class="token punctuation">,</span> event<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 发送到SIEM系统</span></span>
<span class="line">		m<span class="token punctuation">.</span><span class="token function">sendToSIEM</span><span class="token punctuation">(</span>event<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 触发告警</span></span>
<span class="line">		<span class="token keyword">if</span> event<span class="token punctuation">.</span>Severity <span class="token operator">==</span> <span class="token string">"critical"</span> <span class="token punctuation">{</span></span>
<span class="line">			m<span class="token punctuation">.</span><span class="token function">triggerAlert</span><span class="token punctuation">(</span>event<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// sendToSIEM 发送到SIEM系统</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">sendToSIEM</span><span class="token punctuation">(</span>event SecurityEvent<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 实现发送到SIEM系统的逻辑</span></span>
<span class="line">	<span class="token comment">// 例如：发送到Elasticsearch、Splunk等</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// triggerAlert 触发告警</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>SecurityMonitor<span class="token punctuation">)</span> <span class="token function">triggerAlert</span><span class="token punctuation">(</span>event SecurityEvent<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 实现告警逻辑</span></span>
<span class="line">	<span class="token comment">// 例如：发送邮件、Slack通知、调用Webhook等</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-审计日志配置" tabindex="-1"><a class="header-anchor" href="#_2-审计日志配置">#</a> 2. 审计日志配置</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/audit/logger.go</span></span>
<span class="line"><span class="token keyword">package</span> audit</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"encoding/json"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"log"</span></span>
<span class="line">	<span class="token string">"time"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/metadata"</span></span>
<span class="line">	<span class="token string">"google.golang.org/grpc/peer"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// AuditLog 审计日志</span></span>
<span class="line"><span class="token keyword">type</span> AuditLog <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	ID          <span class="token builtin">string</span>            <span class="token string">`json:"id"`</span></span>
<span class="line">	Timestamp   time<span class="token punctuation">.</span>Time         <span class="token string">`json:"timestamp"`</span></span>
<span class="line">	UserID      <span class="token builtin">string</span>            <span class="token string">`json:"user_id"`</span></span>
<span class="line">	Username    <span class="token builtin">string</span>            <span class="token string">`json:"username"`</span></span>
<span class="line">	ClientIP    <span class="token builtin">string</span>            <span class="token string">`json:"client_ip"`</span></span>
<span class="line">	UserAgent   <span class="token builtin">string</span>            <span class="token string">`json:"user_agent"`</span></span>
<span class="line">	Method      <span class="token builtin">string</span>            <span class="token string">`json:"method"`</span></span>
<span class="line">	Request     <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span>       <span class="token string">`json:"request,omitempty"`</span></span>
<span class="line">	Response    <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span>       <span class="token string">`json:"response,omitempty"`</span></span>
<span class="line">	Error       <span class="token builtin">string</span>            <span class="token string">`json:"error,omitempty"`</span></span>
<span class="line">	Duration    time<span class="token punctuation">.</span>Duration     <span class="token string">`json:"duration"`</span></span>
<span class="line">	Metadata    <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`json:"metadata,omitempty"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// AuditLogger 审计日志记录器</span></span>
<span class="line"><span class="token keyword">type</span> AuditLogger <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	logger <span class="token operator">*</span>log<span class="token punctuation">.</span>Logger</span>
<span class="line">	config AuditConfig</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// AuditConfig 审计配置</span></span>
<span class="line"><span class="token keyword">type</span> AuditConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Enabled         <span class="token builtin">bool</span>     <span class="token string">`yaml:"enabled"`</span></span>
<span class="line">	LogRequests     <span class="token builtin">bool</span>     <span class="token string">`yaml:"log_requests"`</span></span>
<span class="line">	LogResponses    <span class="token builtin">bool</span>     <span class="token string">`yaml:"log_responses"`</span></span>
<span class="line">	SensitiveFields <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`yaml:"sensitive_fields"`</span></span>
<span class="line">	ExcludeMethods  <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span> <span class="token string">`yaml:"exclude_methods"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// NewAuditLogger 创建审计日志记录器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewAuditLogger</span><span class="token punctuation">(</span>logger <span class="token operator">*</span>log<span class="token punctuation">.</span>Logger<span class="token punctuation">,</span> config AuditConfig<span class="token punctuation">)</span> <span class="token operator">*</span>AuditLogger <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token operator">&amp;</span>AuditLogger<span class="token punctuation">{</span></span>
<span class="line">		logger<span class="token punctuation">:</span> logger<span class="token punctuation">,</span></span>
<span class="line">		config<span class="token punctuation">:</span> config<span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// AuditInterceptor 审计拦截器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">AuditInterceptor</span><span class="token punctuation">(</span><span class="token punctuation">)</span> grpc<span class="token punctuation">.</span>UnaryServerInterceptor <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> info <span class="token operator">*</span>grpc<span class="token punctuation">.</span>UnaryServerInfo<span class="token punctuation">,</span> handler grpc<span class="token punctuation">.</span>UnaryHandler<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token operator">!</span>a<span class="token punctuation">.</span>config<span class="token punctuation">.</span>Enabled <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 检查是否需要排除此方法</span></span>
<span class="line">		<span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> excludeMethod <span class="token operator">:=</span> <span class="token keyword">range</span> a<span class="token punctuation">.</span>config<span class="token punctuation">.</span>ExcludeMethods <span class="token punctuation">{</span></span>
<span class="line">			<span class="token keyword">if</span> info<span class="token punctuation">.</span>FullMethod <span class="token operator">==</span> excludeMethod <span class="token punctuation">{</span></span>
<span class="line">				<span class="token keyword">return</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">			<span class="token punctuation">}</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 创建审计日志</span></span>
<span class="line">		auditLog <span class="token operator">:=</span> AuditLog<span class="token punctuation">{</span></span>
<span class="line">			ID<span class="token punctuation">:</span>        <span class="token function">generateAuditID</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			Timestamp<span class="token punctuation">:</span> start<span class="token punctuation">,</span></span>
<span class="line">			UserID<span class="token punctuation">:</span>    a<span class="token punctuation">.</span><span class="token function">getUserID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			Username<span class="token punctuation">:</span>  a<span class="token punctuation">.</span><span class="token function">getUsername</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			ClientIP<span class="token punctuation">:</span>  a<span class="token punctuation">.</span><span class="token function">getClientIP</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			UserAgent<span class="token punctuation">:</span> a<span class="token punctuation">.</span><span class="token function">getUserAgent</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">			Method<span class="token punctuation">:</span>    info<span class="token punctuation">.</span>FullMethod<span class="token punctuation">,</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 记录请求</span></span>
<span class="line">		<span class="token keyword">if</span> a<span class="token punctuation">.</span>config<span class="token punctuation">.</span>LogRequests <span class="token punctuation">{</span></span>
<span class="line">			auditLog<span class="token punctuation">.</span>Request <span class="token operator">=</span> a<span class="token punctuation">.</span><span class="token function">sanitizeData</span><span class="token punctuation">(</span>req<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 执行请求</span></span>
<span class="line">		resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">handler</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		auditLog<span class="token punctuation">.</span>Duration <span class="token operator">=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 记录响应</span></span>
<span class="line">		<span class="token keyword">if</span> a<span class="token punctuation">.</span>config<span class="token punctuation">.</span>LogResponses <span class="token operator">&amp;&amp;</span> resp <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			auditLog<span class="token punctuation">.</span>Response <span class="token operator">=</span> a<span class="token punctuation">.</span><span class="token function">sanitizeData</span><span class="token punctuation">(</span>resp<span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 记录错误</span></span>
<span class="line">		<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">			auditLog<span class="token punctuation">.</span>Error <span class="token operator">=</span> err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">		</span>
<span class="line">		<span class="token comment">// 输出审计日志</span></span>
<span class="line">		a<span class="token punctuation">.</span><span class="token function">writeAuditLog</span><span class="token punctuation">(</span>auditLog<span class="token punctuation">)</span></span>
<span class="line">		</span>
<span class="line">		<span class="token keyword">return</span> resp<span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// sanitizeData 清理敏感数据</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">sanitizeData</span><span class="token punctuation">(</span>data <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token comment">// 将数据转换为JSON，然后清理敏感字段</span></span>
<span class="line">	jsonData<span class="token punctuation">,</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>data<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> data</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">var</span> result <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Unmarshal</span><span class="token punctuation">(</span>jsonData<span class="token punctuation">,</span> <span class="token operator">&amp;</span>result<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> data</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token comment">// 清理敏感字段</span></span>
<span class="line">	<span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> field <span class="token operator">:=</span> <span class="token keyword">range</span> a<span class="token punctuation">.</span>config<span class="token punctuation">.</span>SensitiveFields <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">if</span> <span class="token boolean">_</span><span class="token punctuation">,</span> exists <span class="token operator">:=</span> result<span class="token punctuation">[</span>field<span class="token punctuation">]</span><span class="token punctuation">;</span> exists <span class="token punctuation">{</span></span>
<span class="line">			result<span class="token punctuation">[</span>field<span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token string">"[REDACTED]"</span></span>
<span class="line">		<span class="token punctuation">}</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> result</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// writeAuditLog 写入审计日志</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">writeAuditLog</span><span class="token punctuation">(</span>auditLog AuditLog<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	jsonData<span class="token punctuation">,</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>auditLog<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		a<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"Failed to marshal audit log: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">		<span class="token keyword">return</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	a<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Printf</span><span class="token punctuation">(</span><span class="token string">"AUDIT: %s"</span><span class="token punctuation">,</span> <span class="token function">string</span><span class="token punctuation">(</span>jsonData<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 辅助方法</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">getUserID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> userID<span class="token punctuation">,</span> ok <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> userID</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">getUsername</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> username<span class="token punctuation">,</span> ok <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"username"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> username</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">getClientIP</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	p<span class="token punctuation">,</span> ok <span class="token operator">:=</span> peer<span class="token punctuation">.</span><span class="token function">FromContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">"unknown"</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">if</span> addr<span class="token punctuation">,</span> ok <span class="token operator">:=</span> p<span class="token punctuation">.</span>Addr<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>net<span class="token punctuation">.</span>TCPAddr<span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> addr<span class="token punctuation">.</span>IP<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> p<span class="token punctuation">.</span>Addr<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>a <span class="token operator">*</span>AuditLogger<span class="token punctuation">)</span> <span class="token function">getUserAgent</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	md<span class="token punctuation">,</span> ok <span class="token operator">:=</span> metadata<span class="token punctuation">.</span><span class="token function">FromIncomingContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>ok <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	userAgent <span class="token operator">:=</span> md<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"user-agent"</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>userAgent<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> userAgent<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	</span>
<span class="line">	<span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">generateAuditID</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%d"</span><span class="token punctuation">,</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">UnixNano</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-安全告警配置" tabindex="-1"><a class="header-anchor" href="#🚨-安全告警配置">#</a> 🚨 安全告警配置</h2>
<h3 id="_1-alertmanager配置" tabindex="-1"><a class="header-anchor" href="#_1-alertmanager配置">#</a> 1. AlertManager配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># config/alertmanager.yml</span></span>
<span class="line"><span class="token key atrule">global</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">smtp_smarthost</span><span class="token punctuation">:</span> <span class="token string">'localhost:587'</span></span>
<span class="line">  <span class="token key atrule">smtp_from</span><span class="token punctuation">:</span> <span class="token string">'alerts@vgo.local'</span></span>
<span class="line">  <span class="token key atrule">smtp_auth_username</span><span class="token punctuation">:</span> <span class="token string">'alerts@vgo.local'</span></span>
<span class="line">  <span class="token key atrule">smtp_auth_password</span><span class="token punctuation">:</span> <span class="token string">'password'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">route</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">group_by</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'alertname'</span><span class="token punctuation">]</span></span>
<span class="line">  <span class="token key atrule">group_wait</span><span class="token punctuation">:</span> 10s</span>
<span class="line">  <span class="token key atrule">group_interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">  <span class="token key atrule">repeat_interval</span><span class="token punctuation">:</span> 1h</span>
<span class="line">  <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'web.hook'</span></span>
<span class="line">  <span class="token key atrule">routes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">match</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'critical-alerts'</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">match</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'warning-alerts'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">receivers</span><span class="token punctuation">:</span></span>
<span class="line"><span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'web.hook'</span></span>
<span class="line">  <span class="token key atrule">webhook_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">url</span><span class="token punctuation">:</span> <span class="token string">'http://127.0.0.1:5001/'</span></span>
<span class="line"></span>
<span class="line"><span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'critical-alerts'</span></span>
<span class="line">  <span class="token key atrule">email_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token string">'security@vgo.local'</span></span>
<span class="line">    <span class="token key atrule">subject</span><span class="token punctuation">:</span> <span class="token string">'🚨 VGO Critical Security Alert'</span></span>
<span class="line">    <span class="token key atrule">body</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">      Alert: {{ .GroupLabels.alertname }}</span>
<span class="line">      Severity: {{ .CommonLabels.severity }}</span>
<span class="line">      Instance: {{ .CommonLabels.instance }}</span>
<span class="line">      Description: {{ .CommonAnnotations.description }}</span></span>
<span class="line">      </span>
<span class="line">      <span class="token key atrule">Time</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .CommonAnnotations.timestamp <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">  <span class="token key atrule">slack_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">api_url</span><span class="token punctuation">:</span> <span class="token string">'YOUR_SLACK_WEBHOOK_URL'</span></span>
<span class="line">    <span class="token key atrule">channel</span><span class="token punctuation">:</span> <span class="token string">'#security-alerts'</span></span>
<span class="line">    <span class="token key atrule">title</span><span class="token punctuation">:</span> <span class="token string">'🚨 Critical Security Alert'</span></span>
<span class="line">    <span class="token key atrule">text</span><span class="token punctuation">:</span> <span class="token string">'{{ .CommonAnnotations.description }}'</span></span>
<span class="line"></span>
<span class="line"><span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'warning-alerts'</span></span>
<span class="line">  <span class="token key atrule">email_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token string">'ops@vgo.local'</span></span>
<span class="line">    <span class="token key atrule">subject</span><span class="token punctuation">:</span> <span class="token string">'⚠️ VGO Security Warning'</span></span>
<span class="line">    <span class="token key atrule">body</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">      Alert: {{ .GroupLabels.alertname }}</span>
<span class="line">      Severity: {{ .CommonLabels.severity }}</span>
<span class="line">      Instance: {{ .CommonLabels.instance }}</span>
<span class="line">      Description: {{ .CommonAnnotations.description }}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-prometheus告警规则" tabindex="-1"><a class="header-anchor" href="#_2-prometheus告警规则">#</a> 2. Prometheus告警规则</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># config/security-alerts.yml</span></span>
<span class="line"><span class="token key atrule">groups</span><span class="token punctuation">:</span></span>
<span class="line"><span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> security.rules</span>
<span class="line">  <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 认证失败告警</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighAuthenticationFailureRate</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> rate(vgo_auth_failures_total<span class="token punctuation">[</span>5m<span class="token punctuation">]</span>) <span class="token punctuation">></span> 0.1</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 2m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High authentication failure rate detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Authentication failure rate is {{ $value }} failures/sec"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 权限拒绝告警</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighPermissionDeniedRate</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> rate(vgo_permission_denied_total<span class="token punctuation">[</span>5m<span class="token punctuation">]</span>) <span class="token punctuation">></span> 0.05</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 2m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High permission denied rate detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Permission denied rate is {{ $value }} denials/sec"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 异常IP访问</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> AnomalousIPAccess</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> vgo_anomalous_ip_access_total <span class="token punctuation">></span> 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 0m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Anomalous IP access detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Access from anomalous IP: {{ $labels.client_ip }}"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 权限提升尝试</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> PrivilegeEscalationAttempt</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> vgo_privilege_escalation_attempts_total <span class="token punctuation">></span> 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 0m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Privilege escalation attempt detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"User {{ $labels.user_id }} attempted privilege escalation"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 服务不可用</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> ServiceDown</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> up<span class="token punctuation">{</span>job="vgo<span class="token punctuation">-</span>iam"<span class="token punctuation">}</span> == 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 1m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM service is down"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM service has been down for more than 1 minute"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 高错误率</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighErrorRate</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> rate(vgo_requests_total<span class="token punctuation">{</span>status=~"5.."<span class="token punctuation">}</span><span class="token punctuation">[</span>5m<span class="token punctuation">]</span>) <span class="token punctuation">></span> 0.1</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 2m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High error rate detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Error rate is {{ $value }} errors/sec"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 数据库连接失败</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> DatabaseConnectionFailure</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> vgo_database_connection_failures_total <span class="token punctuation">></span> 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 0m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Database connection failure"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Failed to connect to database"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 磁盘空间不足</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> DiskSpaceLow</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 &lt; 10</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Disk space is running low"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Disk space is {{ $value }}% full"</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 内存使用率过高</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighMemoryUsage</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> (1 <span class="token punctuation">-</span> (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 <span class="token punctuation">></span> 90</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High memory usage detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Memory usage is {{ $value }}%"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-密钥管理" tabindex="-1"><a class="header-anchor" href="#🔐-密钥管理">#</a> 🔐 密钥管理</h2>
<h3 id="_1-hashicorp-vault集成" tabindex="-1"><a class="header-anchor" href="#_1-hashicorp-vault集成">#</a> 1. HashiCorp Vault集成</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/vault/client.go</span></span>
<span class="line"><span class="token keyword">package</span> vault</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"fmt"</span></span>
<span class="line">	<span class="token string">"time"</span></span>
<span class="line"></span>
<span class="line">	vaultapi <span class="token string">"github.com/hashicorp/vault/api"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// VaultConfig Vault配置</span></span>
<span class="line"><span class="token keyword">type</span> VaultConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	Address   <span class="token builtin">string</span> <span class="token string">`yaml:"address"`</span></span>
<span class="line">	Token     <span class="token builtin">string</span> <span class="token string">`yaml:"token"`</span></span>
<span class="line">	Namespace <span class="token builtin">string</span> <span class="token string">`yaml:"namespace"`</span></span>
<span class="line">	Timeout   time<span class="token punctuation">.</span>Duration <span class="token string">`yaml:"timeout"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// VaultClient Vault客户端</span></span>
<span class="line"><span class="token keyword">type</span> VaultClient <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	client <span class="token operator">*</span>vaultapi<span class="token punctuation">.</span>Client</span>
<span class="line">	config VaultConfig</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// NewVaultClient 创建Vault客户端</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewVaultClient</span><span class="token punctuation">(</span>config VaultConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>VaultClient<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	vaultConfig <span class="token operator">:=</span> vaultapi<span class="token punctuation">.</span><span class="token function">DefaultConfig</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">	vaultConfig<span class="token punctuation">.</span>Address <span class="token operator">=</span> config<span class="token punctuation">.</span>Address</span>
<span class="line">	vaultConfig<span class="token punctuation">.</span>Timeout <span class="token operator">=</span> config<span class="token punctuation">.</span>Timeout</span>
<span class="line"></span>
<span class="line">	client<span class="token punctuation">,</span> err <span class="token operator">:=</span> vaultapi<span class="token punctuation">.</span><span class="token function">NewClient</span><span class="token punctuation">(</span>vaultConfig<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to create vault client: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	client<span class="token punctuation">.</span><span class="token function">SetToken</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>Token<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> config<span class="token punctuation">.</span>Namespace <span class="token operator">!=</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">		client<span class="token punctuation">.</span><span class="token function">SetNamespace</span><span class="token punctuation">(</span>config<span class="token punctuation">.</span>Namespace<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token operator">&amp;</span>VaultClient<span class="token punctuation">{</span></span>
<span class="line">		client<span class="token punctuation">:</span> client<span class="token punctuation">,</span></span>
<span class="line">		config<span class="token punctuation">:</span> config<span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// GetSecret 获取密钥</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>v <span class="token operator">*</span>VaultClient<span class="token punctuation">)</span> <span class="token function">GetSecret</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> path <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	secret<span class="token punctuation">,</span> err <span class="token operator">:=</span> v<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">Logical</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">ReadWithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> path<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to read secret: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">if</span> secret <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"secret not found at path: %s"</span><span class="token punctuation">,</span> path<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> secret<span class="token punctuation">.</span>Data<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// PutSecret 存储密钥</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>v <span class="token operator">*</span>VaultClient<span class="token punctuation">)</span> <span class="token function">PutSecret</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> path <span class="token builtin">string</span><span class="token punctuation">,</span> data <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> v<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">Logical</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">WriteWithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> path<span class="token punctuation">,</span> data<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to write secret: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// DeleteSecret 删除密钥</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>v <span class="token operator">*</span>VaultClient<span class="token punctuation">)</span> <span class="token function">DeleteSecret</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> path <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> v<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">Logical</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">DeleteWithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> path<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to delete secret: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// RenewToken 续期Token</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>v <span class="token operator">*</span>VaultClient<span class="token punctuation">)</span> <span class="token function">RenewToken</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> v<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">Auth</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Token</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">RenewSelfWithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to renew token: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-密钥轮换脚本" tabindex="-1"><a class="header-anchor" href="#_2-密钥轮换脚本">#</a> 2. 密钥轮换脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/rotate-keys.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">VAULT_ADDR</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${VAULT_ADDR<span class="token operator">:-</span>http<span class="token operator">:</span><span class="token operator">/</span><span class="token operator">/</span>localhost<span class="token operator">:</span>8200}</span>"</span></span>
<span class="line"><span class="token assign-left variable">VAULT_TOKEN</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${VAULT_TOKEN}</span>"</span></span>
<span class="line"><span class="token assign-left variable">KEY_PATH</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${KEY_PATH<span class="token operator">:-</span>secret<span class="token operator">/</span>vgo}</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔄 开始密钥轮换..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Vault连接</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token operator">!</span> vault status <span class="token operator">></span> /dev/null <span class="token operator"><span class="token file-descriptor important">2</span>></span><span class="token file-descriptor important">&amp;1</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ 无法连接到Vault服务器"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成新的JWT密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔑 生成新的JWT密钥..."</span></span>
<span class="line"><span class="token assign-left variable">NEW_JWT_SECRET</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>openssl rand <span class="token parameter variable">-base64</span> <span class="token number">32</span><span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成新的加密密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔐 生成新的加密密钥..."</span></span>
<span class="line"><span class="token assign-left variable">NEW_ENCRYPTION_KEY</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>openssl rand <span class="token parameter variable">-base64</span> <span class="token number">32</span><span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 备份当前密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"💾 备份当前密钥..."</span></span>
<span class="line"><span class="token assign-left variable">BACKUP_PATH</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${KEY_PATH}</span>/backup/<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span>"</span></span>
<span class="line">vault kv put <span class="token string">"<span class="token variable">${BACKUP_PATH}</span>"</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token assign-left variable">jwt_secret</span><span class="token operator">=</span><span class="token string">"<span class="token variable"><span class="token variable">$(</span>vault kv get <span class="token parameter variable">-field</span><span class="token operator">=</span>jwt_secret $<span class="token punctuation">{</span>KEY_PATH<span class="token punctuation">}</span><span class="token variable">)</span></span>"</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token assign-left variable">encryption_key</span><span class="token operator">=</span><span class="token string">"<span class="token variable"><span class="token variable">$(</span>vault kv get <span class="token parameter variable">-field</span><span class="token operator">=</span>encryption_key $<span class="token punctuation">{</span>KEY_PATH<span class="token punctuation">}</span><span class="token variable">)</span></span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 更新密钥</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔄 更新密钥..."</span></span>
<span class="line">vault kv put <span class="token string">"<span class="token variable">${KEY_PATH}</span>"</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token assign-left variable">jwt_secret</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${NEW_JWT_SECRET}</span>"</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token assign-left variable">encryption_key</span><span class="token operator">=</span><span class="token string">"<span class="token variable">${NEW_ENCRYPTION_KEY}</span>"</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token assign-left variable">rotated_at</span><span class="token operator">=</span><span class="token string">"<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> <span class="token parameter variable">-u</span> +%Y-%m-%dT%H:%M:%SZ<span class="token variable">)</span></span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 通知应用重新加载配置</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📡 通知应用重新加载配置..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> kubectl <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    kubectl rollout restart deployment/vgo-iam</span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token comment"># 发送SIGHUP信号重新加载配置</span></span>
<span class="line">    <span class="token function">pkill</span> <span class="token parameter variable">-HUP</span> vgo-iam <span class="token operator">||</span> <span class="token boolean">true</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"✅ 密钥轮换完成！"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📋 备份路径: <span class="token variable">${BACKUP_PATH}</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛡️-安全最佳实践" tabindex="-1"><a class="header-anchor" href="#🛡️-安全最佳实践">#</a> 🛡️ 安全最佳实践</h2>
<h3 id="_1-生产环境安全清单" tabindex="-1"><a class="header-anchor" href="#_1-生产环境安全清单">#</a> 1. 生产环境安全清单</h3>
<ul>
<li>
<p>[ ] <strong>认证和授权</strong></p>
<ul>
<li>[ ] 启用强密码策略</li>
<li>[ ] 配置多因素认证（MFA）</li>
<li>[ ] 实施最小权限原则</li>
<li>[ ] 定期审查用户权限</li>
<li>[ ] 配置会话超时</li>
</ul>
</li>
<li>
<p>[ ] <strong>网络安全</strong></p>
<ul>
<li>[ ] 配置防火墙规则</li>
<li>[ ] 启用TLS/SSL加密</li>
<li>[ ] 实施网络分段</li>
<li>[ ] 配置DDoS防护</li>
<li>[ ] 启用入侵检测系统</li>
</ul>
</li>
<li>
<p>[ ] <strong>数据保护</strong></p>
<ul>
<li>[ ] 加密敏感数据</li>
<li>[ ] 配置数据备份</li>
<li>[ ] 实施数据脱敏</li>
<li>[ ] 配置访问日志</li>
<li>[ ] 定期数据清理</li>
</ul>
</li>
<li>
<p>[ ] <strong>系统安全</strong></p>
<ul>
<li>[ ] 定期安全更新</li>
<li>[ ] 配置安全监控</li>
<li>[ ] 实施漏洞扫描</li>
<li>[ ] 配置安全告警</li>
<li>[ ] 定期安全审计</li>
</ul>
</li>
<li>
<p>[ ] <strong>运维安全</strong></p>
<ul>
<li>[ ] 限制管理员权限</li>
<li>[ ] 配置审计日志</li>
<li>[ ] 实施变更管理</li>
<li>[ ] 配置备份验证</li>
<li>[ ] 制定应急响应计划</li>
</ul>
</li>
</ul>
<h3 id="_2-安全配置验证" tabindex="-1"><a class="header-anchor" href="#_2-安全配置验证">#</a> 2. 安全配置验证</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/security-check.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 开始安全配置检查..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查TLS配置</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📋 检查TLS配置..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"certs/server-cert.pem"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ 服务器证书存在"</span></span>
<span class="line">    <span class="token comment"># 检查证书有效期</span></span>
<span class="line">    <span class="token assign-left variable">EXPIRY</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>openssl x509 <span class="token parameter variable">-in</span> certs/server-cert.pem <span class="token parameter variable">-noout</span> <span class="token parameter variable">-enddate</span> <span class="token operator">|</span> <span class="token function">cut</span> <span class="token parameter variable">-d</span><span class="token operator">=</span> <span class="token parameter variable">-f2</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"📅 证书过期时间: <span class="token variable">$EXPIRY</span>"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ 服务器证书不存在"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查密钥权限</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔐 检查密钥文件权限..."</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">file</span> <span class="token keyword">in</span> certs/*.pem<span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"<span class="token variable">$file</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token assign-left variable">PERMS</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">stat</span> <span class="token parameter variable">-c</span> <span class="token string">"%a"</span> <span class="token string">"<span class="token variable">$file</span>"</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$PERMS</span>"</span> <span class="token operator">=</span> <span class="token string">"600"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">            <span class="token builtin class-name">echo</span> <span class="token string">"✅ <span class="token variable">$file</span> 权限正确 (<span class="token variable">$PERMS</span>)"</span></span>
<span class="line">        <span class="token keyword">else</span></span>
<span class="line">            <span class="token builtin class-name">echo</span> <span class="token string">"⚠️ <span class="token variable">$file</span> 权限不安全 (<span class="token variable">$PERMS</span>)，建议设置为600"</span></span>
<span class="line">        <span class="token keyword">fi</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查防火墙状态</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔥 检查防火墙状态..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> ufw <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token assign-left variable">UFW_STATUS</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>ufw status <span class="token operator">|</span> <span class="token function">head</span> <span class="token parameter variable">-1</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"📊 UFW状态: <span class="token variable">$UFW_STATUS</span>"</span></span>
<span class="line"><span class="token keyword">elif</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> iptables <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token assign-left variable">IPTABLES_RULES</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>iptables <span class="token parameter variable">-L</span> <span class="token operator">|</span> <span class="token function">wc</span> <span class="token parameter variable">-l</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"📊 iptables规则数量: <span class="token variable">$IPTABLES_RULES</span>"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务状态</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🚀 检查服务状态..."</span></span>
<span class="line"><span class="token assign-left variable">SERVICES</span><span class="token operator">=</span><span class="token punctuation">(</span><span class="token string">"vgo-iam"</span> <span class="token string">"postgresql"</span> <span class="token string">"redis"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">service</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">${SERVICES<span class="token punctuation">[</span>@<span class="token punctuation">]</span>}</span>"</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token keyword">if</span> systemctl is-active <span class="token parameter variable">--quiet</span> <span class="token string">"<span class="token variable">$service</span>"</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"✅ <span class="token variable">$service</span> 服务运行正常"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"❌ <span class="token variable">$service</span> 服务未运行"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查日志配置</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📝 检查日志配置..."</span></span>
<span class="line"><span class="token assign-left variable">LOG_DIRS</span><span class="token operator">=</span><span class="token punctuation">(</span><span class="token string">"/var/log/vgo"</span> <span class="token string">"/var/log/audit"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">dir</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">${LOG_DIRS<span class="token punctuation">[</span>@<span class="token punctuation">]</span>}</span>"</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-d</span> <span class="token string">"<span class="token variable">$dir</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"✅ 日志目录存在: <span class="token variable">$dir</span>"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"⚠️ 日志目录不存在: <span class="token variable">$dir</span>"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查备份配置</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"💾 检查备份配置..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"/etc/cron.d/vgo-backup"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ 备份计划任务已配置"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"⚠️ 备份计划任务未配置"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🎉 安全配置检查完成！"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
<li><RouteLink to="/deployment/docker-compose.html">Docker Compose部署</RouteLink></li>
<li><RouteLink to="/deployment/kubernetes.html">Kubernetes部署</RouteLink></li>
<li><RouteLink to="/deployment/monitoring.html">监控配置</RouteLink></li>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/guide/quick-start.html">快速开始</RouteLink></li>
</ul>
</div></template>


