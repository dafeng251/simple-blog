package handler

import (
	"path/filepath"
	"strings"

	"blog-server/config"
	"blog-server/model"
	"blog-server/service"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type StorageFactory func() (service.Storage, error)

type UploadHandler struct {
	cfg            *config.Config
	fileSvc        *service.FileService
	storageFactory StorageFactory
}

func NewUploadHandler(cfg *config.Config, fileSvc *service.FileService, factory StorageFactory) *UploadHandler {
	return &UploadHandler{cfg: cfg, fileSvc: fileSvc, storageFactory: factory}
}

func (h *UploadHandler) Upload(c *gin.Context) {
	file, err := c.FormFile("file")
	if err != nil {
		BadRequest(c, "请选择文件")
		return
	}

	ext := strings.ToLower(filepath.Ext(file.Filename))
	allowed := map[string]bool{".jpg": true, ".jpeg": true, ".png": true, ".gif": true, ".webp": true}
	if !allowed[ext] {
		BadRequest(c, "不支持的文件类型")
		return
	}

	if file.Size > 10*1024*1024 {
		BadRequest(c, "文件大小不能超过10MB")
		return
	}

	filename := uuid.New().String() + ext

	storage, err := h.storageFactory()
	if err != nil {
		ServerError(c)
		return
	}

	url, path, err := storage.Save(file, filename)
	if err != nil {
		ServerError(c)
		return
	}

	uid := getUserID(c)

	fileRecord := &model.File{
		OriginalName: file.Filename,
		FileName:     filename,
		URL:          url,
		Path:         path,
		Size:         file.Size,
		Ext:          ext,
		ContentType:  file.Header.Get("Content-Type"),
	}
	fileRecord.CreatedBy = uid
	h.fileSvc.Create(fileRecord)

	Success(c, gin.H{"url": url})
}
