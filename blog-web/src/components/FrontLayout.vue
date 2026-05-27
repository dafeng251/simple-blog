<template>
  <div class="front-layout">
    <header class="front-header">
      <router-link to="/" class="logo">
        <img v-if="store.siteLogo" :src="store.siteLogo" class="logo-img" />
        <el-icon v-else><Edit /></el-icon>
        {{ store.siteTitle || '极简博客' }}
      </router-link>
      <nav>
        <router-link to="/"><el-icon><House /></el-icon> 首页</router-link>
        <router-link to="/about"><el-icon><InfoFilled /></el-icon> 关于</router-link>
        <router-link to="/admin"><el-icon><Setting /></el-icon> 管理</router-link>
      </nav>
    </header>
    <main class="front-main">
      <router-view />
    </main>
    <footer class="front-footer">
      <p v-if="store.copyright">{{ store.copyright }}</p>
      <p v-else>&copy; {{ new Date().getFullYear() }} {{ store.siteTitle || '极简博客' }}</p>
      <p v-if="store.icpNumber" class="icp">{{ store.icpNumber }}</p>
      <div v-if="store.socialLinks.length" class="social-links">
        <a v-for="link in store.socialLinks" :key="link.label" :href="link.url" target="_blank">{{ link.label }}</a>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { Edit, House, InfoFilled, Setting } from '@element-plus/icons-vue'
import { useAppStore } from '../stores/app'

const store = useAppStore()

onMounted(() => {
  store.loadConfig()
})
</script>

<style scoped>
.front-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.front-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  border-bottom: 1px solid #eee;
}
.front-header .logo {
  font-size: 1.5rem;
  font-weight: bold;
  text-decoration: none;
  color: #333;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.logo-img {
  height: 32px;
}
.front-header nav a {
  margin-left: 1.5rem;
  text-decoration: none;
  color: #666;
}
.front-header nav a:hover {
  color: #409eff;
}
.front-main {
  flex: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  width: 100%;
  box-sizing: border-box;
}
.front-footer {
  text-align: center;
  padding: 1rem;
  border-top: 1px solid #eee;
  color: #999;
}
.front-footer p {
  margin: 4px 0;
}
.icp {
  font-size: 0.85rem;
}
.social-links {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 8px;
}
.social-links a {
  color: #666;
  text-decoration: none;
  font-size: 0.9rem;
}
.social-links a:hover {
  color: #409eff;
}
</style>
