<template><div><h1 id="调试指南" tabindex="-1"><a class="header-anchor" href="#调试指南">#</a> 调试指南</h1>
<p>本文档详细介绍了VGO微服务的调试技巧、工具使用和问题排查方法。</p>
<h2 id="🔍-调试策略" tabindex="-1"><a class="header-anchor" href="#🔍-调试策略">#</a> 🔍 调试策略</h2>
<h3 id="调试层次" tabindex="-1"><a class="header-anchor" href="#调试层次">#</a> 调试层次</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"调试层次"</span></span>
<span class="line">        A<span class="token text string">["应用层调试&lt;br/>业务逻辑、API接口"]</span></span>
<span class="line">        B<span class="token text string">["服务层调试&lt;br/>服务间通信、数据流"]</span></span>
<span class="line">        C<span class="token text string">["基础设施层调试&lt;br/>数据库、缓存、消息队列"]</span></span>
<span class="line">        D<span class="token text string">["系统层调试&lt;br/>网络、存储、性能"]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    A <span class="token arrow operator">--></span> B</span>
<span class="line">    B <span class="token arrow operator">--></span> C</span>
<span class="line">    C <span class="token arrow operator">--></span> D</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">style</span> A <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#e1f5fe</span></span>
<span class="line">    <span class="token keyword">style</span> B <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#f3e5f5</span></span>
<span class="line">    <span class="token keyword">style</span> C <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#fff3e0</span></span>
<span class="line">    <span class="token keyword">style</span> D <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#f1f8e9</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="调试流程" tabindex="-1"><a class="header-anchor" href="#调试流程">#</a> 调试流程</h3>
<ol>
<li><strong>问题识别</strong> - 确定问题的症状和影响范围</li>
<li><strong>信息收集</strong> - 收集日志、指标和追踪信息</li>
<li><strong>假设形成</strong> - 基于信息分析可能的原因</li>
<li><strong>验证测试</strong> - 通过实验验证假设</li>
<li><strong>问题修复</strong> - 实施解决方案</li>
<li><strong>验证修复</strong> - 确认问题已解决</li>
</ol>
<h2 id="🛠️-调试工具" tabindex="-1"><a class="header-anchor" href="#🛠️-调试工具">#</a> 🛠️ 调试工具</h2>
<h3 id="_1-日志调试" tabindex="-1"><a class="header-anchor" href="#_1-日志调试">#</a> 1. 日志调试</h3>
<h4 id="结构化日志" tabindex="-1"><a class="header-anchor" href="#结构化日志">#</a> 结构化日志</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> logger</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"os"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"go.uber.org/zap"</span></span>
<span class="line">    <span class="token string">"go.uber.org/zap/zapcore"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 日志配置</span></span>
<span class="line"><span class="token keyword">type</span> Config <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Level      <span class="token builtin">string</span> <span class="token string">`json:"level"`</span></span>
<span class="line">    Format     <span class="token builtin">string</span> <span class="token string">`json:"format"`</span> <span class="token comment">// json, console</span></span>
<span class="line">    Output     <span class="token builtin">string</span> <span class="token string">`json:"output"`</span> <span class="token comment">// stdout, file</span></span>
<span class="line">    Filename   <span class="token builtin">string</span> <span class="token string">`json:"filename"`</span></span>
<span class="line">    MaxSize    <span class="token builtin">int</span>    <span class="token string">`json:"max_size"`</span>    <span class="token comment">// MB</span></span>
<span class="line">    MaxBackups <span class="token builtin">int</span>    <span class="token string">`json:"max_backups"`</span></span>
<span class="line">    MaxAge     <span class="token builtin">int</span>    <span class="token string">`json:"max_age"`</span>     <span class="token comment">// days</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 创建日志器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewLogger</span><span class="token punctuation">(</span>cfg Config<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 设置日志级别</span></span>
<span class="line">    level<span class="token punctuation">,</span> err <span class="token operator">:=</span> zapcore<span class="token punctuation">.</span><span class="token function">ParseLevel</span><span class="token punctuation">(</span>cfg<span class="token punctuation">.</span>Level<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 配置编码器</span></span>
<span class="line">    <span class="token keyword">var</span> encoderConfig zapcore<span class="token punctuation">.</span>EncoderConfig</span>
<span class="line">    <span class="token keyword">if</span> cfg<span class="token punctuation">.</span>Format <span class="token operator">==</span> <span class="token string">"json"</span> <span class="token punctuation">{</span></span>
<span class="line">        encoderConfig <span class="token operator">=</span> zap<span class="token punctuation">.</span><span class="token function">NewProductionEncoderConfig</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">        encoderConfig <span class="token operator">=</span> zap<span class="token punctuation">.</span><span class="token function">NewDevelopmentEncoderConfig</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        encoderConfig<span class="token punctuation">.</span>EncodeLevel <span class="token operator">=</span> zapcore<span class="token punctuation">.</span>CapitalColorLevelEncoder</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    encoderConfig<span class="token punctuation">.</span>TimeKey <span class="token operator">=</span> <span class="token string">"timestamp"</span></span>
<span class="line">    encoderConfig<span class="token punctuation">.</span>EncodeTime <span class="token operator">=</span> zapcore<span class="token punctuation">.</span>ISO8601TimeEncoder</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 配置输出</span></span>
<span class="line">    <span class="token keyword">var</span> writeSyncer zapcore<span class="token punctuation">.</span>WriteSyncer</span>
<span class="line">    <span class="token keyword">if</span> cfg<span class="token punctuation">.</span>Output <span class="token operator">==</span> <span class="token string">"file"</span> <span class="token punctuation">{</span></span>
<span class="line">        writeSyncer <span class="token operator">=</span> <span class="token function">getLogWriter</span><span class="token punctuation">(</span>cfg<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">        writeSyncer <span class="token operator">=</span> zapcore<span class="token punctuation">.</span><span class="token function">AddSync</span><span class="token punctuation">(</span>os<span class="token punctuation">.</span>Stdout<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建核心</span></span>
<span class="line">    <span class="token keyword">var</span> encoder zapcore<span class="token punctuation">.</span>Encoder</span>
<span class="line">    <span class="token keyword">if</span> cfg<span class="token punctuation">.</span>Format <span class="token operator">==</span> <span class="token string">"json"</span> <span class="token punctuation">{</span></span>
<span class="line">        encoder <span class="token operator">=</span> zapcore<span class="token punctuation">.</span><span class="token function">NewJSONEncoder</span><span class="token punctuation">(</span>encoderConfig<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">        encoder <span class="token operator">=</span> zapcore<span class="token punctuation">.</span><span class="token function">NewConsoleEncoder</span><span class="token punctuation">(</span>encoderConfig<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    core <span class="token operator">:=</span> zapcore<span class="token punctuation">.</span><span class="token function">NewCore</span><span class="token punctuation">(</span>encoder<span class="token punctuation">,</span> writeSyncer<span class="token punctuation">,</span> level<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建日志器</span></span>
<span class="line">    logger <span class="token operator">:=</span> zap<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span>core<span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">AddCaller</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">AddStacktrace</span><span class="token punctuation">(</span>zapcore<span class="token punctuation">.</span>ErrorLevel<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> logger<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 带上下文的日志</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">WithContext</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> requestID <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"request_id"</span><span class="token punctuation">)</span><span class="token punctuation">;</span> requestID <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger <span class="token operator">=</span> logger<span class="token punctuation">.</span><span class="token function">With</span><span class="token punctuation">(</span>zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"request_id"</span><span class="token punctuation">,</span> requestID<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> userID <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">)</span><span class="token punctuation">;</span> userID <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger <span class="token operator">=</span> logger<span class="token punctuation">.</span><span class="token function">With</span><span class="token punctuation">(</span>zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">,</span> userID<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> traceID <span class="token operator">:=</span> ctx<span class="token punctuation">.</span><span class="token function">Value</span><span class="token punctuation">(</span><span class="token string">"trace_id"</span><span class="token punctuation">)</span><span class="token punctuation">;</span> traceID <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger <span class="token operator">=</span> logger<span class="token punctuation">.</span><span class="token function">With</span><span class="token punctuation">(</span>zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"trace_id"</span><span class="token punctuation">,</span> traceID<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> logger</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 使用示例</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    logger <span class="token operator">:=</span> <span class="token function">WithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> s<span class="token punctuation">.</span>logger<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"Creating user"</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"username"</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"email"</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Email<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 验证输入</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span><span class="token function">validateCreateUserRequest</span><span class="token punctuation">(</span>req<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Invalid create user request"</span><span class="token punctuation">,</span></span>
<span class="line">            zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            zap<span class="token punctuation">.</span><span class="token function">Any</span><span class="token punctuation">(</span><span class="token string">"request"</span><span class="token punctuation">,</span> req<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建用户</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">Create</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">        Username<span class="token punctuation">:</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    req<span class="token punctuation">.</span>Email<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Failed to create user"</span><span class="token punctuation">,</span></span>
<span class="line">            zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"username"</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"User created successfully"</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"username"</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>Username<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> user<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="日志查询和分析" tabindex="-1"><a class="header-anchor" href="#日志查询和分析">#</a> 日志查询和分析</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/log-analysis.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看最近的错误日志</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Recent errors:"</span></span>
<span class="line">jq <span class="token string">'select(.level == "error")'</span> logs/app.log <span class="token operator">|</span> <span class="token function">tail</span> <span class="token parameter variable">-10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 按用户ID查询日志</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Logs for user <span class="token variable">$1</span>:"</span></span>
<span class="line">jq <span class="token string">"select(.user_id == <span class="token entity" title="\&quot;">\"</span><span class="token variable">$1</span><span class="token entity" title="\&quot;">\"</span>)"</span> logs/app.log</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看API响应时间统计</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"API response time statistics:"</span></span>
<span class="line">jq <span class="token string">'select(.msg == "HTTP request completed") | .duration'</span> logs/app.log <span class="token operator">|</span> <span class="token punctuation">\</span></span>
<span class="line">    <span class="token function">awk</span> <span class="token string">'{sum+=$1; count++} END {print "Avg:", sum/count, "Count:", count}'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 查看错误率</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Error rate in last hour:"</span></span>
<span class="line"><span class="token assign-left variable">total</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>jq 'select<span class="token punctuation">(</span>.timestamp <span class="token operator">></span> <span class="token punctuation">(</span>now - <span class="token number">3600</span><span class="token punctuation">)</span><span class="token variable">)</span></span>' logs/app.log <span class="token operator">|</span> <span class="token function">wc</span> -l<span class="token punctuation">)</span></span>
<span class="line"><span class="token assign-left variable">errors</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>jq 'select<span class="token punctuation">(</span>.timestamp <span class="token operator">></span> <span class="token punctuation">(</span>now - <span class="token number">3600</span><span class="token punctuation">)</span> and .level <span class="token operator">==</span> <span class="token string">"error"</span><span class="token variable">)</span></span>' logs/app.log <span class="token operator">|</span> <span class="token function">wc</span> -l<span class="token punctuation">)</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Errors: <span class="token variable">$errors</span> / <span class="token variable">$total</span> (<span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">echo</span> <span class="token string">"scale=2; <span class="token variable">$errors</span> * 100 / <span class="token variable">$total</span>"</span> <span class="token operator">|</span> <span class="token function">bc</span><span class="token variable">)</span></span>%)"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-性能分析" tabindex="-1"><a class="header-anchor" href="#_2-性能分析">#</a> 2. 性能分析</h3>
<h4 id="go-pprof集成" tabindex="-1"><a class="header-anchor" href="#go-pprof集成">#</a> Go pprof集成</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> debug</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"net/http"</span></span>
<span class="line">    <span class="token boolean">_</span> <span class="token string">"net/http/pprof"</span></span>
<span class="line">    <span class="token string">"runtime"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"go.uber.org/zap"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 性能分析服务</span></span>
<span class="line"><span class="token keyword">type</span> ProfilerService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger</span>
<span class="line">    server <span class="token operator">*</span>http<span class="token punctuation">.</span>Server</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewProfilerService</span><span class="token punctuation">(</span>addr <span class="token builtin">string</span><span class="token punctuation">,</span> logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token operator">*</span>ProfilerService <span class="token punctuation">{</span></span>
<span class="line">    mux <span class="token operator">:=</span> http<span class="token punctuation">.</span><span class="token function">NewServeMux</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 注册pprof处理器</span></span>
<span class="line">    mux<span class="token punctuation">.</span><span class="token function">HandleFunc</span><span class="token punctuation">(</span><span class="token string">"/debug/pprof/"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        http<span class="token punctuation">.</span>DefaultServeMux<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 自定义性能指标</span></span>
<span class="line">    mux<span class="token punctuation">.</span><span class="token function">HandleFunc</span><span class="token punctuation">(</span><span class="token string">"/debug/stats"</span><span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">var</span> m runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">        runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>m<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        stats <span class="token operator">:=</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">            <span class="token string">"goroutines"</span><span class="token punctuation">:</span>     runtime<span class="token punctuation">.</span><span class="token function">NumGoroutine</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"memory_alloc"</span><span class="token punctuation">:</span>   m<span class="token punctuation">.</span>Alloc<span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"memory_total"</span><span class="token punctuation">:</span>   m<span class="token punctuation">.</span>TotalAlloc<span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"memory_sys"</span><span class="token punctuation">:</span>     m<span class="token punctuation">.</span>Sys<span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"gc_runs"</span><span class="token punctuation">:</span>        m<span class="token punctuation">.</span>NumGC<span class="token punctuation">,</span></span>
<span class="line">            <span class="token string">"gc_pause_total"</span><span class="token punctuation">:</span> m<span class="token punctuation">.</span>PauseTotalNs<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        w<span class="token punctuation">.</span><span class="token function">Header</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Content-Type"</span><span class="token punctuation">,</span> <span class="token string">"application/json"</span><span class="token punctuation">)</span></span>
<span class="line">        json<span class="token punctuation">.</span><span class="token function">NewEncoder</span><span class="token punctuation">(</span>w<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Encode</span><span class="token punctuation">(</span>stats<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    server <span class="token operator">:=</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Server<span class="token punctuation">{</span></span>
<span class="line">        Addr<span class="token punctuation">:</span>    addr<span class="token punctuation">,</span></span>
<span class="line">        Handler<span class="token punctuation">:</span> mux<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>ProfilerService<span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">:</span> logger<span class="token punctuation">,</span></span>
<span class="line">        server<span class="token punctuation">:</span> server<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>ProfilerService<span class="token punctuation">)</span> <span class="token function">Start</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"Starting profiler server"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"addr"</span><span class="token punctuation">,</span> p<span class="token punctuation">.</span>server<span class="token punctuation">.</span>Addr<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> p<span class="token punctuation">.</span>server<span class="token punctuation">.</span><span class="token function">ListenAndServe</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>ProfilerService<span class="token punctuation">)</span> <span class="token function">Stop</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"Stopping profiler server"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> p<span class="token punctuation">.</span>server<span class="token punctuation">.</span><span class="token function">Shutdown</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 性能监控中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">PerformanceMiddleware</span><span class="token punctuation">(</span>logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 记录请求开始时的内存状态</span></span>
<span class="line">            <span class="token keyword">var</span> startMem runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">            runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>startMem<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 执行请求</span></span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 记录请求结束时的内存状态</span></span>
<span class="line">            <span class="token keyword">var</span> endMem runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">            runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>endMem<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">            memoryUsed <span class="token operator">:=</span> endMem<span class="token punctuation">.</span>Alloc <span class="token operator">-</span> startMem<span class="token punctuation">.</span>Alloc</span>
<span class="line">            </span>
<span class="line">            logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"HTTP request completed"</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"method"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>Method<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"path"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span><span class="token string">"duration"</span><span class="token punctuation">,</span> duration<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Uint64</span><span class="token punctuation">(</span><span class="token string">"memory_used"</span><span class="token punctuation">,</span> memoryUsed<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Int</span><span class="token punctuation">(</span><span class="token string">"goroutines"</span><span class="token punctuation">,</span> runtime<span class="token punctuation">.</span><span class="token function">NumGoroutine</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 如果请求时间过长，记录警告</span></span>
<span class="line">            <span class="token keyword">if</span> duration <span class="token operator">></span> <span class="token number">5</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Second <span class="token punctuation">{</span></span>
<span class="line">                logger<span class="token punctuation">.</span><span class="token function">Warn</span><span class="token punctuation">(</span><span class="token string">"Slow request detected"</span><span class="token punctuation">,</span></span>
<span class="line">                    zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"method"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>Method<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                    zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"path"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                    zap<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span><span class="token string">"duration"</span><span class="token punctuation">,</span> duration<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="性能分析脚本" tabindex="-1"><a class="header-anchor" href="#性能分析脚本">#</a> 性能分析脚本</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/profile.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">SERVICE_URL</span><span class="token operator">=</span><span class="token string">"http://localhost:8080"</span></span>
<span class="line"><span class="token assign-left variable">PROFILE_DURATION</span><span class="token operator">=</span><span class="token string">"30s"</span></span>
<span class="line"><span class="token assign-left variable">OUTPUT_DIR</span><span class="token operator">=</span><span class="token string">"./profiles"</span></span>
<span class="line"></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token variable">$OUTPUT_DIR</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting CPU profile for <span class="token variable">$PROFILE_DURATION</span>..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/profile?seconds=30"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/cpu.prof"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting memory profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/heap"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/heap.prof"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting goroutine profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/goroutine"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/goroutine.prof"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting mutex profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/mutex"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/mutex.prof"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting block profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/block"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/block.prof"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Profiles saved to <span class="token variable">$OUTPUT_DIR</span>"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Analyze with: go tool pprof <span class="token variable">$OUTPUT_DIR</span>/cpu.prof"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-分布式追踪" tabindex="-1"><a class="header-anchor" href="#_3-分布式追踪">#</a> 3. 分布式追踪</h3>
<h4 id="jaeger集成" tabindex="-1"><a class="header-anchor" href="#jaeger集成">#</a> Jaeger集成</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> tracing</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"io"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/opentracing/opentracing-go"</span></span>
<span class="line">    <span class="token string">"github.com/opentracing/opentracing-go/ext"</span></span>
<span class="line">    <span class="token string">"github.com/uber/jaeger-client-go"</span></span>
<span class="line">    <span class="token string">"github.com/uber/jaeger-client-go/config"</span></span>
<span class="line">    <span class="token string">"go.uber.org/zap"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 追踪配置</span></span>
<span class="line"><span class="token keyword">type</span> TracingConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    ServiceName <span class="token builtin">string</span>  <span class="token string">`json:"service_name"`</span></span>
<span class="line">    AgentHost   <span class="token builtin">string</span>  <span class="token string">`json:"agent_host"`</span></span>
<span class="line">    AgentPort   <span class="token builtin">int</span>     <span class="token string">`json:"agent_port"`</span></span>
<span class="line">    SampleRate  <span class="token builtin">float64</span> <span class="token string">`json:"sample_rate"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 初始化追踪</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">InitTracing</span><span class="token punctuation">(</span>cfg TracingConfig<span class="token punctuation">,</span> logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token punctuation">(</span>opentracing<span class="token punctuation">.</span>Tracer<span class="token punctuation">,</span> io<span class="token punctuation">.</span>Closer<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    config <span class="token operator">:=</span> config<span class="token punctuation">.</span>Configuration<span class="token punctuation">{</span></span>
<span class="line">        ServiceName<span class="token punctuation">:</span> cfg<span class="token punctuation">.</span>ServiceName<span class="token punctuation">,</span></span>
<span class="line">        Sampler<span class="token punctuation">:</span> <span class="token operator">&amp;</span>config<span class="token punctuation">.</span>SamplerConfig<span class="token punctuation">{</span></span>
<span class="line">            Type<span class="token punctuation">:</span>  jaeger<span class="token punctuation">.</span>SamplerTypeConst<span class="token punctuation">,</span></span>
<span class="line">            Param<span class="token punctuation">:</span> cfg<span class="token punctuation">.</span>SampleRate<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        Reporter<span class="token punctuation">:</span> <span class="token operator">&amp;</span>config<span class="token punctuation">.</span>ReporterConfig<span class="token punctuation">{</span></span>
<span class="line">            LogSpans<span class="token punctuation">:</span>           <span class="token boolean">true</span><span class="token punctuation">,</span></span>
<span class="line">            LocalAgentHostPort<span class="token punctuation">:</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:%d"</span><span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>AgentHost<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>AgentPort<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    tracer<span class="token punctuation">,</span> closer<span class="token punctuation">,</span> err <span class="token operator">:=</span> config<span class="token punctuation">.</span><span class="token function">NewTracer</span><span class="token punctuation">(</span></span>
<span class="line">        config<span class="token punctuation">.</span><span class="token function">Logger</span><span class="token punctuation">(</span>jaeger<span class="token punctuation">.</span>StdLogger<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    opentracing<span class="token punctuation">.</span><span class="token function">SetGlobalTracer</span><span class="token punctuation">(</span>tracer<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"Tracing initialized"</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"service"</span><span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>ServiceName<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"agent"</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:%d"</span><span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>AgentHost<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>AgentPort<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> tracer<span class="token punctuation">,</span> closer<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// HTTP追踪中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TracingMiddleware</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 从请求头中提取span上下文</span></span>
<span class="line">            spanCtx<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">GlobalTracer</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Extract</span><span class="token punctuation">(</span></span>
<span class="line">                opentracing<span class="token punctuation">.</span>HTTPHeaders<span class="token punctuation">,</span></span>
<span class="line">                opentracing<span class="token punctuation">.</span><span class="token function">HTTPHeadersCarrier</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span>Header<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 创建新的span</span></span>
<span class="line">            span <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">GlobalTracer</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">StartSpan</span><span class="token punctuation">(</span></span>
<span class="line">                fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s %s"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>Method<span class="token punctuation">,</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                ext<span class="token punctuation">.</span><span class="token function">RPCServerOption</span><span class="token punctuation">(</span>spanCtx<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">defer</span> span<span class="token punctuation">.</span><span class="token function">Finish</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 设置span标签</span></span>
<span class="line">            ext<span class="token punctuation">.</span>HTTPMethod<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> r<span class="token punctuation">.</span>Method<span class="token punctuation">)</span></span>
<span class="line">            ext<span class="token punctuation">.</span>HTTPUrl<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">            ext<span class="token punctuation">.</span>Component<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token string">"http-server"</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 将span添加到上下文</span></span>
<span class="line">            ctx <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">ContextWithSpan</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span><span class="token function">Context</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> span<span class="token punctuation">)</span></span>
<span class="line">            r <span class="token operator">=</span> r<span class="token punctuation">.</span><span class="token function">WithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 创建响应写入器包装器</span></span>
<span class="line">            rw <span class="token operator">:=</span> <span class="token operator">&amp;</span>responseWriter<span class="token punctuation">{</span>ResponseWriter<span class="token punctuation">:</span> w<span class="token punctuation">,</span> statusCode<span class="token punctuation">:</span> <span class="token number">200</span><span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 执行请求</span></span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>rw<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 设置响应状态</span></span>
<span class="line">            ext<span class="token punctuation">.</span>HTTPStatusCode<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token function">uint16</span><span class="token punctuation">(</span>rw<span class="token punctuation">.</span>statusCode<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> rw<span class="token punctuation">.</span>statusCode <span class="token operator">>=</span> <span class="token number">400</span> <span class="token punctuation">{</span></span>
<span class="line">                ext<span class="token punctuation">.</span>Error<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 响应写入器包装器</span></span>
<span class="line"><span class="token keyword">type</span> responseWriter <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    http<span class="token punctuation">.</span>ResponseWriter</span>
<span class="line">    statusCode <span class="token builtin">int</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>rw <span class="token operator">*</span>responseWriter<span class="token punctuation">)</span> <span class="token function">WriteHeader</span><span class="token punctuation">(</span>code <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    rw<span class="token punctuation">.</span>statusCode <span class="token operator">=</span> code</span>
<span class="line">    rw<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">.</span><span class="token function">WriteHeader</span><span class="token punctuation">(</span>code<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 服务调用追踪</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TraceServiceCall</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> serviceName<span class="token punctuation">,</span> operation <span class="token builtin">string</span><span class="token punctuation">,</span> fn <span class="token keyword">func</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    span<span class="token punctuation">,</span> ctx <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">StartSpanFromContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> operation<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> span<span class="token punctuation">.</span><span class="token function">Finish</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 设置span标签</span></span>
<span class="line">    span<span class="token punctuation">.</span><span class="token function">SetTag</span><span class="token punctuation">(</span><span class="token string">"service.name"</span><span class="token punctuation">,</span> serviceName<span class="token punctuation">)</span></span>
<span class="line">    span<span class="token punctuation">.</span><span class="token function">SetTag</span><span class="token punctuation">(</span><span class="token string">"operation"</span><span class="token punctuation">,</span> operation<span class="token punctuation">)</span></span>
<span class="line">    ext<span class="token punctuation">.</span>Component<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token string">"service-client"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 执行操作</span></span>
<span class="line">    err <span class="token operator">:=</span> <span class="token function">fn</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        ext<span class="token punctuation">.</span>Error<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span></span>
<span class="line">        span<span class="token punctuation">.</span><span class="token function">SetTag</span><span class="token punctuation">(</span><span class="token string">"error.message"</span><span class="token punctuation">,</span> err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 数据库操作追踪</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TraceDBOperation</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> query <span class="token builtin">string</span><span class="token punctuation">,</span> fn <span class="token keyword">func</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    span<span class="token punctuation">,</span> ctx <span class="token operator">:=</span> opentracing<span class="token punctuation">.</span><span class="token function">StartSpanFromContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"db.query"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> span<span class="token punctuation">.</span><span class="token function">Finish</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 设置span标签</span></span>
<span class="line">    ext<span class="token punctuation">.</span>DBType<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token string">"postgresql"</span><span class="token punctuation">)</span></span>
<span class="line">    ext<span class="token punctuation">.</span>DBStatement<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> query<span class="token punctuation">)</span></span>
<span class="line">    ext<span class="token punctuation">.</span>Component<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token string">"database"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 执行查询</span></span>
<span class="line">    err <span class="token operator">:=</span> <span class="token function">fn</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        ext<span class="token punctuation">.</span>Error<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>span<span class="token punctuation">,</span> <span class="token boolean">true</span><span class="token punctuation">)</span></span>
<span class="line">        span<span class="token punctuation">.</span><span class="token function">SetTag</span><span class="token punctuation">(</span><span class="token string">"error.message"</span><span class="token punctuation">,</span> err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-实时调试" tabindex="-1"><a class="header-anchor" href="#_4-实时调试">#</a> 4. 实时调试</h3>
<h4 id="delve调试器" tabindex="-1"><a class="header-anchor" href="#delve调试器">#</a> Delve调试器</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装Delve</span></span>
<span class="line">go <span class="token function">install</span> github.com/go-delve/delve/cmd/dlv@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 调试运行中的程序</span></span>
<span class="line">dlv attach <span class="token operator">&lt;</span>pid<span class="token operator">></span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 调试测试</span></span>
<span class="line">dlv <span class="token builtin class-name">test</span> ./pkg/user</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 远程调试</span></span>
<span class="line">dlv debug <span class="token parameter variable">--headless</span> <span class="token parameter variable">--listen</span><span class="token operator">=</span>:2345 --api-version<span class="token operator">=</span><span class="token number">2</span> --accept-multiclient</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="调试配置" tabindex="-1"><a class="header-anchor" href="#调试配置">#</a> 调试配置</h4>
<div class="language-json line-numbers-mode" data-highlighter="prismjs" data-ext="json"><pre v-pre><code class="language-json"><span class="line"><span class="token comment">// .vscode/launch.json</span></span>
<span class="line"><span class="token punctuation">{</span></span>
<span class="line">    <span class="token property">"version"</span><span class="token operator">:</span> <span class="token string">"0.2.0"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token property">"configurations"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"Debug VGO Service"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"go"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"request"</span><span class="token operator">:</span> <span class="token string">"launch"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"debug"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"program"</span><span class="token operator">:</span> <span class="token string">"${workspaceFolder}/cmd/server"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"env"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token property">"GO_ENV"</span><span class="token operator">:</span> <span class="token string">"development"</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token property">"DATABASE_URL"</span><span class="token operator">:</span> <span class="token string">"postgres://localhost:5432/vgo_dev"</span><span class="token punctuation">,</span></span>
<span class="line">                <span class="token property">"REDIS_URL"</span><span class="token operator">:</span> <span class="token string">"redis://localhost:6379"</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"args"</span><span class="token operator">:</span> <span class="token punctuation">[</span></span>
<span class="line">                <span class="token string">"--config"</span><span class="token punctuation">,</span> <span class="token string">"configs/development.yaml"</span></span>
<span class="line">            <span class="token punctuation">]</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"Debug Test"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"go"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"request"</span><span class="token operator">:</span> <span class="token string">"launch"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"test"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"program"</span><span class="token operator">:</span> <span class="token string">"${workspaceFolder}/pkg/user"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"env"</span><span class="token operator">:</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token property">"GO_ENV"</span><span class="token operator">:</span> <span class="token string">"test"</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            <span class="token property">"name"</span><span class="token operator">:</span> <span class="token string">"Attach to Process"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"type"</span><span class="token operator">:</span> <span class="token string">"go"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"request"</span><span class="token operator">:</span> <span class="token string">"attach"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"mode"</span><span class="token operator">:</span> <span class="token string">"local"</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token property">"processId"</span><span class="token operator">:</span> <span class="token number">0</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">]</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-问题排查" tabindex="-1"><a class="header-anchor" href="#🔧-问题排查">#</a> 🔧 问题排查</h2>
<h3 id="_1-常见问题诊断" tabindex="-1"><a class="header-anchor" href="#_1-常见问题诊断">#</a> 1. 常见问题诊断</h3>
<h4 id="服务启动问题" tabindex="-1"><a class="header-anchor" href="#服务启动问题">#</a> 服务启动问题</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/diagnose-startup.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== VGO Service Startup Diagnosis ==="</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查端口占用</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Checking port usage:"</span></span>
<span class="line"><span class="token function">netstat</span> <span class="token parameter variable">-tulpn</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">':(8080|5432|6379|4222)'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务状态</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Checking service status:"</span></span>
<span class="line">systemctl status vgo-service <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"Service not managed by systemd"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查日志</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Recent logs:"</span></span>
<span class="line"><span class="token function">tail</span> <span class="token parameter variable">-50</span> /var/log/vgo/service.log <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"Log file not found"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查配置文件</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Checking configuration:"</span></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-f</span> <span class="token string">"/etc/vgo/config.yaml"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"Config file exists"</span></span>
<span class="line">    yaml-lint /etc/vgo/config.yaml <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"Config file has syntax errors"</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"Config file not found"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查数据库连接</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Testing database connection:"</span></span>
<span class="line">psql <span class="token parameter variable">-h</span> localhost <span class="token parameter variable">-U</span> vgo <span class="token parameter variable">-d</span> vgo <span class="token parameter variable">-c</span> <span class="token string">"SELECT 1;"</span> <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"Database connection failed"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查Redis连接</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Testing Redis connection:"</span></span>
<span class="line">redis-cli <span class="token function">ping</span> <span class="token operator">||</span> <span class="token builtin class-name">echo</span> <span class="token string">"Redis connection failed"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查磁盘空间</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Disk usage:"</span></span>
<span class="line"><span class="token function">df</span> <span class="token parameter variable">-h</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查内存使用</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Memory usage:"</span></span>
<span class="line"><span class="token function">free</span> <span class="token parameter variable">-h</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="性能问题诊断" tabindex="-1"><a class="header-anchor" href="#性能问题诊断">#</a> 性能问题诊断</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/diagnose-performance.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">SERVICE_PID</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>pgrep vgo-service<span class="token variable">)</span></span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token punctuation">[</span> <span class="token parameter variable">-z</span> <span class="token string">"<span class="token variable">$SERVICE_PID</span>"</span> <span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"VGO service is not running"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== VGO Service Performance Diagnosis ==="</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Service PID: <span class="token variable">$SERVICE_PID</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># CPU使用率</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>CPU usage:"</span></span>
<span class="line"><span class="token function">top</span> <span class="token parameter variable">-p</span> <span class="token variable">$SERVICE_PID</span> <span class="token parameter variable">-n</span> <span class="token number">1</span> <span class="token operator">|</span> <span class="token function">grep</span> vgo-service</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 内存使用</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Memory usage:"</span></span>
<span class="line"><span class="token function">ps</span> <span class="token parameter variable">-p</span> <span class="token variable">$SERVICE_PID</span> <span class="token parameter variable">-o</span> pid,ppid,cmd,%mem,%cpu <span class="token parameter variable">--sort</span><span class="token operator">=</span>-%mem</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 文件描述符</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>File descriptors:"</span></span>
<span class="line"><span class="token function">ls</span> /proc/<span class="token variable">$SERVICE_PID</span>/fd <span class="token operator">|</span> <span class="token function">wc</span> <span class="token parameter variable">-l</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Limit: <span class="token variable"><span class="token variable">$(</span><span class="token builtin class-name">ulimit</span> <span class="token parameter variable">-n</span><span class="token variable">)</span></span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 网络连接</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Network connections:"</span></span>
<span class="line"><span class="token function">netstat</span> <span class="token parameter variable">-anp</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token variable">$SERVICE_PID</span> <span class="token operator">|</span> <span class="token function">wc</span> <span class="token parameter variable">-l</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># Goroutine数量</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Goroutines:"</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:8080/debug/stats <span class="token operator">|</span> jq <span class="token string">'.goroutines'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 内存统计</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Memory stats:"</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> http://localhost:8080/debug/stats <span class="token operator">|</span> jq <span class="token string">'{</span>
<span class="line">    memory_alloc: .memory_alloc,</span>
<span class="line">    memory_sys: .memory_sys,</span>
<span class="line">    gc_runs: .gc_runs</span>
<span class="line">}'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 最近的慢查询</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Slow requests (>1s):"</span></span>
<span class="line"><span class="token function">grep</span> <span class="token string">"duration.*[0-9]\+s"</span> /var/log/vgo/service.log <span class="token operator">|</span> <span class="token function">tail</span> <span class="token parameter variable">-10</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-数据库问题排查" tabindex="-1"><a class="header-anchor" href="#_2-数据库问题排查">#</a> 2. 数据库问题排查</h3>
<h4 id="postgresql诊断" tabindex="-1"><a class="header-anchor" href="#postgresql诊断">#</a> PostgreSQL诊断</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 检查活跃连接</span></span>
<span class="line"><span class="token keyword">SELECT</span> </span>
<span class="line">    pid<span class="token punctuation">,</span></span>
<span class="line">    usename<span class="token punctuation">,</span></span>
<span class="line">    application_name<span class="token punctuation">,</span></span>
<span class="line">    client_addr<span class="token punctuation">,</span></span>
<span class="line">    state<span class="token punctuation">,</span></span>
<span class="line">    query_start<span class="token punctuation">,</span></span>
<span class="line">    query</span>
<span class="line"><span class="token keyword">FROM</span> pg_stat_activity </span>
<span class="line"><span class="token keyword">WHERE</span> state <span class="token operator">=</span> <span class="token string">'active'</span></span>
<span class="line"><span class="token keyword">ORDER</span> <span class="token keyword">BY</span> query_start<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 检查长时间运行的查询</span></span>
<span class="line"><span class="token keyword">SELECT</span> </span>
<span class="line">    pid<span class="token punctuation">,</span></span>
<span class="line">    <span class="token function">now</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-</span> pg_stat_activity<span class="token punctuation">.</span>query_start <span class="token keyword">AS</span> duration<span class="token punctuation">,</span></span>
<span class="line">    query<span class="token punctuation">,</span></span>
<span class="line">    state</span>
<span class="line"><span class="token keyword">FROM</span> pg_stat_activity </span>
<span class="line"><span class="token keyword">WHERE</span> <span class="token punctuation">(</span><span class="token function">now</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-</span> pg_stat_activity<span class="token punctuation">.</span>query_start<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token keyword">interval</span> <span class="token string">'5 minutes'</span></span>
<span class="line"><span class="token keyword">ORDER</span> <span class="token keyword">BY</span> duration <span class="token keyword">DESC</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 检查锁等待</span></span>
<span class="line"><span class="token keyword">SELECT</span> </span>
<span class="line">    blocked_locks<span class="token punctuation">.</span>pid <span class="token keyword">AS</span> blocked_pid<span class="token punctuation">,</span></span>
<span class="line">    blocked_activity<span class="token punctuation">.</span>usename <span class="token keyword">AS</span> blocked_user<span class="token punctuation">,</span></span>
<span class="line">    blocking_locks<span class="token punctuation">.</span>pid <span class="token keyword">AS</span> blocking_pid<span class="token punctuation">,</span></span>
<span class="line">    blocking_activity<span class="token punctuation">.</span>usename <span class="token keyword">AS</span> blocking_user<span class="token punctuation">,</span></span>
<span class="line">    blocked_activity<span class="token punctuation">.</span>query <span class="token keyword">AS</span> blocked_statement<span class="token punctuation">,</span></span>
<span class="line">    blocking_activity<span class="token punctuation">.</span>query <span class="token keyword">AS</span> current_statement_in_blocking_process</span>
<span class="line"><span class="token keyword">FROM</span> pg_catalog<span class="token punctuation">.</span>pg_locks blocked_locks</span>
<span class="line"><span class="token keyword">JOIN</span> pg_catalog<span class="token punctuation">.</span>pg_stat_activity blocked_activity <span class="token keyword">ON</span> blocked_activity<span class="token punctuation">.</span>pid <span class="token operator">=</span> blocked_locks<span class="token punctuation">.</span>pid</span>
<span class="line"><span class="token keyword">JOIN</span> pg_catalog<span class="token punctuation">.</span>pg_locks blocking_locks </span>
<span class="line">    <span class="token keyword">ON</span> blocking_locks<span class="token punctuation">.</span>locktype <span class="token operator">=</span> blocked_locks<span class="token punctuation">.</span>locktype</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span><span class="token keyword">database</span> <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span><span class="token keyword">database</span></span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>relation <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>relation</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>page <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>page</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>tuple <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>tuple</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>virtualxid <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>virtualxid</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>transactionid <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>transactionid</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>classid <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>classid</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>objid <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>objid</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>objsubid <span class="token operator">IS</span> <span class="token operator">NOT</span> <span class="token keyword">DISTINCT</span> <span class="token keyword">FROM</span> blocked_locks<span class="token punctuation">.</span>objsubid</span>
<span class="line">    <span class="token operator">AND</span> blocking_locks<span class="token punctuation">.</span>pid <span class="token operator">!=</span> blocked_locks<span class="token punctuation">.</span>pid</span>
<span class="line"><span class="token keyword">JOIN</span> pg_catalog<span class="token punctuation">.</span>pg_stat_activity blocking_activity <span class="token keyword">ON</span> blocking_activity<span class="token punctuation">.</span>pid <span class="token operator">=</span> blocking_locks<span class="token punctuation">.</span>pid</span>
<span class="line"><span class="token keyword">WHERE</span> <span class="token operator">NOT</span> blocked_locks<span class="token punctuation">.</span>granted<span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 检查表大小</span></span>
<span class="line"><span class="token keyword">SELECT</span> </span>
<span class="line">    schemaname<span class="token punctuation">,</span></span>
<span class="line">    tablename<span class="token punctuation">,</span></span>
<span class="line">    pg_size_pretty<span class="token punctuation">(</span>pg_total_relation_size<span class="token punctuation">(</span>schemaname<span class="token operator">||</span><span class="token string">'.'</span><span class="token operator">||</span>tablename<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token keyword">as</span> size</span>
<span class="line"><span class="token keyword">FROM</span> pg_tables </span>
<span class="line"><span class="token keyword">WHERE</span> schemaname <span class="token operator">=</span> <span class="token string">'public'</span></span>
<span class="line"><span class="token keyword">ORDER</span> <span class="token keyword">BY</span> pg_total_relation_size<span class="token punctuation">(</span>schemaname<span class="token operator">||</span><span class="token string">'.'</span><span class="token operator">||</span>tablename<span class="token punctuation">)</span> <span class="token keyword">DESC</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 检查索引使用情况</span></span>
<span class="line"><span class="token keyword">SELECT</span> </span>
<span class="line">    schemaname<span class="token punctuation">,</span></span>
<span class="line">    tablename<span class="token punctuation">,</span></span>
<span class="line">    indexname<span class="token punctuation">,</span></span>
<span class="line">    idx_scan<span class="token punctuation">,</span></span>
<span class="line">    idx_tup_read<span class="token punctuation">,</span></span>
<span class="line">    idx_tup_fetch</span>
<span class="line"><span class="token keyword">FROM</span> pg_stat_user_indexes</span>
<span class="line"><span class="token keyword">ORDER</span> <span class="token keyword">BY</span> idx_scan <span class="token keyword">DESC</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="redis诊断" tabindex="-1"><a class="header-anchor" href="#redis诊断">#</a> Redis诊断</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/diagnose-redis.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== Redis Diagnosis ==="</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># Redis信息</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Redis info:"</span></span>
<span class="line">redis-cli info server <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">"redis_version|uptime_in_seconds|connected_clients"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 内存使用</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Memory usage:"</span></span>
<span class="line">redis-cli info memory <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">"used_memory_human|used_memory_peak_human|maxmemory_human"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 键空间信息</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Keyspace info:"</span></span>
<span class="line">redis-cli info keyspace</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 慢查询</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Slow queries:"</span></span>
<span class="line">redis-cli slowlog get <span class="token number">10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 客户端连接</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Client connections:"</span></span>
<span class="line">redis-cli client list <span class="token operator">|</span> <span class="token function">head</span> <span class="token parameter variable">-10</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 键分析</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Top keys by memory usage:"</span></span>
<span class="line">redis-cli <span class="token parameter variable">--bigkeys</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-网络问题排查" tabindex="-1"><a class="header-anchor" href="#_3-网络问题排查">#</a> 3. 网络问题排查</h3>
<h4 id="网络连通性测试" tabindex="-1"><a class="header-anchor" href="#网络连通性测试">#</a> 网络连通性测试</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/diagnose-network.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"=== Network Diagnosis ==="</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务端口</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Service ports:"</span></span>
<span class="line"><span class="token function">netstat</span> <span class="token parameter variable">-tulpn</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">':(8080|8081|8082)'</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查DNS解析</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>DNS resolution:"</span></span>
<span class="line"><span class="token function">nslookup</span> postgres.local</span>
<span class="line"><span class="token function">nslookup</span> redis.local</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查服务间连通性</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Service connectivity:"</span></span>
<span class="line">telnet postgres.local <span class="token number">5432</span> <span class="token operator">&lt;</span> /dev/null</span>
<span class="line">telnet redis.local <span class="token number">6379</span> <span class="token operator">&lt;</span> /dev/null</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查外部API连通性</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>External API connectivity:"</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-I</span> https://api.example.com/health</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查网络延迟</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Network latency:"</span></span>
<span class="line"><span class="token function">ping</span> <span class="token parameter variable">-c</span> <span class="token number">3</span> postgres.local</span>
<span class="line"><span class="token function">ping</span> <span class="token parameter variable">-c</span> <span class="token number">3</span> redis.local</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查防火墙规则</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"<span class="token entity" title="\n">\n</span>Firewall rules:"</span></span>
<span class="line"><span class="token function">sudo</span> iptables <span class="token parameter variable">-L</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token parameter variable">-E</span> <span class="token string">'(8080|5432|6379)'</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚨-故障处理" tabindex="-1"><a class="header-anchor" href="#🚨-故障处理">#</a> 🚨 故障处理</h2>
<h3 id="_1-紧急故障响应" tabindex="-1"><a class="header-anchor" href="#_1-紧急故障响应">#</a> 1. 紧急故障响应</h3>
<h4 id="故障响应流程" tabindex="-1"><a class="header-anchor" href="#故障响应流程">#</a> 故障响应流程</h4>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">flowchart</span> TD</span>
<span class="line">    A<span class="token text string">[故障检测]</span> <span class="token arrow operator">--></span> B<span class="token text string">[故障确认]</span></span>
<span class="line">    B <span class="token arrow operator">--></span> C<span class="token text string">[影响评估]</span></span>
<span class="line">    C <span class="token arrow operator">--></span> D<span class="token text string">[紧急处理]</span></span>
<span class="line">    D <span class="token arrow operator">--></span> E<span class="token text string">[根因分析]</span></span>
<span class="line">    E <span class="token arrow operator">--></span> F<span class="token text string">[永久修复]</span></span>
<span class="line">    F <span class="token arrow operator">--></span> G<span class="token text string">[故障总结]</span></span>
<span class="line">    </span>
<span class="line">    D <span class="token arrow operator">--></span> H<span class="token text string">[回滚部署]</span></span>
<span class="line">    D <span class="token arrow operator">--></span> I<span class="token text string">[扩容资源]</span></span>
<span class="line">    D <span class="token arrow operator">--></span> J<span class="token text string">[切换流量]</span></span>
<span class="line">    D <span class="token arrow operator">--></span> K<span class="token text string">[重启服务]</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="故障处理脚本" tabindex="-1"><a class="header-anchor" href="#故障处理脚本">#</a> 故障处理脚本</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/emergency-response.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">ACTION</span><span class="token operator">=</span><span class="token variable">$1</span></span>
<span class="line"><span class="token assign-left variable">SERVICE</span><span class="token operator">=</span><span class="token variable">${2<span class="token operator">:-</span>"all"}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">case</span> <span class="token variable">$ACTION</span> <span class="token keyword">in</span></span>
<span class="line">    <span class="token string">"rollback"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Rolling back deployment..."</span></span>
<span class="line">        kubectl rollout undo deployment/vgo-service</span>
<span class="line">        kubectl rollout status deployment/vgo-service</span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"scale-up"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Scaling up service..."</span></span>
<span class="line">        kubectl scale deployment/vgo-service <span class="token parameter variable">--replicas</span><span class="token operator">=</span><span class="token number">10</span></span>
<span class="line">        kubectl rollout status deployment/vgo-service</span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"restart"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Restarting service..."</span></span>
<span class="line">        kubectl rollout restart deployment/vgo-service</span>
<span class="line">        kubectl rollout status deployment/vgo-service</span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"drain-traffic"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Draining traffic from service..."</span></span>
<span class="line">        kubectl patch <span class="token function">service</span> vgo-service <span class="token parameter variable">-p</span> <span class="token string">'{"spec":{"selector":{"app":"maintenance"}}}'</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"restore-traffic"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Restoring traffic to service..."</span></span>
<span class="line">        kubectl patch <span class="token function">service</span> vgo-service <span class="token parameter variable">-p</span> <span class="token string">'{"spec":{"selector":{"app":"vgo-service"}}}'</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"health-check"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Performing health check..."</span></span>
<span class="line">        <span class="token function">curl</span> <span class="token parameter variable">-f</span> http://localhost:8080/health <span class="token operator">||</span> <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Service is healthy"</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line">    </span>
<span class="line">    *<span class="token punctuation">)</span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"Usage: <span class="token variable">$0</span> {rollback|scale-up|restart|drain-traffic|restore-traffic|health-check} [service]"</span></span>
<span class="line">        <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line">        <span class="token punctuation">;</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">esac</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-监控告警" tabindex="-1"><a class="header-anchor" href="#_2-监控告警">#</a> 2. 监控告警</h3>
<h4 id="告警规则" tabindex="-1"><a class="header-anchor" href="#告警规则">#</a> 告警规则</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># monitoring/alerts.yml</span></span>
<span class="line"><span class="token key atrule">groups</span><span class="token punctuation">:</span></span>
<span class="line"><span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> vgo<span class="token punctuation">-</span>service</span>
<span class="line">  <span class="token key atrule">rules</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> ServiceDown</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> up<span class="token punctuation">{</span>job="vgo<span class="token punctuation">-</span>service"<span class="token punctuation">}</span> == 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 1m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"VGO service is down"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"VGO service has been down for more than 1 minute"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighErrorRate</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> rate(http_requests_total<span class="token punctuation">{</span>status=~"5.."<span class="token punctuation">}</span><span class="token punctuation">[</span>5m<span class="token punctuation">]</span>) <span class="token punctuation">></span> 0.1</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 2m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High error rate detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Error rate is {{ $value }} errors per second"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighResponseTime</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> histogram_quantile(0.95<span class="token punctuation">,</span> rate(http_request_duration_seconds_bucket<span class="token punctuation">[</span>5m<span class="token punctuation">]</span>)) <span class="token punctuation">></span> 1</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High response time detected"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"95th percentile response time is {{ $value }} seconds"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> DatabaseConnectionFailure</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> database_connections_failed_total <span class="token punctuation">></span> 0</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 1m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> critical</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"Database connection failure"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Failed to connect to database"</span></span>
<span class="line">  </span>
<span class="line">  <span class="token punctuation">-</span> <span class="token key atrule">alert</span><span class="token punctuation">:</span> HighMemoryUsage</span>
<span class="line">    <span class="token key atrule">expr</span><span class="token punctuation">:</span> process_resident_memory_bytes / 1024 / 1024 <span class="token punctuation">></span> 1000</span>
<span class="line">    <span class="token key atrule">for</span><span class="token punctuation">:</span> 5m</span>
<span class="line">    <span class="token key atrule">labels</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">severity</span><span class="token punctuation">:</span> warning</span>
<span class="line">    <span class="token key atrule">annotations</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">summary</span><span class="token punctuation">:</span> <span class="token string">"High memory usage"</span></span>
<span class="line">      <span class="token key atrule">description</span><span class="token punctuation">:</span> <span class="token string">"Memory usage is {{ $value }}MB"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-调试最佳实践" tabindex="-1"><a class="header-anchor" href="#📊-调试最佳实践">#</a> 📊 调试最佳实践</h2>
<h3 id="_1-日志最佳实践" tabindex="-1"><a class="header-anchor" href="#_1-日志最佳实践">#</a> 1. 日志最佳实践</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 好的日志实践</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> req <span class="token operator">*</span>CreateUserRequest<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    logger <span class="token operator">:=</span> s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">With</span><span class="token punctuation">(</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"operation"</span><span class="token punctuation">,</span> <span class="token string">"CreateUser"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>UserID<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"Starting user creation"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 记录关键步骤</span></span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Debug</span><span class="token punctuation">(</span><span class="token string">"Validating user input"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span><span class="token function">validateUser</span><span class="token punctuation">(</span>req<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"User validation failed"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Debug</span><span class="token punctuation">(</span><span class="token string">"Checking user existence"</span><span class="token punctuation">)</span></span>
<span class="line">    exists<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">UserExists</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Failed to check user existence"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> exists <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Warn</span><span class="token punctuation">(</span><span class="token string">"User already exists"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"username"</span><span class="token punctuation">,</span> req<span class="token punctuation">.</span>Username<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> ErrUserExists</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Debug</span><span class="token punctuation">(</span><span class="token string">"Creating user in database"</span><span class="token punctuation">)</span></span>
<span class="line">    user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">Create</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Failed to create user"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    logger<span class="token punctuation">.</span><span class="token function">Info</span><span class="token punctuation">(</span><span class="token string">"User created successfully"</span><span class="token punctuation">,</span> zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-错误处理最佳实践" tabindex="-1"><a class="header-anchor" href="#_2-错误处理最佳实践">#</a> 2. 错误处理最佳实践</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 错误包装和上下文</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>r <span class="token operator">*</span>UserRepository<span class="token punctuation">)</span> <span class="token function">GetByID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">const</span> op <span class="token operator">=</span> <span class="token string">"UserRepository.GetByID"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> id <span class="token operator">==</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"%s: %w"</span><span class="token punctuation">,</span> op<span class="token punctuation">,</span> ErrInvalidUserID<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    query <span class="token operator">:=</span> <span class="token string">`SELECT id, username, email, created_at FROM users WHERE id = $1 AND deleted_at IS NULL`</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> user User</span>
<span class="line">    err <span class="token operator">:=</span> r<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">QueryRowContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> query<span class="token punctuation">,</span> id<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Scan</span><span class="token punctuation">(</span></span>
<span class="line">        <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>ID<span class="token punctuation">,</span></span>
<span class="line">        <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Username<span class="token punctuation">,</span></span>
<span class="line">        <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Email<span class="token punctuation">,</span></span>
<span class="line">        <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>CreatedAt<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> errors<span class="token punctuation">.</span><span class="token function">Is</span><span class="token punctuation">(</span>err<span class="token punctuation">,</span> sql<span class="token punctuation">.</span>ErrNoRows<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"%s: user %s: %w"</span><span class="token punctuation">,</span> op<span class="token punctuation">,</span> id<span class="token punctuation">,</span> ErrUserNotFound<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"%s: failed to query user %s: %w"</span><span class="token punctuation">,</span> op<span class="token punctuation">,</span> id<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>user<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 错误分类</span></span>
<span class="line"><span class="token keyword">var</span> <span class="token punctuation">(</span></span>
<span class="line">    ErrUserNotFound   <span class="token operator">=</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"user not found"</span><span class="token punctuation">)</span></span>
<span class="line">    ErrInvalidUserID  <span class="token operator">=</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"invalid user ID"</span><span class="token punctuation">)</span></span>
<span class="line">    ErrUserExists     <span class="token operator">=</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"user already exists"</span><span class="token punctuation">)</span></span>
<span class="line">    ErrDatabaseError  <span class="token operator">=</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"database error"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 错误处理中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">ErrorHandlingMiddleware</span><span class="token punctuation">(</span>logger <span class="token operator">*</span>zap<span class="token punctuation">.</span>Logger<span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">defer</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token keyword">if</span> err <span class="token operator">:=</span> <span class="token function">recover</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                    logger<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token string">"Panic recovered"</span><span class="token punctuation">,</span></span>
<span class="line">                        zap<span class="token punctuation">.</span><span class="token function">Any</span><span class="token punctuation">(</span><span class="token string">"error"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                        zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"path"</span><span class="token punctuation">,</span> r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                        zap<span class="token punctuation">.</span><span class="token function">Stack</span><span class="token punctuation">(</span><span class="token string">"stack"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                    <span class="token punctuation">)</span></span>
<span class="line">                    </span>
<span class="line">                    http<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> <span class="token string">"Internal Server Error"</span><span class="token punctuation">,</span> http<span class="token punctuation">.</span>StatusInternalServerError<span class="token punctuation">)</span></span>
<span class="line">                <span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-性能调试技巧" tabindex="-1"><a class="header-anchor" href="#_3-性能调试技巧">#</a> 3. 性能调试技巧</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 性能测量</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">GetUser</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">        s<span class="token punctuation">.</span>metrics<span class="token punctuation">.</span><span class="token function">RecordDuration</span><span class="token punctuation">(</span><span class="token string">"get_user"</span><span class="token punctuation">,</span> duration<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">if</span> duration <span class="token operator">></span> <span class="token number">100</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Millisecond <span class="token punctuation">{</span></span>
<span class="line">            s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Warn</span><span class="token punctuation">(</span><span class="token string">"Slow operation detected"</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"operation"</span><span class="token punctuation">,</span> <span class="token string">"GetUser"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token string">"user_id"</span><span class="token punctuation">,</span> id<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span><span class="token string">"duration"</span><span class="token punctuation">,</span> duration<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">GetByID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 内存使用监控</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>Service<span class="token punctuation">)</span> <span class="token function">monitorMemory</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ticker <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">NewTicker</span><span class="token punctuation">(</span><span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> ticker<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ticker<span class="token punctuation">.</span>C<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">var</span> m runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">            runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>m<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Debug</span><span class="token punctuation">(</span><span class="token string">"Memory stats"</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Uint64</span><span class="token punctuation">(</span><span class="token string">"alloc"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>Alloc<span class="token operator">/</span><span class="token number">1024</span><span class="token operator">/</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Uint64</span><span class="token punctuation">(</span><span class="token string">"sys"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>Sys<span class="token operator">/</span><span class="token number">1024</span><span class="token operator">/</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Uint32</span><span class="token punctuation">(</span><span class="token string">"gc_runs"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>NumGC<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">                zap<span class="token punctuation">.</span><span class="token function">Int</span><span class="token punctuation">(</span><span class="token string">"goroutines"</span><span class="token punctuation">,</span> runtime<span class="token punctuation">.</span><span class="token function">NumGoroutine</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 内存使用过高时触发GC</span></span>
<span class="line">            <span class="token keyword">if</span> m<span class="token punctuation">.</span>Alloc <span class="token operator">></span> <span class="token number">500</span><span class="token operator">*</span><span class="token number">1024</span><span class="token operator">*</span><span class="token number">1024</span> <span class="token punctuation">{</span> <span class="token comment">// 500MB</span></span>
<span class="line">                s<span class="token punctuation">.</span>logger<span class="token punctuation">.</span><span class="token function">Warn</span><span class="token punctuation">(</span><span class="token string">"High memory usage, forcing GC"</span><span class="token punctuation">)</span></span>
<span class="line">                runtime<span class="token punctuation">.</span><span class="token function">GC</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>s<span class="token punctuation">.</span>ctx<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">return</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/development/">开发指南</RouteLink></li>
<li><RouteLink to="/development/architecture.html">架构设计</RouteLink></li>
<li><RouteLink to="/development/testing.html">测试指南</RouteLink></li>
<li><RouteLink to="/development/performance.html">性能优化</RouteLink></li>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
</ul>
</div></template>


