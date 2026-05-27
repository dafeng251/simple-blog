<template>
  <div class="login-page">
    <el-card class="login-card">
      <h2><el-icon><UserFilled /></el-icon> 注册账户</h2>
      <el-form @submit.prevent="handleRegister">
        <el-form-item>
          <el-input v-model="form.username" placeholder="用户名（至少3位）" :prefix-icon="User" />
        </el-form-item>
        <el-form-item>
          <el-input v-model="form.password" type="password" placeholder="密码（至少6位）" :prefix-icon="Lock" />
        </el-form-item>
        <el-form-item>
          <el-input v-model="form.confirmPassword" type="password" placeholder="确认密码" :prefix-icon="Lock" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleRegister" :loading="loading" style="width: 100%">
            <el-icon><CirclePlus /></el-icon> 注册
          </el-button>
        </el-form-item>
      </el-form>
      <div class="switch-link">
        已有账户？<router-link to="/admin/login"><el-icon><Right /></el-icon> 去登录</router-link>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '../../api/auth'
import { ElMessage } from 'element-plus'
import { UserFilled, User, Lock, CirclePlus, Right } from '@element-plus/icons-vue'

const router = useRouter()
const loading = ref(false)
const form = ref({ username: '', password: '', confirmPassword: '' })

async function handleRegister() {
  if (form.value.username.length < 3) {
    ElMessage.warning('用户名至少3位')
    return
  }
  if (form.value.password.length < 6) {
    ElMessage.warning('密码至少6位')
    return
  }
  if (form.value.password !== form.value.confirmPassword) {
    ElMessage.warning('两次密码不一致')
    return
  }

  loading.value = true
  try {
    const res: any = await register(form.value.username, form.value.password)
    localStorage.setItem('token', res.token)
    ElMessage.success('注册成功')
    router.push('/admin')
  } catch (err: any) {
    ElMessage.error(err.response?.data?.error || '注册失败')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
}
.login-card {
  width: 400px;
}
.login-card h2 {
  text-align: center;
  margin-bottom: 1.5rem;
}
.switch-link {
  text-align: center;
  color: #999;
}
</style>
