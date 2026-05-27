package model

import "gorm.io/gorm"

type Tag struct {
	BaseModel
	Name      string         `json:"name" gorm:"type:varchar(50);not null"`
	Slug      string         `json:"slug" gorm:"type:varchar(50);uniqueIndex:idx_slug_deleted_at;not null"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"uniqueIndex:idx_slug_deleted_at;index"`
}
