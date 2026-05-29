package handler

import (
	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type CommentHandler struct {
	commentSvc *service.CommentService
}

func NewCommentHandler(commentSvc *service.CommentService) *CommentHandler {
	return &CommentHandler{commentSvc: commentSvc}
}

func (h *CommentHandler) ListByPost(c *gin.Context) {
	postID, ok := parseUint(c, c.Param("post_id"))
	if !ok {
		return
	}
	comments, err := h.commentSvc.ListByPostID(postID)
	if err != nil {
		ServerError(c)
		return
	}
	Success(c, comments)
}

type CreateCommentRequest struct {
	PostID   uint   `json:"post_id" binding:"required"`
	ParentID *uint  `json:"parent_id"`
	Nickname string `json:"nickname" binding:"required,max=50"`
	Email    string `json:"email" binding:"max=100,email"`
	Content  string `json:"content" binding:"required,max=2000"`
}

func (h *CommentHandler) Create(c *gin.Context) {
	var req CreateCommentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	comment := &model.Comment{
		PostID:   req.PostID,
		ParentID: req.ParentID,
		Nickname: req.Nickname,
		Email:    req.Email,
		Content:  req.Content,
		Status:   "pending",
	}

	if err := h.commentSvc.Create(comment); err != nil {
		ServerError(c)
		return
	}
	Created(c, comment)
}

func (h *CommentHandler) AdminList(c *gin.Context) {
	page := defaultQueryInt(c, "page", 1)
	pageSize := defaultQueryInt(c, "page_size", 10)

	comments, total, err := h.commentSvc.ListAll(page, pageSize)
	if err != nil {
		ServerError(c)
		return
	}
	SuccessWithPage(c, comments, total, page, pageSize)
}

type UpdateCommentStatusRequest struct {
	Status string `json:"status" binding:"required,oneof=pending approved rejected"`
}

func (h *CommentHandler) UpdateStatus(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}

	var req UpdateCommentStatusRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	if err := h.commentSvc.UpdateStatus(id, req.Status, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "更新成功")
}

func (h *CommentHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)
	if err := h.commentSvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}
