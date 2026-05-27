package model

import "gorm.io/gorm"

type User struct {
	BaseModel
	Username     string         `json:"username" gorm:"type:varchar(50);uniqueIndex:idx_username_deleted_at;not null"`
	PasswordHash string         `json:"-" gorm:"type:varchar(255);not null"`
	Role         string         `json:"role" gorm:"type:varchar(20);default:user"`
	DeletedAt    gorm.DeletedAt `json:"deleted_at" gorm:"uniqueIndex:idx_username_deleted_at;index"`
}
