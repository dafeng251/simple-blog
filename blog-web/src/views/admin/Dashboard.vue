<template>
  <div class="dashboard">
    <h2>仪表盘</h2>
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card>
          <template #header>文章总数</template>
          <div class="stat">{{ stats.posts }}</div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card>
          <template #header>评论总数</template>
          <div class="stat">{{ stats.comments }}</div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card>
          <template #header>分类总数</template>
          <div class="stat">{{ stats.categories }}</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAdminPosts } from '../../api/post'
import { getAdminComments } from '../../api/comment'
import { getCategories } from '../../api/category'

const stats = ref({ posts: 0, comments: 0, categories: 0 })

onMounted(async () => {
  try {
    const [postRes, commentRes, categoryRes]: any[] = await Promise.all([
      getAdminPosts({ page: 1, page_size: 1 }),
      getAdminComments({ page: 1, page_size: 1 }),
      getCategories(),
    ])
    stats.value.posts = postRes.total || 0
    stats.value.comments = commentRes.total || 0
    stats.value.categories = categoryRes.data?.length || 0
  } catch {
    // ignore
  }
})
</script>

<style scoped>
.stat {
  font-size: 2rem;
  font-weight: bold;
  text-align: center;
  color: #409eff;
}
</style>
