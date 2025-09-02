import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/monitoring.html.vue"
const data = JSON.parse("{\"path\":\"/deployment/monitoring.html\",\"title\":\"监控配置\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"deployment/monitoring.md\"}")
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
