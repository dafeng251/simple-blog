package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type TagService struct {
	db *gorm.DB
}

func NewTagService(db *gorm.DB) *TagService {
	return &TagService{db: db}
}

func (s *TagService) List() ([]model.Tag, error) {
	var tags []model.Tag
	err := s.db.Order("created_at DESC").Find(&tags).Error
	return tags, err
}

func (s *TagService) GetByID(id uint) (*model.Tag, error) {
	var tag model.Tag
	err := s.db.First(&tag, id).Error
	return &tag, err
}

func (s *TagService) Create(tag *model.Tag) error {
	return s.db.Create(tag).Error
}

func (s *TagService) Update(tag *model.Tag) error {
	return s.db.Model(&model.Tag{}).Where("id = ?", tag.ID).Updates(tag).Error
}

func (s *TagService) Delete(id uint, deletedBy uint) error {
	return s.db.Model(&model.Tag{}).Where("id = ?", id).
		Update("deleted_by", deletedBy).Update("deleted_at", gorm.Expr("NOW()")).Error
}
