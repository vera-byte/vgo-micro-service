import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/authorization.html.vue"
const data = JSON.parse("{\"path\":\"/api/authorization.html\",\"title\":\"权限验证 API\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"api/authorization.md\"}")
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
