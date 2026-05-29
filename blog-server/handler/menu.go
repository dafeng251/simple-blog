package handler

import (
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
		ServerError(c)
		return
	}
	Success(c, menus)
}

func (h *MenuHandler) PublicList(c *gin.Context) {
	menus, err := h.menuSvc.ListVisible()
	if err != nil {
		ServerError(c)
		return
	}
	Success(c, menus)
}

type MenuRequest struct {
	Name      string `json:"name" binding:"required,max=50"`
	Path      string `json:"path" binding:"required,max=200"`
	Icon      string `json:"icon" binding:"max=50"`
	SortOrder int    `json:"sort_order"`
	IsVisible *bool  `json:"is_visible"`
}

func (h *MenuHandler) Create(c *gin.Context) {
	var req MenuRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
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
		ServerError(c)
		return
	}
	Created(c, menu)
}

func (h *MenuHandler) Update(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}

	var req MenuRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
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

	if err := h.menuSvc.Update(id, updates, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "更新成功")
}

func (h *MenuHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)
	if err := h.menuSvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}

type ReorderRequest struct {
	IDs []uint `json:"ids" binding:"required,min=1,dive,gt=0"`
}

func (h *MenuHandler) Reorder(c *gin.Context) {
	var req ReorderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	if err := h.menuSvc.Reorder(req.IDs); err != nil {
		ServerError(c)
		return
	}
	OK(c, "排序成功")
}
