import request from './request'

export function getAdminFiles(params?: { page?: number; page_size?: number }) {
  return request.get('/admin/files', { params })
}

export function deleteFile(id: number) {
  return request.delete(`/admin/files/${id}`)
}
