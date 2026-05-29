package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// OK returns a success response with code 0
func OK(c *gin.Context, message string) {
	c.JSON(http.StatusOK, gin.H{"code": 0, "message": message})
}

// Success returns a success response with data
func Success(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, gin.H{"code": 0, "message": "success", "data": data})
}

// Created returns a 201 success response with data
func Created(c *gin.Context, data interface{}) {
	c.JSON(http.StatusCreated, gin.H{"code": 0, "message": "success", "data": data})
}

// SuccessWithPage returns a paginated success response
func SuccessWithPage(c *gin.Context, data interface{}, total int64, page, pageSize int) {
	c.JSON(http.StatusOK, gin.H{
		"code":     0,
		"message":  "success",
		"data":     data,
		"total":    total,
		"page":     page,
		"page_size": pageSize,
	})
}

// Error returns an error response with the given HTTP status code
func Error(c *gin.Context, httpCode int, message string) {
	c.JSON(httpCode, gin.H{"code": httpCode, "message": message})
}

// BadRequest returns a 400 error
func BadRequest(c *gin.Context, message string) {
	Error(c, http.StatusBadRequest, message)
}

// Unauthorized returns a 401 error
func Unauthorized(c *gin.Context, message string) {
	Error(c, http.StatusUnauthorized, message)
}

// NotFound returns a 404 error
func NotFound(c *gin.Context, message string) {
	Error(c, http.StatusNotFound, message)
}

// ServerError returns a 500 error
func ServerError(c *gin.Context) {
	Error(c, http.StatusInternalServerError, "服务器内部错误")
}

// BindError handles ShouldBindJSON validation errors
func BindError(c *gin.Context, err error) {
	BadRequest(c, "请求参数错误")
}
