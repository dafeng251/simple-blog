# 个人博客系统 — 前端技术方案

## 技术栈

| 层 | 选型 | 理由 |
|---|---|---|
| 框架 | Vue 3 + Vite | 轻量，构建快 |
| UI 库 | Element Plus | 组件丰富，后台管理模板多 |
| 状态管理 | Pinia | Vue 3 官方推荐 |
| Markdown 编辑器 | md-editor-v3 | Vue 3 原生，活跃维护 |
| HTTP 客户端 | Axios | 拦截器支持，社区标准 |
| 路由 | Vue Router 4 | Vue 3 配套 |
| 部署 | Caddy 静态托管 | 与后端共用 Caddy |

## 项目结构

```
blog-web/
├── public/
│   └── favicon.ico
├── src/
│   ├── api/
│   │   ├── request.ts         # Axios 实例、拦截器
│   │   ├── post.ts            # 文章接口
│   │   ├── category.ts        # 分类接口
│   │   ├── tag.ts             # 标签接口
│   │   ├── comment.ts         # 评论接口
│   │   ├── auth.ts            # 登录接口
│   │   ├── upload.ts          # 上传接口
│   │   └── config.ts          # 站点配置接口
│   ├── stores/
│   │   ├── user.ts            # 用户状态、Token
│   │   └── app.ts             # 全局配置
│   ├── router/
│   │   └── index.ts           # 路由定义
│   ├── views/
│   │   ├── front/             # 公开页面
│   │   │   ├── Home.vue       # 首页 (文章列表)
│   │   │   ├── Post.vue       # 文章详情
│   │   │   ├── Category.vue   # 分类页
│   │   │   ├── Tag.vue        # 标签页
│   │   │   └── About.vue      # 关于页
│   │   └── admin/             # 管理后台
│   │   ├── Login.vue          # 登录页
│   │   ├── Dashboard.vue      # 仪表盘
│   │   ├── PostList.vue       # 文章列表
│   │   ├── PostEdit.vue       # 文章编辑 (md-editor-v3)
│   │   ├── CategoryList.vue   # 分类管理
│   │   ├── TagList.vue        # 标签管理
│   │   ├── CommentList.vue    # 评论管理
│   │   └── SiteConfig.vue     # 站点配置
│   ├── components/
│   │   ├── Layout.vue         # 后台布局 (Element Plus)
│   │   ├── FrontLayout.vue    # 前台布局
│   │   ├── Pagination.vue     # 分页组件
│   │   └── MarkdownRender.vue # Markdown 渲染
│   ├── styles/
│   │   └── main.css           # 全局样式
│   ├── App.vue
│   └── main.ts
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
└── Dockerfile
```

## 页面设计

### 公开页面

#### 首页 (Home)
- 文章卡片列表，显示封面图、标题、摘要、发布时间、分类/标签
- 分页加载
- 侧边栏：分类列表、标签云、最近文章

#### 文章详情 (Post)
- 标题、封面图、发布时间、作者、分类/标签
- Markdown 渲染内容
- 评论区 (提交评论表单 + 评论列表)

#### 分类/标签页
- 按分类或标签筛选的文章列表

### 管理后台

#### 登录页
- 用户名 + 密码表单
- Token 存储至 localStorage

#### 仪表盘
- 文章总数、评论总数、分类总数
- 最近文章列表

#### 文章管理
- 列表：标题、状态、分类、发布时间、操作 (编辑/删除)
- 编辑器：标题、Slug、分类选择、标签选择、封面上传、Markdown 编辑器 (md-editor-v3)、保存/发布

#### 分类/标签管理
- 表格 CRUD

#### 评论管理
- 评论列表：昵称、内容、所属文章、状态
- 操作：通过/拒绝/删除

#### 站点配置
- 站点标题、副标题、Logo、备案号、社交链接等

## 路由设计

```typescript
// 公开路由
/                    → Home.vue
/post/:slug          → Post.vue
/category/:slug      → Category.vue
/tag/:slug           → Tag.vue
/about               → About.vue

// 管理路由 (路由守卫校验 Token)
/admin/login         → Login.vue
/admin               → Dashboard.vue
/admin/posts         → PostList.vue
/admin/posts/edit/:id? → PostEdit.vue
/admin/categories    → CategoryList.vue
/admin/tags          → TagList.vue
/admin/comments      → CommentList.vue
/admin/config        → SiteConfig.vue
```

## 接口封装示例

```typescript
// src/api/request.ts
import axios from 'axios'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000,
})

request.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  (res) => res.data,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/admin/login'
    }
    return Promise.reject(err)
  }
)

export default request
```

## 开发排期

| 阶段 | 内容 | 时间 |
|---|---|---|
| Phase 1 | 项目初始化、路由、布局、Axios 封装 | 0.5 天 |
| Phase 2 | 管理后台：登录页、文章管理 (列表+编辑器) | 1.5 天 |
| Phase 3 | 管理后台：分类/标签/评论管理、站点配置 | 1 天 |
| Phase 4 | 公开页面：首页、文章详情、评论 | 1.5 天 |
| Phase 5 | 样式优化、响应式适配 | 0.5 天 |
| **总计** | | **~5 天** |

## 依赖清单

```json
{
  "dependencies": {
    "vue": "^3.5",
    "vue-router": "^4",
    "pinia": "^2",
    "element-plus": "^2.9",
    "axios": "^1.7",
    "md-editor-v3": "^5"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5",
    "vite": "^6",
    "typescript": "^5"
  }
}
```
