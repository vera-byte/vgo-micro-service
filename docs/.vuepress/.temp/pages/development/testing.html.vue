<template><div><h1 id="测试指南" tabindex="-1"><a class="header-anchor" href="#测试指南">#</a> 测试指南</h1>
<p>本文档详细介绍了VGO微服务的测试策略、测试框架、测试实践和测试工具的使用方法。</p>
<h2 id="🎯-测试策略" tabindex="-1"><a class="header-anchor" href="#🎯-测试策略">#</a> 🎯 测试策略</h2>
<h3 id="测试金字塔" tabindex="-1"><a class="header-anchor" href="#测试金字塔">#</a> 测试金字塔</h3>
<div class="language-mermaid line-numbers-mode" data-highlighter="prismjs" data-ext="mermaid"><pre v-pre><code class="language-mermaid"><span class="line"><span class="token keyword">graph</span> TB</span>
<span class="line">    <span class="token keyword">subgraph</span> <span class="token string">"测试金字塔"</span></span>
<span class="line">        A<span class="token text string">["端到端测试 (E2E)&lt;br/>少量，高价值"]</span> </span>
<span class="line">        B<span class="token text string">["集成测试 (Integration)&lt;br/>适量，关键路径"]</span></span>
<span class="line">        C<span class="token text string">["单元测试 (Unit)&lt;br/>大量，快速反馈"]</span></span>
<span class="line">    <span class="token keyword">end</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">style</span> A <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#ff6b6b</span></span>
<span class="line">    <span class="token keyword">style</span> B <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#ffd93d</span></span>
<span class="line">    <span class="token keyword">style</span> C <span class="token style"><span class="token property">fill</span><span class="token operator">:</span>#6bcf7f</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="测试分层策略" tabindex="-1"><a class="header-anchor" href="#测试分层策略">#</a> 测试分层策略</h3>
<table>
<thead>
<tr>
<th>测试类型</th>
<th>占比</th>
<th>执行速度</th>
<th>覆盖范围</th>
<th>维护成本</th>
</tr>
</thead>
<tbody>
<tr>
<td>单元测试</td>
<td>70%</td>
<td>快</td>
<td>函数/方法级别</td>
<td>低</td>
</tr>
<tr>
<td>集成测试</td>
<td>20%</td>
<td>中等</td>
<td>服务间交互</td>
<td>中等</td>
</tr>
<tr>
<td>端到端测试</td>
<td>10%</td>
<td>慢</td>
<td>完整业务流程</td>
<td>高</td>
</tr>
</tbody>
</table>
<h2 id="🧪-测试框架" tabindex="-1"><a class="header-anchor" href="#🧪-测试框架">#</a> 🧪 测试框架</h2>
<h3 id="_1-单元测试框架" tabindex="-1"><a class="header-anchor" href="#_1-单元测试框架">#</a> 1. 单元测试框架</h3>
<h4 id="go标准测试库-testify" tabindex="-1"><a class="header-anchor" href="#go标准测试库-testify">#</a> Go标准测试库 + Testify</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> user</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/assert"</span></span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/mock"</span></span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/suite"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 测试套件</span></span>
<span class="line"><span class="token keyword">type</span> UserServiceTestSuite <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>Suite</span>
<span class="line">    service    <span class="token operator">*</span>UserService</span>
<span class="line">    mockRepo   <span class="token operator">*</span>MockUserRepository</span>
<span class="line">    mockCache  <span class="token operator">*</span>MockCacheService</span>
<span class="line">    mockLogger <span class="token operator">*</span>MockLogger</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 设置测试环境</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserServiceTestSuite<span class="token punctuation">)</span> <span class="token function">SetupTest</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockRepo <span class="token operator">=</span> <span class="token operator">&amp;</span>MockUserRepository<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockCache <span class="token operator">=</span> <span class="token operator">&amp;</span>MockCacheService<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockLogger <span class="token operator">=</span> <span class="token operator">&amp;</span>MockLogger<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>service <span class="token operator">=</span> <span class="token operator">&amp;</span>UserService<span class="token punctuation">{</span></span>
<span class="line">        repo<span class="token punctuation">:</span>   suite<span class="token punctuation">.</span>mockRepo<span class="token punctuation">,</span></span>
<span class="line">        cache<span class="token punctuation">:</span>  suite<span class="token punctuation">.</span>mockCache<span class="token punctuation">,</span></span>
<span class="line">        logger<span class="token punctuation">:</span> suite<span class="token punctuation">.</span>mockLogger<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 清理测试环境</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserServiceTestSuite<span class="token punctuation">)</span> <span class="token function">TearDownTest</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockRepo<span class="token punctuation">.</span><span class="token function">AssertExpectations</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockCache<span class="token punctuation">.</span><span class="token function">AssertExpectations</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 测试用例：创建用户成功</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserServiceTestSuite<span class="token punctuation">)</span> <span class="token function">TestCreateUser_Success</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// Arrange</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    user <span class="token operator">:=</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">        Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>mockRepo<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span>mockCache<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Delete"</span><span class="token punctuation">,</span> ctx<span class="token punctuation">,</span> <span class="token string">"users:list"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Act</span></span>
<span class="line">    err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Assert</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NotEmpty</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">"active"</span><span class="token punctuation">,</span> user<span class="token punctuation">.</span>Status<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 测试用例：创建用户失败 - 用户名已存在</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>UserServiceTestSuite<span class="token punctuation">)</span> <span class="token function">TestCreateUser_UsernameExists</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// Arrange</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    user <span class="token operator">:=</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">        Username<span class="token punctuation">:</span> <span class="token string">"existinguser"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>mockRepo<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span>ErrUsernameExists<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Act</span></span>
<span class="line">    err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Assert</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span><span class="token function">T</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> ErrUsernameExists<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 运行测试套件</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserServiceTestSuite</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> <span class="token function">new</span><span class="token punctuation">(</span>UserServiceTestSuite<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="mock生成" tabindex="-1"><a class="header-anchor" href="#mock生成">#</a> Mock生成</h4>
<p>使用mockery自动生成Mock对象：</p>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token comment"># 安装mockery</span></span>
<span class="line">go <span class="token function">install</span> github.com/vektra/mockery/v2@latest</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成Mock</span></span>
<span class="line">mockery <span class="token parameter variable">--name</span><span class="token operator">=</span>UserRepository <span class="token parameter variable">--output</span><span class="token operator">=</span>./mocks <span class="token parameter variable">--outpkg</span><span class="token operator">=</span>mocks</span>
<span class="line">mockery <span class="token parameter variable">--name</span><span class="token operator">=</span>CacheService <span class="token parameter variable">--output</span><span class="token operator">=</span>./mocks <span class="token parameter variable">--outpkg</span><span class="token operator">=</span>mocks</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 接口定义</span></span>
<span class="line"><span class="token keyword">type</span> UserRepository <span class="token keyword">interface</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token function">Create</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">GetByID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">Update</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">Delete</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span></span>
<span class="line">    <span class="token function">List</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> opts ListOptions<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 自动生成的Mock</span></span>
<span class="line"><span class="token keyword">type</span> MockUserRepository <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    mock<span class="token punctuation">.</span>Mock</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span> <span class="token function">Create</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> user <span class="token operator">*</span>User<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    args <span class="token operator">:=</span> m<span class="token punctuation">.</span><span class="token function">Called</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> args<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token number">0</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span> <span class="token function">GetByID</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> id <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    args <span class="token operator">:=</span> m<span class="token punctuation">.</span><span class="token function">Called</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> id<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> args<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span><span class="token number">0</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">*</span>User<span class="token punctuation">)</span><span class="token punctuation">,</span> args<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-集成测试框架" tabindex="-1"><a class="header-anchor" href="#_2-集成测试框架">#</a> 2. 集成测试框架</h3>
<h4 id="testcontainers集成测试" tabindex="-1"><a class="header-anchor" href="#testcontainers集成测试">#</a> Testcontainers集成测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> integration</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"database/sql"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/testcontainers/testcontainers-go"</span></span>
<span class="line">    <span class="token string">"github.com/testcontainers/testcontainers-go/modules/postgres"</span></span>
<span class="line">    <span class="token string">"github.com/testcontainers/testcontainers-go/modules/redis"</span></span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/suite"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> IntegrationTestSuite <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>Suite</span>
<span class="line">    pgContainer    <span class="token operator">*</span>postgres<span class="token punctuation">.</span>PostgresContainer</span>
<span class="line">    redisContainer <span class="token operator">*</span>redis<span class="token punctuation">.</span>RedisContainer</span>
<span class="line">    db             <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB</span>
<span class="line">    redisClient    <span class="token operator">*</span>redis<span class="token punctuation">.</span>Client</span>
<span class="line">    userService    <span class="token operator">*</span>UserService</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>IntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">SetupSuite</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 启动PostgreSQL容器</span></span>
<span class="line">    pgContainer<span class="token punctuation">,</span> err <span class="token operator">:=</span> postgres<span class="token punctuation">.</span><span class="token function">RunContainer</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span></span>
<span class="line">        testcontainers<span class="token punctuation">.</span><span class="token function">WithImage</span><span class="token punctuation">(</span><span class="token string">"postgres:15-alpine"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        postgres<span class="token punctuation">.</span><span class="token function">WithDatabase</span><span class="token punctuation">(</span><span class="token string">"testdb"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        postgres<span class="token punctuation">.</span><span class="token function">WithUsername</span><span class="token punctuation">(</span><span class="token string">"testuser"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        postgres<span class="token punctuation">.</span><span class="token function">WithPassword</span><span class="token punctuation">(</span><span class="token string">"testpass"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        testcontainers<span class="token punctuation">.</span><span class="token function">WithWaitStrategy</span><span class="token punctuation">(</span></span>
<span class="line">            wait<span class="token punctuation">.</span><span class="token function">ForLog</span><span class="token punctuation">(</span><span class="token string">"database system is ready to accept connections"</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">WithOccurrence</span><span class="token punctuation">(</span><span class="token number">2</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">WithStartupTimeout</span><span class="token punctuation">(</span><span class="token number">5</span><span class="token operator">*</span>time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span>pgContainer <span class="token operator">=</span> pgContainer</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 启动Redis容器</span></span>
<span class="line">    redisContainer<span class="token punctuation">,</span> err <span class="token operator">:=</span> redis<span class="token punctuation">.</span><span class="token function">RunContainer</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span></span>
<span class="line">        testcontainers<span class="token punctuation">.</span><span class="token function">WithImage</span><span class="token punctuation">(</span><span class="token string">"redis:7-alpine"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span>redisContainer <span class="token operator">=</span> redisContainer</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 连接数据库</span></span>
<span class="line">    connStr<span class="token punctuation">,</span> err <span class="token operator">:=</span> pgContainer<span class="token punctuation">.</span><span class="token function">ConnectionString</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"sslmode=disable"</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>db<span class="token punctuation">,</span> err <span class="token operator">=</span> sql<span class="token punctuation">.</span><span class="token function">Open</span><span class="token punctuation">(</span><span class="token string">"postgres"</span><span class="token punctuation">,</span> connStr<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 连接Redis</span></span>
<span class="line">    redisEndpoint<span class="token punctuation">,</span> err <span class="token operator">:=</span> redisContainer<span class="token punctuation">.</span><span class="token function">Endpoint</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">""</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>redisClient <span class="token operator">=</span> redis<span class="token punctuation">.</span><span class="token function">NewClient</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>redis<span class="token punctuation">.</span>Options<span class="token punctuation">{</span></span>
<span class="line">        Addr<span class="token punctuation">:</span> redisEndpoint<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 初始化服务</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">setupServices</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 运行数据库迁移</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">runMigrations</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>IntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">TearDownSuite</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> suite<span class="token punctuation">.</span>db <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        suite<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> suite<span class="token punctuation">.</span>redisClient <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        suite<span class="token punctuation">.</span>redisClient<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> suite<span class="token punctuation">.</span>pgContainer <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        suite<span class="token punctuation">.</span>pgContainer<span class="token punctuation">.</span><span class="token function">Terminate</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> suite<span class="token punctuation">.</span>redisContainer <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        suite<span class="token punctuation">.</span>redisContainer<span class="token punctuation">.</span><span class="token function">Terminate</span><span class="token punctuation">(</span>ctx<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>IntegrationTestSuite<span class="token punctuation">)</span> <span class="token function">TestUserCRUD</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建用户</span></span>
<span class="line">    user <span class="token operator">:=</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">        Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NotEmpty</span><span class="token punctuation">(</span>user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 获取用户</span></span>
<span class="line">    retrievedUser<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>user<span class="token punctuation">.</span>Username<span class="token punctuation">,</span> retrievedUser<span class="token punctuation">.</span>Username<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>user<span class="token punctuation">.</span>Email<span class="token punctuation">,</span> retrievedUser<span class="token punctuation">.</span>Email<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 更新用户</span></span>
<span class="line">    user<span class="token punctuation">.</span>Email <span class="token operator">=</span> <span class="token string">"updated@example.com"</span></span>
<span class="line">    err <span class="token operator">=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">UpdateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 验证更新</span></span>
<span class="line">    updatedUser<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span><span class="token string">"updated@example.com"</span><span class="token punctuation">,</span> updatedUser<span class="token punctuation">.</span>Email<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 删除用户</span></span>
<span class="line">    err <span class="token operator">=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">DeleteUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 验证删除</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> suite<span class="token punctuation">.</span>userService<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestIntegrationTestSuite</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> <span class="token function">new</span><span class="token punctuation">(</span>IntegrationTestSuite<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-端到端测试框架" tabindex="-1"><a class="header-anchor" href="#_3-端到端测试框架">#</a> 3. 端到端测试框架</h3>
<h4 id="api测试" tabindex="-1"><a class="header-anchor" href="#api测试">#</a> API测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> e2e</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"bytes"</span></span>
<span class="line">    <span class="token string">"encoding/json"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"net/http"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    </span>
<span class="line">    <span class="token string">"github.com/stretchr/testify/suite"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> E2ETestSuite <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>Suite</span>
<span class="line">    baseURL    <span class="token builtin">string</span></span>
<span class="line">    httpClient <span class="token operator">*</span>http<span class="token punctuation">.</span>Client</span>
<span class="line">    authToken  <span class="token builtin">string</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>E2ETestSuite<span class="token punctuation">)</span> <span class="token function">SetupSuite</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span>baseURL <span class="token operator">=</span> <span class="token string">"http://localhost:8080"</span></span>
<span class="line">    suite<span class="token punctuation">.</span>httpClient <span class="token operator">=</span> <span class="token operator">&amp;</span>http<span class="token punctuation">.</span>Client<span class="token punctuation">{</span></span>
<span class="line">        Timeout<span class="token punctuation">:</span> <span class="token number">30</span> <span class="token operator">*</span> time<span class="token punctuation">.</span>Second<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 等待服务启动</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">waitForService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 获取认证令牌</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">authenticate</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>E2ETestSuite<span class="token punctuation">)</span> <span class="token function">waitForService</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> <span class="token number">30</span><span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>httpClient<span class="token punctuation">.</span><span class="token function">Get</span><span class="token punctuation">(</span>suite<span class="token punctuation">.</span>baseURL <span class="token operator">+</span> <span class="token string">"/health"</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">==</span> <span class="token boolean">nil</span> <span class="token operator">&amp;&amp;</span> resp<span class="token punctuation">.</span>StatusCode <span class="token operator">==</span> http<span class="token punctuation">.</span>StatusOK <span class="token punctuation">{</span></span>
<span class="line">            resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">return</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        <span class="token keyword">if</span> resp <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        time<span class="token punctuation">.</span><span class="token function">Sleep</span><span class="token punctuation">(</span>time<span class="token punctuation">.</span>Second<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">FailNow</span><span class="token punctuation">(</span><span class="token string">"Service did not start within 30 seconds"</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>E2ETestSuite<span class="token punctuation">)</span> <span class="token function">authenticate</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    loginReq <span class="token operator">:=</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"username"</span><span class="token punctuation">:</span> <span class="token string">"admin"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"password"</span><span class="token punctuation">:</span> <span class="token string">"admin123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    body<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>loginReq<span class="token punctuation">)</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span>httpClient<span class="token punctuation">.</span><span class="token function">Post</span><span class="token punctuation">(</span></span>
<span class="line">        suite<span class="token punctuation">.</span>baseURL<span class="token operator">+</span><span class="token string">"/api/v1/auth/login"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"application/json"</span><span class="token punctuation">,</span></span>
<span class="line">        bytes<span class="token punctuation">.</span><span class="token function">NewBuffer</span><span class="token punctuation">(</span>body<span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusOK<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> loginResp <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">        Token <span class="token builtin">string</span> <span class="token string">`json:"token"`</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    err <span class="token operator">=</span> json<span class="token punctuation">.</span><span class="token function">NewDecoder</span><span class="token punctuation">(</span>resp<span class="token punctuation">.</span>Body<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Decode</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>loginResp<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span>authToken <span class="token operator">=</span> loginResp<span class="token punctuation">.</span>Token</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>E2ETestSuite<span class="token punctuation">)</span> <span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> path <span class="token builtin">string</span><span class="token punctuation">,</span> body <span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">*</span>http<span class="token punctuation">.</span>Response<span class="token punctuation">,</span> <span class="token builtin">error</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">var</span> reqBody <span class="token operator">*</span>bytes<span class="token punctuation">.</span>Buffer</span>
<span class="line">    <span class="token keyword">if</span> body <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        jsonBody<span class="token punctuation">,</span> <span class="token boolean">_</span> <span class="token operator">:=</span> json<span class="token punctuation">.</span><span class="token function">Marshal</span><span class="token punctuation">(</span>body<span class="token punctuation">)</span></span>
<span class="line">        reqBody <span class="token operator">=</span> bytes<span class="token punctuation">.</span><span class="token function">NewBuffer</span><span class="token punctuation">(</span>jsonBody<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    req<span class="token punctuation">,</span> err <span class="token operator">:=</span> http<span class="token punctuation">.</span><span class="token function">NewRequest</span><span class="token punctuation">(</span>method<span class="token punctuation">,</span> suite<span class="token punctuation">.</span>baseURL<span class="token operator">+</span>path<span class="token punctuation">,</span> reqBody<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> <span class="token boolean">nil</span><span class="token punctuation">,</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    req<span class="token punctuation">.</span>Header<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Authorization"</span><span class="token punctuation">,</span> <span class="token string">"Bearer "</span><span class="token operator">+</span>suite<span class="token punctuation">.</span>authToken<span class="token punctuation">)</span></span>
<span class="line">    req<span class="token punctuation">.</span>Header<span class="token punctuation">.</span><span class="token function">Set</span><span class="token punctuation">(</span><span class="token string">"Content-Type"</span><span class="token punctuation">,</span> <span class="token string">"application/json"</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> suite<span class="token punctuation">.</span>httpClient<span class="token punctuation">.</span><span class="token function">Do</span><span class="token punctuation">(</span>req<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>suite <span class="token operator">*</span>E2ETestSuite<span class="token punctuation">)</span> <span class="token function">TestUserManagementWorkflow</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 1. 创建用户</span></span>
<span class="line">    createUserReq <span class="token operator">:=</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"username"</span><span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"email"</span><span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"password"</span><span class="token punctuation">:</span> <span class="token string">"password123"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">:=</span> suite<span class="token punctuation">.</span><span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span><span class="token string">"POST"</span><span class="token punctuation">,</span> <span class="token string">"/api/v1/users"</span><span class="token punctuation">,</span> createUserReq<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusCreated<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> createResp <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">        User <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">            ID       <span class="token builtin">string</span> <span class="token string">`json:"id"`</span></span>
<span class="line">            Username <span class="token builtin">string</span> <span class="token string">`json:"username"`</span></span>
<span class="line">            Email    <span class="token builtin">string</span> <span class="token string">`json:"email"`</span></span>
<span class="line">        <span class="token punctuation">}</span> <span class="token string">`json:"user"`</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    err <span class="token operator">=</span> json<span class="token punctuation">.</span><span class="token function">NewDecoder</span><span class="token punctuation">(</span>resp<span class="token punctuation">.</span>Body<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Decode</span><span class="token punctuation">(</span><span class="token operator">&amp;</span>createResp<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    userID <span class="token operator">:=</span> createResp<span class="token punctuation">.</span>User<span class="token punctuation">.</span>ID</span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NotEmpty</span><span class="token punctuation">(</span>userID<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 2. 获取用户</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">=</span> suite<span class="token punctuation">.</span><span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span><span class="token string">"GET"</span><span class="token punctuation">,</span> <span class="token string">"/api/v1/users/"</span><span class="token operator">+</span>userID<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusOK<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 3. 更新用户</span></span>
<span class="line">    updateUserReq <span class="token operator">:=</span> <span class="token keyword">map</span><span class="token punctuation">[</span><span class="token builtin">string</span><span class="token punctuation">]</span><span class="token keyword">interface</span><span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"email"</span><span class="token punctuation">:</span> <span class="token string">"updated@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">=</span> suite<span class="token punctuation">.</span><span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span><span class="token string">"PUT"</span><span class="token punctuation">,</span> <span class="token string">"/api/v1/users/"</span><span class="token operator">+</span>userID<span class="token punctuation">,</span> updateUserReq<span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusOK<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 4. 删除用户</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">=</span> suite<span class="token punctuation">.</span><span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span><span class="token string">"DELETE"</span><span class="token punctuation">,</span> <span class="token string">"/api/v1/users/"</span><span class="token operator">+</span>userID<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusNoContent<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 5. 验证用户已删除</span></span>
<span class="line">    resp<span class="token punctuation">,</span> err <span class="token operator">=</span> suite<span class="token punctuation">.</span><span class="token function">makeAuthenticatedRequest</span><span class="token punctuation">(</span><span class="token string">"GET"</span><span class="token punctuation">,</span> <span class="token string">"/api/v1/users/"</span><span class="token operator">+</span>userID<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Require</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">defer</span> resp<span class="token punctuation">.</span>Body<span class="token punctuation">.</span><span class="token function">Close</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Assert</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>http<span class="token punctuation">.</span>StatusNotFound<span class="token punctuation">,</span> resp<span class="token punctuation">.</span>StatusCode<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestE2ETestSuite</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    suite<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> <span class="token function">new</span><span class="token punctuation">(</span>E2ETestSuite<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🔧-测试工具" tabindex="-1"><a class="header-anchor" href="#🔧-测试工具">#</a> 🔧 测试工具</h2>
<h3 id="_1-测试数据管理" tabindex="-1"><a class="header-anchor" href="#_1-测试数据管理">#</a> 1. 测试数据管理</h3>
<h4 id="测试数据工厂" tabindex="-1"><a class="header-anchor" href="#测试数据工厂">#</a> 测试数据工厂</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> testdata</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line">    <span class="token string">"github.com/google/uuid"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 用户测试数据工厂</span></span>
<span class="line"><span class="token keyword">type</span> UserFactory <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    defaults <span class="token operator">*</span>User</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>UserFactory <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>UserFactory<span class="token punctuation">{</span></span>
<span class="line">        defaults<span class="token punctuation">:</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">            ID<span class="token punctuation">:</span>        uuid<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            Username<span class="token punctuation">:</span>  <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">            Email<span class="token punctuation">:</span>     <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">            Status<span class="token punctuation">:</span>    <span class="token string">"active"</span><span class="token punctuation">,</span></span>
<span class="line">            CreatedAt<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">            UpdatedAt<span class="token punctuation">:</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>f <span class="token operator">*</span>UserFactory<span class="token punctuation">)</span> <span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">*</span>User <span class="token punctuation">{</span></span>
<span class="line">    user <span class="token operator">:=</span> <span class="token operator">*</span>f<span class="token punctuation">.</span>defaults</span>
<span class="line">    user<span class="token punctuation">.</span>ID <span class="token operator">=</span> uuid<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">String</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>user</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>f <span class="token operator">*</span>UserFactory<span class="token punctuation">)</span> <span class="token function">WithUsername</span><span class="token punctuation">(</span>username <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>UserFactory <span class="token punctuation">{</span></span>
<span class="line">    f<span class="token punctuation">.</span>defaults<span class="token punctuation">.</span>Username <span class="token operator">=</span> username</span>
<span class="line">    <span class="token keyword">return</span> f</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>f <span class="token operator">*</span>UserFactory<span class="token punctuation">)</span> <span class="token function">WithEmail</span><span class="token punctuation">(</span>email <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>UserFactory <span class="token punctuation">{</span></span>
<span class="line">    f<span class="token punctuation">.</span>defaults<span class="token punctuation">.</span>Email <span class="token operator">=</span> email</span>
<span class="line">    <span class="token keyword">return</span> f</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>f <span class="token operator">*</span>UserFactory<span class="token punctuation">)</span> <span class="token function">WithStatus</span><span class="token punctuation">(</span>status <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>UserFactory <span class="token punctuation">{</span></span>
<span class="line">    f<span class="token punctuation">.</span>defaults<span class="token punctuation">.</span>Status <span class="token operator">=</span> status</span>
<span class="line">    <span class="token keyword">return</span> f</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 使用示例</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserCreation</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// 创建默认用户</span></span>
<span class="line">    user1 <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 创建自定义用户</span></span>
<span class="line">    user2 <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span></span>
<span class="line">        <span class="token function">WithUsername</span><span class="token punctuation">(</span><span class="token string">"customuser"</span><span class="token punctuation">)</span><span class="token punctuation">.</span></span>
<span class="line">        <span class="token function">WithEmail</span><span class="token punctuation">(</span><span class="token string">"custom@example.com"</span><span class="token punctuation">)</span><span class="token punctuation">.</span></span>
<span class="line">        <span class="token function">WithStatus</span><span class="token punctuation">(</span><span class="token string">"inactive"</span><span class="token punctuation">)</span><span class="token punctuation">.</span></span>
<span class="line">        <span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 测试逻辑...</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="测试数据清理" tabindex="-1"><a class="header-anchor" href="#测试数据清理">#</a> 测试数据清理</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> testutil</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"database/sql"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> DatabaseCleaner <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewDatabaseCleaner</span><span class="token punctuation">(</span>db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB<span class="token punctuation">)</span> <span class="token operator">*</span>DatabaseCleaner <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>DatabaseCleaner<span class="token punctuation">{</span>db<span class="token punctuation">:</span> db<span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 清理所有测试数据</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>DatabaseCleaner<span class="token punctuation">)</span> <span class="token function">CleanAll</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    tables <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token string">"user_roles"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"policy_attachments"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"access_key_usage"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"access_keys"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"policies"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"users"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"roles"</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token string">"applications"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    tx<span class="token punctuation">,</span> err <span class="token operator">:=</span> c<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">BeginTx</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    <span class="token keyword">defer</span> tx<span class="token punctuation">.</span><span class="token function">Rollback</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 禁用外键约束</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> tx<span class="token punctuation">.</span><span class="token function">ExecContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"SET FOREIGN_KEY_CHECKS = 0"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 清理表数据</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> table <span class="token operator">:=</span> <span class="token keyword">range</span> tables <span class="token punctuation">{</span></span>
<span class="line">        <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> tx<span class="token punctuation">.</span><span class="token function">ExecContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"DELETE FROM %s"</span><span class="token punctuation">,</span> table<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 重新启用外键约束</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> tx<span class="token punctuation">.</span><span class="token function">ExecContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> <span class="token string">"SET FOREIGN_KEY_CHECKS = 1"</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> tx<span class="token punctuation">.</span><span class="token function">Commit</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 清理特定表</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>c <span class="token operator">*</span>DatabaseCleaner<span class="token punctuation">)</span> <span class="token function">CleanTable</span><span class="token punctuation">(</span>ctx context<span class="token punctuation">.</span>Context<span class="token punctuation">,</span> table <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> c<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">ExecContext</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> fmt<span class="token punctuation">.</span><span class="token function">Sprintf</span><span class="token punctuation">(</span><span class="token string">"DELETE FROM %s"</span><span class="token punctuation">,</span> table<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">return</span> err</span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-性能测试" tabindex="-1"><a class="header-anchor" href="#_2-性能测试">#</a> 2. 性能测试</h3>
<h4 id="基准测试" tabindex="-1"><a class="header-anchor" href="#基准测试">#</a> 基准测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> benchmark</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 用户服务性能测试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">BenchmarkUserService_CreateUser</span><span class="token punctuation">(</span>b <span class="token operator">*</span>testing<span class="token punctuation">.</span>B<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token function">setupUserService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">ResetTimer</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">RunParallel</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>pb <span class="token operator">*</span>testing<span class="token punctuation">.</span>PB<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">for</span> pb<span class="token punctuation">.</span><span class="token function">Next</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            user <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                b<span class="token punctuation">.</span><span class="token function">Fatal</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">BenchmarkUserService_GetUser</span><span class="token punctuation">(</span>b <span class="token operator">*</span>testing<span class="token punctuation">.</span>B<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token function">setupUserService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 预创建用户</span></span>
<span class="line">    user <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        b<span class="token punctuation">.</span><span class="token function">Fatal</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">ResetTimer</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">RunParallel</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>pb <span class="token operator">*</span>testing<span class="token punctuation">.</span>PB<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">for</span> pb<span class="token punctuation">.</span><span class="token function">Next</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">GetUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                b<span class="token punctuation">.</span><span class="token function">Fatal</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 权限检查性能测试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">BenchmarkPermissionService_CheckPermission</span><span class="token punctuation">(</span>b <span class="token operator">*</span>testing<span class="token punctuation">.</span>B<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token function">setupPermissionService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    req <span class="token operator">:=</span> <span class="token operator">&amp;</span>CheckPermissionRequest<span class="token punctuation">{</span></span>
<span class="line">        UserId<span class="token punctuation">:</span>   <span class="token string">"user123"</span><span class="token punctuation">,</span></span>
<span class="line">        Resource<span class="token punctuation">:</span> <span class="token string">"users"</span><span class="token punctuation">,</span></span>
<span class="line">        Action<span class="token punctuation">:</span>   <span class="token string">"read"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">ResetTimer</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">RunParallel</span><span class="token punctuation">(</span><span class="token keyword">func</span><span class="token punctuation">(</span>pb <span class="token operator">*</span>testing<span class="token punctuation">.</span>PB<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">for</span> pb<span class="token punctuation">.</span><span class="token function">Next</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CheckPermission</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> req<span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                b<span class="token punctuation">.</span><span class="token function">Fatal</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 内存分配测试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">BenchmarkUserService_CreateUser_Memory</span><span class="token punctuation">(</span>b <span class="token operator">*</span>testing<span class="token punctuation">.</span>B<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token function">setupUserService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">ReportAllocs</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    b<span class="token punctuation">.</span><span class="token function">ResetTimer</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> b<span class="token punctuation">.</span>N<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        user <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">        err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            b<span class="token punctuation">.</span><span class="token function">Fatal</span><span class="token punctuation">(</span>err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="压力测试" tabindex="-1"><a class="header-anchor" href="#压力测试">#</a> 压力测试</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> stress</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"context"</span></span>
<span class="line">    <span class="token string">"sync"</span></span>
<span class="line">    <span class="token string">"testing"</span></span>
<span class="line">    <span class="token string">"time"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 并发用户创建压力测试</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestConcurrentUserCreation</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token function">setupUserService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    concurrency <span class="token operator">:=</span> <span class="token number">100</span></span>
<span class="line">    iterations <span class="token operator">:=</span> <span class="token number">1000</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> wg sync<span class="token punctuation">.</span>WaitGroup</span>
<span class="line">    errors <span class="token operator">:=</span> <span class="token function">make</span><span class="token punctuation">(</span><span class="token keyword">chan</span> <span class="token builtin">error</span><span class="token punctuation">,</span> concurrency<span class="token operator">*</span>iterations<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    start <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Now</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> i <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> concurrency<span class="token punctuation">;</span> i<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">        wg<span class="token punctuation">.</span><span class="token function">Add</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">go</span> <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">defer</span> wg<span class="token punctuation">.</span><span class="token function">Done</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            <span class="token keyword">for</span> j <span class="token operator">:=</span> <span class="token number">0</span><span class="token punctuation">;</span> j <span class="token operator">&lt;</span> iterations<span class="token punctuation">;</span> j<span class="token operator">++</span> <span class="token punctuation">{</span></span>
<span class="line">                user <span class="token operator">:=</span> <span class="token function">NewUserFactory</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Build</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">                <span class="token keyword">if</span> err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span><span class="token punctuation">;</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">                    errors <span class="token operator">&lt;-</span> err</span>
<span class="line">                    <span class="token keyword">return</span></span>
<span class="line">                <span class="token punctuation">}</span></span>
<span class="line">            <span class="token punctuation">}</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    wg<span class="token punctuation">.</span><span class="token function">Wait</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token function">close</span><span class="token punctuation">(</span>errors<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    duration <span class="token operator">:=</span> time<span class="token punctuation">.</span><span class="token function">Since</span><span class="token punctuation">(</span>start<span class="token punctuation">)</span></span>
<span class="line">    totalOps <span class="token operator">:=</span> concurrency <span class="token operator">*</span> iterations</span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 检查错误</span></span>
<span class="line">    errorCount <span class="token operator">:=</span> <span class="token number">0</span></span>
<span class="line">    <span class="token keyword">for</span> err <span class="token operator">:=</span> <span class="token keyword">range</span> errors <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Logf</span><span class="token punctuation">(</span><span class="token string">"Error: %v"</span><span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        errorCount<span class="token operator">++</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">if</span> errorCount <span class="token operator">></span> <span class="token number">0</span> <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Fatalf</span><span class="token punctuation">(</span><span class="token string">"Failed operations: %d/%d"</span><span class="token punctuation">,</span> errorCount<span class="token punctuation">,</span> totalOps<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 性能指标</span></span>
<span class="line">    opsPerSecond <span class="token operator">:=</span> <span class="token function">float64</span><span class="token punctuation">(</span>totalOps<span class="token punctuation">)</span> <span class="token operator">/</span> duration<span class="token punctuation">.</span><span class="token function">Seconds</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    t<span class="token punctuation">.</span><span class="token function">Logf</span><span class="token punctuation">(</span><span class="token string">"Operations: %d"</span><span class="token punctuation">,</span> totalOps<span class="token punctuation">)</span></span>
<span class="line">    t<span class="token punctuation">.</span><span class="token function">Logf</span><span class="token punctuation">(</span><span class="token string">"Duration: %v"</span><span class="token punctuation">,</span> duration<span class="token punctuation">)</span></span>
<span class="line">    t<span class="token punctuation">.</span><span class="token function">Logf</span><span class="token punctuation">(</span><span class="token string">"Ops/sec: %.2f"</span><span class="token punctuation">,</span> opsPerSecond<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 性能断言</span></span>
<span class="line">    <span class="token keyword">if</span> opsPerSecond <span class="token operator">&lt;</span> <span class="token number">1000</span> <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"Performance below threshold: %.2f ops/sec &lt; 1000 ops/sec"</span><span class="token punctuation">,</span> opsPerSecond<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-测试覆盖率" tabindex="-1"><a class="header-anchor" href="#_3-测试覆盖率">#</a> 3. 测试覆盖率</h3>
<h4 id="覆盖率配置" tabindex="-1"><a class="header-anchor" href="#覆盖率配置">#</a> 覆盖率配置</h4>
<div class="language-makefile line-numbers-mode" data-highlighter="prismjs" data-ext="makefile"><pre v-pre><code class="language-makefile"><span class="line"><span class="token comment"># Makefile</span></span>
<span class="line"><span class="token builtin-target builtin">.PHONY</span><span class="token punctuation">:</span> test test-unit test-integration test-e2e test-coverage</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 单元测试</span></span>
<span class="line"><span class="token target symbol">test-unit</span><span class="token punctuation">:</span></span>
<span class="line">	go test -v -race -short ./...</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 集成测试</span></span>
<span class="line"><span class="token target symbol">test-integration</span><span class="token punctuation">:</span></span>
<span class="line">	go test -v -race -tags<span class="token operator">=</span>integration ./...</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 端到端测试</span></span>
<span class="line"><span class="token target symbol">test-e2e</span><span class="token punctuation">:</span></span>
<span class="line">	go test -v -race -tags<span class="token operator">=</span>e2e ./...</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 所有测试</span></span>
<span class="line"><span class="token target symbol">test</span><span class="token punctuation">:</span> test-unit test-integration test-e2e</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 测试覆盖率</span></span>
<span class="line"><span class="token target symbol">test-coverage</span><span class="token punctuation">:</span></span>
<span class="line">	go test -v -race -coverprofile<span class="token operator">=</span>coverage.out -covermode<span class="token operator">=</span>atomic ./...</span>
<span class="line">	go tool cover -html<span class="token operator">=</span>coverage.out -o coverage.html</span>
<span class="line">	go tool cover -func<span class="token operator">=</span>coverage.out</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 覆盖率报告</span></span>
<span class="line"><span class="token target symbol">coverage-report</span><span class="token punctuation">:</span></span>
<span class="line">	go tool cover -html<span class="token operator">=</span>coverage.out</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 基准测试</span></span>
<span class="line"><span class="token target symbol">benchmark</span><span class="token punctuation">:</span></span>
<span class="line">	go test -bench<span class="token operator">=</span>. -benchmem -cpuprofile<span class="token operator">=</span>cpu.prof -memprofile<span class="token operator">=</span>mem.prof ./...</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 压力测试</span></span>
<span class="line"><span class="token target symbol">stress-test</span><span class="token punctuation">:</span></span>
<span class="line">	go test -v -race -tags<span class="token operator">=</span>stress ./...</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h4 id="覆盖率分析" tabindex="-1"><a class="header-anchor" href="#覆盖率分析">#</a> 覆盖率分析</h4>
<div class="language-bash line-numbers-mode" data-highlighter="prismjs" data-ext="sh"><pre v-pre><code class="language-bash"><span class="line"><span class="token shebang important">#!/bin/bash</span></span>
<span class="line"><span class="token comment"># scripts/coverage.sh</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">set</span> <span class="token parameter variable">-e</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 运行测试并生成覆盖率报告</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Running tests with coverage..."</span></span>
<span class="line">go <span class="token builtin class-name">test</span> <span class="token parameter variable">-v</span> <span class="token parameter variable">-race</span> <span class="token parameter variable">-coverprofile</span><span class="token operator">=</span>coverage.out <span class="token parameter variable">-covermode</span><span class="token operator">=</span>atomic ./<span class="token punctuation">..</span>.</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成HTML报告</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Generating HTML coverage report..."</span></span>
<span class="line">go tool cover <span class="token parameter variable">-html</span><span class="token operator">=</span>coverage.out <span class="token parameter variable">-o</span> coverage.html</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 显示覆盖率统计</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Coverage statistics:"</span></span>
<span class="line">go tool cover <span class="token parameter variable">-func</span><span class="token operator">=</span>coverage.out</span>
<span class="line"></span>
<span class="line"><span class="token comment"># 检查覆盖率阈值</span></span>
<span class="line"><span class="token assign-left variable">COVERAGE</span><span class="token operator">=</span><span class="token variable"><span class="token variable">$(</span>go tool cover <span class="token parameter variable">-func</span><span class="token operator">=</span>coverage.out <span class="token operator">|</span> <span class="token function">grep</span> total <span class="token operator">|</span> <span class="token function">awk</span> <span class="token string">'{print $3}'</span> <span class="token operator">|</span> <span class="token function">sed</span> <span class="token string">'s/%//'</span><span class="token variable">)</span></span></span>
<span class="line"><span class="token assign-left variable">THRESHOLD</span><span class="token operator">=</span><span class="token number">80</span></span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Total coverage: <span class="token variable">${COVERAGE}</span>%"</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">if</span> <span class="token variable"><span class="token punctuation">((</span> $<span class="token punctuation">(</span>echo "$COVERAGE <span class="token operator">&lt;</span> $THRESHOLD" <span class="token operator">|</span> bc <span class="token operator">-</span>l<span class="token punctuation">)</span> <span class="token punctuation">))</span></span><span class="token punctuation">;</span> <span class="token keyword">then</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"❌ Coverage <span class="token variable">${COVERAGE}</span>% is below threshold <span class="token variable">${THRESHOLD}</span>%"</span></span>
<span class="line">    <span class="token builtin class-name">exit</span> <span class="token number">1</span></span>
<span class="line"><span class="token keyword">else</span></span>
<span class="line">    <span class="token builtin class-name">echo</span> <span class="token string">"✅ Coverage <span class="token variable">${COVERAGE}</span>% meets threshold <span class="token variable">${THRESHOLD}</span>%"</span></span>
<span class="line"><span class="token keyword">fi</span></span>
<span class="line"></span>
<span class="line"><span class="token comment"># 生成覆盖率徽章</span></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Generating coverage badge..."</span></span>
<span class="line"><span class="token function">curl</span> <span class="token parameter variable">-s</span> <span class="token string">"https://img.shields.io/badge/coverage-<span class="token variable">${COVERAGE}</span>%25-brightgreen"</span> <span class="token operator">></span> coverage-badge.svg</span>
<span class="line"></span>
<span class="line"><span class="token builtin class-name">echo</span> <span class="token string">"Coverage report generated: coverage.html"</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="🚀-测试自动化" tabindex="-1"><a class="header-anchor" href="#🚀-测试自动化">#</a> 🚀 测试自动化</h2>
<h3 id="_1-ci-cd集成" tabindex="-1"><a class="header-anchor" href="#_1-ci-cd集成">#</a> 1. CI/CD集成</h3>
<h4 id="github-actions配置" tabindex="-1"><a class="header-anchor" href="#github-actions配置">#</a> GitHub Actions配置</h4>
<div class="language-yaml line-numbers-mode" data-highlighter="prismjs" data-ext="yml"><pre v-pre><code class="language-yaml"><span class="line"><span class="token comment"># .github/workflows/test.yml</span></span>
<span class="line"><span class="token key atrule">name</span><span class="token punctuation">:</span> Tests</span>
<span class="line"></span>
<span class="line"><span class="token key atrule">on</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">push</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">branches</span><span class="token punctuation">:</span> <span class="token punctuation">[</span> main<span class="token punctuation">,</span> develop <span class="token punctuation">]</span></span>
<span class="line">  <span class="token key atrule">pull_request</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">branches</span><span class="token punctuation">:</span> <span class="token punctuation">[</span> main <span class="token punctuation">]</span></span>
<span class="line"></span>
<span class="line"><span class="token key atrule">jobs</span><span class="token punctuation">:</span></span>
<span class="line">  <span class="token key atrule">unit-tests</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">runs-on</span><span class="token punctuation">:</span> ubuntu<span class="token punctuation">-</span>latest</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">services</span><span class="token punctuation">:</span></span>
<span class="line">      <span class="token key atrule">postgres</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span><span class="token number">15</span></span>
<span class="line">        <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token key atrule">POSTGRES_PASSWORD</span><span class="token punctuation">:</span> postgres</span>
<span class="line">          <span class="token key atrule">POSTGRES_DB</span><span class="token punctuation">:</span> testdb</span>
<span class="line">        <span class="token key atrule">options</span><span class="token punctuation">:</span> <span class="token punctuation">></span><span class="token punctuation">-</span></span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>cmd pg_isready</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>interval 10s</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>timeout 5s</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>retries 5</span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> 5432<span class="token punctuation">:</span><span class="token number">5432</span></span>
<span class="line">      </span>
<span class="line">      <span class="token key atrule">redis</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">image</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span><span class="token number">7</span></span>
<span class="line">        <span class="token key atrule">options</span><span class="token punctuation">:</span> <span class="token punctuation">></span><span class="token punctuation">-</span></span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>cmd "redis<span class="token punctuation">-</span>cli ping"</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>interval 10s</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>timeout 5s</span>
<span class="line">          <span class="token punctuation">-</span><span class="token punctuation">-</span>health<span class="token punctuation">-</span>retries 5</span>
<span class="line">        <span class="token key atrule">ports</span><span class="token punctuation">:</span></span>
<span class="line">          <span class="token punctuation">-</span> 6379<span class="token punctuation">:</span><span class="token number">6379</span></span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">steps</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">uses</span><span class="token punctuation">:</span> actions/checkout@v4</span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Set up Go</span>
<span class="line">      <span class="token key atrule">uses</span><span class="token punctuation">:</span> actions/setup<span class="token punctuation">-</span>go@v4</span>
<span class="line">      <span class="token key atrule">with</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">go-version</span><span class="token punctuation">:</span> <span class="token string">'1.21'</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Cache Go modules</span>
<span class="line">      <span class="token key atrule">uses</span><span class="token punctuation">:</span> actions/cache@v3</span>
<span class="line">      <span class="token key atrule">with</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">path</span><span class="token punctuation">:</span> ~/go/pkg/mod</span>
<span class="line">        <span class="token key atrule">key</span><span class="token punctuation">:</span> $<span class="token punctuation">{</span><span class="token punctuation">{</span> runner.os <span class="token punctuation">}</span><span class="token punctuation">}</span><span class="token punctuation">-</span>go<span class="token punctuation">-</span>$<span class="token punctuation">{</span><span class="token punctuation">{</span> hashFiles('<span class="token important">**/go.sum')</span> <span class="token punctuation">}</span><span class="token punctuation">}</span></span>
<span class="line">        <span class="token key atrule">restore-keys</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">          ${{ runner.os }}-go-</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Install dependencies</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> go mod download</span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Run unit tests</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> make test<span class="token punctuation">-</span>unit</span>
<span class="line">      <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">DATABASE_URL</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>//postgres<span class="token punctuation">:</span>postgres@localhost<span class="token punctuation">:</span>5432/testdb<span class="token punctuation">?</span>sslmode=disable</span>
<span class="line">        <span class="token key atrule">REDIS_URL</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span>//localhost<span class="token punctuation">:</span><span class="token number">6379</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Run integration tests</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> make test<span class="token punctuation">-</span>integration</span>
<span class="line">      <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">DATABASE_URL</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>//postgres<span class="token punctuation">:</span>postgres@localhost<span class="token punctuation">:</span>5432/testdb<span class="token punctuation">?</span>sslmode=disable</span>
<span class="line">        <span class="token key atrule">REDIS_URL</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span>//localhost<span class="token punctuation">:</span><span class="token number">6379</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Generate coverage report</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> make test<span class="token punctuation">-</span>coverage</span>
<span class="line">      <span class="token key atrule">env</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">DATABASE_URL</span><span class="token punctuation">:</span> postgres<span class="token punctuation">:</span>//postgres<span class="token punctuation">:</span>postgres@localhost<span class="token punctuation">:</span>5432/testdb<span class="token punctuation">?</span>sslmode=disable</span>
<span class="line">        <span class="token key atrule">REDIS_URL</span><span class="token punctuation">:</span> redis<span class="token punctuation">:</span>//localhost<span class="token punctuation">:</span><span class="token number">6379</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Upload coverage to Codecov</span>
<span class="line">      <span class="token key atrule">uses</span><span class="token punctuation">:</span> codecov/codecov<span class="token punctuation">-</span>action@v3</span>
<span class="line">      <span class="token key atrule">with</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">file</span><span class="token punctuation">:</span> ./coverage.out</span>
<span class="line">        <span class="token key atrule">flags</span><span class="token punctuation">:</span> unittests</span>
<span class="line">        <span class="token key atrule">name</span><span class="token punctuation">:</span> codecov<span class="token punctuation">-</span>umbrella</span>
<span class="line"></span>
<span class="line">  <span class="token key atrule">e2e-tests</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token key atrule">runs-on</span><span class="token punctuation">:</span> ubuntu<span class="token punctuation">-</span>latest</span>
<span class="line">    <span class="token key atrule">needs</span><span class="token punctuation">:</span> unit<span class="token punctuation">-</span>tests</span>
<span class="line">    </span>
<span class="line">    <span class="token key atrule">steps</span><span class="token punctuation">:</span></span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">uses</span><span class="token punctuation">:</span> actions/checkout@v4</span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Set up Go</span>
<span class="line">      <span class="token key atrule">uses</span><span class="token punctuation">:</span> actions/setup<span class="token punctuation">-</span>go@v4</span>
<span class="line">      <span class="token key atrule">with</span><span class="token punctuation">:</span></span>
<span class="line">        <span class="token key atrule">go-version</span><span class="token punctuation">:</span> <span class="token string">'1.21'</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Build application</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> make build</span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Start services</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> <span class="token punctuation">|</span><span class="token scalar string"></span>
<span class="line">        docker-compose -f docker-compose.test.yml up -d</span>
<span class="line">        sleep 30</span></span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Run E2E tests</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> make test<span class="token punctuation">-</span>e2e</span>
<span class="line">    </span>
<span class="line">    <span class="token punctuation">-</span> <span class="token key atrule">name</span><span class="token punctuation">:</span> Stop services</span>
<span class="line">      <span class="token key atrule">run</span><span class="token punctuation">:</span> docker<span class="token punctuation">-</span>compose <span class="token punctuation">-</span>f docker<span class="token punctuation">-</span>compose.test.yml down</span>
<span class="line">      <span class="token key atrule">if</span><span class="token punctuation">:</span> always()</span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-测试数据管理" tabindex="-1"><a class="header-anchor" href="#_2-测试数据管理">#</a> 2. 测试数据管理</h3>
<h4 id="测试数据库迁移" tabindex="-1"><a class="header-anchor" href="#测试数据库迁移">#</a> 测试数据库迁移</h4>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token keyword">package</span> testutil</span>
<span class="line"></span>
<span class="line"><span class="token keyword">import</span> <span class="token punctuation">(</span></span>
<span class="line">    <span class="token string">"database/sql"</span></span>
<span class="line">    <span class="token string">"fmt"</span></span>
<span class="line">    <span class="token string">"io/ioutil"</span></span>
<span class="line">    <span class="token string">"path/filepath"</span></span>
<span class="line">    <span class="token string">"sort"</span></span>
<span class="line">    <span class="token string">"strings"</span></span>
<span class="line"><span class="token punctuation">)</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">type</span> TestMigrator <span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">    db          <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB</span>
<span class="line">    migrationsDir <span class="token builtin">string</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">NewTestMigrator</span><span class="token punctuation">(</span>db <span class="token operator">*</span>sql<span class="token punctuation">.</span>DB<span class="token punctuation">,</span> migrationsDir <span class="token builtin">string</span><span class="token punctuation">)</span> <span class="token operator">*</span>TestMigrator <span class="token punctuation">{</span></span>
<span class="line">    <span class="token keyword">return</span> <span class="token operator">&amp;</span>TestMigrator<span class="token punctuation">{</span></span>
<span class="line">        db<span class="token punctuation">:</span>          db<span class="token punctuation">,</span></span>
<span class="line">        migrationsDir<span class="token punctuation">:</span> migrationsDir<span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>TestMigrator<span class="token punctuation">)</span> <span class="token function">Up</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    files<span class="token punctuation">,</span> err <span class="token operator">:=</span> ioutil<span class="token punctuation">.</span><span class="token function">ReadDir</span><span class="token punctuation">(</span>m<span class="token punctuation">.</span>migrationsDir<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> migrations <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> file <span class="token operator">:=</span> <span class="token keyword">range</span> files <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">HasSuffix</span><span class="token punctuation">(</span>file<span class="token punctuation">.</span><span class="token function">Name</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">".up.sql"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            migrations <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>migrations<span class="token punctuation">,</span> file<span class="token punctuation">.</span><span class="token function">Name</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    sort<span class="token punctuation">.</span><span class="token function">Strings</span><span class="token punctuation">(</span>migrations<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> migration <span class="token operator">:=</span> <span class="token keyword">range</span> migrations <span class="token punctuation">{</span></span>
<span class="line">        content<span class="token punctuation">,</span> err <span class="token operator">:=</span> ioutil<span class="token punctuation">.</span><span class="token function">ReadFile</span><span class="token punctuation">(</span>filepath<span class="token punctuation">.</span><span class="token function">Join</span><span class="token punctuation">(</span>m<span class="token punctuation">.</span>migrationsDir<span class="token punctuation">,</span> migration<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> m<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">Exec</span><span class="token punctuation">(</span><span class="token function">string</span><span class="token punctuation">(</span>content<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to execute migration %s: %w"</span><span class="token punctuation">,</span> migration<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token keyword">func</span> <span class="token punctuation">(</span>m <span class="token operator">*</span>TestMigrator<span class="token punctuation">)</span> <span class="token function">Down</span><span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token builtin">error</span> <span class="token punctuation">{</span></span>
<span class="line">    files<span class="token punctuation">,</span> err <span class="token operator">:=</span> ioutil<span class="token punctuation">.</span><span class="token function">ReadDir</span><span class="token punctuation">(</span>m<span class="token punctuation">.</span>migrationsDir<span class="token punctuation">)</span></span>
<span class="line">    <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">return</span> err</span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">var</span> migrations <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token builtin">string</span></span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> file <span class="token operator">:=</span> <span class="token keyword">range</span> files <span class="token punctuation">{</span></span>
<span class="line">        <span class="token keyword">if</span> strings<span class="token punctuation">.</span><span class="token function">HasSuffix</span><span class="token punctuation">(</span>file<span class="token punctuation">.</span><span class="token function">Name</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> <span class="token string">".down.sql"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            migrations <span class="token operator">=</span> <span class="token function">append</span><span class="token punctuation">(</span>migrations<span class="token punctuation">,</span> file<span class="token punctuation">.</span><span class="token function">Name</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// 逆序执行</span></span>
<span class="line">    sort<span class="token punctuation">.</span><span class="token function">Sort</span><span class="token punctuation">(</span>sort<span class="token punctuation">.</span><span class="token function">Reverse</span><span class="token punctuation">(</span>sort<span class="token punctuation">.</span><span class="token function">StringSlice</span><span class="token punctuation">(</span>migrations<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> migration <span class="token operator">:=</span> <span class="token keyword">range</span> migrations <span class="token punctuation">{</span></span>
<span class="line">        content<span class="token punctuation">,</span> err <span class="token operator">:=</span> ioutil<span class="token punctuation">.</span><span class="token function">ReadFile</span><span class="token punctuation">(</span>filepath<span class="token punctuation">.</span><span class="token function">Join</span><span class="token punctuation">(</span>m<span class="token punctuation">.</span>migrationsDir<span class="token punctuation">,</span> migration<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> err</span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">        </span>
<span class="line">        <span class="token boolean">_</span><span class="token punctuation">,</span> err <span class="token operator">=</span> m<span class="token punctuation">.</span>db<span class="token punctuation">.</span><span class="token function">Exec</span><span class="token punctuation">(</span><span class="token function">string</span><span class="token punctuation">(</span>content<span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token keyword">if</span> err <span class="token operator">!=</span> <span class="token boolean">nil</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token keyword">return</span> fmt<span class="token punctuation">.</span><span class="token function">Errorf</span><span class="token punctuation">(</span><span class="token string">"failed to execute migration %s: %w"</span><span class="token punctuation">,</span> migration<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">return</span> <span class="token boolean">nil</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📊-测试最佳实践" tabindex="-1"><a class="header-anchor" href="#📊-测试最佳实践">#</a> 📊 测试最佳实践</h2>
<h3 id="_1-测试命名规范" tabindex="-1"><a class="header-anchor" href="#_1-测试命名规范">#</a> 1. 测试命名规范</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 好的测试命名</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CreateUser_Success</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CreateUser_UsernameExists_ReturnsError</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_GetUser_NotFound_ReturnsError</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span>
<span class="line"><span class="token comment">// 不好的测试命名</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestCreateUser</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUser</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestError</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_2-测试结构模式" tabindex="-1"><a class="header-anchor" href="#_2-测试结构模式">#</a> 2. 测试结构模式</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// AAA模式：Arrange, Act, Assert</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CreateUser_Success</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    <span class="token comment">// Arrange - 准备测试数据和环境</span></span>
<span class="line">    ctx <span class="token operator">:=</span> context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">    mockRepo <span class="token operator">:=</span> <span class="token operator">&amp;</span>MockUserRepository<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">    service <span class="token operator">:=</span> <span class="token operator">&amp;</span>UserService<span class="token punctuation">{</span>repo<span class="token punctuation">:</span> mockRepo<span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    user <span class="token operator">:=</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span></span>
<span class="line">        Username<span class="token punctuation">:</span> <span class="token string">"testuser"</span><span class="token punctuation">,</span></span>
<span class="line">        Email<span class="token punctuation">:</span>    <span class="token string">"test@example.com"</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    mockRepo<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span><span class="token boolean">nil</span><span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Act - 执行被测试的操作</span></span>
<span class="line">    err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>ctx<span class="token punctuation">,</span> user<span class="token punctuation">)</span></span>
<span class="line">    </span>
<span class="line">    <span class="token comment">// Assert - 验证结果</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NoError</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">    assert<span class="token punctuation">.</span><span class="token function">NotEmpty</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> user<span class="token punctuation">.</span>ID<span class="token punctuation">)</span></span>
<span class="line">    mockRepo<span class="token punctuation">.</span><span class="token function">AssertExpectations</span><span class="token punctuation">(</span>t<span class="token punctuation">)</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_3-测试隔离" tabindex="-1"><a class="header-anchor" href="#_3-测试隔离">#</a> 3. 测试隔离</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 每个测试都应该是独立的</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CRUD</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    tests <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">        name <span class="token builtin">string</span></span>
<span class="line">        test <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">,</span> service <span class="token operator">*</span>UserService<span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"CreateUser_Success"</span><span class="token punctuation">,</span></span>
<span class="line">            test<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">,</span> service <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token comment">// 测试逻辑</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"GetUser_Success"</span><span class="token punctuation">,</span></span>
<span class="line">            test<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">,</span> service <span class="token operator">*</span>UserService<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token comment">// 测试逻辑</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> tt <span class="token operator">:=</span> <span class="token keyword">range</span> tests <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>tt<span class="token punctuation">.</span>name<span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            <span class="token comment">// 为每个测试创建独立的服务实例</span></span>
<span class="line">            service <span class="token operator">:=</span> <span class="token function">setupUserService</span><span class="token punctuation">(</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token keyword">defer</span> <span class="token function">cleanupUserService</span><span class="token punctuation">(</span>service<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            tt<span class="token punctuation">.</span><span class="token function">test</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> service<span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h3 id="_4-错误测试" tabindex="-1"><a class="header-anchor" href="#_4-错误测试">#</a> 4. 错误测试</h3>
<div class="language-go line-numbers-mode" data-highlighter="prismjs" data-ext="go"><pre v-pre><code class="language-go"><span class="line"><span class="token comment">// 测试错误场景</span></span>
<span class="line"><span class="token keyword">func</span> <span class="token function">TestUserService_CreateUser_ErrorCases</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">    tests <span class="token operator">:=</span> <span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token keyword">struct</span> <span class="token punctuation">{</span></span>
<span class="line">        name          <span class="token builtin">string</span></span>
<span class="line">        user          <span class="token operator">*</span>User</span>
<span class="line">        mockSetup     <span class="token keyword">func</span><span class="token punctuation">(</span><span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span></span>
<span class="line">        expectedError <span class="token builtin">error</span></span>
<span class="line">    <span class="token punctuation">}</span><span class="token punctuation">{</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"EmptyUsername"</span><span class="token punctuation">,</span></span>
<span class="line">            user<span class="token punctuation">:</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span>Email<span class="token punctuation">:</span> <span class="token string">"test@example.com"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            mockSetup<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>mock <span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                <span class="token comment">// 不设置任何期望，因为验证应该在调用repo之前失败</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            expectedError<span class="token punctuation">:</span> ErrEmptyUsername<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"InvalidEmail"</span><span class="token punctuation">,</span></span>
<span class="line">            user<span class="token punctuation">:</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span>Username<span class="token punctuation">:</span> <span class="token string">"test"</span><span class="token punctuation">,</span> Email<span class="token punctuation">:</span> <span class="token string">"invalid-email"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            mockSetup<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>mock <span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span> <span class="token punctuation">{</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            expectedError<span class="token punctuation">:</span> ErrInvalidEmail<span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">{</span></span>
<span class="line">            name<span class="token punctuation">:</span> <span class="token string">"DatabaseError"</span><span class="token punctuation">,</span></span>
<span class="line">            user<span class="token punctuation">:</span> <span class="token operator">&amp;</span>User<span class="token punctuation">{</span>Username<span class="token punctuation">:</span> <span class="token string">"test"</span><span class="token punctuation">,</span> Email<span class="token punctuation">:</span> <span class="token string">"test@example.com"</span><span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            mockSetup<span class="token punctuation">:</span> <span class="token keyword">func</span><span class="token punctuation">(</span>mock <span class="token operator">*</span>MockUserRepository<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">                mock<span class="token punctuation">.</span><span class="token function">On</span><span class="token punctuation">(</span><span class="token string">"Create"</span><span class="token punctuation">,</span> mock<span class="token punctuation">.</span>Anything<span class="token punctuation">,</span> mock<span class="token punctuation">.</span>Anything<span class="token punctuation">)</span><span class="token punctuation">.</span><span class="token function">Return</span><span class="token punctuation">(</span>errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"database error"</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">            <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">            expectedError<span class="token punctuation">:</span> errors<span class="token punctuation">.</span><span class="token function">New</span><span class="token punctuation">(</span><span class="token string">"database error"</span><span class="token punctuation">)</span><span class="token punctuation">,</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">,</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line">    </span>
<span class="line">    <span class="token keyword">for</span> <span class="token boolean">_</span><span class="token punctuation">,</span> tt <span class="token operator">:=</span> <span class="token keyword">range</span> tests <span class="token punctuation">{</span></span>
<span class="line">        t<span class="token punctuation">.</span><span class="token function">Run</span><span class="token punctuation">(</span>tt<span class="token punctuation">.</span>name<span class="token punctuation">,</span> <span class="token keyword">func</span><span class="token punctuation">(</span>t <span class="token operator">*</span>testing<span class="token punctuation">.</span>T<span class="token punctuation">)</span> <span class="token punctuation">{</span></span>
<span class="line">            mockRepo <span class="token operator">:=</span> <span class="token operator">&amp;</span>MockUserRepository<span class="token punctuation">{</span><span class="token punctuation">}</span></span>
<span class="line">            tt<span class="token punctuation">.</span><span class="token function">mockSetup</span><span class="token punctuation">(</span>mockRepo<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            service <span class="token operator">:=</span> <span class="token operator">&amp;</span>UserService<span class="token punctuation">{</span>repo<span class="token punctuation">:</span> mockRepo<span class="token punctuation">}</span></span>
<span class="line">            </span>
<span class="line">            err <span class="token operator">:=</span> service<span class="token punctuation">.</span><span class="token function">CreateUser</span><span class="token punctuation">(</span>context<span class="token punctuation">.</span><span class="token function">Background</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> tt<span class="token punctuation">.</span>user<span class="token punctuation">)</span></span>
<span class="line">            </span>
<span class="line">            assert<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> err<span class="token punctuation">)</span></span>
<span class="line">            assert<span class="token punctuation">.</span><span class="token function">Equal</span><span class="token punctuation">(</span>t<span class="token punctuation">,</span> tt<span class="token punctuation">.</span>expectedError<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">,</span> err<span class="token punctuation">.</span><span class="token function">Error</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span></span>
<span class="line">        <span class="token punctuation">}</span><span class="token punctuation">)</span></span>
<span class="line">    <span class="token punctuation">}</span></span>
<span class="line"><span class="token punctuation">}</span></span>
<span class="line"></span></code></pre>
<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><h2 id="📚-相关文档" tabindex="-1"><a class="header-anchor" href="#📚-相关文档">#</a> 📚 相关文档</h2>
<ul>
<li><RouteLink to="/development/">开发指南</RouteLink></li>
<li><RouteLink to="/development/architecture.html">架构设计</RouteLink></li>
<li><RouteLink to="/development/debugging.html">调试指南</RouteLink></li>
<li><RouteLink to="/development/performance.html">性能优化</RouteLink></li>
<li><RouteLink to="/api/">API文档</RouteLink></li>
<li><RouteLink to="/deployment/">部署指南</RouteLink></li>
</ul>
</div></template>


