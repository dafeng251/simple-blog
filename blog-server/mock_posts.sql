-- 插入分类（如果不存在）
INSERT IGNORE INTO categories (name, slug, description, created_at, updated_at) VALUES
('前端开发', 'frontend', 'HTML、CSS、JavaScript 及前端框架', NOW(), NOW()),
('后端开发', 'backend', '服务端开发、API 设计与数据库', NOW(), NOW()),
('DevOps', 'devops', '部署、运维、CI/CD 与容器化', NOW(), NOW()),
('随笔', 'essays', '技术感悟与生活随想', NOW(), NOW()),
('工具推荐', 'tools', '开发工具、效率软件推荐', NOW(), NOW());

-- 插入标签（如果不存在）
INSERT IGNORE INTO tags (name, slug, created_at, updated_at) VALUES
('Vue.js', 'vuejs', NOW(), NOW()),
('React', 'react', NOW(), NOW()),
('Go', 'go', NOW(), NOW()),
('TypeScript', 'typescript', NOW(), NOW()),
('Docker', 'docker', NOW(), NOW()),
('MySQL', 'mysql', NOW(), NOW()),
('Redis', 'redis', NOW(), NOW()),
('Git', 'git', NOW(), NOW()),
('CSS', 'css', NOW(), NOW()),
('Node.js', 'nodejs', NOW(), NOW()),
('Linux', 'linux', NOW(), NOW()),
('性能优化', 'performance', NOW(), NOW());

-- 插入50篇文章
INSERT INTO posts (title, slug, content, summary, cover_image, status, category_id, author_id, published_at, created_at, updated_at) VALUES

