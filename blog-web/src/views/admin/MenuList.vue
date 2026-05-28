<template>
  <div class="menu-list">
    <el-card shadow="never" style="margin-bottom: 16px">
      <div class="quick-add">
        <span class="quick-add-label">快速添加:</span>
        <el-select v-model="selectedCategory" placeholder="选择分类..." filterable clearable style="width: 220px; margin-right: 8px">
          <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.slug" />
        </el-select>
        <el-button type="primary" :disabled="!selectedCategory" @click="addFromCategory">添加分类导航</el-button>
        <el-select v-model="selectedArticle" placeholder="选择文章..." filterable clearable style="width: 220px; margin-left: 16px; margin-right: 8px">
          <el-option v-for="post in articles" :key="post.id" :label="post.title" :value="post.slug" />
        </el-select>
        <el-button type="success" :disabled="!selectedArticle" @click="addFromArticle">添加文章导航</el-button>
      </div>
    </el-card>

    <el-card shadow="never">
      <div class="page-header">
        <h2>菜单管理</h2>
        <el-button type="primary" @click="showDialog()"><el-icon><Plus /></el-icon> 新建菜单</el-button>
      </div>
      <el-table :data="menus" v-loading="loading" row-key="id">
        <el-table-column prop="id" label="ID" width="60" />
        <el-table-column prop="name" label="名称" width="150" />
        <el-table-column label="图标" width="80">
          <template #default="{ row }">
            <el-icon v-if="row.icon" :size="18"><component :is="iconMap[row.icon]" /></el-icon>
            <span v-else style="color: #ccc">—</span>
          </template>
        </el-table-column>
        <el-table-column prop="path" label="路径" min-width="200" />
        <el-table-column prop="sort_order" label="排序" width="80" />
        <el-table-column label="显示" width="80">
          <template #default="{ row }">
            <el-tag :type="row.is_visible ? 'success' : 'info'" size="small">
              {{ row.is_visible ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="排序操作" width="160">
          <template #default="{ $index }">
            <el-button size="small" text type="primary" :disabled="$index === 0" @click="moveUp($index)">
              <el-icon><Top /></el-icon>
            </el-button>
            <el-button size="small" text type="primary" :disabled="$index === menus.length - 1" @click="moveDown($index)">
              <el-icon><Bottom /></el-icon>
            </el-button>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="showDialog(row)"><el-icon><Edit /></el-icon> 编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)"><el-icon><Delete /></el-icon> 删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑菜单' : '新建菜单'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="名称">
          <el-input v-model="form.name" placeholder="如：首页" />
        </el-form-item>
        <el-form-item label="图标">
          <el-select v-model="form.icon" placeholder="选择图标（可选）" clearable filterable>
            <el-option v-for="icon in iconOptions" :key="icon.name" :label="icon.label" :value="icon.name">
              <div style="display: flex; align-items: center; gap: 8px">
                <el-icon :size="16"><component :is="iconMap[icon.name]" /></el-icon>
                <span>{{ icon.label }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort_order" :min="0" />
        </el-form-item>
        <el-form-item label="路径">
          <el-input v-model="form.path" placeholder="如：/ 或 /about" />
        </el-form-item>
        <el-form-item label="是否显示">
          <el-switch v-model="form.is_visible" />
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
import {
  Plus, Edit, Delete, Top, Bottom,
  HomeFilled, Document, Collection, PriceTag, ChatDotRound,
  Link, Star, Setting, Menu, House, Notebook, Reading,
  Picture, User, Location, Phone, Message, Promotion, Calendar,
} from '@element-plus/icons-vue'

const iconMap: Record<string, any> = {
  HomeFilled, Document, Collection, PriceTag, ChatDotRound,
  Link, Star, Setting, Menu, House, Notebook, Reading,
  Edit, Picture, User, Location, Phone, Message, Promotion, Calendar,
}

const iconOptions = [
  { name: 'HomeFilled', label: '首页' },
  { name: 'Document', label: '文档' },
  { name: 'Collection', label: '合集' },
  { name: 'PriceTag', label: '标签' },
  { name: 'ChatDotRound', label: '评论' },
  { name: 'Link', label: '链接' },
  { name: 'Star', label: '收藏' },
  { name: 'Setting', label: '设置' },
  { name: 'Menu', label: '菜单' },
  { name: 'House', label: '房屋' },
  { name: 'Notebook', label: '笔记' },
  { name: 'Reading', label: '阅读' },
  { name: 'Edit', label: '编辑' },
  { name: 'Picture', label: '图片' },
  { name: 'User', label: '用户' },
  { name: 'Location', label: '位置' },
  { name: 'Phone', label: '电话' },
  { name: 'Message', label: '消息' },
  { name: 'Promotion', label: '推广' },
  { name: 'Calendar', label: '日历' },
]
import { getMenus, createMenu, updateMenu, deleteMenu, reorderMenus } from '../../api/menu'
import { getCategories } from '../../api/category'
import { getPosts } from '../../api/post'
import { useAppStore } from '../../stores/app'
import { ElMessage, ElMessageBox } from 'element-plus'

const appStore = useAppStore()

interface MenuItem {
  id: number
  name: string
  path: string
  icon: string
  sort_order: number
  is_visible: boolean
}

const menus = ref<MenuItem[]>([])
const loading = ref(true)
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const form = ref({ name: '', path: '', icon: '', sort_order: 0, is_visible: true })

const categories = ref<any[]>([])
const articles = ref<any[]>([])
const selectedCategory = ref('')
const selectedArticle = ref('')

async function fetchMenus() {
  loading.value = true
  try {
    const res: any = await getMenus()
    menus.value = res.data || []
  } finally {
    loading.value = false
  }
}

function showDialog(row?: MenuItem) {
  if (row) {
    editingId.value = row.id
    form.value = { name: row.name, path: row.path, icon: row.icon || '', sort_order: row.sort_order, is_visible: row.is_visible }
  } else {
    editingId.value = null
    form.value = { name: '', path: '', icon: '', sort_order: 0, is_visible: true }
  }
  dialogVisible.value = true
}

async function handleSave() {
  try {
    if (editingId.value) {
      await updateMenu(editingId.value, form.value)
    } else {
      await createMenu(form.value)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    fetchMenus()
    appStore.loadMenus()
  } catch {
    ElMessage.error('保存失败')
  }
}

async function handleDelete(id: number) {
  await ElMessageBox.confirm('确定删除该菜单？', '提示')
  await deleteMenu(id)
  ElMessage.success('已删除')
  fetchMenus()
  appStore.loadMenus()
}

async function moveUp(index: number) {
  const ids = menus.value.map(m => m.id)
  ;[ids[index - 1], ids[index]] = [ids[index], ids[index - 1]]
  await reorderMenus(ids)
  fetchMenus()
  appStore.loadMenus()
}

async function moveDown(index: number) {
  const ids = menus.value.map(m => m.id)
  ;[ids[index], ids[index + 1]] = [ids[index + 1], ids[index]]
  await reorderMenus(ids)
  fetchMenus()
  appStore.loadMenus()
}

async function fetchDropdownData() {
  const [catRes, postRes] = await Promise.all([
    getCategories(),
    getPosts({ page_size: 100 }),
  ])
  categories.value = catRes.data || []
  articles.value = postRes.data || []
}

async function addFromCategory() {
  const cat = categories.value.find((c: any) => c.slug === selectedCategory.value)
  if (!cat) return
  await createMenu({ name: cat.name, path: `/category/${cat.slug}`, is_visible: true })
  ElMessage.success('已添加分类导航')
  selectedCategory.value = ''
  fetchMenus()
  appStore.loadMenus()
}

async function addFromArticle() {
  const post = articles.value.find((p: any) => p.slug === selectedArticle.value)
  if (!post) return
  await createMenu({ name: post.title, path: `/post/${post.slug}`, is_visible: true })
  ElMessage.success('已添加文章导航')
  selectedArticle.value = ''
  fetchMenus()
  appStore.loadMenus()
}

onMounted(() => {
  fetchMenus()
  fetchDropdownData()
})
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
.quick-add {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
}
.quick-add-label {
  margin-right: 8px;
  font-weight: bold;
  white-space: nowrap;
}
</style>
