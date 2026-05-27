package model

type SiteConfig struct {
	BaseModel
	Key   string `json:"key" gorm:"type:varchar(50);uniqueIndex;not null"`
	Value string `json:"value" gorm:"type:text"`
}
