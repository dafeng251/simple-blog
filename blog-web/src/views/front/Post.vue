<template>
  <div class="post-detail" v-loading="loading">
    <article v-if="post">
      <h1>{{ post.title }}</h1>
      <div class="meta">
        <span>发布于 {{ formatDate(post.published_at || post.created_at) }}</span>
        <span v-if="post.category">分类: {{ post.category.name }}</span>
        <el-tag v-for="tag in post.tags" :key="tag.id" size="small">{{ tag.name }}</el-tag>
      </div>
      <MarkdownRender :content="post.content" />

      <section class="comments">
        <h3>评论</h3>
        <el-form @submit.prevent="submitComment">
          <el-form-item>
            <el-input v-model="commentForm.nickname" placeholder="昵称" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="commentForm.email" placeholder="邮箱（可选）" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="commentForm.content" type="textarea" :rows="3" placeholder="写下你的评论..." />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitComment">提交评论</el-button>
          </el-form-item>
        </el-form>

        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <strong>{{ comment.nickname }}</strong>
          <span class="time">{{ formatDate(comment.created_at) }}</span>
          <p>{{ comment.content }}</p>
        </div>
      </section>
    </article>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getPostBySlug } from '../../api/post'
import { getCommentsByPost, createComment } from '../../api/comment'
import { ElMessage } from 'element-plus'
import MarkdownRender from '../../components/MarkdownRender.vue'

const route = useRoute()
const post = ref<any>(null)
const comments = ref<any[]>([])
const loading = ref(true)
const commentForm = ref({ nickname: '', email: '', content: '' })

async function fetchPost() {
  loading.value = true
  try {
    const res: any = await getPostBySlug(route.params.slug as string)
    post.value = res.data
    if (post.value) {
      const commentRes: any = await getCommentsByPost(post.value.id)
      comments.value = commentRes.data
    }
  } finally {
    loading.value = false
  }
}

async function submitComment() {
  if (!commentForm.value.nickname || !commentForm.value.content) {
    ElMessage.warning('请填写昵称和评论内容')
    return
  }
  try {
    await createComment({
      post_id: post.value.id,
      nickname: commentForm.value.nickname,
      email: commentForm.value.email,
      content: commentForm.value.content,
    })
    ElMessage.success('评论已提交，等待审核')
    commentForm.value = { nickname: '', email: '', content: '' }
  } catch {
    ElMessage.error('提交失败')
  }
}

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

onMounted(fetchPost)
</script>

<style scoped>
.meta {
  display: flex;
  gap: 1rem;
  align-items: center;
  color: #999;
  margin-bottom: 2rem;
}
.comments {
  margin-top: 3rem;
  border-top: 1px solid #eee;
  padding-top: 2rem;
}
.comment-item {
  padding: 1rem 0;
  border-bottom: 1px solid #f0f0f0;
}
.comment-item .time {
  color: #999;
  margin-left: 0.5rem;
  font-size: 0.85rem;
}
</style>
