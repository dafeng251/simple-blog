package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type ConfigService struct {
	db *gorm.DB
}

func NewConfigService(db *gorm.DB) *ConfigService {
	return &ConfigService{db: db}
}

func (s *ConfigService) GetAll() ([]model.SiteConfig, error) {
	var configs []model.SiteConfig
	err := s.db.Find(&configs).Error
	return configs, err
}

func (s *ConfigService) GetByKey(key string) (string, error) {
	var config model.SiteConfig
	err := s.db.Where("key = ?", key).First(&config).Error
	if err != nil {
		return "", err
	}
	return config.Value, nil
}

func (s *ConfigService) Set(key, value string, updatedBy uint) error {
	var config model.SiteConfig
	result := s.db.Where("key = ?", key).First(&config)
	if result.Error == gorm.ErrRecordNotFound {
		config = model.SiteConfig{Key: key, Value: value}
		config.CreatedBy = updatedBy
		return s.db.Create(&config).Error
	}
	config.Value = value
	config.UpdatedBy = updatedBy
	return s.db.Model(&model.SiteConfig{}).Where("id = ?", config.ID).
		Updates(map[string]interface{}{"value": value, "updated_by": updatedBy}).Error
}
