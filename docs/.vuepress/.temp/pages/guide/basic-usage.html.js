import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/guide/basic-usage.html.vue"
const data = JSON.parse("{\"path\":\"/guide/basic-usage.html\",\"title\":\"基本使用\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"guide/basic-usage.md\"}")
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
