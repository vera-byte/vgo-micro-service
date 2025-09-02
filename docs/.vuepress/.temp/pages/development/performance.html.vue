<template><div><h1 id="性能优化指南" tabindex="-1"><a class="header-anchor" href="#性能优化指南">#</a> 性能优化指南</h1>
<p>本文档详细介绍了VGO微服务的性能优化策略、技术和最佳实践。</p>
<h2 id="🎯-性能目标" tabindex="-1"><a class="header-anchor" href="#🎯-性能目标">#</a> 🎯 性能目标</h2>
<h3 id="性能指标" tabindex="-1"><a class="header-anchor" href="#性能指标">#</a> 性能指标</h3>
<table>
<thead>
<tr>
<th>指标类型</th>
<th>目标值</th>
<th>监控方式</th>
</tr>
</thead>
<tbody>
<tr>
<td>API响应时间</td>
<td>P95 &lt; 200ms</td>
<td>Prometheus + Grafana</td>
</tr>
<tr>
<td>API吞吐量</td>
<td>&gt; 1000 RPS</td>
<td>负载测试</td>
</tr>
<tr>
<td>数据库查询</td>
<td>P95 &lt; 50ms</td>
<td>慢查询日志</td>
</tr>
<tr>
<td>内存使用</td>
<td>&lt; 512MB</td>
<td>内存监控</td>
</tr>
<tr>
<td>CPU使用率</td>
<td>&lt; 70%</td>
<td>系统监控</td>
</tr>
<tr>
<td>错误率</td>
<td>&lt; 0.1%</td>
<td>错误监控</td>
</tr>
</tbody>
</table>
<h3 id="性能测试金字塔" tabindex="-1"><a class="header-anchor" href="#性能测试金字塔">#</a> 性能测试金字塔</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"性能测试层次"</span></span>
<span class="line">        A<span class="token text string">["压力测试&lt;br/>极限负载测试"]</span></span>
<span class="line">        B<span class="token text string">["负载测试&lt;br/>预期负载测试"]</span></span>
<span class="line">        C<span class="token text string">["基准测试&lt;br/>单组件性能测试"]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">style</span> A <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#ff6b6b</span></span>
<span class="line">    <span class="token keyword">style</span> B <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#ffd93d</span></span>
<span class="line">    <span class="token keyword">style</span> C <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#6bcf7f</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚀-应用层优化" tabindex="-1"><a class="header-anchor" href="#🚀-应用层优化">#</a> 🚀 应用层优化</h2>
<h3 id="_1-go语言优化" tabindex="-1"><a class="header-anchor" href="#_1-go语言优化">#</a> 1. Go语言优化</h3>
<h4 id="内存管理优化" tabindex="-1"><a class="header-anchor" href="#内存管理优化">#</a> 内存管理优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> optimization</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"sync"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 对象池优化</span></span>
<span class="line"><span class="token keyword">type</span> UserPool <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    pool sync<span class="token punctuation">.</span>Pool</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewUserPool</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>UserPool <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>UserPool<span class="token punctuation">{</span></span>
<span class="line">        pool<span class="token punctuation">:</span> sync<span class="token punctuation">.</span>Pool<span class="token punctuation">{</span></span>
<span class="line">            New<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token keyword">return</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>UserPool<span class="token punctuation">)</span> <span class="token function">Get</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>User <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> p<span class="token punctuation">.</span>pool<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>UserPool<span class="token punctuation">)</span> <span class="token function">Put</span><span class="token punctuation">(</span>user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 重置对象状态</span></span>
<span class="line">    user<span class="token punctuation">.</span><span class="token function">Reset</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    p<span class="token punctuation">.</span>pool<span class="token punctuation">.</span><span class="token function">Put</span><span class="token punctuation">(</span>user<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 使用对象池的服务</span></span>
<span class="line"><span class="token keyword">type</span> UserService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    repo     UserRepository</span>
<span class="line">    userPool <span class="token operator">*</span>UserPool</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">ProcessUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userIDs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    users <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>userIDs<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> id <span class="token operator">:=</span> <span class="token keyword">range</span> userIDs <span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 从对象池获取用户对象</span></span>
<span class="line">        user <span class="token operator">:=</span> s<span class="token punctuation">.</span>userPool<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">defer</span> s<span class="token punctuation">.</span>userPool<span class="token punctuation">.</span><span class="token function">Put</span><span class="token punctuation">(</span>user<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">LoadUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> id<span class="token punctuation">,</span> user<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 复制用户数据，避免池对象被修改</span></span>
<span class="line">        userCopy <span class="token operator">:=</span> <span class="token operator">*</span>user</span>
<span class="line">        users <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>users<span class="token punctuation">,</span> <span class="token operator">&amp;</span>userCopy<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> users<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 字符串构建优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">BuildQuery</span><span class="token punctuation">(</span>conditions <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>conditions<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token string">""</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 预分配容量，避免多次内存分配</span></span>
<span class="line">    <span class="token keyword">var</span> builder strings<span class="token punctuation">.</span>Builder</span>
<span class="line">    builder<span class="token punctuation">.</span><span class="token function">Grow</span><span class="token punctuation">(</span><span class="token function">len</span><span class="token punctuation">(</span>conditions<span class="token punctuation">)</span> <span class="token operator">*</span> <span class="token number">20</span><span class="token punctuation">)</span> <span class="token comment">// 估算总长度</span></span>
<span class="line">    </span>
<span class="line">    builder<span class="token punctuation">.</span><span class="token function">WriteString</span><span class="token punctuation">(</span><span class="token string">"SELECT * FROM users WHERE "</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> condition <span class="token operator">:=</span> <span class="token keyword">range</span> conditions <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> i <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">            builder<span class="token punctuation">.</span><span class="token function">WriteString</span><span class="token punctuation">(</span><span class="token string">" AND "</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        builder<span class="token punctuation">.</span><span class="token function">WriteString</span><span class="token punctuation">(</span>condition<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> builder<span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 切片预分配优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">ProcessLargeDataset</span><span class="token punctuation">(</span>data <span class="token punctuation">[</span><span class="token punctuation">]</span>DataItem<span class="token punctuation">)</span> <span class="token punctuation">[</span><span class="token punctuation">]</span>ProcessedItem <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 预分配切片容量，避免动态扩容</span></span>
<span class="line">    result <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span>ProcessedItem<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>data<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> item <span class="token operator">:=</span> <span class="token keyword">range</span> data <span class="token punctuation">{</span></span>
<span class="line">        processed <span class="token operator">:=</span> <span class="token function">ProcessItem</span><span class="token punctuation">(</span>item<span class="token punctuation">)</span></span>
<span class="line">        result <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>result<span class="token punctuation">,</span> processed<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> result</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 避免不必要的内存分配</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">ValidateUsers</span><span class="token punctuation">(</span>users <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> errors <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">error</span> <span class="token comment">// 延迟分配，只在需要时分配</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> user <span class="token operator">:=</span> <span class="token keyword">range</span> users <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span><span class="token function">validateUser</span><span class="token punctuation">(</span>user<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">if</span> errors <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                errors <span class="token operator">=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">error</span><span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>users<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token comment">// 首次分配</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            errors <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errors<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> errors</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="并发优化" tabindex="-1"><a class="header-anchor" href="#并发优化">#</a> 并发优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 工作池模式</span></span>
<span class="line"><span class="token keyword">type</span> WorkerPool <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    workerCount <span class="token builtin">int</span></span>
<span class="line">    jobQueue    <span class="token keyword">chan</span> Job</span>
<span class="line">    workers     <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>Worker</span>
<span class="line">    wg          sync<span class="token punctuation">.</span>WaitGroup</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Job <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    ID   <span class="token builtin">string</span></span>
<span class="line">    Data <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    Done <span class="token keyword">chan</span> Result</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Result <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Data  <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    Error <span class="token builtin">error</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Worker <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    id       <span class="token builtin">int</span></span>
<span class="line">    jobQueue <span class="token keyword">chan</span> Job</span>
<span class="line">    quit     <span class="token keyword">chan</span> <span class="token builtin">bool</span></span>
<span class="line">    handler  JobHandler</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> JobHandler <span class="token keyword">func</span><span class="token punctuation">(</span>Job<span class="token punctuation">)</span> Result</span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewWorkerPool</span><span class="token punctuation">(</span>workerCount <span class="token builtin">int</span><span class="token punctuation">,</span> queueSize <span class="token builtin">int</span><span class="token punctuation">,</span> handler JobHandler<span class="token punctuation">)</span> <span class="token operator">*</span>WorkerPool <span class="token punctuation">{</span></span>
<span class="line">    pool <span class="token operator">:=</span> <span class="token operator">&amp;</span>WorkerPool<span class="token punctuation">{</span></span>
<span class="line">        workerCount<span class="token punctuation">:</span> workerCount<span class="token punctuation">,</span></span>
<span class="line">        jobQueue<span class="token punctuation">:</span>    <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> Job<span class="token punctuation">,</span> queueSize<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        workers<span class="token punctuation">:</span>     <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>Worker<span class="token punctuation">,</span> workerCount<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建工作者</span></span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> workerCount<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        worker <span class="token operator">:=</span> <span class="token operator">&amp;</span>Worker<span class="token punctuation">{</span></span>
<span class="line">            id<span class="token punctuation">:</span>       i<span class="token punctuation">,</span></span>
<span class="line">            jobQueue<span class="token punctuation">:</span> pool<span class="token punctuation">.</span>jobQueue<span class="token punctuation">,</span></span>
<span class="line">            quit<span class="token punctuation">:</span>     <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> <span class="token builtin">bool</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            handler<span class="token punctuation">:</span>  handler<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        pool<span class="token punctuation">.</span>workers<span class="token punctuation">[</span>i<span class="token punctuation">]</span> <span class="token operator">=</span> worker</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> pool</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>WorkerPool<span class="token punctuation">)</span> <span class="token function">Start</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> worker <span class="token operator">:=</span> <span class="token keyword">range</span> p<span class="token punctuation">.</span>workers <span class="token punctuation">{</span></span>
<span class="line">        p<span class="token punctuation">.</span>wg<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">go</span> worker<span class="token punctuation">.</span><span class="token function">start</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>p<span class="token punctuation">.</span>wg<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>WorkerPool<span class="token punctuation">)</span> <span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> worker <span class="token operator">:=</span> <span class="token keyword">range</span> p<span class="token punctuation">.</span>workers <span class="token punctuation">{</span></span>
<span class="line">        worker<span class="token punctuation">.</span>quit <span class="token operator">&lt;-</span> <span class="token boolean">true</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    p<span class="token punctuation">.</span>wg<span class="token punctuation">.</span><span class="token function">Wait</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>WorkerPool<span class="token punctuation">)</span> <span class="token function">Submit</span><span class="token punctuation">(</span>job Job<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>jobQueue <span class="token operator">&lt;-</span> job</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>w <span class="token operator">*</span>Worker<span class="token punctuation">)</span> <span class="token function">start</span><span class="token punctuation">(</span>wg <span class="token operator">*</span>sync<span class="token punctuation">.</span>WaitGroup<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">defer</span> wg<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">case</span> job <span class="token operator">:=</span> <span class="token operator">&lt;-</span>w<span class="token punctuation">.</span>jobQueue<span class="token punctuation">:</span></span>
<span class="line">            result <span class="token operator">:=</span> w<span class="token punctuation">.</span><span class="token function">handler</span><span class="token punctuation">(</span>job<span class="token punctuation">)</span></span>
<span class="line">            job<span class="token punctuation">.</span>Done <span class="token operator">&lt;-</span> result</span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>w<span class="token punctuation">.</span>quit<span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">return</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 使用工作池处理批量任务</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token function">ProcessUsersBatch</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userIDs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    workerPool <span class="token operator">:=</span> <span class="token function">NewWorkerPool</span><span class="token punctuation">(</span><span class="token number">10</span><span class="token punctuation">,</span> <span class="token number">100</span><span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>job Job<span class="token punctuation">)</span> Result <span class="token punctuation">{</span></span>
<span class="line">        userID <span class="token operator">:=</span> job<span class="token punctuation">.</span>Data<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span></span>
<span class="line">        user<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>repo<span class="token punctuation">.</span><span class="token function">GetByID</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userID<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">return</span> Result<span class="token punctuation">{</span>Data<span class="token punctuation">:</span> user<span class="token punctuation">,</span> Error<span class="token punctuation">:</span> err<span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    workerPool<span class="token punctuation">.</span><span class="token function">Start</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> workerPool<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 提交任务</span></span>
<span class="line">    results <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">chan</span> Result<span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>userIDs<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> userID <span class="token operator">:=</span> <span class="token keyword">range</span> userIDs <span class="token punctuation">{</span></span>
<span class="line">        done <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> Result<span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        results<span class="token punctuation">[</span>i<span class="token punctuation">]</span> <span class="token operator">=</span> done</span>
<span class="line">        </span>
<span class="line">        job <span class="token operator">:=</span> Job<span class="token punctuation">{</span></span>
<span class="line">            ID<span class="token punctuation">:</span>   userID<span class="token punctuation">,</span></span>
<span class="line">            Data<span class="token punctuation">:</span> userID<span class="token punctuation">,</span></span>
<span class="line">            Done<span class="token punctuation">:</span> done<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        workerPool<span class="token punctuation">.</span><span class="token function">Submit</span><span class="token punctuation">(</span>job<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 收集结果</span></span>
<span class="line">    users <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>userIDs<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> resultChan <span class="token operator">:=</span> <span class="token keyword">range</span> results <span class="token punctuation">{</span></span>
<span class="line">        result <span class="token operator">:=</span> <span class="token operator">&lt;-</span>resultChan</span>
<span class="line">        <span class="token keyword">if</span> result<span class="token punctuation">.</span>Error <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> result<span class="token punctuation">.</span>Error</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        users <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>users<span class="token punctuation">,</span> result<span class="token punctuation">.</span>Data<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> users<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 限流器</span></span>
<span class="line"><span class="token keyword">type</span> RateLimiter <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    tokens <span class="token keyword">chan</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    ticker <span class="token operator">*</span>time<span class="token punctuation">.</span>Ticker</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewRateLimiter</span><span class="token punctuation">(</span>rate <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token operator">*</span>RateLimiter <span class="token punctuation">{</span></span>
<span class="line">    rl <span class="token operator">:=</span> <span class="token operator">&amp;</span>RateLimiter<span class="token punctuation">{</span></span>
<span class="line">        tokens<span class="token punctuation">:</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> rate<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        ticker<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">NewTicker</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>Second <span class="token operator">/</span> time<span class="token punctuation">.</span><span class="token function">Duration</span><span class="token punctuation">(</span>rate<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 初始填充令牌</span></span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> rate<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        rl<span class="token punctuation">.</span>tokens <span class="token operator">&lt;-</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 定期添加令牌</span></span>
<span class="line">    <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">for</span> <span class="token keyword">range</span> rl<span class="token punctuation">.</span>ticker<span class="token punctuation">.</span>C <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">case</span> rl<span class="token punctuation">.</span>tokens <span class="token operator">&lt;-</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">default</span><span class="token punctuation">:</span></span>
<span class="line">                <span class="token comment">// 令牌桶已满</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> rl</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>rl <span class="token operator">*</span>RateLimiter<span class="token punctuation">)</span> <span class="token function">Wait</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">case</span> <span class="token operator">&lt;-</span>rl<span class="token punctuation">.</span>tokens<span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ctx<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token keyword">return</span> ctx<span class="token punctuation">.</span><span class="token function">Err</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>rl <span class="token operator">*</span>RateLimiter<span class="token punctuation">)</span> <span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    rl<span class="token punctuation">.</span>ticker<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-http服务优化" tabindex="-1"><a class="header-anchor" href="#_2-http服务优化">#</a> 2. HTTP服务优化</h3>
<h4 id="连接池优化" tabindex="-1"><a class="header-anchor" href="#连接池优化">#</a> 连接池优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> http</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"net"</span></span>
<span class="line">    <span class="token string">"net/http"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// HTTP客户端优化配置</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedHTTPClient</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>http<span class="token punctuation">.</span>Client <span class="token punctuation">{</span></span>
<span class="line">    transport <span class="token operator">:=</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Transport<span class="token punctuation">{</span></span>
<span class="line">        <span class="token comment">// 连接池配置</span></span>
<span class="line">        MaxIdleConns<span class="token punctuation">:</span>        <span class="token number">100</span><span class="token punctuation">,</span>              <span class="token comment">// 最大空闲连接数</span></span>
<span class="line">        MaxIdleConnsPerHost<span class="token punctuation">:</span> <span class="token number">20</span><span class="token punctuation">,</span>               <span class="token comment">// 每个主机最大空闲连接数</span></span>
<span class="line">        MaxConnsPerHost<span class="token punctuation">:</span>     <span class="token number">50</span><span class="token punctuation">,</span>               <span class="token comment">// 每个主机最大连接数</span></span>
<span class="line">        IdleConnTimeout<span class="token punctuation">:</span>     <span class="token number">90</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 空闲连接超时</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// TCP配置</span></span>
<span class="line">        DialContext<span class="token punctuation">:</span> <span class="token punctuation">(</span><span class="token operator">&amp;</span>net<span class="token punctuation">.</span>Dialer<span class="token punctuation">{</span></span>
<span class="line">            Timeout<span class="token punctuation">:</span>   <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 连接超时</span></span>
<span class="line">            KeepAlive<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// Keep-Alive间隔</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">.</span>DialContext<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// TLS配置</span></span>
<span class="line">        TLSHandshakeTimeout<span class="token punctuation">:</span>   <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        ResponseHeaderTimeout<span class="token punctuation">:</span> <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        ExpectContinueTimeout<span class="token punctuation">:</span> <span class="token number">1</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 禁用HTTP/2（如果需要）</span></span>
<span class="line">        ForceAttemptHTTP2<span class="token punctuation">:</span> <span class="token boolean">false</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Client<span class="token punctuation">{</span></span>
<span class="line">        Transport<span class="token punctuation">:</span> transport<span class="token punctuation">,</span></span>
<span class="line">        Timeout<span class="token punctuation">:</span>   <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 总超时时间</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// HTTP服务器优化配置</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedHTTPServer</span><span class="token punctuation">(</span>handler http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> <span class="token operator">*</span>http<span class="token punctuation">.</span>Server <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Server<span class="token punctuation">{</span></span>
<span class="line">        Handler<span class="token punctuation">:</span> handler<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 超时配置</span></span>
<span class="line">        ReadTimeout<span class="token punctuation">:</span>       <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        ReadHeaderTimeout<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        WriteTimeout<span class="token punctuation">:</span>      <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        IdleTimeout<span class="token punctuation">:</span>       <span class="token number">120</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 缓冲区大小</span></span>
<span class="line">        MaxHeaderBytes<span class="token punctuation">:</span> <span class="token number">1</span> <span class="token operator">&lt;&lt;</span> <span class="token number">20</span><span class="token punctuation">,</span> <span class="token comment">// 1MB</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 响应压缩中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">CompressionMiddleware</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 检查客户端是否支持压缩</span></span>
<span class="line">            <span class="token keyword">if</span> <span class="token operator">!</span>strings<span class="token punctuation">.</span><span class="token function">Contains</span><span class="token punctuation">(</span>r<span class="token punctuation">.</span>Header<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token string">"Accept-Encoding"</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">"gzip"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>w<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">return</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 设置压缩响应头</span></span>
<span class="line">            w<span class="token punctuation">.</span><span class="token function">Header</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Content-Encoding"</span><span class="token punctuation">,</span> <span class="token string">"gzip"</span><span class="token punctuation">)</span></span>
<span class="line">            w<span class="token punctuation">.</span><span class="token function">Header</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Vary"</span><span class="token punctuation">,</span> <span class="token string">"Accept-Encoding"</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 创建gzip写入器</span></span>
<span class="line">            gz <span class="token operator">:=</span> gzip<span class="token punctuation">.</span><span class="token function">NewWriter</span><span class="token punctuation">(</span>w<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">defer</span> gz<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 包装响应写入器</span></span>
<span class="line">            gzw <span class="token operator">:=</span> <span class="token operator">&amp;</span>gzipResponseWriter<span class="token punctuation">{</span></span>
<span class="line">                ResponseWriter<span class="token punctuation">:</span> w<span class="token punctuation">,</span></span>
<span class="line">                Writer<span class="token punctuation">:</span>         gz<span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>gzw<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> gzipResponseWriter <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    http<span class="token punctuation">.</span>ResponseWriter</span>
<span class="line">    io<span class="token punctuation">.</span>Writer</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>w <span class="token operator">*</span>gzipResponseWriter<span class="token punctuation">)</span> <span class="token function">Write</span><span class="token punctuation">(</span>b <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token builtin">int</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> w<span class="token punctuation">.</span>Writer<span class="token punctuation">.</span><span class="token function">Write</span><span class="token punctuation">(</span>b<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="缓存优化" tabindex="-1"><a class="header-anchor" href="#缓存优化">#</a> 缓存优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 多级缓存实现</span></span>
<span class="line"><span class="token keyword">type</span> MultiLevelCache <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    l1 <span class="token operator">*</span>sync<span class="token punctuation">.</span>Map           <span class="token comment">// 内存缓存</span></span>
<span class="line">    l2 <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client       <span class="token comment">// Redis缓存</span></span>
<span class="line">    l3 Database            <span class="token comment">// 数据库</span></span>
<span class="line">    </span>
<span class="line">    l1TTL time<span class="token punctuation">.</span>Duration</span>
<span class="line">    l2TTL time<span class="token punctuation">.</span>Duration</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> CacheItem <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Data      <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    ExpiresAt time<span class="token punctuation">.</span>Time</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewMultiLevelCache</span><span class="token punctuation">(</span>redisClient <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client<span class="token punctuation">,</span> db Database<span class="token punctuation">)</span> <span class="token operator">*</span>MultiLevelCache <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>MultiLevelCache<span class="token punctuation">{</span></span>
<span class="line">        l1<span class="token punctuation">:</span>    <span class="token operator">&amp;</span>sync<span class="token punctuation">.</span>Map<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        l2<span class="token punctuation">:</span>    redisClient<span class="token punctuation">,</span></span>
<span class="line">        l3<span class="token punctuation">:</span>    db<span class="token punctuation">,</span></span>
<span class="line">        l1TTL<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span></span>
<span class="line">        l2TTL<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">Get</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// L1缓存查询</span></span>
<span class="line">    <span class="token keyword">if</span> item<span class="token punctuation">,</span> ok <span class="token operator">:=</span> c<span class="token punctuation">.</span>l1<span class="token punctuation">.</span><span class="token function">Load</span><span class="token punctuation">(</span>key<span class="token punctuation">)</span><span class="token punctuation">;</span> ok <span class="token punctuation">{</span></span>
<span class="line">        cacheItem <span class="token operator">:=</span> item<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>CacheItem<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Before</span><span class="token punctuation">(</span>cacheItem<span class="token punctuation">.</span>ExpiresAt<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> cacheItem<span class="token punctuation">.</span>Data<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        c<span class="token punctuation">.</span>l1<span class="token punctuation">.</span><span class="token function">Delete</span><span class="token punctuation">(</span>key<span class="token punctuation">)</span> <span class="token comment">// 删除过期项</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// L2缓存查询</span></span>
<span class="line">    data<span class="token punctuation">,</span> err <span class="token operator">:=</span> c<span class="token punctuation">.</span>l2<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Bytes</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">var</span> value <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Unmarshal</span><span class="token punctuation">(</span>data<span class="token punctuation">,</span> <span class="token operator">&amp;</span>value<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 回填L1缓存</span></span>
<span class="line">            c<span class="token punctuation">.</span><span class="token function">setL1</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">return</span> value<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// L3数据库查询</span></span>
<span class="line">    value<span class="token punctuation">,</span> err <span class="token operator">:=</span> c<span class="token punctuation">.</span>l3<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 回填缓存</span></span>
<span class="line">    <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        c<span class="token punctuation">.</span><span class="token function">setL1</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">        c<span class="token punctuation">.</span><span class="token function">setL2</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> value<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">Set</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">,</span> value <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 同时设置所有缓存层</span></span>
<span class="line">    c<span class="token punctuation">.</span><span class="token function">setL1</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> c<span class="token punctuation">.</span><span class="token function">setL2</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">,</span> value<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">setL1</span><span class="token punctuation">(</span>key <span class="token builtin">string</span><span class="token punctuation">,</span> value <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    item <span class="token operator">:=</span> <span class="token operator">&amp;</span>CacheItem<span class="token punctuation">{</span></span>
<span class="line">        Data<span class="token punctuation">:</span>      value<span class="token punctuation">,</span></span>
<span class="line">        ExpiresAt<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span>c<span class="token punctuation">.</span>l1TTL<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    c<span class="token punctuation">.</span>l1<span class="token punctuation">.</span><span class="token function">Store</span><span class="token punctuation">(</span>key<span class="token punctuation">,</span> item<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">setL2</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> key <span class="token builtin">string</span><span class="token punctuation">,</span> value <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    data<span class="token punctuation">,</span> err <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>value<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">return</span> c<span class="token punctuation">.</span>l2<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">,</span> data<span class="token punctuation">,</span> c<span class="token punctuation">.</span>l2TTL<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Err</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 缓存预热</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>MultiLevelCache<span class="token punctuation">)</span> <span class="token function">Warmup</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> keys <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 并发预热</span></span>
<span class="line">    sem <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token number">10</span><span class="token punctuation">)</span> <span class="token comment">// 限制并发数</span></span>
<span class="line">    <span class="token keyword">var</span> wg sync<span class="token punctuation">.</span>WaitGroup</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> key <span class="token operator">:=</span> <span class="token keyword">range</span> keys <span class="token punctuation">{</span></span>
<span class="line">        wg<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span>k <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">defer</span> wg<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            sem <span class="token operator">&lt;-</span> <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">            <span class="token keyword">defer</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span> <span class="token operator">&lt;-</span>sem <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token boolean">_</span><span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">=</span> c<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> k<span class="token punctuation">)</span> <span class="token comment">// 忽略错误，继续预热其他键</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">(</span>key<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    wg<span class="token punctuation">.</span><span class="token function">Wait</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🗄️-数据库优化" tabindex="-1"><a class="header-anchor" href="#🗄️-数据库优化">#</a> 🗄️ 数据库优化</h2>
<h3 id="_1-postgresql优化" tabindex="-1"><a class="header-anchor" href="#_1-postgresql优化">#</a> 1. PostgreSQL优化</h3>
<h4 id="连接池优化-1" tabindex="-1"><a class="header-anchor" href="#连接池优化-1">#</a> 连接池优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> database</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"database/sql"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token boolean">_</span> <span class="token string">"github.com/lib/pq"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 数据库连接池配置</span></span>
<span class="line"><span class="token keyword">type</span> DBConfig <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Host            <span class="token builtin">string</span>        <span class="token string">`json:"host"`</span></span>
<span class="line">    Port            <span class="token builtin">int</span>           <span class="token string">`json:"port"`</span></span>
<span class="line">    Database        <span class="token builtin">string</span>        <span class="token string">`json:"database"`</span></span>
<span class="line">    Username        <span class="token builtin">string</span>        <span class="token string">`json:"username"`</span></span>
<span class="line">    Password        <span class="token builtin">string</span>        <span class="token string">`json:"password"`</span></span>
<span class="line">    MaxOpenConns    <span class="token builtin">int</span>           <span class="token string">`json:"max_open_conns"`</span></span>
<span class="line">    MaxIdleConns    <span class="token builtin">int</span>           <span class="token string">`json:"max_idle_conns"`</span></span>
<span class="line">    ConnMaxLifetime time<span class="token punctuation">.</span>Duration <span class="token string">`json:"conn_max_lifetime"`</span></span>
<span class="line">    ConnMaxIdleTime time<span class="token punctuation">.</span>Duration <span class="token string">`json:"conn_max_idle_time"`</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedDB</span><span class="token punctuation">(</span>cfg DBConfig<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>sql<span class="token punctuation">.</span>DB<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    dsn <span class="token operator">:=</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span></span>
<span class="line">        <span class="token string">"host=%s port=%d dbname=%s user=%s password=%s sslmode=disable"</span><span class="token punctuation">,</span></span>
<span class="line">        cfg<span class="token punctuation">.</span>Host<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>Port<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>Database<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> cfg<span class="token punctuation">.</span>Password<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    db<span class="token punctuation">,</span> err <span class="token operator">:=</span> sql<span class="token punctuation">.</span><span class="token function">Open</span><span class="token punctuation">(</span><span class="token string">"postgres"</span><span class="token punctuation">,</span> dsn<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 连接池配置</span></span>
<span class="line">    db<span class="token punctuation">.</span><span class="token function">SetMaxOpenConns</span><span class="token punctuation">(</span>cfg<span class="token punctuation">.</span>MaxOpenConns<span class="token punctuation">)</span>       <span class="token comment">// 最大打开连接数</span></span>
<span class="line">    db<span class="token punctuation">.</span><span class="token function">SetMaxIdleConns</span><span class="token punctuation">(</span>cfg<span class="token punctuation">.</span>MaxIdleConns<span class="token punctuation">)</span>       <span class="token comment">// 最大空闲连接数</span></span>
<span class="line">    db<span class="token punctuation">.</span><span class="token function">SetConnMaxLifetime</span><span class="token punctuation">(</span>cfg<span class="token punctuation">.</span>ConnMaxLifetime<span class="token punctuation">)</span> <span class="token comment">// 连接最大生存时间</span></span>
<span class="line">    db<span class="token punctuation">.</span><span class="token function">SetConnMaxIdleTime</span><span class="token punctuation">(</span>cfg<span class="token punctuation">.</span>ConnMaxIdleTime<span class="token punctuation">)</span> <span class="token comment">// 连接最大空闲时间</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 测试连接</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> db<span class="token punctuation">.</span><span class="token function">Ping</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> db<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 默认优化配置</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">DefaultDBConfig</span><span class="token punctuation">(</span><span class="token punctuation">)</span> DBConfig <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> DBConfig<span class="token punctuation">{</span></span>
<span class="line">        MaxOpenConns<span class="token punctuation">:</span>    <span class="token number">25</span><span class="token punctuation">,</span>                <span class="token comment">// 最大打开连接数</span></span>
<span class="line">        MaxIdleConns<span class="token punctuation">:</span>    <span class="token number">5</span><span class="token punctuation">,</span>                 <span class="token comment">// 最大空闲连接数</span></span>
<span class="line">        ConnMaxLifetime<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span>  <span class="token comment">// 连接最大生存时间</span></span>
<span class="line">        ConnMaxIdleTime<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span>   <span class="token comment">// 连接最大空闲时间</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="查询优化" tabindex="-1"><a class="header-anchor" href="#查询优化">#</a> 查询优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 批量查询优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>r <span class="token operator">*</span>UserRepository<span class="token punctuation">)</span> <span class="token function">GetUsersByIDs</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> ids <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>ids<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 使用ANY操作符进行批量查询</span></span>
<span class="line">    query <span class="token operator">:=</span> <span class="token string">`</span>
<span class="line">        SELECT id, username, email, created_at </span>
<span class="line">        FROM users </span>
<span class="line">        WHERE id = ANY($1) AND deleted_at IS NULL</span>
<span class="line">        ORDER BY created_at DESC</span>
<span class="line">    `</span></span>
<span class="line">    </span>
<span class="line">    rows<span class="token punctuation">,</span> err <span class="token operator">:=</span> r<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">QueryContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> query<span class="token punctuation">,</span> pq<span class="token punctuation">.</span><span class="token function">Array</span><span class="token punctuation">(</span>ids<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to query users: %w"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> rows<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    users <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>ids<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> rows<span class="token punctuation">.</span><span class="token function">Next</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">var</span> user User</span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> rows<span class="token punctuation">.</span><span class="token function">Scan</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>user<span class="token punctuation">.</span>ID<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Email<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>CreatedAt<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to scan user: %w"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        users <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>users<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> users<span class="token punctuation">,</span> rows<span class="token punctuation">.</span><span class="token function">Err</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 分页查询优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>r <span class="token operator">*</span>UserRepository<span class="token punctuation">)</span> <span class="token function">ListUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> opts ListOptions<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>UserList<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 使用游标分页而不是OFFSET</span></span>
<span class="line">    <span class="token keyword">var</span> query <span class="token builtin">string</span></span>
<span class="line">    <span class="token keyword">var</span> args <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> opts<span class="token punctuation">.</span>Cursor <span class="token operator">!=</span> <span class="token string">""</span> <span class="token punctuation">{</span></span>
<span class="line">        query <span class="token operator">=</span> <span class="token string">`</span>
<span class="line">            SELECT id, username, email, created_at </span>
<span class="line">            FROM users </span>
<span class="line">            WHERE created_at &lt; $1 AND deleted_at IS NULL</span>
<span class="line">            ORDER BY created_at DESC </span>
<span class="line">            LIMIT $2</span>
<span class="line">        `</span></span>
<span class="line">        </span>
<span class="line">        cursorTime<span class="token punctuation">,</span> err <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Parse</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>RFC3339<span class="token punctuation">,</span> opts<span class="token punctuation">.</span>Cursor<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"invalid cursor: %w"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        args <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span>cursorTime<span class="token punctuation">,</span> opts<span class="token punctuation">.</span>Limit<span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span> <span class="token keyword">else</span> <span class="token punctuation">{</span></span>
<span class="line">        query <span class="token operator">=</span> <span class="token string">`</span>
<span class="line">            SELECT id, username, email, created_at </span>
<span class="line">            FROM users </span>
<span class="line">            WHERE deleted_at IS NULL</span>
<span class="line">            ORDER BY created_at DESC </span>
<span class="line">            LIMIT $1</span>
<span class="line">        `</span></span>
<span class="line">        args <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span>opts<span class="token punctuation">.</span>Limit<span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    rows<span class="token punctuation">,</span> err <span class="token operator">:=</span> r<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">QueryContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> query<span class="token punctuation">,</span> args<span class="token operator">...</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to query users: %w"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> rows<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    users <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token number">0</span><span class="token punctuation">,</span> opts<span class="token punctuation">.</span>Limit<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> rows<span class="token punctuation">.</span><span class="token function">Next</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">var</span> user User</span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> rows<span class="token punctuation">.</span><span class="token function">Scan</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>user<span class="token punctuation">.</span>ID<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>Email<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">.</span>CreatedAt<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to scan user: %w"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        users <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>users<span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 计算下一页游标</span></span>
<span class="line">    <span class="token keyword">var</span> nextCursor <span class="token builtin">string</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>users<span class="token punctuation">)</span> <span class="token operator">==</span> opts<span class="token punctuation">.</span>Limit <span class="token punctuation">{</span></span>
<span class="line">        nextCursor <span class="token operator">=</span> users<span class="token punctuation">[</span><span class="token function">len</span><span class="token punctuation">(</span>users<span class="token punctuation">)</span><span class="token operator">-</span><span class="token number">1</span><span class="token punctuation">]</span><span class="token punctuation">.</span>CreatedAt<span class="token punctuation">.</span><span class="token function">Format</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>RFC3339<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>UserList<span class="token punctuation">{</span></span>
<span class="line">        Users<span class="token punctuation">:</span>      users<span class="token punctuation">,</span></span>
<span class="line">        NextCursor<span class="token punctuation">:</span> nextCursor<span class="token punctuation">,</span></span>
<span class="line">        HasMore<span class="token punctuation">:</span>    nextCursor <span class="token operator">!=</span> <span class="token string">""</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">,</span> rows<span class="token punctuation">.</span><span class="token function">Err</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 预编译语句优化</span></span>
<span class="line"><span class="token keyword">type</span> PreparedStatements <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    getUserByID    <span class="token operator">*</span>sql<span class="token punctuation">.</span>Stmt</span>
<span class="line">    createUser     <span class="token operator">*</span>sql<span class="token punctuation">.</span>Stmt</span>
<span class="line">    updateUser     <span class="token operator">*</span>sql<span class="token punctuation">.</span>Stmt</span>
<span class="line">    deleteUser     <span class="token operator">*</span>sql<span class="token punctuation">.</span>Stmt</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewPreparedStatements</span><span class="token punctuation">(</span>db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>PreparedStatements<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ps <span class="token operator">:=</span> <span class="token operator">&amp;</span>PreparedStatements<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> err <span class="token builtin">error</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 预编译常用查询</span></span>
<span class="line">    ps<span class="token punctuation">.</span>getUserByID<span class="token punctuation">,</span> err <span class="token operator">=</span> db<span class="token punctuation">.</span><span class="token function">Prepare</span><span class="token punctuation">(</span><span class="token string">`</span>
<span class="line">        SELECT id, username, email, created_at </span>
<span class="line">        FROM users </span>
<span class="line">        WHERE id = $1 AND deleted_at IS NULL</span>
<span class="line">    `</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    ps<span class="token punctuation">.</span>createUser<span class="token punctuation">,</span> err <span class="token operator">=</span> db<span class="token punctuation">.</span><span class="token function">Prepare</span><span class="token punctuation">(</span><span class="token string">`</span>
<span class="line">        INSERT INTO users (id, username, email, created_at) </span>
<span class="line">        VALUES ($1, $2, $3, $4)</span>
<span class="line">    `</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    ps<span class="token punctuation">.</span>updateUser<span class="token punctuation">,</span> err <span class="token operator">=</span> db<span class="token punctuation">.</span><span class="token function">Prepare</span><span class="token punctuation">(</span><span class="token string">`</span>
<span class="line">        UPDATE users </span>
<span class="line">        SET username = $2, email = $3, updated_at = $4 </span>
<span class="line">        WHERE id = $1 AND deleted_at IS NULL</span>
<span class="line">    `</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    ps<span class="token punctuation">.</span>deleteUser<span class="token punctuation">,</span> err <span class="token operator">=</span> db<span class="token punctuation">.</span><span class="token function">Prepare</span><span class="token punctuation">(</span><span class="token string">`</span>
<span class="line">        UPDATE users </span>
<span class="line">        SET deleted_at = $2 </span>
<span class="line">        WHERE id = $1 AND deleted_at IS NULL</span>
<span class="line">    `</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> ps<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>ps <span class="token operator">*</span>PreparedStatements<span class="token punctuation">)</span> <span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> errs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">error</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> ps<span class="token punctuation">.</span>getUserByID<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        errs <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errs<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> ps<span class="token punctuation">.</span>createUser<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        errs <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errs<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> ps<span class="token punctuation">.</span>updateUser<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        errs <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errs<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">:=</span> ps<span class="token punctuation">.</span>deleteUser<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        errs <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errs<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>errs<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to close prepared statements: %v"</span><span class="token punctuation">,</span> errs<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="索引优化" tabindex="-1"><a class="header-anchor" href="#索引优化">#</a> 索引优化</h4>
<div class="language-sql line-numbers-mode" data-highlighter="prismjs" data-ext="sql"><pre v-pre><code class="language-sql"><span class="line"><span class="token comment">-- 用户表索引优化</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 主键索引（自动创建）</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">UNIQUE</span> <span class="token keyword">INDEX</span> users_pkey <span class="token keyword">ON</span> users <span class="token punctuation">(</span>id<span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 唯一索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">UNIQUE</span> <span class="token keyword">INDEX</span> users_username_key <span class="token keyword">ON</span> users <span class="token punctuation">(</span>username<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">UNIQUE</span> <span class="token keyword">INDEX</span> users_email_key <span class="token keyword">ON</span> users <span class="token punctuation">(</span>email<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 复合索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> users_status_created_at_idx <span class="token keyword">ON</span> users <span class="token punctuation">(</span><span class="token keyword">status</span><span class="token punctuation">,</span> created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> users_created_at_idx <span class="token keyword">ON</span> users <span class="token punctuation">(</span>created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 部分索引（只索引活跃用户）</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> users_active_username_idx <span class="token keyword">ON</span> users <span class="token punctuation">(</span>username<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> <span class="token keyword">status</span> <span class="token operator">=</span> <span class="token string">'active'</span> <span class="token operator">AND</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 表达式索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> users_email_lower_idx <span class="token keyword">ON</span> users <span class="token punctuation">(</span>LOWER<span class="token punctuation">(</span>email<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 策略表索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> policies_user_id_idx <span class="token keyword">ON</span> policies <span class="token punctuation">(</span>user_id<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> policies_name_idx <span class="token keyword">ON</span> policies <span class="token punctuation">(</span>name<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> policies_status_created_at_idx <span class="token keyword">ON</span> policies <span class="token punctuation">(</span><span class="token keyword">status</span><span class="token punctuation">,</span> created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 访问密钥表索引</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">UNIQUE</span> <span class="token keyword">INDEX</span> access_keys_access_key_id_key <span class="token keyword">ON</span> access_keys <span class="token punctuation">(</span>access_key_id<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> access_keys_user_id_idx <span class="token keyword">ON</span> access_keys <span class="token punctuation">(</span>user_id<span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> access_keys_status_idx <span class="token keyword">ON</span> access_keys <span class="token punctuation">(</span><span class="token keyword">status</span><span class="token punctuation">)</span> <span class="token keyword">WHERE</span> deleted_at <span class="token operator">IS</span> <span class="token boolean">NULL</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 审计日志表索引（时间序列优化）</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> audit_logs_user_id_created_at_idx <span class="token keyword">ON</span> audit_logs <span class="token punctuation">(</span>user_id<span class="token punctuation">,</span> created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> audit_logs_action_created_at_idx <span class="token keyword">ON</span> audit_logs <span class="token punctuation">(</span><span class="token keyword">action</span><span class="token punctuation">,</span> created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">INDEX</span> audit_logs_created_at_idx <span class="token keyword">ON</span> audit_logs <span class="token punctuation">(</span>created_at <span class="token keyword">DESC</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">-- 分区表（按时间分区）</span></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> audit_logs_2024_01 <span class="token keyword">PARTITION</span> <span class="token keyword">OF</span> audit_logs </span>
<span class="line"><span class="token keyword">FOR</span> <span class="token keyword">VALUES</span> <span class="token keyword">FROM</span> <span class="token punctuation">(</span><span class="token string">'2024-01-01'</span><span class="token punctuation">)</span> <span class="token keyword">TO</span> <span class="token punctuation">(</span><span class="token string">'2024-02-01'</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">CREATE</span> <span class="token keyword">TABLE</span> audit_logs_2024_02 <span class="token keyword">PARTITION</span> <span class="token keyword">OF</span> audit_logs </span>
<span class="line"><span class="token keyword">FOR</span> <span class="token keyword">VALUES</span> <span class="token keyword">FROM</span> <span class="token punctuation">(</span><span class="token string">'2024-02-01'</span><span class="token punctuation">)</span> <span class="token keyword">TO</span> <span class="token punctuation">(</span><span class="token string">'2024-03-01'</span><span class="token punctuation">)</span><span class="token punctuation">;</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-redis优化" tabindex="-1"><a class="header-anchor" href="#_2-redis优化">#</a> 2. Redis优化</h3>
<h4 id="redis配置优化" tabindex="-1"><a class="header-anchor" href="#redis配置优化">#</a> Redis配置优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> cache</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/redis/go-redis/v9"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Redis配置优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedRedisClient</span><span class="token punctuation">(</span>addr<span class="token punctuation">,</span> password <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> redis<span class="token punctuation">.</span><span class="token function">NewClient</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>redis<span class="token punctuation">.</span>Options<span class="token punctuation">{</span></span>
<span class="line">        Addr<span class="token punctuation">:</span>     addr<span class="token punctuation">,</span></span>
<span class="line">        Password<span class="token punctuation">:</span> password<span class="token punctuation">,</span></span>
<span class="line">        DB<span class="token punctuation">:</span>       <span class="token number">0</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 连接池配置</span></span>
<span class="line">        PoolSize<span class="token punctuation">:</span>        <span class="token number">20</span><span class="token punctuation">,</span>               <span class="token comment">// 连接池大小</span></span>
<span class="line">        MinIdleConns<span class="token punctuation">:</span>    <span class="token number">5</span><span class="token punctuation">,</span>                <span class="token comment">// 最小空闲连接数</span></span>
<span class="line">        MaxIdleConns<span class="token punctuation">:</span>    <span class="token number">10</span><span class="token punctuation">,</span>               <span class="token comment">// 最大空闲连接数</span></span>
<span class="line">        ConnMaxIdleTime<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span>  <span class="token comment">// 连接最大空闲时间</span></span>
<span class="line">        ConnMaxLifetime<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span> <span class="token comment">// 连接最大生存时间</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 超时配置</span></span>
<span class="line">        DialTimeout<span class="token punctuation">:</span>  <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        ReadTimeout<span class="token punctuation">:</span>  <span class="token number">3</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        WriteTimeout<span class="token punctuation">:</span> <span class="token number">3</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 重试配置</span></span>
<span class="line">        MaxRetries<span class="token punctuation">:</span>      <span class="token number">3</span><span class="token punctuation">,</span></span>
<span class="line">        MinRetryBackoff<span class="token punctuation">:</span> <span class="token number">8</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Millisecond<span class="token punctuation">,</span></span>
<span class="line">        MaxRetryBackoff<span class="token punctuation">:</span> <span class="token number">512</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Millisecond<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// Redis集群配置</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedRedisCluster</span><span class="token punctuation">(</span>addrs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">,</span> password <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>redis<span class="token punctuation">.</span>ClusterClient <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> redis<span class="token punctuation">.</span><span class="token function">NewClusterClient</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>redis<span class="token punctuation">.</span>ClusterOptions<span class="token punctuation">{</span></span>
<span class="line">        Addrs<span class="token punctuation">:</span>    addrs<span class="token punctuation">,</span></span>
<span class="line">        Password<span class="token punctuation">:</span> password<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 连接池配置</span></span>
<span class="line">        PoolSize<span class="token punctuation">:</span>        <span class="token number">20</span><span class="token punctuation">,</span></span>
<span class="line">        MinIdleConns<span class="token punctuation">:</span>    <span class="token number">5</span><span class="token punctuation">,</span></span>
<span class="line">        ConnMaxIdleTime<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span></span>
<span class="line">        ConnMaxLifetime<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Minute<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 超时配置</span></span>
<span class="line">        DialTimeout<span class="token punctuation">:</span>  <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        ReadTimeout<span class="token punctuation">:</span>  <span class="token number">3</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        WriteTimeout<span class="token punctuation">:</span> <span class="token number">3</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 集群配置</span></span>
<span class="line">        MaxRedirects<span class="token punctuation">:</span>   <span class="token number">8</span><span class="token punctuation">,</span></span>
<span class="line">        ReadOnly<span class="token punctuation">:</span>       <span class="token boolean">true</span><span class="token punctuation">,</span>  <span class="token comment">// 允许从从节点读取</span></span>
<span class="line">        RouteByLatency<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span>  <span class="token comment">// 按延迟路由</span></span>
<span class="line">        RouteRandomly<span class="token punctuation">:</span>  <span class="token boolean">false</span><span class="token punctuation">,</span> <span class="token comment">// 不随机路由</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="缓存策略优化" tabindex="-1"><a class="header-anchor" href="#缓存策略优化">#</a> 缓存策略优化</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 缓存键管理</span></span>
<span class="line"><span class="token keyword">type</span> CacheKeyManager <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    prefix <span class="token builtin">string</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewCacheKeyManager</span><span class="token punctuation">(</span>prefix <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>CacheKeyManager <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>CacheKeyManager<span class="token punctuation">{</span>prefix<span class="token punctuation">:</span> prefix<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>CacheKeyManager<span class="token punctuation">)</span> <span class="token function">UserKey</span><span class="token punctuation">(</span>userID <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:user:%s"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>prefix<span class="token punctuation">,</span> userID<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>CacheKeyManager<span class="token punctuation">)</span> <span class="token function">UserListKey</span><span class="token punctuation">(</span>page <span class="token builtin">int</span><span class="token punctuation">,</span> limit <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:users:list:%d:%d"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>prefix<span class="token punctuation">,</span> page<span class="token punctuation">,</span> limit<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>CacheKeyManager<span class="token punctuation">)</span> <span class="token function">PermissionKey</span><span class="token punctuation">(</span>userID<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> action <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">string</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%s:permission:%s:%s:%s"</span><span class="token punctuation">,</span> m<span class="token punctuation">.</span>prefix<span class="token punctuation">,</span> userID<span class="token punctuation">,</span> resource<span class="token punctuation">,</span> action<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 缓存服务优化</span></span>
<span class="line"><span class="token keyword">type</span> CacheService <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    client    <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client</span>
<span class="line">    keyMgr    <span class="token operator">*</span>CacheKeyManager</span>
<span class="line">    serializer Serializer</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Serializer <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">Marshal</span><span class="token punctuation">(</span>v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">Unmarshal</span><span class="token punctuation">(</span>data <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// JSON序列化器</span></span>
<span class="line"><span class="token keyword">type</span> JSONSerializer <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>JSONSerializer<span class="token punctuation">)</span> <span class="token function">Marshal</span><span class="token punctuation">(</span>v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>v<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>JSONSerializer<span class="token punctuation">)</span> <span class="token function">Unmarshal</span><span class="token punctuation">(</span>data <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> json<span class="token punctuation">.</span><span class="token function">Unmarshal</span><span class="token punctuation">(</span>data<span class="token punctuation">,</span> v<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// MessagePack序列化器（更高效）</span></span>
<span class="line"><span class="token keyword">type</span> MsgPackSerializer <span class="token keyword">struct</span><span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>MsgPackSerializer<span class="token punctuation">)</span> <span class="token function">Marshal</span><span class="token punctuation">(</span>v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> msgpack<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>v<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>MsgPackSerializer<span class="token punctuation">)</span> <span class="token function">Unmarshal</span><span class="token punctuation">(</span>data <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">byte</span><span class="token punctuation">,</span> v <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> msgpack<span class="token punctuation">.</span><span class="token function">Unmarshal</span><span class="token punctuation">(</span>data<span class="token punctuation">,</span> v<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewCacheService</span><span class="token punctuation">(</span>client <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client<span class="token punctuation">,</span> keyMgr <span class="token operator">*</span>CacheKeyManager<span class="token punctuation">)</span> <span class="token operator">*</span>CacheService <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>CacheService<span class="token punctuation">{</span></span>
<span class="line">        client<span class="token punctuation">:</span>     client<span class="token punctuation">,</span></span>
<span class="line">        keyMgr<span class="token punctuation">:</span>     keyMgr<span class="token punctuation">,</span></span>
<span class="line">        serializer<span class="token punctuation">:</span> <span class="token operator">&amp;</span>MsgPackSerializer<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token comment">// 使用更高效的序列化器</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 批量操作优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>CacheService<span class="token punctuation">)</span> <span class="token function">GetUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userIDs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>userIDs<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 构建缓存键</span></span>
<span class="line">    keys <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">,</span> <span class="token function">len</span><span class="token punctuation">(</span>userIDs<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> id <span class="token operator">:=</span> <span class="token keyword">range</span> userIDs <span class="token punctuation">{</span></span>
<span class="line">        keys<span class="token punctuation">[</span>i<span class="token punctuation">]</span> <span class="token operator">=</span> s<span class="token punctuation">.</span>keyMgr<span class="token punctuation">.</span><span class="token function">UserKey</span><span class="token punctuation">(</span>id<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 批量获取</span></span>
<span class="line">    values<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">MGet</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> keys<span class="token operator">...</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Result</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 解析结果</span></span>
<span class="line">    users <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">for</span> i<span class="token punctuation">,</span> value <span class="token operator">:=</span> <span class="token keyword">range</span> values <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> value <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">continue</span> <span class="token comment">// 缓存未命中</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">var</span> user User</span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>serializer<span class="token punctuation">.</span><span class="token function">Unmarshal</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token function">byte</span><span class="token punctuation">(</span>value<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token builtin">string</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token operator">&amp;</span>user<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">continue</span> <span class="token comment">// 反序列化失败，跳过</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        users<span class="token punctuation">[</span>userIDs<span class="token punctuation">[</span>i<span class="token punctuation">]</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token operator">&amp;</span>user</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> users<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 管道操作优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>CacheService<span class="token punctuation">)</span> <span class="token function">SetUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> users <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> ttl time<span class="token punctuation">.</span>Duration<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>users<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 使用管道批量设置</span></span>
<span class="line">    pipe <span class="token operator">:=</span> s<span class="token punctuation">.</span>client<span class="token punctuation">.</span><span class="token function">Pipeline</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> userID<span class="token punctuation">,</span> user <span class="token operator">:=</span> <span class="token keyword">range</span> users <span class="token punctuation">{</span></span>
<span class="line">        data<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span>serializer<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>user<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">continue</span> <span class="token comment">// 序列化失败，跳过</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        key <span class="token operator">:=</span> s<span class="token punctuation">.</span>keyMgr<span class="token punctuation">.</span><span class="token function">UserKey</span><span class="token punctuation">(</span>userID<span class="token punctuation">)</span></span>
<span class="line">        pipe<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> key<span class="token punctuation">,</span> data<span class="token punctuation">,</span> ttl<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> pipe<span class="token punctuation">.</span><span class="token function">Exec</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 缓存预热</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>s <span class="token operator">*</span>CacheService<span class="token punctuation">)</span> <span class="token function">WarmupUsers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> userIDs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">,</span> loader <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 检查哪些用户不在缓存中</span></span>
<span class="line">    cached<span class="token punctuation">,</span> err <span class="token operator">:=</span> s<span class="token punctuation">.</span><span class="token function">GetUsers</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> userIDs<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> missing <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> id <span class="token operator">:=</span> <span class="token keyword">range</span> userIDs <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> <span class="token boolean">_</span><span class="token punctuation">,</span> exists <span class="token operator">:=</span> cached<span class="token punctuation">[</span>id<span class="token punctuation">]</span><span class="token punctuation">;</span> <span class="token operator">!</span>exists <span class="token punctuation">{</span></span>
<span class="line">            missing <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>missing<span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>missing<span class="token punctuation">)</span> <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span> <span class="token comment">// 所有数据都已缓存</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 加载缺失的数据</span></span>
<span class="line">    users<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">loader</span><span class="token punctuation">(</span>missing<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 缓存新数据</span></span>
<span class="line">    <span class="token keyword">return</span> s<span class="token punctuation">.</span><span class="token function">SetUsers</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> users<span class="token punctuation">,</span> <span class="token number">30</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Minute<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🌐-网络优化" tabindex="-1"><a class="header-anchor" href="#🌐-网络优化">#</a> 🌐 网络优化</h2>
<h3 id="_1-grpc优化" tabindex="-1"><a class="header-anchor" href="#_1-grpc优化">#</a> 1. gRPC优化</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> grpc</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"google.golang.org/grpc"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/keepalive"</span></span>
<span class="line">    <span class="token string">"google.golang.org/grpc/credentials/insecure"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// gRPC客户端优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedGRPCClient</span><span class="token punctuation">(</span>target <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> grpc<span class="token punctuation">.</span><span class="token function">Dial</span><span class="token punctuation">(</span>target<span class="token punctuation">,</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">WithTransportCredentials</span><span class="token punctuation">(</span>insecure<span class="token punctuation">.</span><span class="token function">NewCredentials</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 连接池配置</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">WithDefaultCallOptions</span><span class="token punctuation">(</span></span>
<span class="line">            grpc<span class="token punctuation">.</span><span class="token function">MaxCallRecvMsgSize</span><span class="token punctuation">(</span><span class="token number">4</span><span class="token operator">*</span><span class="token number">1024</span><span class="token operator">*</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token comment">// 4MB</span></span>
<span class="line">            grpc<span class="token punctuation">.</span><span class="token function">MaxCallSendMsgSize</span><span class="token punctuation">(</span><span class="token number">4</span><span class="token operator">*</span><span class="token number">1024</span><span class="token operator">*</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token comment">// 4MB</span></span>
<span class="line">        <span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// Keep-Alive配置</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">WithKeepaliveParams</span><span class="token punctuation">(</span>keepalive<span class="token punctuation">.</span>ClientParameters<span class="token punctuation">{</span></span>
<span class="line">            Time<span class="token punctuation">:</span>                <span class="token number">10</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 发送keepalive ping的间隔</span></span>
<span class="line">            Timeout<span class="token punctuation">:</span>             <span class="token number">3</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span>  <span class="token comment">// 等待keepalive ping响应的超时</span></span>
<span class="line">            PermitWithoutStream<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span>             <span class="token comment">// 允许在没有活跃流时发送keepalive ping</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 连接状态监控</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">WithBlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">WithTimeout</span><span class="token punctuation">(</span><span class="token number">10</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// gRPC服务器优化</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewOptimizedGRPCServer</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>grpc<span class="token punctuation">.</span>Server <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> grpc<span class="token punctuation">.</span><span class="token function">NewServer</span><span class="token punctuation">(</span></span>
<span class="line">        <span class="token comment">// 消息大小限制</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">MaxRecvMsgSize</span><span class="token punctuation">(</span><span class="token number">4</span><span class="token operator">*</span><span class="token number">1024</span><span class="token operator">*</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token comment">// 4MB</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">MaxSendMsgSize</span><span class="token punctuation">(</span><span class="token number">4</span><span class="token operator">*</span><span class="token number">1024</span><span class="token operator">*</span><span class="token number">1024</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token comment">// 4MB</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// Keep-Alive配置</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">KeepaliveParams</span><span class="token punctuation">(</span>keepalive<span class="token punctuation">.</span>ServerParameters<span class="token punctuation">{</span></span>
<span class="line">            Time<span class="token punctuation">:</span>    <span class="token number">60</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 服务器发送keepalive ping的间隔</span></span>
<span class="line">            Timeout<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span>  <span class="token comment">// 等待keepalive ping响应的超时</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">KeepaliveEnforcementPolicy</span><span class="token punctuation">(</span>keepalive<span class="token punctuation">.</span>EnforcementPolicy<span class="token punctuation">{</span></span>
<span class="line">            MinTime<span class="token punctuation">:</span>             <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span> <span class="token comment">// 客户端发送keepalive ping的最小间隔</span></span>
<span class="line">            PermitWithoutStream<span class="token punctuation">:</span> <span class="token boolean">true</span><span class="token punctuation">,</span>             <span class="token comment">// 允许在没有活跃流时发送keepalive ping</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        </span>
<span class="line">        <span class="token comment">// 连接超时</span></span>
<span class="line">        grpc<span class="token punctuation">.</span><span class="token function">ConnectionTimeout</span><span class="token punctuation">(</span><span class="token number">10</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 连接池管理</span></span>
<span class="line"><span class="token keyword">type</span> GRPCConnectionPool <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    connections <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn</span>
<span class="line">    current     <span class="token builtin">int</span></span>
<span class="line">    mu          sync<span class="token punctuation">.</span>RWMutex</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewGRPCConnectionPool</span><span class="token punctuation">(</span>target <span class="token builtin">string</span><span class="token punctuation">,</span> size <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>GRPCConnectionPool<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    pool <span class="token operator">:=</span> <span class="token operator">&amp;</span>GRPCConnectionPool<span class="token punctuation">{</span></span>
<span class="line">        connections<span class="token punctuation">:</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn<span class="token punctuation">,</span> size<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> size<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        conn<span class="token punctuation">,</span> err <span class="token operator">:=</span> <span class="token function">NewOptimizedGRPCClient</span><span class="token punctuation">(</span>target<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 关闭已创建的连接</span></span>
<span class="line">            <span class="token keyword">for</span> j <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> j <span class="token operator">&lt;</span> i<span class="token punctuation">;</span> j<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">                pool<span class="token punctuation">.</span>connections<span class="token punctuation">[</span>j<span class="token punctuation">]</span><span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        pool<span class="token punctuation">.</span>connections<span class="token punctuation">[</span>i<span class="token punctuation">]</span> <span class="token operator">=</span> conn</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> pool<span class="token punctuation">,</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>GRPCConnectionPool<span class="token punctuation">)</span> <span class="token function">GetConnection</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>grpc<span class="token punctuation">.</span>ClientConn <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> p<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    conn <span class="token operator">:=</span> p<span class="token punctuation">.</span>connections<span class="token punctuation">[</span>p<span class="token punctuation">.</span>current<span class="token punctuation">]</span></span>
<span class="line">    p<span class="token punctuation">.</span>current <span class="token operator">=</span> <span class="token punctuation">(</span>p<span class="token punctuation">.</span>current <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">%</span> <span class="token function">len</span><span class="token punctuation">(</span>p<span class="token punctuation">.</span>connections<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> conn</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>p <span class="token operator">*</span>GRPCConnectionPool<span class="token punctuation">)</span> <span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    p<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> p<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> errs <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">error</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> conn <span class="token operator">:=</span> <span class="token keyword">range</span> p<span class="token punctuation">.</span>connections <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">:=</span> conn<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            errs <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>errs<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> <span class="token function">len</span><span class="token punctuation">(</span>errs<span class="token punctuation">)</span> <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to close connections: %v"</span><span class="token punctuation">,</span> errs<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-负载均衡优化" tabindex="-1"><a class="header-anchor" href="#_2-负载均衡优化">#</a> 2. 负载均衡优化</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 负载均衡器</span></span>
<span class="line"><span class="token keyword">type</span> LoadBalancer <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    servers <span class="token punctuation">[</span><span class="token punctuation">]</span>Server</span>
<span class="line">    current <span class="token builtin">int</span></span>
<span class="line">    mu      sync<span class="token punctuation">.</span>RWMutex</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> Server <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    Address <span class="token builtin">string</span></span>
<span class="line">    Weight  <span class="token builtin">int</span></span>
<span class="line">    Active  <span class="token builtin">bool</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 轮询负载均衡</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>lb <span class="token operator">*</span>LoadBalancer<span class="token punctuation">)</span> <span class="token function">RoundRobin</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>Server <span class="token punctuation">{</span></span>
<span class="line">    lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> <span class="token function">len</span><span class="token punctuation">(</span>lb<span class="token punctuation">.</span>servers<span class="token punctuation">)</span><span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        server <span class="token operator">:=</span> <span class="token operator">&amp;</span>lb<span class="token punctuation">.</span>servers<span class="token punctuation">[</span>lb<span class="token punctuation">.</span>current<span class="token punctuation">]</span></span>
<span class="line">        lb<span class="token punctuation">.</span>current <span class="token operator">=</span> <span class="token punctuation">(</span>lb<span class="token punctuation">.</span>current <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">%</span> <span class="token function">len</span><span class="token punctuation">(</span>lb<span class="token punctuation">.</span>servers<span class="token punctuation">)</span></span>
<span class="line">        </span>
<span class="line">        <span class="token keyword">if</span> server<span class="token punctuation">.</span>Active <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> server</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span> <span class="token comment">// 没有可用服务器</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 加权轮询负载均衡</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>lb <span class="token operator">*</span>LoadBalancer<span class="token punctuation">)</span> <span class="token function">WeightedRoundRobin</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>Server <span class="token punctuation">{</span></span>
<span class="line">    lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    totalWeight <span class="token operator">:=</span> <span class="token number">0</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> server <span class="token operator">:=</span> <span class="token keyword">range</span> lb<span class="token punctuation">.</span>servers <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> server<span class="token punctuation">.</span>Active <span class="token punctuation">{</span></span>
<span class="line">            totalWeight <span class="token operator">+=</span> server<span class="token punctuation">.</span>Weight</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> totalWeight <span class="token operator">==</span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    target <span class="token operator">:=</span> rand<span class="token punctuation">.</span><span class="token function">Intn</span><span class="token punctuation">(</span>totalWeight<span class="token punctuation">)</span></span>
<span class="line">    current <span class="token operator">:=</span> <span class="token number">0</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> server <span class="token operator">:=</span> <span class="token keyword">range</span> lb<span class="token punctuation">.</span>servers <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> <span class="token operator">!</span>server<span class="token punctuation">.</span>Active <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">continue</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        current <span class="token operator">+=</span> server<span class="token punctuation">.</span>Weight</span>
<span class="line">        <span class="token keyword">if</span> current <span class="token operator">></span> target <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> <span class="token operator">&amp;</span>server</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 健康检查</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>lb <span class="token operator">*</span>LoadBalancer<span class="token punctuation">)</span> <span class="token function">HealthCheck</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ticker <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">NewTicker</span><span class="token punctuation">(</span><span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> ticker<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ticker<span class="token punctuation">.</span>C<span class="token punctuation">:</span></span>
<span class="line">            lb<span class="token punctuation">.</span><span class="token function">checkServers</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ctx<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">return</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>lb <span class="token operator">*</span>LoadBalancer<span class="token punctuation">)</span> <span class="token function">checkServers</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> wg sync<span class="token punctuation">.</span>WaitGroup</span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token keyword">range</span> lb<span class="token punctuation">.</span>servers <span class="token punctuation">{</span></span>
<span class="line">        wg<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span>index <span class="token builtin">int</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">defer</span> wg<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            server <span class="token operator">:=</span> <span class="token operator">&amp;</span>lb<span class="token punctuation">.</span>servers<span class="token punctuation">[</span>index<span class="token punctuation">]</span></span>
<span class="line">            active <span class="token operator">:=</span> lb<span class="token punctuation">.</span><span class="token function">isServerHealthy</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> server<span class="token punctuation">.</span>Address<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Lock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            server<span class="token punctuation">.</span>Active <span class="token operator">=</span> active</span>
<span class="line">            lb<span class="token punctuation">.</span>mu<span class="token punctuation">.</span><span class="token function">Unlock</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    wg<span class="token punctuation">.</span><span class="token function">Wait</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>lb <span class="token operator">*</span>LoadBalancer<span class="token punctuation">)</span> <span class="token function">isServerHealthy</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> address <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">bool</span> <span class="token punctuation">{</span></span>
<span class="line">    client <span class="token operator">:=</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Client<span class="token punctuation">{</span>Timeout<span class="token punctuation">:</span> <span class="token number">5</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    req<span class="token punctuation">,</span> err <span class="token operator">:=</span> http<span class="token punctuation">.</span><span class="token function">NewRequestWithContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"GET"</span><span class="token punctuation">,</span> address<span class="token operator">+</span><span class="token string">"/health"</span><span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> client<span class="token punctuation">.</span><span class="token function">Do</span><span class="token punctuation">(</span>req<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">false</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> resp<span class="token punctuation">.</span>StatusCode <span class="token operator">==</span> http<span class="token punctuation">.</span>StatusOK</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-监控和分析" tabindex="-1"><a class="header-anchor" href="#📊-监控和分析">#</a> 📊 监控和分析</h2>
<h3 id="_1-性能指标收集" tabindex="-1"><a class="header-anchor" href="#_1-性能指标收集">#</a> 1. 性能指标收集</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> metrics</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"runtime"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/prometheus/client_golang/prometheus"</span></span>
<span class="line">    <span class="token string">"github.com/prometheus/client_golang/prometheus/promauto"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 性能指标定义</span></span>
<span class="line"><span class="token keyword">var</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token comment">// HTTP指标</span></span>
<span class="line">    httpRequestsTotal <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"http_requests_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of HTTP requests"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"method"</span><span class="token punctuation">,</span> <span class="token string">"endpoint"</span><span class="token punctuation">,</span> <span class="token string">"status"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    httpRequestDuration <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewHistogramVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>HistogramOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span>    <span class="token string">"http_request_duration_seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span>    <span class="token string">"HTTP request duration in seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Buckets<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">float64</span><span class="token punctuation">{</span><span class="token number">.005</span><span class="token punctuation">,</span> <span class="token number">.01</span><span class="token punctuation">,</span> <span class="token number">.025</span><span class="token punctuation">,</span> <span class="token number">.05</span><span class="token punctuation">,</span> <span class="token number">.1</span><span class="token punctuation">,</span> <span class="token number">.25</span><span class="token punctuation">,</span> <span class="token number">.5</span><span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2.5</span><span class="token punctuation">,</span> <span class="token number">5</span><span class="token punctuation">,</span> <span class="token number">10</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"method"</span><span class="token punctuation">,</span> <span class="token string">"endpoint"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 数据库指标</span></span>
<span class="line">    dbConnectionsActive <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewGauge</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>GaugeOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"db_connections_active"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Number of active database connections"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    dbQueryDuration <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewHistogramVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>HistogramOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span>    <span class="token string">"db_query_duration_seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span>    <span class="token string">"Database query duration in seconds"</span><span class="token punctuation">,</span></span>
<span class="line">            Buckets<span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">float64</span><span class="token punctuation">{</span><span class="token number">.001</span><span class="token punctuation">,</span> <span class="token number">.005</span><span class="token punctuation">,</span> <span class="token number">.01</span><span class="token punctuation">,</span> <span class="token number">.025</span><span class="token punctuation">,</span> <span class="token number">.05</span><span class="token punctuation">,</span> <span class="token number">.1</span><span class="token punctuation">,</span> <span class="token number">.25</span><span class="token punctuation">,</span> <span class="token number">.5</span><span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2.5</span><span class="token punctuation">,</span> <span class="token number">5</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"query_type"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 缓存指标</span></span>
<span class="line">    cacheHitsTotal <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"cache_hits_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of cache hits"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"cache_type"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    cacheMissesTotal <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewCounterVec</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>CounterOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"cache_misses_total"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Total number of cache misses"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span><span class="token string">"cache_type"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 系统指标</span></span>
<span class="line">    memoryUsage <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewGauge</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>GaugeOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"memory_usage_bytes"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Memory usage in bytes"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    goroutinesActive <span class="token operator">=</span> promauto<span class="token punctuation">.</span><span class="token function">NewGauge</span><span class="token punctuation">(</span></span>
<span class="line">        prometheus<span class="token punctuation">.</span>GaugeOpts<span class="token punctuation">{</span></span>
<span class="line">            Name<span class="token punctuation">:</span> <span class="token string">"goroutines_active"</span><span class="token punctuation">,</span></span>
<span class="line">            Help<span class="token punctuation">:</span> <span class="token string">"Number of active goroutines"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 指标收集器</span></span>
<span class="line"><span class="token keyword">type</span> MetricsCollector <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewMetricsCollector</span><span class="token punctuation">(</span>db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB<span class="token punctuation">)</span> <span class="token operator">*</span>MetricsCollector <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>MetricsCollector<span class="token punctuation">{</span>db<span class="token punctuation">:</span> db<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 启动指标收集</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MetricsCollector<span class="token punctuation">)</span> <span class="token function">Start</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ticker <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">NewTicker</span><span class="token punctuation">(</span><span class="token number">15</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> ticker<span class="token punctuation">.</span><span class="token function">Stop</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">select</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ticker<span class="token punctuation">.</span>C<span class="token punctuation">:</span></span>
<span class="line">            m<span class="token punctuation">.</span><span class="token function">collectSystemMetrics</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            m<span class="token punctuation">.</span><span class="token function">collectDatabaseMetrics</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">case</span> <span class="token operator">&lt;-</span>ctx<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">:</span></span>
<span class="line">            <span class="token keyword">return</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MetricsCollector<span class="token punctuation">)</span> <span class="token function">collectSystemMetrics</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> memStats runtime<span class="token punctuation">.</span>MemStats</span>
<span class="line">    runtime<span class="token punctuation">.</span><span class="token function">ReadMemStats</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>memStats<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    memoryUsage<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>memStats<span class="token punctuation">.</span>Alloc<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    goroutinesActive<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>runtime<span class="token punctuation">.</span><span class="token function">NumGoroutine</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MetricsCollector<span class="token punctuation">)</span> <span class="token function">collectDatabaseMetrics</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    stats <span class="token operator">:=</span> m<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">Stats</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    dbConnectionsActive<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token function">float64</span><span class="token punctuation">(</span>stats<span class="token punctuation">.</span>OpenConnections<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// HTTP指标中间件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">MetricsMiddleware</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">func</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token keyword">func</span><span class="token punctuation">(</span>next http<span class="token punctuation">.</span>Handler<span class="token punctuation">)</span> http<span class="token punctuation">.</span>Handler <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> http<span class="token punctuation">.</span><span class="token function">HandlerFunc</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>w http<span class="token punctuation">.</span>ResponseWriter<span class="token punctuation">,</span> r <span class="token operator">*</span>http<span class="token punctuation">.</span>Request<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 包装响应写入器以捕获状态码</span></span>
<span class="line">            rw <span class="token operator">:=</span> <span class="token operator">&amp;</span>responseWriter<span class="token punctuation">{</span>ResponseWriter<span class="token punctuation">:</span> w<span class="token punctuation">,</span> statusCode<span class="token punctuation">:</span> <span class="token number">200</span><span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 执行请求</span></span>
<span class="line">            next<span class="token punctuation">.</span><span class="token function">ServeHTTP</span><span class="token punctuation">(</span>rw<span class="token punctuation">,</span> r<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token comment">// 记录指标</span></span>
<span class="line">            duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Seconds</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            httpRequestsTotal<span class="token punctuation">.</span><span class="token function">WithLabelValues</span><span class="token punctuation">(</span></span>
<span class="line">                r<span class="token punctuation">.</span>Method<span class="token punctuation">,</span></span>
<span class="line">                r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">,</span></span>
<span class="line">                fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"%d"</span><span class="token punctuation">,</span> rw<span class="token punctuation">.</span>statusCode<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Inc</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            httpRequestDuration<span class="token punctuation">.</span><span class="token function">WithLabelValues</span><span class="token punctuation">(</span></span>
<span class="line">                r<span class="token punctuation">.</span>Method<span class="token punctuation">,</span></span>
<span class="line">                r<span class="token punctuation">.</span>URL<span class="token punctuation">.</span>Path<span class="token punctuation">,</span></span>
<span class="line">            <span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Observe</span><span class="token punctuation">(</span>duration<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 数据库指标装饰器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MetricsCollector<span class="token punctuation">)</span> <span class="token function">WrapDBQuery</span><span class="token punctuation">(</span>queryType <span class="token builtin">string</span><span class="token punctuation">,</span> fn <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    err <span class="token operator">:=</span> <span class="token function">fn</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Seconds</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    dbQueryDuration<span class="token punctuation">.</span><span class="token function">WithLabelValues</span><span class="token punctuation">(</span>queryType<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Observe</span><span class="token punctuation">(</span>duration<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 缓存指标装饰器</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">RecordCacheHit</span><span class="token punctuation">(</span>cacheType <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    cacheHitsTotal<span class="token punctuation">.</span><span class="token function">WithLabelValues</span><span class="token punctuation">(</span>cacheType<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Inc</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">RecordCacheMiss</span><span class="token punctuation">(</span>cacheType <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    cacheMissesTotal<span class="token punctuation">.</span><span class="token function">WithLabelValues</span><span class="token punctuation">(</span>cacheType<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Inc</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-性能分析工具" tabindex="-1"><a class="header-anchor" href="#_2-性能分析工具">#</a> 2. 性能分析工具</h3>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/performance-analysis.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token assign-left variable">SERVICE_URL</span><span class="token operator">=</span><span class="token string">"http://localhost:8080"</span></span>
<span class="line"><span class="token assign-left variable">DURATION</span><span class="token operator">=</span><span class="token string">"60s"</span></span>
<span class="line"><span class="token assign-left variable">OUTPUT_DIR</span><span class="token operator">=</span><span class="token string">"./performance-analysis"</span></span>
<span class="line"></span>
<span class="line"><span class="token function">mkdir</span> <span class="token parameter variable">-p</span> <span class="token variable">$OUTPUT_DIR</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Starting performance analysis for <span class="token variable">$DURATION</span>..."</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 收集CPU profile</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting CPU profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/profile?seconds=60"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/cpu.prof"</span> <span class="token operator">&amp;</span></span>
<span class="line"><span class="token assign-left variable">CPU_PID</span><span class="token operator">=</span><span class="token variable">$!</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 收集内存profile</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting memory profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/heap"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/heap.prof"</span> <span class="token operator">&amp;</span></span>
<span class="line"><span class="token assign-left variable">MEM_PID</span><span class="token operator">=</span><span class="token variable">$!</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 收集goroutine profile</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Collecting goroutine profile..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/debug/pprof/goroutine"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/goroutine.prof"</span> <span class="token operator">&amp;</span></span>
<span class="line"><span class="token assign-left variable">GOR_PID</span><span class="token operator">=</span><span class="token variable">$!</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行负载测试</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Running load test..."</span></span>
<span class="line">wrk <span class="token parameter variable">-t12</span> <span class="token parameter variable">-c400</span> <span class="token parameter variable">-d60s</span> <span class="token parameter variable">--latency</span> <span class="token string">"<span class="token variable">$SERVICE_URL</span>/api/v1/users"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/load-test.txt"</span> <span class="token operator">&amp;</span></span>
<span class="line"><span class="token assign-left variable">LOAD_PID</span><span class="token operator">=</span><span class="token variable">$!</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 监控系统资源</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Monitoring system resources..."</span></span>
<span class="line"><span class="token punctuation">{</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"timestamp,cpu_percent,memory_percent,disk_io,network_io"</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token for-or-select variable">i</span> <span class="token keyword">in</span> <span class="token punctuation">{</span><span class="token number">1</span><span class="token punctuation">..</span><span class="token number">60</span><span class="token punctuation">}</span><span class="token punctuation">;</span> <span class="token keyword">do</span></span>
<span class="line">        <span class="token assign-left variable">timestamp</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">date</span> +<span class="token string">"%Y-%m-%d %H:%M:%S"</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">cpu</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">top</span> <span class="token parameter variable">-l</span> <span class="token number">1</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token string">"CPU usage"</span> <span class="token operator">|</span> <span class="token function">awk</span> <span class="token string">'{print $3}'</span> <span class="token operator">|</span> <span class="token function">sed</span> <span class="token string">'s/%//'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token assign-left variable">memory</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span><span class="token function">top</span> <span class="token parameter variable">-l</span> <span class="token number">1</span> <span class="token operator">|</span> <span class="token function">grep</span> <span class="token string">"PhysMem"</span> <span class="token operator">|</span> <span class="token function">awk</span> <span class="token string">'{print $2}'</span> <span class="token operator">|</span> <span class="token function">sed</span> <span class="token string">'s/M//'</span><span class="token variable">)</span></span></span>
<span class="line">        <span class="token builtin class-name">echo</span> <span class="token string">"<span class="token variable">$timestamp</span>,<span class="token variable">$cpu</span>,<span class="token variable">$memory</span>,0,0"</span></span>
<span class="line">        <span class="token function">sleep</span> <span class="token number">1</span></span>
<span class="line">    <span class="token keyword">done</span></span>
<span class="line"><span class="token punctuation">}</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/system-metrics.csv"</span> <span class="token operator">&amp;</span></span>
<span class="line"><span class="token assign-left variable">SYS_PID</span><span class="token operator">=</span><span class="token variable">$!</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 等待所有任务完成</span></span>
<span class="line"><span class="token function">wait</span> <span class="token variable">$CPU_PID</span> <span class="token variable">$MEM_PID</span> <span class="token variable">$GOR_PID</span> <span class="token variable">$LOAD_PID</span> <span class="token variable">$SYS_PID</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Performance analysis completed. Results saved to <span class="token variable">$OUTPUT_DIR</span>"</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成分析报告</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Generating analysis report..."</span></span>
<span class="line">go tool pprof <span class="token parameter variable">-top</span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/cpu.prof"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/cpu-analysis.txt"</span></span>
<span class="line">go tool pprof <span class="token parameter variable">-top</span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/heap.prof"</span> <span class="token operator">></span> <span class="token string">"<span class="token variable">$OUTPUT_DIR</span>/memory-analysis.txt"</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Analysis report generated."</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"View CPU analysis: cat <span class="token variable">$OUTPUT_DIR</span>/cpu-analysis.txt"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"View memory analysis: cat <span class="token variable">$OUTPUT_DIR</span>/memory-analysis.txt"</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"View load test results: cat <span class="token variable">$OUTPUT_DIR</span>/load-test.txt"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/development/">开发指南</RouteLink></li>
<li><RouteLink to="/development/architecture.html">架构设计</RouteLink></li>
<li><RouteLink to="/development/testing.html">测试指南</RouteLink></li>
<li><RouteLink to="/development/debugging.html">调试指南</RouteLink></li>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
</ul>
</div></template>


