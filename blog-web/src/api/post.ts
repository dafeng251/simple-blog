import request from './request'

export function getPosts(params?: { page?: number; page_size?: number; category_id?: number; tag_id?: number }) {
  return request.get('/posts', { params })
}

export function getPostBySlug(slug: string) {
  return request.get(`/posts/${slug}`)
}

export function getPostById(id: number) {
  return request.get(`/admin/posts/${id}`)
}

export function getAdminPosts(params?: { page?: number; page_size?: number }) {
  return request.get('/admin/posts', { params })
}

export function createPost(data: any) {
  return request.post('/admin/posts', data)
}

export function updatePost(id: number, data: any) {
  return request.put(`/admin/posts/${id}`, data)
}

export function deletePost(id: number) {
  return request.delete(`/admin/posts/${id}`)
}
