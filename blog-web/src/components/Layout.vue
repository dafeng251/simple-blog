<template>
  <el-container class="admin-layout">
    <el-aside width="220px">
      <div class="admin-logo">极简博客</div>
      <el-menu :default-active="route.path" router>
        <el-menu-item index="/admin">
          <el-icon><DataBoard /></el-icon>
          <span>仪表盘</span>
        </el-menu-item>
        <el-menu-item index="/admin/posts">
          <el-icon><Document /></el-icon>
          <span>文章管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/categories">
          <el-icon><FolderOpened /></el-icon>
          <span>分类管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/tags">
          <el-icon><CollectionTag /></el-icon>
          <span>标签管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/comments">
          <el-icon><ChatDotRound /></el-icon>
          <span>评论管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/config">
          <el-icon><Setting /></el-icon>
          <span>站点配置</span>
        </el-menu-item>
        <el-menu-item index="/admin/files">
          <el-icon><Folder /></el-icon>
          <span>文件管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-right">
          <router-link to="/"><el-icon><View /></el-icon> 查看博客</router-link>
          <el-button type="text" @click="handleLogout"><el-icon><SwitchButton /></el-icon> 退出登录</el-button>
        </div>
      </el-header>
      <el-main>
        <div class="page-container">
          <router-view />
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { DataBoard, Document, FolderOpened, CollectionTag, ChatDotRound, Setting, View, SwitchButton, Folder } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

function handleLogout() {
  localStorage.removeItem('token')
  router.push('/admin/login')
}
</script>

<style scoped>
.admin-layout {
  height: 100vh;
}
.admin-logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  font-weight: bold;
  border-bottom: 1px solid #dcdfe6;
}
.el-header {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  border-bottom: 1px solid #dcdfe6;
  padding: 0 24px;
  height: 60px;
}
.header-right {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}
.el-main {
  padding: 0;
  background: #f5f7fa;
}
.page-container {
  padding: 28px 32px;
}
</style>
