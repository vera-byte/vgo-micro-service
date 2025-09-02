import comp from "/Users/mac/workspace/vgo_micro_service/docs/.vuepress/.temp/pages/deployment/docker-compose.html.vue"
const data = JSON.parse("{\"path\":\"/deployment/docker-compose.html\",\"title\":\"Docker Compose 部署\",\"lang\":\"zh-CN\",\"frontmatter\":{},\"git\":{},\"filePathRelative\":\"deployment/docker-compose.md\"}")
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
