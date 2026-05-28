package model

import "gorm.io/gorm"

type Menu struct {
	BaseModel
	Name      string         `json:"name" gorm:"type:varchar(50);not null"`
	Path      string         `json:"path" gorm:"type:varchar(200);not null"`
	Icon      string         `json:"icon" gorm:"type:varchar(50);default:''"`
	SortOrder int            `json:"sort_order" gorm:"default:0"`
	IsVisible bool           `json:"is_visible" gorm:"default:true"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"index"`
}
