import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    // Public routes
    {
      path: '/',
      component: () => import('../components/FrontLayout.vue'),
      children: [
        { path: '', name: 'Home', component: () => import('../views/front/Home.vue') },
        { path: 'post/:slug', name: 'Post', component: () => import('../views/front/Post.vue') },
        { path: 'category/:slug', name: 'Category', component: () => import('../views/front/Category.vue') },
        { path: 'tag/:slug', name: 'Tag', component: () => import('../views/front/Tag.vue') },
        { path: 'about', name: 'About', component: () => import('../views/front/About.vue') },
      ],
    },
    // Admin routes
    { path: '/admin/login', name: 'Login', component: () => import('../views/admin/Login.vue') },
    { path: '/admin/register', name: 'Register', component: () => import('../views/admin/Register.vue') },
    {
      path: '/admin',
      component: () => import('../components/Layout.vue'),
      meta: { requiresAuth: true },
      children: [
        { path: '', name: 'Dashboard', component: () => import('../views/admin/Dashboard.vue') },
        { path: 'posts', name: 'PostList', component: () => import('../views/admin/PostList.vue') },
        { path: 'posts/edit/:id?', name: 'PostEdit', component: () => import('../views/admin/PostEdit.vue') },
        { path: 'categories', name: 'CategoryList', component: () => import('../views/admin/CategoryList.vue') },
        { path: 'tags', name: 'TagList', component: () => import('../views/admin/TagList.vue') },
        { path: 'comments', name: 'CommentList', component: () => import('../views/admin/CommentList.vue') },
        { path: 'config', name: 'SiteConfig', component: () => import('../views/admin/SiteConfig.vue') },
        { path: 'menus', name: 'MenuList', component: () => import('../views/admin/MenuList.vue') },
        { path: 'files', name: 'FileList', component: () => import('../views/admin/FileList.vue') },
      ],
    },
  ],
})

router.beforeEach((to, _from, next) => {
  if (to.meta.requiresAuth && !localStorage.getItem('token')) {
    next('/admin/login')
  } else {
    next()
  }
})

export default router
