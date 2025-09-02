<template><div><h1 id="监控配置" tabindex="-1"><a class="header-anchor" href="#监控配置">#</a> 监控配置</h1>
<p>VGO微服务提供了完整的监控解决方案，包括指标收集、日志聚合、链路追踪和告警通知。本指南将详细介绍如何配置和使用这些监控组件。</p>
<h2 id="📊-监控架构" tabindex="-1"><a class="header-anchor" href="#📊-监控架构">#</a> 📊 监控架构</h2>
<h3 id="监控组件图" tabindex="-1"><a class="header-anchor" href="#监控组件图">#</a> 监控组件图</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"应用层"</span></span>
<span class="line">        A<span class="token text string">[IAM Service]</span></span>
<span class="line">        B<span class="token text string">[Web UI]</span></span>
<span class="line">        C<span class="token text string">[gRPC Client]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"指标收集"</span></span>
<span class="line">        D<span class="token text string">[Prometheus]</span></span>
<span class="line">        E<span class="token text string">[Node Exporter]</span></span>
<span class="line">        F<span class="token text string">[Postgres Exporter]</span></span>
<span class="line">        G<span class="token text string">[Redis Exporter]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"日志收集"</span></span>
<span class="line">        H<span class="token text string">[Fluent Bit]</span></span>
<span class="line">        I<span class="token text string">[Elasticsearch]</span></span>
<span class="line">        J<span class="token text string">[Kibana]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"链路追踪"</span></span>
<span class="line">        K<span class="token text string">[Jaeger]</span></span>
<span class="line">        L<span class="token text string">[Jaeger Collector]</span></span>
<span class="line">        M<span class="token text string">[Jaeger Query]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"告警通知"</span></span>
<span class="line">        N<span class="token text string">[AlertManager]</span></span>
<span class="line">        O<span class="token text string">[Webhook]</span></span>
<span class="line">        P<span class="token text string">[Email/Slack]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"可视化"</span></span>
<span class="line">        Q<span class="token text string">[Grafana]</span></span>
<span class="line">        R<span class="token text string">[Dashboard]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> D</span>
<span class="line">    A <span class="token arrow operator">--></span> H</span>
<span class="line">    A <span class="token arrow operator">--></span> K</span>
<span class="line">    </span>
<span class="line">    D <span class="token arrow operator">--></span> N</span>
<span class="line">    D <span class="token arrow operator">--></span> Q</span>
<span class="line">    </span>
<span class="line">    H <span class="token arrow operator">--></span> I</span>
<span class="line">    I <span class="token arrow operator">--></span> J</span>
<span class="line">    </span>
<span class="line">    K <span class="token arrow operator">--></span> L</span>
<span class="line">    L <span class="token arrow operator">--></span> M</span>
<span class="line">    </span>
<span class="line">    N <span class="token arrow operator">--></span> O</span>
<span class="line">    O <span class="token arrow operator">--></span> P</span>
<span class="line">    </span>
<span class="line">    Q <span class="token arrow operator">--></span> R</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="监控指标分类" tabindex="-1"><a class="header-anchor" href="#监控指标分类">#</a> 监控指标分类</h3>
<table>
<thead>
<tr>
<th>类别</th>
<th>指标类型</th>
<th>示例指标</th>
<th>用途</th>
</tr>
</thead>
<tbody>
<tr>
<td>应用指标</td>
<td>Counter, Histogram</td>
<td>grpc_requests_total, http_request_duration</td>
<td>业务监控</td>
</tr>
<tr>
<td>系统指标</td>
<td>Gauge, Counter</td>
<td>cpu_usage, memory_usage, disk_io</td>
<td>资源监控</td>
</tr>
<tr>
<td>数据库指标</td>
<td>Gauge, Counter</td>
<td>pg_connections, pg_query_duration</td>
<td>数据库监控</td>
</tr>
<tr>
<td>缓存指标</td>
<td>Gauge, Counter</td>
<td>redis_connected_clients, redis_memory_usage</td>
<td>缓存监控</td>
</tr>
<tr>
<td>网络指标</td>
<td>Counter, Histogram</td>
<td>network_bytes_sent, network_latency</td>
<td>网络监控</td>
</tr>
</tbody>
</table>
<h2 id="🔧-prometheus配置" tabindex="-1"><a class="header-anchor" href="#🔧-prometheus配置">#</a> 🔧 Prometheus配置</h2>
<h3 id="_1-prometheus部署" tabindex="-1"><a class="header-anchor" href="#_1-prometheus部署">#</a> 1. Prometheus部署</h3>
<h4 id="docker-compose配置" tabindex="-1"><a class="header-anchor" href="#docker-compose配置">#</a> Docker Compose配置</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.monitoring.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">prometheus</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prom/prometheus<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>prometheus</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9090:9090"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/prometheus<span class="token punctuation">:</span>/etc/prometheus</span>
<span class="line">      <span class="token punctuation">-</span> prometheus_data<span class="token punctuation">:</span>/prometheus</span>
<span class="line">    <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--config.file=/etc/prometheus/prometheus.yml'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.path=/prometheus'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.console.libraries=/etc/prometheus/console_libraries'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.console.templates=/etc/prometheus/consoles'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.retention.time=200h'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.enable-lifecycle'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.enable-admin-api'</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.enable=true"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.routers.prometheus.rule=Host(`prometheus.vgo.local`)"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.services.prometheus.loadbalancer.server.port=9090"</span></span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">node-exporter</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prom/node<span class="token punctuation">-</span>exporter<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>node<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9100:9100"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> /proc<span class="token punctuation">:</span>/host/proc<span class="token punctuation">:</span>ro</span>
<span class="line">      <span class="token punctuation">-</span> /sys<span class="token punctuation">:</span>/host/sys<span class="token punctuation">:</span>ro</span>
<span class="line">      <span class="token punctuation">-</span> /<span class="token punctuation">:</span>/rootfs<span class="token punctuation">:</span>ro</span>
<span class="line">    <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--path.procfs=/host/proc'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--path.rootfs=/rootfs'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--path.sysfs=/host/sys'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">postgres-exporter</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prometheuscommunity/postgres<span class="token punctuation">-</span>exporter<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9187:9187"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">DATA_SOURCE_NAME</span><span class="token punctuation">:</span> <span class="token string">"postgresql://vgo_user:your_password@postgres:5432/vgo_db?sslmode=disable"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> postgres</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">redis-exporter</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> oliver006/redis_exporter<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9121:9121"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">REDIS_ADDR</span><span class="token punctuation">:</span> <span class="token string">"redis://redis:6379"</span></span>
<span class="line">      <span class="token key atrule">REDIS_PASSWORD</span><span class="token punctuation">:</span> <span class="token string">"your_redis_password"</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> redis</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">prometheus_data</span><span class="token punctuation">:</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-network</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">external</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="prometheus配置文件" tabindex="-1"><a class="header-anchor" href="#prometheus配置文件">#</a> Prometheus配置文件</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/prometheus/prometheus.yml</span></span>
<span class="line"><span class="token key atrule">global</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">  <span class="token key atrule">evaluation_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">  <span class="token key atrule">external_labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">cluster</span><span class="token punctuation">:</span> <span class="token string">'vgo-cluster'</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span> <span class="token string">'production'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">rule_files</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token string">"rules/*.yml"</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">alerting</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">alertmanagers</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> alertmanager<span class="token punctuation">:</span><span class="token number">9093</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">scrape_configs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token comment"># Prometheus自身</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'prometheus'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'localhost:9090'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 5s</span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># VGO IAM服务</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'vgo-iam'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'iam:8082'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line">    <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> instance</span>
<span class="line">        <span class="token key atrule">replacement</span><span class="token punctuation">:</span> <span class="token string">'vgo-iam'</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># 系统指标</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'node-exporter'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'node-exporter:9100'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> instance</span>
<span class="line">        <span class="token key atrule">replacement</span><span class="token punctuation">:</span> <span class="token string">'vgo-host'</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># PostgreSQL指标</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'postgres-exporter'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'postgres-exporter:9187'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> instance</span>
<span class="line">        <span class="token key atrule">replacement</span><span class="token punctuation">:</span> <span class="token string">'vgo-postgres'</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Redis指标</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'redis-exporter'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'redis-exporter:9121'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> instance</span>
<span class="line">        <span class="token key atrule">replacement</span><span class="token punctuation">:</span> <span class="token string">'vgo-redis'</span></span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Docker容器指标</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'cadvisor'</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'cadvisor:8080'</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">scrape_interval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line"></span>
<span class="line">  <span class="token comment"># Blackbox探测</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'blackbox'</span></span>
<span class="line">    <span class="token key atrule">metrics_path</span><span class="token punctuation">:</span> /probe</span>
<span class="line">    <span class="token key atrule">params</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">module</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>http_2xx<span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">static_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">targets</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> http<span class="token punctuation">:</span>//iam<span class="token punctuation">:</span>8080/health</span>
<span class="line">        <span class="token punctuation">-</span> http<span class="token punctuation">:</span>//iam<span class="token punctuation">:</span>8081/ready</span>
<span class="line">    <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __param_target</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__param_target<span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">target_label</span><span class="token punctuation">:</span> instance</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __address__</span>
<span class="line">        <span class="token key atrule">replacement</span><span class="token punctuation">:</span> blackbox<span class="token punctuation">-</span>exporter<span class="token punctuation">:</span><span class="token number">9115</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-告警规则配置" tabindex="-1"><a class="header-anchor" href="#_2-告警规则配置">#</a> 2. 告警规则配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/prometheus/rules/vgo-alerts.yml</span></span>
<span class="line"><span class="token key atrule">groups</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>alerts</span>
<span class="line">    <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># 服务可用性告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> VGOServiceDown</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> up<span class="token punctuation">{</span>job="vgo<span class="token punctuation">-</span>iam"<span class="token punctuation">}</span> == 0</span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 1m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务不可用"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务已经停止响应超过1分钟"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 高错误率告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> VGOHighErrorRate</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            rate(grpc_server_handled_total{grpc_code!="OK",job="vgo-iam"}[5m])</span>
<span class="line">            /</span>
<span class="line">            rate(grpc_server_handled_total{job="vgo-iam"}[5m])</span>
<span class="line">          ) > 0.05</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务错误率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务5分钟内错误率超过5%，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 高延迟告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> VGOHighLatency</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          histogram_quantile(0.95,</span>
<span class="line">            rate(grpc_server_handling_seconds_bucket{job="vgo-iam"}[5m])</span>
<span class="line">          ) > 1</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务延迟过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务95%分位延迟超过1秒，当前值：{{ $value }}s"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 内存使用率告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> VGOHighMemoryUsage</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            process_resident_memory_bytes{job="vgo-iam"}</span>
<span class="line">            /</span>
<span class="line">            (1024*1024*1024)</span>
<span class="line">          ) > 1</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 10m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务内存使用率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务内存使用超过1GB，当前值：{{ $value | humanize }}B"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># CPU使用率告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> VGOHighCPUUsage</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          rate(process_cpu_seconds_total{job="vgo-iam"}[5m]) * 100 > 80</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 10m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务CPU使用率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO IAM服务CPU使用率超过80%，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>alerts</span>
<span class="line">    <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># 数据库连接数告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> PostgreSQLHighConnections</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          pg_stat_database_numbackends{datname="vgo_db"} > 80</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> postgresql</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL连接数过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL数据库连接数超过80，当前值：{{ $value }}"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 数据库查询时间告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> PostgreSQLSlowQueries</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          pg_stat_activity_max_tx_duration{datname="vgo_db"} > 300</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 2m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> postgresql</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL存在慢查询"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL存在执行时间超过5分钟的查询，当前最长：{{ $value }}秒"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 数据库磁盘空间告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> PostgreSQLDiskSpaceLow</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            pg_database_size_bytes{datname="vgo_db"}</span>
<span class="line">            /</span>
<span class="line">            (1024*1024*1024)</span>
<span class="line">          ) > 50</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> postgresql</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL磁盘空间不足"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"PostgreSQL数据库大小超过50GB，当前值：{{ $value | humanize }}B"</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>alerts</span>
<span class="line">    <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># Redis内存使用告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> RedisHighMemoryUsage</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            redis_memory_used_bytes</span>
<span class="line">            /</span>
<span class="line">            redis_memory_max_bytes</span>
<span class="line">          ) > 0.8</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> redis</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Redis内存使用率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Redis内存使用率超过80%，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># Redis连接数告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> RedisHighConnections</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> redis_connected_clients <span class="token punctuation">></span> 100</span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> redis</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Redis连接数过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Redis连接数超过100，当前值：{{ $value }}"</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system<span class="token punctuation">-</span>alerts</span>
<span class="line">    <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># 系统CPU使用率告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> SystemHighCPUUsage</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)</span>
<span class="line">          ) > 80</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 10m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> system</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"系统CPU使用率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"系统CPU使用率超过80%，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 系统内存使用率告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> SystemHighMemoryUsage</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)</span>
<span class="line">            /</span>
<span class="line">            node_memory_MemTotal_bytes</span>
<span class="line">          ) > 0.8</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 10m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> system</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"系统内存使用率过高"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"系统内存使用率超过80%，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span>
<span class="line">      <span class="token comment"># 系统磁盘空间告警</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> SystemDiskSpaceLow</span>
<span class="line">        <span class="token key atrule">expr</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          (</span>
<span class="line">            (node_filesystem_size_bytes{fstype!="tmpfs"} - node_filesystem_free_bytes{fstype!="tmpfs"})</span>
<span class="line">            /</span>
<span class="line">            node_filesystem_size_bytes{fstype!="tmpfs"}</span>
<span class="line">          ) > 0.8</span></span>
<span class="line">        <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">        <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span> system</span>
<span class="line">        <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"系统磁盘空间不足"</span></span>
<span class="line">          <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"系统磁盘使用率超过80%，挂载点：{{ $labels.mountpoint }}，当前值：{{ $value | humanizePercentage }}"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-grafana配置" tabindex="-1"><a class="header-anchor" href="#📈-grafana配置">#</a> 📈 Grafana配置</h2>
<h3 id="_1-grafana部署" tabindex="-1"><a class="header-anchor" href="#_1-grafana部署">#</a> 1. Grafana部署</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.grafana.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">grafana</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> grafana/grafana<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>grafana</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"3000:3000"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> GF_SECURITY_ADMIN_PASSWORD=admin123</span>
<span class="line">      <span class="token punctuation">-</span> GF_USERS_ALLOW_SIGN_UP=false</span>
<span class="line">      <span class="token punctuation">-</span> GF_INSTALL_PLUGINS=grafana<span class="token punctuation">-</span>piechart<span class="token punctuation">-</span>panel<span class="token punctuation">,</span>grafana<span class="token punctuation">-</span>worldmap<span class="token punctuation">-</span>panel</span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> grafana_data<span class="token punctuation">:</span>/var/lib/grafana</span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/grafana/provisioning<span class="token punctuation">:</span>/etc/grafana/provisioning</span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/grafana/dashboards<span class="token punctuation">:</span>/var/lib/grafana/dashboards</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.enable=true"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.routers.grafana.rule=Host(`grafana.vgo.local`)"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.services.grafana.loadbalancer.server.port=3000"</span></span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> prometheus</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">grafana_data</span><span class="token punctuation">:</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-network</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">external</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-数据源配置" tabindex="-1"><a class="header-anchor" href="#_2-数据源配置">#</a> 2. 数据源配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/grafana/provisioning/datasources/prometheus.yml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">datasources</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Prometheus</span>
<span class="line">    <span class="token key atrule">type</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">    <span class="token key atrule">access</span><span class="token punctuation">:</span> proxy</span>
<span class="line">    <span class="token key atrule">url</span><span class="token punctuation">:</span> http<span class="token punctuation">:</span>//prometheus<span class="token punctuation">:</span><span class="token number">9090</span></span>
<span class="line">    <span class="token key atrule">isDefault</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">editable</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">jsonData</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">timeInterval</span><span class="token punctuation">:</span> 15s</span>
<span class="line">      <span class="token key atrule">queryTimeout</span><span class="token punctuation">:</span> 60s</span>
<span class="line">      <span class="token key atrule">httpMethod</span><span class="token punctuation">:</span> POST</span>
<span class="line">    <span class="token key atrule">secureJsonData</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Jaeger</span>
<span class="line">    <span class="token key atrule">type</span><span class="token punctuation">:</span> jaeger</span>
<span class="line">    <span class="token key atrule">access</span><span class="token punctuation">:</span> proxy</span>
<span class="line">    <span class="token key atrule">url</span><span class="token punctuation">:</span> http<span class="token punctuation">:</span>//jaeger<span class="token punctuation">-</span>query<span class="token punctuation">:</span><span class="token number">16686</span></span>
<span class="line">    <span class="token key atrule">editable</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">jsonData</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">tracesToLogs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">datasourceUid</span><span class="token punctuation">:</span> <span class="token string">'loki'</span></span>
<span class="line">        <span class="token key atrule">tags</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'job'</span><span class="token punctuation">,</span> <span class="token string">'instance'</span><span class="token punctuation">,</span> <span class="token string">'pod'</span><span class="token punctuation">,</span> <span class="token string">'namespace'</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">mappedTags</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">{</span> <span class="token key atrule">key</span><span class="token punctuation">:</span> <span class="token string">'service.name'</span><span class="token punctuation">,</span> <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token string">'service'</span> <span class="token punctuation">}</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token key atrule">mapTagNamesEnabled</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">        <span class="token key atrule">spanStartTimeShift</span><span class="token punctuation">:</span> <span class="token string">'1h'</span></span>
<span class="line">        <span class="token key atrule">spanEndTimeShift</span><span class="token punctuation">:</span> <span class="token string">'1h'</span></span>
<span class="line">        <span class="token key atrule">filterByTraceID</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">        <span class="token key atrule">filterBySpanID</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Loki</span>
<span class="line">    <span class="token key atrule">type</span><span class="token punctuation">:</span> loki</span>
<span class="line">    <span class="token key atrule">access</span><span class="token punctuation">:</span> proxy</span>
<span class="line">    <span class="token key atrule">url</span><span class="token punctuation">:</span> http<span class="token punctuation">:</span>//loki<span class="token punctuation">:</span><span class="token number">3100</span></span>
<span class="line">    <span class="token key atrule">editable</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">jsonData</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">maxLines</span><span class="token punctuation">:</span> <span class="token number">1000</span></span>
<span class="line">      <span class="token key atrule">derivedFields</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">datasourceUid</span><span class="token punctuation">:</span> <span class="token string">'jaeger'</span></span>
<span class="line">          <span class="token key atrule">matcherRegex</span><span class="token punctuation">:</span> <span class="token string">'trace_id=(\w+)'</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'TraceID'</span></span>
<span class="line">          <span class="token key atrule">url</span><span class="token punctuation">:</span> <span class="token string">'$${__value.raw}'</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-仪表板配置" tabindex="-1"><a class="header-anchor" href="#_3-仪表板配置">#</a> 3. 仪表板配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/grafana/provisioning/dashboards/dashboards.yml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">providers</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'VGO Dashboards'</span></span>
<span class="line">    <span class="token key atrule">orgId</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">    <span class="token key atrule">folder</span><span class="token punctuation">:</span> <span class="token string">'VGO'</span></span>
<span class="line">    <span class="token key atrule">type</span><span class="token punctuation">:</span> file</span>
<span class="line">    <span class="token key atrule">disableDeletion</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">    <span class="token key atrule">updateIntervalSeconds</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">    <span class="token key atrule">allowUiUpdates</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">options</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">path</span><span class="token punctuation">:</span> /var/lib/grafana/dashboards</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-vgo服务仪表板" tabindex="-1"><a class="header-anchor" href="#_4-vgo服务仪表板">#</a> 4. VGO服务仪表板</h3>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token punctuation">{</span></span>
<span class="line">  <span class="token property">"dashboard"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"id"</span><span class="token operator">:</span> <span class="token null keyword">null</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"VGO IAM Service"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"tags"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token string">"vgo"</span><span class="token punctuation">,</span> <span class="token string">"iam"</span><span class="token punctuation">,</span> <span class="token string">"microservice"</span><span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"timezone"</span><span class="token operator">:</span> <span class="token string">"browser"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"panels"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"请求速率"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"stat"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"RPS"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"reqps"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"color"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"thresholds"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"thresholds"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"steps"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"green"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token null keyword">null</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"yellow"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">100</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"red"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">500</span><span class="token punctuation">}</span></span>
<span class="line">              <span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">2</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"错误率"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"stat"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"rate(grpc_server_handled_total{job=\"vgo-iam\",grpc_code!=\"OK\"}[5m]) / rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"Error Rate"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"percentunit"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"color"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"thresholds"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"thresholds"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"steps"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"green"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token null keyword">null</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"yellow"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">0.01</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"red"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">0.05</span><span class="token punctuation">}</span></span>
<span class="line">              <span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">3</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"响应时间"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"stat"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"histogram_quantile(0.95, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"P95 Latency"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"s"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"color"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"thresholds"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"thresholds"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"steps"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"green"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token null keyword">null</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"yellow"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">0.5</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"red"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">}</span></span>
<span class="line">              <span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">12</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">4</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"活跃连接数"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"stat"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"grpc_server_started_total{job=\"vgo-iam\"} - grpc_server_handled_total{job=\"vgo-iam\"}"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"Active Connections"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"short"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"color"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"thresholds"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"thresholds"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"steps"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"green"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token null keyword">null</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"yellow"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">100</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">{</span><span class="token property">"color"</span><span class="token operator">:</span> <span class="token string">"red"</span><span class="token punctuation">,</span> <span class="token property">"value"</span><span class="token operator">:</span> <span class="token number">500</span><span class="token punctuation">}</span></span>
<span class="line">              <span class="token punctuation">]</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">18</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">5</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"请求速率趋势"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"timeseries"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"rate(grpc_server_handled_total{job=\"vgo-iam\"}[5m])"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"{{grpc_method}}"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"reqps"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"custom"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"drawStyle"</span><span class="token operator">:</span> <span class="token string">"line"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"lineInterpolation"</span><span class="token operator">:</span> <span class="token string">"linear"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"lineWidth"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"fillOpacity"</span><span class="token operator">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"gradientMode"</span><span class="token operator">:</span> <span class="token string">"none"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"spanNulls"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"pointSize"</span><span class="token operator">:</span> <span class="token number">5</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"stacking"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"none"</span><span class="token punctuation">,</span> <span class="token property">"group"</span><span class="token operator">:</span> <span class="token string">"A"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"axisPlacement"</span><span class="token operator">:</span> <span class="token string">"auto"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"axisLabel"</span><span class="token operator">:</span> <span class="token string">""</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"scaleDistribution"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"linear"</span><span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">12</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"id"</span><span class="token operator">:</span> <span class="token number">6</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"title"</span><span class="token operator">:</span> <span class="token string">"响应时间分布"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"timeseries"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"targets"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"histogram_quantile(0.50, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"P50"</span></span>
<span class="line">          <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"histogram_quantile(0.95, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"P95"</span></span>
<span class="line">          <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">          <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"expr"</span><span class="token operator">:</span> <span class="token string">"histogram_quantile(0.99, rate(grpc_server_handling_seconds_bucket{job=\"vgo-iam\"}[5m]))"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"legendFormat"</span><span class="token operator">:</span> <span class="token string">"P99"</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"fieldConfig"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">          <span class="token property">"defaults"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"unit"</span><span class="token operator">:</span> <span class="token string">"s"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"custom"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">              <span class="token property">"drawStyle"</span><span class="token operator">:</span> <span class="token string">"line"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"lineInterpolation"</span><span class="token operator">:</span> <span class="token string">"linear"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"lineWidth"</span><span class="token operator">:</span> <span class="token number">1</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"fillOpacity"</span><span class="token operator">:</span> <span class="token number">10</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"gradientMode"</span><span class="token operator">:</span> <span class="token string">"none"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"spanNulls"</span><span class="token operator">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"pointSize"</span><span class="token operator">:</span> <span class="token number">5</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"stacking"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"none"</span><span class="token punctuation">,</span> <span class="token property">"group"</span><span class="token operator">:</span> <span class="token string">"A"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"axisPlacement"</span><span class="token operator">:</span> <span class="token string">"auto"</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"axisLabel"</span><span class="token operator">:</span> <span class="token string">""</span><span class="token punctuation">,</span></span>
<span class="line">              <span class="token property">"scaleDistribution"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"linear"</span><span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token property">"gridPos"</span><span class="token operator">:</span> <span class="token punctuation">{</span><span class="token property">"h"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">,</span> <span class="token property">"w"</span><span class="token operator">:</span> <span class="token number">12</span><span class="token punctuation">,</span> <span class="token property">"x"</span><span class="token operator">:</span> <span class="token number">12</span><span class="token punctuation">,</span> <span class="token property">"y"</span><span class="token operator">:</span> <span class="token number">8</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"time"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">      <span class="token property">"from"</span><span class="token operator">:</span> <span class="token string">"now-1h"</span><span class="token punctuation">,</span></span>
<span class="line">      <span class="token property">"to"</span><span class="token operator">:</span> <span class="token string">"now"</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"refresh"</span><span class="token operator">:</span> <span class="token string">"5s"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"schemaVersion"</span><span class="token operator">:</span> <span class="token number">27</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"version"</span><span class="token operator">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-链路追踪配置" tabindex="-1"><a class="header-anchor" href="#🔍-链路追踪配置">#</a> 🔍 链路追踪配置</h2>
<h3 id="_1-jaeger部署" tabindex="-1"><a class="header-anchor" href="#_1-jaeger部署">#</a> 1. Jaeger部署</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.jaeger.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">jaeger-collector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> jaegertracing/jaeger<span class="token punctuation">-</span>collector<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>jaeger<span class="token punctuation">-</span>collector</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"14268:14268"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"14250:14250"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> SPAN_STORAGE_TYPE=elasticsearch</span>
<span class="line">      <span class="token punctuation">-</span> ES_SERVER_URLS=http<span class="token punctuation">:</span>//elasticsearch<span class="token punctuation">:</span><span class="token number">9200</span></span>
<span class="line">      <span class="token punctuation">-</span> ES_USERNAME=elastic</span>
<span class="line">      <span class="token punctuation">-</span> ES_PASSWORD=changeme</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> elasticsearch</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">jaeger-query</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> jaegertracing/jaeger<span class="token punctuation">-</span>query<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>jaeger<span class="token punctuation">-</span>query</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"16686:16686"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> SPAN_STORAGE_TYPE=elasticsearch</span>
<span class="line">      <span class="token punctuation">-</span> ES_SERVER_URLS=http<span class="token punctuation">:</span>//elasticsearch<span class="token punctuation">:</span><span class="token number">9200</span></span>
<span class="line">      <span class="token punctuation">-</span> ES_USERNAME=elastic</span>
<span class="line">      <span class="token punctuation">-</span> ES_PASSWORD=changeme</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.enable=true"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.routers.jaeger.rule=Host(`jaeger.vgo.local`)"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.services.jaeger.loadbalancer.server.port=16686"</span></span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> elasticsearch</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">jaeger-agent</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> jaegertracing/jaeger<span class="token punctuation">-</span>agent<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>jaeger<span class="token punctuation">-</span>agent</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"6831:6831/udp"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"6832:6832/udp"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"5778:5778"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> REPORTER_GRPC_HOST_PORT=jaeger<span class="token punctuation">-</span>collector<span class="token punctuation">:</span><span class="token number">14250</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> jaeger<span class="token punctuation">-</span>collector</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-network</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">external</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-应用链路追踪配置" tabindex="-1"><a class="header-anchor" href="#_2-应用链路追踪配置">#</a> 2. 应用链路追踪配置</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/tracing/jaeger.go</span></span>
<span class="line"><span class="token keyword">package</span> tracing</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">	<span class="token string">"context"</span></span>
<span class="line">	<span class="token string">"io"</span></span>
<span class="line">	<span class="token string">"time"</span></span>
<span class="line"></span>
<span class="line">	<span class="token string">"github.com/opentracing/opentracing-go"</span></span>
<span class="line">	<span class="token string">"github.com/uber/jaeger-client-go"</span></span>
<span class="line">	<span class="token string">"github.com/uber/jaeger-client-go/config"</span></span>
<span class="line">	<span class="token string">"github.com/uber/jaeger-client-go/log"</span></span>
<span class="line">	<span class="token string">"github.com/uber/jaeger-client-go/metrics"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// TracingConfig 链路追踪配置</span></span>
<span class="line"><span class="token keyword">type</span> TracingConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">	ServiceName     <span class="token builtin">string</span>  <span class="token string">`yaml:"service_name"`</span></span>
<span class="line">	JaegerEndpoint  <span class="token builtin">string</span>  <span class="token string">`yaml:"jaeger_endpoint"`</span></span>
<span class="line">	SampleRate      <span class="token builtin">float64</span> <span class="token string">`yaml:"sample_rate"`</span></span>
<span class="line">	Enabled         <span class="token builtin">bool</span>    <span class="token string">`yaml:"enabled"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// InitJaeger 初始化Jaeger追踪</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">InitJaeger</span><span class="token punctuation">(</span>cfg TracingConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span>opentracing<span class="token punctuation">.</span>Tracer<span class="token punctuation">,</span> io<span class="token punctuation">.</span>Closer<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> <span class="token operator">!</span>cfg<span class="token punctuation">.</span>Enabled <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> opentracing<span class="token punctuation">.</span>NoopTracer<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token operator">&amp;</span>noopCloser<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// Jaeger配置</span></span>
<span class="line">	jcfg <span class="token operator">:=</span> config<span class="token punctuation">.</span>Configuration<span class="token punctuation">{</span></span>
<span class="line">		ServiceName<span class="token punctuation">:</span> cfg<span class="token punctuation">.</span>ServiceName<span class="token punctuation">,</span></span>
<span class="line">		Sampler<span class="token punctuation">:</span> <span class="token operator">&amp;</span>config<span class="token punctuation">.</span>SamplerConfig<span class="token punctuation">{</span></span>
<span class="line">			Type<span class="token punctuation">:</span>  jaeger<span class="token punctuation">.</span>SamplerTypeConst<span class="token punctuation">,</span></span>
<span class="line">			Param<span class="token punctuation">:</span> cfg<span class="token punctuation">.</span>SampleRate<span class="token punctuation">,</span></span>
<span class="line">		<span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">		Reporter<span class="token punctuation">:</span> <span class="token operator">&amp;</span>config<span class="token punctuation">.</span>ReporterConfig<span class="token punctuation">{</span></span>
<span class="line">			LogSpans<span class="token punctuation">:</span>            <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">			BufferFlushInterval<span class="token punctuation">:</span> <span class="token number">1</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">			CollectorEndpoint<span class="token punctuation">:</span>   cfg<span class="token punctuation">.</span>JaegerEndpoint<span class="token punctuation">,</span></span>
<span class="line">		<span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 创建追踪器</span></span>
<span class="line">	tracer<span class="token punctuation">,</span> closer<span class="token punctuation">,</span> err <span class="token operator">:=</span> jcfg<span class="token punctuation">.</span><span class="token function">NewTracer</span><span class="token punctuation">(</span></span>
<span class="line">		config<span class="token punctuation">.</span><span class="token function">Logger</span><span class="token punctuation">(</span>log<span class="token punctuation">.</span>StdLogger<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">		config<span class="token punctuation">.</span><span class="token function">Metrics</span><span class="token punctuation">(</span>metrics<span class="token punctuation">.</span>NullFactory<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">	<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		<span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line">	<span class="token comment">// 设置全局追踪器</span></span>
<span class="line">	opentracing<span class="token punctuation">.</span><span class="token function">SetGlobalTracer</span><span class="token punctuation">(</span>tracer<span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line">	<span class="token keyword">return</span> tracer<span class="token punctuation">,</span> closer<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// StartSpan 开始一个新的span</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">StartSpan</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> operationName <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span>opentracing<span class="token punctuation">.</span>Span<span class="token punctuation">,</span> context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	span<span class="token punctuation">,</span> ctx <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">StartSpanFromContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> operationName<span class="token punctuation">)</span></span>
<span class="line">	<span class="token keyword">return</span> span<span class="token punctuation">,</span> ctx</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// FinishSpan 结束span</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">FinishSpan</span><span class="token punctuation">(</span>span opentracing<span class="token punctuation">.</span>Span<span class="token punctuation">,</span> err <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">		span<span class="token punctuation">.</span><span class="token function">SetTag</span><span class="token punctuation">(</span><span class="token string">"error"</span><span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span></span>
<span class="line">		span<span class="token punctuation">.</span><span class="token function">LogKV</span><span class="token punctuation">(</span><span class="token string">"error"</span><span class="token punctuation">,</span> err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">	<span class="token punctuation">}</span></span>
<span class="line">	span<span class="token punctuation">.</span><span class="token function">Finish</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> noopCloser <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>n <span class="token operator">*</span>noopCloser<span class="token punctuation">)</span> <span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">	<span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📋-日志聚合配置" tabindex="-1"><a class="header-anchor" href="#📋-日志聚合配置">#</a> 📋 日志聚合配置</h2>
<h3 id="_1-elk-stack部署" tabindex="-1"><a class="header-anchor" href="#_1-elk-stack部署">#</a> 1. ELK Stack部署</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.elk.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">elasticsearch</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> docker.elastic.co/elasticsearch/elasticsearch<span class="token punctuation">:</span>8.8.0</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>elasticsearch</span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> discovery.type=single<span class="token punctuation">-</span>node</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"ES_JAVA_OPTS=-Xms512m -Xmx512m"</span></span>
<span class="line">      <span class="token punctuation">-</span> xpack.security.enabled=false</span>
<span class="line">      <span class="token punctuation">-</span> xpack.security.enrollment.enabled=false</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9200:9200"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9300:9300"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> elasticsearch_data<span class="token punctuation">:</span>/usr/share/elasticsearch/data</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">kibana</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> docker.elastic.co/kibana/kibana<span class="token punctuation">:</span>8.8.0</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>kibana</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"5601:5601"</span></span>
<span class="line">    <span class="token key atrule">environment</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ELASTICSEARCH_HOSTS=http<span class="token punctuation">:</span>//elasticsearch<span class="token punctuation">:</span><span class="token number">9200</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.enable=true"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.routers.kibana.rule=Host(`kibana.vgo.local`)"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.services.kibana.loadbalancer.server.port=5601"</span></span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> elasticsearch</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">fluent-bit</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> fluent/fluent<span class="token punctuation">-</span>bit<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>fluent<span class="token punctuation">-</span>bit</span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/fluent<span class="token punctuation">-</span>bit/fluent<span class="token punctuation">-</span>bit.conf<span class="token punctuation">:</span>/fluent<span class="token punctuation">-</span>bit/etc/fluent<span class="token punctuation">-</span>bit.conf</span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/fluent<span class="token punctuation">-</span>bit/parsers.conf<span class="token punctuation">:</span>/fluent<span class="token punctuation">-</span>bit/etc/parsers.conf</span>
<span class="line">      <span class="token punctuation">-</span> /var/lib/docker/containers<span class="token punctuation">:</span>/var/lib/docker/containers<span class="token punctuation">:</span>ro</span>
<span class="line">      <span class="token punctuation">-</span> /var/log<span class="token punctuation">:</span>/var/log<span class="token punctuation">:</span>ro</span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">depends_on</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> elasticsearch</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">elasticsearch_data</span><span class="token punctuation">:</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-network</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">external</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-fluent-bit配置" tabindex="-1"><a class="header-anchor" href="#_2-fluent-bit配置">#</a> 2. Fluent Bit配置</h3>
<div class="language-ini line-numbers-mode" data-highlighter="prismjs" data-ext="ini"><pre v-pre><code class="language-ini"><span class="line"><span class="token comment"># monitoring/fluent-bit/fluent-bit.conf</span></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">SERVICE</span><span class="token punctuation">]</span></span></span>
<span class="line">    Flush         1</span>
<span class="line">    Log_Level     info</span>
<span class="line">    Daemon        off</span>
<span class="line">    Parsers_File  parsers.conf</span>
<span class="line">    HTTP_Server   On</span>
<span class="line">    HTTP_Listen   0.0.0.0</span>
<span class="line">    HTTP_Port     2020</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">INPUT</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name              tail</span>
<span class="line">    Path              /var/lib/docker/containers/*/*.log</span>
<span class="line">    Parser            docker</span>
<span class="line">    Tag               docker.*</span>
<span class="line">    Refresh_Interval  5</span>
<span class="line">    Mem_Buf_Limit     50MB</span>
<span class="line">    Skip_Long_Lines   On</span>
<span class="line">    Skip_Empty_Lines  On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">INPUT</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name              systemd</span>
<span class="line">    Tag               systemd.*</span>
<span class="line">    <span class="token key attr-name">Systemd_Filter    _SYSTEMD_UNIT</span><span class="token punctuation">=</span><span class="token value attr-value">docker.service</span></span>
<span class="line">    Read_From_Tail    On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">FILTER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name                kubernetes</span>
<span class="line">    Match               docker.*</span>
<span class="line">    Kube_URL            https://kubernetes.default.svc:443</span>
<span class="line">    Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt</span>
<span class="line">    Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token</span>
<span class="line">    Kube_Tag_Prefix     docker.var.lib.docker.containers.</span>
<span class="line">    Merge_Log           On</span>
<span class="line">    Merge_Log_Key       log_processed</span>
<span class="line">    K8S-Logging.Parser  On</span>
<span class="line">    K8S-Logging.Exclude Off</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">FILTER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name                parser</span>
<span class="line">    Match               docker.*vgo*</span>
<span class="line">    Key_Name            log</span>
<span class="line">    Parser              vgo_json</span>
<span class="line">    Reserve_Data        On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">FILTER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name                nest</span>
<span class="line">    Match               docker.*vgo*</span>
<span class="line">    Operation           lift</span>
<span class="line">    Nested_under        kubernetes</span>
<span class="line">    Add_prefix          k8s_</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">FILTER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name                modify</span>
<span class="line">    Match               docker.*vgo*</span>
<span class="line">    Add                 service vgo-iam</span>
<span class="line">    Add                 environment production</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">OUTPUT</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name            es</span>
<span class="line">    Match           docker.*vgo*</span>
<span class="line">    Host            elasticsearch</span>
<span class="line">    Port            9200</span>
<span class="line">    Index           vgo-logs</span>
<span class="line">    Type            _doc</span>
<span class="line">    Logstash_Format On</span>
<span class="line">    Logstash_Prefix vgo</span>
<span class="line">    Logstash_DateFormat %Y.%m.%d</span>
<span class="line">    Include_Tag_Key On</span>
<span class="line">    Tag_Key         @tag</span>
<span class="line">    Retry_Limit     5</span>
<span class="line">    Suppress_Type_Name On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">OUTPUT</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name            es</span>
<span class="line">    Match           systemd.*</span>
<span class="line">    Host            elasticsearch</span>
<span class="line">    Port            9200</span>
<span class="line">    Index           system-logs</span>
<span class="line">    Type            _doc</span>
<span class="line">    Logstash_Format On</span>
<span class="line">    Logstash_Prefix system</span>
<span class="line">    Logstash_DateFormat %Y.%m.%d</span>
<span class="line">    Include_Tag_Key On</span>
<span class="line">    Tag_Key         @tag</span>
<span class="line">    Retry_Limit     5</span>
<span class="line">    Suppress_Type_Name On</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-ini line-numbers-mode" data-highlighter="prismjs" data-ext="ini"><pre v-pre><code class="language-ini"><span class="line"><span class="token comment"># monitoring/fluent-bit/parsers.conf</span></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">PARSER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name        docker</span>
<span class="line">    Format      json</span>
<span class="line">    Time_Key    time</span>
<span class="line">    Time_Format %Y-%m-%dT%H:%M:%S.%L</span>
<span class="line">    Time_Keep   On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">PARSER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name        vgo_json</span>
<span class="line">    Format      json</span>
<span class="line">    Time_Key    timestamp</span>
<span class="line">    Time_Format %Y-%m-%dT%H:%M:%S.%L%z</span>
<span class="line">    Time_Keep   On</span>
<span class="line"></span>
<span class="line"><span class="token section"><span class="token punctuation">[</span><span class="token section-name selector">PARSER</span><span class="token punctuation">]</span></span></span>
<span class="line">    Name        nginx</span>
<span class="line">    Format      regex</span>
<span class="line">    Regex       ^(?&lt;remote>[^ ]*) (?&lt;host>[^ ]*) (?&lt;user>[^ ]*) \[(?&lt;time>[^\]]*)\] "(?&lt;method>\S+)(?: +(?&lt;path>[^\"]*?)(?: +\S*)?)?" (?&lt;code>[^ ]*) (?&lt;size>[^ ]*)(?: "(?&lt;referer>[^\"]*)" "(?&lt;agent>[^\"]*)")</span>
<span class="line">    Time_Key    time</span>
<span class="line">    Time_Format %d/%b/%Y:%H:%M:%S %z</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-alertmanager配置" tabindex="-1"><a class="header-anchor" href="#🚨-alertmanager配置">#</a> 🚨 AlertManager配置</h2>
<h3 id="_1-alertmanager部署" tabindex="-1"><a class="header-anchor" href="#_1-alertmanager部署">#</a> 1. AlertManager部署</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># docker-compose.alertmanager.yml</span></span>
<span class="line"><span class="token key atrule">version</span><span class="token punctuation">:</span> <span class="token string">'3.8'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">alertmanager</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">image</span><span class="token punctuation">:</span> prom/alertmanager<span class="token punctuation">:</span>latest</span>
<span class="line">    <span class="token key atrule">container_name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>alertmanager</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"9093:9093"</span></span>
<span class="line">    <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> ./monitoring/alertmanager<span class="token punctuation">:</span>/etc/alertmanager</span>
<span class="line">      <span class="token punctuation">-</span> alertmanager_data<span class="token punctuation">:</span>/alertmanager</span>
<span class="line">    <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--config.file=/etc/alertmanager/alertmanager.yml'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--storage.path=/alertmanager'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--web.external-url=http://localhost:9093'</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">'--cluster.listen-address=0.0.0.0:9094'</span></span>
<span class="line">    <span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>network</span>
<span class="line">    <span class="token key atrule">restart</span><span class="token punctuation">:</span> unless<span class="token punctuation">-</span>stopped</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.enable=true"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.routers.alertmanager.rule=Host(`alertmanager.vgo.local`)"</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"traefik.http.services.alertmanager.loadbalancer.server.port=9093"</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">alertmanager_data</span><span class="token punctuation">:</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">networks</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-network</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">external</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-alertmanager配置文件" tabindex="-1"><a class="header-anchor" href="#_2-alertmanager配置文件">#</a> 2. AlertManager配置文件</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/alertmanager/alertmanager.yml</span></span>
<span class="line"><span class="token key atrule">global</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">smtp_smarthost</span><span class="token punctuation">:</span> <span class="token string">'smtp.gmail.com:587'</span></span>
<span class="line">  <span class="token key atrule">smtp_from</span><span class="token punctuation">:</span> <span class="token string">'alerts@vgo.example.com'</span></span>
<span class="line">  <span class="token key atrule">smtp_auth_username</span><span class="token punctuation">:</span> <span class="token string">'alerts@vgo.example.com'</span></span>
<span class="line">  <span class="token key atrule">smtp_auth_password</span><span class="token punctuation">:</span> <span class="token string">'your_app_password'</span></span>
<span class="line">  <span class="token key atrule">slack_api_url</span><span class="token punctuation">:</span> <span class="token string">'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">route</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">group_by</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'alertname'</span><span class="token punctuation">,</span> <span class="token string">'cluster'</span><span class="token punctuation">,</span> <span class="token string">'service'</span><span class="token punctuation">]</span></span>
<span class="line">  <span class="token key atrule">group_wait</span><span class="token punctuation">:</span> 10s</span>
<span class="line">  <span class="token key atrule">group_interval</span><span class="token punctuation">:</span> 10s</span>
<span class="line">  <span class="token key atrule">repeat_interval</span><span class="token punctuation">:</span> 1h</span>
<span class="line">  <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'web.hook'</span></span>
<span class="line">  <span class="token key atrule">routes</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">match</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">      <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'critical-alerts'</span></span>
<span class="line">      <span class="token key atrule">group_wait</span><span class="token punctuation">:</span> 5s</span>
<span class="line">      <span class="token key atrule">repeat_interval</span><span class="token punctuation">:</span> 30m</span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">match</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">      <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'warning-alerts'</span></span>
<span class="line">      <span class="token key atrule">group_wait</span><span class="token punctuation">:</span> 30s</span>
<span class="line">      <span class="token key atrule">repeat_interval</span><span class="token punctuation">:</span> 2h</span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">match</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">service</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">      <span class="token key atrule">receiver</span><span class="token punctuation">:</span> <span class="token string">'vgo-team'</span></span>
<span class="line">      <span class="token key atrule">group_wait</span><span class="token punctuation">:</span> 10s</span>
<span class="line">      <span class="token key atrule">repeat_interval</span><span class="token punctuation">:</span> 1h</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">receivers</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'web.hook'</span></span>
<span class="line">    <span class="token key atrule">webhook_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">url</span><span class="token punctuation">:</span> <span class="token string">'http://webhook-service:8080/alerts'</span></span>
<span class="line">        <span class="token key atrule">send_resolved</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">        <span class="token key atrule">http_config</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">basic_auth</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">username</span><span class="token punctuation">:</span> <span class="token string">'webhook_user'</span></span>
<span class="line">            <span class="token key atrule">password</span><span class="token punctuation">:</span> <span class="token string">'webhook_password'</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'critical-alerts'</span></span>
<span class="line">    <span class="token key atrule">email_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token string">'oncall@vgo.example.com'</span></span>
<span class="line">        <span class="token key atrule">subject</span><span class="token punctuation">:</span> <span class="token string">'🚨 [CRITICAL] VGO Alert: {{ .GroupLabels.alertname }}'</span></span>
<span class="line">        <span class="token key atrule">body</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          {{ range .Alerts }}</span>
<span class="line">          Alert: {{ .Annotations.summary }}</span>
<span class="line">          Description: {{ .Annotations.description }}</span>
<span class="line">          Service: {{ .Labels.service }}</span>
<span class="line">          Severity: {{ .Labels.severity }}</span>
<span class="line">          Time: {{ .StartsAt.Format "2006-01-02 15:04:05" }}</span>
<span class="line">          {{ end }}</span></span>
<span class="line">    <span class="token key atrule">slack_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">channel</span><span class="token punctuation">:</span> <span class="token string">'#critical-alerts'</span></span>
<span class="line">        <span class="token key atrule">title</span><span class="token punctuation">:</span> <span class="token string">'🚨 Critical Alert'</span></span>
<span class="line">        <span class="token key atrule">text</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          {{ range .Alerts }}</span>
<span class="line">          *Alert:* {{ .Annotations.summary }}</span>
<span class="line">          *Description:* {{ .Annotations.description }}</span>
<span class="line">          *Service:* {{ .Labels.service }}</span>
<span class="line">          *Severity:* {{ .Labels.severity }}</span>
<span class="line">          {{ end }}</span></span>
<span class="line">        <span class="token key atrule">send_resolved</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'warning-alerts'</span></span>
<span class="line">    <span class="token key atrule">email_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token string">'team@vgo.example.com'</span></span>
<span class="line">        <span class="token key atrule">subject</span><span class="token punctuation">:</span> <span class="token string">'⚠️ [WARNING] VGO Alert: {{ .GroupLabels.alertname }}'</span></span>
<span class="line">        <span class="token key atrule">body</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          {{ range .Alerts }}</span>
<span class="line">          Alert: {{ .Annotations.summary }}</span>
<span class="line">          Description: {{ .Annotations.description }}</span>
<span class="line">          Service: {{ .Labels.service }}</span>
<span class="line">          Severity: {{ .Labels.severity }}</span>
<span class="line">          Time: {{ .StartsAt.Format "2006-01-02 15:04:05" }}</span>
<span class="line">          {{ end }}</span></span>
<span class="line">    <span class="token key atrule">slack_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">channel</span><span class="token punctuation">:</span> <span class="token string">'#alerts'</span></span>
<span class="line">        <span class="token key atrule">title</span><span class="token punctuation">:</span> <span class="token string">'⚠️ Warning Alert'</span></span>
<span class="line">        <span class="token key atrule">text</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          {{ range .Alerts }}</span>
<span class="line">          *Alert:* {{ .Annotations.summary }}</span>
<span class="line">          *Description:* {{ .Annotations.description }}</span>
<span class="line">          *Service:* {{ .Labels.service }}</span>
<span class="line">          *Severity:* {{ .Labels.severity }}</span>
<span class="line">          {{ end }}</span></span>
<span class="line">        <span class="token key atrule">send_resolved</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> <span class="token string">'vgo-team'</span></span>
<span class="line">    <span class="token key atrule">email_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token string">'vgo-team@vgo.example.com'</span></span>
<span class="line">        <span class="token key atrule">subject</span><span class="token punctuation">:</span> <span class="token string">'[VGO] Service Alert: {{ .GroupLabels.alertname }}'</span></span>
<span class="line">        <span class="token key atrule">body</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          VGO服务告警通知：</span></span>
<span class="line">          </span>
<span class="line">          <span class="token punctuation">{</span><span class="token punctuation">{</span> range .Alerts <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token key atrule">告警名称</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .Annotations.summary <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token key atrule">详细描述</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .Annotations.description <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token key atrule">服务名称</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .Labels.service <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token key atrule">告警级别</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .Labels.severity <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token key atrule">开始时间</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .StartsAt.Format "2006<span class="token punctuation">-</span>01<span class="token punctuation">-</span>02 15<span class="token punctuation">:</span>04<span class="token punctuation">:</span>05" <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">{</span><span class="token punctuation">{</span> if .EndsAt <span class="token punctuation">}</span><span class="token punctuation">}</span>结束时间<span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">{</span> .EndsAt.Format "2006<span class="token punctuation">-</span>01<span class="token punctuation">-</span>02 15<span class="token punctuation">:</span>04<span class="token punctuation">:</span>05" <span class="token punctuation">}</span><span class="token punctuation">}</span><span class="token punctuation">{</span><span class="token punctuation">{</span> end <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">          <span class="token punctuation">{</span><span class="token punctuation">{</span> end <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token key atrule">slack_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">channel</span><span class="token punctuation">:</span> <span class="token string">'#vgo-alerts'</span></span>
<span class="line">        <span class="token key atrule">title</span><span class="token punctuation">:</span> <span class="token string">'VGO Service Alert'</span></span>
<span class="line">        <span class="token key atrule">text</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          {{ range .Alerts }}</span>
<span class="line">          *服务:* {{ .Labels.service }}</span>
<span class="line">          *告警:* {{ .Annotations.summary }}</span>
<span class="line">          *描述:* {{ .Annotations.description }}</span>
<span class="line">          *级别:* {{ .Labels.severity }}</span>
<span class="line">          {{ end }}</span></span>
<span class="line">        <span class="token key atrule">send_resolved</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">inhibit_rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">source_match</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> <span class="token string">'critical'</span></span>
<span class="line">    <span class="token key atrule">target_match</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> <span class="token string">'warning'</span></span>
<span class="line">    <span class="token key atrule">equal</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">'alertname'</span><span class="token punctuation">,</span> <span class="token string">'cluster'</span><span class="token punctuation">,</span> <span class="token string">'service'</span><span class="token punctuation">]</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-监控部署脚本" tabindex="-1"><a class="header-anchor" href="#🔧-监控部署脚本">#</a> 🔧 监控部署脚本</h2>
<h3 id="完整部署脚本" tabindex="-1"><a class="header-anchor" href="#完整部署脚本">#</a> 完整部署脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/deploy-monitoring.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🚀 开始部署VGO监控系统..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建监控目录</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> monitoring/<span class="token punctuation">{</span>prometheus,grafana,alertmanager,fluent-bit,jaeger<span class="token punctuation">}</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> monitoring/grafana/<span class="token punctuation">{</span>provisioning/<span class="token punctuation">{</span>datasources,dashboards<span class="token punctuation">}</span>,dashboards<span class="token punctuation">}</span></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> monitoring/prometheus/rules</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Docker和Docker Compose</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token operator">!</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> <span class="token function">docker</span> <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Docker未安装，请先安装Docker"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token operator">!</span> <span class="token builtin class-name">command</span> <span class="token parameter variable">-v</span> <span class="token function">docker-compose</span> <span class="token operator">&amp;></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Docker Compose未安装，请先安装Docker Compose"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建网络</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📡 创建Docker网络..."</span></span>
<span class="line"><span class="token function">docker</span> network create vgo-network <span class="token operator"><span class="token file-descriptor important">2</span>></span>/dev/null <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"网络已存在"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署Elasticsearch和Kibana</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📊 部署ELK Stack..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token parameter variable">-f</span> docker-compose.elk.yml up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待Elasticsearch启动</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"⏳ 等待Elasticsearch启动..."</span></span>
<span class="line"><span class="token keyword">until</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:9200/_cluster/health <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'"status":"green"\|"status":"yellow"'</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"等待Elasticsearch..."</span></span>
<span class="line">    <span class="token function">sleep</span> <span class="token number">5</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"✅ Elasticsearch已启动"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署Jaeger</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 部署Jaeger..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token parameter variable">-f</span> docker-compose.jaeger.yml up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署Prometheus和相关组件</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📈 部署Prometheus..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token parameter variable">-f</span> docker-compose.monitoring.yml up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署Grafana</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📊 部署Grafana..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token parameter variable">-f</span> docker-compose.grafana.yml up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署AlertManager</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🚨 部署AlertManager..."</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token parameter variable">-f</span> docker-compose.alertmanager.yml up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待所有服务启动</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"⏳ 等待所有服务启动..."</span></span>
<span class="line"><span class="token function">sleep</span> <span class="token number">30</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务状态</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 检查服务状态..."</span></span>
<span class="line"><span class="token assign-left variable">services</span><span class="token operator">=</span><span class="token punctuation">(</span><span class="token string">"prometheus:9090"</span> <span class="token string">"grafana:3000"</span> <span class="token string">"alertmanager:9093"</span> <span class="token string">"kibana:5601"</span> <span class="token string">"jaeger-query:16686"</span><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">for</span> <span class="token for-or-select variable">service</span> <span class="token keyword">in</span> <span class="token string">"<span class="token variable">${services<span class="token punctuation">[</span>@<span class="token punctuation">]</span>}</span>"</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">    <span class="token assign-left variable">name</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> $service <span class="token operator">|</span> <span class="token function">cut</span> -d: <span class="token parameter variable">-f1</span><span class="token variable">)</span></span></span>
<span class="line">    <span class="token assign-left variable">port</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> $service <span class="token operator">|</span> <span class="token function">cut</span> -d: <span class="token parameter variable">-f2</span><span class="token variable">)</span></span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token parameter variable">-f</span> http://localhost:<span class="token variable">$port</span> <span class="token operator">></span> /dev/null<span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"✅ <span class="token variable">$name</span> 运行正常 (端口 <span class="token variable">$port</span>)"</span></span>
<span class="line">    <span class="token keyword">else</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"❌ <span class="token variable">$name</span> 启动失败 (端口 <span class="token variable">$port</span>)"</span></span>
<span class="line">    <span class="token keyword">fi</span></span>
<span class="line"><span class="token keyword">done</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 导入Grafana仪表板</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📊 导入Grafana仪表板..."</span></span>
<span class="line"><span class="token function">sleep</span> <span class="token number">10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建数据源</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-X</span> POST <span class="token punctuation">\</span></span>
<span class="line">  http://admin:admin123@localhost:3000/api/datasources <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-H</span> <span class="token string">'Content-Type: application/json'</span> <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">    "name": "Prometheus",</span>
<span class="line">    "type": "prometheus",</span>
<span class="line">    "url": "http://prometheus:9090",</span>
<span class="line">    "access": "proxy",</span>
<span class="line">    "isDefault": true</span>
<span class="line">  }'</span> <span class="token operator"><span class="token file-descriptor important">2</span>></span>/dev/null <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"数据源可能已存在"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">""</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🎉 监控系统部署完成！"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">""</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📊 访问地址："</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  - Grafana:      http://localhost:3000 (admin/admin123)"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  - Prometheus:   http://localhost:9090"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  - AlertManager: http://localhost:9093"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  - Kibana:       http://localhost:5601"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  - Jaeger:       http://localhost:16686"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">""</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📝 下一步："</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  1. 配置Grafana仪表板"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  2. 设置告警通知"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  3. 配置日志索引模式"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"  4. 验证链路追踪"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">""</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="监控验证脚本" tabindex="-1"><a class="header-anchor" href="#监控验证脚本">#</a> 监控验证脚本</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/verify-monitoring.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 验证VGO监控系统..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Prometheus指标</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📈 检查Prometheus指标..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:9090/api/v1/query?query<span class="token operator">=</span>up <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'"status":"success"'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ Prometheus API正常"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Prometheus API异常"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查VGO服务指标</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🎯 检查VGO服务指标..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:9090/api/v1/query?query<span class="token operator">=</span>grpc_server_handled_total <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'grpc_server_handled_total'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ VGO服务指标正常"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"⚠️ VGO服务指标未找到，请确保服务正在运行"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查告警规则</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🚨 检查告警规则..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:9090/api/v1/rules <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'VGOServiceDown'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ 告警规则已加载"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ 告警规则未加载"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Grafana</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"📊 检查Grafana..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token parameter variable">-u</span> admin:admin123 http://localhost:3000/api/health <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'"database":"ok"'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ Grafana正常"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Grafana异常"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Elasticsearch</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔍 检查Elasticsearch..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:9200/_cluster/health <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'"status":"green"\|"status":"yellow"'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ Elasticsearch正常"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Elasticsearch异常"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Jaeger</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"🔗 检查Jaeger..."</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:16686/api/services <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-q</span> <span class="token string">'"data"'</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ Jaeger正常"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Jaeger异常"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">""</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"✅ 监控系统验证完成！"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/deployment/docker-compose.html">Docker Compose部署</RouteLink> - 基础部署方案</li>
<li><RouteLink to="/deployment/kubernetes.html">Kubernetes部署</RouteLink> - 生产环境部署</li>
<li><RouteLink to="/deployment/troubleshooting.html">故障排除</RouteLink> - 问题诊断指南</li>
<li><RouteLink to="/deployment/performance.html">性能调优</RouteLink> - 性能优化建议</li>
<li><RouteLink to="/deployment/security.html">安全配置</RouteLink> - 安全最佳实践</li>
</ul>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>监控系统需要一定的资源，建议在生产环境中为监控组件分配足够的CPU和内存。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>请根据实际环境调整告警阈值和通知配置，避免告警风暴。</p>
</div>
</div></template>