('Vue 3 组合式 API 完全指南', 'vue3-composition-api-guide',
'# Vue 3 组合式 API 完全指南

## 什么是组合式 API？

组合式 API（Composition API）是 Vue 3 引入的一种全新的组织组件逻辑的方式。它通过一系列函数来组织和复用逻辑，使得代码更加灵活和可维护。

## 核心概念

### ref 和 reactive

`ref` 用于创建基本类型的响应式数据：

```javascript
import { ref } from "vue"
const count = ref(0)
console.log(count.value) // 0
count.value++
```

`reactive` 用于创建对象类型的响应式数据：

```javascript
import { reactive } from "vue"
const state = reactive({ count: 0, name: "Vue" })
```

### computed

计算属性可以基于已有的响应式数据派生出新的值：

```javascript
const doubleCount = computed(() => count.value * 2)
```

### watch 和 watchEffect

`watch` 可以监听特定的数据源，`watchEffect` 会自动追踪依赖：

```javascript
watch(count, (newVal, oldVal) => {
  console.log(`count changed from ${oldVal} to ${newVal}`)
})
```

## 最佳实践

1. 优先使用 `ref` 处理基本类型
2. 复杂对象使用 `reactive`
3. 将相关逻辑封装到组合函数中
4. 使用 TypeScript 获得更好的类型推导',
'深入理解 Vue 3 组合式 API 的核心概念，包括 ref、reactive、computed、watch 等，附带最佳实践和代码示例。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 45 DAY), NOW()),

('Go 语言并发编程实战', 'go-concurrency-in-practice',
'# Go 语言并发编程实战

## Goroutine 基础

Goroutine 是 Go 语言并发的核心，它是一种轻量级的线程，由 Go 运行时管理。

```go
go func() {
    fmt.Println("Hello from goroutine")
}()
```

## Channel 通信

Channel 是 goroutine 之间通信的管道：

```go
ch := make(chan int)
go func() {
    ch <- 42
}()
value := <-ch
```

### 带缓冲的 Channel

```go
ch := make(chan int, 10) // 缓冲大小为10
```

## Select 语句

`select` 让一个 goroutine 等待多个通信操作：

```go
select {
case msg := <-ch1:
    fmt.Println("Received", msg)
case ch2 <- msg:
    fmt.Println("Sent", msg)
case <-time.After(time.Second):
    fmt.Println("Timeout")
}
```

## 实战：并发爬虫

```go
func crawl(urls []string) []string {
    results := make(chan string, len(urls))
    for _, url := range urls {
        go func(u string) {
            resp, _ := http.Get(u)
            defer resp.Body.Close()
            body, _ := io.ReadAll(resp.Body)
            results <- string(body)
        }(url)
    }
    var pages []string
    for range urls {
        pages = append(pages, <-results)
    }
    return pages
}
```

## 注意事项

- 避免 goroutine 泄漏
- 使用 `context` 控制 goroutine 生命周期
- 合理使用 `sync.WaitGroup` 等待 goroutine 完成',
'深入 Go 语言并发编程，涵盖 goroutine、channel、select 语句以及实战案例，助你写出高效的并发程序。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 43 DAY), DATE_SUB(NOW(), INTERVAL 43 DAY), NOW()),

('Docker 容器化部署最佳实践', 'docker-deployment-best-practices',
'# Docker 容器化部署最佳实践

## Dockerfile 编写规范

### 多阶段构建

```dockerfile
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o server ./cmd

FROM alpine:3.18
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/server .
CMD ["./server"]
```

### .dockerignore

```
.git
node_modules
*.md
docker-compose*.yml
```

## Docker Compose 编排

```yaml
version: "3.8"
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_DSN=root:pass@tcp(db:3306)/blog
    depends_on:
      - db
      - redis
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: pass
      MYSQL_DATABASE: blog
    volumes:
      - db_data:/var/lib/mysql
  redis:
    image: redis:7-alpine

volumes:
  db_data:
```

## 生产环境建议

1. 使用非 root 用户运行容器
2. 设置健康检查
3. 合理配置资源限制
4. 使用 secrets 管理敏感信息',
'从 Dockerfile 编写到 Docker Compose 编排，全面介绍容器化部署的最佳实践和生产环境建议。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 40 DAY), NOW()),

('TypeScript 高级类型体操', 'typescript-advanced-types',
'# TypeScript 高级类型体操

## 条件类型

```typescript
type IsString<T> = T extends string ? true : false
type A = IsString<"hello"> // true
type B = IsString<42> // false
```

## 映射类型

```typescript
type Readonly<T> = {
  readonly [K in keyof T]: T[K]
}

type Optional<T> = {
  [K in keyof T]?: T[K]
}
```

## 模板字面量类型

```typescript
type EventName<T extends string> = `on${Capitalize<T>}`
type ClickEvent = EventName<"click"> // "onClick"
```

## infer 关键字

```typescript
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never

type UnwrapPromise<T> = T extends Promise<infer U> ? U : T
type X = UnwrapPromise<Promise<string>> // string
```

## 实用工具类型

```typescript
// 深度只读
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K]
}

// 选取部分属性
type PickByType<T, U> = {
  [K in keyof T as T[K] extends U ? K : never]: T[K]
}
```

这些高级类型技巧能帮你写出更安全、更灵活的类型定义。',
'深入 TypeScript 类型系统，掌握条件类型、映射类型、模板字面量类型和 infer 关键字等高级用法。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 38 DAY), DATE_SUB(NOW(), INTERVAL 38 DAY), NOW()),

('MySQL 索引优化完全攻略', 'mysql-index-optimization',
'# MySQL 索引优化完全攻略

## 索引类型

### B+ 树索引

MySQL 默认的索引类型，适用于等值查询和范围查询。

### 哈希索引

仅支持等值查询，Memory 引擎默认使用。

### 全文索引

适用于文本搜索场景。

## 索引设计原则

1. 最左前缀匹配原则
2. 区分度高的列放前面
3. 避免在索引列上使用函数
4. 覆盖索引减少回表

## EXPLAIN 分析

```sql
EXPLAIN SELECT * FROM posts WHERE category_id = 1 AND status = "published";
```

关注字段：
- `type`: 访问类型，const > eq_ref > ref > range > ALL
- `key`: 实际使用的索引
- `rows`: 预估扫描行数
- `Extra`: Using index（覆盖索引）、Using filesort（需要排序优化）

## 常见优化场景

### 慢查询优化

```sql
-- 优化前：全表扫描
SELECT * FROM posts WHERE YEAR(published_at) = 2024

-- 优化后：使用范围查询
SELECT * FROM posts WHERE published_at >= "2024-01-01" AND published_at < "2025-01-01"
```

### 联合索引

```sql
CREATE INDEX idx_category_status ON posts(category_id, status);
```

这样 `WHERE category_id = ? AND status = ?` 可以高效命中索引。',
'详解 MySQL 索引原理与优化策略，包括 EXPLAIN 分析、索引设计原则和常见慢查询优化技巧。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 35 DAY), NOW()),

('CSS Grid 布局完全入门', 'css-grid-layout-guide',
'# CSS Grid 布局完全入门

## 基础概念

CSS Grid 是一种二维布局系统，可以同时控制行和列。

```css
.container {
  display: grid;
  grid-template-columns: 1fr 2fr 1fr;
  grid-template-rows: auto;
  gap: 20px;
}
```

## 常用属性

### 定义网格

```css
/* 固定列宽 */
grid-template-columns: 200px 200px 200px;

/* 等分 */
grid-template-columns: repeat(3, 1fr);

/* 响应式 */
grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
```

### 网格项定位

```css
.item {
  grid-column: 1 / 3; /* 跨越第1到第3列 */
  grid-row: 1 / 2;
}
```

## 实战：圣杯布局

```css
.layout {
  display: grid;
  grid-template-areas:
    "header header header"
    "sidebar main aside"
    "footer footer footer";
  grid-template-columns: 200px 1fr 200px;
  min-height: 100vh;
}
.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.aside { grid-area: aside; }
.footer { grid-area: footer; }
```

## Grid vs Flexbox

- Grid：二维布局，适合整体页面结构
- Flexbox：一维布局，适合组件内部排列',
'从零开始学习 CSS Grid 布局，掌握网格定义、区域命名、响应式布局等核心技巧。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 32 DAY), DATE_SUB(NOW(), INTERVAL 32 DAY), NOW()),

('Redis 缓存策略与实战', 'redis-caching-strategies',
'# Redis 缓存策略与实战

## 缓存策略

### Cache Aside（旁路缓存）

最常用的策略，应用层负责维护缓存：

```go
func GetPost(id int) (*Post, error) {
    // 1. 查缓存
    cached, err := redis.Get(fmt.Sprintf("post:%d", id))
    if err == nil {
        return json.Unmarshal(cached), nil
    }
    // 2. 查数据库
    post, err := db.FindByID(id)
    if err != nil {
        return nil, err
    }
    // 3. 写缓存
    data, _ := json.Marshal(post)
    redis.Set(fmt.Sprintf("post:%d", id), data, time.Hour)
    return post, nil
}
```

### Write Through

写操作同时更新缓存和数据库。

### Write Behind

先写缓存，异步写入数据库。

## 缓存问题

### 缓存穿透

查询不存在的数据，每次都打到数据库。

解决方案：布隆过滤器、缓存空值。

### 缓存击穿

热点数据过期瞬间大量请求。

解决方案：互斥锁、永不过期 + 异步更新。

### 缓存雪崩

大量缓存同时过期。

解决方案：随机过期时间、多级缓存。

## 实战：文章详情缓存

```go
const cacheKey = "post:slug:%s"
const cacheTTL = 30 * time.Minute

func GetPostBySlug(slug string) (*Post, error) {
    key := fmt.Sprintf(cacheKey, slug)
    if data, err := rdb.Get(ctx, key).Bytes(); err == nil {
        var post Post
        json.Unmarshal(data, &post)
        return &post, nil
    }
    post, err := repo.FindBySlug(slug)
    if err != nil {
        return nil, err
    }
    data, _ := json.Marshal(post)
    rdb.Set(ctx, key, data, cacheTTL)
    return post, nil
}
``',
'详解 Redis 缓存策略，包括 Cache Aside、缓存穿透/击穿/雪崩的解决方案，附带实战代码。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 30 DAY), NOW()),

('Git 工作流与团队协作规范', 'git-workflow-team-collaboration',
'# Git 工作流与团队协作规范

## 分支策略

### 主要分支

- `main`: 生产分支，始终保持可部署状态
- `dev`: 开发分支，功能集成
- `feature/*`: 功能分支
- `hotfix/*`: 紧急修复分支

### 分支命名规范

```
feature/user-authentication
fix/login-redirect-bug
hotfix/security-patch
```

## Commit 规范

### Conventional Commits

```
<type>(<scope>): <subject>

<body>

<footer>
```

Type 类型：
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

### 示例

```
feat(auth): add JWT refresh token support

Implement refresh token rotation for improved security.
Tokens are now stored in httpOnly cookies.

Closes #123
```

## Code Review 流程

1. 创建 PR，填写清晰的描述
2. 至少 1 人 approve
3. CI 通过后合并
4. 合并后删除功能分支

## 常用 Git 技巧

```bash
# 交互式 rebase 整理 commit
git rebase -i HEAD~3

# 暂存部分修改
git add -p

# 撤销最近一次 commit（保留修改）
git reset --soft HEAD~1
``',
'建立规范的 Git 工作流程，涵盖分支策略、Commit 规范和 Code Review 流程，提升团队协作效率。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 28 DAY), DATE_SUB(NOW(), INTERVAL 28 DAY), NOW()),

('React Server Components 深度解析', 'react-server-components-deep-dive',
'# React Server Components 深度解析

## 什么是 RSC？

React Server Components 是 React 18+ 引入的新范式，允许组件在服务端渲染且不发送 JavaScript 到客户端。

## Server vs Client Components

### Server Components（默认）

- 在服务端执行
- 可以直接访问数据库、文件系统
- 不包含交互逻辑
- 零 JS 体积

```tsx
async function PostList() {
  const posts = await db.posts.findMany()
  return (
    <ul>
      {posts.map(post => <li key={post.id}>{post.title}</li>)}
    </ul>
  )
}
```

### Client Components

- 使用 `"use client"` 指令
- 可以使用 useState、useEffect 等 Hooks
- 支持事件处理

```tsx
"use client"
function LikeButton() {
  const [liked, setLiked] = useState(false)
  return <button onClick={() => setLiked(!liked)}>Like</button>
}
```

## 数据获取模式

RSC 鼓励在组件内直接获取数据，无需 useEffect：

```tsx
async function UserProfile({ userId }) {
  const user = await fetchUser(userId)
  return <div>{user.name}</div>
}
```

## 性能优势

1. 减少客户端 JS 体积
2. 直接访问后端资源
3. 自动流式传输
4. 选择性 hydration',
'深入理解 React Server Components 的工作原理、使用场景和性能优势，掌握现代 React 开发范式。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), DATE_SUB(NOW(), INTERVAL 25 DAY), NOW()),

('Linux 服务器性能调优指南', 'linux-server-performance-tuning',
'# Linux 服务器性能调优指南

## 系统监控

### 常用工具

```bash
# CPU 使用率
top -c
htop

# 内存使用
free -h
vmstat 1

# 磁盘 IO
iostat -x 1

# 网络
ss -tunlp
netstat -an
```

## 内核参数调优

### 文件描述符

```bash
# 查看限制
ulimit -n

# 临时修改
ulimit -n 65535

# 永久修改 /etc/security/limits.conf
* soft nofile 65535
* hard nofile 65535
```

### TCP 优化

```bash
# /etc/sysctl.conf
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 600
```

## 内存优化

```bash
# 调整 swappiness
vm.swappiness = 10

# 调整脏页比例
vm.dirty_ratio = 40
vm.dirty_background_ratio = 10
```

## 磁盘优化

- 使用 SSD
- 选择合适的文件系统（ext4/xfs）
- 调整 IO 调度器

```bash
# 查看当前调度器
cat /sys/block/sda/queue/scheduler

# 设置为 deadline
echo deadline > /sys/block/sda/queue/scheduler
```',
'全面的 Linux 服务器性能调优指南，涵盖系统监控、内核参数、内存和磁盘优化。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 22 DAY), DATE_SUB(NOW(), INTERVAL 22 DAY), NOW()),

('使用 VueUse 提升开发效率', 'vueuse-productivity-tips',
'# 使用 VueUse 提升开发效率

## 什么是 VueUse？

VueUse 是一个基于 Composition API 的实用函数合集，提供了大量常用的组合式函数。

## 常用函数

### useLocalStorage

```typescript
import { useLocalStorage } from "@vueuse/core"

const token = useLocalStorage("token", "")
// 自动同步到 localStorage
```

### useDebounceFn

```typescript
import { useDebounceFn } from "@vueuse/core"

const search = ref("")
const debouncedSearch = useDebounceFn(() => {
  fetchResults(search.value)
}, 300)
```

### useIntersectionObserver

```typescript
import { useIntersectionObserver } from "@vueuse/core"

const target = ref(null)
const isVisible = ref(false)

useIntersectionObserver(target, ([{ isIntersecting }]) => {
  isVisible.value = isIntersecting
})
```

### useDark

```typescript
import { useDark, useToggle } from "@vueuse/core"

const isDark = useDark()
const toggleDark = useToggle(isDark)
```

## 实用场景

### 网络状态监听

```typescript
import { useNetwork } from "@vueuse/core"

const { isOnline, offlineAt } = useNetwork()
```

### 页面可见性

```typescript
import { useDocumentVisibility } from "@vueuse/core"

const visibility = useDocumentVisibility()
// "visible" | "hidden"
```

VueUse 让你专注于业务逻辑，不再重复造轮子。',
'介绍 VueUse 中最实用的组合式函数，包括本地存储、防抖、懒加载、暗黑模式等功能。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), DATE_SUB(NOW(), INTERVAL 20 DAY), NOW()),

('Go 项目目录结构设计', 'go-project-structure-design',
'# Go 项目目录结构设计

## 推荐的项目结构

```
project/
├── cmd/
│   └── main.go           # 入口文件
├── config/
│   └── config.go         # 配置加载
├── handler/              # HTTP 处理器
│   ├── auth.go
│   ├── post.go
│   └── response.go
├── service/              # 业务逻辑
│   ├── auth.go
│   └── post.go
├── model/                # 数据模型
│   ├── post.go
│   └── user.go
├── middleware/           # 中间件
│   ├── jwt.go
│   └── cors.go
├── router/               # 路由定义
│   └── router.go
├── go.mod
└── go.sum
```

## 分层原则

### Handler 层

- 解析请求参数
- 参数验证
- 调用 Service 层
- 返回响应

### Service 层

- 业务逻辑处理
- 数据库操作
- 缓存管理

### Model 层

- 数据结构定义
- GORM 模型
- 数据库关联

## 依赖注入

```go
// cmd/main.go
func main() {
    db := initDB()
    redis := initRedis()

    postRepo := repository.NewPostRepository(db)
    postSvc := service.NewPostService(postRepo, redis)
    postHandler := handler.NewPostHandler(postSvc)

    r := router.Setup(postHandler)
    r.Run(":8080")
}
```

## 错误处理

```go
// 定义业务错误
var (
    ErrPostNotFound = errors.New("post not found")
    ErrUnauthorized = errors.New("unauthorized")
)

// Handler 中处理
if errors.Is(err, ErrPostNotFound) {
    NotFound(c, "文章不存在")
    return
}
```

清晰的目录结构是项目可维护性的基础。',
'探讨 Go 项目的目录结构设计，涵盖分层架构、依赖注入和错误处理的最佳实践。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 18 DAY), DATE_SUB(NOW(), INTERVAL 18 DAY), NOW()),

('前端性能优化清单', 'frontend-performance-checklist',
'# 前端性能优化清单

## 加载优化

### 资源压缩

- 开启 Gzip/Brotli 压缩
- CSS/JS 压缩混淆
- 图片压缩（WebP 格式）

### 代码分割

```javascript
// 路由懒加载
const Home = () => import("./views/Home.vue")
const Post = () => import("./views/Post.vue")
```

### 预加载

```html
<link rel="preload" href="/fonts/main.woff2" as="font" crossorigin>
<link rel="prefetch" href="/api/posts?page=2">
```

## 渲染优化

### 虚拟列表

长列表使用虚拟滚动，只渲染可见区域。

### 防抖与节流

```javascript
const debouncedSearch = useDebounceFn(search, 300)
const throttledScroll = useThrottleFn(onScroll, 100)
```

### 避免重排

- 使用 `transform` 代替 `top/left`
- 批量修改 DOM
- 使用 `will-change` 提示浏览器

## 网络优化

### CDN

静态资源部署到 CDN，减少网络延迟。

### HTTP/2

开启 HTTP/2，支持多路复用。

### 缓存策略

```nginx
location ~* \.(js|css|png|jpg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## 监控指标

- **FCP**（首次内容绘制）< 1.8s
- **LCP**（最大内容绘制）< 2.5s
- **CLS**（累积布局偏移）< 0.1
- **FID**（首次输入延迟）< 100ms',
'全面的前端性能优化清单，涵盖加载、渲染、网络等各个方面的优化策略和具体实践。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), DATE_SUB(NOW(), INTERVAL 15 DAY), NOW()),

('写给程序员的写作指南', 'writing-guide-for-developers',
'# 写给程序员的写作指南

## 为什么要写作？

1. **加深理解**：教是最好的学
2. **建立个人品牌**：技术影响力
3. **帮助他人**：分享经验
4. **记录成长**：回顾自己的进步

## 写什么？

### 技术教程

- 某个技术的入门指南
- 解决特定问题的方案
- 源码分析

### 经验总结

- 项目复盘
- 踩坑记录
- 工具推荐

### 思考感悟

- 技术趋势
- 职业发展
- 学习方法

## 怎么写？

### 结构清晰

使用标题层级组织内容，每个段落聚焦一个观点。

### 代码示例

代码是最好的说明。确保示例可运行，附带注释。

### 循序渐进

从简单到复杂，照顾不同水平的读者。

## 写作平台

- 个人博客（完全掌控）
- 掘金（社区活跃）
- GitHub Pages（免费托管）
- Medium（国际化）

## 坚持写作

> 种一棵树最好的时间是十年前，其次是现在。

每天写一点，哪怕只是 100 字。养成习惯比追求完美更重要。',
'从写作的意义到具体方法，帮助程序员建立写作习惯，提升技术影响力。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 12 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY), NOW()),

('Caddy 服务器入门与配置', 'caddy-server-getting-started',
'# Caddy 服务器入门与配置

## 什么是 Caddy？

Caddy 是一个现代的 Web 服务器，特点是自动 HTTPS、配置简单。

## 安装

```bash
# macOS
brew install caddy

# Linux
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf "https://dl.cloudsmith.io/public/caddy/stable/gpg.key" | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
sudo apt update
sudo apt install caddy
```

## 基本配置

### 静态文件服务

```
example.com {
    root * /var/www/html
    file_server
}
```

### 反向代理

```
example.com {
    reverse_proxy localhost:8080
}
```

### 自动 HTTPS

Caddy 自动获取和续期 Let''s Encrypt 证书，无需手动配置。

## 博客部署配置

```
blog.example.com {
    root * /var/www/blog/dist
    file_server

    handle /api/* {
        reverse_proxy localhost:8080
    }

    handle_errors {
        rewrite * /index.html
        file_server
    }

    encode gzip zstd
    header /assets/* Cache-Control "public, max-age=31536000"
}
```

## 优势

1. 零配置 HTTPS
2. 配置语法简洁
3. 支持动态配置 API
4. 性能优秀',
'快速上手 Caddy Web 服务器，从安装到配置自动 HTTPS 和反向代理，轻松部署 Web 应用。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), NOW()),

('我的 2024 年度技术总结', 'my-2024-tech-review',
'# 我的 2024 年度技术总结

## 技术栈变化

今年主要从 Node.js 全栈转向了 Go + Vue 3 的技术栈。

### 后端：Go + Gin

Golang 的简洁和高性能给我留下了深刻印象。特别是：
- 编译速度快
- 并发模型优雅（goroutine + channel）
- 标准库丰富
- 部署简单（单二进制文件）

### 前端：Vue 3 + TypeScript

Vue 3 的组合式 API 让代码组织更加灵活：
- 逻辑复用更方便
- TypeScript 支持更好
- 性能提升明显

## 完成的项目

1. **个人博客系统** — Go + Vue 3 + MySQL
2. **内部工具平台** — 管理后台 + API 服务
3. **命令行工具** — 用 Go 写了几个实用 CLI

## 踩过的坑

- GORM 的关联查询需要注意 Preload
- Vue 3 的 ref 在模板中自动解包，但在 script 中需要 .value
- Docker 镜像优化可以大幅减少体积

## 明年计划

- 深入学习分布式系统
- 尝试 Rust
- 写更多技术博客
- 参与开源项目

保持学习，保持好奇心。',
'回顾 2024 年的技术成长历程，包括技术栈转型、项目经验和未来规划。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY), NOW()),

('Vite 插件开发入门', 'vite-plugin-development',
'# Vite 插件开发入门

## Vite 插件基础

Vite 插件基于 Rollup 插件接口，扩展了 Vite 特有的功能。

## 最小插件示例

```typescript
import { Plugin } from "vite"

export function myPlugin(): Plugin {
  return {
    name: "vite-plugin-my",
    transform(code, id) {
      console.log(`Transforming: ${id}`)
      return code
    },
  }
}
```

## 常用钩子

| 钩子 | 说明 |
|------|------|
| `configResolved` | 解析配置后 |
| `transformIndexHtml` | 转换 HTML |
| `transform` | 转换模块代码 |
| `configureServer` | 配置开发服务器 |
| `buildEnd` | 构建结束 |

## 实战：自动导入插件

```typescript
export function autoImport(): Plugin {
  return {
    name: "auto-import",
    transform(code, id) {
      if (!id.endsWith(".vue")) return code

      // 检测未导入的组件使用
      const used = code.match(/<([A-Z]\w+)\s/g) || []
      const imports = used
        .map(m => `import ${m.slice(1, -1)} from "./${m.slice(1, -1)}.vue"`)
        .join("\n")

      return imports + "\n" + code
    },
  }
}
```

## 调试技巧

```typescript
export function debugPlugin(): Plugin {
  return {
    name: "debug",
    enforce: "pre",
    transform(code, id) {
      if (process.env.DEBUG) {
        this.info(`Processing: ${id}`)
      }
      return code
    },
  }
}
```

Vite 插件开发并不复杂，关键是理解各个钩子的执行时机。',
'从零开始学习 Vite 插件开发，掌握插件钩子、常用 API 和调试技巧。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), NOW()),

('GORM 关联关系详解', 'gorm-associations-guide',
'# GORM 关联关系详解

## 一对一

```go
type User struct {
    gorm.Model
    Name   string
    Profile Profile
}

type Profile struct {
    gorm.Model
    UserID uint
    Bio    string
}

// 查询时预加载
var user User
db.Preload("Profile").First(&user, 1)
```

## 一对多

```go
type Category struct {
    gorm.Model
    Name  string
    Posts []Post
}

type Post struct {
    gorm.Model
    Title      string
    CategoryID uint
}

// 查询分类及其文章
var category Category
db.Preload("Posts").First(&category, 1)
```

## 多对多

```go
type Post struct {
    gorm.Model
    Title string
    Tags  []Tag `gorm:"many2many:post_tags;"`
}

type Tag struct {
    gorm.Model
    Name string
}

// 添加关联
db.Model(&post).Association("Tags").Append(&tag1, &tag2)

// 替换关联
db.Model(&post).Association("Tags").Replace([]Tag{tag1, tag2})

// 清除关联
db.Model(&post).Association("Tags").Clear()
```

## 自定义外键

```go
type User struct {
    gorm.Model
    CreditCard CreditCard `gorm:"foreignKey:UserName;references:name"`
}
```

## 注意事项

1. 预加载避免 N+1 查询
2. 使用 `gorm:"-"` 排除不需要的关联
3. 注意软删除对关联查询的影响',
'详解 GORM 的一对一、一对多和多对多关联关系，包含预加载、自定义外键等高级用法。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), NOW()),

('Tailwind CSS 实用技巧', 'tailwind-css-practical-tips',
'# Tailwind CSS 实用技巧

## 响应式设计

```html
<div class="w-full md:w-1/2 lg:w-1/3">
  响应式宽度
</div>
```

断点前缀：
- `sm:` 640px+
- `md:` 768px+
- `lg:` 1024px+
- `xl:` 1280px+

## 暗黑模式

```html
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
  自动适配暗黑模式
</div>
```

## 自定义主题

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: "#409eff",
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
      },
    },
  },
}
```

## 常用组合

### 居中

```html
<div class="flex items-center justify-center">
```

### 文本截断

```html
<p class="line-clamp-3">超出三行显示省略号...</p>
```

### 渐变背景

```html
<div class="bg-gradient-to-r from-blue-500 to-purple-600">
```

## 生产优化

```javascript
// purge 未使用的样式
module.exports = {
  content: ["./src/**/*.{vue,js,ts}"],
}
```

Tailwind 让你不用写 CSS 也能快速构建漂亮的界面。',
'分享 Tailwind CSS 的实用技巧，包括响应式设计、暗黑模式、自定义主题和生产优化。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()),

('如何设计一个好的 API', 'how-to-design-good-api',
'# 如何设计一个好的 API

## RESTful 原则

### URL 设计

```
GET    /api/posts          # 获取文章列表
GET    /api/posts/:id      # 获取单篇文章
POST   /api/posts          # 创建文章
PUT    /api/posts/:id      # 更新文章
DELETE /api/posts/:id      # 删除文章
```

### 命名规范

- 使用名词复数
- 使用小写 + 连字符
- 避免动词

```
❌ /api/getPosts
❌ /api/post/create
✅ /api/posts
```

## 统一响应格式

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

错误响应：
```json
{
  "code": 400,
  "message": "参数错误"
}
```

## 分页设计

```json
{
  "code": 0,
  "data": [...],
  "total": 100,
  "page": 1,
  "page_size": 10
}
```

## 版本控制

```
/api/v1/posts
/api/v2/posts
```

## 安全考虑

1. 使用 HTTPS
2. JWT 认证
3. 请求频率限制
4. 参数验证
5. SQL 注入防护
6. CORS 配置

## 文档

使用 Swagger/OpenAPI 自动生成 API 文档，保持文档与代码同步。',
'从 URL 设计到响应格式，全面讲解 RESTful API 的设计原则和最佳实践。',
'', 'published', 2, 1, NOW(), NOW(), NOW()),

('Nginx 反向代理配置详解', 'nginx-reverse-proxy-config',
'# Nginx 反向代理配置详解

## 基础配置

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## WebSocket 代理

```nginx
location /ws {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

## 负载均衡

```nginx
upstream backend {
    least_conn;
    server backend1.example.com:8080;
    server backend2.example.com:8080;
    server backend3.example.com:8080 backup;
}

server {
    location / {
        proxy_pass http://backend;
    }
}
```

## SSL 配置

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;

    # HTTP 重定向到 HTTPS
}
server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}
```

## 性能优化

```nginx
# 开启 gzip
gzip on;
gzip_types text/plain text/css application/json application/javascript;

# 静态资源缓存
location ~* \.(css|js|png|jpg)$ {
    expires 1y;
}
```',
'全面的 Nginx 反向代理配置指南，涵盖基础代理、WebSocket、负载均衡和 SSL 配置。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 9 DAY), DATE_SUB(NOW(), INTERVAL 9 DAY), NOW()),

('正则表达式速查手册', 'regex-cheatsheet',
'# 正则表达式速查手册

## 基础语法

| 符号 | 说明 |
|------|------|
| `.` | 任意字符 |
| `*` | 0 次或多次 |
| `+` | 1 次或多次 |
| `?` | 0 次或 1 次 |
| `^` | 行首 |
| `$` | 行尾 |
| `\d` | 数字 |
| `\w` | 单词字符 |
| `\s` | 空白字符 |

## 常用模式

### 邮箱

```
/^[\w.-]+@[\w.-]+\.\w{2,}$/
```

### 手机号（中国）

```
/^1[3-9]\d{9}$/
```

### URL

```
/^https?:\/\/[\w\-.]+(:\d+)?(\/[\w\-./?%&=]*)?$/
```

### IP 地址

```
/^(\d{1,3}\.){3}\d{1,3}$/
```

## 分组与捕获

```javascript
const regex = /(\d{4})-(\d{2})-(\d{2})/
const match = "2024-01-15".match(regex)
// match[1] = "2024", match[2] = "01", match[3] = "15"
```

## 非捕获组

```
/(?:abc)+/  // 不捕获，只分组
```

## 前瞻与后顾

```
(?=...)  正向前瞻
(?!...)  负向前瞻
(?<=...) 正向后顾
(?<!...) 负向后顾
```

## 实用技巧

```javascript
// 去除首尾空格
str.replace(/^\s+|\s+$/g, "")

// 全局替换
str.replace(/foo/g, "bar")

// 惰性匹配
/<.*?>/  // 匹配最短的 HTML 标签
```

正则表达式是每个程序员都应该掌握的技能。',
'正则表达式速查手册，涵盖基础语法、常用模式和实用技巧，随时查阅。',
'', 'published', 5, 1, DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY), NOW()),

('从零搭建 Monorepo 项目', 'monorepo-from-scratch',
'# 从零搭建 Monorepo 项目

## 什么是 Monorepo？

将多个项目放在一个仓库中管理的方式，适用于共享代码多、需要统一版本管理的场景。

## 工具选择

### pnpm workspace

```json
// pnpm-workspace.yaml
packages:
  - "packages/*"
  - "apps/*"
```

### Turborepo

```json
// turbo.json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "dev": {
      "cache": false
    }
  }
}
```

## 项目结构

```
monorepo/
├── apps/
│   ├── web/          # 前端应用
│   └── admin/        # 管理后台
├── packages/
│   ├── ui/           # 共享 UI 组件
│   ├── utils/        # 工具函数
│   └── api-client/   # API 客户端
├── turbo.json
└── pnpm-workspace.yaml
```

## 共享包配置

```json
// packages/ui/package.json
{
  "name": "@blog/ui",
  "version": "0.0.0",
  "exports": {
    ".": "./src/index.ts"
  }
}
```

## 使用共享包

```json
// apps/web/package.json
{
  "dependencies": {
    "@blog/ui": "workspace:*"
  }
}
```

## 优势

1. 代码共享方便
2. 统一依赖管理
3. 原子化提交
4. 统一 CI/CD',
'使用 pnpm workspace + Turborepo 从零搭建 Monorepo 项目，实现多项目统一管理。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()),

('WebSocket 实时通信实战', 'websocket-realtime-communication',
'# WebSocket 实时通信实战

## WebSocket 基础

WebSocket 提供全双工通信，适用于实时应用。

## 服务端（Go）

```go
import "github.com/gorilla/websocket"

var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool { return true },
}

func handleWS(w http.ResponseWriter, r *http.Request) {
    conn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        return
    }
    defer conn.Close()

    for {
        msgType, msg, err := conn.ReadMessage()
        if err != nil {
            break
        }
        conn.WriteMessage(msgType, msg)
    }
}
```

## 客户端（JavaScript）

```javascript
const ws = new WebSocket("ws://localhost:8080/ws")

