<template>
  <div class="tag-list">
    <el-card shadow="never">
      <div class="page-header">
        <h2>标签管理</h2>
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
          <el-button type="primary" @click="showDialog()"><el-icon><Plus /></el-icon> 新建标签</el-button>
        </div>
      </div>
      <el-table :data="tags" v-loading="loading">
        <el-table-column v-if="show('id')" prop="id" label="ID" width="60" />
        <el-table-column v-if="show('name')" prop="name" label="名称" width="150" />
        <el-table-column v-if="show('slug')" prop="slug" label="别名" width="150" />
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
        <el-table-column v-if="show('deleted_by')" prop="deleted_by" label="删除人" width="80" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="showDialog(row)"><el-icon><Edit /></el-icon> 编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)"><el-icon><Delete /></el-icon> 删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑标签' : '新建标签'" width="500px">
      <el-form :model="form" label-width="60px">
        <el-form-item label="名称">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="别名">
          <el-input v-model="form.slug" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { Plus, Edit, Delete, Setting } from '@element-plus/icons-vue'
import { getTags, createTag, updateTag, deleteTag } from '../../api/tag'
import { ElMessage, ElMessageBox } from 'element-plus'
import { slugify } from 'transliteration'

const tags = ref<any[]>([])
const loading = ref(true)
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const form = ref({ name: '', slug: '' })

watch(() => form.value.name, (val) => {
  if (!form.value.slug) {
    form.value.slug = slugify(val)
  }
})

const allColumns = [
  { prop: 'id', label: 'ID' },
  { prop: 'name', label: '名称' },
  { prop: 'slug', label: '别名' },
  { prop: 'created_at', label: '创建时间' },
  { prop: 'created_by', label: '创建人' },
  { prop: 'updated_at', label: '更新时间' },
  { prop: 'updated_by', label: '更新人' },
  { prop: 'deleted_at', label: '删除时间' },
  { prop: 'deleted_by', label: '删除人' },
]
const defaultVisible = allColumns.map(c => c.prop)
const visibleColumns = ref<string[]>(JSON.parse(localStorage.getItem('tag_columns') || 'null') || defaultVisible)

function show(prop: string) {
  return visibleColumns.value.includes(prop)
}
function saveColumns() {
  localStorage.setItem('tag_columns', JSON.stringify(visibleColumns.value))
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

async function fetchTags() {
  loading.value = true
  try {
    const res: any = await getTags()
    tags.value = res.data
  } finally {
    loading.value = false
  }
}

function showDialog(row?: any) {
  if (row) {
    editingId.value = row.id
    form.value = { name: row.name, slug: row.slug }
  } else {
    editingId.value = null
    form.value = { name: '', slug: '' }
  }
  dialogVisible.value = true
}

async function handleSave() {
  if (!form.value.slug) {
    form.value.slug = slugify(form.value.name)
  }
  try {
    if (editingId.value) {
      await updateTag(editingId.value, form.value)
    } else {
      await createTag(form.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    fetchTags()
  } catch (e) {
    console.error(e)
    ElMessage.error('保存失败')
  }
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除？', '提示')
  await deleteTag(id)
  ElMessage.success('已删除')
  fetchTags()
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

onMounted(fetchTags)
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
</style>
