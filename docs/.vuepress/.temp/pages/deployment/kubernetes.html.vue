<template><div><h1 id="kubernetes-部署" tabindex="-1"><a class="header-anchor" href="#kubernetes-部署">#</a> Kubernetes 部署</h1>
<p>Kubernetes是VGO微服务在生产环境的推荐部署方式，提供了高可用、自动扩缩容、服务发现、负载均衡等企业级特性。本指南将详细介绍如何在Kubernetes集群中部署VGO微服务。</p>
<h2 id="📋-部署架构" tabindex="-1"><a class="header-anchor" href="#📋-部署架构">#</a> 📋 部署架构</h2>
<h3 id="集群架构图" tabindex="-1"><a class="header-anchor" href="#集群架构图">#</a> 集群架构图</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"Kubernetes Cluster"</span></span>
<span class="line">        <span class="token keyword">subgraph</span> <span class="token string">"Ingress Layer"</span></span>
<span class="line">            A<span class="token text string">[Ingress Controller]</span></span>
<span class="line">            B<span class="token text string">[Load Balancer]</span></span>
<span class="line">        <span class="token keyword">end</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">subgraph</span> <span class="token string">"Application Layer"</span></span>
<span class="line">            C<span class="token text string">[IAM Service Pod 1]</span></span>
<span class="line">            D<span class="token text string">[IAM Service Pod 2]</span></span>
<span class="line">            E<span class="token text string">[IAM Service Pod 3]</span></span>
<span class="line">        <span class="token keyword">end</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">subgraph</span> <span class="token string">"Data Layer"</span></span>
<span class="line">            F<span class="token text string">[PostgreSQL Primary]</span></span>
<span class="line">            G<span class="token text string">[PostgreSQL Replica]</span></span>
<span class="line">            H<span class="token text string">[Redis Cluster]</span></span>
<span class="line">        <span class="token keyword">end</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">subgraph</span> <span class="token string">"Monitoring Layer"</span></span>
<span class="line">            I<span class="token text string">[Prometheus]</span></span>
<span class="line">            J<span class="token text string">[Grafana]</span></span>
<span class="line">            K<span class="token text string">[Jaeger]</span></span>
<span class="line">            L<span class="token text string">[AlertManager]</span></span>
<span class="line">        <span class="token keyword">end</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">subgraph</span> <span class="token string">"Storage Layer"</span></span>
<span class="line">            M<span class="token text string">[Persistent Volumes]</span></span>
<span class="line">            N<span class="token text string">[ConfigMaps]</span></span>
<span class="line">            O<span class="token text string">[Secrets]</span></span>
<span class="line">        <span class="token keyword">end</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    P<span class="token text string">[External Users]</span> <span class="token arrow operator">--></span> B</span>
<span class="line">    B <span class="token arrow operator">--></span> A</span>
<span class="line">    A <span class="token arrow operator">--></span> C</span>
<span class="line">    A <span class="token arrow operator">--></span> D</span>
<span class="line">    A <span class="token arrow operator">--></span> E</span>
<span class="line">    C <span class="token arrow operator">--></span> F</span>
<span class="line">    D <span class="token arrow operator">--></span> F</span>
<span class="line">    E <span class="token arrow operator">--></span> F</span>
<span class="line">    F <span class="token arrow operator">--></span> G</span>
<span class="line">    C <span class="token arrow operator">--></span> H</span>
<span class="line">    D <span class="token arrow operator">--></span> H</span>
<span class="line">    E <span class="token arrow operator">--></span> H</span>
<span class="line">    </span>
<span class="line">    C <span class="token arrow operator">--></span> I</span>
<span class="line">    D <span class="token arrow operator">--></span> I</span>
<span class="line">    E <span class="token arrow operator">--></span> I</span>
<span class="line">    I <span class="token arrow operator">--></span> J</span>
<span class="line">    I <span class="token arrow operator">--></span> L</span>
<span class="line">    </span>
<span class="line">    F <span class="token arrow operator">--></span> M</span>
<span class="line">    H <span class="token arrow operator">--></span> M</span>
<span class="line">    C <span class="token arrow operator">--></span> N</span>
<span class="line">    C <span class="token arrow operator">--></span> O</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="资源分布" tabindex="-1"><a class="header-anchor" href="#资源分布">#</a> 资源分布</h3>
<table>
<thead>
<tr>
<th>组件</th>
<th>副本数</th>
<th>CPU请求</th>
<th>CPU限制</th>
<th>内存请求</th>
<th>内存限制</th>
<th>存储</th>
</tr>
</thead>
<tbody>
<tr>
<td>IAM Service</td>
<td>3</td>
<td>500m</td>
<td>1000m</td>
<td>512Mi</td>
<td>1Gi</td>
<td>-</td>
</tr>
<tr>
<td>PostgreSQL</td>
<td>1+1</td>
<td>1000m</td>
<td>2000m</td>
<td>1Gi</td>
<td>2Gi</td>
<td>100Gi</td>
</tr>
<tr>
<td>Redis</td>
<td>3</td>
<td>250m</td>
<td>500m</td>
<td>256Mi</td>
<td>512Mi</td>
<td>10Gi</td>
</tr>
<tr>
<td>Prometheus</td>
<td>1</td>
<td>500m</td>
<td>1000m</td>
<td>1Gi</td>
<td>2Gi</td>
<td>50Gi</td>
</tr>
<tr>
<td>Grafana</td>
<td>1</td>
<td>100m</td>
<td>200m</td>
<td>128Mi</td>
<td>256Mi</td>
<td>10Gi</td>
</tr>
</tbody>
</table>
<h2 id="🚀-快速开始" tabindex="-1"><a class="header-anchor" href="#🚀-快速开始">#</a> 🚀 快速开始</h2>
<h3 id="_1-环境准备" tabindex="-1"><a class="header-anchor" href="#_1-环境准备">#</a> 1. 环境准备</h3>
<h4 id="集群要求" tabindex="-1"><a class="header-anchor" href="#集群要求">#</a> 集群要求</h4>
<ul>
<li><strong>Kubernetes版本</strong>: 1.20+</li>
<li><strong>节点数量</strong>: 最少3个节点</li>
<li><strong>总CPU</strong>: 最少8核</li>
<li><strong>总内存</strong>: 最少16GB</li>
<li><strong>存储</strong>: 支持动态PV供应</li>
</ul>
<h4 id="必需组件" tabindex="-1"><a class="header-anchor" href="#必需组件">#</a> 必需组件</h4>
<ul>
<li><strong>Ingress Controller</strong>: Nginx, Traefik, 或 Istio</li>
<li><strong>存储类</strong>: 支持ReadWriteOnce和ReadWriteMany</li>
<li><strong>DNS</strong>: CoreDNS或kube-dns</li>
<li><strong>网络插件</strong>: Calico, Flannel, 或 Weave</li>
</ul>
<h4 id="工具安装" tabindex="-1"><a class="header-anchor" href="#工具安装">#</a> 工具安装</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装kubectl</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-LO</span> <span class="token string">"https://dl.k8s.io/release/<span class="token variable"><span class="token variable">$(</span><span class="token function">curl</span> <span class="token parameter variable">-L</span> <span class="token parameter variable">-s</span> https://dl.k8s.io/release/stable.txt<span class="token variable">)</span></span>/bin/linux/amd64/kubectl"</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">install</span> <span class="token parameter variable">-o</span> root <span class="token parameter variable">-g</span> root <span class="token parameter variable">-m</span> 0755 kubectl /usr/local/bin/kubectl</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装Helm</span></span>
<span class="line"><span class="token function">curl</span> https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 <span class="token operator">|</span> <span class="token function">bash</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 验证安装</span></span>
<span class="line">kubectl version <span class="token parameter variable">--client</span></span>
<span class="line">helm version</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-创建命名空间" tabindex="-1"><a class="header-anchor" href="#_2-创建命名空间">#</a> 2. 创建命名空间</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># namespace.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Namespace</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">    <span class="token key atrule">app.kubernetes.io/name</span><span class="token punctuation">:</span> vgo</span>
<span class="line">    <span class="token key atrule">app.kubernetes.io/instance</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>production</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Namespace</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">    <span class="token key atrule">app.kubernetes.io/name</span><span class="token punctuation">:</span> monitoring</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 应用命名空间</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> namespace.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-配置存储" tabindex="-1"><a class="header-anchor" href="#_3-配置存储">#</a> 3. 配置存储</h3>
<h4 id="存储类定义" tabindex="-1"><a class="header-anchor" href="#存储类定义">#</a> 存储类定义</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># storage-class.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> storage.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> StorageClass</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>ssd</span>
<span class="line">  <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">storageclass.kubernetes.io/is-default-class</span><span class="token punctuation">:</span> <span class="token string">"false"</span></span>
<span class="line"><span class="token key atrule">provisioner</span><span class="token punctuation">:</span> kubernetes.io/aws<span class="token punctuation">-</span>ebs  <span class="token comment"># 根据云提供商调整</span></span>
<span class="line"><span class="token key atrule">parameters</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> gp3</span>
<span class="line">  <span class="token key atrule">fsType</span><span class="token punctuation">:</span> ext4</span>
<span class="line">  <span class="token key atrule">encrypted</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line"><span class="token key atrule">volumeBindingMode</span><span class="token punctuation">:</span> WaitForFirstConsumer</span>
<span class="line"><span class="token key atrule">allowVolumeExpansion</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"><span class="token key atrule">reclaimPolicy</span><span class="token punctuation">:</span> Retain</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> storage.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> StorageClass</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>standard</span>
<span class="line"><span class="token key atrule">provisioner</span><span class="token punctuation">:</span> kubernetes.io/aws<span class="token punctuation">-</span>ebs</span>
<span class="line"><span class="token key atrule">parameters</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> gp2</span>
<span class="line">  <span class="token key atrule">fsType</span><span class="token punctuation">:</span> ext4</span>
<span class="line"><span class="token key atrule">volumeBindingMode</span><span class="token punctuation">:</span> WaitForFirstConsumer</span>
<span class="line"><span class="token key atrule">allowVolumeExpansion</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line"><span class="token key atrule">reclaimPolicy</span><span class="token punctuation">:</span> Delete</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-配置密钥和配置" tabindex="-1"><a class="header-anchor" href="#_4-配置密钥和配置">#</a> 4. 配置密钥和配置</h3>
<h4 id="创建密钥" tabindex="-1"><a class="header-anchor" href="#创建密钥">#</a> 创建密钥</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># secrets.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Secret</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">type</span><span class="token punctuation">:</span> Opaque</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">username</span><span class="token punctuation">:</span> dmdvX3VzZXI=  <span class="token comment"># base64编码的 "vgo_user"</span></span>
<span class="line">  <span class="token key atrule">password</span><span class="token punctuation">:</span> eW91ci1zZWN1cmUtcGFzc3dvcmQ=  <span class="token comment"># base64编码的密码</span></span>
<span class="line">  <span class="token key atrule">database</span><span class="token punctuation">:</span> dmdvX2Ri  <span class="token comment"># base64编码的 "vgo_db"</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Secret</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>secret</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">type</span><span class="token punctuation">:</span> Opaque</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">password</span><span class="token punctuation">:</span> eW91ci1yZWRpcy1wYXNzd29yZA==  <span class="token comment"># base64编码的Redis密码</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Secret</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>app<span class="token punctuation">-</span>secret</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">type</span><span class="token punctuation">:</span> Opaque</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">jwt-secret</span><span class="token punctuation">:</span> eW91ci12ZXJ5LWxvbmctand0LXNlY3JldC1rZXktYXQtbGVhc3QtMzItY2hhcmFjdGVycw==</span>
<span class="line">  <span class="token key atrule">encryption-key</span><span class="token punctuation">:</span> eW91ci0zMi1jaGFyYWN0ZXItZW5jcnlwdGlvbi1rZXk=</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="创建配置映射" tabindex="-1"><a class="header-anchor" href="#创建配置映射">#</a> 创建配置映射</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># configmap.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> ConfigMap</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>config</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">app.yaml</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">    server:</span>
<span class="line">      grpc_port: 50051</span>
<span class="line">      http_port: 8080</span>
<span class="line">      health_port: 8081</span>
<span class="line">      metrics_port: 8082</span>
<span class="line">      read_timeout: 30s</span>
<span class="line">      write_timeout: 30s</span>
<span class="line">      idle_timeout: 120s</span></span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">database</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">host</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line">      <span class="token key atrule">sslmode</span><span class="token punctuation">:</span> require</span>
<span class="line">      <span class="token key atrule">max_open_conns</span><span class="token punctuation">:</span> <span class="token number">25</span></span>
<span class="line">      <span class="token key atrule">max_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">      <span class="token key atrule">conn_max_lifetime</span><span class="token punctuation">:</span> 300s</span>
<span class="line">      <span class="token key atrule">query_timeout</span><span class="token punctuation">:</span> 30s</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">host</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">6379</span></span>
<span class="line">      <span class="token key atrule">db</span><span class="token punctuation">:</span> <span class="token number">0</span></span>
<span class="line">      <span class="token key atrule">pool_size</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">      <span class="token key atrule">min_idle_conns</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">      <span class="token key atrule">pool_timeout</span><span class="token punctuation">:</span> 5s</span>
<span class="line">      <span class="token key atrule">idle_timeout</span><span class="token punctuation">:</span> 300s</span>
<span class="line">      <span class="token key atrule">default_ttl</span><span class="token punctuation">:</span> 3600s</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">logging</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">level</span><span class="token punctuation">:</span> info</span>
<span class="line">      <span class="token key atrule">format</span><span class="token punctuation">:</span> json</span>
<span class="line">      <span class="token key atrule">output</span><span class="token punctuation">:</span> stdout</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">metrics</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">      <span class="token key atrule">path</span><span class="token punctuation">:</span> /metrics</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">tracing</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">      <span class="token key atrule">jaeger_endpoint</span><span class="token punctuation">:</span> http<span class="token punctuation">:</span>//jaeger<span class="token punctuation">-</span>collector.vgo<span class="token punctuation">-</span>monitoring<span class="token punctuation">:</span>14268/api/traces</span>
<span class="line">      <span class="token key atrule">sample_rate</span><span class="token punctuation">:</span> <span class="token number">0.1</span></span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">security</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">tls_enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">      <span class="token key atrule">cors_enabled</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">      <span class="token key atrule">cors_origins</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">"https://vgo.example.com"</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">"https://admin.vgo.example.com"</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> ConfigMap</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>config</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">postgresql.conf</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">    # 连接设置</span>
<span class="line">    listen_addresses = '*'</span>
<span class="line">    port = 5432</span>
<span class="line">    max_connections = 200</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 内存设置</span></span>
<span class="line">    shared_buffers = 256MB</span>
<span class="line">    effective_cache_size = 1GB</span>
<span class="line">    work_mem = 4MB</span>
<span class="line">    maintenance_work_mem = 64MB</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># WAL设置</span></span>
<span class="line">    wal_level = replica</span>
<span class="line">    max_wal_size = 1GB</span>
<span class="line">    min_wal_size = 80MB</span>
<span class="line">    checkpoint_completion_target = 0.9</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 复制设置</span></span>
<span class="line">    hot_standby = on</span>
<span class="line">    max_replication_slots = 10</span>
<span class="line">    max_wal_senders = 10</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 日志设置</span></span>
<span class="line">    log_destination = 'stderr'</span>
<span class="line">    logging_collector = on</span>
<span class="line">    log_directory = 'log'</span>
<span class="line">    log_filename = 'postgresql<span class="token punctuation">-</span>%Y<span class="token punctuation">-</span>%m<span class="token punctuation">-</span>%d_%H%M%S.log'</span>
<span class="line">    log_statement = 'mod'</span>
<span class="line">    log_min_duration_statement = 1000</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 性能设置</span></span>
<span class="line">    random_page_cost = 1.1</span>
<span class="line">    effective_io_concurrency = 200</span>
<span class="line">  </span>
<span class="line">  <span class="token key atrule">pg_hba.conf</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">    # TYPE  DATABASE        USER            ADDRESS                 METHOD</span>
<span class="line">    local   all             all                                     trust</span>
<span class="line">    host    all             all             127.0.0.1/32            md5</span>
<span class="line">    host    all             all             ::1/128                 md5</span>
<span class="line">    host    all             all             0.0.0.0/0               md5</span>
<span class="line">    host    replication     all             0.0.0.0/0               md5</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 应用密钥和配置</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> secrets.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> configmap.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_5-部署postgresql" tabindex="-1"><a class="header-anchor" href="#_5-部署postgresql">#</a> 5. 部署PostgreSQL</h3>
<h4 id="postgresql主库" tabindex="-1"><a class="header-anchor" href="#postgresql主库">#</a> PostgreSQL主库</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># postgres-primary.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> StatefulSet</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">    <span class="token key atrule">role</span><span class="token punctuation">:</span> primary</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">serviceName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">  <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">      <span class="token key atrule">role</span><span class="token punctuation">:</span> primary</span>
<span class="line">  <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">        <span class="token key atrule">role</span><span class="token punctuation">:</span> primary</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">securityContext</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">fsGroup</span><span class="token punctuation">:</span> <span class="token number">999</span></span>
<span class="line">      <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres</span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>15<span class="token punctuation">-</span>alpine</span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres</span>
<span class="line">        <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_DB</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> database</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_USER</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> username</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_PASSWORD</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> password</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_INITDB_ARGS</span>
<span class="line">          <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token string">"--encoding=UTF8 --locale=C"</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> PGDATA</span>
<span class="line">          <span class="token key atrule">value</span><span class="token punctuation">:</span> /var/lib/postgresql/data/pgdata</span>
<span class="line">        <span class="token key atrule">volumeMounts</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>data</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /var/lib/postgresql/data</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>config</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /etc/postgresql</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>init</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /docker<span class="token punctuation">-</span>entrypoint<span class="token punctuation">-</span>initdb.d</span>
<span class="line">        <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 1000m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1Gi</span>
<span class="line">          <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 2000m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 2Gi</span>
<span class="line">        <span class="token key atrule">livenessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">exec</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> /bin/sh</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">-</span>c</span>
<span class="line">            <span class="token punctuation">-</span> pg_isready <span class="token punctuation">-</span>U $POSTGRES_USER <span class="token punctuation">-</span>d $POSTGRES_DB</span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">        <span class="token key atrule">readinessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">exec</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> /bin/sh</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">-</span>c</span>
<span class="line">            <span class="token punctuation">-</span> pg_isready <span class="token punctuation">-</span>U $POSTGRES_USER <span class="token punctuation">-</span>d $POSTGRES_DB</span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">      <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>config</span>
<span class="line">        <span class="token key atrule">configMap</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>config</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>init</span>
<span class="line">        <span class="token key atrule">configMap</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>init<span class="token punctuation">-</span>scripts</span>
<span class="line">  <span class="token key atrule">volumeClaimTemplates</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>data</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">accessModes</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"ReadWriteOnce"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">storageClassName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>ssd</span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">storage</span><span class="token punctuation">:</span> 100Gi</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Service</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> ClusterIP</span>
<span class="line">  <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres</span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">    <span class="token key atrule">role</span><span class="token punctuation">:</span> primary</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_6-部署redis" tabindex="-1"><a class="header-anchor" href="#_6-部署redis">#</a> 6. 部署Redis</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># redis.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> StatefulSet</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">serviceName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">  <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">  <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> redis</span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span>7<span class="token punctuation">-</span>alpine</span>
<span class="line">        <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> redis<span class="token punctuation">-</span>server</span>
<span class="line">        <span class="token punctuation">-</span> /etc/redis/redis.conf</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token punctuation">-</span><span class="token punctuation">-</span>requirepass</span>
<span class="line">        <span class="token punctuation">-</span> $(REDIS_PASSWORD)</span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">6379</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> redis</span>
<span class="line">        <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> REDIS_PASSWORD</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> password</span>
<span class="line">        <span class="token key atrule">volumeMounts</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>data</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /data</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>config</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /etc/redis</span>
<span class="line">        <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 250m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 256Mi</span>
<span class="line">          <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 500m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 512Mi</span>
<span class="line">        <span class="token key atrule">livenessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">exec</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> redis<span class="token punctuation">-</span>cli</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">-</span>a</span>
<span class="line">            <span class="token punctuation">-</span> $(REDIS_PASSWORD)</span>
<span class="line">            <span class="token punctuation">-</span> ping</span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">        <span class="token key atrule">readinessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">exec</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> redis<span class="token punctuation">-</span>cli</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">-</span>a</span>
<span class="line">            <span class="token punctuation">-</span> $(REDIS_PASSWORD)</span>
<span class="line">            <span class="token punctuation">-</span> ping</span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">      <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>config</span>
<span class="line">        <span class="token key atrule">configMap</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>config</span>
<span class="line">  <span class="token key atrule">volumeClaimTemplates</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>data</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">accessModes</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"ReadWriteOnce"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">storageClassName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>ssd</span>
<span class="line">      <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">storage</span><span class="token punctuation">:</span> 10Gi</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Service</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> ClusterIP</span>
<span class="line">  <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">6379</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">6379</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> redis</span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> ConfigMap</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> redis<span class="token punctuation">-</span>config</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">redis.conf</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">    # 网络配置</span>
<span class="line">    bind 0.0.0.0</span>
<span class="line">    port 6379</span>
<span class="line">    tcp-backlog 511</span>
<span class="line">    timeout 0</span>
<span class="line">    tcp-keepalive 300</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 持久化配置</span></span>
<span class="line">    save 900 1</span>
<span class="line">    save 300 10</span>
<span class="line">    save 60 10000</span>
<span class="line">    stop<span class="token punctuation">-</span>writes<span class="token punctuation">-</span>on<span class="token punctuation">-</span>bgsave<span class="token punctuation">-</span>error yes</span>
<span class="line">    rdbcompression yes</span>
<span class="line">    rdbchecksum yes</span>
<span class="line">    dbfilename dump.rdb</span>
<span class="line">    dir /data</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># AOF配置</span></span>
<span class="line">    appendonly yes</span>
<span class="line">    appendfilename "appendonly.aof"</span>
<span class="line">    appendfsync everysec</span>
<span class="line">    no<span class="token punctuation">-</span>appendfsync<span class="token punctuation">-</span>on<span class="token punctuation">-</span>rewrite no</span>
<span class="line">    auto<span class="token punctuation">-</span>aof<span class="token punctuation">-</span>rewrite<span class="token punctuation">-</span>percentage 100</span>
<span class="line">    auto<span class="token punctuation">-</span>aof<span class="token punctuation">-</span>rewrite<span class="token punctuation">-</span>min<span class="token punctuation">-</span>size 64mb</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 内存配置</span></span>
<span class="line">    maxmemory 400mb</span>
<span class="line">    maxmemory<span class="token punctuation">-</span>policy allkeys<span class="token punctuation">-</span>lru</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 日志配置</span></span>
<span class="line">    loglevel notice</span>
<span class="line">    logfile ""</span>
<span class="line">    </span>
<span class="line">    <span class="token comment"># 客户端配置</span></span>
<span class="line">    maxclients 10000</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_7-部署iam服务" tabindex="-1"><a class="header-anchor" href="#_7-部署iam服务">#</a> 7. 部署IAM服务</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># iam-deployment.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Deployment</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">    <span class="token key atrule">version</span><span class="token punctuation">:</span> v1.0.0</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">  <span class="token key atrule">strategy</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">type</span><span class="token punctuation">:</span> RollingUpdate</span>
<span class="line">    <span class="token key atrule">rollingUpdate</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">maxSurge</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">      <span class="token key atrule">maxUnavailable</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token key atrule">version</span><span class="token punctuation">:</span> v1.0.0</span>
<span class="line">      <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">prometheus.io/scrape</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line">        <span class="token key atrule">prometheus.io/port</span><span class="token punctuation">:</span> <span class="token string">"8082"</span></span>
<span class="line">        <span class="token key atrule">prometheus.io/path</span><span class="token punctuation">:</span> <span class="token string">"/metrics"</span></span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">serviceAccountName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">      <span class="token key atrule">securityContext</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">runAsNonRoot</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">        <span class="token key atrule">runAsUser</span><span class="token punctuation">:</span> <span class="token number">1000</span></span>
<span class="line">        <span class="token key atrule">runAsGroup</span><span class="token punctuation">:</span> <span class="token number">1000</span></span>
<span class="line">        <span class="token key atrule">fsGroup</span><span class="token punctuation">:</span> <span class="token number">1000</span></span>
<span class="line">      <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> iam</span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> vgo/iam<span class="token punctuation">:</span>v1.0.0</span>
<span class="line">        <span class="token key atrule">imagePullPolicy</span><span class="token punctuation">:</span> IfNotPresent</span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">50051</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> grpc</span>
<span class="line">          <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> http</span>
<span class="line">          <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> health</span>
<span class="line">          <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">8082</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> metrics</span>
<span class="line">          <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">        <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> CONFIG_FILE</span>
<span class="line">          <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token string">"/etc/vgo/app.yaml"</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> DB_PASSWORD</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> password</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> REDIS_PASSWORD</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> password</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> JWT_SECRET</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>app<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> jwt<span class="token punctuation">-</span>secret</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> ENCRYPTION_KEY</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>app<span class="token punctuation">-</span>secret</span>
<span class="line">              <span class="token key atrule">key</span><span class="token punctuation">:</span> encryption<span class="token punctuation">-</span>key</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POD_NAME</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">fieldRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">fieldPath</span><span class="token punctuation">:</span> metadata.name</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POD_NAMESPACE</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">fieldRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">fieldPath</span><span class="token punctuation">:</span> metadata.namespace</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POD_IP</span>
<span class="line">          <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">fieldRef</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">fieldPath</span><span class="token punctuation">:</span> status.podIP</span>
<span class="line">        <span class="token key atrule">volumeMounts</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> config</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /etc/vgo</span>
<span class="line">          <span class="token key atrule">readOnly</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> tmp</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /tmp</span>
<span class="line">        <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 500m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 512Mi</span>
<span class="line">          <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 1000m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1Gi</span>
<span class="line">        <span class="token key atrule">livenessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">httpGet</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">path</span><span class="token punctuation">:</span> /health</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">        <span class="token key atrule">readinessProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">httpGet</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">path</span><span class="token punctuation">:</span> /ready</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">        <span class="token key atrule">startupProbe</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">httpGet</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">path</span><span class="token punctuation">:</span> /health</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">          <span class="token key atrule">initialDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">          <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">5</span></span>
<span class="line">          <span class="token key atrule">timeoutSeconds</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">          <span class="token key atrule">failureThreshold</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">        <span class="token key atrule">securityContext</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">allowPrivilegeEscalation</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">          <span class="token key atrule">readOnlyRootFilesystem</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">          <span class="token key atrule">capabilities</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">drop</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> ALL</span>
<span class="line">      <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> config</span>
<span class="line">        <span class="token key atrule">configMap</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>config</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> tmp</span>
<span class="line">        <span class="token key atrule">emptyDir</span><span class="token punctuation">:</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">      <span class="token key atrule">affinity</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">podAntiAffinity</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">preferredDuringSchedulingIgnoredDuringExecution</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> <span class="token key atrule">weight</span><span class="token punctuation">:</span> <span class="token number">100</span></span>
<span class="line">            <span class="token key atrule">podAffinityTerm</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">labelSelector</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token key atrule">matchExpressions</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token punctuation">-</span> <span class="token key atrule">key</span><span class="token punctuation">:</span> app</span>
<span class="line">                  <span class="token key atrule">operator</span><span class="token punctuation">:</span> In</span>
<span class="line">                  <span class="token key atrule">values</span><span class="token punctuation">:</span></span>
<span class="line">                  <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">              <span class="token key atrule">topologyKey</span><span class="token punctuation">:</span> kubernetes.io/hostname</span>
<span class="line">      <span class="token key atrule">tolerations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">key</span><span class="token punctuation">:</span> <span class="token string">"node.kubernetes.io/not-ready"</span></span>
<span class="line">        <span class="token key atrule">operator</span><span class="token punctuation">:</span> <span class="token string">"Exists"</span></span>
<span class="line">        <span class="token key atrule">effect</span><span class="token punctuation">:</span> <span class="token string">"NoExecute"</span></span>
<span class="line">        <span class="token key atrule">tolerationSeconds</span><span class="token punctuation">:</span> <span class="token number">300</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">key</span><span class="token punctuation">:</span> <span class="token string">"node.kubernetes.io/unreachable"</span></span>
<span class="line">        <span class="token key atrule">operator</span><span class="token punctuation">:</span> <span class="token string">"Exists"</span></span>
<span class="line">        <span class="token key atrule">effect</span><span class="token punctuation">:</span> <span class="token string">"NoExecute"</span></span>
<span class="line">        <span class="token key atrule">tolerationSeconds</span><span class="token punctuation">:</span> <span class="token number">300</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Service</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">service.beta.kubernetes.io/aws-load-balancer-type</span><span class="token punctuation">:</span> nlb</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> ClusterIP</span>
<span class="line">  <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">50051</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">50051</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> grpc</span>
<span class="line">    <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> http</span>
<span class="line">    <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">8081</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> health</span>
<span class="line">    <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8082</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">8082</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> metrics</span>
<span class="line">    <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> ServiceAccount</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line"><span class="token key atrule">automountServiceAccountToken</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_8-配置ingress" tabindex="-1"><a class="header-anchor" href="#_8-配置ingress">#</a> 8. 配置Ingress</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># ingress.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> networking.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Ingress</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>ingress</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo</span>
<span class="line">  <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">kubernetes.io/ingress.class</span><span class="token punctuation">:</span> nginx</span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/ssl-redirect</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/force-ssl-redirect</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/backend-protocol</span><span class="token punctuation">:</span> <span class="token string">"HTTP"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/proxy-body-size</span><span class="token punctuation">:</span> <span class="token string">"100m"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/proxy-connect-timeout</span><span class="token punctuation">:</span> <span class="token string">"5"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/proxy-send-timeout</span><span class="token punctuation">:</span> <span class="token string">"60"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/proxy-read-timeout</span><span class="token punctuation">:</span> <span class="token string">"60"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/rate-limit</span><span class="token punctuation">:</span> <span class="token string">"100"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/rate-limit-window</span><span class="token punctuation">:</span> <span class="token string">"1m"</span></span>
<span class="line">    <span class="token key atrule">cert-manager.io/cluster-issuer</span><span class="token punctuation">:</span> <span class="token string">"letsencrypt-prod"</span></span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">tls</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">hosts</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> vgo.example.com</span>
<span class="line">    <span class="token punctuation">-</span> api.vgo.example.com</span>
<span class="line">    <span class="token key atrule">secretName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>tls<span class="token punctuation">-</span>secret</span>
<span class="line">  <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">host</span><span class="token punctuation">:</span> vgo.example.com</span>
<span class="line">    <span class="token key atrule">http</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">paths</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> /</span>
<span class="line">        <span class="token key atrule">pathType</span><span class="token punctuation">:</span> Prefix</span>
<span class="line">        <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">number</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">host</span><span class="token punctuation">:</span> api.vgo.example.com</span>
<span class="line">    <span class="token key atrule">http</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">paths</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> /</span>
<span class="line">        <span class="token key atrule">pathType</span><span class="token punctuation">:</span> Prefix</span>
<span class="line">        <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">number</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token comment"># gRPC Ingress (如果需要)</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> networking.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Ingress</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>grpc<span class="token punctuation">-</span>ingress</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo</span>
<span class="line">  <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">kubernetes.io/ingress.class</span><span class="token punctuation">:</span> nginx</span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/ssl-redirect</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/backend-protocol</span><span class="token punctuation">:</span> <span class="token string">"GRPC"</span></span>
<span class="line">    <span class="token key atrule">nginx.ingress.kubernetes.io/grpc-backend</span><span class="token punctuation">:</span> <span class="token string">"true"</span></span>
<span class="line">    <span class="token key atrule">cert-manager.io/cluster-issuer</span><span class="token punctuation">:</span> <span class="token string">"letsencrypt-prod"</span></span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">tls</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">hosts</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> grpc.vgo.example.com</span>
<span class="line">    <span class="token key atrule">secretName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>grpc<span class="token punctuation">-</span>tls<span class="token punctuation">-</span>secret</span>
<span class="line">  <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">host</span><span class="token punctuation">:</span> grpc.vgo.example.com</span>
<span class="line">    <span class="token key atrule">http</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">paths</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> /</span>
<span class="line">        <span class="token key atrule">pathType</span><span class="token punctuation">:</span> Prefix</span>
<span class="line">        <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">number</span><span class="token punctuation">:</span> <span class="token number">50051</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_9-部署应用" tabindex="-1"><a class="header-anchor" href="#_9-部署应用">#</a> 9. 部署应用</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 按顺序部署</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> storage-class.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> secrets.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> configmap.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> postgres-primary.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> redis.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待数据库就绪</span></span>
<span class="line">kubectl <span class="token function">wait</span> <span class="token parameter variable">--for</span><span class="token operator">=</span>condition<span class="token operator">=</span>ready pod <span class="token parameter variable">-l</span> <span class="token assign-left variable">app</span><span class="token operator">=</span>vgo-postgres <span class="token parameter variable">-n</span> vgo-system <span class="token parameter variable">--timeout</span><span class="token operator">=</span>300s</span>
<span class="line">kubectl <span class="token function">wait</span> <span class="token parameter variable">--for</span><span class="token operator">=</span>condition<span class="token operator">=</span>ready pod <span class="token parameter variable">-l</span> <span class="token assign-left variable">app</span><span class="token operator">=</span>vgo-redis <span class="token parameter variable">-n</span> vgo-system <span class="token parameter variable">--timeout</span><span class="token operator">=</span>300s</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署应用</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> iam-deployment.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待应用就绪</span></span>
<span class="line">kubectl <span class="token function">wait</span> <span class="token parameter variable">--for</span><span class="token operator">=</span>condition<span class="token operator">=</span>ready pod <span class="token parameter variable">-l</span> <span class="token assign-left variable">app</span><span class="token operator">=</span>vgo-iam <span class="token parameter variable">-n</span> vgo-system <span class="token parameter variable">--timeout</span><span class="token operator">=</span>300s</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 部署Ingress</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> ingress.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_10-验证部署" tabindex="-1"><a class="header-anchor" href="#_10-验证部署">#</a> 10. 验证部署</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查Pod状态</span></span>
<span class="line">kubectl get pods <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务状态</span></span>
<span class="line">kubectl get svc <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Ingress状态</span></span>
<span class="line">kubectl get ingress <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看应用日志</span></span>
<span class="line">kubectl logs <span class="token parameter variable">-f</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试健康检查</span></span>
<span class="line">kubectl <span class="token builtin class-name">exec</span> <span class="token parameter variable">-it</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system -- <span class="token function">curl</span> http://localhost:8081/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试gRPC API</span></span>
<span class="line">kubectl port-forward svc/vgo-iam <span class="token number">50051</span>:50051 <span class="token parameter variable">-n</span> vgo-system <span class="token operator">&amp;</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 list</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-高级配置" tabindex="-1"><a class="header-anchor" href="#🔧-高级配置">#</a> 🔧 高级配置</h2>
<h3 id="水平pod自动扩缩容-hpa" tabindex="-1"><a class="header-anchor" href="#水平pod自动扩缩容-hpa">#</a> 水平Pod自动扩缩容(HPA)</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># hpa.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> autoscaling/v2</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> HorizontalPodAutoscaler</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>hpa</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">scaleTargetRef</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line">    <span class="token key atrule">kind</span><span class="token punctuation">:</span> Deployment</span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">minReplicas</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">  <span class="token key atrule">maxReplicas</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">  <span class="token key atrule">metrics</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Resource</span>
<span class="line">    <span class="token key atrule">resource</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">name</span><span class="token punctuation">:</span> cpu</span>
<span class="line">      <span class="token key atrule">target</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">type</span><span class="token punctuation">:</span> Utilization</span>
<span class="line">        <span class="token key atrule">averageUtilization</span><span class="token punctuation">:</span> <span class="token number">70</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Resource</span>
<span class="line">    <span class="token key atrule">resource</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">name</span><span class="token punctuation">:</span> memory</span>
<span class="line">      <span class="token key atrule">target</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">type</span><span class="token punctuation">:</span> Utilization</span>
<span class="line">        <span class="token key atrule">averageUtilization</span><span class="token punctuation">:</span> <span class="token number">80</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Pods</span>
<span class="line">    <span class="token key atrule">pods</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">metric</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">name</span><span class="token punctuation">:</span> grpc_requests_per_second</span>
<span class="line">      <span class="token key atrule">target</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">type</span><span class="token punctuation">:</span> AverageValue</span>
<span class="line">        <span class="token key atrule">averageValue</span><span class="token punctuation">:</span> <span class="token string">"100"</span></span>
<span class="line">  <span class="token key atrule">behavior</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">scaleDown</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">stabilizationWindowSeconds</span><span class="token punctuation">:</span> <span class="token number">300</span></span>
<span class="line">      <span class="token key atrule">policies</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Percent</span>
<span class="line">        <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token number">10</span></span>
<span class="line">        <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">60</span></span>
<span class="line">    <span class="token key atrule">scaleUp</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">stabilizationWindowSeconds</span><span class="token punctuation">:</span> <span class="token number">60</span></span>
<span class="line">      <span class="token key atrule">policies</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Percent</span>
<span class="line">        <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token number">50</span></span>
<span class="line">        <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">60</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">type</span><span class="token punctuation">:</span> Pods</span>
<span class="line">        <span class="token key atrule">value</span><span class="token punctuation">:</span> <span class="token number">2</span></span>
<span class="line">        <span class="token key atrule">periodSeconds</span><span class="token punctuation">:</span> <span class="token number">60</span></span>
<span class="line">      <span class="token key atrule">selectPolicy</span><span class="token punctuation">:</span> Max</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="垂直pod自动扩缩容-vpa" tabindex="-1"><a class="header-anchor" href="#垂直pod自动扩缩容-vpa">#</a> 垂直Pod自动扩缩容(VPA)</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># vpa.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> autoscaling.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> VerticalPodAutoscaler</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>vpa</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">targetRef</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line">    <span class="token key atrule">kind</span><span class="token punctuation">:</span> Deployment</span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">updatePolicy</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">updateMode</span><span class="token punctuation">:</span> <span class="token string">"Auto"</span></span>
<span class="line">  <span class="token key atrule">resourcePolicy</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">containerPolicies</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">containerName</span><span class="token punctuation">:</span> iam</span>
<span class="line">      <span class="token key atrule">minAllowed</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 100m</span>
<span class="line">        <span class="token key atrule">memory</span><span class="token punctuation">:</span> 128Mi</span>
<span class="line">      <span class="token key atrule">maxAllowed</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 2000m</span>
<span class="line">        <span class="token key atrule">memory</span><span class="token punctuation">:</span> 2Gi</span>
<span class="line">      <span class="token key atrule">controlledResources</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token string">"cpu"</span><span class="token punctuation">,</span> <span class="token string">"memory"</span><span class="token punctuation">]</span></span>
<span class="line">      <span class="token key atrule">controlledValues</span><span class="token punctuation">:</span> RequestsAndLimits</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="pod中断预算-pdb" tabindex="-1"><a class="header-anchor" href="#pod中断预算-pdb">#</a> Pod中断预算(PDB)</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># pdb.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> policy/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> PodDisruptionBudget</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>pdb</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">minAvailable</span><span class="token punctuation">:</span> <span class="token number">2</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> policy/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> PodDisruptionBudget</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres<span class="token punctuation">-</span>pdb</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">maxUnavailable</span><span class="token punctuation">:</span> <span class="token number">0</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="网络策略" tabindex="-1"><a class="header-anchor" href="#网络策略">#</a> 网络策略</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># network-policy.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> networking.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> NetworkPolicy</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>netpol</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">policyTypes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> Ingress</span>
<span class="line">  <span class="token punctuation">-</span> Egress</span>
<span class="line">  <span class="token key atrule">ingress</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">from</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">namespaceSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> ingress<span class="token punctuation">-</span>nginx</span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">50051</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">from</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">namespaceSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">8082</span></span>
<span class="line">  <span class="token key atrule">egress</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>redis</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">6379</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">53</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> UDP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">53</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">to</span><span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">443</span></span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> networking.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> NetworkPolicy</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres<span class="token punctuation">-</span>netpol</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>postgres</span>
<span class="line">  <span class="token key atrule">policyTypes</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> Ingress</span>
<span class="line">  <span class="token key atrule">ingress</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">from</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">podSelector</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">app</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>exporter</span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">protocol</span><span class="token punctuation">:</span> TCP</span>
<span class="line">      <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">5432</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-监控配置" tabindex="-1"><a class="header-anchor" href="#📊-监控配置">#</a> 📊 监控配置</h2>
<h3 id="prometheus配置" tabindex="-1"><a class="header-anchor" href="#prometheus配置">#</a> Prometheus配置</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># prometheus.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> ConfigMap</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>config</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line"><span class="token key atrule">data</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">prometheus.yml</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">    global:</span>
<span class="line">      scrape_interval: 15s</span>
<span class="line">      evaluation_interval: 15s</span>
<span class="line">      external_labels:</span>
<span class="line">        cluster: 'vgo-k8s-cluster'</span>
<span class="line">        environment: 'production'</span></span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">rule_files</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"/etc/prometheus/rules/*.yml"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">scrape_configs</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token comment"># Kubernetes API Server</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'kubernetes-apiservers'</span></span>
<span class="line">        <span class="token key atrule">kubernetes_sd_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">role</span><span class="token punctuation">:</span> endpoints</span>
<span class="line">        <span class="token key atrule">scheme</span><span class="token punctuation">:</span> https</span>
<span class="line">        <span class="token key atrule">tls_config</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">ca_file</span><span class="token punctuation">:</span> /var/run/secrets/kubernetes.io/serviceaccount/ca.crt</span>
<span class="line">        <span class="token key atrule">bearer_token_file</span><span class="token punctuation">:</span> /var/run/secrets/kubernetes.io/serviceaccount/token</span>
<span class="line">        <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_namespace<span class="token punctuation">,</span> __meta_kubernetes_service_name<span class="token punctuation">,</span> __meta_kubernetes_endpoint_port_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> keep</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> default;kubernetes;https</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># Kubernetes Nodes</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'kubernetes-nodes'</span></span>
<span class="line">        <span class="token key atrule">kubernetes_sd_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">role</span><span class="token punctuation">:</span> node</span>
<span class="line">        <span class="token key atrule">scheme</span><span class="token punctuation">:</span> https</span>
<span class="line">        <span class="token key atrule">tls_config</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">ca_file</span><span class="token punctuation">:</span> /var/run/secrets/kubernetes.io/serviceaccount/ca.crt</span>
<span class="line">        <span class="token key atrule">bearer_token_file</span><span class="token punctuation">:</span> /var/run/secrets/kubernetes.io/serviceaccount/token</span>
<span class="line">        <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">action</span><span class="token punctuation">:</span> labelmap</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> __meta_kubernetes_node_label_(.+)</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __address__</span>
<span class="line">          <span class="token key atrule">replacement</span><span class="token punctuation">:</span> kubernetes.default.svc<span class="token punctuation">:</span><span class="token number">443</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_node_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> (.+)</span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __metrics_path__</span>
<span class="line">          <span class="token key atrule">replacement</span><span class="token punctuation">:</span> /api/v1/nodes/$<span class="token punctuation">{</span><span class="token number">1</span><span class="token punctuation">}</span>/proxy/metrics</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># Kubernetes Pods</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'kubernetes-pods'</span></span>
<span class="line">        <span class="token key atrule">kubernetes_sd_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">role</span><span class="token punctuation">:</span> pod</span>
<span class="line">        <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_pod_annotation_prometheus_io_scrape<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> keep</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_pod_annotation_prometheus_io_path<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> replace</span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __metrics_path__</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> (.+)</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__address__<span class="token punctuation">,</span> __meta_kubernetes_pod_annotation_prometheus_io_port<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> replace</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> (<span class="token punctuation">[</span>^<span class="token punctuation">:</span><span class="token punctuation">]</span>+)(<span class="token punctuation">?</span><span class="token punctuation">:</span><span class="token punctuation">:</span>\d+)<span class="token punctuation">?</span>;(\d+)</span>
<span class="line">          <span class="token key atrule">replacement</span><span class="token punctuation">:</span> $1<span class="token punctuation">:</span>$2</span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> __address__</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">action</span><span class="token punctuation">:</span> labelmap</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> __meta_kubernetes_pod_label_(.+)</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_namespace<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> replace</span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> kubernetes_namespace</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_pod_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> replace</span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> kubernetes_pod_name</span>
<span class="line">      </span>
<span class="line">      <span class="token comment"># VGO IAM Service</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">job_name</span><span class="token punctuation">:</span> <span class="token string">'vgo-iam'</span></span>
<span class="line">        <span class="token key atrule">kubernetes_sd_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">role</span><span class="token punctuation">:</span> endpoints</span>
<span class="line">          <span class="token key atrule">namespaces</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">names</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">        <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_service_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> keep</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_endpoint_port_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> keep</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> metrics</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_namespace<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> namespace</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_service_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> service</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_pod_name<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">target_label</span><span class="token punctuation">:</span> pod</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">alerting</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">alertmanagers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">kubernetes_sd_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">role</span><span class="token punctuation">:</span> pod</span>
<span class="line">          <span class="token key atrule">namespaces</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">names</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">        <span class="token key atrule">relabel_configs</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">source_labels</span><span class="token punctuation">:</span> <span class="token punctuation">[</span>__meta_kubernetes_pod_label_app<span class="token punctuation">]</span></span>
<span class="line">          <span class="token key atrule">action</span><span class="token punctuation">:</span> keep</span>
<span class="line">          <span class="token key atrule">regex</span><span class="token punctuation">:</span> alertmanager</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> apps/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Deployment</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> prometheus</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">  <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">app</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">serviceAccountName</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">      <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> prom/prometheus<span class="token punctuation">:</span>latest</span>
<span class="line">        <span class="token key atrule">args</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--config.file=/etc/prometheus/prometheus.yml'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.path=/prometheus/'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--web.console.libraries=/etc/prometheus/console_libraries'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--web.console.templates=/etc/prometheus/consoles'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--storage.tsdb.retention.time=200h'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--web.enable-lifecycle'</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token string">'--web.enable-admin-api'</span></span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">containerPort</span><span class="token punctuation">:</span> <span class="token number">9090</span></span>
<span class="line">        <span class="token key atrule">volumeMounts</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>config</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /etc/prometheus</span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>storage</span>
<span class="line">          <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /prometheus</span>
<span class="line">        <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 500m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 1Gi</span>
<span class="line">          <span class="token key atrule">limits</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">cpu</span><span class="token punctuation">:</span> 1000m</span>
<span class="line">            <span class="token key atrule">memory</span><span class="token punctuation">:</span> 2Gi</span>
<span class="line">      <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>config</span>
<span class="line">        <span class="token key atrule">configMap</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>config</span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>storage</span>
<span class="line">        <span class="token key atrule">persistentVolumeClaim</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">claimName</span><span class="token punctuation">:</span> prometheus<span class="token punctuation">-</span>pvc</span>
<span class="line"><span class="token punctuation">---</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Service</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> prometheus</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>monitoring</span>
<span class="line">  <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> prometheus</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">type</span><span class="token punctuation">:</span> ClusterIP</span>
<span class="line">  <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">port</span><span class="token punctuation">:</span> <span class="token number">9090</span></span>
<span class="line">    <span class="token key atrule">targetPort</span><span class="token punctuation">:</span> <span class="token number">9090</span></span>
<span class="line">    <span class="token key atrule">name</span><span class="token punctuation">:</span> web</span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">app</span><span class="token punctuation">:</span> prometheus</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔄-备份和恢复" tabindex="-1"><a class="header-anchor" href="#🔄-备份和恢复">#</a> 🔄 备份和恢复</h2>
<h3 id="数据库备份cronjob" tabindex="-1"><a class="header-anchor" href="#数据库备份cronjob">#</a> 数据库备份CronJob</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># backup-cronjob.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> batch/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> CronJob</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>backup</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">schedule</span><span class="token punctuation">:</span> <span class="token string">"0 2 * * *"</span>  <span class="token comment"># 每天凌晨2点</span></span>
<span class="line">  <span class="token key atrule">jobTemplate</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> postgres<span class="token punctuation">-</span>backup</span>
<span class="line">            <span class="token key atrule">image</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>15<span class="token punctuation">-</span>alpine</span>
<span class="line">            <span class="token key atrule">command</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> /bin/bash</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">-</span>c</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">              set -e</span>
<span class="line">              BACKUP_FILE="/backup/postgres_$(date +%Y%m%d_%H%M%S).sql.gz"</span>
<span class="line">              echo "开始备份到 $BACKUP_FILE"</span>
<span class="line">              pg_dump -h vgo-postgres -U $POSTGRES_USER -d $POSTGRES_DB | gzip > $BACKUP_FILE</span>
<span class="line">              echo "备份完成"</span></span>
<span class="line">              </span>
<span class="line">              <span class="token comment"># 清理7天前的备份</span></span>
<span class="line">              find /backup <span class="token punctuation">-</span>name "postgres_<span class="token important">*.sql.gz"</span> <span class="token punctuation">-</span>mtime +7 <span class="token punctuation">-</span>delete</span>
<span class="line">              echo "清理完成"</span>
<span class="line">            <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_USER</span>
<span class="line">              <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">                  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">                  <span class="token key atrule">key</span><span class="token punctuation">:</span> username</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> POSTGRES_DB</span>
<span class="line">              <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">                  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">                  <span class="token key atrule">key</span><span class="token punctuation">:</span> database</span>
<span class="line">            <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> PGPASSWORD</span>
<span class="line">              <span class="token key atrule">valueFrom</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token key atrule">secretKeyRef</span><span class="token punctuation">:</span></span>
<span class="line">                  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>database<span class="token punctuation">-</span>secret</span>
<span class="line">                  <span class="token key atrule">key</span><span class="token punctuation">:</span> password</span>
<span class="line">            <span class="token key atrule">volumeMounts</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> backup<span class="token punctuation">-</span>storage</span>
<span class="line">              <span class="token key atrule">mountPath</span><span class="token punctuation">:</span> /backup</span>
<span class="line">          <span class="token key atrule">volumes</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> backup<span class="token punctuation">-</span>storage</span>
<span class="line">            <span class="token key atrule">persistentVolumeClaim</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">claimName</span><span class="token punctuation">:</span> backup<span class="token punctuation">-</span>pvc</span>
<span class="line">          <span class="token key atrule">restartPolicy</span><span class="token punctuation">:</span> OnFailure</span>
<span class="line">  <span class="token key atrule">successfulJobsHistoryLimit</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">  <span class="token key atrule">failedJobsHistoryLimit</span><span class="token punctuation">:</span> <span class="token number">1</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="备份存储pvc" tabindex="-1"><a class="header-anchor" href="#备份存储pvc">#</a> 备份存储PVC</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># backup-pvc.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> PersistentVolumeClaim</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> backup<span class="token punctuation">-</span>pvc</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">accessModes</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> ReadWriteOnce</span>
<span class="line">  <span class="token key atrule">storageClassName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>standard</span>
<span class="line">  <span class="token key atrule">resources</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">requests</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">storage</span><span class="token punctuation">:</span> 100Gi</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-故障排除" tabindex="-1"><a class="header-anchor" href="#🔧-故障排除">#</a> 🔧 故障排除</h2>
<h3 id="常见问题诊断" tabindex="-1"><a class="header-anchor" href="#常见问题诊断">#</a> 常见问题诊断</h3>
<h4 id="_1-pod启动失败" tabindex="-1"><a class="header-anchor" href="#_1-pod启动失败">#</a> 1. Pod启动失败</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看Pod状态</span></span>
<span class="line">kubectl get pods <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看Pod详细信息</span></span>
<span class="line">kubectl describe pod <span class="token operator">&lt;</span>pod-name<span class="token operator">></span> <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看Pod日志</span></span>
<span class="line">kubectl logs <span class="token operator">&lt;</span>pod-name<span class="token operator">></span> <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看前一个容器的日志</span></span>
<span class="line">kubectl logs <span class="token operator">&lt;</span>pod-name<span class="token operator">></span> <span class="token parameter variable">-n</span> vgo-system <span class="token parameter variable">--previous</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 进入Pod调试</span></span>
<span class="line">kubectl <span class="token builtin class-name">exec</span> <span class="token parameter variable">-it</span> <span class="token operator">&lt;</span>pod-name<span class="token operator">></span> <span class="token parameter variable">-n</span> vgo-system -- /bin/sh</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-服务连接问题" tabindex="-1"><a class="header-anchor" href="#_2-服务连接问题">#</a> 2. 服务连接问题</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 测试服务连通性</span></span>
<span class="line">kubectl run test-pod <span class="token parameter variable">--image</span><span class="token operator">=</span>busybox <span class="token parameter variable">--rm</span> <span class="token parameter variable">-it</span> <span class="token parameter variable">--restart</span><span class="token operator">=</span>Never -- <span class="token function">nslookup</span> vgo-iam.vgo-system.svc.cluster.local</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试端口连通性</span></span>
<span class="line">kubectl run test-pod <span class="token parameter variable">--image</span><span class="token operator">=</span>busybox <span class="token parameter variable">--rm</span> <span class="token parameter variable">-it</span> <span class="token parameter variable">--restart</span><span class="token operator">=</span>Never -- telnet vgo-iam.vgo-system.svc.cluster.local <span class="token number">8080</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看服务端点</span></span>
<span class="line">kubectl get endpoints <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看服务详情</span></span>
<span class="line">kubectl describe svc vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-存储问题" tabindex="-1"><a class="header-anchor" href="#_3-存储问题">#</a> 3. 存储问题</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看PVC状态</span></span>
<span class="line">kubectl get pvc <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看PV状态</span></span>
<span class="line">kubectl get <span class="token function">pv</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看存储类</span></span>
<span class="line">kubectl get storageclass</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看PVC详情</span></span>
<span class="line">kubectl describe pvc postgres-data-vgo-postgres-0 <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="性能调优" tabindex="-1"><a class="header-anchor" href="#性能调优">#</a> 性能调优</h3>
<h4 id="资源监控" tabindex="-1"><a class="header-anchor" href="#资源监控">#</a> 资源监控</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看节点资源使用</span></span>
<span class="line">kubectl <span class="token function">top</span> nodes</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看Pod资源使用</span></span>
<span class="line">kubectl <span class="token function">top</span> pods <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看容器资源使用</span></span>
<span class="line">kubectl <span class="token function">top</span> pods <span class="token parameter variable">-n</span> vgo-system <span class="token parameter variable">--containers</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="性能分析" tabindex="-1"><a class="header-anchor" href="#性能分析">#</a> 性能分析</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启用性能分析</span></span>
<span class="line">kubectl port-forward svc/vgo-iam <span class="token number">8082</span>:8082 <span class="token parameter variable">-n</span> vgo-system <span class="token operator">&amp;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># CPU分析</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8082/debug/pprof/profile?seconds<span class="token operator">=</span><span class="token number">30</span> <span class="token operator">></span> cpu.prof</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 内存分析</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8082/debug/pprof/heap <span class="token operator">></span> heap.prof</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看goroutine</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8082/debug/pprof/goroutine?debug<span class="token operator">=</span><span class="token number">1</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📈-扩展和升级" tabindex="-1"><a class="header-anchor" href="#📈-扩展和升级">#</a> 📈 扩展和升级</h2>
<h3 id="滚动更新" tabindex="-1"><a class="header-anchor" href="#滚动更新">#</a> 滚动更新</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 更新镜像</span></span>
<span class="line">kubectl <span class="token builtin class-name">set</span> image deployment/vgo-iam <span class="token assign-left variable">iam</span><span class="token operator">=</span>vgo/iam:v1.1.0 <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看更新状态</span></span>
<span class="line">kubectl rollout status deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看更新历史</span></span>
<span class="line">kubectl rollout <span class="token function">history</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 回滚到上一个版本</span></span>
<span class="line">kubectl rollout undo deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 回滚到指定版本</span></span>
<span class="line">kubectl rollout undo deployment/vgo-iam --to-revision<span class="token operator">=</span><span class="token number">2</span> <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="蓝绿部署" tabindex="-1"><a class="header-anchor" href="#蓝绿部署">#</a> 蓝绿部署</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># blue-green-deployment.yaml</span></span>
<span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> argoproj.io/v1alpha1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Rollout</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>rollout</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">replicas</span><span class="token punctuation">:</span> <span class="token number">3</span></span>
<span class="line">  <span class="token key atrule">strategy</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">blueGreen</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">activeService</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>active</span>
<span class="line">      <span class="token key atrule">previewService</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>preview</span>
<span class="line">      <span class="token key atrule">autoPromotionEnabled</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">      <span class="token key atrule">scaleDownDelaySeconds</span><span class="token punctuation">:</span> <span class="token number">30</span></span>
<span class="line">      <span class="token key atrule">prePromotionAnalysis</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">templates</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">templateName</span><span class="token punctuation">:</span> success<span class="token punctuation">-</span>rate</span>
<span class="line">        <span class="token key atrule">args</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> service<span class="token punctuation">-</span>name</span>
<span class="line">          <span class="token key atrule">value</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>preview.vgo<span class="token punctuation">-</span>system.svc.cluster.local</span>
<span class="line">      <span class="token key atrule">postPromotionAnalysis</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">templates</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">templateName</span><span class="token punctuation">:</span> success<span class="token punctuation">-</span>rate</span>
<span class="line">        <span class="token key atrule">args</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> service<span class="token punctuation">-</span>name</span>
<span class="line">          <span class="token key atrule">value</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>active.vgo<span class="token punctuation">-</span>system.svc.cluster.local</span>
<span class="line">  <span class="token key atrule">selector</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">matchLabels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">  <span class="token key atrule">template</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">app</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">    <span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">containers</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> iam</span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> vgo/iam<span class="token punctuation">:</span>v1.1.0</span>
<span class="line">        <span class="token comment"># ... 其他配置</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/deployment/docker-compose.html">Docker Compose部署</RouteLink> - 简单部署方案</li>
<li><RouteLink to="/deployment/monitoring.html">监控配置</RouteLink> - 完整监控解决方案</li>
<li><RouteLink to="/deployment/security.html">安全配置</RouteLink> - 生产环境安全</li>
<li><RouteLink to="/deployment/troubleshooting.html">故障排除</RouteLink> - 问题诊断指南</li>
<li><RouteLink to="/deployment/performance.html">性能调优</RouteLink> - 性能优化建议</li>
</ul>
<hr>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>Kubernetes部署适合大规模生产环境，建议先在测试环境验证配置。</p>
</div>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>生产环境请务必配置适当的资源限制、网络策略和安全策略。</p>
</div>
</div></template>


