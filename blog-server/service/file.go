package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type FileService struct {
	db *gorm.DB
}

func NewFileService(db *gorm.DB) *FileService {
	return &FileService{db: db}
}

func (s *FileService) List(page, pageSize int) ([]model.File, int64, error) {
	var files []model.File
	var total int64

	s.db.Model(&model.File{}).Count(&total)

	offset := (page - 1) * pageSize
	err := s.db.Order("created_at ASC").Offset(offset).Limit(pageSize).Find(&files).Error
	return files, total, err
}

func (s *FileService) Create(file *model.File) error {
	return s.db.Create(file).Error
}

func (s *FileService) GetByID(id uint) (*model.File, error) {
	var file model.File
	err := s.db.First(&file, id).Error
	return &file, err
}

func (s *FileService) Delete(id uint, deletedBy uint) error {
	return s.db.Model(&model.File{}).Where("id = ?", id).
		Updates(map[string]interface{}{"deleted_by": deletedBy, "deleted_at": gorm.Expr("NOW()")}).Error
}
