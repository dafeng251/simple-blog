package model

import "gorm.io/gorm"

type SiteConfig struct {
	BaseModel
	Key       string         `json:"key" gorm:"type:varchar(50);uniqueIndex:idx_key_deleted_at;not null"`
	Value     string         `json:"value" gorm:"type:text"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"uniqueIndex:idx_key_deleted_at;index"`
}
