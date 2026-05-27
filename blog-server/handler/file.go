package handler

import (
	"net/http"
	"os"
	"strconv"

	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type FileHandler struct {
	fileSvc *service.FileService
	uploadDir string
}

func NewFileHandler(fileSvc *service.FileService, uploadDir string) *FileHandler {
	return &FileHandler{fileSvc: fileSvc, uploadDir: uploadDir}
}

func (h *FileHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "10"))

	files, total, err := h.fileSvc.List(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": files, "total": total})
}

func (h *FileHandler) Delete(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	uid := getUserID(c)

	file, err := h.fileSvc.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "file not found"})
		return
	}

	// Delete physical file
	os.Remove(file.Path)

	if err := h.fileSvc.Delete(uint(id), uid); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "deleted"})
}
