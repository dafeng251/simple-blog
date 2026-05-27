import request from './request'

export function getCommentsByPost(postId: number) {
  return request.get(`/comments/${postId}`)
}

export function createComment(data: {
  post_id: number
  parent_id?: number
  nickname: string
  email?: string
  content: string
}) {
  return request.post('/comments', data)
}

export function getAdminComments(params?: { page?: number; page_size?: number }) {
  return request.get('/admin/comments', { params })
}

export function updateCommentStatus(id: number, status: string) {
  return request.put(`/admin/comments/${id}`, { status })
}

export function deleteComment(id: number) {
  return request.delete(`/admin/comments/${id}`)
}
