package model

type SiteConfig struct {
	ID    uint   `json:"id" gorm:"primaryKey"`
	Key   string `json:"key" gorm:"type:varchar(50);uniqueIndex;not null"`
	Value string `json:"value" gorm:"type:text"`
}
