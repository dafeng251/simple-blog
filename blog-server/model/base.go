package model

import "time"

// BaseModel provides common audit fields for all models.
// DeletedAt is declared per-model with composite unique indexes.
type BaseModel struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	CreatedAt time.Time `json:"created_at"`
	CreatedBy uint      `json:"created_by"`
	UpdatedAt time.Time `json:"updated_at"`
	UpdatedBy uint      `json:"updated_by"`
	DeletedBy uint      `json:"deleted_by"`
}
