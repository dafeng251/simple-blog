package handler

import (
	"net/http"
	"strconv"

	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type MenuHandler struct {
	menuSvc *service.MenuService
}

func NewMenuHandler(menuSvc *service.MenuService) *MenuHandler {
	return &MenuHandler{menuSvc: menuSvc}
}

func (h *MenuHandler) List(c *gin.Context) {
	menus, err := h.menuSvc.List()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": menus})
}

func (h *MenuHandler) PublicList(c *gin.Context) {
	menus, err := h.menuSvc.ListVisible()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": menus})
}

type MenuRequest struct {
	Name      string `json:"name" binding:"required"`
	Path      string `json:"path" binding:"required"`
	Icon      string `json:"icon"`
	SortOrder int    `json:"sort_order"`
	IsVisible *bool  `json:"is_visible"`
}

func (h *MenuHandler) Create(c *gin.Context) {
	var req MenuRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := getUserID(c)
	menu := &model.Menu{
		Name:      req.Name,
		Path:      req.Path,
		Icon:      req.Icon,
		SortOrder: req.SortOrder,
		IsVisible: true,
	}
	if req.IsVisible != nil {
		menu.IsVisible = *req.IsVisible
	}
	menu.CreatedBy = uid

	if err := h.menuSvc.Create(menu); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"data": menu})
}

func (h *MenuHandler) Update(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)

	var req MenuRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := getUserID(c)
	updates := map[string]interface{}{
		"name":       req.Name,
		"path":       req.Path,
		"icon":       req.Icon,
		"sort_order": req.SortOrder,
	}
	if req.IsVisible != nil {
		updates["is_visible"] = *req.IsVisible
	}

	if err := h.menuSvc.Update(uint(id), updates, uid); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "updated"})
}

func (h *MenuHandler) Delete(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	uid := getUserID(c)
	if err := h.menuSvc.Delete(uint(id), uid); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "deleted"})
}

type ReorderRequest struct {
	IDs []uint `json:"ids" binding:"required"`
}

func (h *MenuHandler) Reorder(c *gin.Context) {
	var req ReorderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.menuSvc.Reorder(req.IDs); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "reordered"})
}
