<template>
  <el-container class="admin-layout">
    <el-aside width="200px">
      <div class="admin-logo">管理后台</div>
      <el-menu :default-active="route.path" router>
        <el-menu-item index="/admin">
          <span>仪表盘</span>
        </el-menu-item>
        <el-menu-item index="/admin/posts">
          <span>文章管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/categories">
          <span>分类管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/tags">
          <span>标签管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/comments">
          <span>评论管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/config">
          <span>站点配置</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-right">
          <router-link to="/">查看博客</router-link>
          <el-button type="text" @click="handleLogout">退出登录</el-button>
        </div>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'

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
}
.header-right {
  display: flex;
  gap: 1rem;
  align-items: center;
}
</style>
