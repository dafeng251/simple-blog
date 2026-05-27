<template>
  <div class="comment-list">
    <h2>评论管理</h2>
    <el-table :data="comments" v-loading="loading">
      <el-table-column prop="nickname" label="昵称" width="120" />
      <el-table-column prop="content" label="内容" show-overflow-tooltip />
      <el-table-column prop="post.title" label="所属文章" width="200" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusType(row.status)">{{ statusLabel(row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="250">
        <template #default="{ row }">
          <template v-if="row.status === 'pending'">
            <el-button size="small" type="success" @click="handleStatus(row.id, 'approved')"><el-icon><Check /></el-icon> 通过</el-button>
            <el-button size="small" type="warning" @click="handleStatus(row.id, 'rejected')"><el-icon><Close /></el-icon> 拒绝</el-button>
          </template>
          <el-button size="small" type="danger" @click="handleDelete(row.id)"><el-icon><Delete /></el-icon> 删除</el-button>
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
import { Check, Close, Delete } from '@element-plus/icons-vue'
import { getAdminComments, updateCommentStatus, deleteComment } from '../../api/comment'
import { ElMessage, ElMessageBox } from 'element-plus'
import Pagination from '../../components/Pagination.vue'

const comments = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

async function fetchComments() {
  loading.value = true
  try {
    const res: any = await getAdminComments({ page: page.value, page_size: pageSize })
    comments.value = res.data
    total.value = res.total
  } finally {
    loading.value = false
  }
}

async function handleStatus(id: number, status: string) {
  await updateCommentStatus(id, status)
  ElMessage.success('已更新')
  fetchComments()
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除？', '提示')
  await deleteComment(id)
  ElMessage.success('已删除')
  fetchComments()
}

function handlePageChange(p: number) {
  page.value = p
  fetchComments()
}

function statusType(s: string) {
  return s === 'approved' ? 'success' : s === 'rejected' ? 'danger' : 'warning'
}

function statusLabel(s: string) {
  return s === 'approved' ? '已通过' : s === 'rejected' ? '已拒绝' : '待审核'
}

onMounted(fetchComments)
</script>
