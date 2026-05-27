# 推荐 Skills 清单

按维度划分，优先安装标 ★ 的。

## 后端 (Go + Gin + GORM)

| Skill | 安装量 | 安装命令 | 用途 |
|---|---|---|---|
| ★ `golang-gin-api` | 92 | `npx skills add henriqueatila/golang-gin-best-practices@golang-gin-api` | Gin 最佳实践、项目结构、中间件 |
| ★ `sqlite-database-expert` | 1.7K | `npx skills add martinholovsky/claude-skills-generator@sqlite-database-expert` | SQLite 设计与优化 |
| ★ `go-gorm-model` | 84 | `npx skills add cristiano-pacheco/ai-tools@go-gorm-model` | GORM 模型定义与迁移 |
| `golang-gin-database` | 34 | `npx skills add henriqueatila/golang-gin-best-practices@golang-gin-database` | Gin + GORM 数据库集成 |
| `gin-gonic` | 58 | `npx skills add teachingai/full-stack-skills@gin-gonic` | Gin 框架通用指导 |
| `go-backend-clean-architecture` | 74 | `npx skills add eng0ai/eng0-template-skills@go-backend-clean-architecture` | handler/service/model 分层架构 |

## 前端 (Vue 3 + Element Plus + TypeScript)

| Skill | 安装量 | 安装命令 | 用途 |
|---|---|---|---|
| ★ `element-plus-vue3` | 1.7K | `npx skills add teachingai/full-stack-skills@element-plus-vue3` | Element Plus 组件用法、最佳实践 |
| ★ `vue-expert-js` | 2K | `npx skills add jeffallan/claude-skills@vue-expert-js` | Vue 3 组合式 API、生命周期 |
| ★ `vue-typescript` | 427 | `npx skills add mindrally/skills@vue-typescript` | Vue + TypeScript 类型规范 |
| `unit-test-vue-pinia` | 1.5K | `npx skills add github/awesome-copilot/unit-test-vue-pinia` | Vue + Pinia 单元测试 |
| `nuxtjs-vue-typescript` | 469 | `npx skills add mindrally/skills@nuxtjs-vue-typescript` | TypeScript 在 Vue 中的模式 |

## 通用开发工具

| Skill | 安装量 | 安装命令 | 用途 |
|---|---|---|---|
| ★ `git-workflow` | 389 | `npx skills add mindrally/skills@git-workflow` | Git 分支策略、commit 规范 |
| ★ `caddy-reverse-proxy` | 46 | `npx skills add dimdasci/vps-setup@caddy-reverse-proxy` | Caddy 反向代理配置 |
| `docker-deployment` | 421 | `npx skills add pluginagentmarketplace/custom-plugin-nodejs@docker-deployment` | Docker 容器化部署 |
| `docker-compose-production` | 199 | `npx skills add thebushidocollective/han@docker-compose-production` | Docker Compose 生产环境 |

## 快速安装

标 ★ 的核心组合（8 个）：

```bash
# 后端
npx skills add henriqueatila/golang-gin-best-practices@golang-gin-api -g -y
npx skills add martinholovsky/claude-skills-generator@sqlite-database-expert -g -y
npx skills add cristiano-pacheco/ai-tools@go-gorm-model -g -y

# 前端
npx skills add teachingai/full-stack-skills@element-plus-vue3 -g -y
npx skills add jeffallan/claude-skills@vue-expert-js -g -y
npx skills add mindrally/skills@vue-typescript -g -y

# 通用
npx skills add mindrally/skills@git-workflow -g -y
npx skills add dimdasci/vps-setup@caddy-reverse-proxy -g -y
```
