import request from './request'

export function getSiteConfig() {
  return request.get('/config')
}

export function getAdminSiteConfig() {
  return request.get('/admin/config')
}

export function updateSiteConfig(key: string, value: string) {
  return request.put('/admin/config', { key, value })
}

export function batchUpdateSiteConfig(configs: { key: string; value: string }[]) {
  return request.put('/admin/config/batch', { configs })
}
