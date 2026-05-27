<template>
  <div class="post-list">
    <div class="header">
      <h2>文章管理</h2>
      <el-button type="primary" @click="$router.push('/admin/posts/edit')">
        <el-icon><Plus /></el-icon> 新建文章
      </el-button>
    </div>
    <el-table :data="posts" v-loading="loading">
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag :type="row.status === 'published' ? 'success' : 'info'">
            {{ row.status === 'published' ? '已发布' : '草稿' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="category.name" label="分类" />
      <el-table-column prop="created_at" label="创建时间">
        <template #default="{ row }">{{ formatDate(row.created_at) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template #default="{ row }">
          <el-button size="small" @click="$router.push(`/admin/posts/edit/${row.id}`)">
            <el-icon><Edit /></el-icon> 编辑
          </el-button>
          <el-button size="small" type="danger" @click="handleDelete(row.id)">
            <el-icon><Delete /></el-icon> 删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <Pagination
      :total="total"
      :page-size="pageSize"
      :current-page="page"
      @page-change="handlePageChange"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { getAdminPosts, deletePost } from '../../api/post'
import { ElMessage, ElMessageBox } from 'element-plus'
import Pagination from '../../components/Pagination.vue'

const posts = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

async function fetchPosts() {
  loading.value = true
  try {
    const res: any = await getAdminPosts({ page: page.value, page_size: pageSize })
    posts.value = res.data
    total.value = res.total
  } finally {
    loading.value = false
  }
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除这篇文章？', '提示')
  await deletePost(id)
  ElMessage.success('已删除')
  fetchPosts()
}

function handlePageChange(p: number) {
  page.value = p
  fetchPosts()
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

onMounted(fetchPosts)
</script>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}
</style>
