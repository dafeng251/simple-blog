package model

import "time"

type Tag struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name" gorm:"type:varchar(50);not null"`
	Slug      string    `json:"slug" gorm:"type:varchar(50);uniqueIndex;not null"`
	CreatedAt time.Time `json:"created_at"`
}
