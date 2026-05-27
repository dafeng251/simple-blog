<template>
  <div class="dashboard">
    <!-- Welcome banner -->
    <div class="welcome-banner">
      <div class="welcome-text">
        <h2>欢迎回来</h2>
        <p>今天是个写文章的好日子</p>
      </div>
      <div class="quick-actions">
        <el-button type="primary" @click="$router.push('/admin/posts/edit')">
          <el-icon><EditPen /></el-icon> 写文章
        </el-button>
        <el-button @click="$router.push('/admin/posts')">
          <el-icon><Document /></el-icon> 文章列表
        </el-button>
        <el-button @click="$router.push('/admin/comments')">
          <el-icon><ChatDotRound /></el-icon> 评论管理
        </el-button>
      </div>
    </div>

    <!-- Stat cards -->
    <el-row :gutter="20" class="stat-row">
      <el-col :span="8">
        <div class="stat-card stat-posts">
          <div class="stat-icon"><el-icon :size="40"><Document /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.posts }}</div>
            <div class="stat-label">文章</div>
          </div>
        </div>
      </el-col>
      <el-col :span="8">
        <div class="stat-card stat-comments">
          <div class="stat-icon"><el-icon :size="40"><ChatDotRound /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.comments }}</div>
            <div class="stat-label">评论</div>
          </div>
        </div>
      </el-col>
      <el-col :span="8">
        <div class="stat-card stat-categories">
          <div class="stat-icon"><el-icon :size="40"><FolderOpened /></el-icon></div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.categories }}</div>
            <div class="stat-label">分类</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Recent data -->
    <el-row :gutter="20" class="detail-row">
      <el-col :span="16">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span><el-icon><Document /></el-icon> 最近文章</span>
              <el-button type="text" @click="$router.push('/admin/posts')">查看全部</el-button>
            </div>
          </template>
          <el-table :data="recentPosts" size="small" :show-header="false">
            <el-table-column prop="title" />
            <el-table-column prop="status" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 'published' ? 'success' : 'info'" size="small">
                  {{ row.status === 'published' ? '已发布' : '草稿' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="created_at" width="120">
              <template #default="{ row }">{{ formatDate(row.created_at) }}</template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span><el-icon><ChatDotRound /></el-icon> 最近评论</span>
              <el-button type="text" @click="$router.push('/admin/comments')">查看全部</el-button>
            </div>
          </template>
          <div v-for="comment in recentComments" :key="comment.id" class="comment-item">
            <div class="comment-meta">
              <span class="comment-author">{{ comment.nickname }}</span>
              <el-tag :type="statusType(comment.status)" size="small">{{ statusLabel(comment.status) }}</el-tag>
            </div>
            <p class="comment-text">{{ comment.content }}</p>
          </div>
          <el-empty v-if="recentComments.length === 0" description="暂无评论" :image-size="60" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Document, ChatDotRound, FolderOpened, EditPen } from '@element-plus/icons-vue'
import { getAdminPosts } from '../../api/post'
import { getAdminComments } from '../../api/comment'
import { getCategories } from '../../api/category'

const stats = ref({ posts: 0, comments: 0, categories: 0 })
const recentPosts = ref<any[]>([])
const recentComments = ref<any[]>([])

onMounted(async () => {
  try {
    const [postRes, commentRes, categoryRes]: any[] = await Promise.all([
      getAdminPosts({ page: 1, page_size: 5 }),
      getAdminComments({ page: 1, page_size: 5 }),
      getCategories(),
    ])
    stats.value.posts = postRes.total || 0
    stats.value.comments = commentRes.total || 0
    stats.value.categories = categoryRes.data?.length || 0
    recentPosts.value = postRes.data || []
    recentComments.value = commentRes.data || []
  } catch {
    // ignore
  }
})

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

function statusType(s: string) {
  return s === 'approved' ? 'success' : s === 'rejected' ? 'danger' : 'warning'
}

function statusLabel(s: string) {
  return s === 'approved' ? '已通过' : s === 'rejected' ? '已拒绝' : '待审核'
}
</script>

<style scoped>
.dashboard {
  padding: 4px;
}

.welcome-banner {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  border-radius: 12px;
  padding: 28px 32px;
  color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.welcome-text h2 {
  font-size: 1.5rem;
  margin-bottom: 4px;
}
.welcome-text p {
  opacity: 0.85;
  font-size: 0.95rem;
}
.quick-actions .el-button {
  background: rgba(255,255,255,0.2);
  border-color: transparent;
  color: #fff;
}
.quick-actions .el-button:hover {
  background: rgba(255,255,255,0.35);
}

.stat-row {
  margin-bottom: 24px;
}
.stat-card {
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  color: #fff;
}
.stat-icon {
  opacity: 0.85;
}
.stat-value {
  font-size: 2rem;
  font-weight: bold;
  line-height: 1;
}
.stat-label {
  font-size: 0.85rem;
  opacity: 0.85;
  margin-top: 4px;
}
.stat-posts {
  background: linear-gradient(135deg, #409eff, #79bbff);
}
.stat-comments {
  background: linear-gradient(135deg, #67c23a, #95d475);
}
.stat-categories {
  background: linear-gradient(135deg, #e6a23c, #f0c78a);
}

.detail-row {
  margin-bottom: 24px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.comment-item {
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}
.comment-item:last-child {
  border-bottom: none;
}
.comment-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}
.comment-author {
  font-weight: 500;
  font-size: 0.9rem;
}
.comment-text {
  color: #666;
  font-size: 0.85rem;
  margin: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
