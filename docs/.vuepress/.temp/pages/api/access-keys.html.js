import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/api/access-keys.html.vue"
const data = JSON.parse("{\"path\":\"/api/access-keys.html\",\"title\":\"访问密钥管理 API\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"api/access-keys.md\"}")
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
