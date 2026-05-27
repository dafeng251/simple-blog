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

// Public: list published posts
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

// Public: get post by slug
func (h *PostHandler) GetBySlug(c *gin.Context) {
	slug := c.Param("slug")
	post, err := h.postSvc.GetBySlug(slug)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": post})
}

// Admin: list all posts (including drafts)
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

	userID, _ := c.Get("user_id")
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
		AuthorID:   uint(userID.(float64)),
	}

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
	post, err := h.postSvc.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
		return
	}

	var req CreatePostRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	post.Title = req.Title
	post.Slug = req.Slug
	post.Content = req.Content
	post.Summary = req.Summary
	post.CoverImage = req.CoverImage
	post.CategoryID = req.CategoryID

	if req.Status == "published" && post.Status != "published" {
		now := time.Now()
		post.PublishedAt = &now
	}
	if req.Status != "" {
		post.Status = req.Status
	}

	if err := h.postSvc.Update(post); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if req.TagIDs != nil {
		h.postSvc.UpdateTags(post, req.TagIDs)
	}

	c.JSON(http.StatusOK, gin.H{"data": post})
}

func (h *PostHandler) Delete(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	if err := h.postSvc.Delete(uint(id)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "deleted"})
}
