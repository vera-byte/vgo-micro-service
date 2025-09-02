<template><div><h1 id="docker-compose-部署" tabindex="-1"><a class="header-anchor" href="#docker-compose-部署">#</a> Docker Compose 部署</h1>
<p>Docker Compose是部署VGO微服务最简单快捷的方式，特别适合开发环境、测试环境和小规模生产环境。本指南将详细介绍如何使用Docker Compose部署完整的VGO微服务栈。</p>
<h2 id="📋-部署概览" tabindex="-1"><a class="header-anchor" href="#📋-部署概览">#</a> 📋 部署概览</h2>
<h3 id="服务组件" tabindex="-1"><a class="header-anchor" href="#服务组件">#</a> 服务组件</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"Docker Compose Stack"</span></span>
<span class="line">        A<span class="token text string">[Nginx]</span> <span class="token arrow operator">--></span> B<span class="token text string">[IAM Service]</span></span>
<span class="line">        B <span class="token arrow operator">--></span> C<span class="token text string">[PostgreSQL]</span></span>
<span class="line">        B <span class="token arrow operator">--></span> D<span class="token text string">[Redis]</span></span>
<span class="line">        E<span class="token text string">[Prometheus]</span> <span class="token arrow operator">--></span> B</span>
<span class="line">        F<span class="token text string">[Grafana]</span> <span class="token arrow operator">--></span> E</span>
<span class="line">        G<span class="token text string">[Jaeger]</span> <span class="token arrow operator">--></span> B</span>
<span class="line">        H<span class="token text string">[Postgres Exporter]</span> <span class="token arrow operator">--></span> C</span>
<span class="line">        I<span class="token text string">[Redis Exporter]</span> <span class="token arrow operator">--></span> D</span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    J<span class="token text string">[External Client]</span> <span class="token arrow operator">--></span> A</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">style</span> A <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#e1f5fe</span></span>
<span class="line">    <span class="token keyword">style</span> B <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#f3e5f5</span></span>
<span class="line">    <span class="token keyword">style</span> C <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#e8f5e8</span></span>
<span class="line">    <span class="token keyword">style</span> D <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#fff3e0</span></span>
<span class="line">    <span class="token keyword">style</span> E <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#fce4ec</span></span>
<span class="line">    <span class="token keyword">style</span> F <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#f1f8e9</span></span>
<span class="line">    <span class="token keyword">style</span> G <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#e0f2f1</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="端口映射" tabindex="-1"><a class="header-anchor" href="#端口映射">#</a> 端口映射</h3>
<table>
<thead>
<tr>
<th>服务</th>
<th>内部端口</th>
<th>外部端口</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>Nginx</td>
<td>80/443</td>
<td>80/443</td>
<td>Web入口</td>
</tr>
<tr>
<td>IAM gRPC</td>
<td>50051</td>
<td>50051</td>
<td>gRPC API</td>
</tr>
<tr>
<td>IAM HTTP</td>
<td>8080</td>
<td>-</td>
<td>内部HTTP API</td>
</tr>
<tr>
<td>PostgreSQL</td>
<td>5432</td>
<td>5432</td>
<td>数据库（开发环境）</td>
</tr>
<tr>
<td>Redis</td>
<td>6379</td>
<td>6379</td>
<td>缓存（开发环境）</td>
</tr>
<tr>
<td>Prometheus</td>
<td>9090</td>
<td>9090</td>
<td>监控服务</td>
</tr>
<tr>
<td>Grafana</td>
<td>3000</td>
<td>3000</td>
<td>可视化界面</td>
</tr>
<tr>
<td>Jaeger</td>
<td>16686</td>
<td>16686</td>
<td>链路追踪界面</td>
</tr>
</tbody>
</table>
<h2 id="🚀-快速开始" tabindex="-1"><a class="header-anchor" href="#🚀-快速开始">#</a> 🚀 快速开始</h2>
<h3 id="_1-环境准备" tabindex="-1"><a class="header-anchor" href="#_1-环境准备">#</a> 1. 环境准备</h3>
<h4 id="系统要求" tabindex="-1"><a class="header-anchor" href="#系统要求">#</a> 系统要求</h4>
<ul>
<li><strong>操作系统</strong>: Linux, macOS, Windows</li>
<li><strong>Docker</strong>: 20.10+</li>
<li><strong>Docker Compose</strong>: 2.0+</li>
<li><strong>内存</strong>: 最少4GB，推荐8GB+</li>
<li><strong>存储</strong>: 最少10GB可用空间</li>
</ul>
<h4 id="安装docker和docker-compose" tabindex="-1"><a class="header-anchor" href="#安装docker和docker-compose">#</a> 安装Docker和Docker Compose</h4>
<p><strong>Ubuntu/Debian:</strong></p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装Docker</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-fsSL</span> https://get.docker.com <span class="token parameter variable">-o</span> get-docker.sh</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">sh</span> get-docker.sh</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装Docker Compose</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">curl</span> <span class="token parameter variable">-L</span> <span class="token string">"https://github.com/docker/compose/releases/latest/download/docker-compose-<span class="token variable"><span class="token variable">$(</span><span class="token function">uname</span> <span class="token parameter variable">-s</span><span class="token variable">)</span></span>-<span class="token variable"><span class="token variable">$(</span><span class="token function">uname</span> <span class="token parameter variable">-m</span><span class="token variable">)</span></span>"</span> <span class="token parameter variable">-o</span> /usr/local/bin/docker-compose</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chmod</span> +x /usr/local/bin/docker-compose</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 添加用户到docker组</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">usermod</span> <span class="token parameter variable">-aG</span> <span class="token function">docker</span> <span class="token environment constant">$USER</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>CentOS/RHEL:</strong></p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装Docker</span></span>
<span class="line"><span class="token function">sudo</span> yum <span class="token function">install</span> <span class="token parameter variable">-y</span> yum-utils</span>
<span class="line"><span class="token function">sudo</span> yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo</span>
<span class="line"><span class="token function">sudo</span> yum <span class="token function">install</span> <span class="token parameter variable">-y</span> docker-ce docker-ce-cli containerd.io</span>
<span class="line"><span class="token function">sudo</span> systemctl start <span class="token function">docker</span></span>
<span class="line"><span class="token function">sudo</span> systemctl <span class="token builtin class-name">enable</span> <span class="token function">docker</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装Docker Compose</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">curl</span> <span class="token parameter variable">-L</span> <span class="token string">"https://github.com/docker/compose/releases/latest/download/docker-compose-<span class="token variable"><span class="token variable">$(</span><span class="token function">uname</span> <span class="token parameter variable">-s</span><span class="token variable">)</span></span>-<span class="token variable"><span class="token variable">$(</span><span class="token function">uname</span> <span class="token parameter variable">-m</span><span class="token variable">)</span></span>"</span> <span class="token parameter variable">-o</span> /usr/local/bin/docker-compose</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chmod</span> +x /usr/local/bin/docker-compose</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>macOS:</strong></p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 使用Homebrew</span></span>
<span class="line">brew <span class="token function">install</span> <span class="token function">docker</span> <span class="token function">docker-compose</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或下载Docker Desktop</span></span>
<span class="line"><span class="token comment"># https://www.docker.com/products/docker-desktop</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-获取项目文件" tabindex="-1"><a class="header-anchor" href="#_2-获取项目文件">#</a> 2. 获取项目文件</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 克隆项目</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/your-org/vgo-microservice.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo-microservice</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或者创建项目目录</span></span>
<span class="line"><span class="token function">mkdir</span> vgo-deployment</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo-deployment</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-配置文件准备" tabindex="-1"><a class="header-anchor" href="#_3-配置文件准备">#</a> 3. 配置文件准备</h3>
<h4 id="创建docker-compose-yml" tabindex="-1"><a class="header-anchor" href="#创建docker-compose-yml">#</a> 创建docker-compose.yml</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># PostgreSQL数据库</span></span>
<span class="line">  <span class="token key atrule">postgres</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>15<span class="token punctuation">-</span>alpine</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">POSTGRES_DB</span><span class="token punctuation">:</span> vgo_db</span>
<span class="line">      <span class="token key atrule">POSTGRES_USER</span><span class="token punctuation">:</span> vgo_user</span>
<span class="line">      <span class="token key atrule">POSTGRES_PASSWORD</span><span class="token punctuation">:</span> $<span class="token punctuation">{</span>POSTGRES_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>vgo_password<span class="token punctuation">}</span></span>
<span class="line">      <span class="token key atrule">POSTGRES_INITDB_ARGS</span><span class="token punctuation">:</span> <span class="token string">"--encoding=UTF8 --locale=C"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> postgres_data<span class="token punctuation">:</span>/var/lib/postgresql/data</span>
<span class="line">      <span class="token punctuation">-</span> ./init<span class="token punctuation">-</span>scripts<span class="token punctuation">:</span>/docker<span class="token punctuation">-</span>entrypoint<span class="token punctuation">-</span>initdb.d</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"5432:5432"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">healthcheck</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">test</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"CMD-SHELL"</span><span class="token punctuation">,</span> <span class="token string">"pg_isready -U vgo_user -d vgo_db"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">      <span class="token key atrule">timeout</span><span class="token punctuation">:</span> 5s</span>
<span class="line">      <span class="token key atrule">retries</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Redis缓存</span></span>
<span class="line">  <span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span>7<span class="token punctuation">-</span>alpine</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">    <span class="token key atrule">command</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>server <span class="token punctuation">-</span><span class="token punctuation">-</span>requirepass $<span class="token punctuation">{</span>REDIS_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>redis_password<span class="token punctuation">}</span> <span class="token punctuation">-</span><span class="token punctuation">-</span>appendonly yes</span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> redis_data<span class="token punctuation">:</span>/data</span>
<span class="line">      <span class="token punctuation">-</span> ./redis.conf<span class="token punctuation">:</span>/usr/local/etc/redis/redis.conf</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"6379:6379"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">healthcheck</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">test</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"CMD"</span><span class="token punctuation">,</span> <span class="token string">"redis-cli"</span><span class="token punctuation">,</span> <span class="token string">"--raw"</span><span class="token punctuation">,</span> <span class="token string">"incr"</span><span class="token punctuation">,</span> <span class="token string">"ping"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">      <span class="token key atrule">timeout</span><span class="token punctuation">:</span> 3s</span>
<span class="line">      <span class="token key atrule">retries</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># IAM微服务</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> vgo/iam<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">    <span class="token key atrule">build</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">context</span><span class="token punctuation">:</span> .</span>
<span class="line">      <span class="token key atrule">dockerfile</span><span class="token punctuation">:</span> Dockerfile</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># 数据库配置</span></span>
<span class="line">      <span class="token punctuation">-</span> DB_HOST=postgres</span>
<span class="line">      <span class="token punctuation">-</span> DB_PORT=5432</span>
<span class="line">      <span class="token punctuation">-</span> DB_NAME=vgo_db</span>
<span class="line">      <span class="token punctuation">-</span> DB_USER=vgo_user</span>
<span class="line">      <span class="token punctuation">-</span> DB_PASSWORD=$<span class="token punctuation">{</span>POSTGRES_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>vgo_password<span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">-</span> DB_SSLMODE=disable</span>
<span class="line">      <span class="token punctuation">-</span> DB_MAX_OPEN_CONNS=25</span>
<span class="line">      <span class="token punctuation">-</span> DB_MAX_IDLE_CONNS=5</span>
<span class="line">      <span class="token punctuation">-</span> DB_CONN_MAX_LIFETIME=300s</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># Redis配置</span></span>
<span class="line">      <span class="token punctuation">-</span> REDIS_HOST=redis</span>
<span class="line">      <span class="token punctuation">-</span> REDIS_PORT=6379</span>
<span class="line">      <span class="token punctuation">-</span> REDIS_PASSWORD=$<span class="token punctuation">{</span>REDIS_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>redis_password<span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">-</span> REDIS_DB=0</span>
<span class="line">      <span class="token punctuation">-</span> REDIS_POOL_SIZE=10</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 服务配置</span></span>
<span class="line">      <span class="token punctuation">-</span> GRPC_PORT=50051</span>
<span class="line">      <span class="token punctuation">-</span> HTTP_PORT=8080</span>
<span class="line">      <span class="token punctuation">-</span> HEALTH_PORT=8081</span>
<span class="line">      <span class="token punctuation">-</span> METRICS_PORT=8082</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 安全配置</span></span>
<span class="line">      <span class="token punctuation">-</span> JWT_SECRET=$<span class="token punctuation">{</span>JWT_SECRET<span class="token punctuation">:</span><span class="token punctuation">-</span>your<span class="token punctuation">-</span>jwt<span class="token punctuation">-</span>secret<span class="token punctuation">-</span>key<span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">-</span> ENCRYPTION_KEY=$<span class="token punctuation">{</span>ENCRYPTION_KEY<span class="token punctuation">:</span><span class="token punctuation">-</span>your<span class="token punctuation">-</span>encryption<span class="token punctuation">-</span>key<span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">-</span> TLS_ENABLED=false</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 日志配置</span></span>
<span class="line">      <span class="token punctuation">-</span> LOG_LEVEL=info</span>
<span class="line">      <span class="token punctuation">-</span> LOG_FORMAT=json</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># 监控配置</span></span>
<span class="line">      <span class="token punctuation">-</span> METRICS_ENABLED=true</span>
<span class="line">      <span class="token punctuation">-</span> TRACING_ENABLED=true</span>
<span class="line">      <span class="token punctuation">-</span> JAEGER_ENDPOINT=http<span class="token punctuation">:</span>//jaeger<span class="token punctuation">:</span>14268/api/traces</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"50051:50051"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"8080:8080"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"8081:8081"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"8082:8082"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./configs<span class="token punctuation">:</span>/app/configs</span>
<span class="line">      <span class="token punctuation">-</span> ./logs<span class="token punctuation">:</span>/app/logs</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> frontend</span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">postgres</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">condition</span><span class="token punctuation">:</span> service_healthy</span>
<span class="line">      <span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">condition</span><span class="token punctuation">:</span> service_healthy</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">healthcheck</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">test</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"CMD"</span><span class="token punctuation">,</span> <span class="token string">"curl"</span><span class="token punctuation">,</span> <span class="token string">"-f"</span><span class="token punctuation">,</span> <span class="token string">"http://localhost:8081/health"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">interval</span><span class="token punctuation">:</span> 30s</span>
<span class="line">      <span class="token key atrule">timeout</span><span class="token punctuation">:</span> 10s</span>
<span class="line">      <span class="token key atrule">retries</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">      <span class="token key atrule">start_period</span><span class="token punctuation">:</span> 40s</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Nginx反向代理</span></span>
<span class="line">  <span class="token key atrule">nginx</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> nginx<span class="token punctuation">:</span>alpine</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>nginx</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"80:80"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"443:443"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./nginx/nginx.conf<span class="token punctuation">:</span>/etc/nginx/nginx.conf</span>
<span class="line">      <span class="token punctuation">-</span> ./nginx/conf.d<span class="token punctuation">:</span>/etc/nginx/conf.d</span>
<span class="line">      <span class="token punctuation">-</span> ./certs<span class="token punctuation">:</span>/etc/nginx/certs</span>
<span class="line">      <span class="token punctuation">-</span> ./logs/nginx<span class="token punctuation">:</span>/var/log/nginx</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> frontend</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> iam</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">healthcheck</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">test</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"CMD"</span><span class="token punctuation">,</span> <span class="token string">"curl"</span><span class="token punctuation">,</span> <span class="token string">"-f"</span><span class="token punctuation">,</span> <span class="token string">"http://localhost/health"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">interval</span><span class="token punctuation">:</span> 30s</span>
<span class="line">      <span class="token key atrule">timeout</span><span class="token punctuation">:</span> 10s</span>
<span class="line">      <span class="token key atrule">retries</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Prometheus监控</span></span>
<span class="line">  <span class="token key atrule">prometheus</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prom/prometheus<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>prometheus</span>
<span class="line">    <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--config.file=/etc/prometheus/prometheus.yml'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.path=/prometheus'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.console.libraries=/etc/prometheus/console_libraries'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.console.templates=/etc/prometheus/consoles'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.retention.time=200h'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.enable-lifecycle'</span></span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9090:9090"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./prometheus/prometheus.yml<span class="token punctuation">:</span>/etc/prometheus/prometheus.yml</span>
<span class="line">      <span class="token punctuation">-</span> prometheus_data<span class="token punctuation">:</span>/prometheus</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Grafana可视化</span></span>
<span class="line">  <span class="token key atrule">grafana</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> grafana/grafana<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>grafana</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> GF_SECURITY_ADMIN_PASSWORD=$<span class="token punctuation">{</span>GRAFANA_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>admin<span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">-</span> GF_USERS_ALLOW_SIGN_UP=false</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"3000:3000"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> grafana_data<span class="token punctuation">:</span>/var/lib/grafana</span>
<span class="line">      <span class="token punctuation">-</span> ./grafana/provisioning<span class="token punctuation">:</span>/etc/grafana/provisioning</span>
<span class="line">      <span class="token punctuation">-</span> ./grafana/dashboards<span class="token punctuation">:</span>/var/lib/grafana/dashboards</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> prometheus</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Jaeger链路追踪</span></span>
<span class="line">  <span class="token key atrule">jaeger</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> jaegertracing/all<span class="token punctuation">-</span>in<span class="token punctuation">-</span>one<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>jaeger</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> COLLECTOR_OTLP_ENABLED=true</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"16686:16686"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"14268:14268"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># PostgreSQL监控</span></span>
<span class="line">  <span class="token key atrule">postgres-exporter</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prometheuscommunity/postgres<span class="token punctuation">-</span>exporter<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> DATA_SOURCE_NAME=postgresql<span class="token punctuation">:</span>//vgo_user<span class="token punctuation">:</span>$<span class="token punctuation">{</span>POSTGRES_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>vgo_password<span class="token punctuation">}</span>@postgres<span class="token punctuation">:</span>5432/vgo_db<span class="token punctuation">?</span>sslmode=disable</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9187:9187"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> postgres</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Redis监控</span></span>
<span class="line">  <span class="token key atrule">redis-exporter</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> oliver006/redis_exporter<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> REDIS_ADDR=redis<span class="token punctuation">:</span>//redis<span class="token punctuation">:</span><span class="token number">6379</span></span>
<span class="line">      <span class="token punctuation">-</span> REDIS_PASSWORD=$<span class="token punctuation">{</span>REDIS_PASSWORD<span class="token punctuation">:</span><span class="token punctuation">-</span>redis_password<span class="token punctuation">}</span></span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9121:9121"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> backend</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> redis</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">postgres_data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">redis_data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">prometheus_data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">grafana_data</span><span class="token punctuation">:</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">frontend</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">driver</span><span class="token punctuation">:</span> bridge</span>
<span class="line">  <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">driver</span><span class="token punctuation">:</span> bridge</span>
<span class="line">    <span class="token key atrule">internal</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="创建环境变量文件" tabindex="-1"><a class="header-anchor" href="#创建环境变量文件">#</a> 创建环境变量文件</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># .env</span></span>
<span class="line"><span class="token comment"># 数据库配置</span></span>
<span class="line"><span class="token assign-left variable">POSTGRES_PASSWORD</span><span class="token operator">=</span>your-secure-postgres-password</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Redis配置</span></span>
<span class="line"><span class="token assign-left variable">REDIS_PASSWORD</span><span class="token operator">=</span>your-secure-redis-password</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安全配置</span></span>
<span class="line"><span class="token assign-left variable">JWT_SECRET</span><span class="token operator">=</span>your-very-long-jwt-secret-key-at-least-32-characters</span>
<span class="line"><span class="token assign-left variable">ENCRYPTION_KEY</span><span class="token operator">=</span>your-32-character-encryption-key</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Grafana配置</span></span>
<span class="line"><span class="token assign-left variable">GRAFANA_PASSWORD</span><span class="token operator">=</span>your-grafana-admin-password</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 环境标识</span></span>
<span class="line"><span class="token assign-left variable">ENVIRONMENT</span><span class="token operator">=</span>development</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="创建nginx配置" tabindex="-1"><a class="header-anchor" href="#创建nginx配置">#</a> 创建Nginx配置</h4>
<div class="language-nginx line-numbers-mode" data-highlighter="prismjs" data-ext="nginx"><pre v-pre><code class="language-nginx"><span class="line"><span class="token comment"># nginx/nginx.conf</span></span>
<span class="line"><span class="token directive"><span class="token keyword">user</span> nginx</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token directive"><span class="token keyword">worker_processes</span> auto</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token directive"><span class="token keyword">error_log</span> /var/log/nginx/error.log warn</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token directive"><span class="token keyword">pid</span> /var/run/nginx.pid</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token directive"><span class="token keyword">events</span></span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">worker_connections</span> <span class="token number">1024</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">use</span> epoll</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">multi_accept</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token directive"><span class="token keyword">http</span></span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">include</span> /etc/nginx/mime.types</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">default_type</span> application/octet-stream</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 日志格式</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">log_format</span> main <span class="token string">'<span class="token variable">$remote_addr</span> - <span class="token variable">$remote_user</span> [<span class="token variable">$time_local]</span> "<span class="token variable">$request</span>" '</span></span>
<span class="line">                    <span class="token string">'<span class="token variable">$status</span> <span class="token variable">$body_bytes_sent</span> "<span class="token variable">$http_referer</span>" '</span></span>
<span class="line">                    <span class="token string">'"<span class="token variable">$http_user_agent</span>" "<span class="token variable">$http_x_forwarded_for</span>" '</span></span>
<span class="line">                    <span class="token string">'rt=<span class="token variable">$request_time</span> uct="<span class="token variable">$upstream_connect_time</span>" '</span></span>
<span class="line">                    <span class="token string">'uht="<span class="token variable">$upstream_header_time</span>" urt="<span class="token variable">$upstream_response_time</span>"'</span></span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token directive"><span class="token keyword">access_log</span> /var/log/nginx/access.log main</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 基础配置</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">sendfile</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">tcp_nopush</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">tcp_nodelay</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">keepalive_timeout</span> <span class="token number">65</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">types_hash_max_size</span> <span class="token number">2048</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">client_max_body_size</span> <span class="token number">100M</span></span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># Gzip压缩</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">gzip</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">gzip_vary</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">gzip_min_length</span> <span class="token number">1024</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">gzip_types</span> text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 上游服务器</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">upstream</span> iam_backend</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">least_conn</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">server</span> iam:8080 max_fails=3 fail_timeout=30s</span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">keepalive</span> <span class="token number">32</span></span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token directive"><span class="token keyword">upstream</span> iam_grpc</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">server</span> iam:50051</span><span class="token punctuation">;</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># HTTP服务器</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server</span></span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">listen</span> <span class="token number">80</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">server_name</span> _</span><span class="token punctuation">;</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 健康检查</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">location</span> /health</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">access_log</span> <span class="token boolean">off</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend/health</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Real-IP <span class="token variable">$remote_addr</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-For <span class="token variable">$proxy_add_x_forwarded_for</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-Proto <span class="token variable">$scheme</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># API代理</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">location</span> /api/</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Real-IP <span class="token variable">$remote_addr</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-For <span class="token variable">$proxy_add_x_forwarded_for</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-Proto <span class="token variable">$scheme</span></span><span class="token punctuation">;</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment"># 超时配置</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_connect_timeout</span> <span class="token number">5s</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_send_timeout</span> <span class="token number">60s</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_read_timeout</span> <span class="token number">60s</span></span><span class="token punctuation">;</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment"># 缓冲配置</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_buffering</span> <span class="token boolean">on</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_buffer_size</span> <span class="token number">4k</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_buffers</span> <span class="token number">8</span> <span class="token number">4k</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># Web界面</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">location</span> /</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Real-IP <span class="token variable">$remote_addr</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-For <span class="token variable">$proxy_add_x_forwarded_for</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> X-Forwarded-Proto <span class="token variable">$scheme</span></span><span class="token punctuation">;</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment"># WebSocket支持</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_http_version</span> 1.1</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Upgrade <span class="token variable">$http_upgrade</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Connection <span class="token string">"upgrade"</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment"># 静态文件缓存</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">location</span> ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_pass</span> http://iam_backend</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">proxy_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">expires</span> <span class="token number">1y</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">add_header</span> Cache-Control <span class="token string">"public, immutable"</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># gRPC服务器（如果需要直接暴露gRPC）</span></span>
<span class="line">    <span class="token directive"><span class="token keyword">server</span></span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token directive"><span class="token keyword">listen</span> <span class="token number">50051</span> http2</span><span class="token punctuation">;</span></span>
<span class="line">        </span>
<span class="line">        <span class="token directive"><span class="token keyword">location</span> /</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">grpc_pass</span> grpc://iam_grpc</span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">grpc_set_header</span> Host <span class="token variable">$host</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">grpc_set_header</span> X-Real-IP <span class="token variable">$remote_addr</span></span><span class="token punctuation">;</span></span>
<span class="line">            <span class="token directive"><span class="token keyword">grpc_set_header</span> X-Forwarded-For <span class="token variable">$proxy_add_x_forwarded_for</span></span><span class="token punctuation">;</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="创建prometheus配置" tabindex="-1"><a class="header-anchor" href="#创建prometheus配置">#</a> 创建Prometheus配置</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># prometheus/prometheus.yml</span></span>
<span class="line"><span class="token key atrule">global</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">  <span class="token key atrule">evaluation_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">  <span class="token key atrule">external_labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">cluster</span><span class="token punctuation">:</span> <span class="token string">'vgo-cluster'</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">'development'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">scrape_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># VGO IAM服务</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'vgo-iam'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'iam:8082'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">    <span class="token key atrule">scrape_timeout</span><span class="token punctuation">:</span> 5s</span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># PostgreSQL</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'postgres'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'postgres-exporter:9187'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># Redis</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'redis'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'redis-exporter:9121'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># Prometheus自身</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'prometheus'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'localhost:9090'</span><span class="token punctuation">]</span></span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># Nginx（如果配置了nginx-prometheus-exporter）</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'nginx'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'nginx-exporter:9113'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 告警规则</span></span>
<span class="line"><span class="token key atrule">rule_files</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token string">"alert_rules.yml"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 告警管理器配置（可选）</span></span>
<span class="line"><span class="token comment"># alerting:</span></span>
<span class="line"><span class="token comment">#   alertmanagers:</span></span>
<span class="line"><span class="token comment">#     - static_configs:</span></span>
<span class="line"><span class="token comment">#         - targets:</span></span>
<span class="line"><span class="token comment">#           - alertmanager:9093</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-启动服务" tabindex="-1"><a class="header-anchor" href="#_4-启动服务">#</a> 4. 启动服务</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建必要的目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token punctuation">{</span>configs,logs,nginx/conf.d,prometheus,grafana/<span class="token punctuation">{</span>provisioning,dashboards<span class="token punctuation">}</span>,certs,init-scripts<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 设置权限</span></span>
<span class="line"><span class="token function">chmod</span> +x scripts/*.sh</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动所有服务</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看服务状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs <span class="token parameter variable">-f</span> iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_5-验证部署" tabindex="-1"><a class="header-anchor" href="#_5-验证部署">#</a> 5. 验证部署</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查服务健康状态</span></span>
<span class="line"><span class="token function">curl</span> http://localhost/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试gRPC API</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问Web界面</span></span>
<span class="line"><span class="token function">open</span> http://localhost</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问监控界面</span></span>
<span class="line"><span class="token function">open</span> http://localhost:3000  <span class="token comment"># Grafana</span></span>
<span class="line"><span class="token function">open</span> http://localhost:9090  <span class="token comment"># Prometheus</span></span>
<span class="line"><span class="token function">open</span> http://localhost:16686 <span class="token comment"># Jaeger</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-配置详解" tabindex="-1"><a class="header-anchor" href="#🔧-配置详解">#</a> 🔧 配置详解</h2>
<h3 id="环境变量配置" tabindex="-1"><a class="header-anchor" href="#环境变量配置">#</a> 环境变量配置</h3>
<h4 id="数据库配置" tabindex="-1"><a class="header-anchor" href="#数据库配置">#</a> 数据库配置</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 基础连接配置</span></span>
<span class="line"><span class="token assign-left variable">DB_HOST</span><span class="token operator">=</span>postgres</span>
<span class="line"><span class="token assign-left variable">DB_PORT</span><span class="token operator">=</span><span class="token number">5432</span></span>
<span class="line"><span class="token assign-left variable">DB_NAME</span><span class="token operator">=</span>vgo_db</span>
<span class="line"><span class="token assign-left variable">DB_USER</span><span class="token operator">=</span>vgo_user</span>
<span class="line"><span class="token assign-left variable">DB_PASSWORD</span><span class="token operator">=</span>your-password</span>
<span class="line"><span class="token assign-left variable">DB_SSLMODE</span><span class="token operator">=</span>disable</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 连接池配置</span></span>
<span class="line"><span class="token assign-left variable">DB_MAX_OPEN_CONNS</span><span class="token operator">=</span><span class="token number">25</span>        <span class="token comment"># 最大打开连接数</span></span>
<span class="line"><span class="token assign-left variable">DB_MAX_IDLE_CONNS</span><span class="token operator">=</span><span class="token number">5</span>         <span class="token comment"># 最大空闲连接数</span></span>
<span class="line"><span class="token assign-left variable">DB_CONN_MAX_LIFETIME</span><span class="token operator">=</span>300s   <span class="token comment"># 连接最大生命周期</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查询配置</span></span>
<span class="line"><span class="token assign-left variable">DB_QUERY_TIMEOUT</span><span class="token operator">=</span>30s        <span class="token comment"># 查询超时时间</span></span>
<span class="line"><span class="token assign-left variable">DB_EXEC_TIMEOUT</span><span class="token operator">=</span>30s         <span class="token comment"># 执行超时时间</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="redis配置" tabindex="-1"><a class="header-anchor" href="#redis配置">#</a> Redis配置</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 基础连接配置</span></span>
<span class="line"><span class="token assign-left variable">REDIS_HOST</span><span class="token operator">=</span>redis</span>
<span class="line"><span class="token assign-left variable">REDIS_PORT</span><span class="token operator">=</span><span class="token number">6379</span></span>
<span class="line"><span class="token assign-left variable">REDIS_PASSWORD</span><span class="token operator">=</span>your-password</span>
<span class="line"><span class="token assign-left variable">REDIS_DB</span><span class="token operator">=</span><span class="token number">0</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 连接池配置</span></span>
<span class="line"><span class="token assign-left variable">REDIS_POOL_SIZE</span><span class="token operator">=</span><span class="token number">10</span>          <span class="token comment"># 连接池大小</span></span>
<span class="line"><span class="token assign-left variable">REDIS_MIN_IDLE_CONNS</span><span class="token operator">=</span><span class="token number">5</span>      <span class="token comment"># 最小空闲连接数</span></span>
<span class="line"><span class="token assign-left variable">REDIS_POOL_TIMEOUT</span><span class="token operator">=</span>5s       <span class="token comment"># 连接池超时</span></span>
<span class="line"><span class="token assign-left variable">REDIS_IDLE_TIMEOUT</span><span class="token operator">=</span>300s     <span class="token comment"># 空闲连接超时</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 缓存配置</span></span>
<span class="line"><span class="token assign-left variable">REDIS_DEFAULT_TTL</span><span class="token operator">=</span>3600s     <span class="token comment"># 默认TTL</span></span>
<span class="line"><span class="token assign-left variable">REDIS_MAX_RETRIES</span><span class="token operator">=</span><span class="token number">3</span>         <span class="token comment"># 最大重试次数</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="服务配置" tabindex="-1"><a class="header-anchor" href="#服务配置">#</a> 服务配置</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 端口配置</span></span>
<span class="line"><span class="token assign-left variable">GRPC_PORT</span><span class="token operator">=</span><span class="token number">50051</span></span>
<span class="line"><span class="token assign-left variable">HTTP_PORT</span><span class="token operator">=</span><span class="token number">8080</span></span>
<span class="line"><span class="token assign-left variable">HEALTH_PORT</span><span class="token operator">=</span><span class="token number">8081</span></span>
<span class="line"><span class="token assign-left variable">METRICS_PORT</span><span class="token operator">=</span><span class="token number">8082</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 性能配置</span></span>
<span class="line"><span class="token assign-left variable">GOMEMLIMIT</span><span class="token operator">=</span>1GiB            <span class="token comment"># Go内存限制</span></span>
<span class="line"><span class="token assign-left variable">GOMAXPROCS</span><span class="token operator">=</span><span class="token number">4</span>               <span class="token comment"># Go最大进程数</span></span>
<span class="line"><span class="token assign-left variable">GOGC</span><span class="token operator">=</span><span class="token number">100</span>                   <span class="token comment"># GC目标百分比</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 超时配置</span></span>
<span class="line"><span class="token assign-left variable">SERVER_READ_TIMEOUT</span><span class="token operator">=</span>30s    <span class="token comment"># 读取超时</span></span>
<span class="line"><span class="token assign-left variable">SERVER_WRITE_TIMEOUT</span><span class="token operator">=</span>30s   <span class="token comment"># 写入超时</span></span>
<span class="line"><span class="token assign-left variable">SERVER_IDLE_TIMEOUT</span><span class="token operator">=</span>120s   <span class="token comment"># 空闲超时</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="数据初始化" tabindex="-1"><a class="header-anchor" href="#数据初始化">#</a> 数据初始化</h3>
<h4 id="创建初始化脚本" tabindex="-1"><a class="header-anchor" href="#创建初始化脚本">#</a> 创建初始化脚本</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- init-scripts/01-init-database.sql</span></span>
<span class="line"><span class="token comment">-- 创建扩展</span></span>
<span class="line"><span class="token keyword">CREATE</span> EXTENSION <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> <span class="token string">"uuid-ossp"</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> EXTENSION <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> <span class="token string">"pgcrypto"</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建用户表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> users <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> uuid_generate_v4<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    username <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    email <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    password_hash <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建策略表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> policies <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> uuid_generate_v4<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    name <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    description <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    document JSONB <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    version <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'2025-01-01'</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建用户策略关联表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> user_policies <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> uuid_generate_v4<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    user_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span> <span class="token keyword">ON</span> <span class="token keyword">DELETE</span> <span class="token keyword">CASCADE</span><span class="token punctuation">,</span></span>
<span class="line">    policy_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> policies<span class="token punctuation">(</span>id<span class="token punctuation">)</span> <span class="token keyword">ON</span> <span class="token keyword">DELETE</span> <span class="token keyword">CASCADE</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">UNIQUE</span><span class="token punctuation">(</span>user_id<span class="token punctuation">,</span> policy_id<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建访问密钥表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> access_keys <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> uuid_generate_v4<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    user_id UUID <span class="token operator">NOT</span> <span class="token boolean">NULL</span> <span class="token keyword">REFERENCES</span> users<span class="token punctuation">(</span>id<span class="token punctuation">)</span> <span class="token keyword">ON</span> <span class="token keyword">DELETE</span> <span class="token keyword">CASCADE</span><span class="token punctuation">,</span></span>
<span class="line">    access_key_id <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    secret_access_key_hash <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    description <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    last_used_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE<span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建应用表</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> applications <span class="token punctuation">(</span></span>
<span class="line">    id UUID <span class="token keyword">PRIMARY</span> <span class="token keyword">KEY</span> <span class="token keyword">DEFAULT</span> uuid_generate_v4<span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    name <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    description <span class="token keyword">TEXT</span><span class="token punctuation">,</span></span>
<span class="line">    client_id <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token keyword">UNIQUE</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    client_secret_hash <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">255</span><span class="token punctuation">)</span> <span class="token operator">NOT</span> <span class="token boolean">NULL</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">type</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'web'</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token keyword">status</span> <span class="token keyword">VARCHAR</span><span class="token punctuation">(</span><span class="token number">50</span><span class="token punctuation">)</span> <span class="token keyword">DEFAULT</span> <span class="token string">'active'</span><span class="token punctuation">,</span></span>
<span class="line">    created_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    updated_at <span class="token keyword">TIMESTAMP</span> <span class="token keyword">WITH</span> <span class="token keyword">TIME</span> ZONE <span class="token keyword">DEFAULT</span> <span class="token function">NOW</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 创建索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_users_username <span class="token keyword">ON</span> users<span class="token punctuation">(</span>username<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_users_email <span class="token keyword">ON</span> users<span class="token punctuation">(</span>email<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_users_status <span class="token keyword">ON</span> users<span class="token punctuation">(</span><span class="token keyword">status</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_policies_name <span class="token keyword">ON</span> policies<span class="token punctuation">(</span>name<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_user_policies_user_id <span class="token keyword">ON</span> user_policies<span class="token punctuation">(</span>user_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_user_policies_policy_id <span class="token keyword">ON</span> user_policies<span class="token punctuation">(</span>policy_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_access_keys_user_id <span class="token keyword">ON</span> access_keys<span class="token punctuation">(</span>user_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_access_keys_access_key_id <span class="token keyword">ON</span> access_keys<span class="token punctuation">(</span>access_key_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> <span class="token keyword">IF</span> <span class="token operator">NOT</span> <span class="token keyword">EXISTS</span> idx_applications_client_id <span class="token keyword">ON</span> applications<span class="token punctuation">(</span>client_id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- init-scripts/02-seed-data.sql</span></span>
<span class="line"><span class="token comment">-- 插入管理员用户</span></span>
<span class="line"><span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> users <span class="token punctuation">(</span>username<span class="token punctuation">,</span> email<span class="token punctuation">,</span> password_hash<span class="token punctuation">,</span> <span class="token keyword">status</span><span class="token punctuation">)</span> <span class="token keyword">VALUES</span> </span>
<span class="line"><span class="token punctuation">(</span><span class="token string">'admin'</span><span class="token punctuation">,</span> <span class="token string">'admin@example.com'</span><span class="token punctuation">,</span> crypt<span class="token punctuation">(</span><span class="token string">'admin123'</span><span class="token punctuation">,</span> gen_salt<span class="token punctuation">(</span><span class="token string">'bf'</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">'active'</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">ON</span> CONFLICT <span class="token punctuation">(</span>username<span class="token punctuation">)</span> <span class="token keyword">DO</span> NOTHING<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 插入管理员策略</span></span>
<span class="line"><span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> policies <span class="token punctuation">(</span>name<span class="token punctuation">,</span> description<span class="token punctuation">,</span> document<span class="token punctuation">)</span> <span class="token keyword">VALUES</span> </span>
<span class="line"><span class="token punctuation">(</span><span class="token string">'AdminPolicy'</span><span class="token punctuation">,</span> <span class="token string">'管理员完全权限策略'</span><span class="token punctuation">,</span> <span class="token string">'{</span>
<span class="line">  "Version": "2025-01-01",</span>
<span class="line">  "Statement": [</span>
<span class="line">    {</span>
<span class="line">      "Effect": "Allow",</span>
<span class="line">      "Action": "*",</span>
<span class="line">      "Resource": "*"</span>
<span class="line">    }</span>
<span class="line">  ]</span>
<span class="line">}'</span>::jsonb<span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">ON</span> CONFLICT <span class="token punctuation">(</span>name<span class="token punctuation">)</span> <span class="token keyword">DO</span> NOTHING<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 绑定管理员策略</span></span>
<span class="line"><span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> user_policies <span class="token punctuation">(</span>user_id<span class="token punctuation">,</span> policy_id<span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">SELECT</span> u<span class="token punctuation">.</span>id<span class="token punctuation">,</span> p<span class="token punctuation">.</span>id</span>
<span class="line"><span class="token keyword">FROM</span> users u<span class="token punctuation">,</span> policies p</span>
<span class="line"><span class="token keyword">WHERE</span> u<span class="token punctuation">.</span>username <span class="token operator">=</span> <span class="token string">'admin'</span> <span class="token operator">AND</span> p<span class="token punctuation">.</span>name <span class="token operator">=</span> <span class="token string">'AdminPolicy'</span></span>
<span class="line"><span class="token keyword">ON</span> CONFLICT <span class="token punctuation">(</span>user_id<span class="token punctuation">,</span> policy_id<span class="token punctuation">)</span> <span class="token keyword">DO</span> NOTHING<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 插入只读策略</span></span>
<span class="line"><span class="token keyword">INSERT</span> <span class="token keyword">INTO</span> policies <span class="token punctuation">(</span>name<span class="token punctuation">,</span> description<span class="token punctuation">,</span> document<span class="token punctuation">)</span> <span class="token keyword">VALUES</span> </span>
<span class="line"><span class="token punctuation">(</span><span class="token string">'ReadOnlyPolicy'</span><span class="token punctuation">,</span> <span class="token string">'只读权限策略'</span><span class="token punctuation">,</span> <span class="token string">'{</span>
<span class="line">  "Version": "2025-01-01",</span>
<span class="line">  "Statement": [</span>
<span class="line">    {</span>
<span class="line">      "Effect": "Allow",</span>
<span class="line">      "Action": [</span>
<span class="line">        "iam:GetUser",</span>
<span class="line">        "iam:ListUsers",</span>
<span class="line">        "iam:GetPolicy",</span>
<span class="line">        "iam:ListPolicies",</span>
<span class="line">        "iam:ListUserPolicies",</span>
<span class="line">        "iam:CheckPermission"</span>
<span class="line">      ],</span>
<span class="line">      "Resource": "*"</span>
<span class="line">    }</span>
<span class="line">  ]</span>
<span class="line">}'</span>::jsonb<span class="token punctuation">)</span></span>
<span class="line"><span class="token keyword">ON</span> CONFLICT <span class="token punctuation">(</span>name<span class="token punctuation">)</span> <span class="token keyword">DO</span> NOTHING<span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="备份和恢复" tabindex="-1"><a class="header-anchor" href="#备份和恢复">#</a> 备份和恢复</h3>
<h4 id="自动备份脚本" tabindex="-1"><a class="header-anchor" href="#自动备份脚本">#</a> 自动备份脚本</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/backup.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 配置</span></span>
<span class="line"><span class="token assign-left variable">BACKUP_DIR</span><span class="token operator">=</span><span class="token string">"./backups"</span></span>
<span class="line"><span class="token assign-left variable">DATE</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +%Y%m%d_%H%M%S<span class="token variable">)</span></span></span>
<span class="line"><span class="token assign-left variable">RETENTION_DAYS</span><span class="token operator">=</span><span class="token number">7</span></span>
<span class="line"><span class="token assign-left variable">COMPOSE_PROJECT</span><span class="token operator">=</span><span class="token string">"vgo"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建备份目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token variable">$BACKUP_DIR</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"开始备份 - <span class="token variable">$DATE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 备份数据库</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份PostgreSQL数据库..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> <span class="token parameter variable">-T</span> postgres pg_dump <span class="token parameter variable">-U</span> vgo_user vgo_db <span class="token operator">|</span> <span class="token function">gzip</span> <span class="token operator">></span> <span class="token variable">$BACKUP_DIR</span>/postgres_<span class="token variable">$DATE</span>.sql.gz</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 备份Redis</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份Redis数据..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli BGSAVE</span>
<span class="line"><span class="token function">sleep</span> <span class="token number">5</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis <span class="token function">cat</span> /data/dump.rdb <span class="token operator">|</span> <span class="token function">gzip</span> <span class="token operator">></span> <span class="token variable">$BACKUP_DIR</span>/redis_<span class="token variable">$DATE</span>.rdb.gz</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 备份配置文件</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份配置文件..."</span></span>
<span class="line"><span class="token function">tar</span> <span class="token parameter variable">-czf</span> <span class="token variable">$BACKUP_DIR</span>/configs_<span class="token variable">$DATE</span>.tar.gz configs/ .env docker-compose.yml nginx/ prometheus/ grafana/</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 备份日志（最近7天）</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份日志文件..."</span></span>
<span class="line"><span class="token function">find</span> logs/ <span class="token parameter variable">-name</span> <span class="token string">"*.log"</span> <span class="token parameter variable">-mtime</span> <span class="token parameter variable">-7</span> <span class="token operator">|</span> <span class="token function">tar</span> <span class="token parameter variable">-czf</span> <span class="token variable">$BACKUP_DIR</span>/logs_<span class="token variable">$DATE</span>.tar.gz <span class="token parameter variable">-T</span> -</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 清理旧备份</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"清理旧备份..."</span></span>
<span class="line"><span class="token function">find</span> <span class="token variable">$BACKUP_DIR</span> <span class="token parameter variable">-name</span> <span class="token string">"*.gz"</span> <span class="token parameter variable">-mtime</span> +<span class="token variable">$RETENTION_DAYS</span> <span class="token parameter variable">-delete</span></span>
<span class="line"><span class="token function">find</span> <span class="token variable">$BACKUP_DIR</span> <span class="token parameter variable">-name</span> <span class="token string">"*.tar.gz"</span> <span class="token parameter variable">-mtime</span> +<span class="token variable">$RETENTION_DAYS</span> <span class="token parameter variable">-delete</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份完成 - <span class="token variable">$DATE</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"备份文件:"</span></span>
<span class="line"><span class="token function">ls</span> <span class="token parameter variable">-la</span> <span class="token variable">$BACKUP_DIR</span>/*<span class="token variable">$DATE</span>*</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="恢复脚本" tabindex="-1"><a class="header-anchor" href="#恢复脚本">#</a> 恢复脚本</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/restore.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token variable">$#</span> <span class="token parameter variable">-ne</span> <span class="token number">1</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"用法: <span class="token variable">$0</span> &lt;备份日期>"</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"示例: <span class="token variable">$0</span> 20240115_103000"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">BACKUP_DATE</span><span class="token operator">=</span><span class="token variable">$1</span></span>
<span class="line"><span class="token assign-left variable">BACKUP_DIR</span><span class="token operator">=</span><span class="token string">"./backups"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"开始恢复 - <span class="token variable">$BACKUP_DATE</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查备份文件是否存在</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token operator">!</span> <span class="token parameter variable">-f</span> <span class="token string">"<span class="token variable">$BACKUP_DIR</span>/postgres_<span class="token variable">$BACKUP_DATE</span>.sql.gz"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"错误: 找不到数据库备份文件"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 停止服务</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"停止服务..."</span></span>
<span class="line"><span class="token function">docker-compose</span> stop iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 恢复数据库</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"恢复PostgreSQL数据库..."</span></span>
<span class="line">zcat <span class="token variable">$BACKUP_DIR</span>/postgres_<span class="token variable">$BACKUP_DATE</span>.sql.gz <span class="token operator">|</span> <span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> <span class="token parameter variable">-T</span> postgres psql <span class="token parameter variable">-U</span> vgo_user <span class="token parameter variable">-d</span> vgo_db</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 恢复Redis</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"<span class="token variable">$BACKUP_DIR</span>/redis_<span class="token variable">$BACKUP_DATE</span>.rdb.gz"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"恢复Redis数据..."</span></span>
<span class="line">    <span class="token function">docker-compose</span> stop redis</span>
<span class="line">    zcat <span class="token variable">$BACKUP_DIR</span>/redis_<span class="token variable">$BACKUP_DATE</span>.rdb.gz <span class="token operator">|</span> <span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> <span class="token parameter variable">-T</span> redis <span class="token function">sh</span> <span class="token parameter variable">-c</span> <span class="token string">'cat > /data/dump.rdb'</span></span>
<span class="line">    <span class="token function">docker-compose</span> start redis</span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 恢复配置文件（可选）</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"<span class="token variable">$BACKUP_DIR</span>/configs_<span class="token variable">$BACKUP_DATE</span>.tar.gz"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"是否恢复配置文件? (y/N)"</span></span>
<span class="line">    <span class="token builtin class-name">read</span> <span class="token parameter variable">-r</span> response</span>
<span class="line">    <span class="token keyword">if</span> <span class="token punctuation">[</span><span class="token punctuation">[</span> <span class="token string">"<span class="token variable">$response</span>"</span> <span class="token operator">=~</span> ^<span class="token punctuation">[</span>Yy<span class="token punctuation">]</span>$ <span class="token punctuation">]</span><span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"恢复配置文件..."</span></span>
<span class="line">        <span class="token function">tar</span> <span class="token parameter variable">-xzf</span> <span class="token variable">$BACKUP_DIR</span>/configs_<span class="token variable">$BACKUP_DATE</span>.tar.gz</span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动服务</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"启动服务..."</span></span>
<span class="line"><span class="token function">docker-compose</span> start iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待服务启动</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"等待服务启动..."</span></span>
<span class="line"><span class="token function">sleep</span> <span class="token number">10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 验证恢复</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"验证恢复..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-f</span> http://localhost/health <span class="token operator">></span> /dev/null <span class="token operator"><span class="token file-descriptor important">2</span>></span><span class="token file-descriptor important">&amp;1</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"恢复成功!"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"恢复可能失败，请检查服务状态"</span></span>
<span class="line">    <span class="token function">docker-compose</span> logs iam</span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-故障排除" tabindex="-1"><a class="header-anchor" href="#🔍-故障排除">#</a> 🔍 故障排除</h2>
<h3 id="常见问题" tabindex="-1"><a class="header-anchor" href="#常见问题">#</a> 常见问题</h3>
<h4 id="_1-容器启动失败" tabindex="-1"><a class="header-anchor" href="#_1-容器启动失败">#</a> 1. 容器启动失败</h4>
<p><strong>问题</strong>: 容器无法启动或立即退出</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看容器状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看容器日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs iam</span>
<span class="line"><span class="token function">docker-compose</span> logs postgres</span>
<span class="line"><span class="token function">docker-compose</span> logs redis</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查资源使用</span></span>
<span class="line"><span class="token function">docker</span> stats</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查端口占用</span></span>
<span class="line"><span class="token function">netstat</span> <span class="token parameter variable">-tlnp</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">':(50051|8080|5432|6379)'</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>常见解决方案</strong>:</p>
<ul>
<li>检查端口是否被占用</li>
<li>确认配置文件语法正确</li>
<li>检查磁盘空间是否充足</li>
<li>验证环境变量设置</li>
</ul>
<h4 id="_2-数据库连接失败" tabindex="-1"><a class="header-anchor" href="#_2-数据库连接失败">#</a> 2. 数据库连接失败</h4>
<p><strong>问题</strong>: IAM服务无法连接到PostgreSQL</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查PostgreSQL状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres pg_isready <span class="token parameter variable">-U</span> vgo_user</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试数据库连接</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres psql <span class="token parameter variable">-U</span> vgo_user <span class="token parameter variable">-d</span> vgo_db <span class="token parameter variable">-c</span> <span class="token string">"SELECT 1;"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查网络连通性</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam <span class="token function">ping</span> postgres</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看数据库日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs postgres</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>解决方案</strong>:</p>
<ul>
<li>确认数据库用户名密码正确</li>
<li>检查数据库是否已完全启动</li>
<li>验证网络配置</li>
<li>检查防火墙设置</li>
</ul>
<h4 id="_3-redis连接问题" tabindex="-1"><a class="header-anchor" href="#_3-redis连接问题">#</a> 3. Redis连接问题</h4>
<p><strong>问题</strong>: 无法连接到Redis缓存</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查Redis状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli <span class="token function">ping</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试认证</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli <span class="token parameter variable">-a</span> your-password <span class="token function">ping</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Redis配置</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli CONFIG GET <span class="token string">'*'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看Redis日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs redis</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_4-性能问题" tabindex="-1"><a class="header-anchor" href="#_4-性能问题">#</a> 4. 性能问题</h4>
<p><strong>问题</strong>: 服务响应缓慢</p>
<p><strong>排查步骤</strong>:</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查资源使用</span></span>
<span class="line"><span class="token function">docker</span> stats</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看数据库性能</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> postgres psql <span class="token parameter variable">-U</span> vgo_user <span class="token parameter variable">-d</span> vgo_db <span class="token parameter variable">-c</span> <span class="token string">"</span>
<span class="line">  SELECT query, mean_time, calls </span>
<span class="line">  FROM pg_stat_statements </span>
<span class="line">  ORDER BY mean_time DESC </span>
<span class="line">  LIMIT 10;"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Redis性能</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> redis redis-cli --latency-history</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看应用指标</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8082/metrics</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="监控和调试" tabindex="-1"><a class="header-anchor" href="#监控和调试">#</a> 监控和调试</h3>
<h4 id="启用调试日志" tabindex="-1"><a class="header-anchor" href="#启用调试日志">#</a> 启用调试日志</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> LOG_LEVEL=debug</span>
<span class="line">      <span class="token punctuation">-</span> DB_LOG_LEVEL=debug</span>
<span class="line">      <span class="token punctuation">-</span> GRPC_LOG_LEVEL=debug</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="性能分析" tabindex="-1"><a class="header-anchor" href="#性能分析">#</a> 性能分析</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启用Go性能分析</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam <span class="token function">curl</span> http://localhost:8082/debug/pprof/profile?seconds<span class="token operator">=</span><span class="token number">30</span> <span class="token operator">></span> cpu.prof</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 内存分析</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam <span class="token function">curl</span> http://localhost:8082/debug/pprof/heap <span class="token operator">></span> heap.prof</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看goroutine</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> iam <span class="token function">curl</span> http://localhost:8082/debug/pprof/goroutine?debug<span class="token operator">=</span><span class="token number">1</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-生产环境优化" tabindex="-1"><a class="header-anchor" href="#📈-生产环境优化">#</a> 📈 生产环境优化</h2>
<h3 id="资源限制" tabindex="-1"><a class="header-anchor" href="#资源限制">#</a> 资源限制</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">deploy</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'2.0'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1G</span>
<span class="line">        <span class="token key atrule">reservations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'0.5'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 512M</span>
<span class="line">    </span>
<span class="line">  <span class="token key atrule">postgres</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">deploy</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'1.0'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 2G</span>
<span class="line">        <span class="token key atrule">reservations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'0.5'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1G</span>
<span class="line">    </span>
<span class="line">  <span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">deploy</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'0.5'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 512M</span>
<span class="line">        <span class="token key atrule">reservations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">cpus</span><span class="token punctuation">:</span> <span class="token string">'0.1'</span></span>
<span class="line">          <span class="token key atrule">memory</span><span class="token punctuation">:</span> 128M</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="安全加固" tabindex="-1"><a class="header-anchor" href="#安全加固">#</a> 安全加固</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">security_opt</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> no<span class="token punctuation">-</span>new<span class="token punctuation">-</span>privileges<span class="token punctuation">:</span><span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">read_only</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">tmpfs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> /tmp</span>
<span class="line">      <span class="token punctuation">-</span> /var/tmp</span>
<span class="line">    <span class="token key atrule">user</span><span class="token punctuation">:</span> <span class="token string">"1000:1000"</span></span>
<span class="line">    <span class="token key atrule">cap_drop</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ALL</span>
<span class="line">    <span class="token key atrule">cap_add</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> NET_BIND_SERVICE</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="日志管理" tabindex="-1"><a class="header-anchor" href="#日志管理">#</a> 日志管理</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.yml</span></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">logging</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">driver</span><span class="token punctuation">:</span> <span class="token string">"json-file"</span></span>
<span class="line">      <span class="token key atrule">options</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">max-size</span><span class="token punctuation">:</span> <span class="token string">"100m"</span></span>
<span class="line">        <span class="token key atrule">max-file</span><span class="token punctuation">:</span> <span class="token string">"5"</span></span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span> <span class="token string">"service=iam,environment=production"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/deployment/kubernetes.html">Kubernetes部署</RouteLink> - 生产级容器编排</li>
<li><RouteLink to="/deployment/monitoring.html">监控配置</RouteLink> - 完整监控解决方案</li>
<li><RouteLink to="/deployment/security.html">安全配置</RouteLink> - 生产环境安全</li>
<li><RouteLink to="/deployment/troubleshooting.html">故障排除</RouteLink> - 问题诊断指南</li>
<li><RouteLink to="/deployment/performance.html">性能调优</RouteLink> - 性能优化建议</li>
</ul>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>Docker Compose适合中小规模部署，对于大规模生产环境建议使用Kubernetes。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>生产环境请务必修改默认密码，启用TLS加密，并配置适当的资源限制。</p>
</div>
</div></template>


