# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Personal blog system (个人博客系统) — a fullstack project with a Go backend and Vue 3 frontend. Currently in the planning/implementation phase. Detailed technical plans live in `docs/backend-plan.md` and `docs/frontend-plan.md` (written in Chinese).

## Architecture

Two independent sub-projects sharing a single deployment:

- **`blog-server/`** — Go REST API (Gin + GORM + MySQL). Layered: `handler → service → model`, with middleware for JWT auth, CORS, and logging. Entry point: `cmd/main.go`.
- **`blog-web/`** — Vue 3 SPA (Vite + TypeScript + Element Plus). Public blog pages + admin dashboard. Communicates with backend via Axios over `/api`.
- **Database** — MySQL + Redis. Key tables: `users`, `categories`, `tags`, `posts`, `post_tags`, `comments`, `site_config`. Redis used for post detail cache.
- **Deployment** — Docker + Caddy reverse proxy (auto HTTPS). Caddy serves frontend static files and proxies `/api` to the Go backend.

## API Surface

- **Public** (no auth): `GET /api/posts`, `GET /api/posts/:slug`, `GET /api/categories`, `GET /api/tags`, `POST /api/comments`
- **Admin** (JWT Bearer): CRUD for posts, categories, tags, comments, site config; `POST /api/admin/login`; `POST /api/admin/upload` for image uploads
- All admin routes are prefixed `/api/admin/`. JWT token is stored in `localStorage` and attached via Axios interceptor.

## Tech Stack

| Layer | Backend | Frontend |
|---|---|---|
| Language | Go | TypeScript |
| Framework | Gin | Vue 3 + Vite 6 |
| ORM / Cache | GORM (MySQL) + Redis | Pinia |
| Auth | golang-jwt/jwt/v5 | localStorage token |
| UI | — | Element Plus |
| Markdown | — | md-editor-v3 |

## Dev Commands

Once the project is scaffolded:

```bash
# Backend
cd blog-server
go run ./cmd/main.go       # start dev server
go build -o server ./cmd    # build binary

# Frontend
cd blog-web
npm install
npm run dev                 # Vite dev server
npm run build               # production build
```

## Key Conventions

- Backend follows handler/service/model layering — put business logic in `service/`, not handlers.
- GORM auto-migration handles schema changes; no separate migration files.
- Frontend API calls go through `src/api/request.ts` (Axios instance with auth interceptor). Each resource has its own file under `src/api/`.
- Frontend routes: public pages under `src/views/front/`, admin pages under `src/views/admin/`. Admin routes use Vue Router navigation guards to check token.
- Slugs are used as URL identifiers for posts, categories, and tags (not numeric IDs).
- Comments support threading via `parent_id` and require moderation (`pending/approved/rejected`).
