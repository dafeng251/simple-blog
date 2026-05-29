package handler

import (
	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type CategoryHandler struct {
	categorySvc *service.CategoryService
}

func NewCategoryHandler(categorySvc *service.CategoryService) *CategoryHandler {
	return &CategoryHandler{categorySvc: categorySvc}
}

func (h *CategoryHandler) List(c *gin.Context) {
	categories, err := h.categorySvc.List()
	if err != nil {
		ServerError(c)
		return
	}
	Success(c, categories)
}

type CategoryRequest struct {
	Name        string `json:"name" binding:"required,max=50"`
	Slug        string `json:"slug" binding:"required,max=50"`
	Description string `json:"description" binding:"max=200"`
}

func (h *CategoryHandler) Create(c *gin.Context) {
	var req CategoryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	cat := &model.Category{
		Name:        req.Name,
		Slug:        req.Slug,
		Description: req.Description,
	}
	cat.CreatedBy = uid

	if err := h.categorySvc.Create(cat); err != nil {
		ServerError(c)
		return
	}
	Created(c, cat)
}

func (h *CategoryHandler) Update(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}

	var req CategoryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	cat := &model.Category{
		Name:        req.Name,
		Slug:        req.Slug,
		Description: req.Description,
	}
	cat.ID = id
	cat.UpdatedBy = uid

	if err := h.categorySvc.Update(cat); err != nil {
		ServerError(c)
		return
	}
	Success(c, cat)
}

func (h *CategoryHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)
	if err := h.categorySvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}
