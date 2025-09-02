import { GitContributors } from "/Users/mac/workspace/vgo_micro_service/docs/node_modules/.pnpm/@vuepress+plugin-git@2.0.0-rc.112_vuepress@2.0.0-rc.25_@vuepress+bundler-vite@2.0.0-rc._b6c026d99e4f0146c55e497cba07d1f0/node_modules/@vuepress/plugin-git/lib/client/components/GitContributors.js";
import { GitChangelog } from "/Users/mac/workspace/vgo_micro_service/docs/node_modules/.pnpm/@vuepress+plugin-git@2.0.0-rc.112_vuepress@2.0.0-rc.25_@vuepress+bundler-vite@2.0.0-rc._b6c026d99e4f0146c55e497cba07d1f0/node_modules/@vuepress/plugin-git/lib/client/components/GitChangelog.js";

export default {
  enhance: ({ app }) => {
    app.component("GitContributors", GitContributors);
    app.component("GitChangelog", GitChangelog);
  },
};
