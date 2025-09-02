export const siteData = JSON.parse("{\"base\":\"/vgo-docs/\",\"lang\":\"zh-CN\",\"title\":\"VGO微服务文档\",\"description\":\"企业级微服务架构解决方案 - 身份认证与访问管理解决方案\",\"head\":[[\"link\",{\"rel\":\"icon\",\"href\":\"/favicon.ico\"}],[\"meta\",{\"name\":\"viewport\",\"content\":\"width=device-width,initial-scale=1,user-scalable=no\"}],[\"meta\",{\"name\":\"theme-color\",\"content\":\"#3eaf7c\"}],[\"meta\",{\"name\":\"apple-mobile-web-app-capable\",\"content\":\"yes\"}],[\"meta\",{\"name\":\"apple-mobile-web-app-status-bar-style\",\"content\":\"black\"}],[\"meta\",{\"name\":\"keywords\",\"content\":\"VGO,微服务,身份认证,访问管理,IAM,Go,gRPC,文档\"}]],\"locales\":{}}")

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateSiteData) {
    __VUE_HMR_RUNTIME__.updateSiteData(siteData)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ siteData }) => {
    __VUE_HMR_RUNTIME__.updateSiteData(siteData)
  })
}
