import request from './request'

export function login(username: string, password: string) {
  return request.post('/admin/login', { username, password })
}

export function register(username: string, password: string) {
  return request.post('/admin/register', { username, password })
}
