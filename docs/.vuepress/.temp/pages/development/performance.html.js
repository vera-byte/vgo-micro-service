import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/performance.html.vue"
const data = JSON.parse("{\"path\":\"/development/performance.html\",\"title\":\"性能优化指南\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"development/performance.md\"}")
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
