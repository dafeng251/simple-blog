package model

import (
	"time"

	"gorm.io/gorm"
)

type Post struct {
	BaseModel
	Title       string         `json:"title" gorm:"type:varchar(200);not null"`
	Slug        string         `json:"slug" gorm:"type:varchar(200);uniqueIndex:idx_slug_deleted_at;not null"`
	Content     string         `json:"content" gorm:"type:text"`
	Summary     string         `json:"summary" gorm:"type:varchar(500)"`
	CoverImage  string         `json:"cover_image" gorm:"type:varchar(500)"`
	Status      string         `json:"status" gorm:"type:varchar(20);default:draft"`
	CategoryID  uint           `json:"category_id"`
	Category    Category       `json:"category" gorm:"foreignKey:CategoryID"`
	AuthorID    uint           `json:"author_id"`
	Author      User           `json:"author" gorm:"foreignKey:AuthorID"`
	Tags        []Tag          `json:"tags" gorm:"many2many:post_tags;"`
	PublishedAt *time.Time     `json:"published_at"`
	DeletedAt   gorm.DeletedAt `json:"deleted_at" gorm:"uniqueIndex:idx_slug_deleted_at;index"`
}

type PostTag struct {
	PostID uint `gorm:"primaryKey"`
	TagID  uint `gorm:"primaryKey"`
}
