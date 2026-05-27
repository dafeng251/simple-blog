package handler

import (
	"net/http"
	"strconv"
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
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "10"))
	categoryID, _ := strconv.ParseUint(c.Query("category_id"), 10, 32)
	tagID, _ := strconv.ParseUint(c.Query("tag_id"), 10, 32)

	posts, total, err := h.postSvc.List(service.ListPostsParams{
		Page:       page,
		PageSize:   pageSize,
		CategoryID: uint(categoryID),
		TagID:      uint(tagID),
		Status:     "published",
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": posts, "total": total, "page": page, "page_size": pageSize})
}

func (h *PostHandler) GetBySlug(c *gin.Context) {
	slug := c.Param("slug")
	post, err := h.postSvc.GetBySlug(slug)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": post})
}

func (h *PostHandler) AdminList(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "10"))

	posts, total, err := h.postSvc.List(service.ListPostsParams{
		Page:     page,
		PageSize: pageSize,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": posts, "total": total, "page": page, "page_size": pageSize})
}

type CreatePostRequest struct {
	Title      string `json:"title" binding:"required"`
	Slug       string `json:"slug" binding:"required"`
	Content    string `json:"content"`
	Summary    string `json:"summary"`
	CoverImage string `json:"cover_image"`
	Status     string `json:"status"`
	CategoryID uint   `json:"category_id"`
	TagIDs     []uint `json:"tag_ids"`
}

func (h *PostHandler) Create(c *gin.Context) {
	var req CreatePostRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if len(req.TagIDs) > 0 {
		h.postSvc.UpdateTags(post, req.TagIDs)
	}

	c.JSON(http.StatusCreated, gin.H{"data": post})
}

func (h *PostHandler) Update(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)

	var req CreatePostRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := getUserID(c)

	post := &model.Post{}
	post.ID = uint(id)
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if req.TagIDs != nil {
		p := &model.Post{}
		p.ID = uint(id)
		h.postSvc.UpdateTags(p, req.TagIDs)
	}

	c.JSON(http.StatusOK, gin.H{"data": post})
}

func (h *PostHandler) Delete(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	uid := getUserID(c)
	if err := h.postSvc.Delete(uint(id), uid); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "deleted"})
}
