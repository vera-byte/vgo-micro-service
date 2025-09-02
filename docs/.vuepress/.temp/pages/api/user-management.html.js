import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/user-management.html.vue"
const data = JSON.parse("{\"path\":\"/api/user-management.html\",\"title\":\"用户管理 API\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"api/user-management.md\"}")
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
