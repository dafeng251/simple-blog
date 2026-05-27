import request from './request'

export function getSiteConfig() {
  return request.get('/admin/config')
}

export function updateSiteConfig(key: string, value: string) {
  return request.put('/admin/config', { key, value })
}
