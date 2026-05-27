package model

import "time"

type Category struct {
	ID          uint      `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(50);not null"`
	Slug        string    `json:"slug" gorm:"type:varchar(50);uniqueIndex;not null"`
	Description string    `json:"description" gorm:"type:varchar(200)"`
	CreatedAt   time.Time `json:"created_at"`
}
