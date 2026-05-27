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
            <el-form-item label="Slug">
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
              <el-select v-model="form.tag_ids" multiple placeholder="选择标签" style="width: 100%">
                <el-option v-for="tag in tags" :key="tag.id" :label="tag.name" :value="tag.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="封面图">
              <el-input v-model="form.cover_image" placeholder="图片URL" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="摘要">
          <el-input v-model="form.summary" type="textarea" :rows="3" placeholder="文章摘要，用于列表页展示" />
        </el-form-item>
        <el-form-item label="内容">
          <MdEditor v-model="form.content" style="height: 480px; width: 100%" />
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
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getPostBySlug, createPost, updatePost } from '../../api/post'
import { getCategories } from '../../api/category'
import { getTags } from '../../api/tag'
import { ElMessage } from 'element-plus'
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
  tag_ids: [] as number[],
})

const categories = ref<any[]>([])
const tags = ref<any[]>([])

async function fetchData() {
  const [catRes, tagRes]: any[] = await Promise.all([getCategories(), getTags()])
  categories.value = catRes.data
  tags.value = tagRes.data

  if (isEdit.value) {
    const res: any = await getPostBySlug(route.params.id as string)
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
  try {
    if (isEdit.value) {
      await updatePost(Number(route.params.id), form.value)
      ElMessage.success('更新成功')
    } else {
      await createPost(form.value)
      ElMessage.success('创建成功')
    }
    router.push('/admin/posts')
  } catch {
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
</style>
