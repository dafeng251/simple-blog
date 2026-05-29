<template>
  <div class="post-detail" v-loading="loading">
    <article v-if="post" class="article-wrap">
      <!-- Article header -->
      <header class="article-header">
        <h1 class="article-title">{{ post.title }}</h1>
        <div class="article-meta">
          <span class="meta-item">
            <el-icon><Calendar /></el-icon>
            {{ formatDate(post.published_at || post.created_at) }}
          </span>
          <span v-if="post.category" class="meta-item">
            <el-icon><FolderOpened /></el-icon>
            {{ post.category.name }}
          </span>
        </div>
        <div v-if="post.tags?.length" class="article-tags">
          <span v-for="tag in post.tags" :key="tag.id" class="tag-item">{{ tag.name }}</span>
        </div>
      </header>

      <!-- Cover image -->
      <div v-if="post.cover_image" class="article-cover">
        <el-image :src="post.cover_image" fit="cover" class="cover-img" />
      </div>

      <!-- Article content -->
      <div class="article-content">
        <MarkdownRender :content="post.content" />
      </div>

      <!-- Comments section -->
      <section class="comment-section">
        <h3 class="section-title">
          <el-icon><ChatDotRound /></el-icon>
          评论 ({{ comments.length }})
        </h3>

        <!-- Comment form -->
        <div class="comment-form">
          <div class="form-row">
            <el-input v-model="commentForm.nickname" placeholder="昵称" size="large" />
            <el-input v-model="commentForm.email" placeholder="邮箱（可选）" size="large" />
          </div>
          <el-input
            v-model="commentForm.content"
            type="textarea"
            :rows="4"
            placeholder="写下你的评论..."
            size="large"
          />
          <div class="form-actions">
            <el-button type="primary" size="large" @click="submitComment" :disabled="!commentForm.nickname || !commentForm.content">
              提交评论
            </el-button>
          </div>
        </div>

        <!-- Comment list -->
        <div class="comment-list">
          <div v-for="comment in comments" :key="comment.id" class="comment-item">
            <div class="comment-avatar">{{ (comment.nickname || '匿')[0].toUpperCase() }}</div>
            <div class="comment-body">
              <div class="comment-header">
                <span class="comment-author">{{ comment.nickname }}</span>
                <span class="comment-time">{{ formatDate(comment.created_at) }}</span>
              </div>
              <p class="comment-content">{{ comment.content }}</p>
            </div>
          </div>
          <el-empty v-if="comments.length === 0" description="暂无评论，来抢沙发吧" :image-size="80" />
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
import { Calendar, FolderOpened, ChatDotRound } from '@element-plus/icons-vue'
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
  return new Date(dateStr).toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
}

onMounted(fetchPost)
</script>

<style scoped>
.post-detail {
  max-width: 800px;
  margin: 0 auto;
}

.article-header {
  text-align: center;
  margin-bottom: 2rem;
}

.article-title {
  font-size: 2rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 1rem;
  line-height: 1.3;
}

.article-meta {
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  color: #888;
  font-size: 0.9rem;
  margin-bottom: 0.75rem;
}
.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}
.meta-item .el-icon {
  vertical-align: -1px;
}

.article-tags {
  display: flex;
  justify-content: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}
.tag-item {
  font-size: 0.8rem;
  color: #409eff;
  background: #ecf5ff;
  padding: 3px 12px;
  border-radius: 12px;
}

.article-cover {
  margin-bottom: 2rem;
  border-radius: 12px;
  overflow: hidden;
}
.cover-img {
  width: 100%;
  height: 360px;
  display: block;
}

.article-content {
  background: #fff;
  border-radius: 12px;
  padding: 2rem 2.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  line-height: 1.8;
  font-size: 1rem;
  color: #333;
}

/* Comment section */
.comment-section {
  margin-top: 3rem;
}
.section-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 1.3rem;
  font-weight: 600;
  color: #1a1a2e;
  margin-bottom: 1.5rem;
}

.comment-form {
  background: #fff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  margin-bottom: 2rem;
}
.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}
.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 1rem;
}

.comment-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.comment-item {
  display: flex;
  gap: 1rem;
  background: #fff;
  border-radius: 12px;
  padding: 1.25rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.comment-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409eff, #66b1ff);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 1rem;
  flex-shrink: 0;
}

.comment-body {
  flex: 1;
  min-width: 0;
}
.comment-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.4rem;
}
.comment-author {
  font-weight: 600;
  color: #1a1a2e;
  font-size: 0.95rem;
}
.comment-time {
  color: #bbb;
  font-size: 0.8rem;
}
.comment-content {
  color: #555;
  font-size: 0.9rem;
  line-height: 1.6;
  margin: 0;
}

@media (max-width: 768px) {
  .article-title {
    font-size: 1.5rem;
  }
  .article-content {
    padding: 1.25rem;
  }
  .form-row {
    grid-template-columns: 1fr;
  }
  .article-cover .cover-img {
    height: 200px;
  }
}
</style>
