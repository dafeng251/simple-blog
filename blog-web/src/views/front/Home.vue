<template>
  <div class="home">
    <div class="page-header">
      <h1>最新文章</h1>
      <p class="subtitle">分享技术与生活的点点滴滴</p>
    </div>
    <div v-if="loading" v-loading="true" style="height: 300px"></div>
    <div v-else class="post-grid">
      <router-link
        v-for="post in posts"
        :key="post.id"
        :to="`/post/${post.slug}`"
        class="post-card"
      >
        <div v-if="post.cover_image" class="card-cover">
          <el-image :src="post.cover_image" fit="cover" class="cover-img" />
        </div>
        <div class="card-body">
          <div class="card-meta">
            <span v-if="post.category?.name" class="card-category">{{ post.category.name }}</span>
            <span class="card-date">{{ formatDate(post.published_at || post.created_at) }}</span>
          </div>
          <h2 class="card-title">{{ post.title }}</h2>
          <p v-if="post.summary" class="card-summary">{{ post.summary }}</p>
          <div class="card-tags">
            <span v-for="tag in post.tags" :key="tag.id" class="tag-item">{{ tag.name }}</span>
          </div>
        </div>
      </router-link>
    </div>
    <el-empty v-if="!loading && posts.length === 0" description="暂无文章" />
    <div class="pagination-wrap">
      <Pagination
        :total="total"
        :page-size="pageSize"
        :current-page="page"
        @page-change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getPosts } from '../../api/post'
import Pagination from '../../components/Pagination.vue'

const posts = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

async function fetchPosts() {
  loading.value = true
  try {
    const res: any = await getPosts({ page: page.value, page_size: pageSize })
    posts.value = res.data
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function handlePageChange(p: number) {
  page.value = p
  fetchPosts()
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
}

onMounted(fetchPosts)
</script>

<style scoped>
.home {
  max-width: 1100px;
  margin: 0 auto;
}

.page-header {
  text-align: center;
  margin-bottom: 2.5rem;
}
.page-header h1 {
  font-size: 2rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 0.5rem;
}
.subtitle {
  color: #888;
  font-size: 0.95rem;
  margin: 0;
}

.post-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
}

.post-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}
.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.card-cover {
  width: 100%;
  overflow: hidden;
}
.cover-img {
  width: 100%;
  height: 200px;
  display: block;
  transition: transform 0.4s ease;
}
.post-card:hover .cover-img {
  transform: scale(1.05);
}

.card-body {
  padding: 1.25rem 1.5rem 1.5rem;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
  font-size: 0.8rem;
}
.card-category {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  color: #fff;
  padding: 2px 10px;
  border-radius: 12px;
  font-weight: 500;
}
.card-date {
  color: #aaa;
}

.card-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #1a1a2e;
  margin: 0 0 0.5rem;
  line-height: 1.4;
  transition: color 0.2s;
}
.post-card:hover .card-title {
  color: #409eff;
}

.card-summary {
  color: #666;
  font-size: 0.9rem;
  line-height: 1.6;
  margin: 0 0 auto;
  padding-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
}
.tag-item {
  font-size: 0.75rem;
  color: #666;
  background: #f5f5f5;
  padding: 2px 8px;
  border-radius: 4px;
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 2rem;
}

@media (max-width: 768px) {
  .post-grid {
    grid-template-columns: 1fr;
  }
}
</style>
