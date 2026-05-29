<template>
  <div class="post-edit">
    <el-card shadow="never">
      <div class="page-header">
        <h2>{{ isEdit ? '编辑文章' : '新建文章' }}</h2>
      </div>
      <el-form :model="form" label-width="80px">
        <el-row :gutter="20">
          <el-col :span="16">
            <el-form-item label="标题">
              <el-input v-model="form.title" placeholder="请输入文章标题" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="别名">
              <el-input v-model="form.slug" placeholder="url-slug" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="分类">
              <el-select v-model="form.category_id" placeholder="选择分类" style="width: 100%">
                <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="标签">
              <el-select
                v-model="form.tag_ids"
                multiple
                filterable
                :filter-method="filterTags"
                placeholder="选择或搜索标签"
                style="width: 100%"
                @change="handleTagChange"
                @visible-change="onDropdownVisible"
              >
                <el-option
                  v-for="tag in filteredTagOptions"
                  :key="tag.id"
                  :label="tag.name"
                  :value="tag.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="封面图">
              <div class="cover-upload">
                <el-image v-if="form.cover_image" :src="form.cover_image" fit="cover" style="width: 80px; height: 80px; margin-right: 12px; border-radius: 4px" />
                <el-upload
                  :action="uploadUrl"
                  :headers="uploadHeaders"
                  :show-file-list="false"
                  :on-success="(res: any) => { form.cover_image = res.data.url }"
                  accept="image/*"
                >
                  <el-button size="small">上传</el-button>
                </el-upload>
                <el-button v-if="form.cover_image" size="small" type="danger" @click="form.cover_image = ''" style="margin-left: 8px">移除</el-button>
              </div>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="摘要">
          <el-input v-model="form.summary" type="textarea" :rows="3" placeholder="文章摘要，用于列表页展示" />
        </el-form-item>
        <el-form-item label="内容">
          <MdEditor v-model="form.content" style="height: 480px; width: 100%" :on-upload-img="handleEditorUploadImg" />
        </el-form-item>
        <el-form-item>
          <el-button @click="handleSave('draft')">保存草稿</el-button>
          <el-button type="primary" @click="handleSave('published')">发布</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getPostById, createPost, updatePost } from '../../api/post'
import { getCategories } from '../../api/category'
import { getTags, createTag } from '../../api/tag'
import { uploadFile } from '../../api/upload'
import { ElMessage } from 'element-plus'
import { slugify } from 'transliteration'
import { MdEditor } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'

const route = useRoute()
const router = useRouter()
const isEdit = computed(() => !!route.params.id)

const form = ref({
  title: '',
  slug: '',
  content: '',
  summary: '',
  cover_image: '',
  status: 'draft',
  category_id: null as number | null,
  tag_ids: [] as (number | string)[],
})

const categories = ref<any[]>([])
const tags = ref<any[]>([])
const tagSearchQuery = ref('')

const filteredTagOptions = computed(() => {
  const q = tagSearchQuery.value.trim().toLowerCase()
  const existing = tags.value.filter(t => !q || t.name.toLowerCase().includes(q))
  if (q && !tags.value.some(t => t.name.toLowerCase() === q)) {
    return [...existing, { id: `__create__${tagSearchQuery.value.trim()}`, name: `+ 创建 "${tagSearchQuery.value.trim()}"` }]
  }
  return existing
})

function filterTags(query: string) {
  tagSearchQuery.value = query
}

function onDropdownVisible(visible: boolean) {
  if (!visible) {
    tagSearchQuery.value = ''
  }
}

async function handleTagChange(values: (number | string)[]) {
  const result: number[] = []
  for (const val of values) {
    if (typeof val === 'string' && val.startsWith('__create__')) {
      const name = val.replace('__create__', '')
      const existing = tags.value.find(t => t.name.toLowerCase() === name.toLowerCase())
      if (existing) {
        if (!result.includes(existing.id)) result.push(existing.id)
      } else {
        try {
          const res: any = await createTag({ name, slug: slugify(name) })
          const newTag = res.data
          tags.value.push(newTag)
          result.push(newTag.id)
          ElMessage.success(`标签"${name}"已创建`)
        } catch {
          ElMessage.error(`创建标签"${name}"失败`)
        }
      }
    } else {
      result.push(val as number)
    }
  }
  form.value.tag_ids = result
}

watch(() => form.value.title, (val) => {
  if (val && !form.value.slug) {
    form.value.slug = slugify(val)
  }
})

const uploadUrl = '/api/admin/upload'
const uploadHeaders = { Authorization: `Bearer ${localStorage.getItem('token')}` }

async function handleEditorUploadImg(files: File[], callback: (urls: string[]) => void) {
  const urls: string[] = []
  for (const file of files) {
    try {
      const res: any = await uploadFile(file)
      urls.push(res.data.url)
    } catch {
      ElMessage.error('图片上传失败')
    }
  }
  callback(urls)
}

async function fetchData() {
  const [catRes, tagRes]: any[] = await Promise.all([getCategories(), getTags()])
  categories.value = catRes.data
  tags.value = tagRes.data

  if (isEdit.value) {
    const res: any = await getPostById(Number(route.params.id))
    const post = res.data
    form.value = {
      title: post.title,
      slug: post.slug,
      content: post.content,
      summary: post.summary,
      cover_image: post.cover_image,
      status: post.status,
      category_id: post.category_id,
      tag_ids: post.tags?.map((t: any) => t.id) || [],
    }
  }
}

async function handleSave(status: string) {
  form.value.status = status
  if (!form.value.slug) {
    form.value.slug = slugify(form.value.title)
  }
  try {
    // 确保所有标签都已创建
    const resolvedTagIds: number[] = []
    for (const val of form.value.tag_ids) {
      if (typeof val === 'string' && val.startsWith('__create__')) {
        const name = val.replace('__create__', '')
        const existing = tags.value.find(t => t.name.toLowerCase() === name.toLowerCase())
        if (existing) {
          resolvedTagIds.push(existing.id)
        } else {
          const res: any = await createTag({ name, slug: slugify(name) })
          const newTag = res.data
          tags.value.push(newTag)
          resolvedTagIds.push(newTag.id)
        }
      } else if (typeof val === 'number') {
        resolvedTagIds.push(val)
      }
    }
    form.value.tag_ids = resolvedTagIds

    if (isEdit.value) {
      await updatePost(Number(route.params.id), form.value)
      ElMessage.success('更新成功')
    } else {
      await createPost(form.value)
      ElMessage.success('创建成功')
    }
    router.push('/admin/posts')
  } catch (e) {
    console.error(e)
    ElMessage.error('保存失败')
  }
}

onMounted(fetchData)
</script>

<style scoped>
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
.cover-upload {
  display: flex;
  align-items: center;
}
</style>
