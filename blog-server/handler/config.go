package handler

import (
	"net/http"

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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": configs})
}

type UpdateConfigRequest struct {
	Key   string `json:"key" binding:"required"`
	Value string `json:"value"`
}

func (h *ConfigHandler) Update(c *gin.Context) {
	var req UpdateConfigRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := getUserID(c)
	if err := h.configSvc.Set(req.Key, req.Value, uid); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "updated"})
}

type BatchUpdateConfigRequest struct {
	Configs []UpdateConfigRequest `json:"configs" binding:"required"`
}

func (h *ConfigHandler) BatchUpdate(c *gin.Context) {
	var req BatchUpdateConfigRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := getUserID(c)
	for _, item := range req.Configs {
		if err := h.configSvc.Set(item.Key, item.Value, uid); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	}
	c.JSON(http.StatusOK, gin.H{"message": "updated"})
}
