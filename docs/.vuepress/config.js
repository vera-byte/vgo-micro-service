import { defineUserConfig } from 'vuepress'
import { viteBundler } from '@vuepress/bundler-vite'
import { defaultTheme } from '@vuepress/theme-default'
import { backToTopPlugin } from '@vuepress/plugin-back-to-top'
import { mediumZoomPlugin } from '@vuepress/plugin-medium-zoom'
import { nprogressPlugin } from '@vuepress/plugin-nprogress'
import { searchPlugin } from '@vuepress/plugin-search'

export default defineUserConfig({
  lang: 'zh-CN',
  title: 'VGO微服务文档',
  
  // 打包工具配置
  bundler: viteBundler(),
  description: '企业级微服务架构解决方案 - 身份认证与访问管理解决方案',
  base: '/vgo-docs/',
  
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    ['meta', { name: 'viewport', content: 'width=device-width,initial-scale=1,user-scalable=no' }],
    ['meta', { name: 'theme-color', content: '#3eaf7c' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
    ['meta', { name: 'keywords', content: 'VGO,微服务,身份认证,访问管理,IAM,Go,gRPC,文档' }]
  ],

  theme: defaultTheme({
    logo: '/logo.png',
    colorMode: 'auto',
    colorModeSwitch: true,
    
    navbar: [
      {
        text: '首页',
        link: '/'
      },
      {
        text: '快速开始',
        link: '/guide/'
      },
      {
        text: 'API文档',
        children: [
          {
            text: 'API 概览',
            link: '/api/'
          },
          {
            text: '身份认证',
            link: '/api/authentication.md'
          },
          {
            text: 'gRPC API',
            link: '/api/grpc.md'
          },
          {
            text: 'REST API',
            link: '/api/rest.md'
          }
        ]
      },
      {
        text: '部署',
        children: [
          {
            text: '部署概览',
            link: '/deployment/'
          },
          {
            text: 'Docker部署',
            link: '/deployment/docker.md'
          },
          {
            text: 'Kubernetes部署',
            link: '/deployment/kubernetes.md'
          },
          {
            text: '监控配置',
            link: '/deployment/monitoring.md'
          }
        ]
      },
      {
        text: '开发指南',
        children: [
          {
            text: '开发概览',
            link: '/development/'
          },
          {
            text: '架构设计',
            link: '/development/architecture.md'
          },
          {
            text: '测试指南',
            link: '/development/testing.md'
          }
        ]
      },
      {
        text: 'GitHub',
        link: 'https://github.com/vera-byte/vgo_micro_service'
      }
    ],

    sidebar: {
      '/guide/': [
        {
          text: '快速开始',
          collapsible: true,
          children: [
            '/guide/README.md',
            '/guide/installation.md',
            '/guide/configuration.md',
            '/guide/basic-usage.md',
            '/guide/internationalization.md'
          ]
        }
      ],
      '/api/': [
        {
          text: 'API文档',
          collapsible: true,
          children: [
            '/api/README.md',
            '/api/user-management.md',
            '/api/authorization.md',
            '/api/policy-management.md',
            '/api/application-management.md',
            '/api/access-keys.md'
          ]
        }
      ],
      '/deployment/': [
        {
          text: '部署指南',
          collapsible: true,
          children: [
            '/deployment/README.md',
            '/deployment/docker-compose.md',
            '/deployment/kubernetes.md',
            '/deployment/monitoring.md',
            '/deployment/security.md'
          ]
        }
      ],
      '/development/': [
        {
          text: '开发指南',
          collapsible: true,
          children: [
            '/development/README.md',
            '/development/architecture.md',
            '/development/testing.md',
            '/development/debugging.md',
            '/development/performance.md'
          ]
        }
      ]
    },

    repo: 'vera-byte/vgo_micro_service',
    repoLabel: 'GitHub',
    docsDir: 'docs',
    docsBranch: 'main',
    editLink: true,
    editLinkText: '在 GitHub 上编辑此页',
    lastUpdated: true,
    lastUpdatedText: '最后更新'
  }),

  // 插件配置
  plugins: [
    backToTopPlugin(),
    nprogressPlugin(),
    mediumZoomPlugin(),
    searchPlugin({
      locales: {
        '/': {
          placeholder: '搜索文档'
        }
      }
    })
  ],

  // Markdown 配置
  markdown: {
    anchor: {
      permalink: true,
      permalinkBefore: true,
      permalinkSymbol: '#'
    },
    toc: {
      level: [1, 2, 3, 4]
    }
  }
})