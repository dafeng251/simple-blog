<template>
  <div class="category-list">
    <el-card shadow="never">
      <div class="page-header">
        <h2>分类管理</h2>
        <el-button type="primary" @click="showDialog()"><el-icon><Plus /></el-icon> 新建分类</el-button>
      </div>
      <el-table :data="categories" v-loading="loading">
        <el-table-column prop="name" label="名称" />
        <el-table-column prop="slug" label="别名" />
        <el-table-column prop="description" label="描述" show-overflow-tooltip />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="showDialog(row)"><el-icon><Edit /></el-icon> 编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)"><el-icon><Delete /></el-icon> 删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑分类' : '新建分类'" width="500px">
      <el-form :model="form" label-width="60px">
        <el-form-item label="名称">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="别名">
          <el-input v-model="form.slug" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
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
import { ref, onMounted } from 'vue'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { getCategories, createCategory, updateCategory, deleteCategory } from '../../api/category'
import { ElMessage, ElMessageBox } from 'element-plus'

const categories = ref<any[]>([])
const loading = ref(true)
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const form = ref({ name: '', slug: '', description: '' })

async function fetchCategories() {
  loading.value = true
  try {
    const res: any = await getCategories()
    categories.value = res.data
  } finally {
    loading.value = false
  }
}

function showDialog(row?: any) {
  if (row) {
    editingId.value = row.id
    form.value = { name: row.name, slug: row.slug, description: row.description }
  } else {
    editingId.value = null
    form.value = { name: '', slug: '', description: '' }
  }
  dialogVisible.value = true
}

async function handleSave() {
  try {
    if (editingId.value) {
      await updateCategory(editingId.value, form.value)
    } else {
      await createCategory(form.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    fetchCategories()
  } catch {
    ElMessage.error('保存失败')
  }
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除？', '提示')
  await deleteCategory(id)
  ElMessage.success('已删除')
  fetchCategories()
}

onMounted(fetchCategories)
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
</style>