ws.onopen = () => {
  console.log("Connected")
  ws.send("Hello Server")
}

ws.onmessage = (event) => {
  console.log("Received:", event.data)
}

ws.onclose = () => {
  console.log("Disconnected")
}
```

## 心跳检测

```go
func heartbeat(conn *websocket.Conn) {
    ticker := time.NewTicker(30 * time.Second)
    defer ticker.Stop()
    for range ticker.C {
        if err := conn.WriteMessage(websocket.PingMessage, nil); err != nil {
            return
        }
    }
}
```

## 房间广播

```go
type Hub struct {
    rooms map[string]map[*websocket.Conn]bool
    mu    sync.RWMutex
}

func (h *Hub) Broadcast(room string, msg []byte) {
    h.mu.RLock()
    defer h.mu.RUnlock()
    for conn := range h.rooms[room] {
        conn.WriteMessage(websocket.TextMessage, msg)
    }
}
```

WebSocket 是构建实时应用的基础。',
'从零实现 WebSocket 实时通信，涵盖服务端、客户端、心跳检测和房间广播。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY), NOW()),

('前端状态管理方案对比', 'frontend-state-management-comparison',
'# 前端状态管理方案对比

## 方案概览

| 方案 | 框架 | 复杂度 | 适用场景 |
|------|------|--------|----------|
| Pinia | Vue | 低 | Vue 3 项目 |
| Zustand | React | 低 | 轻量状态管理 |
| Redux Toolkit | React | 中 | 大型应用 |
| Jotai | React | 低 | 原子化状态 |

## Pinia（推荐 Vue 项目）

```typescript
import { defineStore } from "pinia"

