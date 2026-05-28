package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type MenuService struct {
	db *gorm.DB
}

func NewMenuService(db *gorm.DB) *MenuService {
	return &MenuService{db: db}
}

func (s *MenuService) List() ([]model.Menu, error) {
	var menus []model.Menu
	err := s.db.Order("sort_order ASC, created_at ASC").Find(&menus).Error
	return menus, err
}

func (s *MenuService) ListVisible() ([]model.Menu, error) {
	var menus []model.Menu
	err := s.db.Where("is_visible = ?", true).Order("sort_order ASC, created_at ASC").Find(&menus).Error
	return menus, err
}

func (s *MenuService) Create(menu *model.Menu) error {
	return s.db.Create(menu).Error
}

func (s *MenuService) Update(id uint, updates map[string]interface{}, updatedBy uint) error {
	updates["updated_by"] = updatedBy
	return s.db.Model(&model.Menu{}).Where("id = ?", id).Updates(updates).Error
}

func (s *MenuService) Delete(id uint, deletedBy uint) error {
	return s.db.Model(&model.Menu{}).Where("id = ?", id).
		Updates(map[string]interface{}{"deleted_by": deletedBy, "deleted_at": gorm.Expr("NOW()")}).Error
}

func (s *MenuService) Reorder(ids []uint) error {
	return s.db.Transaction(func(tx *gorm.DB) error {
		for i, id := range ids {
			if err := tx.Model(&model.Menu{}).Where("id = ?", id).
				Update("sort_order", i).Error; err != nil {
				return err
			}
		}
		return nil
	})
}
