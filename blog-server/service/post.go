package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type PostService struct {
	db *gorm.DB
}

func NewPostService(db *gorm.DB) *PostService {
	return &PostService{db: db}
}

type ListPostsParams struct {
	Page       int
	PageSize   int
	CategoryID uint
	TagID      uint
	Status     string
}

func (s *PostService) List(params ListPostsParams) ([]model.Post, int64, error) {
	var posts []model.Post
	var total int64

	query := s.db.Model(&model.Post{})
	if params.CategoryID > 0 {
		query = query.Where("category_id = ?", params.CategoryID)
	}
	if params.TagID > 0 {
		query = query.Joins("JOIN post_tags ON post_tags.post_id = posts.id").Where("post_tags.tag_id = ?", params.TagID)
	}
	if params.Status != "" {
		query = query.Where("status = ?", params.Status)
	}

	query.Count(&total)

	offset := (params.Page - 1) * params.PageSize
	err := query.
		Preload("Category").
		Preload("Tags").
		Preload("Author").
		Order("created_at DESC").
		Offset(offset).
		Limit(params.PageSize).
		Find(&posts).Error

	return posts, total, err
}

func (s *PostService) GetBySlug(slug string) (*model.Post, error) {
	var post model.Post
	err := s.db.
		Preload("Category").
		Preload("Tags").
		Preload("Author").
		Where("slug = ?", slug).
		First(&post).Error
	return &post, err
}

func (s *PostService) GetByID(id uint) (*model.Post, error) {
	var post model.Post
	err := s.db.
		Preload("Category").
		Preload("Tags").
		Preload("Author").
		First(&post, id).Error
	return &post, err
}

func (s *PostService) Create(post *model.Post) error {
	return s.db.Create(post).Error
}

func (s *PostService) Update(post *model.Post) error {
	return s.db.Save(post).Error
}

func (s *PostService) UpdateTags(post *model.Post, tagIDs []uint) error {
	var tags []model.Tag
	if err := s.db.Find(&tags, tagIDs).Error; err != nil {
		return err
	}
	return s.db.Model(post).Association("Tags").Replace(tags)
}

func (s *PostService) Delete(id uint) error {
	return s.db.Delete(&model.Post{}, id).Error
}
