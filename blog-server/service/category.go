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
	err := s.db.Order("created_at ASC").Find(&categories).Error
	return categories, err
}

func (s *CategoryService) GetByID(id uint) (*model.Category, error) {
	var cat model.Category
	err := s.db.First(&cat, id).Error
	return &cat, err
}

func (s *CategoryService) Create(cat *model.Category) error {
	return s.db.Create(cat).Error
}

func (s *CategoryService) Update(cat *model.Category) error {
	return s.db.Model(&model.Category{}).Where("id = ?", cat.ID).Updates(cat).Error
}

func (s *CategoryService) Delete(id uint, deletedBy uint) error {
	return s.db.Model(&model.Category{}).Where("id = ?", id).
		Updates(map[string]interface{}{"deleted_by": deletedBy, "deleted_at": gorm.Expr("NOW()")}).Error
}
