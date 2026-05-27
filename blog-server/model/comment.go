package model

type Comment struct {
	BaseModel
	PostID   uint     `json:"post_id" gorm:"index;not null"`
	Post     Post     `json:"post,omitempty" gorm:"foreignKey:PostID"`
	ParentID *uint    `json:"parent_id"`
	Parent   *Comment `json:"parent,omitempty" gorm:"foreignKey:ParentID"`
	Nickname string   `json:"nickname" gorm:"type:varchar(50);not null"`
	Email    string   `json:"email" gorm:"type:varchar(100)"`
	Content  string   `json:"content" gorm:"type:text;not null"`
	Status   string   `json:"status" gorm:"type:varchar(20);default:pending"`
}
