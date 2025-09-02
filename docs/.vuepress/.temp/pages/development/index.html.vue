<template><div><h1 id="开发指南" tabindex="-1"><a class="header-anchor" href="#开发指南">#</a> 开发指南</h1>
<p>欢迎来到VGO微服务开发指南！本指南将帮助您了解如何参与VGO微服务的开发，包括环境搭建、代码规范、测试流程、调试技巧等内容。</p>
<h2 id="📋-开发概览" tabindex="-1"><a class="header-anchor" href="#📋-开发概览">#</a> 📋 开发概览</h2>
<h3 id="技术栈" tabindex="-1"><a class="header-anchor" href="#技术栈">#</a> 技术栈</h3>
<table>
<thead>
<tr>
<th>组件</th>
<th>技术</th>
<th>版本</th>
<th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>后端语言</td>
<td>Go</td>
<td>1.21+</td>
<td>主要开发语言</td>
</tr>
<tr>
<td>RPC框架</td>
<td>gRPC</td>
<td>v1.58+</td>
<td>服务间通信</td>
</tr>
<tr>
<td>数据库</td>
<td>PostgreSQL</td>
<td>15+</td>
<td>主数据库</td>
</tr>
<tr>
<td>缓存</td>
<td>Redis</td>
<td>7+</td>
<td>缓存和会话存储</td>
</tr>
<tr>
<td>消息队列</td>
<td>NATS</td>
<td>2.9+</td>
<td>异步消息处理</td>
</tr>
<tr>
<td>监控</td>
<td>Prometheus</td>
<td>2.45+</td>
<td>指标收集</td>
</tr>
<tr>
<td>日志</td>
<td>Zap</td>
<td>1.25+</td>
<td>结构化日志</td>
</tr>
<tr>
<td>测试</td>
<td>Testify</td>
<td>1.8+</td>
<td>单元测试框架</td>
</tr>
<tr>
<td>构建工具</td>
<td>Make</td>
<td>-</td>
<td>构建自动化</td>
</tr>
<tr>
<td>容器化</td>
<td>Docker</td>
<td>24+</td>
<td>容器化部署</td>
</tr>
</tbody>
</table>
<h3 id="项目架构" tabindex="-1"><a class="header-anchor" href="#项目架构">#</a> 项目架构</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"客户端层"</span></span>
<span class="line">        A<span class="token text string">[gRPC客户端]</span></span>
<span class="line">        B<span class="token text string">[HTTP客户端]</span></span>
<span class="line">        C<span class="token text string">[SDK]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"网关层"</span></span>
<span class="line">        D<span class="token text string">[API网关]</span></span>
<span class="line">        E<span class="token text string">[负载均衡器]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"服务层"</span></span>
<span class="line">        F<span class="token text string">[用户管理服务]</span></span>
<span class="line">        G<span class="token text string">[策略管理服务]</span></span>
<span class="line">        H<span class="token text string">[权限验证服务]</span></span>
<span class="line">        I<span class="token text string">[访问密钥服务]</span></span>
<span class="line">        J<span class="token text string">[应用管理服务]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"数据层"</span></span>
<span class="line">        K<span class="token text string">[PostgreSQL]</span></span>
<span class="line">        L<span class="token text string">[Redis]</span></span>
<span class="line">        M<span class="token text string">[NATS]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"监控层"</span></span>
<span class="line">        N<span class="token text string">[Prometheus]</span></span>
<span class="line">        O<span class="token text string">[Grafana]</span></span>
<span class="line">        P<span class="token text string">[Jaeger]</span></span>
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
<span class="line">    E <span class="token arrow operator">--></span> J</span>
<span class="line">    F <span class="token arrow operator">--></span> K</span>
<span class="line">    G <span class="token arrow operator">--></span> K</span>
<span class="line">    H <span class="token arrow operator">--></span> L</span>
<span class="line">    I <span class="token arrow operator">--></span> K</span>
<span class="line">    J <span class="token arrow operator">--></span> K</span>
<span class="line">    F <span class="token arrow operator">--></span> M</span>
<span class="line">    G <span class="token arrow operator">--></span> M</span>
<span class="line">    H <span class="token arrow operator">--></span> M</span>
<span class="line">    F <span class="token arrow operator">--></span> N</span>
<span class="line">    G <span class="token arrow operator">--></span> N</span>
<span class="line">    H <span class="token arrow operator">--></span> N</span>
<span class="line">    N <span class="token arrow operator">--></span> O</span>
<span class="line">    F <span class="token arrow operator">--></span> P</span>
<span class="line">    G <span class="token arrow operator">--></span> P</span>
<span class="line">    H <span class="token arrow operator">--></span> P</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="目录结构" tabindex="-1"><a class="header-anchor" href="#目录结构">#</a> 目录结构</h3>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">vgo_micro_service/</span>
<span class="line">├── api/                    # API定义</span>
<span class="line">│   ├── proto/             # Protocol Buffers定义</span>
<span class="line">│   └── openapi/           # OpenAPI规范</span>
<span class="line">├── cmd/                   # 应用程序入口</span>
<span class="line">│   ├── server/           # 服务器启动代码</span>
<span class="line">│   └── client/           # 客户端工具</span>
<span class="line">├── internal/              # 内部代码</span>
<span class="line">│   ├── config/           # 配置管理</span>
<span class="line">│   ├── server/           # 服务器实现</span>
<span class="line">│   ├── service/          # 业务逻辑</span>
<span class="line">│   ├── repository/       # 数据访问层</span>
<span class="line">│   ├── middleware/       # 中间件</span>
<span class="line">│   ├── auth/             # 认证授权</span>
<span class="line">│   ├── crypto/           # 加密解密</span>
<span class="line">│   └── utils/            # 工具函数</span>
<span class="line">├── pkg/                   # 公共库</span>
<span class="line">│   ├── client/           # 客户端SDK</span>
<span class="line">│   ├── errors/           # 错误定义</span>
<span class="line">│   └── logger/           # 日志工具</span>
<span class="line">├── scripts/               # 脚本文件</span>
<span class="line">│   ├── build.sh          # 构建脚本</span>
<span class="line">│   ├── test.sh           # 测试脚本</span>
<span class="line">│   └── deploy.sh         # 部署脚本</span>
<span class="line">├── configs/               # 配置文件</span>
<span class="line">├── deployments/           # 部署配置</span>
<span class="line">├── docs/                  # 文档</span>
<span class="line">├── tests/                 # 测试文件</span>
<span class="line">├── tools/                 # 开发工具</span>
<span class="line">├── go.mod                 # Go模块定义</span>
<span class="line">├── go.sum                 # Go模块校验</span>
<span class="line">├── Makefile              # 构建配置</span>
<span class="line">├── Dockerfile            # Docker镜像</span>
<span class="line">└── docker-compose.yml    # Docker Compose配置</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚀-快速开始" tabindex="-1"><a class="header-anchor" href="#🚀-快速开始">#</a> 🚀 快速开始</h2>
<h3 id="_1-环境准备" tabindex="-1"><a class="header-anchor" href="#_1-环境准备">#</a> 1. 环境准备</h3>
<h4 id="必需软件" tabindex="-1"><a class="header-anchor" href="#必需软件">#</a> 必需软件</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装Go（版本1.21+）</span></span>
<span class="line"><span class="token function">wget</span> https://go.dev/dl/go1.21.5.linux-amd64.tar.gz</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">tar</span> <span class="token parameter variable">-C</span> /usr/local <span class="token parameter variable">-xzf</span> go1.21.5.linux-amd64.tar.gz</span>
<span class="line"><span class="token builtin class-name">export</span> <span class="token assign-left variable"><span class="token environment constant">PATH</span></span><span class="token operator">=</span><span class="token environment constant">$PATH</span>:/usr/local/go/bin</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装Protocol Buffers编译器</span></span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt-get</span> update</span>
<span class="line"><span class="token function">sudo</span> <span class="token function">apt-get</span> <span class="token function">install</span> <span class="token parameter variable">-y</span> protobuf-compiler</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装Go插件</span></span>
<span class="line">go <span class="token function">install</span> google.golang.org/protobuf/cmd/protoc-gen-go@latest</span>
<span class="line">go <span class="token function">install</span> google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装开发工具</span></span>
<span class="line">go <span class="token function">install</span> github.com/golangci/golangci-lint/cmd/golangci-lint@latest</span>
<span class="line">go <span class="token function">install</span> github.com/swaggo/swag/cmd/swag@latest</span>
<span class="line">go <span class="token function">install</span> github.com/air-verse/air@latest</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="数据库准备" tabindex="-1"><a class="header-anchor" href="#数据库准备">#</a> 数据库准备</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启动PostgreSQL和Redis</span></span>
<span class="line"><span class="token function">docker-compose</span> up <span class="token parameter variable">-d</span> postgres redis</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待服务启动</span></span>
<span class="line"><span class="token function">sleep</span> <span class="token number">10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行数据库迁移</span></span>
<span class="line"><span class="token function">make</span> migrate-up</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-克隆和构建" tabindex="-1"><a class="header-anchor" href="#_2-克隆和构建">#</a> 2. 克隆和构建</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 克隆项目</span></span>
<span class="line"><span class="token function">git</span> clone https://github.com/your-org/vgo_micro_service.git</span>
<span class="line"><span class="token builtin class-name">cd</span> vgo_micro_service</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 安装依赖</span></span>
<span class="line">go mod download</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成代码</span></span>
<span class="line"><span class="token function">make</span> generate</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 构建项目</span></span>
<span class="line"><span class="token function">make</span> build</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行测试</span></span>
<span class="line"><span class="token function">make</span> <span class="token builtin class-name">test</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-启动开发服务器" tabindex="-1"><a class="header-anchor" href="#_3-启动开发服务器">#</a> 3. 启动开发服务器</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 启动开发服务器（热重载）</span></span>
<span class="line"><span class="token function">make</span> dev</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 或者直接运行</span></span>
<span class="line">air</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-验证安装" tabindex="-1"><a class="header-anchor" href="#_4-验证安装">#</a> 4. 验证安装</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 检查服务健康状态</span></span>
<span class="line"><span class="token function">curl</span> http://localhost:8081/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试gRPC接口</span></span>
<span class="line">grpcurl <span class="token parameter variable">-plaintext</span> localhost:50051 grpc.health.v1.Health/Check</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🛠️-开发工作流" tabindex="-1"><a class="header-anchor" href="#🛠️-开发工作流">#</a> 🛠️ 开发工作流</h2>
<h3 id="_1-分支管理" tabindex="-1"><a class="header-anchor" href="#_1-分支管理">#</a> 1. 分支管理</h3>
<p>我们使用Git Flow工作流：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 创建功能分支</span></span>
<span class="line"><span class="token function">git</span> checkout <span class="token parameter variable">-b</span> feature/user-management</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 开发完成后提交</span></span>
<span class="line"><span class="token function">git</span> <span class="token function">add</span> <span class="token builtin class-name">.</span></span>
<span class="line"><span class="token function">git</span> commit <span class="token parameter variable">-m</span> <span class="token string">"feat: add user management API"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 推送到远程</span></span>
<span class="line"><span class="token function">git</span> push origin feature/user-management</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 创建Pull Request</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-代码提交规范" tabindex="-1"><a class="header-anchor" href="#_2-代码提交规范">#</a> 2. 代码提交规范</h3>
<p>我们使用<a href="https://www.conventionalcommits.org/" target="_blank" rel="noopener noreferrer">Conventional Commits</a>规范：</p>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">&lt;type>[optional scope]: &lt;description></span>
<span class="line"></span>
<span class="line">[optional body]</span>
<span class="line"></span>
<span class="line">[optional footer(s)]</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p><strong>类型说明：</strong></p>
<ul>
<li><code v-pre>feat</code>: 新功能</li>
<li><code v-pre>fix</code>: 修复bug</li>
<li><code v-pre>docs</code>: 文档更新</li>
<li><code v-pre>style</code>: 代码格式化</li>
<li><code v-pre>refactor</code>: 代码重构</li>
<li><code v-pre>test</code>: 测试相关</li>
<li><code v-pre>chore</code>: 构建过程或辅助工具的变动</li>
</ul>
<p><strong>示例：</strong></p>
<div class="language-text line-numbers-mode" data-highlighter="prismjs" data-ext="text"><pre v-pre><code class="language-text"><span class="line">feat(auth): add JWT token validation</span>
<span class="line"></span>
<span class="line">Implement JWT token validation middleware with:</span>
<span class="line">- Token signature verification</span>
<span class="line">- Expiration time checking</span>
<span class="line">- User permission extraction</span>
<span class="line"></span>
<span class="line">Closes #123</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-代码审查" tabindex="-1"><a class="header-anchor" href="#_3-代码审查">#</a> 3. 代码审查</h3>
<p>每个Pull Request都需要经过代码审查：</p>
<ul>
<li>[ ] 代码符合项目规范</li>
<li>[ ] 包含适当的测试</li>
<li>[ ] 文档已更新</li>
<li>[ ] 通过所有CI检查</li>
<li>[ ] 至少一个团队成员审查通过</li>
</ul>
<h2 id="📝-代码规范" tabindex="-1"><a class="header-anchor" href="#📝-代码规范">#</a> 📝 代码规范</h2>
<h3 id="_1-go代码规范" tabindex="-1"><a class="header-anchor" href="#_1-go代码规范">#</a> 1. Go代码规范</h3>
<p>我们遵循<a href="https://github.com/golang/go/wiki/CodeReviewComments" target="_blank" rel="noopener noreferrer">Go Code Review Comments</a>和<a href="https://golang.org/doc/effective_go.html" target="_blank" rel="noopener noreferrer">Effective Go</a>：</p>
<h4 id="命名规范" tabindex="-1"><a class="header-anchor" href="#命名规范">#</a> 命名规范</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// ✅ 好的命名</span></span>
<span class="line"><span class="token keyword">type</span> UserService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    repo UserRepository</span>
<span class="line">    logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 实现逻辑</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// ❌ 不好的命名</span></span>
<span class="line"><span class="token keyword">type</span> usrSvc <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    r UserRepository</span>
<span class="line">    l <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>usrSvc<span class="token punctuation">)</span> <span class="token function">create</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 实现逻辑</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="错误处理" tabindex="-1"><a class="header-anchor" href="#错误处理">#</a> 错误处理</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// ✅ 好的错误处理</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">GetUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">GetByID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> errors<span class="token punctuation">.</span><span class="token function">Is</span><span class="token punctuation">(</span>err<span class="token punctuation">,</span> repository<span class="token punctuation">.</span>ErrNotFound<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>NotFound<span class="token punctuation">,</span> <span class="token string">"user not found: %s"</span><span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> status<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span>codes<span class="token punctuation">.</span>Internal<span class="token punctuation">,</span> <span class="token string">"failed to get user: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> user<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// ❌ 不好的错误处理</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">GetUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">GetByID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err <span class="token comment">// 直接返回底层错误</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> user<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="上下文使用" tabindex="-1"><a class="header-anchor" href="#上下文使用">#</a> 上下文使用</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// ✅ 正确使用context</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 检查上下文是否已取消</span></span>
<span class="line">    <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ctx<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> ctx<span class="token punctuation">.</span><span class="token function">Err</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 传递上下文到下层调用</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">Create</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> user<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-项目结构规范" tabindex="-1"><a class="header-anchor" href="#_2-项目结构规范">#</a> 2. 项目结构规范</h3>
<h4 id="包组织" tabindex="-1"><a class="header-anchor" href="#包组织">#</a> 包组织</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/service/user.go</span></span>
<span class="line"><span class="token keyword">package</span> service</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/repository"</span></span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/pkg/errors"</span></span>
<span class="line">    pb <span class="token string">"github.com/your-org/vgo/api/proto/user/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> UserService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    repo repository<span class="token punctuation">.</span>UserRepository</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewUserService</span><span class="token punctuation">(</span>repo repository<span class="token punctuation">.</span>UserRepository<span class="token punctuation">)</span> <span class="token operator">*</span>UserService <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>UserService<span class="token punctuation">{</span>repo<span class="token punctuation">:</span> repo<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="接口定义" tabindex="-1"><a class="header-anchor" href="#接口定义">#</a> 接口定义</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/repository/user.go</span></span>
<span class="line"><span class="token keyword">package</span> repository</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/model"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// UserRepository 用户数据访问接口</span></span>
<span class="line"><span class="token keyword">type</span> UserRepository <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">Create</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>model<span class="token punctuation">.</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">GetByID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>model<span class="token punctuation">.</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">GetByEmail</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> email <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>model<span class="token punctuation">.</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">Update</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>model<span class="token punctuation">.</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">Delete</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">List</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> opts ListOptions<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>model<span class="token punctuation">.</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-测试规范" tabindex="-1"><a class="header-anchor" href="#_3-测试规范">#</a> 3. 测试规范</h3>
<h4 id="单元测试" tabindex="-1"><a class="header-anchor" href="#单元测试">#</a> 单元测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// internal/service/user_test.go</span></span>
<span class="line"><span class="token keyword">package</span> service</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/assert"</span></span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/mock"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/model"</span></span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/repository/mocks"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CreateUser</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    tests <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">        name    <span class="token builtin">string</span></span>
<span class="line">        setup   <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token operator">*</span>mocks<span class="token punctuation">.</span>UserRepository<span class="token punctuation">)</span></span>
<span class="line">        input   <span class="token operator">*</span>model<span class="token punctuation">.</span>User</span>
<span class="line">        want    <span class="token operator">*</span>model<span class="token punctuation">.</span>User</span>
<span class="line">        wantErr <span class="token builtin">bool</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"successful creation"</span><span class="token punctuation">,</span></span>
<span class="line">            setup<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>repo <span class="token operator">*</span>mocks<span class="token punctuation">.</span>UserRepository<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                repo<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> mock<span class="token punctuation">.</span>Anything<span class="token punctuation">,</span> mock<span class="token punctuation">.</span><span class="token function">AnythingOfType</span><span class="token punctuation">(</span><span class="token string">"*model.User"</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            input<span class="token punctuation">:</span> <span class="token operator">&amp;</span>model<span class="token punctuation">.</span>User<span class="token punctuation">{</span></span>
<span class="line">                Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">                Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            want<span class="token punctuation">:</span> <span class="token operator">&amp;</span>model<span class="token punctuation">.</span>User<span class="token punctuation">{</span></span>
<span class="line">                Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">                Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            wantErr<span class="token punctuation">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"repository error"</span><span class="token punctuation">,</span></span>
<span class="line">            setup<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>repo <span class="token operator">*</span>mocks<span class="token punctuation">.</span>UserRepository<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                repo<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> mock<span class="token punctuation">.</span>Anything<span class="token punctuation">,</span> mock<span class="token punctuation">.</span><span class="token function">AnythingOfType</span><span class="token punctuation">(</span><span class="token string">"*model.User"</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span>errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"db error"</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            input<span class="token punctuation">:</span> <span class="token operator">&amp;</span>model<span class="token punctuation">.</span>User<span class="token punctuation">{</span></span>
<span class="line">                Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">                Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            want<span class="token punctuation">:</span>    <span class="token boolean">nil</span><span class="token punctuation">,</span></span>
<span class="line">            wantErr<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> tt <span class="token operator">:=</span> <span class="token keyword">range</span> tests <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>tt<span class="token punctuation">.</span>name<span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            repo <span class="token operator">:=</span> <span class="token operator">&amp;</span>mocks<span class="token punctuation">.</span>UserRepository<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">            tt<span class="token punctuation">.</span><span class="token function">setup</span><span class="token punctuation">(</span>repo<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            service <span class="token operator">:=</span> <span class="token function">NewUserService</span><span class="token punctuation">(</span>repo<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            got<span class="token punctuation">,</span> err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> tt<span class="token punctuation">.</span>input<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">if</span> tt<span class="token punctuation">.</span>wantErr <span class="token punctuation">{</span></span>
<span class="line">                assert<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">                assert<span class="token punctuation">.</span><span class="token function">Nil</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> got<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">                assert<span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">                assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> tt<span class="token punctuation">.</span>want<span class="token punctuation">.</span>Email<span class="token punctuation">,</span> got<span class="token punctuation">.</span>Email<span class="token punctuation">)</span></span>
<span class="line">                assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> tt<span class="token punctuation">.</span>want<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> got<span class="token punctuation">.</span>Username<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            repo<span class="token punctuation">.</span><span class="token function">AssertExpectations</span><span class="token punctuation">(</span>t<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="集成测试" tabindex="-1"><a class="header-anchor" href="#集成测试">#</a> 集成测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// tests/integration/user_test.go</span></span>
<span class="line"><span class="token keyword">package</span> integration</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/assert"</span></span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/suite"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/config"</span></span>
<span class="line">    <span class="token string">"github.com/your-org/vgo/internal/server"</span></span>
<span class="line">    pb <span class="token string">"github.com/your-org/vgo/api/proto/user/v1"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> UserIntegrationTestSuite <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>Suite</span>
<span class="line">    server <span class="token operator">*</span>server<span class="token punctuation">.</span>Server</span>
<span class="line">    client pb<span class="token punctuation">.</span>UserServiceClient</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserIntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">SetupSuite</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    cfg <span class="token operator">:=</span> config<span class="token punctuation">.</span><span class="token function">LoadTestConfig</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span>server <span class="token operator">=</span> server<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span>cfg<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">go</span> suite<span class="token punctuation">.</span>server<span class="token punctuation">.</span><span class="token function">Start</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    conn<span class="token punctuation">,</span> err <span class="token operator">:=</span> grpc<span class="token punctuation">.</span><span class="token function">Dial</span><span class="token punctuation">(</span><span class="token string">"localhost:50051"</span><span class="token punctuation">,</span> grpc<span class="token punctuation">.</span><span class="token function">WithInsecure</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>client <span class="token operator">=</span> pb<span class="token punctuation">.</span><span class="token function">NewUserServiceClient</span><span class="token punctuation">(</span>conn<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserIntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">TearDownSuite</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>server<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserIntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">TestCreateUser</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    req <span class="token operator">:=</span> <span class="token operator">&amp;</span>pb<span class="token punctuation">.</span>CreateUserRequest<span class="token punctuation">{</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">        Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">        Password<span class="token punctuation">:</span> <span class="token string">"password123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NotEmpty</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> resp<span class="token punctuation">.</span>User<span class="token punctuation">.</span>Id<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Email<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>User<span class="token punctuation">.</span>Email<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>User<span class="token punctuation">.</span>Username<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserIntegrationTestSuite</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> <span class="token function">new</span><span class="token punctuation">(</span>UserIntegrationTestSuite<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-开发工具" tabindex="-1"><a class="header-anchor" href="#🔧-开发工具">#</a> 🔧 开发工具</h2>
<h3 id="_1-makefile命令" tabindex="-1"><a class="header-anchor" href="#_1-makefile命令">#</a> 1. Makefile命令</h3>
<div class="language-makefile line-numbers-mode" data-highlighter="prismjs" data-ext="makefile"><pre v-pre><code class="language-makefile"><span class="line"><span class="token comment"># 查看所有可用命令</span></span>
<span class="line">make help</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 开发相关</span></span>
<span class="line">make dev          <span class="token comment"># 启动开发服务器（热重载）</span></span>
<span class="line">make build        <span class="token comment"># 构建项目</span></span>
<span class="line">make clean        <span class="token comment"># 清理构建文件</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 代码生成</span></span>
<span class="line">make generate     <span class="token comment"># 生成所有代码</span></span>
<span class="line">make proto        <span class="token comment"># 生成Protocol Buffers代码</span></span>
<span class="line">make mock         <span class="token comment"># 生成Mock代码</span></span>
<span class="line">make swagger      <span class="token comment"># 生成Swagger文档</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试相关</span></span>
<span class="line">make test         <span class="token comment"># 运行所有测试</span></span>
<span class="line">make test-unit    <span class="token comment"># 运行单元测试</span></span>
<span class="line">make test-integration <span class="token comment"># 运行集成测试</span></span>
<span class="line">make test-coverage    <span class="token comment"># 生成测试覆盖率报告</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 代码质量</span></span>
<span class="line">make lint         <span class="token comment"># 运行代码检查</span></span>
<span class="line">make fmt          <span class="token comment"># 格式化代码</span></span>
<span class="line">make vet          <span class="token comment"># 运行go vet</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 数据库相关</span></span>
<span class="line">make migrate-up   <span class="token comment"># 运行数据库迁移</span></span>
<span class="line">make migrate-down <span class="token comment"># 回滚数据库迁移</span></span>
<span class="line">make migrate-create <span class="token comment"># 创建新的迁移文件</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># Docker相关</span></span>
<span class="line">make docker-build <span class="token comment"># 构建Docker镜像</span></span>
<span class="line">make docker-run   <span class="token comment"># 运行Docker容器</span></span>
<span class="line">make docker-push  <span class="token comment"># 推送Docker镜像</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-开发环境配置" tabindex="-1"><a class="header-anchor" href="#_2-开发环境配置">#</a> 2. 开发环境配置</h3>
<h4 id="vs-code配置" tabindex="-1"><a class="header-anchor" href="#vs-code配置">#</a> VS Code配置</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token comment">// .vscode/settings.json</span></span>
<span class="line"><span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"go.useLanguageServer"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.lintTool"</span><span class="token operator">:</span> <span class="token string">"golangci-lint"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.lintFlags"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"--fast"</span></span>
<span class="line">    <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.testFlags"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token string">"-v"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"-race"</span></span>
<span class="line">    <span class="token punctuation">]</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.testTimeout"</span><span class="token operator">:</span> <span class="token string">"30s"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.coverOnSave"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"go.coverOnSingleTest"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"editor.formatOnSave"</span><span class="token operator">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"editor.codeActionsOnSave"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token property">"source.organizeImports"</span><span class="token operator">:</span> <span class="token boolean">true</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token comment">// .vscode/launch.json</span></span>
<span class="line"><span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"version"</span><span class="token operator">:</span> <span class="token string">"0.2.0"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"configurations"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"Launch Server"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"go"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"request"</span><span class="token operator">:</span> <span class="token string">"launch"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"auto"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"program"</span><span class="token operator">:</span> <span class="token string">"${workspaceFolder}/cmd/server"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"env"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token property">"VGO_ENV"</span><span class="token operator">:</span> <span class="token string">"development"</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token property">"VGO_CONFIG_PATH"</span><span class="token operator">:</span> <span class="token string">"${workspaceFolder}/configs/development.yaml"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"args"</span><span class="token operator">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"Debug Test"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"go"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"request"</span><span class="token operator">:</span> <span class="token string">"launch"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"test"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"program"</span><span class="token operator">:</span> <span class="token string">"${workspaceFolder}"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"env"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token property">"VGO_ENV"</span><span class="token operator">:</span> <span class="token string">"test"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"args"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token string">"-test.v"</span></span>
<span class="line">            <span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="golangci-lint配置" tabindex="-1"><a class="header-anchor" href="#golangci-lint配置">#</a> golangci-lint配置</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># .golangci.yml</span></span>
<span class="line"><span class="token key atrule">run</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">timeout</span><span class="token punctuation">:</span> 5m</span>
<span class="line">  <span class="token key atrule">modules-download-mode</span><span class="token punctuation">:</span> readonly</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">linters-settings</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">gocyclo</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">min-complexity</span><span class="token punctuation">:</span> <span class="token number">15</span></span>
<span class="line">  <span class="token key atrule">goconst</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">min-len</span><span class="token punctuation">:</span> <span class="token number">2</span></span>
<span class="line">    <span class="token key atrule">min-occurrences</span><span class="token punctuation">:</span> <span class="token number">2</span></span>
<span class="line">  <span class="token key atrule">gocritic</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">enabled-tags</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token punctuation">-</span> diagnostic</span>
<span class="line">      <span class="token punctuation">-</span> experimental</span>
<span class="line">      <span class="token punctuation">-</span> opinionated</span>
<span class="line">      <span class="token punctuation">-</span> performance</span>
<span class="line">      <span class="token punctuation">-</span> style</span>
<span class="line">  <span class="token key atrule">gofumpt</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">extra-rules</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">gomnd</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">settings</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">mnd</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">checks</span><span class="token punctuation">:</span> argument<span class="token punctuation">,</span>case<span class="token punctuation">,</span>condition<span class="token punctuation">,</span>operation<span class="token punctuation">,</span>return<span class="token punctuation">,</span>assign</span>
<span class="line">  <span class="token key atrule">govet</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">check-shadowing</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">lll</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">line-length</span><span class="token punctuation">:</span> <span class="token number">120</span></span>
<span class="line">  <span class="token key atrule">misspell</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">locale</span><span class="token punctuation">:</span> US</span>
<span class="line">  <span class="token key atrule">nolintlint</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">allow-leading-space</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">    <span class="token key atrule">allow-unused</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">    <span class="token key atrule">require-explanation</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line">    <span class="token key atrule">require-specific</span><span class="token punctuation">:</span> <span class="token boolean important">false</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">linters</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">disable-all</span><span class="token punctuation">:</span> <span class="token boolean important">true</span></span>
<span class="line">  <span class="token key atrule">enable</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> bodyclose</span>
<span class="line">    <span class="token punctuation">-</span> deadcode</span>
<span class="line">    <span class="token punctuation">-</span> depguard</span>
<span class="line">    <span class="token punctuation">-</span> dogsled</span>
<span class="line">    <span class="token punctuation">-</span> dupl</span>
<span class="line">    <span class="token punctuation">-</span> errcheck</span>
<span class="line">    <span class="token punctuation">-</span> exportloopref</span>
<span class="line">    <span class="token punctuation">-</span> exhaustive</span>
<span class="line">    <span class="token punctuation">-</span> gochecknoinits</span>
<span class="line">    <span class="token punctuation">-</span> goconst</span>
<span class="line">    <span class="token punctuation">-</span> gocritic</span>
<span class="line">    <span class="token punctuation">-</span> gocyclo</span>
<span class="line">    <span class="token punctuation">-</span> gofmt</span>
<span class="line">    <span class="token punctuation">-</span> gofumpt</span>
<span class="line">    <span class="token punctuation">-</span> gomnd</span>
<span class="line">    <span class="token punctuation">-</span> goprintffuncname</span>
<span class="line">    <span class="token punctuation">-</span> gosec</span>
<span class="line">    <span class="token punctuation">-</span> gosimple</span>
<span class="line">    <span class="token punctuation">-</span> govet</span>
<span class="line">    <span class="token punctuation">-</span> ineffassign</span>
<span class="line">    <span class="token punctuation">-</span> lll</span>
<span class="line">    <span class="token punctuation">-</span> misspell</span>
<span class="line">    <span class="token punctuation">-</span> nakedret</span>
<span class="line">    <span class="token punctuation">-</span> noctx</span>
<span class="line">    <span class="token punctuation">-</span> nolintlint</span>
<span class="line">    <span class="token punctuation">-</span> rowserrcheck</span>
<span class="line">    <span class="token punctuation">-</span> staticcheck</span>
<span class="line">    <span class="token punctuation">-</span> structcheck</span>
<span class="line">    <span class="token punctuation">-</span> stylecheck</span>
<span class="line">    <span class="token punctuation">-</span> typecheck</span>
<span class="line">    <span class="token punctuation">-</span> unconvert</span>
<span class="line">    <span class="token punctuation">-</span> unparam</span>
<span class="line">    <span class="token punctuation">-</span> unused</span>
<span class="line">    <span class="token punctuation">-</span> varcheck</span>
<span class="line">    <span class="token punctuation">-</span> whitespace</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">issues</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">exclude-rules</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> _test\.go</span>
<span class="line">      <span class="token key atrule">linters</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> gomnd</span>
<span class="line">        <span class="token punctuation">-</span> goconst</span>
<span class="line">        <span class="token punctuation">-</span> dupl</span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">path</span><span class="token punctuation">:</span> internal/mocks/</span>
<span class="line">      <span class="token key atrule">linters</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token punctuation">-</span> gomnd</span>
<span class="line">        <span class="token punctuation">-</span> goconst</span>
<span class="line">        <span class="token punctuation">-</span> dupl</span>
<span class="line">        <span class="token punctuation">-</span> unused</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
<li><RouteLink to="/guide/quick-start.html">快速开始</RouteLink></li>
<li><RouteLink to="/development/architecture.html">架构设计</RouteLink></li>
<li><RouteLink to="/development/testing.html">测试指南</RouteLink></li>
<li><RouteLink to="/development/debugging.html">调试指南</RouteLink></li>
<li><RouteLink to="/development/performance.html">性能优化</RouteLink></li>
<li><RouteLink to="/development/troubleshooting.html">故障排除</RouteLink></li>
</ul>
</div></template>


