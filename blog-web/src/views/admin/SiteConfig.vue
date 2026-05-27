<template>
  <div class="site-config">
    <el-card shadow="never">
      <div class="page-header">
        <h2>站点配置</h2>
      </div>
      <el-form :model="form" label-width="100px" style="max-width: 640px" v-loading="loading">
        <el-form-item label="站点标题">
          <el-input v-model="form.site_title" placeholder="网站标题" />
        </el-form-item>
        <el-form-item label="副标题">
          <el-input v-model="form.site_subtitle" placeholder="一句话介绍" />
        </el-form-item>
        <el-form-item label="Logo URL">
          <el-input v-model="form.site_logo" placeholder="https://..." />
        </el-form-item>
        <el-form-item label="备案号">
          <el-input v-model="form.icp_number" placeholder="如：京ICP备xxxxxxxx号" />
        </el-form-item>
        <el-form-item label="社交链接">
          <el-input v-model="form.social_links" type="textarea" :rows="4" placeholder='JSON 格式，如：{"github":"https://..."}' />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSave"><el-icon><Check /></el-icon> 保存配置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Check } from '@element-plus/icons-vue'
import { getSiteConfig, updateSiteConfig } from '../../api/config'
import { ElMessage } from 'element-plus'

const loading = ref(true)
const form = ref({
  site_title: '',
  site_subtitle: '',
  site_logo: '',
  icp_number: '',
  social_links: '',
})

async function fetchConfig() {
  loading.value = true
  try {
    const res: any = await getSiteConfig()
    const configs: any[] = res.data || []
    configs.forEach((c) => {
      if (c.key in form.value) {
        ;(form.value as any)[c.key] = c.value
      }
    })
  } finally {
    loading.value = false
  }
}

async function handleSave() {
  try {
    const entries = Object.entries(form.value)
    await Promise.all(entries.map(([key, value]) => updateSiteConfig(key, value)))
    ElMessage.success('保存成功')
  } catch {
    ElMessage.error('保存失败')
  }
}

onMounted(fetchConfig)
</script>

<style scoped>
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
</style>
