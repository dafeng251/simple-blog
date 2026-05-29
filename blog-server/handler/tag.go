package handler

import (
	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type TagHandler struct {
	tagSvc *service.TagService
}

func NewTagHandler(tagSvc *service.TagService) *TagHandler {
	return &TagHandler{tagSvc: tagSvc}
}

func (h *TagHandler) List(c *gin.Context) {
	tags, err := h.tagSvc.List()
	if err != nil {
		ServerError(c)
		return
	}
	Success(c, tags)
}

type TagRequest struct {
	Name string `json:"name" binding:"required,max=50"`
	Slug string `json:"slug" binding:"required,max=50"`
}

func (h *TagHandler) Create(c *gin.Context) {
	var req TagRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	tag := &model.Tag{Name: req.Name, Slug: req.Slug}
	tag.CreatedBy = uid

	if err := h.tagSvc.Create(tag); err != nil {
		ServerError(c)
		return
	}
	Created(c, tag)
}

func (h *TagHandler) Update(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}

	var req TagRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	tag := &model.Tag{Name: req.Name, Slug: req.Slug}
	tag.ID = id
	tag.UpdatedBy = uid

	if err := h.tagSvc.Update(tag); err != nil {
		ServerError(c)
		return
	}
	Success(c, tag)
}

func (h *TagHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)
	if err := h.tagSvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}
