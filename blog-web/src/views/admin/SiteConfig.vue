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
              :on-success="(res: any) => { form.site_logo = res.data.url }"
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
              :on-success="(res: any) => { form.site_favicon = res.data.url }"
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
        <el-divider content-position="left">存储配置</el-divider>
        <el-form-item label="存储类型">
          <el-radio-group v-model="form.storage_type">
            <el-radio value="local">本地存储</el-radio>
            <el-radio value="rustfs">RustFS (S3)</el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="form.storage_type === 'rustfs'">
          <el-form-item label="Endpoint">
            <el-input v-model="form.rustfs_endpoint" placeholder="http://rustfs.example.com:9000" />
          </el-form-item>
          <el-form-item label="Access Key">
            <el-input v-model="form.rustfs_access_key" placeholder="访问密钥" />
          </el-form-item>
          <el-form-item label="Secret Key">
            <el-input v-model="form.rustfs_secret_key" placeholder="秘密密钥" type="password" show-password />
          </el-form-item>
          <el-form-item label="Bucket">
            <el-input v-model="form.rustfs_bucket" placeholder="bucket 名称" />
          </el-form-item>
          <el-form-item label="访问域名">
            <el-input v-model="form.rustfs_domain" placeholder="https://cdn.example.com" />
          </el-form-item>
        </template>
        <el-divider content-position="left">其他配置</el-divider>
        <el-form-item label="社交链接">
          <div class="social-links">
            <div v-for="(link, index) in socialLinks" :key="index" class="social-link-row">
              <IconInput v-model="link.icon" placeholder="图标" style="width: 160px" />
              <el-input v-model="link.label" placeholder="名称" style="width: 120px; margin-left: 8px" />
              <el-input v-model="link.url" placeholder="链接地址" style="flex: 1; margin-left: 8px" />
              <el-button type="danger" :icon="Delete" circle size="small" @click="socialLinks.splice(index, 1)" style="margin-left: 8px; flex-shrink: 0" />
            </div>
            <el-button size="small" type="primary" plain @click="socialLinks.push({ label: '', url: '', icon: '' })" style="width: 100%">
              <el-icon><Plus /></el-icon> 添加链接
            </el-button>
          </div>
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
import IconInput from '../../components/IconInput.vue'
import { getAdminSiteConfig, batchUpdateSiteConfig } from '../../api/config'
import { useAppStore } from '../../stores/app'
import { ElMessage } from 'element-plus'

const appStore = useAppStore()

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
  storage_type: 'local',
  rustfs_endpoint: '',
  rustfs_access_key: '',
  rustfs_secret_key: '',
  rustfs_bucket: '',
  rustfs_domain: '',
})

interface SocialLink { label: string; url: string; icon: string }
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
    await appStore.loadConfig()
    await fetchConfig()
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
.social-links {
  width: 100%;
}
.social-link-row {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}
</style>
