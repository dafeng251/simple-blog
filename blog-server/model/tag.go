package model

type Tag struct {
	BaseModel
	Name string `json:"name" gorm:"type:varchar(50);not null"`
	Slug string `json:"slug" gorm:"type:varchar(50);uniqueIndex;not null"`
}
