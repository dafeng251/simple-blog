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
        <el-form-item label="站点描述">
          <el-input v-model="form.site_description" type="textarea" :rows="3" placeholder="用于 SEO 的站点描述" />
        </el-form-item>
        <el-form-item label="Logo">
          <div class="logo-upload">
            <el-image v-if="form.site_logo" :src="form.site_logo" fit="contain" style="width: 120px; height: 60px; margin-right: 12px" />
            <el-upload
              :action="uploadUrl"
              :headers="uploadHeaders"
              :show-file-list="false"
              :on-success="(res: any) => { form.site_logo = res.url }"
              accept="image/*"
            >
              <el-button size="small"><el-icon><Upload /></el-icon> 上传</el-button>
            </el-upload>
            <el-button v-if="form.site_logo" size="small" type="danger" @click="form.site_logo = ''" style="margin-left: 8px">移除</el-button>
          </div>
        </el-form-item>
        <el-form-item label="Favicon">
          <div class="logo-upload">
            <el-image v-if="form.site_favicon" :src="form.site_favicon" fit="contain" style="width: 32px; height: 32px; margin-right: 12px" />
            <el-upload
              :action="uploadUrl"
              :headers="uploadHeaders"
              :show-file-list="false"
              :on-success="(res: any) => { form.site_favicon = res.url }"
              accept="image/*"
            >
              <el-button size="small"><el-icon><Upload /></el-icon> 上传</el-button>
            </el-upload>
            <el-button v-if="form.site_favicon" size="small" type="danger" @click="form.site_favicon = ''" style="margin-left: 8px">移除</el-button>
          </div>
        </el-form-item>
        <el-form-item label="备案号">
          <el-input v-model="form.icp_number" placeholder="如：京ICP备xxxxxxxx号" />
        </el-form-item>
        <el-form-item label="底部版权">
          <el-input v-model="form.copyright" placeholder="如：© 2026 极简博客" />
        </el-form-item>
        <el-form-item label="社交链接">
          <div v-for="(link, index) in socialLinks" :key="index" class="social-link-row">
            <el-input v-model="link.label" placeholder="名称" style="width: 120px" />
            <el-input v-model="link.url" placeholder="链接地址" style="flex: 1; margin-left: 8px" />
            <el-button type="danger" size="small" @click="socialLinks.splice(index, 1)" style="margin-left: 8px">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
          <el-button size="small" @click="socialLinks.push({ label: '', url: '' })">
            <el-icon><Plus /></el-icon> 添加链接
          </el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSave" :loading="saving"><el-icon><Check /></el-icon> 保存配置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Check, Upload, Plus, Delete } from '@element-plus/icons-vue'
import { getAdminSiteConfig, batchUpdateSiteConfig } from '../../api/config'
import { ElMessage } from 'element-plus'

const loading = ref(true)
const saving = ref(false)
const uploadUrl = '/api/admin/upload'
const uploadHeaders = { Authorization: `Bearer ${localStorage.getItem('token')}` }

const form = ref({
  site_title: '',
  site_subtitle: '',
  site_description: '',
  site_logo: '',
  site_favicon: '',
  icp_number: '',
  copyright: '',
})

interface SocialLink { label: string; url: string }
const socialLinks = ref<SocialLink[]>([])

async function fetchConfig() {
  loading.value = true
  try {
    const res: any = await getAdminSiteConfig()
    const configs: any[] = res.data || []
    configs.forEach((c) => {
      if (c.key === 'social_links') {
        try {
          socialLinks.value = JSON.parse(c.value)
        } catch {
          socialLinks.value = []
        }
      } else if (c.key in form.value) {
        ;(form.value as any)[c.key] = c.value
      }
    })
  } finally {
    loading.value = false
  }
}

async function handleSave() {
  saving.value = true
  try {
    const configs = Object.entries(form.value).map(([key, value]) => ({ key, value }))
    const validLinks = socialLinks.value.filter(l => l.label && l.url)
    configs.push({ key: 'social_links', value: JSON.stringify(validLinks) })
    await batchUpdateSiteConfig(configs)
    ElMessage.success('保存成功')
  } catch {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
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
.logo-upload {
  display: flex;
  align-items: center;
}
.social-link-row {
  display: flex;
  margin-bottom: 8px;
}
</style>
