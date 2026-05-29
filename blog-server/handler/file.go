package handler

import (
	"blog-server/service"

	"github.com/gin-gonic/gin"
)

type FileHandler struct {
	fileSvc        *service.FileService
	storageFactory StorageFactory
}

func NewFileHandler(fileSvc *service.FileService, factory StorageFactory) *FileHandler {
	return &FileHandler{fileSvc: fileSvc, storageFactory: factory}
}

func (h *FileHandler) List(c *gin.Context) {
	page := defaultQueryInt(c, "page", 1)
	pageSize := defaultQueryInt(c, "page_size", 10)

	files, total, err := h.fileSvc.List(page, pageSize)
	if err != nil {
		ServerError(c)
		return
	}
	SuccessWithPage(c, files, total, page, pageSize)
}

func (h *FileHandler) Delete(c *gin.Context) {
	id, ok := parseUint(c, c.Param("id"))
	if !ok {
		return
	}
	uid := getUserID(c)

	file, err := h.fileSvc.GetByID(id)
	if err != nil {
		NotFound(c, "文件不存在")
		return
	}

	// Delete physical file from storage
	if storage, err := h.storageFactory(); err == nil {
		storage.Delete(file.Path)
	}

	if err := h.fileSvc.Delete(id, uid); err != nil {
		ServerError(c)
		return
	}
	OK(c, "删除成功")
}
