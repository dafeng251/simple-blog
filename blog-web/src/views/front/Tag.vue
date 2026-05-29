<template>
  <div class="tag-page">
    <h1>标签: {{ tagName }}</h1>
    <div v-if="loading" v-loading="true" style="height: 200px"></div>
    <div v-else>
      <el-card v-for="post in posts" :key="post.id" class="post-card">
        <router-link :to="`/post/${post.slug}`" class="post-link">
          <h2>{{ post.title }}</h2>
        </router-link>
        <p class="summary">{{ post.summary }}</p>
        <div class="meta">
          <span>{{ post.category?.name }}</span>
          <span>{{ formatDate(post.published_at || post.created_at) }}</span>
          <el-tag v-for="tag in post.tags" :key="tag.id" size="small">{{ tag.name }}</el-tag>
        </div>
      </el-card>
      <div v-if="!posts.length" class="empty">该标签下暂无文章</div>
    </div>
    <Pagination
      :total="total"
      :page-size="pageSize"
      :current-page="page"
      @page-change="handlePageChange"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { getPosts } from '../../api/post'
import { getTags } from '../../api/tag'
import Pagination from '../../components/Pagination.vue'

const route = useRoute()
const posts = ref<any[]>([])
const tagName = ref('')
const loading = ref(true)
const total = ref(0)
const page = ref(1)
const pageSize = 10

async function fetchPosts() {
  loading.value = true
  try {
    const tagRes: any = await getTags()
    const tags = tagRes.data || []
    const tag = tags.find((t: any) => t.slug === route.params.slug)
    if (!tag) {
      tagName.value = '未知标签'
      posts.value = []
      total.value = 0
      return
    }
    tagName.value = tag.name
    const res: any = await getPosts({
      tag_id: tag.id,
      page: page.value,
      page_size: pageSize,
    })
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
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

watch(() => route.params.slug, () => {
  page.value = 1
  fetchPosts()
})

onMounted(fetchPosts)
</script>

<style scoped>
.post-card {
  margin-bottom: 1rem;
}
.post-link {
  text-decoration: none;
  color: #333;
}
.post-link:hover {
  color: #409eff;
}
.summary {
  color: #666;
  margin: 0.5rem 0;
}
.meta {
  display: flex;
  gap: 0.5rem;
  align-items: center;
  color: #999;
  font-size: 0.85rem;
}
.empty {
  text-align: center;
  color: #999;
  padding: 2rem;
}
</style>
