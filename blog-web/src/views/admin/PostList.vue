<template>
  <div class="post-list">
    <el-card shadow="never">
      <div class="page-header">
        <h2>文章管理</h2>
        <div class="page-actions">
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
          <el-button type="primary" @click="$router.push('/admin/posts/edit')">
            <el-icon><Plus /></el-icon> 新建文章
          </el-button>
        </div>
      </div>
      <el-table :data="posts" v-loading="loading">
        <el-table-column v-if="show('id')" prop="id" label="ID" width="60" />
        <el-table-column v-if="show('title')" prop="title" label="标题" min-width="180" show-overflow-tooltip />
        <el-table-column v-if="show('slug')" prop="slug" label="别名" width="150" show-overflow-tooltip />
        <el-table-column v-if="show('status')" prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === 'published' ? 'success' : 'info'" size="small">
              {{ row.status === 'published' ? '已发布' : '草稿' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column v-if="show('category')" prop="category.name" label="分类" width="100" show-overflow-tooltip />
        <el-table-column v-if="show('tags')" label="标签" width="150">
          <template #default="{ row }">
            <el-tag v-for="tag in row.tags" :key="tag.id" size="small" style="margin: 2px">{{ tag.name }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column v-if="show('author')" prop="author.username" label="作者" width="90" />
        <el-table-column v-if="show('published_at')" label="发布时间" width="120">
          <template #default="{ row }">{{ row.published_at ? formatDate(row.published_at) : '-' }}</template>
        </el-table-column>
        <el-table-column v-if="show('created_at')" label="创建时间" width="120">
          <template #default="{ row }">{{ formatDate(row.created_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('created_by')" prop="created_by" label="创建人" width="80" />
        <el-table-column v-if="show('updated_at')" label="更新时间" width="120">
          <template #default="{ row }">{{ formatDate(row.updated_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('updated_by')" prop="updated_by" label="更新人" width="80" />
        <el-table-column v-if="show('deleted_at')" label="删除时间" width="120">
          <template #default="{ row }">{{ row.deleted_at ? formatDate(row.deleted_at) : '-' }}</template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
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
      <div class="pagination-wrapper">
        <Pagination :total="total" :page-size="pageSize" :current-page="page" @page-change="handlePageChange" />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Plus, Edit, Delete, Setting } from '@element-plus/icons-vue'
import { getAdminPosts, deletePost } from '../../api/post'
import { ElMessage, ElMessageBox } from 'element-plus'
import Pagination from '../../components/Pagination.vue'

const posts = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

const allColumns = [
  { prop: 'id', label: 'ID' },
  { prop: 'title', label: '标题' },
  { prop: 'slug', label: '别名' },
  { prop: 'status', label: '状态' },
  { prop: 'category', label: '分类' },
  { prop: 'tags', label: '标签' },
  { prop: 'author', label: '作者' },
  { prop: 'published_at', label: '发布时间' },
  { prop: 'created_at', label: '创建时间' },
  { prop: 'created_by', label: '创建人' },
  { prop: 'updated_at', label: '更新时间' },
  { prop: 'updated_by', label: '更新人' },
  { prop: 'deleted_at', label: '删除时间' },
]
const defaultVisible = ['title', 'status', 'category', 'tags', 'author', 'created_at']
const visibleColumns = ref<string[]>(JSON.parse(localStorage.getItem('post_columns') || 'null') || defaultVisible)

function show(prop: string) {
  return visibleColumns.value.includes(prop)
}
function saveColumns() {
  localStorage.setItem('post_columns', JSON.stringify(visibleColumns.value))
}

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
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
.page-actions {
  display: flex;
  gap: 10px;
}
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
