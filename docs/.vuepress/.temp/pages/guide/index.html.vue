<template><div><h1 id="快速开始" tabindex="-1"><a class="header-anchor" href="#快速开始">#</a> 快速开始</h1>
<p>欢迎使用VGO微服务！本指南将帮助您快速了解和部署VGO身份认证与授权管理系统。</p>
<h2 id="📋-系统要求" tabindex="-1"><a class="header-anchor" href="#📋-系统要求">#</a> 📋 系统要求</h2>
<p>在开始之前，请确保您的系统满足以下要求：</p>
<h3 id="基础环境" tabindex="-1"><a class="header-anchor" href="#基础环境">#</a> 基础环境</h3>
<ul>
<li><strong>操作系统</strong>: Linux、macOS 或 Windows</li>
<li><strong>Go语言</strong>: 1.19+ (如需从源码编译)</li>
<li><strong>Docker</strong>: 20.10+ (推荐使用Docker部署)</li>
<li><strong>Docker Compose</strong>: 2.0+</li>
</ul>
<h3 id="数据库要求" tabindex="-1"><a class="header-anchor" href="#数据库要求">#</a> 数据库要求</h3>
<ul>
<li><strong>PostgreSQL</strong>: 13+</li>
<li><strong>Redis</strong>: 6.0+ (可选，用于缓存)</li>
</ul>
<h2 id="🚀-快速部署" tabindex="-1"><a class="header-anchor" href="#🚀-快速部署">#</a> 🚀 快速部署</h2>
<h3 id="方式一-使用docker-compose-推荐" tabindex="-1"><a class="header-anchor" href="#方式一-使用docker-compose-推荐">#</a> 方式一：使用Docker Compose（推荐）</h3>
<p>这是最简单的部署方式，适合快速体验和开发环境。</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 1. 克隆项目</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/vera-byte/vgo_micro_service.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 2. 启动所有服务</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 3. 查看服务状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>服务启动后，您可以访问：</p>
<ul>
<li><strong>调试界面</strong>: http://localhost:8080</li>
<li><strong>gRPC服务</strong>: localhost:50051</li>
<li><strong>PostgreSQL</strong>: localhost:5432</li>
<li><strong>Redis</strong>: localhost:6379</li>
</ul>
<h3 id="方式二-手动部署" tabindex="-1"><a class="header-anchor" href="#方式二-手动部署">#</a> 方式二：手动部署</h3>
<p>如果您希望更精细地控制部署过程，可以选择手动部署。</p>
<h4 id="_1-准备数据库" tabindex="-1"><a class="header-anchor" href="#_1-准备数据库">#</a> 1. 准备数据库</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启动PostgreSQL</span></span>
<span class="line"><span class="token function">docker</span> run <span class="token parameter variable">-d</span> <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--name</span> vgo-postgres <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-e</span> <span class="token assign-left variable">POSTGRES_DB</span><span class="token operator">=</span>vgo_iam <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-e</span> <span class="token assign-left variable">POSTGRES_USER</span><span class="token operator">=</span>vgo_iam <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-e</span> <span class="token assign-left variable">POSTGRES_PASSWORD</span><span class="token operator">=</span>your_password <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-p</span> <span class="token number">5432</span>:5432 <span class="token punctuation">\</span></span>
<span class="line">  postgres:13</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动Redis（可选）</span></span>
<span class="line"><span class="token function">docker</span> run <span class="token parameter variable">-d</span> <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">--name</span> vgo-redis <span class="token punctuation">\</span></span>
<span class="line">  <span class="token parameter variable">-p</span> <span class="token number">6379</span>:6379 <span class="token punctuation">\</span></span>
<span class="line">  redis:6-alpine</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-配置服务" tabindex="-1"><a class="header-anchor" href="#_2-配置服务">#</a> 2. 配置服务</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 进入vgo-iam目录</span></span>
<span class="line"><span class="token builtin class-name">cd</span> vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 复制配置文件</span></span>
<span class="line"><span class="token function">cp</span> config/config.yaml.example config/config.yaml</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 编辑配置文件，修改数据库连接信息</span></span>
<span class="line"><span class="token function">vim</span> config/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-编译和运行" tabindex="-1"><a class="header-anchor" href="#_3-编译和运行">#</a> 3. 编译和运行</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 编译服务</span></span>
<span class="line">go build <span class="token parameter variable">-o</span> bin/iam-service cmd/server.go</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行数据库迁移</span></span>
<span class="line">./bin/iam-service migrate</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 初始化管理员账户</span></span>
<span class="line">./bin/iam-service init-admin</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 启动服务</span></span>
<span class="line">./bin/iam-service server</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-初始化配置" tabindex="-1"><a class="header-anchor" href="#🔧-初始化配置">#</a> 🔧 初始化配置</h2>
<h3 id="创建管理员账户" tabindex="-1"><a class="header-anchor" href="#创建管理员账户">#</a> 创建管理员账户</h3>
<p>首次部署后，您需要创建管理员账户：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 使用Docker Compose</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service init-admin</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或者直接运行</span></span>
<span class="line">./bin/iam-service init-admin</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>系统会提示您输入管理员信息：</p>
<ul>
<li>用户名</li>
<li>显示名称</li>
<li>邮箱地址</li>
<li>密码</li>
</ul>
<h3 id="获取访问密钥" tabindex="-1"><a class="header-anchor" href="#获取访问密钥">#</a> 获取访问密钥</h3>
<p>创建管理员账户后，获取API访问密钥：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 获取管理员访问密钥</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token builtin class-name">exec</span> vgo-iam ./bin/iam-service get-admin-key</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🎯-验证部署" tabindex="-1"><a class="header-anchor" href="#🎯-验证部署">#</a> 🎯 验证部署</h2>
<h3 id="_1-检查服务状态" tabindex="-1"><a class="header-anchor" href="#_1-检查服务状态">#</a> 1. 检查服务状态</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查所有容器状态</span></span>
<span class="line"><span class="token function">docker-compose</span> <span class="token function">ps</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看服务日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs vgo-iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-访问调试界面" tabindex="-1"><a class="header-anchor" href="#_2-访问调试界面">#</a> 2. 访问调试界面</h3>
<p>打开浏览器访问 http://localhost:8080，您应该能看到VGO调试界面，包括：</p>
<ul>
<li>用户管理</li>
<li>策略管理</li>
<li>访问密钥管理</li>
<li>应用管理</li>
<li>权限检查</li>
</ul>
<h3 id="_3-测试grpc-api" tabindex="-1"><a class="header-anchor" href="#_3-测试grpc-api">#</a> 3. 测试gRPC API</h3>
<p>使用grpcurl测试API接口：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装grpcurl</span></span>
<span class="line">go <span class="token function">install</span> github.com/fullstorydev/grpcurl/cmd/grpcurl@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试创建用户</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> <span class="token parameter variable">-d</span> <span class="token string">'{</span>
<span class="line">  "name":"testuser",</span>
<span class="line">  "display_name":"Test User",</span>
<span class="line">  "email":"test@example.com"</span>
<span class="line">}'</span> localhost:50051 iam.v1.IAM/CreateUser</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔍-故障排除" tabindex="-1"><a class="header-anchor" href="#🔍-故障排除">#</a> 🔍 故障排除</h2>
<h3 id="常见问题" tabindex="-1"><a class="header-anchor" href="#常见问题">#</a> 常见问题</h3>
<h4 id="_1-数据库连接失败" tabindex="-1"><a class="header-anchor" href="#_1-数据库连接失败">#</a> 1. 数据库连接失败</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查PostgreSQL是否正常运行</span></span>
<span class="line"><span class="token function">docker-compose</span> logs postgres</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查数据库连接配置</span></span>
<span class="line"><span class="token function">cat</span> vgo-iam/config/config.yaml</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_2-端口冲突" tabindex="-1"><a class="header-anchor" href="#_2-端口冲突">#</a> 2. 端口冲突</h4>
<p>如果遇到端口冲突，可以修改<code v-pre>docker-compose.yml</code>中的端口映射：</p>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">vgo-iam</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"8081:8080"</span>  <span class="token comment"># 修改调试界面端口</span></span>
<span class="line">      <span class="token punctuation">-</span> <span class="token string">"50052:50051"</span> <span class="token comment"># 修改gRPC端口</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="_3-权限问题" tabindex="-1"><a class="header-anchor" href="#_3-权限问题">#</a> 3. 权限问题</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 确保有足够的权限</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">chown</span> <span class="token parameter variable">-R</span> <span class="token environment constant">$USER</span><span class="token builtin class-name">:</span><span class="token environment constant">$USER</span> <span class="token builtin class-name">.</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Docker权限</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">usermod</span> <span class="token parameter variable">-aG</span> <span class="token function">docker</span> <span class="token environment constant">$USER</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="查看日志" tabindex="-1"><a class="header-anchor" href="#查看日志">#</a> 查看日志</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 查看所有服务日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看特定服务日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs vgo-iam</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 实时查看日志</span></span>
<span class="line"><span class="token function">docker-compose</span> logs <span class="token parameter variable">-f</span> vgo-iam</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-下一步" tabindex="-1"><a class="header-anchor" href="#📚-下一步">#</a> 📚 下一步</h2>
<p>恭喜！您已经成功部署了VGO微服务。接下来您可以：</p>
<ol>
<li><RouteLink to="/guide/configuration.html">配置详解</RouteLink> - 了解详细的配置选项</li>
<li><RouteLink to="/guide/basic-usage.html">基本使用</RouteLink> - 学习如何使用各项功能</li>
<li><a href="/api/" target="_blank" rel="noopener noreferrer">API文档</a> - 查看完整的API接口文档</li>
<li><a href="/deployment/" target="_blank" rel="noopener noreferrer">部署指南</a> - 了解生产环境部署</li>
</ol>
<div class="hint-container tip">
<p class="hint-container-title">提示</p>
<p>如果您在部署过程中遇到问题，请查看<RouteLink to="/guide/troubleshooting.html">故障排除指南</RouteLink>或在GitHub上提交Issue。</p>
</div>
</div></template>


