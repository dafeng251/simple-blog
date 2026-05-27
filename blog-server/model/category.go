package model

type Category struct {
	BaseModel
	Name        string `json:"name" gorm:"type:varchar(50);not null"`
	Slug        string `json:"slug" gorm:"type:varchar(50);uniqueIndex;not null"`
	Description string `json:"description" gorm:"type:varchar(200)"`
}