export const usePostStore = defineStore("post", () => {
  const posts = ref([])
  const loading = ref(false)

  async function fetchPosts() {
    loading.value = true
    posts.value = await api.getPosts()
    loading.value = false
  }

  return { posts, loading, fetchPosts }
})
```

## Zustand（推荐 React 项目）

```typescript
import { create } from "zustand"

const usePostStore = create((set) => ({
  posts: [],
  loading: false,
  fetchPosts: async () => {
    set({ loading: true })
    const posts = await api.getPosts()
    set({ posts, loading: false })
  },
}))
```

## 选择建议

1. **小型项目**: useState + useContext 足够
2. **中型项目**: Pinia / Zustand
3. **大型复杂项目**: Redux Toolkit

## 服务端状态

对于服务端数据，考虑使用：
- TanStack Query（React）
- Vue Query（Vue）

它们处理缓存、重新获取、乐观更新等，比传统状态管理更合适。',
'对比前端主流状态管理方案，帮助你根据项目需求选择最合适的工具。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY), NOW()),

('PostgreSQL vs MySQL 选型指南', 'postgresql-vs-mysql-guide',
'# PostgreSQL vs MySQL 选型指南

## 基本对比

| 特性 | PostgreSQL | MySQL |
|------|------------|-------|
| JSON 支持 | 原生 JSONB | JSON 类型 |
| 全文搜索 | 内置 | 内置 |
| 地理数据 | PostGIS | 有限 |
| 并发控制 | MVCC | MVCC |
| 复制 | 流复制 | 主从复制 |

## PostgreSQL 优势

### JSONB 操作

```sql
-- 存储和查询 JSON
SELECT * FROM posts WHERE metadata @> "tags": ["go"]'

-- 创建索引
CREATE INDEX idx_meta ON posts USING GIN (metadata);
```

### 窗口函数

```sql
SELECT title, category_id,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY created_at DESC)
FROM posts;
```

### 扩展生态

- PostGIS（地理数据）
- pg_trgm（模糊搜索）
- TimescaleDB（时序数据）

## MySQL 优势

1. 部署简单
2. 读取性能优秀
3. 复制方案成熟
4. 运维工具丰富

## 选型建议

- **选 PostgreSQL**: 复杂查询、JSON 操作、地理数据、数据完整性要求高
- **选 MySQL**: 高并发读取、简单 CRUD、已有 MySQL 运维经验

## 博客项目选择

对于个人博客这类应用，两者都可以胜任。MySQL 足够简单高效，PostgreSQL 功能更丰富。',
'对比 PostgreSQL 和 MySQL 的特性差异，帮助你根据项目需求做出正确的数据库选型。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 11 DAY), DATE_SUB(NOW(), INTERVAL 11 DAY), NOW()),

('Docker Compose 开发环境搭建', 'docker-compose-dev-environment',
'# Docker Compose 开发环境搭建

## 为什么要容器化开发环境？

1. 环境一致性
2. 快速搭建和销毁
3. 不污染宿主机
4. 团队共享配置

## 完整配置

```yaml
version: "3.8"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8080:8080"
    volumes:
      - .:/app
      - go-modules:/go/pkg/mod
    environment:
      - DB_DSN=root:password@tcp(db:3306)/blog
      - REDIS_ADDR=redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started

  db:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: blog
    volumes:
      - db-data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  db-data:
  go-modules:
