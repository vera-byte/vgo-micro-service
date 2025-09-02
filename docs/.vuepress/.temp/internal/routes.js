export const redirects = JSON.parse("{}")

export const routes = Object.fromEntries([
  ["/", { loader: () => import(/* webpackChunkName: "index.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/index.html.js"), meta: {"title":""} }],
  ["/api/", { loader: () => import(/* webpackChunkName: "api_index.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/index.html.js"), meta: {"title":"API 文档"} }],
  ["/api/access-keys.html", { loader: () => import(/* webpackChunkName: "api_access-keys.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/access-keys.html.js"), meta: {"title":"访问密钥管理 API"} }],
  ["/api/application-management.html", { loader: () => import(/* webpackChunkName: "api_application-management.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/application-management.html.js"), meta: {"title":"应用管理 API"} }],
  ["/api/authorization.html", { loader: () => import(/* webpackChunkName: "api_authorization.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/authorization.html.js"), meta: {"title":"权限验证 API"} }],
  ["/api/policy-management.html", { loader: () => import(/* webpackChunkName: "api_policy-management.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/policy-management.html.js"), meta: {"title":"策略管理 API"} }],
  ["/api/user-management.html", { loader: () => import(/* webpackChunkName: "api_user-management.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/user-management.html.js"), meta: {"title":"用户管理 API"} }],
  ["/deployment/", { loader: () => import(/* webpackChunkName: "deployment_index.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/index.html.js"), meta: {"title":"部署指南"} }],
  ["/deployment/docker-compose.html", { loader: () => import(/* webpackChunkName: "deployment_docker-compose.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/docker-compose.html.js"), meta: {"title":"Docker Compose 部署"} }],
  ["/deployment/kubernetes.html", { loader: () => import(/* webpackChunkName: "deployment_kubernetes.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/kubernetes.html.js"), meta: {"title":"Kubernetes 部署"} }],
  ["/deployment/monitoring.html", { loader: () => import(/* webpackChunkName: "deployment_monitoring.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/monitoring.html.js"), meta: {"title":"监控配置"} }],
  ["/deployment/security.html", { loader: () => import(/* webpackChunkName: "deployment_security.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/security.html.js"), meta: {"title":"安全配置"} }],
  ["/development/", { loader: () => import(/* webpackChunkName: "development_index.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/index.html.js"), meta: {"title":"开发指南"} }],
  ["/development/architecture.html", { loader: () => import(/* webpackChunkName: "development_architecture.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/architecture.html.js"), meta: {"title":"架构设计"} }],
  ["/development/debugging.html", { loader: () => import(/* webpackChunkName: "development_debugging.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/debugging.html.js"), meta: {"title":"调试指南"} }],
  ["/development/performance.html", { loader: () => import(/* webpackChunkName: "development_performance.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/performance.html.js"), meta: {"title":"性能优化指南"} }],
  ["/development/testing.html", { loader: () => import(/* webpackChunkName: "development_testing.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/testing.html.js"), meta: {"title":"测试指南"} }],
  ["/guide/", { loader: () => import(/* webpackChunkName: "guide_index.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/guide/index.html.js"), meta: {"title":"快速开始"} }],
  ["/guide/basic-usage.html", { loader: () => import(/* webpackChunkName: "guide_basic-usage.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/guide/basic-usage.html.js"), meta: {"title":"基本使用"} }],
  ["/guide/configuration.html", { loader: () => import(/* webpackChunkName: "guide_configuration.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/guide/configuration.html.js"), meta: {"title":"配置详解"} }],
  ["/guide/installation.html", { loader: () => import(/* webpackChunkName: "guide_installation.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/guide/installation.html.js"), meta: {"title":"安装指南"} }],
  ["/404.html", { loader: () => import(/* webpackChunkName: "404.html" */"/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/404.html.js"), meta: {"title":""} }],
]);

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateRoutes) {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
  }
  if (__VUE_HMR_RUNTIME__.updateRedirects) {
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ routes, redirects }) => {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  })
}
