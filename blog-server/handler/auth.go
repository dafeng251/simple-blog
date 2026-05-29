package handler

import (
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	authSvc *service.AuthService
}

func NewAuthHandler(authSvc *service.AuthService) *AuthHandler {
	return &AuthHandler{authSvc: authSvc}
}

type LoginRequest struct {
	Username string `json:"username" binding:"required,max=50"`
	Password string `json:"password" binding:"required,max=100"`
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	token, err := h.authSvc.Login(req.Username, req.Password)
	if err != nil {
		Unauthorized(c, "用户名或密码错误")
		return
	}

	Success(c, gin.H{"token": token})
}

type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Password string `json:"password" binding:"required,min=6,max=100"`
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	token, err := h.authSvc.Register(req.Username, req.Password)
	if err != nil {
		BadRequest(c, err.Error())
		return
	}

	Created(c, gin.H{"token": token})
}
