<template><div><h1 id="配置详解" tabindex="-1"><a class="header-anchor" href="#配置详解">#</a> 配置详解</h1>
<p>本文档详细介绍VGO微服务的配置选项，帮助您根据实际需求进行个性化配置。</p>
<h2 id="📁-配置文件结构" tabindex="-1"><a class="header-anchor" href="#📁-配置文件结构">#</a> 📁 配置文件结构</h2>
<p>VGO使用YAML格式的配置文件，默认位置为 <code v-pre>config/config.yaml</code>。配置文件包含以下主要部分：</p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># 服务基本配置</span></span>
<span class="line"><span class="token key atrule">server</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">grpc_port</span><span class="token punctuation">:</span> <span class="token string">"50051"</span></span>
<span class="line">  <span class="token key atrule">http_port</span><span class="token punctuation">:</span> <span class="token string">"8080"</span></span>
<span class="line">  <span class="token key atrule">debug_mode</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 数据库配置</span></span>
<span class="line"><span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">dsn</span><span class="token punctuation">:</span> <span class="token string">"postgres://user:password@localhost:5432/dbname?sslmode=disable"</span></span>
<span class="line">  <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">25</span></span>
<span class="line">  <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> <span class="token string">"1h"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 缓存配置</span></span>
<span class="line"><span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">addr</span><span class="token punctuation">:</span> <span class="token string">"localhost:6379"</span></span>
<span class="line">  <span class="token key atrule">password</span><span class="token punctuation">:</span> <span class="token string">""</span></span>
<span class="line">  <span class="token key atrule">db</span><span class="token punctuation">:</span> <span class="token number">0</span></span>
<span class="line">  <span class="token key atrule">pool_size</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安全配置</span></span>
<span class="line"><span class="token key atrule">security</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">master_key</span><span class="token punctuation">:</span> <span class="token string">"your-master-key-here"</span></span>
<span class="line">  <span class="token key atrule">jwt_secret</span><span class="token punctuation">:</span> <span class="token string">"your-jwt-secret-here"</span></span>
<span class="line">  <span class="token key atrule">access_key_rotation_interval</span><span class="token punctuation">:</span> <span class="token string">"24h"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 日志配置</span></span>
<span class="line"><span class="token key atrule">log</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">level</span><span class="token punctuation">:</span> <span class="token string">"info"</span></span>
<span class="line">  <span class="token key atrule">format</span><span class="token punctuation">:</span> <span class="token string">"json"</span></span>
<span class="line">  <span class="token key atrule">output</span><span class="token punctuation">:</span> <span class="token string">"stdout"</span></span>
<span class="line">  <span class="token key atrule">file_path</span><span class="token punctuation">:</span> <span class="token string">"./logs/iam.log"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 监控配置</span></span>
<span class="line"><span class="token key atrule">metrics</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token string">"9090"</span></span>
<span class="line">  <span class="token key atrule">path</span><span class="token punctuation">:</span> <span class="token string">"/metrics"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 链路追踪配置</span></span>
<span class="line"><span class="token key atrule">tracing</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">jaeger_endpoint</span><span class="token punctuation">:</span> <span class="token string">"http://localhost:14268/api/traces"</span></span>
<span class="line">  <span class="token key atrule">service_name</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 错误监控配置</span></span>
<span class="line"><span class="token key atrule">sentry</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">dsn</span><span class="token punctuation">:</span> <span class="token string">"https://your-sentry-dsn@sentry.io/project-id"</span></span>
<span class="line">  <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">"production"</span></span>
<span class="line">  <span class="token key atrule">debug</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🖥️-服务配置" tabindex="-1"><a class="header-anchor" href="#🖥️-服务配置">#</a> 🖥️ 服务配置</h2>
<h3 id="基本服务设置" tabindex="-1"><a class="header-anchor" href="#基本服务设置">#</a> 基本服务设置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">server</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># gRPC服务端口</span></span>
<span class="line">  <span class="token key atrule">grpc_port</span><span class="token punctuation">:</span> <span class="token string">"50051"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># HTTP调试界面端口</span></span>
<span class="line">  <span class="token key atrule">http_port</span><span class="token punctuation">:</span> <span class="token string">"8080"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 调试模式（开发环境建议开启）</span></span>
<span class="line">  <span class="token key atrule">debug_mode</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 服务绑定地址</span></span>
<span class="line">  <span class="token key atrule">bind_addr</span><span class="token punctuation">:</span> <span class="token string">"0.0.0.0"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 优雅关闭超时时间</span></span>
<span class="line">  <span class="token key atrule">shutdown_timeout</span><span class="token punctuation">:</span> <span class="token string">"30s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 读取超时时间</span></span>
<span class="line">  <span class="token key atrule">read_timeout</span><span class="token punctuation">:</span> <span class="token string">"10s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 写入超时时间</span></span>
<span class="line">  <span class="token key atrule">write_timeout</span><span class="token punctuation">:</span> <span class="token string">"10s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 空闲超时时间</span></span>
<span class="line">  <span class="token key atrule">idle_timeout</span><span class="token punctuation">:</span> <span class="token string">"60s"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="grpc配置" tabindex="-1"><a class="header-anchor" href="#grpc配置">#</a> gRPC配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">grpc</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 最大接收消息大小（字节）</span></span>
<span class="line">  <span class="token key atrule">max_recv_msg_size</span><span class="token punctuation">:</span> <span class="token number">4194304</span>  <span class="token comment"># 4MB</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 最大发送消息大小（字节）</span></span>
<span class="line">  <span class="token key atrule">max_send_msg_size</span><span class="token punctuation">:</span> <span class="token number">4194304</span>  <span class="token comment"># 4MB</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接超时时间</span></span>
<span class="line">  <span class="token key atrule">connection_timeout</span><span class="token punctuation">:</span> <span class="token string">"5s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 保持连接设置</span></span>
<span class="line">  <span class="token key atrule">keepalive</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">time</span><span class="token punctuation">:</span> <span class="token string">"30s"</span></span>
<span class="line">    <span class="token key atrule">timeout</span><span class="token punctuation">:</span> <span class="token string">"5s"</span></span>
<span class="line">    <span class="token key atrule">permit_without_stream</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🗄️-数据库配置" tabindex="-1"><a class="header-anchor" href="#🗄️-数据库配置">#</a> 🗄️ 数据库配置</h2>
<h3 id="postgresql配置" tabindex="-1"><a class="header-anchor" href="#postgresql配置">#</a> PostgreSQL配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 数据库连接字符串</span></span>
<span class="line">  <span class="token key atrule">dsn</span><span class="token punctuation">:</span> <span class="token string">"postgres://username:password@hostname:port/database?sslmode=disable"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 最大打开连接数</span></span>
<span class="line">  <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">25</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 最大空闲连接数</span></span>
<span class="line">  <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接最大生存时间</span></span>
<span class="line">  <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> <span class="token string">"1h"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接最大空闲时间</span></span>
<span class="line">  <span class="token key atrule">conn_max_idle_time</span><span class="token punctuation">:</span> <span class="token string">"30m"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 数据库迁移设置</span></span>
<span class="line">  <span class="token key atrule">migration</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">path</span><span class="token punctuation">:</span> <span class="token string">"./migrations"</span></span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># 慢查询日志阈值</span></span>
<span class="line">  <span class="token key atrule">slow_query_threshold</span><span class="token punctuation">:</span> <span class="token string">"1s"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="连接池优化" tabindex="-1"><a class="header-anchor" href="#连接池优化">#</a> 连接池优化</h3>
<p>根据不同环境调整连接池参数：</p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># 开发环境</span></span>
<span class="line"><span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">  <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">2</span></span>
<span class="line">  <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> <span class="token string">"30m"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试环境</span></span>
<span class="line"><span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">20</span></span>
<span class="line">  <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">  <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> <span class="token string">"1h"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生产环境</span></span>
<span class="line"><span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">50</span></span>
<span class="line">  <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">  <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> <span class="token string">"2h"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚀-缓存配置" tabindex="-1"><a class="header-anchor" href="#🚀-缓存配置">#</a> 🚀 缓存配置</h2>
<h3 id="redis配置" tabindex="-1"><a class="header-anchor" href="#redis配置">#</a> Redis配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># Redis服务器地址</span></span>
<span class="line">  <span class="token key atrule">addr</span><span class="token punctuation">:</span> <span class="token string">"localhost:6379"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 认证密码</span></span>
<span class="line">  <span class="token key atrule">password</span><span class="token punctuation">:</span> <span class="token string">""</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 数据库编号</span></span>
<span class="line">  <span class="token key atrule">db</span><span class="token punctuation">:</span> <span class="token number">0</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接池大小</span></span>
<span class="line">  <span class="token key atrule">pool_size</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 最小空闲连接数</span></span>
<span class="line">  <span class="token key atrule">min_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接超时时间</span></span>
<span class="line">  <span class="token key atrule">dial_timeout</span><span class="token punctuation">:</span> <span class="token string">"5s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 读取超时时间</span></span>
<span class="line">  <span class="token key atrule">read_timeout</span><span class="token punctuation">:</span> <span class="token string">"3s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 写入超时时间</span></span>
<span class="line">  <span class="token key atrule">write_timeout</span><span class="token punctuation">:</span> <span class="token string">"3s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 连接池超时时间</span></span>
<span class="line">  <span class="token key atrule">pool_timeout</span><span class="token punctuation">:</span> <span class="token string">"4s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 空闲连接检查频率</span></span>
<span class="line">  <span class="token key atrule">idle_check_frequency</span><span class="token punctuation">:</span> <span class="token string">"60s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 最大连接年龄</span></span>
<span class="line">  <span class="token key atrule">max_conn_age</span><span class="token punctuation">:</span> <span class="token string">"30m"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 空闲超时时间</span></span>
<span class="line">  <span class="token key atrule">idle_timeout</span><span class="token punctuation">:</span> <span class="token string">"5m"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="缓存策略" tabindex="-1"><a class="header-anchor" href="#缓存策略">#</a> 缓存策略</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">cache</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 用户信息缓存时间</span></span>
<span class="line">  <span class="token key atrule">user_cache_ttl</span><span class="token punctuation">:</span> <span class="token string">"15m"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 策略缓存时间</span></span>
<span class="line">  <span class="token key atrule">policy_cache_ttl</span><span class="token punctuation">:</span> <span class="token string">"30m"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 访问密钥缓存时间</span></span>
<span class="line">  <span class="token key atrule">access_key_cache_ttl</span><span class="token punctuation">:</span> <span class="token string">"10m"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 权限检查缓存时间</span></span>
<span class="line">  <span class="token key atrule">permission_cache_ttl</span><span class="token punctuation">:</span> <span class="token string">"5m"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔒-安全配置" tabindex="-1"><a class="header-anchor" href="#🔒-安全配置">#</a> 🔒 安全配置</h2>
<h3 id="密钥管理" tabindex="-1"><a class="header-anchor" href="#密钥管理">#</a> 密钥管理</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">security</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 主密钥（用于加密访问密钥）</span></span>
<span class="line">  <span class="token key atrule">master_key</span><span class="token punctuation">:</span> <span class="token string">"your-32-character-master-key-here"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># JWT密钥</span></span>
<span class="line">  <span class="token key atrule">jwt_secret</span><span class="token punctuation">:</span> <span class="token string">"your-jwt-secret-key-here"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 访问密钥轮换间隔</span></span>
<span class="line">  <span class="token key atrule">access_key_rotation_interval</span><span class="token punctuation">:</span> <span class="token string">"24h"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 密码哈希成本（bcrypt）</span></span>
<span class="line">  <span class="token key atrule">password_hash_cost</span><span class="token punctuation">:</span> <span class="token number">12</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># JWT过期时间</span></span>
<span class="line">  <span class="token key atrule">jwt_expiration</span><span class="token punctuation">:</span> <span class="token string">"24h"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 刷新令牌过期时间</span></span>
<span class="line">  <span class="token key atrule">refresh_token_expiration</span><span class="token punctuation">:</span> <span class="token string">"168h"</span>  <span class="token comment"># 7天</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="tls配置" tabindex="-1"><a class="header-anchor" href="#tls配置">#</a> TLS配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">tls</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 启用TLS</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 证书文件路径</span></span>
<span class="line">  <span class="token key atrule">cert_file</span><span class="token punctuation">:</span> <span class="token string">"/path/to/cert.pem"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 私钥文件路径</span></span>
<span class="line">  <span class="token key atrule">key_file</span><span class="token punctuation">:</span> <span class="token string">"/path/to/key.pem"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># CA证书文件路径</span></span>
<span class="line">  <span class="token key atrule">ca_file</span><span class="token punctuation">:</span> <span class="token string">"/path/to/ca.pem"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 客户端认证模式</span></span>
<span class="line">  <span class="token key atrule">client_auth</span><span class="token punctuation">:</span> <span class="token string">"require_and_verify"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="速率限制" tabindex="-1"><a class="header-anchor" href="#速率限制">#</a> 速率限制</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">rate_limit</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 启用速率限制</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 每秒请求数限制</span></span>
<span class="line">  <span class="token key atrule">requests_per_second</span><span class="token punctuation">:</span> <span class="token number">100</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 突发请求数</span></span>
<span class="line">  <span class="token key atrule">burst</span><span class="token punctuation">:</span> <span class="token number">200</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 限制窗口大小</span></span>
<span class="line">  <span class="token key atrule">window</span><span class="token punctuation">:</span> <span class="token string">"1m"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-日志配置" tabindex="-1"><a class="header-anchor" href="#📊-日志配置">#</a> 📊 日志配置</h2>
<h3 id="基本日志设置" tabindex="-1"><a class="header-anchor" href="#基本日志设置">#</a> 基本日志设置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">log</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 日志级别：debug, info, warn, error</span></span>
<span class="line">  <span class="token key atrule">level</span><span class="token punctuation">:</span> <span class="token string">"info"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 日志格式：json, text</span></span>
<span class="line">  <span class="token key atrule">format</span><span class="token punctuation">:</span> <span class="token string">"json"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 输出目标：stdout, stderr, file</span></span>
<span class="line">  <span class="token key atrule">output</span><span class="token punctuation">:</span> <span class="token string">"stdout"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 日志文件路径（当output为file时）</span></span>
<span class="line">  <span class="token key atrule">file_path</span><span class="token punctuation">:</span> <span class="token string">"./logs/iam.log"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 日志文件最大大小（MB）</span></span>
<span class="line">  <span class="token key atrule">max_size</span><span class="token punctuation">:</span> <span class="token number">100</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 保留的日志文件数量</span></span>
<span class="line">  <span class="token key atrule">max_backups</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 日志文件保留天数</span></span>
<span class="line">  <span class="token key atrule">max_age</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 是否压缩旧日志文件</span></span>
<span class="line">  <span class="token key atrule">compress</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="结构化日志字段" tabindex="-1"><a class="header-anchor" href="#结构化日志字段">#</a> 结构化日志字段</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">log</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 自定义字段</span></span>
<span class="line">  <span class="token key atrule">fields</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">service</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line">    <span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">"1.2.0"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">"production"</span></span>
<span class="line">    </span>
<span class="line">  <span class="token comment"># 敏感字段过滤</span></span>
<span class="line">  <span class="token key atrule">sensitive_fields</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"password"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"secret"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"token"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"key"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-监控配置" tabindex="-1"><a class="header-anchor" href="#📈-监控配置">#</a> 📈 监控配置</h2>
<h3 id="prometheus指标" tabindex="-1"><a class="header-anchor" href="#prometheus指标">#</a> Prometheus指标</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">metrics</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 启用指标收集</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 指标服务端口</span></span>
<span class="line">  <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token string">"9090"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 指标路径</span></span>
<span class="line">  <span class="token key atrule">path</span><span class="token punctuation">:</span> <span class="token string">"/metrics"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 指标收集间隔</span></span>
<span class="line">  <span class="token key atrule">interval</span><span class="token punctuation">:</span> <span class="token string">"15s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 自定义标签</span></span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">service</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line">    <span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">"1.2.0"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="健康检查" tabindex="-1"><a class="header-anchor" href="#健康检查">#</a> 健康检查</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">health</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 健康检查端点</span></span>
<span class="line">  <span class="token key atrule">endpoint</span><span class="token punctuation">:</span> <span class="token string">"/health"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 检查间隔</span></span>
<span class="line">  <span class="token key atrule">interval</span><span class="token punctuation">:</span> <span class="token string">"30s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 超时时间</span></span>
<span class="line">  <span class="token key atrule">timeout</span><span class="token punctuation">:</span> <span class="token string">"5s"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 检查项目</span></span>
<span class="line">  <span class="token key atrule">checks</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"database"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"redis"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"external_api"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-链路追踪配置" tabindex="-1"><a class="header-anchor" href="#🔍-链路追踪配置">#</a> 🔍 链路追踪配置</h2>
<h3 id="jaeger配置" tabindex="-1"><a class="header-anchor" href="#jaeger配置">#</a> Jaeger配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">tracing</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># 启用链路追踪</span></span>
<span class="line">  <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># Jaeger端点</span></span>
<span class="line">  <span class="token key atrule">jaeger_endpoint</span><span class="token punctuation">:</span> <span class="token string">"http://localhost:14268/api/traces"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 服务名称</span></span>
<span class="line">  <span class="token key atrule">service_name</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 采样率（0.0-1.0）</span></span>
<span class="line">  <span class="token key atrule">sampling_rate</span><span class="token punctuation">:</span> <span class="token number">0.1</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 标签</span></span>
<span class="line">  <span class="token key atrule">tags</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">"1.2.0"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">"production"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-错误监控配置" tabindex="-1"><a class="header-anchor" href="#🚨-错误监控配置">#</a> 🚨 错误监控配置</h2>
<h3 id="sentry配置" tabindex="-1"><a class="header-anchor" href="#sentry配置">#</a> Sentry配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">sentry</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># Sentry DSN</span></span>
<span class="line">  <span class="token key atrule">dsn</span><span class="token punctuation">:</span> <span class="token string">"https://your-sentry-dsn@sentry.io/project-id"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 环境标识</span></span>
<span class="line">  <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">"production"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 调试模式</span></span>
<span class="line">  <span class="token key atrule">debug</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 采样率</span></span>
<span class="line">  <span class="token key atrule">sample_rate</span><span class="token punctuation">:</span> <span class="token number">1.0</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 发布版本</span></span>
<span class="line">  <span class="token key atrule">release</span><span class="token punctuation">:</span> <span class="token string">"vgo-iam@1.2.0"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token comment"># 忽略的错误</span></span>
<span class="line">  <span class="token key atrule">ignore_errors</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"context canceled"</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token string">"connection reset by peer"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🌍-环境变量" tabindex="-1"><a class="header-anchor" href="#🌍-环境变量">#</a> 🌍 环境变量</h2>
<p>您可以使用环境变量覆盖配置文件中的设置：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 数据库配置</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_DATABASE_DSN</span><span class="token operator">=</span><span class="token string">"postgres://user:pass@localhost/db"</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_DATABASE_MAX_OPEN_CONNS</span><span class="token operator">=</span><span class="token number">50</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 服务配置</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_SERVER_GRPC_PORT</span><span class="token operator">=</span><span class="token number">50051</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_SERVER_HTTP_PORT</span><span class="token operator">=</span><span class="token number">8080</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_SERVER_DEBUG_MODE</span><span class="token operator">=</span>true</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安全配置</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_SECURITY_MASTER_KEY</span><span class="token operator">=</span><span class="token string">"your-master-key"</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_SECURITY_JWT_SECRET</span><span class="token operator">=</span><span class="token string">"your-jwt-secret"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># Redis配置</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_REDIS_ADDR</span><span class="token operator">=</span><span class="token string">"localhost:6379"</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_REDIS_PASSWORD</span><span class="token operator">=</span><span class="token string">"redis-password"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 日志配置</span></span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_LOG_LEVEL</span><span class="token operator">=</span>debug</span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable">VGO_LOG_FORMAT</span><span class="token operator">=</span>json</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📋-配置验证" tabindex="-1"><a class="header-anchor" href="#📋-配置验证">#</a> 📋 配置验证</h2>
<h3 id="验证配置文件" tabindex="-1"><a class="header-anchor" href="#验证配置文件">#</a> 验证配置文件</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 验证配置文件语法</span></span>
<span class="line">iam-service config validate <span class="token parameter variable">--config</span> config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 显示当前配置</span></span>
<span class="line">iam-service config show <span class="token parameter variable">--config</span> config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试数据库连接</span></span>
<span class="line">iam-service config test-db <span class="token parameter variable">--config</span> config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试Redis连接</span></span>
<span class="line">iam-service config test-redis <span class="token parameter variable">--config</span> config/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="配置模板" tabindex="-1"><a class="header-anchor" href="#配置模板">#</a> 配置模板</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 生成配置模板</span></span>
<span class="line">iam-service config template <span class="token operator">></span> config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成开发环境配置</span></span>
<span class="line">iam-service config template <span class="token parameter variable">--env</span> dev <span class="token operator">></span> config/config-dev.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成生产环境配置</span></span>
<span class="line">iam-service config template <span class="token parameter variable">--env</span> prod <span class="token operator">></span> config/config-prod.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-最佳实践" tabindex="-1"><a class="header-anchor" href="#🔧-最佳实践">#</a> 🔧 最佳实践</h2>
<h3 id="_1-安全配置" tabindex="-1"><a class="header-anchor" href="#_1-安全配置">#</a> 1. 安全配置</h3>
<ul>
<li>使用强密码和随机密钥</li>
<li>定期轮换密钥</li>
<li>启用TLS加密</li>
<li>配置适当的速率限制</li>
</ul>
<h3 id="_2-性能优化" tabindex="-1"><a class="header-anchor" href="#_2-性能优化">#</a> 2. 性能优化</h3>
<ul>
<li>根据负载调整连接池大小</li>
<li>合理设置缓存TTL</li>
<li>启用gRPC连接复用</li>
<li>优化数据库查询</li>
</ul>
<h3 id="_3-监控配置" tabindex="-1"><a class="header-anchor" href="#_3-监控配置">#</a> 3. 监控配置</h3>
<ul>
<li>启用所有监控组件</li>
<li>设置合适的采样率</li>
<li>配置告警规则</li>
<li>定期检查日志</li>
</ul>
<h3 id="_4-环境隔离" tabindex="-1"><a class="header-anchor" href="#_4-环境隔离">#</a> 4. 环境隔离</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 开发环境</span></span>
<span class="line"><span class="token function">cp</span> config/config-dev.yaml config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试环境</span></span>
<span class="line"><span class="token function">cp</span> config/config-test.yaml config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生产环境</span></span>
<span class="line"><span class="token function">cp</span> config/config-prod.yaml config/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/guide/installation.html">安装指南</RouteLink></li>
<li><RouteLink to="/guide/basic-usage.html">基本使用</RouteLink></li>
<li><a href="/api/" target="_blank" rel="noopener noreferrer">API文档</a></li>
<li><a href="/deployment/" target="_blank" rel="noopener noreferrer">部署指南</a></li>
</ul>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>配置文件支持热重载，修改配置后发送SIGHUP信号即可重新加载配置。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>在生产环境中，请确保配置文件的权限设置正确，避免敏感信息泄露。</p>
</div>
</div></template>


