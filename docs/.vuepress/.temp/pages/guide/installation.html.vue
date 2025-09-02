<template><div><h1 id="安装指南" tabindex="-1"><a class="header-anchor" href="#安装指南">#</a> 安装指南</h1>
<p>本指南详细介绍了VGO微服务的各种安装方式，您可以根据自己的需求选择合适的安装方法。</p>
<h2 id="📦-安装方式概览" tabindex="-1"><a class="header-anchor" href="#📦-安装方式概览">#</a> 📦 安装方式概览</h2>
<table>
<thead>
<tr>
<th>安装方式</th>
<th>适用场景</th>
<th>难度</th>
<th>推荐度</th>
</tr>
</thead>
<tbody>
<tr>
<td>Docker Compose</td>
<td>开发、测试</td>
<td>⭐</td>
<td>⭐⭐⭐⭐⭐</td>
</tr>
<tr>
<td>二进制文件</td>
<td>生产环境</td>
<td>⭐⭐</td>
<td>⭐⭐⭐⭐</td>
</tr>
<tr>
<td>源码编译</td>
<td>定制开发</td>
<td>⭐⭐⭐</td>
<td>⭐⭐⭐</td>
</tr>
<tr>
<td>Kubernetes</td>
<td>云原生环境</td>
<td>⭐⭐⭐⭐</td>
<td>⭐⭐⭐⭐⭐</td>
</tr>
</tbody>
</table>
<h2 id="🐳-docker-compose-安装" tabindex="-1"><a class="header-anchor" href="#🐳-docker-compose-安装">#</a> 🐳 Docker Compose 安装</h2>
<h3 id="系统要求" tabindex="-1"><a class="header-anchor" href="#系统要求">#</a> 系统要求</h3>
<ul>
<li>Docker 20.10+</li>
<li>Docker Compose 2.0+</li>
<li>至少 2GB 可用内存</li>
<li>至少 5GB 可用磁盘空间</li>
</ul>
<h3 id="安装步骤" tabindex="-1"><a class="header-anchor" href="#安装步骤">#</a> 安装步骤</h3>
<h4 id="_1-获取项目代码" tabindex="-1"><a class="header-anchor" href="#_1-获取项目代码">#</a> 1. 获取项目代码</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 使用Git克隆</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/vera-byte/vgo_micro_service.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或者下载压缩包</span></span>
<span class="line"><span class="token function">wget</span> https://github.com/vera-byte/vgo_micro_service/archive/main.zip</span>
<span class="line"><span class="token function">unzip</span> main.zip</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service-main</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-配置环境变量" tabindex="-1"><a class="header-anchor" href="#_2-配置环境变量">#</a> 2. 配置环境变量</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 复制环境变量模板</span></span>
<span class="line"><span class="token function">cp</span> .env.example .env</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编辑环境变量</span></span>
<span class="line"><span class="token function">vim</span> .env</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>关键配置项：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 数据库配置</span></span>
<span class="line"><span class="token assign-left variable">POSTGRES_DB</span><span class="token operator">=</span>vgo_iam</span>
<span class="line"><span class="token assign-left variable">POSTGRES_USER</span><span class="token operator">=</span>vgo_iam</span>
<span class="line"><span class="token assign-left variable">POSTGRES_PASSWORD</span><span class="token operator">=</span>your_secure_password</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 服务配置</span></span>
<span class="line"><span class="token assign-left variable">GRPC_PORT</span><span class="token operator">=</span><span class="token number">50051</span></span>
<span class="line"><span class="token assign-left variable">HTTP_PORT</span><span class="token operator">=</span><span class="token number">8080</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安全配置</span></span>
<span class="line"><span class="token assign-left variable">MASTER_KEY</span><span class="token operator">=</span>your_master_key_here</span>
<span class="line"><span class="token assign-left variable">JWT_SECRET</span><span class="token operator">=</span>your_jwt_secret_here</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-启动服务" tabindex="-1"><a class="header-anchor" href="#_3-启动服务">#</a> 3. 启动服务</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启动所有服务</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看启动状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs <span class="token parameter variable">-f</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_4-初始化数据" tabindex="-1"><a class="header-anchor" href="#_4-初始化数据">#</a> 4. 初始化数据</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 等待数据库启动完成</span></span>
<span class="line"><span class="token function">sleep</span> <span class="token number">30</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行数据库迁移</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service migrate</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建管理员账户</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service init-admin</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📁-二进制文件安装" tabindex="-1"><a class="header-anchor" href="#📁-二进制文件安装">#</a> 📁 二进制文件安装</h2>
<h3 id="下载预编译二进制文件" tabindex="-1"><a class="header-anchor" href="#下载预编译二进制文件">#</a> 下载预编译二进制文件</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 下载最新版本</span></span>
<span class="line"><span class="token function">wget</span> https://github.com/vera-byte/vgo_micro_service/releases/latest/download/iam-service-linux-amd64.tar.gz</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 解压</span></span>
<span class="line"><span class="token function">tar</span> <span class="token parameter variable">-xzf</span> iam-service-linux-amd64.tar.gz</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 移动到系统路径</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">mv</span> iam-service /usr/local/bin/</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chmod</span> +x /usr/local/bin/iam-service</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="配置文件" tabindex="-1"><a class="header-anchor" href="#配置文件">#</a> 配置文件</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建配置目录</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">mkdir</span> <span class="token parameter variable">-p</span> /etc/vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 下载配置模板</span></span>
<span class="line"><span class="token function">wget</span> <span class="token parameter variable">-O</span> /etc/vgo-iam/config.yaml https://raw.githubusercontent.com/vera-byte/vgo_micro_service/main/vgo-iam/config/config.yaml.example</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编辑配置</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">vim</span> /etc/vgo-iam/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="创建系统服务" tabindex="-1"><a class="header-anchor" href="#创建系统服务">#</a> 创建系统服务</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建systemd服务文件</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">tee</span> /etc/systemd/system/vgo-iam.service <span class="token operator">></span> /dev/null <span class="token operator">&lt;&lt;</span><span class="token string">EOF</span>
<span class="line">[Unit]</span>
<span class="line">Description=VGO IAM Service</span>
<span class="line">After=network.target postgresql.service</span>
<span class="line"></span>
<span class="line">[Service]</span>
<span class="line">Type=simple</span>
<span class="line">User=vgo-iam</span>
<span class="line">Group=vgo-iam</span>
<span class="line">ExecStart=/usr/local/bin/iam-service server --config /etc/vgo-iam/config.yaml</span>
<span class="line">Restart=always</span>
<span class="line">RestartSec=5</span>
<span class="line"></span>
<span class="line">[Install]</span>
<span class="line">WantedBy=multi-user.target</span>
<span class="line">EOF</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建用户</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">useradd</span> <span class="token parameter variable">-r</span> <span class="token parameter variable">-s</span> /bin/false vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 重载systemd配置</span></span>
<span class="line"><span class="token function">sudo</span> systemctl daemon-reload</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动服务</span></span>
<span class="line"><span class="token function">sudo</span> systemctl <span class="token builtin class-name">enable</span> vgo-iam</span>
<span class="line"><span class="token function">sudo</span> systemctl start vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看状态</span></span>
<span class="line"><span class="token function">sudo</span> systemctl status vgo-iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔨-源码编译安装" tabindex="-1"><a class="header-anchor" href="#🔨-源码编译安装">#</a> 🔨 源码编译安装</h2>
<h3 id="系统要求-1" tabindex="-1"><a class="header-anchor" href="#系统要求-1">#</a> 系统要求</h3>
<ul>
<li>Go 1.19+</li>
<li>Git</li>
<li>Make</li>
<li>Protocol Buffers编译器</li>
</ul>
<h3 id="安装依赖" tabindex="-1"><a class="header-anchor" href="#安装依赖">#</a> 安装依赖</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># Ubuntu/Debian</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt</span> update</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt</span> <span class="token function">install</span> <span class="token parameter variable">-y</span> <span class="token function">git</span> <span class="token function">make</span> protobuf-compiler</span>
<span class="line"></span>
<span class="line"><span class="token comment"># CentOS/RHEL</span></span>
<span class="line"><span class="token function">sudo</span> yum <span class="token function">install</span> <span class="token parameter variable">-y</span> <span class="token function">git</span> <span class="token function">make</span> protobuf-compiler</span>
<span class="line"></span>
<span class="line"><span class="token comment"># macOS</span></span>
<span class="line">brew <span class="token function">install</span> <span class="token function">git</span> <span class="token function">make</span> protobuf</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="编译步骤" tabindex="-1"><a class="header-anchor" href="#编译步骤">#</a> 编译步骤</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 1. 克隆代码</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/vera-byte/vgo_micro_service.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service/vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 2. 安装Go依赖</span></span>
<span class="line">go mod download</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 3. 安装protobuf工具</span></span>
<span class="line">go <span class="token function">install</span> google.golang.org/protobuf/cmd/protoc-gen-go@latest</span>
<span class="line">go <span class="token function">install</span> google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 4. 生成protobuf代码</span></span>
<span class="line"><span class="token function">make</span> proto</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 5. 编译二进制文件</span></span>
<span class="line"><span class="token function">make</span> build</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 6. 运行测试</span></span>
<span class="line"><span class="token function">make</span> <span class="token builtin class-name">test</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 7. 安装到系统</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">make</span> <span class="token function">install</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="编译选项" tabindex="-1"><a class="header-anchor" href="#编译选项">#</a> 编译选项</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 编译特定平台</span></span>
<span class="line"><span class="token assign-left variable">GOOS</span><span class="token operator">=</span>linux <span class="token assign-left variable">GOARCH</span><span class="token operator">=</span>amd64 <span class="token function">make</span> build</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编译所有平台</span></span>
<span class="line"><span class="token function">make</span> build-all</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编译Docker镜像</span></span>
<span class="line"><span class="token function">make</span> <span class="token function">docker</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编译并推送Docker镜像</span></span>
<span class="line"><span class="token function">make</span> docker-push</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="☸️-kubernetes-安装" tabindex="-1"><a class="header-anchor" href="#☸️-kubernetes-安装">#</a> ☸️ Kubernetes 安装</h2>
<h3 id="前置要求" tabindex="-1"><a class="header-anchor" href="#前置要求">#</a> 前置要求</h3>
<ul>
<li>Kubernetes 1.20+</li>
<li>kubectl 配置完成</li>
<li>Helm 3.0+ (可选)</li>
</ul>
<h3 id="使用helm安装-推荐" tabindex="-1"><a class="header-anchor" href="#使用helm安装-推荐">#</a> 使用Helm安装（推荐）</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 1. 添加Helm仓库</span></span>
<span class="line">helm repo <span class="token function">add</span> vgo https://charts.vgo.dev</span>
<span class="line">helm repo update</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 2. 创建命名空间</span></span>
<span class="line">kubectl create namespace vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 3. 安装VGO</span></span>
<span class="line">helm <span class="token function">install</span> vgo-iam vgo/vgo-iam <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--namespace</span> vgo-system <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--set</span> <span class="token assign-left variable">postgresql.enabled</span><span class="token operator">=</span>true <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--set</span> <span class="token assign-left variable">redis.enabled</span><span class="token operator">=</span>true</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 4. 查看安装状态</span></span>
<span class="line">kubectl get pods <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="使用yaml文件安装" tabindex="-1"><a class="header-anchor" href="#使用yaml文件安装">#</a> 使用YAML文件安装</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 1. 应用Kubernetes配置</span></span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> k8s/namespace.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> k8s/postgres.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> k8s/redis.yaml</span>
<span class="line">kubectl apply <span class="token parameter variable">-f</span> k8s/vgo-iam.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 2. 查看部署状态</span></span>
<span class="line">kubectl get all <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 3. 查看服务日志</span></span>
<span class="line">kubectl logs <span class="token parameter variable">-f</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="配置ingress" tabindex="-1"><a class="header-anchor" href="#配置ingress">#</a> 配置Ingress</h3>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">apiVersion</span><span class="token punctuation">:</span> networking.k8s.io/v1</span>
<span class="line"><span class="token key atrule">kind</span><span class="token punctuation">:</span> Ingress</span>
<span class="line"><span class="token key atrule">metadata</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>ingress</span>
<span class="line">  <span class="token key atrule">namespace</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>system</span>
<span class="line">  <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">kubernetes.io/ingress.class</span><span class="token punctuation">:</span> nginx</span>
<span class="line">    <span class="token key atrule">cert-manager.io/cluster-issuer</span><span class="token punctuation">:</span> letsencrypt<span class="token punctuation">-</span>prod</span>
<span class="line"><span class="token key atrule">spec</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">tls</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">hosts</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> iam.yourdomain.com</span>
<span class="line">    <span class="token key atrule">secretName</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam<span class="token punctuation">-</span>tls</span>
<span class="line">  <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">host</span><span class="token punctuation">:</span> iam.yourdomain.com</span>
<span class="line">    <span class="token key atrule">http</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">paths</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> /</span>
<span class="line">        <span class="token key atrule">pathType</span><span class="token punctuation">:</span> Prefix</span>
<span class="line">        <span class="token key atrule">backend</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">service</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>iam</span>
<span class="line">            <span class="token key atrule">port</span><span class="token punctuation">:</span></span>
<span class="line">              <span class="token key atrule">number</span><span class="token punctuation">:</span> <span class="token number">8080</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-安装后配置" tabindex="-1"><a class="header-anchor" href="#🔧-安装后配置">#</a> 🔧 安装后配置</h2>
<h3 id="数据库初始化" tabindex="-1"><a class="header-anchor" href="#数据库初始化">#</a> 数据库初始化</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># Docker Compose环境</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service migrate</span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service init-admin</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 二进制安装</span></span>
<span class="line">iam-service migrate <span class="token parameter variable">--config</span> /etc/vgo-iam/config.yaml</span>
<span class="line">iam-service init-admin <span class="token parameter variable">--config</span> /etc/vgo-iam/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Kubernetes环境</span></span>
<span class="line">kubectl <span class="token builtin class-name">exec</span> <span class="token parameter variable">-it</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system -- ./bin/iam-service migrate</span>
<span class="line">kubectl <span class="token builtin class-name">exec</span> <span class="token parameter variable">-it</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system -- ./bin/iam-service init-admin</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="验证安装" tabindex="-1"><a class="header-anchor" href="#验证安装">#</a> 验证安装</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查服务健康状态</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8080/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试gRPC接口</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 grpc.health.v1.Health/Check</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 访问调试界面</span></span>
<span class="line"><span class="token function">open</span> http://localhost:8080</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-故障排除" tabindex="-1"><a class="header-anchor" href="#🚨-故障排除">#</a> 🚨 故障排除</h2>
<h3 id="常见问题" tabindex="-1"><a class="header-anchor" href="#常见问题">#</a> 常见问题</h3>
<h4 id="_1-端口被占用" tabindex="-1"><a class="header-anchor" href="#_1-端口被占用">#</a> 1. 端口被占用</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看端口占用</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">netstat</span> <span class="token parameter variable">-tlnp</span> <span class="token operator">|</span> <span class="token function">grep</span> :8080</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">netstat</span> <span class="token parameter variable">-tlnp</span> <span class="token operator">|</span> <span class="token function">grep</span> :50051</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 修改配置文件中的端口</span></span>
<span class="line"><span class="token function">vim</span> config/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-数据库连接失败" tabindex="-1"><a class="header-anchor" href="#_2-数据库连接失败">#</a> 2. 数据库连接失败</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查PostgreSQL状态</span></span>
<span class="line"><span class="token function">sudo</span> systemctl status postgresql</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试数据库连接</span></span>
<span class="line">psql <span class="token parameter variable">-h</span> localhost <span class="token parameter variable">-U</span> vgo_iam <span class="token parameter variable">-d</span> vgo_iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查防火墙设置</span></span>
<span class="line"><span class="token function">sudo</span> ufw status</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-权限问题" tabindex="-1"><a class="header-anchor" href="#_3-权限问题">#</a> 3. 权限问题</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查文件权限</span></span>
<span class="line"><span class="token function">ls</span> <span class="token parameter variable">-la</span> /usr/local/bin/iam-service</span>
<span class="line"><span class="token function">ls</span> <span class="token parameter variable">-la</span> /etc/vgo-iam/</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 修复权限</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chown</span> vgo-iam:vgo-iam /etc/vgo-iam/config.yaml</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chmod</span> <span class="token number">600</span> /etc/vgo-iam/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="日志查看" tabindex="-1"><a class="header-anchor" href="#日志查看">#</a> 日志查看</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># Docker Compose</span></span>
<span class="line"><span class="token function">docker-compose</span> logs vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># Systemd服务</span></span>
<span class="line"><span class="token function">sudo</span> journalctl <span class="token parameter variable">-u</span> vgo-iam <span class="token parameter variable">-f</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># Kubernetes</span></span>
<span class="line">kubectl logs <span class="token parameter variable">-f</span> deployment/vgo-iam <span class="token parameter variable">-n</span> vgo-system</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-下一步" tabindex="-1"><a class="header-anchor" href="#📚-下一步">#</a> 📚 下一步</h2>
<p>安装完成后，您可以：</p>
<ol>
<li><RouteLink to="/guide/configuration.html">配置详解</RouteLink> - 了解详细配置选项</li>
<li><RouteLink to="/guide/basic-usage.html">基本使用</RouteLink> - 开始使用VGO服务</li>
<li><a href="/api/" target="_blank" rel="noopener noreferrer">API文档</a> - 查看API接口文档</li>
</ol>
<div class="hint-container warning">
<p class="hint-container-title">注意</p>
<p>在生产环境中，请确保：</p>
<ul>
<li>使用强密码和安全的密钥</li>
<li>配置适当的防火墙规则</li>
<li>定期备份数据库</li>
<li>监控服务运行状态</li>
</ul>
</div>
</div></template>


