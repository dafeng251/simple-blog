import request from './request'

export function getMenus() {
  return request.get('/admin/menus')
}

export function getPublicMenus() {
  return request.get('/menus')
}

export function createMenu(data: { name: string; path: string; icon?: string; sort_order?: number; is_visible?: boolean }) {
  return request.post('/admin/menus', data)
}

export function updateMenu(id: number, data: { name: string; path: string; icon?: string; sort_order?: number; is_visible?: boolean }) {
  return request.put(`/admin/menus/${id}`, data)
}

export function deleteMenu(id: number) {
  return request.delete(`/admin/menus/${id}`)
}

export function reorderMenus(ids: number[]) {
  return request.put('/admin/menus/reorder', { ids })
}
