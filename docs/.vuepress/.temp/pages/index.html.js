import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/index.html.vue"
const data = JSON.parse("{\"path\":\"/\",\"title\":\"\",\"lang\":\"zh-CN\",\"frontmatter\":{\"home\":true,\"heroImage\":\"/logo.png\",\"heroText\":\"VGO微服务\",\"tagline\":\"企业级微服务架构解决方案\",\"actionText\":\"快速开始 →\",\"actionLink\":\"/guide/\",\"features\":[{\"title\":\"🚀 高性能\",\"details\":\"基于Go语言开发，采用gRPC通信协议，提供高性能的微服务解决方案\"},{\"title\":\"🔒 安全可靠\",\"details\":\"完整的IAM身份认证与授权系统，支持细粒度权限控制和访问密钥管理\"},{\"title\":\"📊 可观测性\",\"details\":\"集成Prometheus监控、Jaeger链路追踪和结构化日志，提供全方位的系统观测能力\"},{\"title\":\"🐳 云原生\",\"details\":\"支持Docker容器化部署和Kubernetes编排，完美适配云原生环境\"},{\"title\":\"🔧 易于扩展\",\"details\":\"模块化设计，支持水平扩展，可根据业务需求灵活调整服务规模\"},{\"title\":\"📱 多端支持\",\"details\":\"支持Web、移动端、API等多种应用类型，提供统一的身份认证服务\"}],\"footer\":\"MIT Licensed | Copyright © 2024 VGO Team\"},\"git\":{},\"filePathRelative\":\"README.md\"}")
export { comp, data }

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updatePageData) {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ data }) => {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  })
}
