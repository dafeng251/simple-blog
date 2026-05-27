package model

import "gorm.io/gorm"

type File struct {
	BaseModel
	OriginalName string         `json:"original_name" gorm:"type:varchar(255);not null"`
	FileName     string         `json:"file_name" gorm:"type:varchar(255);not null"`
	URL          string         `json:"url" gorm:"type:varchar(500);not null"`
	Path         string         `json:"path" gorm:"type:varchar(500);not null"`
	Size         int64          `json:"size"`
	Ext          string         `json:"ext" gorm:"type:varchar(20)"`
	ContentType  string         `json:"content_type" gorm:"type:varchar(100)"`
	DeletedAt    gorm.DeletedAt `json:"deleted_at" gorm:"index"`
}
