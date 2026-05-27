<template>
  <div class="front-layout">
    <header class="front-header">
      <router-link to="/" class="logo">My Blog</router-link>
      <nav>
        <router-link to="/">首页</router-link>
        <router-link to="/about">关于</router-link>
        <router-link to="/admin">管理</router-link>
      </nav>
    </header>
    <main class="front-main">
      <router-view />
    </main>
    <footer class="front-footer">
      <p>&copy; 2026 My Blog</p>
    </footer>
  </div>
</template>

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
</style>
