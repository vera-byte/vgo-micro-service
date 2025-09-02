import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/development/architecture.html.vue"
const data = JSON.parse("{\"path\":\"/development/architecture.html\",\"title\":\"架构设计\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"development/architecture.md\"}")
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
