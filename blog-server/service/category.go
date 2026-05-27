package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type CategoryService struct {
	db *gorm.DB
}

func NewCategoryService(db *gorm.DB) *CategoryService {
	return &CategoryService{db: db}
}

func (s *CategoryService) List() ([]model.Category, error) {
	var categories []model.Category
	err := s.db.Order("created_at DESC").Find(&categories).Error
	return categories, err
}

func (s *CategoryService) GetBySlug(slug string) (*model.Category, error) {
	var cat model.Category
	err := s.db.Where("slug = ?", slug).First(&cat).Error
	return &cat, err
}

func (s *CategoryService) Create(cat *model.Category) error {
	return s.db.Create(cat).Error
}

func (s *CategoryService) Update(cat *model.Category) error {
	return s.db.Save(cat).Error
}

func (s *CategoryService) Delete(id uint) error {
	return s.db.Delete(&model.Category{}, id).Error
}