```

## 常用命令

```bash
# 启动
docker compose up -d

# 查看日志
docker compose logs -f app

# 进入容器
docker compose exec app sh

# 重建服务
docker compose up -d --build

# 清理
docker compose down -v
```

## 开发 Dockerfile

```dockerfile
FROM golang:1.21-alpine
RUN go install github.com/cosmtrek/air@latest
WORKDIR /app
CMD ["air"]
```

一键 `docker compose up` 启动完整的开发环境。',
'使用 Docker Compose 快速搭建包含 Go、MySQL、Redis 的完整开发环境。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 13 DAY), DATE_SUB(NOW(), INTERVAL 13 DAY), NOW()),

('如何写好技术文档', 'how-to-write-technical-docs',
'# 如何写好技术文档

## 文档类型

### API 文档

使用 Swagger/OpenAPI 自动生成，保持代码即文档。

### 架构文档

说明系统架构、模块职责和数据流。

### 操作手册

面向运维人员，提供部署和维护指南。

### README

项目的门面，包含：
- 项目简介
- 快速开始
- 依赖说明
- 贡献指南

## 写作原则

### 1. 面向读者

了解读者是谁，使用他们能理解的语言。

### 2. 结构清晰

```markdown
# 标题

## 概述

## 前置条件

## 步骤

### 步骤 1
...
### 步骤 2
...

## 常见问题

## 参考资料
```

### 3. 代码示例

每个概念都配合代码示例，确保示例可运行。

### 4. 及时更新

代码变更时同步更新文档。

## 工具推荐

- **Markdown**: 通用格式
- **VuePress**: 文档网站
- **Swagger**: API 文档
- **Mermaid**: 流程图

## 检查清单

- [ ] 是否有明确的受众
- [ ] 结构是否清晰
- [ ] 代码示例是否可运行
- [ ] 是否包含常见问题
- [ ] 是否与代码同步

好的文档能让项目更容易被接受和使用。',
'系统讲解如何撰写高质量的技术文档，涵盖文档类型、写作原则和工具选择。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 14 DAY), DATE_SUB(NOW(), INTERVAL 14 DAY), NOW()),

('JavaScript 异步编程完全指南', 'javascript-async-programming',
'# JavaScript 异步编程完全指南

## 回调函数

```javascript
setTimeout(() => {
  console.log("1 second later")
}, 1000)
```

回调地狱问题：
```javascript
getUser(id, (user) => {
  getPosts(user.id, (posts) => {
    getComments(posts[0].id, (comments) => {
      // 嵌套越来越深
    })
  })
})
```

## Promise

```javascript
function getUser(id) {
  return new Promise((resolve, reject) => {
    db.findUser(id, (err, user) => {
      if (err) reject(err)
      else resolve(user)
    })
  })
}

getUser(1)
  .then(user => getPosts(user.id))
  .then(posts => getComments(posts[0].id))
  .catch(err => console.error(err))
```

## async/await

```javascript
async function loadPost(id) {
  try {
    const user = await getUser(id)
    const posts = await getPosts(user.id)
    const comments = await getComments(posts[0].id)
    return { user, posts, comments }
  } catch (err) {
    console.error(err)
  }
}
```

## 并行执行

```javascript
// 串行
const a = await fetchA()
const b = await fetchB()

// 并行
const [a, b] = await Promise.all([fetchA(), fetchB()])

// 竞速
const fastest = await Promise.race([fetchA(), fetchB()])
```

## 错误处理

```javascript
async function safeFetch(url) {
  try {
    const res = await fetch(url)
    if (!res.ok) throw new Error(res.statusText)
    return await res.json()
  } catch (err) {
    console.error("Fetch failed:", err)
    return null
  }
}
```

掌握异步编程是 JavaScript 开发的基础。',
'从回调到 async/await，全面讲解 JavaScript 异步编程的演进和最佳实践。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 16 DAY), DATE_SUB(NOW(), INTERVAL 16 DAY), NOW()),

('Go 单元测试入门与实践', 'go-unit-testing-guide',
'# Go 单元测试入门与实践

## 基础测试

```go
// math_test.go
package math

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Add(2, 3) = %d; want 5", result)
    }
}
```

## 表驱动测试

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

## 使用 testify

```go
import "github.com/stretchr/testify/assert"

func TestAdd(t *testing.T) {
    assert.Equal(t, 5, Add(2, 3))
    assert.NotEqual(t, 0, Add(1, 1))
}
```

## Mock

```go
type MockUserRepo struct {
    mock.Mock
}

func (m *MockUserRepo) FindByID(id uint) (*User, error) {
    args := m.Called(id)
    return args.Get(0).(*User), args.Error(1)
}

func TestGetUser(t *testing.T) {
    repo := new(MockUserRepo)
    repo.On("FindByID", uint(1)).Return(&User{Name: "test"}, nil)

    svc := NewUserService(repo)
    user, err := svc.GetUser(1)

    assert.NoError(t, err)
    assert.Equal(t, "test", user.Name)
    repo.AssertExpectations(t)
}
```

## 运行测试

```bash
go test ./...
go test -v -cover ./...
go test -race ./...
```

写好测试是保证代码质量的关键。',
'从基础测试到表驱动测试和 Mock，全面掌握 Go 语言的单元测试方法。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 17 DAY), DATE_SUB(NOW(), INTERVAL 17 DAY), NOW()),

('Element Plus 主题定制指南', 'element-plus-theme-customization',
'# Element Plus 主题定制指南

## CSS 变量方式

Element Plus 使用 CSS 变量实现主题，最简单的方式：

```css
:root {
  --el-color-primary: #409eff;
  --el-color-primary-light-3: #79bbff;
  --el-color-primary-light-5: #a0cfff;
  --el-color-primary-light-7: #c6e2ff;
  --el-color-primary-light-8: #d9ecff;
  --el-color-primary-light-9: #ecf5ff;
  --el-color-primary-dark-2: #337ecc;
}
```

## 暗黑模式

```html
<html class="dark">
```

```css
html.dark {
  --el-bg-color: #141414;
  --el-text-color-primary: #e5eaf3;
}
```

## SCSS 变量覆盖

```scss
@use "element-plus/theme-chalk/dark/css-vars.scss" as *;

$--colors: (
  "primary": (
    "base": #409eff,
  ),
);

@forward "element-plus/theme-chalk/src/index" with (
  $colors: $--colors
);
```

## 按需导入主题

```typescript
import "element-plus/theme-chalk/el-button.css"
import "element-plus/theme-chalk/el-input.css"
```

## 自定义组件样式

```scss
.el-button--primary {
  --el-button-bg-color: #409eff;
  --el-button-border-color: #409eff;
  &:hover {
    --el-button-bg-color: #79bbff;
    --el-button-border-color: #79bbff;
  }
}
```

## 设计令牌

```typescript
import { useToken } from "element-plus"
const { textColorPrimary, bgColor } = useToken()
```

通过主题定制让你的应用脱颖而出。',
'详解 Element Plus 的主题定制方法，包括 CSS 变量、SCSS 覆盖和暗黑模式配置。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 19 DAY), DATE_SUB(NOW(), INTERVAL 19 DAY), NOW()),

('微前端架构探索', 'micro-frontend-architecture',
'# 微前端架构探索

## 什么是微前端？

将前端应用拆分成多个独立开发、独立部署的小型应用，类似于后端的微服务。

## 方案对比

| 方案 | 特点 |
|------|------|
| qiankun | 基于 single-spa，阿里出品 |
| Module Federation | Webpack 5 原生支持 |
| micro-app | 类似 iframe，京东出品 |

## qiankun 实现

### 主应用

```typescript
import { registerMicroApps, start } from "qiankun"

registerMicroApps([
  {
    name: "admin",
    entry: "//localhost:8081",
    container: "#container",
    activeRule: "/admin",
  },
  {
    name: "blog",
    entry: "//localhost:8082",
    container: "#container",
    activeRule: "/blog",
  },
])

start()
```

### 子应用

```typescript
// 导出生命周期
export async function bootstrap() {}
export async function mount(props) {}
export async function unmount() {}
```

## Module Federation

```javascript
// 主应用
new ModuleFederationPlugin({
  name: "host",
  remotes: {
    admin: "admin@http://localhost:8081/remoteEntry.js",
  },
})

// 使用
const AdminApp = React.lazy(() => import("admin/App"))
```

## 适用场景

1. 多团队协作
2. 技术栈异构
3. 独立部署需求
4. 存量应用整合

## 注意事项

- 样式隔离
- 状态共享
- 性能开销
- 调试复杂度

微前端不是银弹，需要根据实际情况决定是否采用。',
'探索微前端架构的实现方案，对比 qiankun 和 Module Federation 等主流方案。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 21 DAY), DATE_SUB(NOW(), INTERVAL 21 DAY), NOW()),

('HTTPS 原理与 TLS 握手', 'https-tls-handshake',
'# HTTPS 原理与 TLS 握手

## 为什么需要 HTTPS？

HTTP 明文传输，存在三大风险：
1. 窃听 — 数据被中间人截获
2. 篡改 — 数据被修改
3. 冒充 — 身份被伪造

## TLS 握手过程

```
Client                              Server
  |                                    |
  | -------- ClientHello ------------> |
  |         (支持的加密套件)              |
  |                                    |
  | <------- ServerHello ------------- |
  |         (选择的加密套件)              |
  | <------- Certificate ------------- |
  |         (服务器证书)                 |
  | <------- ServerKeyExchange -------- |
  |         (服务器公钥)                 |
  | <------- ServerHelloDone ---------- |
  |                                    |
  | -------- ClientKeyExchange ------> |
  |         (客户端公钥)                 |
  | -------- ChangeCipherSpec -------> |
  | -------- Finished ---------------> |
  |                                    |
  | <------- ChangeCipherSpec -------- |
  | <------- Finished ---------------- |
  |                                    |
  | <======== 加密通信开始 =========> |
