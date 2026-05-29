<template>
  <div class="front-layout">
    <header class="front-header">
      <router-link to="/" class="logo">
        <img v-if="store.siteLogo" :src="store.siteLogo" class="logo-img" />
        <el-icon v-else><Edit /></el-icon>
        {{ store.siteTitle || '极简博客' }}
      </router-link>
      <nav class="main-nav">
        <router-link v-for="item in store.menuItems" :key="item.id" :to="item.path">
          <el-icon v-if="item.icon"><component :is="iconMap[item.icon]" /></el-icon>{{ item.name }}
        </router-link>
        <router-link to="/admin"><el-icon><Setting /></el-icon> 后台管理</router-link>
      </nav>
    </header>
    <main class="front-main">
      <router-view />
    </main>
    <footer class="front-footer">
      <div class="footer-content">
        <div class="footer-col footer-about">
          <div class="footer-brand">
            <img v-if="store.siteLogo" :src="store.siteLogo" class="footer-logo" />
            <span class="footer-title">{{ store.siteTitle || '极简博客' }}</span>
          </div>
          <p v-if="store.siteDescription" class="footer-desc">{{ store.siteDescription }}</p>
        </div>
        <div class="footer-col footer-nav">
          <h4>导航</h4>
          <ul>
            <li v-for="item in store.menuItems" :key="item.id">
              <router-link :to="item.path">
                <el-icon v-if="item.icon"><component :is="iconMap[item.icon]" /></el-icon>{{ item.name }}
              </router-link>
            </li>
          </ul>
        </div>
        <div class="footer-col footer-social">
          <h4>社交媒体</h4>
          <div class="social-links">
            <a v-for="link in store.socialLinks" :key="link.label" :href="link.url" target="_blank" rel="noopener noreferrer">
              <el-icon v-if="link.icon && resolveIcon(link.icon)"><component :is="resolveIcon(link.icon)" /></el-icon>
              {{ link.label }}
            </a>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <span v-if="store.copyright">{{ store.copyright }}</span>
        <span v-else>&copy; {{ new Date().getFullYear() }} {{ store.siteTitle || '极简博客' }}</span>
        <span v-if="store.icpNumber" class="icp"> · {{ store.icpNumber }}</span>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import * as allIcons from '@element-plus/icons-vue'
import { Edit, Setting } from '@element-plus/icons-vue'
import { useAppStore } from '../stores/app'

function resolveIcon(name: string) {
  return (allIcons as Record<string, any>)[name] || null
}

const iconMap = new Proxy({} as Record<string, any>, {
  get(_target, prop: string) {
    return resolveIcon(prop)
  },
})

const store = useAppStore()

onMounted(() => {
  store.loadConfig()
  store.loadMenus()
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
.main-nav a {
  margin-left: 1.5rem;
  text-decoration: none;
  color: #666;
}
.main-nav a:hover {
  color: #409eff;
}
.main-nav .el-icon {
  vertical-align: -2px;
  margin-right: 2px;
}
.front-main {
  flex: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  width: 100%;
  box-sizing: border-box;
}

/* Footer */
.front-footer {
  background: #f8f9fa;
  border-top: 1px solid #e9ecef;
  color: #6c757d;
}
.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2.5rem 2rem 1.5rem;
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  gap: 2rem;
}
.footer-col h4 {
  margin: 0 0 0.75rem;
  font-size: 0.95rem;
  color: #333;
}
.footer-brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}
.footer-logo {
  height: 28px;
}
.footer-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
}
.footer-desc {
  font-size: 0.85rem;
  line-height: 1.6;
  color: #8c8c8c;
  margin: 0;
}
.footer-nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.footer-nav li {
  margin-bottom: 0.4rem;
}
.footer-nav a {
  text-decoration: none;
  color: #6c757d;
  font-size: 0.9rem;
  transition: color 0.2s;
}
.footer-nav a:hover {
  color: #409eff;
}
.footer-nav .el-icon {
  vertical-align: -2px;
  margin-right: 2px;
}
.social-links {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}
.social-links a {
  text-decoration: none;
  color: #6c757d;
  font-size: 0.9rem;
  transition: color 0.2s;
}
.social-links a:hover {
  color: #409eff;
}
.footer-bottom {
  text-align: center;
  padding: 1rem 2rem;
  border-top: 1px solid #e9ecef;
  font-size: 0.85rem;
  color: #adb5bd;
}
.icp {
  color: #adb5bd;
}

/* Responsive */
@media (max-width: 768px) {
  .front-header {
    flex-direction: column;
    gap: 0.75rem;
  }
  .main-nav a {
    margin-left: 0;
    margin-right: 1rem;
  }
  .footer-content {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
}
</style>
