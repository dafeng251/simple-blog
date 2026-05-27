<template>
  <div class="comment-list">
    <el-card shadow="never">
      <div class="page-header">
        <h2>评论管理</h2>
        <el-popover placement="bottom-end" :width="200" trigger="click">
          <template #reference>
            <el-button><el-icon><Setting /></el-icon> 列设置</el-button>
          </template>
          <el-checkbox-group v-model="visibleColumns" @change="saveColumns">
            <el-checkbox v-for="col in allColumns" :key="col.prop" :label="col.prop" :value="col.prop">
              {{ col.label }}
            </el-checkbox>
          </el-checkbox-group>
        </el-popover>
      </div>
      <el-table :data="comments" v-loading="loading">
        <el-table-column v-if="show('id')" prop="id" label="ID" width="60" />
        <el-table-column v-if="show('nickname')" prop="nickname" label="昵称" width="100" />
        <el-table-column v-if="show('email')" prop="email" label="邮箱" width="160" show-overflow-tooltip />
        <el-table-column v-if="show('content')" prop="content" label="内容" min-width="200" show-overflow-tooltip />
        <el-table-column v-if="show('post')" prop="post.title" label="所属文章" width="160" show-overflow-tooltip />
        <el-table-column v-if="show('status')" prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)" size="small">{{ statusLabel(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column v-if="show('created_at')" label="创建时间" width="140">
          <template #default="{ row }">{{ formatDate(row.created_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('created_by')" prop="created_by" label="创建人" width="80" />
        <el-table-column v-if="show('updated_at')" label="更新时间" width="140">
          <template #default="{ row }">{{ formatDate(row.updated_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('updated_by')" prop="updated_by" label="更新人" width="80" />
        <el-table-column v-if="show('deleted_at')" label="删除时间" width="140">
          <template #default="{ row }">{{ row.deleted_at ? formatDate(row.deleted_at) : '-' }}</template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <template v-if="row.status === 'pending'">
              <el-button size="small" type="success" @click="handleStatus(row.id, 'approved')"><el-icon><Check /></el-icon> 通过</el-button>
              <el-button size="small" type="warning" @click="handleStatus(row.id, 'rejected')"><el-icon><Close /></el-icon> 拒绝</el-button>
            </template>
            <el-button size="small" type="danger" @click="handleDelete(row.id)"><el-icon><Delete /></el-icon> 删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrapper">
        <Pagination :total="total" :page-size="pageSize" :current-page="page" @page-change="handlePageChange" />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Check, Close, Delete, Setting } from '@element-plus/icons-vue'
import { getAdminComments, updateCommentStatus, deleteComment } from '../../api/comment'
import { ElMessage, ElMessageBox } from 'element-plus'
import Pagination from '../../components/Pagination.vue'

const comments = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

const allColumns = [
  { prop: 'id', label: 'ID' },
  { prop: 'nickname', label: '昵称' },
  { prop: 'email', label: '邮箱' },
  { prop: 'content', label: '内容' },
  { prop: 'post', label: '所属文章' },
  { prop: 'status', label: '状态' },
  { prop: 'created_at', label: '创建时间' },
  { prop: 'created_by', label: '创建人' },
  { prop: 'updated_at', label: '更新时间' },
  { prop: 'updated_by', label: '更新人' },
  { prop: 'deleted_at', label: '删除时间' },
]
const defaultVisible = ['nickname', 'email', 'content', 'post', 'status', 'created_at']
const visibleColumns = ref<string[]>(JSON.parse(localStorage.getItem('comment_columns') || 'null') || defaultVisible)

function show(prop: string) {
  return visibleColumns.value.includes(prop)
}
function saveColumns() {
  localStorage.setItem('comment_columns', JSON.stringify(visibleColumns.value))
}

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

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

function statusType(s: string) {
  return s === 'approved' ? 'success' : s === 'rejected' ? 'danger' : 'warning'
}

function statusLabel(s: string) {
  return s === 'approved' ? '已通过' : s === 'rejected' ? '已拒绝' : '待审核'
}

onMounted(fetchComments)
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
