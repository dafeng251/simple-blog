package service

import (
	"blog-server/model"

	"gorm.io/gorm"
)

type CommentService struct {
	db *gorm.DB
}

func NewCommentService(db *gorm.DB) *CommentService {
	return &CommentService{db: db}
}

func (s *CommentService) ListByPostID(postID uint) ([]model.Comment, error) {
	var comments []model.Comment
	err := s.db.Where("post_id = ? AND status = ?", postID, "approved").
		Order("created_at ASC").
		Find(&comments).Error
	return comments, err
}

func (s *CommentService) ListAll(page, pageSize int) ([]model.Comment, int64, error) {
	var comments []model.Comment
	var total int64

	s.db.Model(&model.Comment{}).Count(&total)

	offset := (page - 1) * pageSize
	err := s.db.
		Preload("Post").
		Order("created_at ASC").
		Offset(offset).
		Limit(pageSize).
		Find(&comments).Error

	return comments, total, err
}

func (s *CommentService) Create(comment *model.Comment) error {
	return s.db.Create(comment).Error
}

func (s *CommentService) UpdateStatus(id uint, status string, updatedBy uint) error {
	return s.db.Model(&model.Comment{}).Where("id = ?", id).
		Updates(map[string]interface{}{"status": status, "updated_by": updatedBy}).Error
}

func (s *CommentService) Delete(id uint, deletedBy uint) error {
	return s.db.Model(&model.Comment{}).Where("id = ?", id).
		Updates(map[string]interface{}{"deleted_by": deletedBy, "deleted_at": gorm.Expr("NOW()")}).Error
}
