package handler

import (
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type ConfigHandler struct {
	configSvc *service.ConfigService
}

func NewConfigHandler(configSvc *service.ConfigService) *ConfigHandler {
	return &ConfigHandler{configSvc: configSvc}
}

func (h *ConfigHandler) GetAll(c *gin.Context) {
	configs, err := h.configSvc.GetAll()
	if err != nil {
		ServerError(c)
		return
	}
	Success(c, configs)
}

type UpdateConfigRequest struct {
	Key   string `json:"key" binding:"required,max=50"`
	Value string `json:"value"`
}

func (h *ConfigHandler) Update(c *gin.Context) {
	var req UpdateConfigRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	if err := h.configSvc.Set(req.Key, req.Value, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "更新成功")
}

type BatchUpdateConfigRequest struct {
	Configs []UpdateConfigRequest `json:"configs" binding:"required,min=1"`
}

func (h *ConfigHandler) BatchUpdate(c *gin.Context) {
	var req BatchUpdateConfigRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		BindError(c, err)
		return
	}

	uid := getUserID(c)
	for _, item := range req.Configs {
		if err := h.configSvc.Set(item.Key, item.Value, uid); err != nil {
			ServerError(c)
			return
		}
	}
	OK(c, "更新成功")
}
