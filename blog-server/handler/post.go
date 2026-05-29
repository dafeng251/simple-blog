package handler

import (
	"time"

	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type PostHandler struct {
	postSvc *service.PostService
}

func NewPostHandler(postSvc *service.PostService) *PostHandler {
	return &PostHandler{postSvc: postSvc}
}

func (h *PostHandler) List(c *gin.Context) {
	page := defaultQueryInt(c, "page", 1)
	pageSize := defaultQueryInt(c, "page_size", 10)
	categoryID, _ := parseUintOptional(c.Query("category_id"))
	tagID, _ := parseUintOptional(c.Query("tag_id"))

	posts, total, err := h.postSvc.List(service.ListPostsParams{
		Page:       page,
		PageSize:   pageSize,
		CategoryID: categoryID,
		TagID:      tagID,
		Status:     "published",
	})
	if err != nil {
		ServerError(c)
		return
	}
	SuccessWithPage(c, posts, total, page, pageSize)
}

func (h *PostHandler) GetBySlug(c *gin.Context) {
	slug := c.Param("slug")
	post, err := h.postSvc.GetBySlug(slug)
	if err != nil {
		NotFound(c, "文章不存在")
		return
	}
	Success(c, post)
}

func (h *PostHandler) GetByID(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	post, err := h.postSvc.GetByID(id)
	if err != nil {
		NotFound(c, "文章不存在")
		return
	}
	Success(c, post)
}

func (h *PostHandler) AdminList(c *gin.Context) {
	page := defaultQueryInt(c, "page", 1)
	pageSize := defaultQueryInt(c, "page_size", 10)

	posts, total, err := h.postSvc.List(service.ListPostsParams{
		Page:     page,
		PageSize: pageSize,
	})
	if err != nil {
		ServerError(c)
		return
	}
	SuccessWithPage(c, posts, total, page, pageSize)
}

type CreatePostRequest struct {
	Title      string `json:"title" binding:"required,max=200"`
	Slug       string `json:"slug" binding:"required,max=200"`
	Content    string `json:"content"`
	Summary    string `json:"summary" binding:"max=500"`
	CoverImage string `json:"cover_image" binding:"max=500"`
	Status     string `json:"status" binding:"omitempty,oneof=draft published"`
	CategoryID uint   `json:"category_id"`
	TagIDs     []uint `json:"tag_ids"`
}

func (h *PostHandler) Create(c *gin.Context) {
	var req CreatePostRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	status := req.Status
	if status == "" {
		status = "draft"
	}

	post := &model.Post{
		Title:      req.Title,
		Slug:       req.Slug,
		Content:    req.Content,
		Summary:    req.Summary,
		CoverImage: req.CoverImage,
		Status:     status,
		CategoryID: req.CategoryID,
		AuthorID:   uid,
	}
	post.CreatedBy = uid

	if status == "published" {
		now := time.Now()
		post.PublishedAt = &now
	}

	if err := h.postSvc.Create(post); err != nil {
		ServerError(c)
		return
	}

	if len(req.TagIDs) > 0 {
		h.postSvc.UpdateTags(post, req.TagIDs)
	}

	Created(c, post)
}

func (h *PostHandler) Update(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}

	var req CreatePostRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)

	post := &model.Post{}
	post.ID = id
	post.Title = req.Title
	post.Slug = req.Slug
	post.Content = req.Content
	post.Summary = req.Summary
	post.CoverImage = req.CoverImage
	post.CategoryID = req.CategoryID
	post.UpdatedBy = uid

	if req.Status != "" {
		post.Status = req.Status
		if req.Status == "published" {
			now := time.Now()
			post.PublishedAt = &now
		}
	}

	if err := h.postSvc.Update(post); err != nil {
		ServerError(c)
		return
	}

	if req.TagIDs != nil {
		p := &model.Post{}
		p.ID = id
		h.postSvc.UpdateTags(p, req.TagIDs)
	}

	Success(c, post)
}

func (h *PostHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)
	if err := h.postSvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}
