<template>
  <div class="file-list">
    <el-card shadow="never">
      <div class="page-header">
        <h2>文件管理</h2>
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
            <div class="column-actions">
              <el-button size="small" @click="selectAll">{{ allSelected ? '取消全选' : '全选' }}</el-button>
              <el-button size="small" @click="resetColumns">重置</el-button>
            </div>
          </el-popover>
          <el-upload
            :action="uploadUrl"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            accept="image/*"
          >
            <el-button type="primary"><el-icon><Upload /></el-icon> 上传文件</el-button>
          </el-upload>
        </div>
      </div>
      <el-table :data="files" v-loading="loading">
        <el-table-column v-if="show('id')" prop="id" label="ID" width="60" />
        <el-table-column v-if="show('original_name')" prop="original_name" label="文件名" min-width="180" show-overflow-tooltip />
        <el-table-column v-if="show('url')" label="预览" width="80">
          <template #default="{ row }">
            <el-image :src="row.url" :preview-src-list="[row.url]" fit="cover" style="width: 40px; height: 40px" preview-teleported />
          </template>
        </el-table-column>
        <el-table-column v-if="show('size')" label="大小" width="100">
          <template #default="{ row }">{{ formatSize(row.size) }}</template>
        </el-table-column>
        <el-table-column v-if="show('ext')" prop="ext" label="类型" width="80" />
        <el-table-column v-if="show('created_at')" label="上传时间" width="140">
          <template #default="{ row }">{{ formatDate(row.created_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('created_by')" prop="created_by" label="上传人" width="80" />
        <el-table-column v-if="show('updated_at')" label="更新时间" width="140">
          <template #default="{ row }">{{ formatDate(row.updated_at) }}</template>
        </el-table-column>
        <el-table-column v-if="show('updated_by')" prop="updated_by" label="更新人" width="80" />
        <el-table-column v-if="show('deleted_by')" prop="deleted_by" label="删除人" width="80" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
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
import { ref, computed, onMounted } from 'vue'
import { Upload, Delete, Setting } from '@element-plus/icons-vue'
import { getAdminFiles, deleteFile } from '../../api/file'
import { ElMessage, ElMessageBox } from 'element-plus'
import Pagination from '../../components/Pagination.vue'

const files = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const pageSize = 10
const loading = ref(true)

const uploadUrl = '/api/admin/upload'
const uploadHeaders = { Authorization: `Bearer ${localStorage.getItem('token')}` }

const allColumns = [
  { prop: 'id', label: 'ID' },
  { prop: 'original_name', label: '文件名' },
  { prop: 'url', label: '预览' },
  { prop: 'size', label: '大小' },
  { prop: 'ext', label: '类型' },
  { prop: 'created_at', label: '上传时间' },
  { prop: 'created_by', label: '上传人' },
  { prop: 'updated_at', label: '更新时间' },
  { prop: 'updated_by', label: '更新人' },
  { prop: 'deleted_by', label: '删除人' },
]
const defaultVisible = allColumns.map(c => c.prop)
const visibleColumns = ref<string[]>(JSON.parse(localStorage.getItem('file_columns') || 'null') || defaultVisible)

function show(prop: string) {
  return visibleColumns.value.includes(prop)
}
function saveColumns() {
  localStorage.setItem('file_columns', JSON.stringify(visibleColumns.value))
}
const allSelected = computed(() => visibleColumns.value.length === allColumns.length)
function selectAll() {
  if (allSelected.value) {
    visibleColumns.value = []
  } else {
    visibleColumns.value = allColumns.map(c => c.prop)
  }
  saveColumns()
}
function resetColumns() {
  visibleColumns.value = [...defaultVisible]
  saveColumns()
}

async function fetchFiles() {
  loading.value = true
  try {
    const res: any = await getAdminFiles({ page: page.value, page_size: pageSize })
    files.value = res.data
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function handleUploadSuccess() {
  ElMessage.success('上传成功')
  fetchFiles()
}

function handleUploadError() {
  ElMessage.error('上传失败')
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除？', '提示')
  await deleteFile(id)
  ElMessage.success('已删除')
  fetchFiles()
}

function handlePageChange(p: number) {
  page.value = p
  fetchFiles()
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

function formatSize(bytes: number) {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}

onMounted(fetchFiles)
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
.column-actions {
  margin-top: 10px;
  display: flex;
  gap: 8px;
}
.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
