<template>
  <div class="category-page">
    <h1>分类: {{ categoryName }}</h1>
    <div v-loading="loading">
      <el-card v-for="post in posts" :key="post.id" class="post-card">
        <router-link :to="`/post/${post.slug}`">
          <h2>{{ post.title }}</h2>
        </router-link>
        <p>{{ post.summary }}</p>
      </el-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getPosts } from '../../api/post'

const route = useRoute()
const posts = ref<any[]>([])
const categoryName = ref('')
const loading = ref(true)

async function fetchPosts() {
  loading.value = true
  try {
    const res: any = await getPosts({ category_id: Number(route.params.slug) })
    posts.value = res.data
  } finally {
    loading.value = false
  }
}

onMounted(fetchPosts)
</script>

<style scoped>
.post-card {
  margin-bottom: 1rem;
}
</style>
