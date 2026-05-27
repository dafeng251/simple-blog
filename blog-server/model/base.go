package model

import (
	"time"

	"gorm.io/gorm"
)

// BaseModel provides common audit fields for all models.
type BaseModel struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	CreatedAt time.Time      `json:"created_at"`
	CreatedBy uint           `json:"created_by"`
	UpdatedAt time.Time      `json:"updated_at"`
	UpdatedBy uint           `json:"updated_by"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"index"`
	DeletedBy uint           `json:"deleted_by"`
}
