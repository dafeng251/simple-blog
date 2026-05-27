import request from './request'

export function getTags() {
  return request.get('/tags')
}

export function getAdminTags() {
  return request.get('/admin/tags')
}

export function createTag(data: { name: string; slug: string }) {
  return request.post('/admin/tags', data)
}

export function updateTag(id: number, data: { name: string; slug: string }) {
  return request.put(`/admin/tags/${id}`, data)
}

export function deleteTag(id: number) {
  return request.delete(`/admin/tags/${id}`)
}
