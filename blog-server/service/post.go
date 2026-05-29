package service

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"blog-server/model"

	"github.com/redis/go-redis/v9"
	"gorm.io/gorm"
)

type PostService struct {
	db  *gorm.DB
	rdb *redis.Client
}

func NewPostService(db *gorm.DB, rdb *redis.Client) *PostService {
	return &PostService{db: db, rdb: rdb}
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
	ctx := context.Background()
	cacheKey := fmt.Sprintf("post:slug:%s", slug)

	if s.rdb != nil {
		if cached, err := s.rdb.Get(ctx, cacheKey).Result(); err == nil {
			var post model.Post
			if json.Unmarshal([]byte(cached), &post) == nil {
				return &post, nil
			}
		}
	}

	var post model.Post
	err := s.db.
		Preload("Category").
		Preload("Tags").
		Preload("Author").
		Where("slug = ?", slug).
		First(&post).Error
	if err != nil {
		return nil, err
	}

	if s.rdb != nil {
		if data, err := json.Marshal(post); err == nil {
			s.rdb.Set(ctx, cacheKey, data, 5*time.Minute)
		}
	}

	return &post, nil
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
	if s.rdb != nil {
		ctx := context.Background()
		s.rdb.Del(ctx, fmt.Sprintf("post:slug:%s", post.Slug))
	}
	return s.db.Model(&model.Post{}).Where("id = ?", post.ID).Updates(post).Error
}

func (s *PostService) UpdateTags(post *model.Post, tagIDs []uint) error {
	var tags []model.Tag
	if err := s.db.Find(&tags, tagIDs).Error; err != nil {
		return err
	}
	return s.db.Model(post).Association("Tags").Replace(tags)
}

func (s *PostService) Delete(id uint, deletedBy uint) error {
	var post model.Post
	s.db.Select("slug").First(&post, id)
	if s.rdb != nil {
		ctx := context.Background()
		s.rdb.Del(ctx, fmt.Sprintf("post:slug:%s", post.Slug))
	}
	return s.db.Model(&model.Post{}).Where("id = ?", id).
		Updates(map[string]interface{}{"deleted_by": deletedBy, "deleted_at": gorm.Expr("NOW()")}).Error
}
