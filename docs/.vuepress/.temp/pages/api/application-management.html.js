import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/application-management.html.vue"
const data = JSON.parse("{\"path\":\"/api/application-management.html\",\"title\":\"应用管理 API\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"api/application-management.md\"}")
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
