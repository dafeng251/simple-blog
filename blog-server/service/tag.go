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

func (s *TagService) GetBySlug(slug string) (*model.Tag, error) {
	var tag model.Tag
	err := s.db.Where("slug = ?", slug).First(&tag).Error
	return &tag, err
}

func (s *TagService) Create(tag *model.Tag) error {
	return s.db.Create(tag).Error
}

func (s *TagService) Update(tag *model.Tag) error {
	return s.db.Save(tag).Error
}

func (s *TagService) Delete(id uint) error {
	return s.db.Delete(&model.Tag{}, id).Error
}
