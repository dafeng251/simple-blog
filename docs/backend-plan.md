# 个人博客系统 — 后端技术方案

## 技术栈

| 层 | 选型 | 理由 |
|---|---|---|
| Web 框架 | Gin | 生态最大、文档最全、上手最快 |
| ORM | GORM | 支持 SQLite/MySQL/PostgreSQL，自动迁移 |
| 认证 | golang-jwt/jwt/v5 | 社区标准，轻量 |
| 数据库 | SQLite (可迁移至 MySQL) | 零配置，单文件，适合个人博客 |
| 部署 | Docker + Caddy | Caddy 自动 HTTPS，一行配置 |

## 项目结构

```
blog-server/
├── cmd/
│   └── main.go              # 入口
├── config/
│   └── config.go            # 配置加载
├── handler/
│   ├── auth.go              # 登录认证
│   ├── post.go              # 文章处理
│   ├── category.go          # 分类处理
│   ├── tag.go               # 标签处理
│   ├── comment.go           # 评论处理
│   ├── upload.go            # 文件上传
│   └── config.go            # 站点配置
├── service/
│   ├── auth.go
│   ├── post.go
│   ├── category.go
│   ├── tag.go
│   ├── comment.go
│   └── config.go
├── model/
│   ├── user.go
│   ├── post.go
│   ├── category.go
│   ├── tag.go
│   └── comment.go
├── middleware/
│   ├── jwt.go               # JWT 认证中间件
│   ├── cors.go              # 跨域
│   └── logger.go            # 请求日志
├── router/
│   └── router.go            # 路由定义
├── uploads/                 # 上传文件存储
├── go.mod
├── go.sum
└── Dockerfile
```

## 数据库设计

### users

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| username | VARCHAR(50) UNIQUE | 用户名 |
| password_hash | VARCHAR(255) | 密码哈希 |
| role | VARCHAR(20) | 角色 (admin/user) |
| created_at | DATETIME | 创建时间 |

### categories

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| name | VARCHAR(50) | 分类名 |
| slug | VARCHAR(50) UNIQUE | URL 别名 |
| description | VARCHAR(200) | 描述 |
| created_at | DATETIME | 创建时间 |

### tags

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| name | VARCHAR(50) | 标签名 |
| slug | VARCHAR(50) UNIQUE | URL 别名 |
| created_at | DATETIME | 创建时间 |

### posts

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| title | VARCHAR(200) | 标题 |
| slug | VARCHAR(200) UNIQUE | URL 别名 |
| content | TEXT | Markdown 内容 |
| summary | VARCHAR(500) | 摘要 |
| cover_image | VARCHAR(500) | 封面图 |
| status | VARCHAR(20) | draft/published |
| category_id | INTEGER FK | 分类 ID |
| author_id | INTEGER FK | 作者 ID |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |
| published_at | DATETIME | 发布时间 |

### post_tags

| 字段 | 类型 | 说明 |
|---|---|---|
| post_id | INTEGER FK | 文章 ID |
| tag_id | INTEGER FK | 标签 ID |

### comments

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| post_id | INTEGER FK | 文章 ID |
| parent_id | INTEGER FK | 父评论 ID (支持回复) |
| nickname | VARCHAR(50) | 昵称 |
| email | VARCHAR(100) | 邮箱 |
| content | TEXT | 内容 |
| status | VARCHAR(20) | pending/approved/rejected |
| created_at | DATETIME | 创建时间 |

### site_config

| 字段 | 类型 | 说明 |
|---|---|---|
| id | INTEGER PK | 主键 |
| key | VARCHAR(50) UNIQUE | 配置键 |
| value | TEXT | 配置值 |

## API 接口设计

### 公开接口 (无需认证)

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | /api/posts | 文章列表 (分页、分类、标签筛选) |
| GET | /api/posts/:slug | 文章详情 |
| GET | /api/categories | 分类列表 |
| GET | /api/tags | 标签列表 |
| POST | /api/comments | 提交评论 |

### 管理接口 (JWT 认证)

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | /api/admin/login | 管理员登录 |
| GET | /api/admin/posts | 文章列表 (含草稿) |
| POST | /api/admin/posts | 创建文章 |
| PUT | /api/admin/posts/:id | 更新文章 |
| DELETE | /api/admin/posts/:id | 删除文章 |
| CRUD | /api/admin/categories | 分类管理 |
| CRUD | /api/admin/tags | 标签管理 |
| GET | /api/admin/comments | 评论列表 |
| PUT | /api/admin/comments/:id | 评论审核 |
| GET | /api/admin/config | 获取站点配置 |
| PUT | /api/admin/config | 更新站点配置 |
| POST | /api/admin/upload | 图片上传 |

## 开发排期

| 阶段 | 内容 | 时间 |
|---|---|---|
| Phase 1 | 项目初始化、数据库建表、基础路由 | 0.5 天 |
| Phase 2 | 登录认证 (JWT)、用户模型 | 0.5 天 |
| Phase 3 | 文章 CRUD、分页查询、分类/标签关联 | 1 天 |
| Phase 4 | 评论接口、图片上传、站点配置 | 0.5 天 |
| Phase 5 | Docker 化、Caddy 反代 | 0.5 天 |
| **总计** | | **~3 天** |

## 依赖清单

```go
require (
    github.com/gin-gonic/gin
    gorm.io/gorm
    gorm.io/driver/sqlite          // SQLite 驱动
    github.com/golang-jwt/jwt/v5
    github.com/google/uuid         // 生成唯一文件名
    golang.org/x/crypto            // bcrypt 密码哈希
)
```
