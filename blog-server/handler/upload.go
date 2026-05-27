package handler

import (
	"net/http"
	"path/filepath"
	"strings"

	"blog-server/config"
	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type UploadHandler struct {
	cfg     *config.Config
	fileSvc *service.FileService
}

func NewUploadHandler(cfg *config.Config, fileSvc *service.FileService) *UploadHandler {
	return &UploadHandler{cfg: cfg, fileSvc: fileSvc}
}

func (h *UploadHandler) Upload(c *gin.Context) {
	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "file is required"})
		return
	}

	ext := strings.ToLower(filepath.Ext(file.Filename))
	allowed := map[string]bool{".jpg": true, ".jpeg": true, ".png": true, ".gif": true, ".webp": true}
	if !allowed[ext] {
		c.JSON(http.StatusBadRequest, gin.H{"error": "file type not allowed"})
		return
	}

	filename := uuid.New().String() + ext
	dst := filepath.Join(h.cfg.UploadDir, filename)

	if err := c.SaveUploadedFile(file, dst); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	url := "/uploads/" + filename
	uid := getUserID(c)

	// Save file record to DB
	fileRecord := &model.File{
		OriginalName: file.Filename,
		FileName:     filename,
		URL:          url,
		Path:         dst,
		Size:         file.Size,
		Ext:          ext,
		ContentType:  file.Header.Get("Content-Type"),
	}
	fileRecord.CreatedBy = uid
	h.fileSvc.Create(fileRecord)

	c.JSON(http.StatusOK, gin.H{"url": url})
}
