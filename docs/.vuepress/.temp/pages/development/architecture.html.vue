<template><div><h1 id="架构设计" tabindex="-1"><a class="header-anchor" href="#架构设计">#</a> 架构设计</h1>
<p>VGO微服务采用现代化的微服务架构设计，本文档详细介绍了系统的整体架构、设计原则、技术选型和各个组件的职责。</p>
<h2 id="🏗️-整体架构" tabindex="-1"><a class="header-anchor" href="#🏗️-整体架构">#</a> 🏗️ 整体架构</h2>
<h3 id="系统架构图" tabindex="-1"><a class="header-anchor" href="#系统架构图">#</a> 系统架构图</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"客户端层 (Client Layer)"</span></span>
<span class="line">        A<span class="token text string">[Web应用]</span></span>
<span class="line">        B<span class="token text string">[移动应用]</span></span>
<span class="line">        C<span class="token text string">[第三方应用]</span></span>
<span class="line">        D<span class="token text string">[CLI工具]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"接入层 (Gateway Layer)"</span></span>
<span class="line">        E<span class="token text string">[API网关]</span></span>
<span class="line">        F<span class="token text string">[负载均衡器]</span></span>
<span class="line">        G<span class="token text string">[防火墙/WAF]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"服务层 (Service Layer)"</span></span>
<span class="line">        H<span class="token text string">[认证服务]</span></span>
<span class="line">        I<span class="token text string">[用户管理服务]</span></span>
<span class="line">        J<span class="token text string">[策略管理服务]</span></span>
<span class="line">        K<span class="token text string">[权限验证服务]</span></span>
<span class="line">        L<span class="token text string">[访问密钥服务]</span></span>
<span class="line">        M<span class="token text string">[应用管理服务]</span></span>
<span class="line">        N<span class="token text string">[审计日志服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据层 (Data Layer)"</span></span>
<span class="line">        O<span class="token text string">[PostgreSQL主库]</span></span>
<span class="line">        P<span class="token text string">[PostgreSQL从库]</span></span>
<span class="line">        Q<span class="token text string">[Redis缓存]</span></span>
<span class="line">        R<span class="token text string">[NATS消息队列]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"基础设施层 (Infrastructure Layer)"</span></span>
<span class="line">        S<span class="token text string">[监控系统]</span></span>
<span class="line">        T<span class="token text string">[日志系统]</span></span>
<span class="line">        U<span class="token text string">[配置中心]</span></span>
<span class="line">        V<span class="token text string">[服务发现]</span></span>
<span class="line">        W<span class="token text string">[容器编排]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> E</span>
<span class="line">    B <span class="token arrow operator">--></span> E</span>
<span class="line">    C <span class="token arrow operator">--></span> E</span>
<span class="line">    D <span class="token arrow operator">--></span> E</span>
<span class="line">    E <span class="token arrow operator">--></span> F</span>
<span class="line">    F <span class="token arrow operator">--></span> G</span>
<span class="line">    G <span class="token arrow operator">--></span> H</span>
<span class="line">    G <span class="token arrow operator">--></span> I</span>
<span class="line">    G <span class="token arrow operator">--></span> J</span>
<span class="line">    G <span class="token arrow operator">--></span> K</span>
<span class="line">    G <span class="token arrow operator">--></span> L</span>
<span class="line">    G <span class="token arrow operator">--></span> M</span>
<span class="line">    G <span class="token arrow operator">--></span> N</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> O</span>
<span class="line">    I <span class="token arrow operator">--></span> O</span>
<span class="line">    J <span class="token arrow operator">--></span> O</span>
<span class="line">    K <span class="token arrow operator">--></span> Q</span>
<span class="line">    L <span class="token arrow operator">--></span> O</span>
<span class="line">    M <span class="token arrow operator">--></span> O</span>
<span class="line">    N <span class="token arrow operator">--></span> O</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> P</span>
<span class="line">    I <span class="token arrow operator">--></span> P</span>
<span class="line">    J <span class="token arrow operator">--></span> P</span>
<span class="line">    L <span class="token arrow operator">--></span> P</span>
<span class="line">    M <span class="token arrow operator">--></span> P</span>
<span class="line">    N <span class="token arrow operator">--></span> P</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> R</span>
<span class="line">    I <span class="token arrow operator">--></span> R</span>
<span class="line">    J <span class="token arrow operator">--></span> R</span>
<span class="line">    K <span class="token arrow operator">--></span> R</span>
<span class="line">    L <span class="token arrow operator">--></span> R</span>
<span class="line">    M <span class="token arrow operator">--></span> R</span>
<span class="line">    N <span class="token arrow operator">--></span> R</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> S</span>
<span class="line">    I <span class="token arrow operator">--></span> S</span>
<span class="line">    J <span class="token arrow operator">--></span> S</span>
<span class="line">    K <span class="token arrow operator">--></span> S</span>
<span class="line">    L <span class="token arrow operator">--></span> S</span>
<span class="line">    M <span class="token arrow operator">--></span> S</span>
<span class="line">    N <span class="token arrow operator">--></span> S</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> T</span>
<span class="line">    I <span class="token arrow operator">--></span> T</span>
<span class="line">    J <span class="token arrow operator">--></span> T</span>
<span class="line">    K <span class="token arrow operator">--></span> T</span>
<span class="line">    L <span class="token arrow operator">--></span> T</span>
<span class="line">    M <span class="token arrow operator">--></span> T</span>
<span class="line">    N <span class="token arrow operator">--></span> T</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="架构分层" tabindex="-1"><a class="header-anchor" href="#架构分层">#</a> 架构分层</h3>
<table>
<thead>
<tr>
<th>层级</th>
<th>职责</th>
<th>技术栈</th>
</tr>
</thead>
<tbody>
<tr>
<td>客户端层</td>
<td>用户交互界面</td>
<td>Web/Mobile/CLI</td>
</tr>
<tr>
<td>接入层</td>
<td>流量接入、路由、安全</td>
<td>Nginx, Envoy, Istio</td>
</tr>
<tr>
<td>服务层</td>
<td>业务逻辑处理</td>
<td>Go, gRPC, HTTP</td>
</tr>
<tr>
<td>数据层</td>
<td>数据存储和消息传递</td>
<td>PostgreSQL, Redis, NATS</td>
</tr>
<tr>
<td>基础设施层</td>
<td>运维支撑服务</td>
<td>Kubernetes, Prometheus, ELK</td>
</tr>
</tbody>
</table>
<h2 id="🎯-设计原则" tabindex="-1"><a class="header-anchor" href="#🎯-设计原则">#</a> 🎯 设计原则</h2>
<h3 id="_1-单一职责原则-srp" tabindex="-1"><a class="header-anchor" href="#_1-单一职责原则-srp">#</a> 1. 单一职责原则 (SRP)</h3>
<p>每个微服务只负责一个业务领域：</p>
<ul>
<li><strong>用户管理服务</strong>: 用户的CRUD操作</li>
<li><strong>策略管理服务</strong>: 权限策略的管理</li>
<li><strong>权限验证服务</strong>: 权限检查和决策</li>
<li><strong>访问密钥服务</strong>: API密钥的生命周期管理</li>
<li><strong>应用管理服务</strong>: 应用注册和配置</li>
</ul>
<h3 id="_2-开闭原则-ocp" tabindex="-1"><a class="header-anchor" href="#_2-开闭原则-ocp">#</a> 2. 开闭原则 (OCP)</h3>
<p>系统对扩展开放，对修改关闭：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 权限验证接口，支持多种验证策略</span></span>
<span class="line"><span class="token keyword">type</span> PermissionChecker <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CheckPermissionRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>CheckPermissionResponse<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// RBAC权限检查器</span></span>
<span class="line"><span class="token keyword">type</span> RBACChecker <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    policyRepo PolicyRepository</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// ABAC权限检查器</span></span>
<span class="line"><span class="token keyword">type</span> ABACChecker <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    ruleEngine RuleEngine</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 可以轻松添加新的权限检查策略</span></span>
<span class="line"><span class="token keyword">type</span> CustomChecker <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    customLogic CustomLogic</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-依赖倒置原则-dip" tabindex="-1"><a class="header-anchor" href="#_3-依赖倒置原则-dip">#</a> 3. 依赖倒置原则 (DIP)</h3>
<p>高层模块不依赖低层模块，都依赖抽象：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 服务层依赖抽象接口</span></span>
<span class="line"><span class="token keyword">type</span> UserService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    repo   UserRepository    <span class="token comment">// 抽象接口</span></span>
<span class="line">    cache  CacheService     <span class="token comment">// 抽象接口</span></span>
<span class="line">    logger Logger           <span class="token comment">// 抽象接口</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 具体实现在基础设施层</span></span>
<span class="line"><span class="token keyword">type</span> PostgreSQLUserRepository <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> RedisCache <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    client <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-接口隔离原则-isp" tabindex="-1"><a class="header-anchor" href="#_4-接口隔离原则-isp">#</a> 4. 接口隔离原则 (ISP)</h3>
<p>客户端不应该依赖它不需要的接口：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 细粒度接口设计</span></span>
<span class="line"><span class="token keyword">type</span> UserReader <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">GetUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">ListUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> opts ListOptions<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> UserWriter <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">UpdateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">DeleteUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 组合接口</span></span>
<span class="line"><span class="token keyword">type</span> UserRepository <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    UserReader</span>
<span class="line">    UserWriter</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-技术选型" tabindex="-1"><a class="header-anchor" href="#🔧-技术选型">#</a> 🔧 技术选型</h2>
<h3 id="编程语言和框架" tabindex="-1"><a class="header-anchor" href="#编程语言和框架">#</a> 编程语言和框架</h3>
<table>
<thead>
<tr>
<th>技术</th>
<th>版本</th>
<th>选择理由</th>
</tr>
</thead>
<tbody>
<tr>
<td>Go</td>
<td>1.21+</td>
<td>高性能、并发友好、生态丰富</td>
</tr>
<tr>
<td>gRPC</td>
<td>1.58+</td>
<td>高效的RPC框架，支持多语言</td>
</tr>
<tr>
<td>Protocol Buffers</td>
<td>3.21+</td>
<td>高效的序列化协议</td>
</tr>
<tr>
<td>Gin</td>
<td>1.9+</td>
<td>轻量级HTTP框架</td>
</tr>
<tr>
<td>Zap</td>
<td>1.25+</td>
<td>高性能结构化日志</td>
</tr>
</tbody>
</table>
<h3 id="数据存储" tabindex="-1"><a class="header-anchor" href="#数据存储">#</a> 数据存储</h3>
<table>
<thead>
<tr>
<th>技术</th>
<th>版本</th>
<th>用途</th>
<th>选择理由</th>
</tr>
</thead>
<tbody>
<tr>
<td>PostgreSQL</td>
<td>15+</td>
<td>主数据库</td>
<td>ACID特性、JSON支持、扩展性好</td>
</tr>
<tr>
<td>Redis</td>
<td>7+</td>
<td>缓存、会话</td>
<td>高性能、丰富的数据结构</td>
</tr>
<tr>
<td>NATS</td>
<td>2.9+</td>
<td>消息队列</td>
<td>轻量级、高性能、云原生</td>
</tr>
</tbody>
</table>
<h3 id="基础设施" tabindex="-1"><a class="header-anchor" href="#基础设施">#</a> 基础设施</h3>
<table>
<thead>
<tr>
<th>技术</th>
<th>版本</th>
<th>用途</th>
<th>选择理由</th>
</tr>
</thead>
<tbody>
<tr>
<td>Docker</td>
<td>24+</td>
<td>容器化</td>
<td>标准化部署、环境一致性</td>
</tr>
<tr>
<td>Kubernetes</td>
<td>1.28+</td>
<td>容器编排</td>
<td>自动化运维、弹性伸缩</td>
</tr>
<tr>
<td>Prometheus</td>
<td>2.45+</td>
<td>监控</td>
<td>云原生监控标准</td>
</tr>
<tr>
<td>Grafana</td>
<td>10+</td>
<td>可视化</td>
<td>丰富的图表和仪表板</td>
</tr>
<tr>
<td>Jaeger</td>
<td>1.49+</td>
<td>链路追踪</td>
<td>分布式追踪标准</td>
</tr>
</tbody>
</table>
<h2 id="🏛️-服务架构" tabindex="-1"><a class="header-anchor" href="#🏛️-服务架构">#</a> 🏛️ 服务架构</h2>
<h3 id="服务拆分策略" tabindex="-1"><a class="header-anchor" href="#服务拆分策略">#</a> 服务拆分策略</h3>
<h4 id="按业务领域拆分" tabindex="-1"><a class="header-anchor" href="#按业务领域拆分">#</a> 按业务领域拆分</h4>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> LR</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"身份认证域"</span></span>
<span class="line">        A<span class="token text string">[认证服务]</span></span>
<span class="line">        B<span class="token text string">[用户管理服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"权限管理域"</span></span>
<span class="line">        C<span class="token text string">[策略管理服务]</span></span>
<span class="line">        D<span class="token text string">[权限验证服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"应用管理域"</span></span>
<span class="line">        E<span class="token text string">[应用管理服务]</span></span>
<span class="line">        F<span class="token text string">[访问密钥服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"审计域"</span></span>
<span class="line">        G<span class="token text string">[审计日志服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="服务职责矩阵" tabindex="-1"><a class="header-anchor" href="#服务职责矩阵">#</a> 服务职责矩阵</h4>
<table>
<thead>
<tr>
<th>服务</th>
<th>核心职责</th>
<th>数据模型</th>
<th>依赖服务</th>
</tr>
</thead>
<tbody>
<tr>
<td>认证服务</td>
<td>用户登录、Token管理</td>
<td>Session, Token</td>
<td>用户管理服务</td>
</tr>
<tr>
<td>用户管理服务</td>
<td>用户CRUD、用户信息</td>
<td>User, Profile</td>
<td>-</td>
</tr>
<tr>
<td>策略管理服务</td>
<td>策略CRUD、策略解析</td>
<td>Policy, Rule</td>
<td>-</td>
</tr>
<tr>
<td>权限验证服务</td>
<td>权限检查、决策引擎</td>
<td>Permission, Decision</td>
<td>策略管理服务</td>
</tr>
<tr>
<td>应用管理服务</td>
<td>应用注册、配置管理</td>
<td>Application, Config</td>
<td>-</td>
</tr>
<tr>
<td>访问密钥服务</td>
<td>密钥生成、生命周期</td>
<td>AccessKey, Secret</td>
<td>用户管理服务</td>
</tr>
<tr>
<td>审计日志服务</td>
<td>操作记录、合规审计</td>
<td>AuditLog, Event</td>
<td>所有服务</td>
</tr>
</tbody>
</table>
<h3 id="数据一致性策略" tabindex="-1"><a class="header-anchor" href="#数据一致性策略">#</a> 数据一致性策略</h3>
<h4 id="_1-强一致性场景" tabindex="-1"><a class="header-anchor" href="#_1-强一致性场景">#</a> 1. 强一致性场景</h4>
<p>使用数据库事务保证ACID特性：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 用户创建时同时创建默认策略</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">CreateUserWithDefaultPolicy</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> s<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">WithTransaction</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>tx <span class="token operator">*</span>sql<span class="token punctuation">.</span>Tx<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 创建用户</span></span>
<span class="line">        user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>userRepo<span class="token punctuation">.</span><span class="token function">CreateWithTx</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> tx<span class="token punctuation">,</span> req<span class="token punctuation">.</span>User<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 创建默认策略</span></span>
<span class="line">        policy <span class="token operator">:=</span> <span class="token operator">&amp;</span>Policy<span class="token punctuation">{</span></span>
<span class="line">            UserID<span class="token punctuation">:</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">,</span></span>
<span class="line">            Name<span class="token punctuation">:</span>   <span class="token string">"default"</span><span class="token punctuation">,</span></span>
<span class="line">            Rules<span class="token punctuation">:</span>  defaultRules<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">return</span> s<span class="token punctuation">.</span>policyRepo<span class="token punctuation">.</span><span class="token function">CreateWithTx</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> tx<span class="token punctuation">,</span> policy<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-最终一致性场景" tabindex="-1"><a class="header-anchor" href="#_2-最终一致性场景">#</a> 2. 最终一致性场景</h4>
<p>使用事件驱动架构：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 用户状态变更事件</span></span>
<span class="line"><span class="token keyword">type</span> UserStatusChangedEvent <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    UserID    <span class="token builtin">string</span>    <span class="token string">`json:"user_id"`</span></span>
<span class="line">    OldStatus <span class="token builtin">string</span>    <span class="token string">`json:"old_status"`</span></span>
<span class="line">    NewStatus <span class="token builtin">string</span>    <span class="token string">`json:"new_status"`</span></span>
<span class="line">    Timestamp time<span class="token punctuation">.</span>Time <span class="token string">`json:"timestamp"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 发布事件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">UpdateUserStatus</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userID<span class="token punctuation">,</span> status <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 更新用户状态</span></span>
<span class="line">    err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">UpdateStatus</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userID<span class="token punctuation">,</span> status<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 发布状态变更事件</span></span>
<span class="line">    event <span class="token operator">:=</span> UserStatusChangedEvent<span class="token punctuation">{</span></span>
<span class="line">        UserID<span class="token punctuation">:</span>    userID<span class="token punctuation">,</span></span>
<span class="line">        NewStatus<span class="token punctuation">:</span> status<span class="token punctuation">,</span></span>
<span class="line">        Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> s<span class="token punctuation">.</span>eventBus<span class="token punctuation">.</span><span class="token function">Publish</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"user.status.changed"</span><span class="token punctuation">,</span> event<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 其他服务订阅事件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>PolicyService<span class="token punctuation">)</span> <span class="token function">HandleUserStatusChanged</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> event UserStatusChangedEvent<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> event<span class="token punctuation">.</span>NewStatus <span class="token operator">==</span> <span class="token string">"disabled"</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 禁用用户的所有策略</span></span>
<span class="line">        <span class="token keyword">return</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">DisableUserPolicies</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> event<span class="token punctuation">.</span>UserID<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔄-通信模式" tabindex="-1"><a class="header-anchor" href="#🔄-通信模式">#</a> 🔄 通信模式</h2>
<h3 id="_1-同步通信-grpc" tabindex="-1"><a class="header-anchor" href="#_1-同步通信-grpc">#</a> 1. 同步通信 (gRPC)</h3>
<p>用于需要立即响应的场景：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 权限检查 - 同步调用</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>AuthMiddleware<span class="token punctuation">)</span> <span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userID<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> action <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    req <span class="token operator">:=</span> <span class="token operator">&amp;</span>pb<span class="token punctuation">.</span>CheckPermissionRequest<span class="token punctuation">{</span></span>
<span class="line">        UserId<span class="token punctuation">:</span>   userID<span class="token punctuation">,</span></span>
<span class="line">        Resource<span class="token punctuation">:</span> resource<span class="token punctuation">,</span></span>
<span class="line">        Action<span class="token punctuation">:</span>   action<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>permissionClient<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token operator">!</span>resp<span class="token punctuation">.</span>Allowed <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"permission denied"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-异步通信-消息队列" tabindex="-1"><a class="header-anchor" href="#_2-异步通信-消息队列">#</a> 2. 异步通信 (消息队列)</h3>
<p>用于事件通知和后台处理：</p>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 审计日志 - 异步处理</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>AuditService<span class="token punctuation">)</span> <span class="token function">LogUserAction</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> action UserAction<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    event <span class="token operator">:=</span> AuditEvent<span class="token punctuation">{</span></span>
<span class="line">        UserID<span class="token punctuation">:</span>    action<span class="token punctuation">.</span>UserID<span class="token punctuation">,</span></span>
<span class="line">        Action<span class="token punctuation">:</span>    action<span class="token punctuation">.</span>Type<span class="token punctuation">,</span></span>
<span class="line">        Resource<span class="token punctuation">:</span>  action<span class="token punctuation">.</span>Resource<span class="token punctuation">,</span></span>
<span class="line">        Timestamp<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        Metadata<span class="token punctuation">:</span>  action<span class="token punctuation">.</span>Metadata<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 异步发送到消息队列</span></span>
<span class="line">    <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>messageQueue<span class="token punctuation">.</span><span class="token function">Publish</span><span class="token punctuation">(</span><span class="token string">"audit.user.action"</span><span class="token punctuation">,</span> event<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Failed to publish audit event"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-请求-响应模式" tabindex="-1"><a class="header-anchor" href="#_3-请求-响应模式">#</a> 3. 请求-响应模式</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 用户信息查询</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">GetUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>pb<span class="token punctuation">.</span>GetUserRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>pb<span class="token punctuation">.</span>GetUserResponse<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 参数验证</span></span>
<span class="line">    <span class="token keyword">if</span> req<span class="token punctuation">.</span>UserId <span class="token operator">==</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>InvalidArgument<span class="token punctuation">,</span> <span class="token string">"user_id is required"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 从缓存获取</span></span>
<span class="line">    <span class="token keyword">if</span> user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">.</span>UserId<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token operator">&amp;</span>pb<span class="token punctuation">.</span>GetUserResponse<span class="token punctuation">{</span>User<span class="token punctuation">:</span> user<span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 从数据库获取</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">GetByID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">.</span>UserId<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> errors<span class="token punctuation">.</span><span class="token function">Is</span><span class="token punctuation">(</span>err<span class="token punctuation">,</span> repository<span class="token punctuation">.</span>ErrNotFound<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>NotFound<span class="token punctuation">,</span> <span class="token string">"user not found"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>Internal<span class="token punctuation">,</span> <span class="token string">"failed to get user: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 更新缓存</span></span>
<span class="line">    <span class="token keyword">go</span> s<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">SetUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>pb<span class="token punctuation">.</span>GetUserResponse<span class="token punctuation">{</span>User<span class="token punctuation">:</span> user<span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🗄️-数据架构" tabindex="-1"><a class="header-anchor" href="#🗄️-数据架构">#</a> 🗄️ 数据架构</h2>
<h3 id="数据库设计" tabindex="-1"><a class="header-anchor" href="#数据库设计">#</a> 数据库设计</h3>
<h4 id="_1-用户管理数据模型" tabindex="-1"><a class="header-anchor" href="#_1-用户管理数据模型">#</a> 1. 用户管理数据模型</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 用户表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> users <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    username <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    email <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    password_hash <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    profile JSONB<span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    deleted_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE</span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 用户角色关联表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> user_roles <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    user_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    role_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> roles<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    granted_by UUID <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    granted_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    expires_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE<span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">UNIQUE</span><span class="token punctuation">(</span>user_id<span class="token punctuation">,</span> role_id<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-策略管理数据模型" tabindex="-1"><a class="header-anchor" href="#_2-策略管理数据模型">#</a> 2. 策略管理数据模型</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 策略表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> policies <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    name <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">100</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    description <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    document JSONB <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    version <span class="token keyword">INTEGER</span> <span class="token keyword">DEFAULT</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    created_by UUID <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 策略附加表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> policy_attachments <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    policy_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> policies<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    principal_type <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span> <span class="token comment">-- 'user', 'role', 'group'</span></span>
<span class="line">    principal_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    attached_by UUID <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    attached_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">UNIQUE</span><span class="token punctuation">(</span>policy_id<span class="token punctuation">,</span> principal_type<span class="token punctuation">,</span> principal_id<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-访问密钥数据模型" tabindex="-1"><a class="header-anchor" href="#_3-访问密钥数据模型">#</a> 3. 访问密钥数据模型</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 访问密钥表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> access_keys <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    access_key_id <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    secret_access_key_hash <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    user_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    description <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    last_used_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE<span class="token punctuation">,</span></span>
<span class="line">    expires_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE<span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 访问密钥使用记录表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> access_key_usage <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> gen_random_uuid<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    access_key_id <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">20</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> access_keys<span class="token punctuation">(</span>access_key_id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    service <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">action</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">100</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    resource <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    client_ip INET<span class="token punctuation">,</span></span>
<span class="line">    user_agent <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    success <span class="token keyword">BOOLEAN</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    error_message <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="缓存策略" tabindex="-1"><a class="header-anchor" href="#缓存策略">#</a> 缓存策略</h3>
<h4 id="_1-多级缓存架构" tabindex="-1"><a class="header-anchor" href="#_1-多级缓存架构">#</a> 1. 多级缓存架构</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 缓存接口</span></span>
<span class="line"><span class="token keyword">type</span> CacheService <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">Get</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">Set</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">,</span> value <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> ttl time<span class="token punctuation">.</span>Duration<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">Delete</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">Exists</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">bool</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 多级缓存实现</span></span>
<span class="line"><span class="token keyword">type</span> MultiLevelCache <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    l1Cache <span class="token operator">*</span>sync<span class="token punctuation">.</span>Map        <span class="token comment">// 内存缓存</span></span>
<span class="line">    l2Cache <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client    <span class="token comment">// Redis缓存</span></span>
<span class="line">    l3Cache Database         <span class="token comment">// 数据库</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">Get</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// L1: 内存缓存</span></span>
<span class="line">    <span class="token keyword">if</span> value<span class="token punctuation">,</span> ok <span class="token operator">:=</span> c<span class="token punctuation">.</span>l1Cache<span class="token punctuation">.</span><span class="token function">Load</span><span class="token punctuation">(</span>key<span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> value<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// L2: Redis缓存</span></span>
<span class="line">    value<span class="token punctuation">,</span> err <span class="token operator">:=</span> c<span class="token punctuation">.</span>l2Cache<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Bytes</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 回填L1缓存</span></span>
<span class="line">        c<span class="token punctuation">.</span>l1Cache<span class="token punctuation">.</span><span class="token function">Store</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> value<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// L3: 数据库</span></span>
<span class="line">    value<span class="token punctuation">,</span> err <span class="token operator">=</span> c<span class="token punctuation">.</span>l3Cache<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 回填缓存</span></span>
<span class="line">    c<span class="token punctuation">.</span>l1Cache<span class="token punctuation">.</span><span class="token function">Store</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">    c<span class="token punctuation">.</span>l2Cache<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">,</span> value<span class="token punctuation">,</span> time<span class="token punctuation">.</span>Hour<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> value<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-缓存更新策略" tabindex="-1"><a class="header-anchor" href="#_2-缓存更新策略">#</a> 2. 缓存更新策略</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 写入时更新缓存</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">UpdateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 更新数据库</span></span>
<span class="line">    err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">Update</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 更新缓存</span></span>
<span class="line">    cacheKey <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"user:%s"</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    userData<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>user<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 异步更新缓存，避免影响主流程</span></span>
<span class="line">    <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> cacheKey<span class="token punctuation">,</span> userData<span class="token punctuation">,</span> time<span class="token punctuation">.</span>Hour<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Failed to update cache"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 缓存失效策略</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">InvalidateUserCache</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userID <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    keys <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"user:%s"</span><span class="token punctuation">,</span> userID<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"user:profile:%s"</span><span class="token punctuation">,</span> userID<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"user:permissions:%s"</span><span class="token punctuation">,</span> userID<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> key <span class="token operator">:=</span> <span class="token keyword">range</span> keys <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>cache<span class="token punctuation">.</span><span class="token function">Delete</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Warn</span><span class="token punctuation">(</span><span class="token string">"Failed to delete cache key"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"key"</span><span class="token punctuation">,</span> key<span class="token punctuation">)</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔒-安全架构" tabindex="-1"><a class="header-anchor" href="#🔒-安全架构">#</a> 🔒 安全架构</h2>
<h3 id="认证流程" tabindex="-1"><a class="header-anchor" href="#认证流程">#</a> 认证流程</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">sequenceDiagram</span></span>
<span class="line">    <span class="token keyword">participant</span> C as 客户端</span>
<span class="line">    <span class="token keyword">participant</span> G as API网关</span>
<span class="line">    <span class="token keyword">participant</span> A as 认证服务</span>
<span class="line">    <span class="token keyword">participant</span> U as 用户服务</span>
<span class="line">    <span class="token keyword">participant</span> R as Redis</span>
<span class="line">    </span>
<span class="line">    C<span class="token arrow operator">->></span>G<span class="token operator">:</span> 登录请求 <span class="token text string">(username/password)</span></span>
<span class="line">    G<span class="token arrow operator">->></span>A<span class="token operator">:</span> 转发认证请求</span>
<span class="line">    A<span class="token arrow operator">->></span>U<span class="token operator">:</span> 验证用户凭据</span>
<span class="line">    U<span class="token arrow operator">-->></span>A<span class="token operator">:</span> 返回用户信息</span>
<span class="line">    A<span class="token arrow operator">->></span>R<span class="token operator">:</span> 创建会话</span>
<span class="line">    A<span class="token arrow operator">->></span>A<span class="token operator">:</span> 生成JWT Token</span>
<span class="line">    A<span class="token arrow operator">-->></span>G<span class="token operator">:</span> 返回Token</span>
<span class="line">    G<span class="token arrow operator">-->></span>C<span class="token operator">:</span> 返回认证结果</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">Note over</span> C,R<span class="token operator">:</span> 后续API调用</span>
<span class="line">    C<span class="token arrow operator">->></span>G<span class="token operator">:</span> API请求 <span class="token text string">(Bearer Token)</span></span>
<span class="line">    G<span class="token arrow operator">->></span>G<span class="token operator">:</span> 验证JWT Token</span>
<span class="line">    G<span class="token arrow operator">->></span>A<span class="token operator">:</span> 检查会话状态</span>
<span class="line">    A<span class="token arrow operator">->></span>R<span class="token operator">:</span> 查询会话</span>
<span class="line">    R<span class="token arrow operator">-->></span>A<span class="token operator">:</span> 返回会话信息</span>
<span class="line">    A<span class="token arrow operator">-->></span>G<span class="token operator">:</span> 会话有效</span>
<span class="line">    G<span class="token arrow operator">->></span>G<span class="token operator">:</span> 提取用户信息</span>
<span class="line">    G<span class="token arrow operator">->></span>+<span class="token operator">:</span> 转发到目标服务</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="授权流程" tabindex="-1"><a class="header-anchor" href="#授权流程">#</a> 授权流程</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">sequenceDiagram</span></span>
<span class="line">    <span class="token keyword">participant</span> C as 客户端</span>
<span class="line">    <span class="token keyword">participant</span> G as API网关</span>
<span class="line">    <span class="token keyword">participant</span> P as 权限服务</span>
<span class="line">    <span class="token keyword">participant</span> S as 策略服务</span>
<span class="line">    <span class="token keyword">participant</span> Cache as Redis缓存</span>
<span class="line">    </span>
<span class="line">    C<span class="token arrow operator">->></span>G<span class="token operator">:</span> API请求 <span class="token text string">(已认证)</span></span>
<span class="line">    G<span class="token arrow operator">->></span>P<span class="token operator">:</span> 权限检查请求</span>
<span class="line">    P<span class="token arrow operator">->></span>Cache<span class="token operator">:</span> 查询权限缓存</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">alt</span> 缓存命中</span>
<span class="line">        Cache<span class="token arrow operator">-->></span>P<span class="token operator">:</span> 返回权限结果</span>
<span class="line">    <span class="token keyword">else</span> 缓存未命中</span>
<span class="line">        P<span class="token arrow operator">->></span>S<span class="token operator">:</span> 获取用户策略</span>
<span class="line">        S<span class="token arrow operator">-->></span>P<span class="token operator">:</span> 返回策略列表</span>
<span class="line">        P<span class="token arrow operator">->></span>P<span class="token operator">:</span> 执行权限决策</span>
<span class="line">        P<span class="token arrow operator">->></span>Cache<span class="token operator">:</span> 缓存权限结果</span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    P<span class="token arrow operator">-->></span>G<span class="token operator">:</span> 返回权限决策</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">alt</span> 权限允许</span>
<span class="line">        G<span class="token arrow operator">->></span>+<span class="token operator">:</span> 转发到目标服务</span>
<span class="line">    <span class="token keyword">else</span> 权限拒绝</span>
<span class="line">        G<span class="token arrow operator">-->></span>C<span class="token operator">:</span> 返回403错误</span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-监控架构" tabindex="-1"><a class="header-anchor" href="#📊-监控架构">#</a> 📊 监控架构</h2>
<h3 id="监控体系" tabindex="-1"><a class="header-anchor" href="#监控体系">#</a> 监控体系</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"应用层监控"</span></span>
<span class="line">        A<span class="token text string">[业务指标]</span></span>
<span class="line">        B<span class="token text string">[性能指标]</span></span>
<span class="line">        C<span class="token text string">[错误指标]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"基础设施监控"</span></span>
<span class="line">        D<span class="token text string">[系统指标]</span></span>
<span class="line">        E<span class="token text string">[网络指标]</span></span>
<span class="line">        F<span class="token text string">[存储指标]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"日志监控"</span></span>
<span class="line">        G<span class="token text string">[应用日志]</span></span>
<span class="line">        H<span class="token text string">[访问日志]</span></span>
<span class="line">        I<span class="token text string">[错误日志]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"链路追踪"</span></span>
<span class="line">        J<span class="token text string">[请求追踪]</span></span>
<span class="line">        K<span class="token text string">[服务依赖]</span></span>
<span class="line">        L<span class="token text string">[性能分析]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据收集"</span></span>
<span class="line">        M<span class="token text string">[Prometheus]</span></span>
<span class="line">        N<span class="token text string">[Jaeger]</span></span>
<span class="line">        O<span class="token text string">[Fluentd]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据存储"</span></span>
<span class="line">        P<span class="token text string">[时序数据库]</span></span>
<span class="line">        Q<span class="token text string">[链路数据库]</span></span>
<span class="line">        R<span class="token text string">[日志存储]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"可视化"</span></span>
<span class="line">        S<span class="token text string">[Grafana]</span></span>
<span class="line">        T<span class="token text string">[Jaeger UI]</span></span>
<span class="line">        U<span class="token text string">[Kibana]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> M</span>
<span class="line">    B <span class="token arrow operator">--></span> M</span>
<span class="line">    C <span class="token arrow operator">--></span> M</span>
<span class="line">    D <span class="token arrow operator">--></span> M</span>
<span class="line">    E <span class="token arrow operator">--></span> M</span>
<span class="line">    F <span class="token arrow operator">--></span> M</span>
<span class="line">    </span>
<span class="line">    G <span class="token arrow operator">--></span> O</span>
<span class="line">    H <span class="token arrow operator">--></span> O</span>
<span class="line">    I <span class="token arrow operator">--></span> O</span>
<span class="line">    </span>
<span class="line">    J <span class="token arrow operator">--></span> N</span>
<span class="line">    K <span class="token arrow operator">--></span> N</span>
<span class="line">    L <span class="token arrow operator">--></span> N</span>
<span class="line">    </span>
<span class="line">    M <span class="token arrow operator">--></span> P</span>
<span class="line">    N <span class="token arrow operator">--></span> Q</span>
<span class="line">    O <span class="token arrow operator">--></span> R</span>
<span class="line">    </span>
<span class="line">    P <span class="token arrow operator">--></span> S</span>
<span class="line">    Q <span class="token arrow operator">--></span> T</span>
<span class="line">    R <span class="token arrow operator">--></span> U</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="指标体系" tabindex="-1"><a class="header-anchor" href="#指标体系">#</a> 指标体系</h3>
<h4 id="_1-业务指标" tabindex="-1"><a class="header-anchor" href="#_1-业务指标">#</a> 1. 业务指标</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 业务指标定义</span></span>
<span class="line"><span class="token keyword">var</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token comment">// 用户相关指标</span></span>
<span class="line">    userRegistrations <span class="token operator">=</span> prometheus<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"vgo_user_registrations_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of user registrations"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"status"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 认证相关指标</span></span>
<span class="line">    authenticationAttempts <span class="token operator">=</span> prometheus<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"vgo_authentication_attempts_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of authentication attempts"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"method"</span><span class="token punctuation">,</span> <span class="token string">"status"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 权限检查指标</span></span>
<span class="line">    permissionChecks <span class="token operator">=</span> prometheus<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"vgo_permission_checks_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of permission checks"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"resource"</span><span class="token punctuation">,</span> <span class="token string">"action"</span><span class="token punctuation">,</span> <span class="token string">"result"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// API调用指标</span></span>
<span class="line">    apiRequests <span class="token operator">=</span> prometheus<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"vgo_api_requests_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of API requests"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"method"</span><span class="token punctuation">,</span> <span class="token string">"endpoint"</span><span class="token punctuation">,</span> <span class="token string">"status"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 响应时间指标</span></span>
<span class="line">    apiDuration <span class="token operator">=</span> prometheus<span class="token punctuation">.</span><span class="token function">NewHistogramVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>HistogramOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span>    <span class="token string">"vgo_api_duration_seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span>    <span class="token string">"API request duration in seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Buckets<span class="token punctuation">:</span> prometheus<span class="token punctuation">.</span>DefBuckets<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"method"</span><span class="token punctuation">,</span> <span class="token string">"endpoint"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-系统指标" tabindex="-1"><a class="header-anchor" href="#_2-系统指标">#</a> 2. 系统指标</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 系统指标收集</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>MetricsCollector<span class="token punctuation">)</span> <span class="token function">CollectSystemMetrics</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// CPU使用率</span></span>
<span class="line">    cpuUsage<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> cpu<span class="token punctuation">.</span><span class="token function">Percent</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token boolean">false</span><span class="token punctuation">)</span></span>
<span class="line">    cpuUsageGauge<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>cpuUsage<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 内存使用率</span></span>
<span class="line">    memInfo<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> mem<span class="token punctuation">.</span><span class="token function">VirtualMemory</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    memoryUsageGauge<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>memInfo<span class="token punctuation">.</span>UsedPercent<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 磁盘使用率</span></span>
<span class="line">    diskInfo<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> disk<span class="token punctuation">.</span><span class="token function">Usage</span><span class="token punctuation">(</span><span class="token string">"/"</span><span class="token punctuation">)</span></span>
<span class="line">    diskUsageGauge<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>diskInfo<span class="token punctuation">.</span>UsedPercent<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 网络流量</span></span>
<span class="line">    netInfo<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> net<span class="token punctuation">.</span><span class="token function">IOCounters</span><span class="token punctuation">(</span><span class="token boolean">false</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>netInfo<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        networkBytesReceivedCounter<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>netInfo<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span><span class="token punctuation">.</span>BytesRecv<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        networkBytesSentCounter<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>netInfo<span class="token punctuation">[</span><span class="token number">0</span><span class="token punctuation">]</span><span class="token punctuation">.</span>BytesSent<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Goroutine数量</span></span>
<span class="line">    goroutineGauge<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>runtime<span class="token punctuation">.</span><span class="token function">NumGoroutine</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// GC统计</span></span>
<span class="line">    <span class="token keyword">var</span> gcStats runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">    runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>gcStats<span class="token punctuation">)</span></span>
<span class="line">    gcDurationGauge<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>gcStats<span class="token punctuation">.</span>PauseTotalNs<span class="token punctuation">)</span> <span class="token operator">/</span> <span class="token number">1e9</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/development/">开发指南</RouteLink></li>
<li><RouteLink to="/development/testing.html">测试指南</RouteLink></li>
<li><RouteLink to="/development/debugging.html">调试指南</RouteLink></li>
<li><RouteLink to="/development/performance.html">性能优化</RouteLink></li>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
</ul>
</div></template>