```

## 证书验证

1. 浏览器获取服务器证书
2. 验证证书链是否完整
3. 检查证书是否过期
4. 验证域名是否匹配
5. 检查证书是否被吊销（CRL/OCSP）

## 对称与非对称加密

- **非对称加密**（RSA）: 密钥交换
- **对称加密**（AES）: 数据传输
- **哈希算法**（SHA-256）: 完整性校验

## 性能优化

1. TLS 1.3 — 减少握手往返
2. 会话复用 — 避免重复握手
3. OCSP Stapling — 减少证书验证延迟
4. HTTP/2 — 多路复用

## 实践建议

- 使用 TLS 1.2+
- 配置 HSTS
- 定期更新证书
- 使用 CDN 加速',
'深入理解 HTTPS 的安全机制和 TLS 握手过程，掌握加密通信的原理。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 23 DAY), DATE_SUB(NOW(), INTERVAL 23 DAY), NOW()),

('代码重构的艺术', 'the-art-of-refactoring',
'# 代码重构的艺术

## 什么时候重构？

1. 添加新功能前
2. 修复 bug 后
3. Code Review 发现问题时
4. 代码有明显坏味道时

## 常见坏味道

### 重复代码

```go
// Before
func ProcessOrder(o Order) {
    if o.Amount <= 0 {
        return errors.New("invalid amount")
    }
    // ...
}

func ProcessRefund(r Refund) {
    if r.Amount <= 0 {
        return errors.New("invalid amount")
    }
    // ...
}

// After
func ValidateAmount(amount float64) error {
    if amount <= 0 {
        return errors.New("invalid amount")
    }
    return nil
}
```

### 过长函数

将函数拆分为多个小函数，每个函数只做一件事。

### 过多参数

使用结构体封装相关参数：

```go
// Before
func CreatePost(title, slug, content, summary string, categoryID uint, tagIDs []uint) {}

// After
type CreatePostParams struct {
    Title      string
    Slug       string
    Content    string
    Summary    string
    CategoryID uint
    TagIDs     []uint
}
func CreatePost(params CreatePostParams) {}
```

## 重构手法

1. **提取函数** — 将代码块提取为独立函数
2. **内联函数** — 将简单函数内联
3. **搬移函数** — 将函数移到更合适的类
4. **重命名** — 使用更有意义的名称

## 重构原则

- 小步前进
- 频繁测试
- 保持行为不变
- 先重构再优化

> 重构是软件开发的日常，不是特殊活动。',
'探讨代码重构的原则和手法，帮助你持续改善代码质量。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 24 DAY), DATE_SUB(NOW(), INTERVAL 24 DAY), NOW()),

('Kubernetes 基础概念入门', 'kubernetes-basic-concepts',
'# Kubernetes 基础概念入门

## 核心概念

### Pod

Kubernetes 最小调度单位，包含一个或多个容器。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: blog-app
spec:
  containers:
    - name: app
      image: blog:latest
      ports:
        - containerPort: 8080
```

### Deployment

管理 Pod 的部署和更新。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog
spec:
  replicas: 3
  selector:
    matchLabels:
      app: blog
  template:
    metadata:
      labels:
        app: blog
    spec:
      containers:
        - name: app
          image: blog:latest
          ports:
            - containerPort: 8080
```

### Service

暴露 Pod 给集群内部或外部访问。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: blog-service
spec:
  type: LoadBalancer
  selector:
    app: blog
  ports:
    - port: 80
      targetPort: 8080
```

## 常用命令

```bash
kubectl get pods
kubectl apply -f deployment.yaml
kubectl logs -f pod/blog-xxx
kubectl exec -it pod/blog-xxx -- /bin/sh
kubectl port-forward svc/blog-service 8080:80
```

## 适用场景

- 微服务架构
- 自动扩缩容
- 自愈能力
- 滚动更新

Kubernetes 是容器编排的事实标准。',
'介绍 Kubernetes 的核心概念，包括 Pod、Deployment、Service 等基础资源。',
'', 'published', 3, 1, DATE_SUB(NOW(), INTERVAL 26 DAY), DATE_SUB(NOW(), INTERVAL 26 DAY), NOW()),

