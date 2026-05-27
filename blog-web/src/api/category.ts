import request from './request'

export function getCategories() {
  return request.get('/categories')
}

export function getAdminCategories() {
  return request.get('/admin/categories')
}

export function createCategory(data: { name: string; slug: string; description?: string }) {
  return request.post('/admin/categories', data)
}

export function updateCategory(id: number, data: { name: string; slug: string; description?: string }) {
  return request.put(`/admin/categories/${id}`, data)
}

export function deleteCategory(id: number) {
  return request.delete(`/admin/categories/${id}`)
}
