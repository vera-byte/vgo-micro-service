<template><div><h1 id="部署指南" tabindex="-1"><a class="header-anchor" href="#部署指南">#</a> 部署指南</h1>
<p>本指南将帮助您在不同环境中部署VGO微服务，包括开发环境、测试环境和生产环境。VGO微服务支持多种部署方式，您可以根据实际需求选择最适合的部署方案。</p>
<h2 id="📋-部署方式概览" tabindex="-1"><a class="header-anchor" href="#📋-部署方式概览">#</a> 📋 部署方式概览</h2>
<table>
<thead>
<tr>
<th>部署方式</th>
<th>适用场景</th>
<th>复杂度</th>
<th>推荐指数</th>
</tr>
</thead>
<tbody>
<tr>
<td><RouteLink to="/deployment/docker-compose.html">Docker Compose</RouteLink></td>
<td>开发、测试环境</td>
<td>⭐</td>
<td>⭐⭐⭐⭐⭐</td>
</tr>
<tr>
<td><RouteLink to="/deployment/kubernetes.html">Kubernetes</RouteLink></td>
<td>生产环境</td>
<td>⭐⭐⭐⭐</td>
<td>⭐⭐⭐⭐⭐</td>
</tr>
<tr>
<td><RouteLink to="/deployment/binary.html">二进制部署</RouteLink></td>
<td>简单生产环境</td>
<td>⭐⭐</td>
<td>⭐⭐⭐</td>
</tr>
<tr>
<td><RouteLink to="/deployment/source.html">源码编译</RouteLink></td>
<td>开发环境</td>
<td>⭐⭐⭐</td>
<td>⭐⭐</td>
</tr>
<tr>
<td><RouteLink to="/deployment/cloud.html">云服务部署</RouteLink></td>
<td>云原生环境</td>
<td>⭐⭐⭐⭐⭐</td>
<td>⭐⭐⭐⭐</td>
</tr>
</tbody>
</table>
<h2 id="🏗️-系统架构" tabindex="-1"><a class="header-anchor" href="#🏗️-系统架构">#</a> 🏗️ 系统架构</h2>
<h3 id="核心组件" tabindex="-1"><a class="header-anchor" href="#核心组件">#</a> 核心组件</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"客户端层"</span></span>
<span class="line">        A<span class="token text string">[Web界面]</span></span>
<span class="line">        B<span class="token text string">[gRPC客户端]</span></span>
<span class="line">        C<span class="token text string">[REST API客户端]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"网关层"</span></span>
<span class="line">        D<span class="token text string">[负载均衡器]</span></span>
<span class="line">        E<span class="token text string">[API网关]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"服务层"</span></span>
<span class="line">        F<span class="token text string">[IAM服务]</span></span>
<span class="line">        G<span class="token text string">[用户管理服务]</span></span>
<span class="line">        H<span class="token text string">[策略管理服务]</span></span>
<span class="line">        I<span class="token text string">[权限验证服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据层"</span></span>
<span class="line">        J<span class="token text string">[PostgreSQL]</span></span>
<span class="line">        K<span class="token text string">[Redis]</span></span>
<span class="line">        L<span class="token text string">[文件存储]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"监控层"</span></span>
<span class="line">        M<span class="token text string">[Prometheus]</span></span>
<span class="line">        N<span class="token text string">[Grafana]</span></span>
<span class="line">        O<span class="token text string">[Jaeger]</span></span>
<span class="line">        P<span class="token text string">[ELK Stack]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> D</span>
<span class="line">    B <span class="token arrow operator">--></span> D</span>
<span class="line">    C <span class="token arrow operator">--></span> D</span>
<span class="line">    D <span class="token arrow operator">--></span> E</span>
<span class="line">    E <span class="token arrow operator">--></span> F</span>
<span class="line">    E <span class="token arrow operator">--></span> G</span>
<span class="line">    E <span class="token arrow operator">--></span> H</span>
<span class="line">    E <span class="token arrow operator">--></span> I</span>
<span class="line">    F <span class="token arrow operator">--></span> J</span>
<span class="line">    F <span class="token arrow operator">--></span> K</span>
<span class="line">    G <span class="token arrow operator">--></span> J</span>
<span class="line">    H <span class="token arrow operator">--></span> J</span>
<span class="line">    I <span class="token arrow operator">--></span> K</span>
<span class="line">    F <span class="token arrow operator">--></span> L</span>
<span class="line">    </span>
<span class="line">    F <span class="token arrow operator">--></span> M</span>
<span class="line">    G <span class="token arrow operator">--></span> M</span>
<span class="line">    H <span class="token arrow operator">--></span> M</span>
<span class="line">    I <span class="token arrow operator">--></span> M</span>
<span class="line">    M <span class="token arrow operator">--></span> N</span>
<span class="line">    F <span class="token arrow operator">--></span> O</span>
<span class="line">    G <span class="token arrow operator">--></span> O</span>
<span class="line">    H <span class="token arrow operator">--></span> O</span>
<span class="line">    I <span class="token arrow operator">--></span> O</span>
<span class="line">    F <span class="token arrow operator">--></span> P</span>
<span class="line">    G <span class="token arrow operator">--></span> P</span>
<span class="line">    H <span class="token arrow operator">--></span> P</span>
<span class="line">    I <span class="token arrow operator">--></span> P</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="服务端口分配" tabindex="-1"><a class="header-anchor" href="#服务端口分配">#</a> 服务端口分配</h3>
<table>
<thead>
<tr>
<th>服务</th>
<th>端口</th>
<th>协议</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>IAM gRPC</td>
<td>50051</td>
<td>gRPC</td>
<td>主要API服务</td>
</tr>
<tr>
<td>IAM HTTP</td>
<td>8080</td>
<td>HTTP</td>
<td>REST API和Web界面</td>
</tr>
<tr>
<td>健康检查</td>
<td>8081</td>
<td>HTTP</td>
<td>健康检查端点</td>
</tr>
<tr>
<td>指标收集</td>
<td>8082</td>
<td>HTTP</td>
<td>Prometheus指标</td>
</tr>
<tr>
<td>PostgreSQL</td>
<td>5432</td>
<td>TCP</td>
<td>数据库服务</td>
</tr>
<tr>
<td>Redis</td>
<td>6379</td>
<td>TCP</td>
<td>缓存服务</td>
</tr>
<tr>
<td>Prometheus</td>
<td>9090</td>
<td>HTTP</td>
<td>监控服务</td>
</tr>
<tr>
<td>Grafana</td>
<td>3000</td>
<td>HTTP</td>
<td>可视化界面</td>
</tr>
<tr>
<td>Jaeger</td>
<td>16686</td>
<td>HTTP</td>
<td>链路追踪界面</td>
</tr>
</tbody>
</table>
<h2 id="🔧-环境要求" tabindex="-1"><a class="header-anchor" href="#🔧-环境要求">#</a> 🔧 环境要求</h2>
<h3 id="最小系统要求" tabindex="-1"><a class="header-anchor" href="#最小系统要求">#</a> 最小系统要求</h3>
<table>
<thead>
<tr>
<th>组件</th>
<th>最小配置</th>
<th>推荐配置</th>
</tr>
</thead>
<tbody>
<tr>
<td>CPU</td>
<td>2核</td>
<td>4核+</td>
</tr>
<tr>
<td>内存</td>
<td>4GB</td>
<td>8GB+</td>
</tr>
<tr>
<td>存储</td>
<td>20GB</td>
<td>100GB+</td>
</tr>
<tr>
<td>网络</td>
<td>100Mbps</td>
<td>1Gbps+</td>
</tr>
</tbody>
</table>
<h3 id="软件依赖" tabindex="-1"><a class="header-anchor" href="#软件依赖">#</a> 软件依赖</h3>
<h4 id="必需组件" tabindex="-1"><a class="header-anchor" href="#必需组件">#</a> 必需组件</h4>
<ul>
<li><strong>操作系统</strong>: Linux (Ubuntu 20.04+, CentOS 8+, RHEL 8+)</li>
<li><strong>容器运行时</strong>: Docker 20.10+ 或 Podman 3.0+</li>
<li><strong>数据库</strong>: PostgreSQL 13+</li>
<li><strong>缓存</strong>: Redis 6.0+</li>
</ul>
<h4 id="可选组件" tabindex="-1"><a class="header-anchor" href="#可选组件">#</a> 可选组件</h4>
<ul>
<li><strong>容器编排</strong>: Kubernetes 1.20+ 或 Docker Swarm</li>
<li><strong>负载均衡</strong>: Nginx, HAProxy, 或云负载均衡器</li>
<li><strong>监控</strong>: Prometheus + Grafana</li>
<li><strong>日志</strong>: ELK Stack 或 Loki</li>
<li><strong>链路追踪</strong>: Jaeger 或 Zipkin</li>
</ul>
<h2 id="🚀-快速开始" tabindex="-1"><a class="header-anchor" href="#🚀-快速开始">#</a> 🚀 快速开始</h2>
<h3 id="_1-使用docker-compose-推荐" tabindex="-1"><a class="header-anchor" href="#_1-使用docker-compose-推荐">#</a> 1. 使用Docker Compose（推荐）</h3>
<p>最简单的部署方式，适合开发和测试环境：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 克隆项目</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/your-org/vgo-microservice.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo-microservice</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动所有服务</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs <span class="token parameter variable">-f</span> iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-验证部署" tabindex="-1"><a class="header-anchor" href="#_2-验证部署">#</a> 2. 验证部署</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查服务健康状态</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8081/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问Web界面</span></span>
<span class="line"><span class="token function">open</span> http://localhost:8080</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试gRPC API</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-初始化数据" tabindex="-1"><a class="header-anchor" href="#_3-初始化数据">#</a> 3. 初始化数据</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建管理员用户</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam ./vgo-iam admin create-user <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--username</span> admin <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--email</span> admin@example.com <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--password</span> admin123</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建访问密钥</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam ./vgo-iam admin create-access-key <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--username</span> admin <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--description</span> <span class="token string">"管理员密钥"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔐-安全配置" tabindex="-1"><a class="header-anchor" href="#🔐-安全配置">#</a> 🔐 安全配置</h2>
<h3 id="基础安全设置" tabindex="-1"><a class="header-anchor" href="#基础安全设置">#</a> 基础安全设置</h3>
<ol>
<li>
<p><strong>更改默认密码</strong></p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更改数据库密码</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">POSTGRES_PASSWORD</span><span class="token operator">=</span><span class="token string">"your-secure-password"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 更改Redis密码</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">REDIS_PASSWORD</span><span class="token operator">=</span><span class="token string">"your-redis-password"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 更改JWT密钥</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">JWT_SECRET</span><span class="token operator">=</span><span class="token string">"your-jwt-secret-key"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div></li>
<li>
<p><strong>启用TLS</strong></p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> TLS_ENABLED=true</span>
<span class="line">      <span class="token punctuation">-</span> TLS_CERT_FILE=/certs/server.crt</span>
<span class="line">      <span class="token punctuation">-</span> TLS_KEY_FILE=/certs/server.key</span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./certs<span class="token punctuation">:</span>/certs<span class="token punctuation">:</span>ro</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div></li>
<li>
<p><strong>网络隔离</strong></p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">frontend</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">driver</span><span class="token punctuation">:</span> bridge</span>
<span class="line">  <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">driver</span><span class="token punctuation">:</span> bridge</span>
<span class="line">    <span class="token key atrule">internal</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div></li>
</ol>
<h3 id="生产环境安全清单" tabindex="-1"><a class="header-anchor" href="#生产环境安全清单">#</a> 生产环境安全清单</h3>
<ul>
<li>[ ] 使用强密码和密钥</li>
<li>[ ] 启用TLS/SSL加密</li>
<li>[ ] 配置防火墙规则</li>
<li>[ ] 启用访问日志</li>
<li>[ ] 配置入侵检测</li>
<li>[ ] 定期安全更新</li>
<li>[ ] 备份加密</li>
<li>[ ] 权限最小化</li>
</ul>
<h2 id="📊-监控配置" tabindex="-1"><a class="header-anchor" href="#📊-监控配置">#</a> 📊 监控配置</h2>
<h3 id="prometheus配置" tabindex="-1"><a class="header-anchor" href="#prometheus配置">#</a> Prometheus配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># prometheus.yml</span></span>
<span class="line"><span class="token key atrule">global</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">  <span class="token key atrule">evaluation_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">scrape_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'vgo-iam'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'iam:8082'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">    </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'postgres'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'postgres-exporter:9187'</span><span class="token punctuation">]</span></span>
<span class="line">    </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'redis'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'redis-exporter:9121'</span><span class="token punctuation">]</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="grafana仪表板" tabindex="-1"><a class="header-anchor" href="#grafana仪表板">#</a> Grafana仪表板</h3>
<p>预配置的仪表板包括：</p>
<ul>
<li><strong>系统概览</strong>: CPU、内存、磁盘使用率</li>
<li><strong>服务性能</strong>: 请求量、响应时间、错误率</li>
<li><strong>数据库监控</strong>: 连接数、查询性能、锁等待</li>
<li><strong>缓存监控</strong>: 命中率、内存使用、连接数</li>
<li><strong>业务指标</strong>: 用户数量、权限检查次数、API调用统计</li>
</ul>
<h2 id="🔄-备份和恢复" tabindex="-1"><a class="header-anchor" href="#🔄-备份和恢复">#</a> 🔄 备份和恢复</h2>
<h3 id="数据备份" tabindex="-1"><a class="header-anchor" href="#数据备份">#</a> 数据备份</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 数据库备份</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres pg_dump <span class="token parameter variable">-U</span> vgo_user vgo_db <span class="token operator">></span> backup_<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span>.sql</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Redis备份</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli BGSAVE</span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis <span class="token function">cp</span> /data/dump.rdb /backup/</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 配置文件备份</span></span>
<span class="line"><span class="token function">tar</span> <span class="token parameter variable">-czf</span> config_backup_<span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span>.tar.gz configs/</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="自动备份脚本" tabindex="-1"><a class="header-anchor" href="#自动备份脚本">#</a> 自动备份脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># backup.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">BACKUP_DIR</span><span class="token operator">=</span><span class="token string">"/backup/vgo"</span></span>
<span class="line"><span class="token assign-left variable">DATE</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span></span>
<span class="line"><span class="token assign-left variable">RETENTION_DAYS</span><span class="token operator">=</span><span class="token number">30</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建备份目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token variable">$BACKUP_DIR</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 数据库备份</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> <span class="token parameter variable">-T</span> postgres pg_dump <span class="token parameter variable">-U</span> vgo_user vgo_db <span class="token operator">|</span> <span class="token function">gzip</span> <span class="token operator">></span> <span class="token variable">$BACKUP_DIR</span>/db_<span class="token variable">$DATE</span>.sql.gz</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Redis备份</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli BGSAVE</span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">cp</span> redis:/data/dump.rdb <span class="token variable">$BACKUP_DIR</span>/redis_<span class="token variable">$DATE</span>.rdb</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清理旧备份</span></span>
<span class="line"><span class="token function">find</span> <span class="token variable">$BACKUP_DIR</span> <span class="token parameter variable">-name</span> <span class="token string">"*.sql.gz"</span> <span class="token parameter variable">-mtime</span> +<span class="token variable">$RETENTION_DAYS</span> <span class="token parameter variable">-delete</span></span>
<span class="line"><span class="token function">find</span> <span class="token variable">$BACKUP_DIR</span> <span class="token parameter variable">-name</span> <span class="token string">"*.rdb"</span> <span class="token parameter variable">-mtime</span> +<span class="token variable">$RETENTION_DAYS</span> <span class="token parameter variable">-delete</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份完成: <span class="token variable">$DATE</span>"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="数据恢复" tabindex="-1"><a class="header-anchor" href="#数据恢复">#</a> 数据恢复</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 恢复数据库</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> <span class="token parameter variable">-T</span> postgres psql <span class="token parameter variable">-U</span> vgo_user <span class="token parameter variable">-d</span> vgo_db <span class="token operator">&lt;</span> backup_20240115_103000.sql</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 恢复Redis</span></span>
<span class="line"><span class="token function">docker-compose</span> stop redis</span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">cp</span> redis_20240115_103000.rdb redis:/data/dump.rdb</span>
<span class="line"><span class="token function">docker-compose</span> start redis</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-故障排除" tabindex="-1"><a class="header-anchor" href="#🔧-故障排除">#</a> 🔧 故障排除</h2>
<h3 id="常见问题" tabindex="-1"><a class="header-anchor" href="#常见问题">#</a> 常见问题</h3>
<h4 id="_1-服务启动失败" tabindex="-1"><a class="header-anchor" href="#_1-服务启动失败">#</a> 1. 服务启动失败</h4>
<p><strong>症状</strong>: 容器无法启动或立即退出</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看容器日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查容器状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查资源使用</span></span>
<span class="line"><span class="token function">docker</span> stats</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查端口占用</span></span>
<span class="line"><span class="token function">netstat</span> <span class="token parameter variable">-tlnp</span> <span class="token operator">|</span> <span class="token function">grep</span> :50051</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>常见原因</strong>:</p>
<ul>
<li>端口被占用</li>
<li>配置文件错误</li>
<li>依赖服务未启动</li>
<li>资源不足</li>
</ul>
<h4 id="_2-数据库连接失败" tabindex="-1"><a class="header-anchor" href="#_2-数据库连接失败">#</a> 2. 数据库连接失败</h4>
<p><strong>症状</strong>: 服务日志显示数据库连接错误</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查数据库状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres pg_isready <span class="token parameter variable">-U</span> vgo_user</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试连接</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres psql <span class="token parameter variable">-U</span> vgo_user <span class="token parameter variable">-d</span> vgo_db <span class="token parameter variable">-c</span> <span class="token string">"SELECT 1;"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查网络连通性</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam <span class="token function">ping</span> postgres</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>解决方案</strong>:</p>
<ul>
<li>检查数据库配置</li>
<li>确认用户名密码正确</li>
<li>检查网络配置</li>
<li>查看数据库日志</li>
</ul>
<h4 id="_3-权限验证失败" tabindex="-1"><a class="header-anchor" href="#_3-权限验证失败">#</a> 3. 权限验证失败</h4>
<p><strong>症状</strong>: API调用返回权限不足错误</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查用户是否存在</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{"user_name":"test_user"}'</span> localhost:50051 iam.v1.IAM/GetUser</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查用户策略</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{"user_name":"test_user"}'</span> localhost:50051 iam.v1.IAM/ListUserPolicies</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试权限检查</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "user_name":"test_user",</span>
<span class="line">  "action":"iam:GetUser",</span>
<span class="line">  "resource":"arn:iam::user/test_user"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CheckPermission</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="性能优化" tabindex="-1"><a class="header-anchor" href="#性能优化">#</a> 性能优化</h3>
<h4 id="_1-数据库优化" tabindex="-1"><a class="header-anchor" href="#_1-数据库优化">#</a> 1. 数据库优化</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 创建索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> CONCURRENTLY idx_users_username <span class="token keyword">ON</span> users<span class="token punctuation">(</span>username<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> CONCURRENTLY idx_policies_name <span class="token keyword">ON</span> policies<span class="token punctuation">(</span>name<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> CONCURRENTLY idx_user_policies_user_id <span class="token keyword">ON</span> user_policies<span class="token punctuation">(</span>user_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 分析表统计信息</span></span>
<span class="line"><span class="token keyword">ANALYZE</span> users<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ANALYZE</span> policies<span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">ANALYZE</span> user_policies<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 查看慢查询</span></span>
<span class="line"><span class="token keyword">SELECT</span> query<span class="token punctuation">,</span> mean_time<span class="token punctuation">,</span> calls </span>
<span class="line"><span class="token keyword">FROM</span> pg_stat_statements </span>
<span class="line"><span class="token keyword">ORDER</span> <span class="token keyword">BY</span> mean_time <span class="token keyword">DESC</span> </span>
<span class="line"><span class="token keyword">LIMIT</span> <span class="token number">10</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-redis优化" tabindex="-1"><a class="header-anchor" href="#_2-redis优化">#</a> 2. Redis优化</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 配置内存策略</span></span>
<span class="line">redis-cli CONFIG SET maxmemory-policy allkeys-lru</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启用持久化</span></span>
<span class="line">redis-cli CONFIG SET save <span class="token string">"900 1 300 10 60 10000"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 监控性能</span></span>
<span class="line">redis-cli --latency-history</span>
<span class="line">redis-cli INFO memory</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-应用优化" tabindex="-1"><a class="header-anchor" href="#_3-应用优化">#</a> 3. 应用优化</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># 连接池配置</span></span>
<span class="line">      <span class="token punctuation">-</span> DB_MAX_OPEN_CONNS=25</span>
<span class="line">      <span class="token punctuation">-</span> DB_MAX_IDLE_CONNS=5</span>
<span class="line">      <span class="token punctuation">-</span> DB_CONN_MAX_LIFETIME=300s</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 缓存配置</span></span>
<span class="line">      <span class="token punctuation">-</span> CACHE_TTL=300s</span>
<span class="line">      <span class="token punctuation">-</span> CACHE_MAX_SIZE=1000</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 性能配置</span></span>
<span class="line">      <span class="token punctuation">-</span> GOMAXPROCS=4</span>
<span class="line">      <span class="token punctuation">-</span> GOGC=100</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 资源限制</span></span>
<span class="line">    <span class="token key atrule">deploy</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'2.0'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1G</span>
<span class="line">        <span class="token key atrule">reservations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'0.5'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 512M</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-扩展部署" tabindex="-1"><a class="header-anchor" href="#📈-扩展部署">#</a> 📈 扩展部署</h2>
<h3 id="水平扩展" tabindex="-1"><a class="header-anchor" href="#水平扩展">#</a> 水平扩展</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">deploy</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">    </span>
<span class="line">  <span class="token key atrule">nginx</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> nginx<span class="token punctuation">:</span>alpine</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"80:80"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"443:443"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./nginx.conf<span class="token punctuation">:</span>/etc/nginx/nginx.conf</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="负载均衡配置" tabindex="-1"><a class="header-anchor" href="#负载均衡配置">#</a> 负载均衡配置</h3>
<div class="language-nginx line-numbers-mode" data-highlighter="prismjs" data-ext="nginx"><pre v-pre><code class="language-nginx"><span class="line"><span class="token comment"># nginx.conf</span></span>
<span class="line"><span class="token directive"><span class="token keyword">upstream</span> iam_backend</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">least_conn</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server</span> iam_1:8080 max_fails=3 fail_timeout=30s</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server</span> iam_2:8080 max_fails=3 fail_timeout=30s</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server</span> iam_3:8080 max_fails=3 fail_timeout=30s</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token directive"><span class="token keyword">server</span></span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">listen</span> <span class="token number">80</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server_name</span> your-domain.com</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token directive"><span class="token keyword">location</span> /</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Real-IP <span class="token variable">$remote_addr</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-For <span class="token variable">$proxy_add_x_forwarded_for</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-Proto <span class="token variable">$scheme</span></span><span class="token punctuation">;</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 健康检查</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_next_upstream</span> error timeout invalid_header http_500 http_502 http_503 http_504</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_connect_timeout</span> <span class="token number">5s</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_send_timeout</span> <span class="token number">10s</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_read_timeout</span> <span class="token number">10s</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token directive"><span class="token keyword">location</span> /health</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">access_log</span> <span class="token boolean">off</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend/health</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/deployment/docker-compose.html">Docker Compose部署</RouteLink> - 详细的Docker Compose部署指南</li>
<li><RouteLink to="/deployment/kubernetes.html">Kubernetes部署</RouteLink> - 生产级Kubernetes部署</li>
<li><RouteLink to="/deployment/binary.html">二进制部署</RouteLink> - 传统二进制文件部署</li>
<li><RouteLink to="/deployment/cloud.html">云服务部署</RouteLink> - 云原生部署方案</li>
<li><RouteLink to="/deployment/monitoring.html">监控配置</RouteLink> - 完整的监控解决方案</li>
<li><RouteLink to="/deployment/security.html">安全配置</RouteLink> - 生产环境安全配置</li>
<li><RouteLink to="/deployment/troubleshooting.html">故障排除</RouteLink> - 常见问题解决方案</li>
</ul>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>建议先在测试环境验证部署方案，确认无误后再部署到生产环境。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>生产环境部署前请务必阅读安全配置章节，确保系统安全。</p>
</div>
</div></template>


