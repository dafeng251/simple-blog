package model

import "time"

type Post struct {
	ID          uint      `json:"id" gorm:"primaryKey"`
	Title       string    `json:"title" gorm:"type:varchar(200);not null"`
	Slug        string    `json:"slug" gorm:"type:varchar(200);uniqueIndex;not null"`
	Content     string    `json:"content" gorm:"type:text"`
	Summary     string    `json:"summary" gorm:"type:varchar(500)"`
	CoverImage  string    `json:"cover_image" gorm:"type:varchar(500)"`
	Status      string    `json:"status" gorm:"type:varchar(20);default:draft"`
	CategoryID  uint      `json:"category_id"`
	Category    Category  `json:"category" gorm:"foreignKey:CategoryID"`
	AuthorID    uint      `json:"author_id"`
	Author      User      `json:"author" gorm:"foreignKey:AuthorID"`
	Tags        []Tag     `json:"tags" gorm:"many2many:post_tags;"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	PublishedAt *time.Time `json:"published_at"`
}

type PostTag struct {
	PostID uint `gorm:"primaryKey"`
	TagID  uint `gorm:"primaryKey"`
}