('Elasticsearch 搜索入门', 'elasticsearch-getting-started',
'# Elasticsearch 搜索入门

## 基本概念

- **Index**: 类似数据库的表
- **Document**: 一条数据记录
- **Field**: 文档的字段
- **Mapping**: 定义字段类型

## 创建索引

```json
PUT /posts
{
  "mappings": {
    "properties": {
      "title": { "type": "text", "analyzer": "ik_max_word" },
      "content": { "type": "text", "analyzer": "ik_max_word" },
      "category": { "type": "keyword" },
      "created_at": { "type": "date" }
    }
  }
}
```

## 索引文档

```json
POST /posts/_doc/1
{
  "title": "Go 并发编程",
  "content": "Goroutine 是 Go 的并发原语...",
  "category": "后端开发",
  "created_at": "2024-01-15"
}
```

## 搜索

```json
GET /posts/_search
{
  "query": {
    "multi_match": {
      "query": "Go 并发",
      "fields": ["title^2", "content"]
    }
  },
  "highlight": {
    "fields": {
      "title": {},
      "content": {}
    }
  }
}
```

## 聚合查询

```json
GET /posts/_search
{
  "aggs": {
    "by_category": {
      "terms": { "field": "category" }
    }
  }
}
```

Elasticsearch 是全文搜索的利器。',
'快速上手 Elasticsearch，掌握索引创建、文档索引和搜索查询的基础操作。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 27 DAY), DATE_SUB(NOW(), INTERVAL 27 DAY), NOW()),

('Go 泛型编程入门', 'go-generics-introduction',
'# Go 泛型编程入门

## 泛型函数

```go
func Map[T, U any](s []T, f func(T) U) []U {
    result := make([]U, len(s))
    for i, v := range s {
        result[i] = f(v)
    }
    return result
}

// 使用
names := Map(users, func(u User) string { return u.Name })
```

## 类型约束

```go
type Number interface {
    ~int | ~float64
}

func Sum[T Number](nums []T) T {
    var total T
    for _, n := range nums {
        total += n
    }
    return total
}
```

## 泛型数据结构

```go
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}
```

## 实用泛型函数

```go
// Filter
func Filter[T any](s []T, pred func(T) bool) []T {
    var result []T
    for _, v := range s {
        if pred(v) {
            result = append(result, v)
        }
    }
    return result
}

// Contains
func Contains[T comparable](s []T, target T) bool {
    for _, v := range s {
        if v == target {
            return true
        }
    }
    return false
}
```

泛型让 Go 代码更加灵活和可复用。',
'从基础语法到实用案例，入门 Go 1.18 引入的泛型编程特性。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 29 DAY), DATE_SUB(NOW(), INTERVAL 29 DAY), NOW()),

('程序员效率工具推荐', 'developer-productivity-tools',
'# 程序员效率工具推荐

## 终端

### Warp

现代化终端，支持 AI 命令补全。

### Oh My Zsh

Zsh 配置框架，丰富的插件生态。

## 编辑器

### VS Code

必备插件：
- GitLens — Git 增强
- Error Lens — 行内错误提示
- GitHub Copilot — AI 编程助手
- Prettier — 代码格式化

### JetBrains IDE

GoLand、WebStorm 等，功能强大的专业 IDE。

## 命令行工具

| 工具 | 用途 |
|------|------|
| ripgrep | 快速搜索 |
| fd | 文件查找 |
| bat | 代码高亮查看 |
| fzf | 模糊搜索 |
| jq | JSON 处理 |

## 效率软件

### Raycast（Mac）

启动器 + 工具集，替代 Spotlight。

### Rectangle（Mac）

窗口管理，快捷键分屏。

### Notion

笔记 + 知识库 + 项目管理。

## 浏览器

### Vimium

键盘操控浏览器，告别鼠标。

### 1Password

密码管理，安全方便。

## API 测试

### Bruno

开源 API 客户端，替代 Postman。

善用工具事半功倍。',
'精选程序员效率工具，从终端到编辑器，从命令行到桌面应用，提升开发效率。',
'', 'published', 5, 1, DATE_SUB(NOW(), INTERVAL 31 DAY), DATE_SUB(NOW(), INTERVAL 31 DAY), NOW()),

('OAuth 2.0 认证流程详解', 'oauth2-authentication-flow',
'# OAuth 2.0 认证流程详解

## 什么是 OAuth 2.0？

一种授权框架，允许第三方应用在用户授权下访问资源，无需获取用户密码。

## 授权码模式

最常用的模式，适合有后端的应用：

```
1. 用户点击"使用 GitHub 登录"
2. 重定向到 GitHub 授权页面
3. 用户授权后，GitHub 回调应用
4. 应用用授权码换取 Access Token
5. 用 Token 获取用户信息
```

## 实现示例

### 第一步：跳转授权

```
GET https://github.com/login/oauth/authorize
  ?client_id=xxx
  &redirect_uri=http://localhost:8080/callback
  &scope=user:email
```

### 第二步：回调处理

```go
func callback(c *gin.Context) {
    code := c.Query("code")

    // 用 code 换 token
    resp, _ := http.PostForm("https://github.com/login/oauth/access_token", url.Values{
        "client_id":     {clientID},
        "client_secret": {clientSecret},
        "code":          {code},
    })

    // 解析 token
    token := parseToken(resp)

    // 获取用户信息
    user := getUserInfo(token)
}
```

## 安全注意事项

1. 使用 state 参数防止 CSRF
2. 验证 redirect_uri
3. Token 安全存储
4. 使用 HTTPS
5. Token 设置过期时间

## 与 JWT 的区别

- OAuth 2.0：授权框架
- JWT：令牌格式

两者可以配合使用。',
'详解 OAuth 2.0 的认证流程，从原理到实现，掌握第三方登录的完整方案。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 33 DAY), DATE_SUB(NOW(), INTERVAL 33 DAY), NOW()),

('程序员如何保持学习', 'how-developers-keep-learning',
'# 程序员如何保持学习

## 为什么要持续学习？

技术更新快，不学习就会被淘汰。但更重要的是，学习让工作更有趣。

## 学习方法

### 1. 项目驱动

做项目是最高效的学习方式。不要只看教程，动手做。

### 2. 费曼技巧

用简单的语言解释复杂概念，如果解释不清楚，说明还没真正理解。

### 3. 刻意练习

找到自己的薄弱点，有针对性地练习。

### 4. 教别人

写博客、做分享、回答问题。教是最好的学。

## 学习资源

### 免费资源

- MDN Web Docs
- Go 官方教程
- Vue.js 官方文档
- YouTube 技术频道

### 付费资源

- Udemy / Coursera
- 极客时间
- 技术书籍

## 时间管理

1. 利用碎片时间听播客
2. 每天固定时间学习（哪怕 30 分钟）
3. 周末做项目实践
4. 减少无效社交

## 避免的误区

1. 收藏了很多但从不看
2. 只学不练
3. 追求新技术，忽略基础
4. 学习焦虑

## 推荐习惯

- 每周读一篇源码
- 每月一个小项目
- 每年学一门新语言
- 每天记录学习笔记

> 学习不是冲刺，是马拉松。',
'分享程序员持续学习的方法和习惯，帮助你在快速变化的技术领域保持竞争力。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 34 DAY), DATE_SUB(NOW(), INTERVAL 34 DAY), NOW()),

('浅谈技术选型', 'thoughts-on-tech-selection',
'# 浅谈技术选型

## 选型原则

### 1. 适合团队

团队熟悉的技术比"最好"的技术更重要。

### 2. 社区活跃

看 GitHub stars、issue 处理速度、文档质量。

### 3. 生态完善

有没有你需要的库？遇到问题能不能搜到答案？

### 4. 长期维护

避免选择快要被废弃的技术。

## 案例分析

### 前端框架选择

Vue vs React：

- Vue：学习曲线平缓，中文文档好
- React：生态更丰富，就业市场大

对于小团队和个人项目，Vue 更友好。

### 后端框架选择

Go Gin vs Node Express：

- Gin：高性能，类型安全
- Express：开发快，JavaScript 全栈

对于需要高性能的场景，Go 更合适。

### 数据库选择

MySQL vs PostgreSQL：

- MySQL：简单够用，运维成熟
- PostgreSQL：功能丰富，JSON 支持好

对于博客这类应用，MySQL 足够。

## 不要过度设计

选择技术时要考虑：
1. 当前需求
2. 团队能力
3. 维护成本

不要为了"可能的需求"引入不必要的复杂度。

## 总结

没有最好的技术，只有最合适的技术。选型要从实际出发。',
'讨论技术选型的思考方式，帮助你在面对选择时做出理性决策。',
'', 'published', 4, 1, DATE_SUB(NOW(), INTERVAL 36 DAY), DATE_SUB(NOW(), INTERVAL 36 DAY), NOW()),

('我的终端美化配置', 'my-terminal-beautification',
'# 我的终端美化配置

## 工具链

- **iTerm2**: 终端模拟器
- **Oh My Zsh**: Zsh 配置框架
- **Starship**: 跨 shell 提示符
- **Nerd Font**: 图标字体

## Starship 配置

```toml
# ~/.config/starship.toml

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[git_branch]
symbol = " "

[git_status]
ahead = "⇡${count}"
behind = "⇣${count}"

[nodejs]
symbol = " "

[golang]
symbol = " "

[docker_context]
symbol = " "
```

## Oh My Zsh 插件

```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  docker
  kubectl
)
```

## 别名配置

```bash
# ~/.zshrc
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias dc="docker compose"
alias k="kubectl"
alias ll="ls -la"
```

## 效果

配置完成后，终端会显示：
- 当前目录
- Git 分支和状态
- 当前语言/工具版本
- 上一条命令耗时

一个好看的终端能提升开发心情。',
'分享我的终端美化方案，从 iTerm2 到 Starship，打造高效的开发环境。',
'', 'published', 5, 1, DATE_SUB(NOW(), INTERVAL 37 DAY), DATE_SUB(NOW(), INTERVAL 37 DAY), NOW()),

('Go Context 使用指南', 'go-context-usage-guide',
'# Go Context 使用指南

## Context 是什么？

Context 用于在 goroutine 之间传递截止时间、取消信号和请求范围的值。

## 基本用法

### WithCancel

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel()

go func() {
    // 监听取消信号
    <-ctx.Done()
    fmt.Println("cancelled")
}()
```

### WithTimeout

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

result, err := slowOperation(ctx)
if err != nil {
    fmt.Println("timeout or cancelled")
}
```

### WithValue

```go
ctx := context.WithValue(context.Background(), "userID", 123)

// 在其他地方获取
userID := ctx.Value("userID").(int)
```

## HTTP 请求中使用

```go
func handler(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()

    result, err := dbQuery(ctx)
    if err != nil {
        if ctx.Err() == context.Canceled {
            // 客户端断开连接
            return
        }
    }
}
```

## 最佳实践

1. Context 作为第一个参数传递
2. 不要存储 Context 在结构体中
3. 使用 WithTimeout 控制超时
4. 及时调用 cancel 释放资源
5. 不要传递 nil Context

```go
// Good
func DoSomething(ctx context.Context, param string) error

// Bad
func (s *Service) DoSomething(param string) error // 没有 context
```

Context 是 Go 并发编程的重要工具。',
'全面讲解 Go Context 的用法，包括取消、超时和值传递，附带最佳实践。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 39 DAY), DATE_SUB(NOW(), INTERVAL 39 DAY), NOW()),

('响应式设计完全指南', 'responsive-design-complete-guide',
'# 响应式设计完全指南

## 核心概念

### 移动优先

先设计移动端，再逐步适配大屏。

```css
/* 移动端样式（默认） */
.container {
  padding: 1rem;
}

/* 平板 */
@media (min-width: 768px) {
  .container {
    padding: 2rem;
  }
}

/* 桌面 */
@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

### 弹性布局

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}
```

### 弹性图片

```css
img {
  max-width: 100%;
  height: auto;
}
```

## CSS 单位

- `vw/vh`: 视口单位
- `%`: 相对父元素
- `rem`: 相对根元素字体
- `em`: 相对当前字体
- `fr`: Grid 弹性单位

## 实用断点

```css
/* 手机 */
@media (max-width: 640px) { }

/* 平板 */
@media (min-width: 768px) { }

/* 小桌面 */
@media (min-width: 1024px) { }

/* 大桌面 */
@media (min-width: 1280px) { }
```

## 测试技巧

1. Chrome DevTools 设备模拟
2. 真机测试
3. 不同浏览器测试

## 常见问题

- 文字太小：使用 rem 而非 px
- 横向滚动：检查固定宽度元素
- 点击区域太小：最小 44x44px

响应式设计是现代 Web 开发的基础。',
'从移动优先到弹性布局，全面掌握响应式 Web 设计的方法和技巧。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 41 DAY), DATE_SUB(NOW(), INTERVAL 41 DAY), NOW()),

('Go 错误处理最佳实践', 'go-error-handling-best-practices',
'# Go 错误处理最佳实践

## 基本模式

```go
result, err := doSomething()
if err != nil {
    return fmt.Errorf("doSomething failed: %w", err)
}
```

## 错误包装

使用 `%w` 包装错误，保留原始错误信息：

```go
var ErrNotFound = errors.New("not found")

func FindUser(id int) (*User, error) {
    user, err := db.FindByID(id)
    if errors.Is(err, sql.ErrNoRows) {
        return nil, fmt.Errorf("user %d: %w", id, ErrNotFound)
    }
    if err != nil {
        return nil, fmt.Errorf("FindUser: %w", err)
    }
    return user, nil
}
```

## 自定义错误类型

```go
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed on %s: %s", e.Field, e.Message)
}

// 使用
func ValidateUser(u User) error {
    if u.Name == "" {
        return &ValidationError{Field: "name", Message: "required"}
    }
    return nil
}
```

## Sentinel Errors vs 自定义类型

| 方式 | 适用场景 |
|------|----------|
| Sentinel | 简单的错误判断 |
| 自定义类型 | 需要携带额外信息 |

## 错误处理策略

1. 在边界处理错误（handler 层）
2. 中间层只包装错误
3. 不要忽略错误
4. 提供有用的错误上下文

```go
// Bad
_ = doSomething()

// Good
if err := doSomething(); err != nil {
    log.Printf("doSomething failed: %v", err)
    return err
}
```

良好的错误处理让调试更容易。',
'深入 Go 语言的错误处理机制，从基本模式到高级技巧，写出更健壮的代码。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 42 DAY), DATE_SUB(NOW(), INTERVAL 42 DAY), NOW()),

('网页动画性能优化', 'web-animation-performance',
'# 网页动画性能优化

## 浏览器渲染流程

1. **JavaScript** — 计算样式
2. **Style** — 生成样式规则
3. **Layout** — 计算几何信息
4. **Paint** — 绘制图层
5. **Composite** — 合成显示

## 高性能属性

只触发 Composite 的属性：
- `transform`
- `opacity`

```css
/* Good */
.animate {
  transition: transform 0.3s;
}
.animate:hover {
  transform: translateY(-4px);
}

/* Bad */
.animate {
  transition: top 0.3s; /* 触发 layout */
}
```

## will-change

提示浏览器提前优化：

```css
.card {
  will-change: transform;
}
```

不要过度使用，会消耗内存。

## requestAnimationFrame

```javascript
function animate() {
  element.style.transform = `translateX(${x}px)`
  x += 1
  if (x < 300) {
    requestAnimationFrame(animate)
  }
}
requestAnimationFrame(animate)
```

## CSS vs JS 动画

| 方式 | 适用场景 |
|------|----------|
| CSS transition | 简单状态变化 |
| CSS animation | 循环动画 |
| JS (rAF) | 复杂交互动画 |

## 性能检测

1. Chrome DevTools Performance 面板
2. 查看帧率是否稳定 60fps
3. 绿色条 = 合成层

## 总结

- 优先使用 transform 和 opacity
- 避免在动画中触发 layout
- 使用 DevTools 检测性能',
'详解网页动画的性能优化技巧，从渲染原理到实践方法，实现流畅的 60fps 动画。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 44 DAY), DATE_SUB(NOW(), INTERVAL 44 DAY), NOW()),

('设计模式在 Go 中的实现', 'design-patterns-in-go',
'# 设计模式在 Go 中的实现

## 工厂模式

```go
type Storage interface {
    Save(path string, data []byte) error
}

func NewStorage(driver string) Storage {
    switch driver {
    case "local":
        return &LocalStorage{}
    case "s3":
        return &S3Storage{}
    default:
        return &LocalStorage{}
    }
}
```

## 单例模式

```go
var (
    instance *Service
    once     sync.Once
)

func GetService() *Service {
    once.Do(func() {
        instance = &Service{}
    })
    return instance
}
```

## 策略模式

```go
type Formatter interface {
    Format(data []byte) string
}

type JSONFormatter struct{}
func (f JSONFormatter) Format(data []byte) string { /* ... */ }

type XMLFormatter struct{}
func (f XMLFormatter) Format(data []byte) string { /* ... */ }

type Logger struct {
    formatter Formatter
}

func (l *Logger) Log(data []byte) {
    fmt.Println(l.formatter.Format(data))
}
```

## 装饰器模式（中间件）

```go
func Logging(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        next.ServeHTTP(w, r)
        log.Printf("%s %s %v", r.Method, r.URL.Path, time.Since(start))
    })
}
```

## 观察者模式

```go
type EventManager struct {
    listeners map[string][]func(interface{})
}

func (e *EventManager) Subscribe(event string, fn func(interface{})) {
    e.listeners[event] = append(e.listeners[event], fn)
}

func (e *EventManager) Emit(event string, data interface{}) {
    for _, fn := range e.listeners[event] {
        fn(data)
    }
}
```

设计模式是解决问题的工具，不是教条。',
'用 Go 语言实现常用设计模式，包括工厂、单例、策略、装饰器和观察者模式。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 46 DAY), DATE_SUB(NOW(), INTERVAL 46 DAY), NOW()),

('Git Rebase vs Merge', 'git-rebase-vs-merge',
'# Git Rebase vs Merge

## Merge

保留完整的分支历史：

```bash
git checkout main
git merge feature
```

生成一个合并提交，保留两条分支线。

## Rebase

将分支线性化：

```bash
git checkout feature
git rebase main
```

将 feature 的提交"移到" main 的最新提交之后。

## 对比

| 特性 | Merge | Rebase |
|------|-------|--------|
| 历史 | 完整，有分支 | 线性，干净 |
| 冲突 | 一次性解决 | 每个提交可能遇到 |
| 安全性 | 安全 | 会改写历史 |
| 适用 | 公共分支 | 本地分支 |

## 黄金法则

> 永远不要 rebase 已经推送到远程的公共分支。

## 工作流建议

```bash
# 功能开发中，保持与 main 同步
git checkout feature
git rebase main

# 功能完成后，合并到 main
git checkout main
git merge --no-ff feature
```

## 交互式 Rebase

```bash
git rebase -i HEAD~3
```

可以：
- `pick`: 保留
- `squash`: 合并到前一个
- `edit`: 修改
- `drop`: 删除

## 选择建议

- 个人分支：用 rebase 保持整洁
- 团队分支：用 merge 保留历史
- PR 合并：squash and merge

根据场景选择合适的策略。',
'深入理解 Git Rebase 和 Merge 的区别和使用场景，写出更清晰的提交历史。',
'', 'published', 5, 1, DATE_SUB(NOW(), INTERVAL 47 DAY), DATE_SUB(NOW(), INTERVAL 47 DAY), NOW()),

('Go JSON 处理技巧', 'go-json-processing-tips',
'# Go JSON 处理技巧

## 基本序列化

```go
type User struct {
    Name  string `json:"name"`
    Email string `json:"email,omitempty"`
    Age   int    `json:"age"`
}

// 编码
data, _ := json.Marshal(user)

// 解码
var user User
json.Unmarshal(data, &user)
```

## 嵌套结构

```go
type Post struct {
    Title string `json:"title"`
    Author struct {
        Name string `json:"name"`
    } `json:"author"`
}
```

## 自定义序列化

```go
type Time time.Time

func (t Time) MarshalJSON() ([]byte, error) {
    return []byte(`"` + time.Time(t).Format("2006-01-02") + `"`), nil
}
```

## 处理未知结构

```go
var data map[string]interface{}
json.Unmarshal(jsonBytes, &data)
```

## 流式处理大文件

```go
decoder := json.NewDecoder(file)
for {
    var item Item
    if err := decoder.Decode(&item); err == io.EOF {
        break
    }
    process(item)
}
```

## 常见问题

### 忽略空值

```go
type Config struct {
    Name string `json:"name,omitempty"`
}
```

### 数字精度

```go
// 使用 json.Number 避免精度丢失
decoder.UseNumber()
```

### 处理 null

```go
type Response struct {
    Data *User `json:"data"` // 指针类型可以区分 null 和零值
}
```

JSON 处理是 Go Web 开发的日常技能。',
'分享 Go 语言 JSON 处理的实用技巧，涵盖自定义序列化、流式处理和常见问题。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 48 DAY), DATE_SUB(NOW(), INTERVAL 48 DAY), NOW()),

('前端路由实现原理', 'frontend-router-principle',
'# 前端路由实现原理

## Hash 模式

使用 URL 的 hash（#）部分：

```javascript
class HashRouter {
  constructor() {
    this.routes = {}
    window.addEventListener("hashchange", () => this.handleRoute())
  }

  register(path, handler) {
    this.routes[path] = handler
  }

  handleRoute() {
    const path = location.hash.slice(1) || "/"
    const handler = this.routes[path]
    if (handler) handler()
  }
}
```

## History 模式

使用 HTML5 History API：

```javascript
class HistoryRouter {
  constructor() {
    this.routes = {}
    window.addEventListener("popstate", () => this.handleRoute())
  }

  register(path, handler) {
    this.routes[path] = handler
  }

  push(path) {
    history.pushState(null, "", path)
    this.handleRoute()
  }

  handleRoute() {
    const path = location.pathname
    const handler = this.routes[path]
    if (handler) handler()
  }
}
```

## Vue Router 简化实现

```javascript
function createRouter(options) {
  const routes = options.routes

  return {
    install(app) {
      const currentRoute = ref(window.location.pathname)

      window.addEventListener("popstate", () => {
        currentRoute.value = window.location.pathname
      })

      app.config.globalProperties.$router = {
        push(path) {
          history.pushState(null, "", path)
          currentRoute.value = path
        },
      }

      app.provide("route", currentRoute)
    },
  }
}
```

## 服务端配置

History 模式需要服务端将所有请求重定向到 index.html：

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

理解路由原理有助于排查路由相关问题。',
'从零实现前端路由，理解 Hash 和 History 两种模式的工作原理。',
'', 'published', 1, 1, DATE_SUB(NOW(), INTERVAL 49 DAY), DATE_SUB(NOW(), INTERVAL 49 DAY), NOW()),

('RESTful API 版本管理策略', 'api-versioning-strategies',
'# RESTful API 版本管理策略

## 为什么需要版本管理？

API 变更不可避免，版本管理确保向后兼容。

## 版本策略

### 1. URL 路径

```
/api/v1/posts
/api/v2/posts
```

最直观，容易理解和路由。

### 2. 请求头

```
Accept: application/vnd.api.v1+json
```

URL 干净，但不够直观。

### 3. 查询参数

```
/api/posts?version=1
```

简单，但不太 RESTful。

## 实现示例（Go）

```go
func SetupRoutes(r *gin.Engine) {
    v1 := r.Group("/api/v1")
    {
        v1.GET("/posts", v1ListPosts)
        v1.POST("/posts", v1CreatePost)
    }

    v2 := r.Group("/api/v2")
    {
        v2.GET("/posts", v2ListPosts)
        v2.POST("/posts", v2CreatePost)
    }
}
```

## 共享逻辑

```go
func v1ListPosts(c *gin.Context) {
    posts, total := postSvc.List(params)
    c.JSON(200, gin.H{"data": posts, "total": total})
}

func v2ListPosts(c *gin.Context) {
    posts, total := postSvc.List(params)
    // v2 新增分页信息
    c.JSON(200, gin.H{
        "data": posts,
        "total": total,
        "page": params.Page,
        "page_size": params.PageSize,
    })
}
```

## 建议

1. 新功能只在最新版本添加
2. 旧版本设置弃用时间线
3. 文档标注版本差异
4. 不要维护超过 2 个版本

合理的版本策略减少维护负担。',
'讨论 RESTful API 的版本管理策略，从 URL 路径到请求头，选择适合你的方案。',
'', 'published', 2, 1, DATE_SUB(NOW(), INTERVAL 50 DAY), DATE_SUB(NOW(), INTERVAL 50 DAY), NOW());

-- 插入文章标签关联（为每篇文章随机分配 1-3 个标签）
INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id
FROM posts p
CROSS JOIN tags t
WHERE p.deleted_at IS NULL
  AND t.deleted_at IS NULL
  AND (
    -- 根据分类关联相关标签
    (p.category_id = 1 AND t.id IN (1, 2, 4, 9)) OR   -- 前端：Vue, React, TS, CSS
    (p.category_id = 2 AND t.id IN (3, 4, 6, 7)) OR    -- 后端：Go, TS, MySQL, Redis
    (p.category_id = 3 AND t.id IN (5, 11)) OR          -- DevOps：Docker, Linux
    (p.category_id = 4 AND t.id IN (8)) OR              -- 随笔：Git
    (p.category_id = 5 AND t.id IN (8, 10, 12))         -- 工具：Git, Node, 性能
  )
ORDER BY RAND()
LIMIT 100;
