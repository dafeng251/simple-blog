package model

type User struct {
	BaseModel
	Username     string `json:"username" gorm:"type:varchar(50);uniqueIndex;not null"`
	PasswordHash string `json:"-" gorm:"type:varchar(255);not null"`
	Role         string `json:"role" gorm:"type:varchar(20);default:user"`
}
