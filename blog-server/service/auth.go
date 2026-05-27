package service

import (
	"errors"
	"time"

	"blog-server/model"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type AuthService struct {
	db        *gorm.DB
	jwtSecret string
}

func NewAuthService(db *gorm.DB, jwtSecret string) *AuthService {
	return &AuthService{db: db, jwtSecret: jwtSecret}
}

func (s *AuthService) Login(username, password string) (string, error) {
	var user model.User
	if err := s.db.Where("username = ?", username).First(&user).Error; err != nil {
		return "", errors.New("invalid credentials")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return "", errors.New("invalid credentials")
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id":  user.ID,
		"username": user.Username,
		"role":     user.Role,
		"exp":      time.Now().Add(24 * time.Hour).Unix(),
	})

	tokenStr, err := token.SignedString([]byte(s.jwtSecret))
	if err != nil {
		return "", err
	}

	return tokenStr, nil
}

func (s *AuthService) Register(username, password string) (string, error) {
	// Check if username already exists
	var exist int64
	s.db.Model(&model.User{}).Where("username = ?", username).Count(&exist)
	if exist > 0 {
		return "", errors.New("username already taken")
	}

	// First registered user becomes admin
	role := "user"
	var total int64
	s.db.Model(&model.User{}).Count(&total)
	if total == 0 {
		role = "admin"
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	user := model.User{
		Username:     username,
		PasswordHash: string(hash),
		Role:         role,
	}
	if err := s.db.Create(&user).Error; err != nil {
		return "", err
	}

	// Auto-login after registration
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id":  user.ID,
		"username": user.Username,
		"role":     user.Role,
		"exp":      time.Now().Add(24 * time.Hour).Unix(),
	})

	return token.SignedString([]byte(s.jwtSecret))
}

func (s *AuthService) CreateUser(username, password, role string) error {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user := model.User{
		Username:     username,
		PasswordHash: string(hash),
		Role:         role,
	}
	return s.db.Create(&user).Error
}
