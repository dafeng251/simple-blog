package main

import (
	"context"
	"log"
	"os"
	"strconv"

	"blog-server/config"
	"blog-server/handler"
	"blog-server/model"
	"blog-server/router"
	"blog-server/service"

	"github.com/redis/go-redis/v9"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func main() {
	cfg := config.Load()

	// Ensure upload directory exists
	os.MkdirAll(cfg.UploadDir, 0755)

	// MySQL
	db, err := gorm.Open(mysql.Open(cfg.DBDSN), &gorm.Config{})
	if err != nil {
		log.Fatal("failed to connect database:", err)
	}

	// Auto migrate
	if err := db.AutoMigrate(
		&model.User{},
		&model.Category{},
		&model.Tag{},
		&model.Post{},
		&model.PostTag{},
		&model.Comment{},
		&model.SiteConfig{},model.SiteConfig{},
		&model.File{},
	); err != nil {
		log.Fatal("failed to migrate database:", err)
	}

	// Redis
	redisDB, _ := strconv.Atoi(cfg.RedisDB)
	rdb := redis.NewClient(&redis.Options{
		Addr:     cfg.RedisAddr,
		Password: cfg.RedisPwd,
		DB:       redisDB,
	})
	if err := rdb.Ping(context.Background()).Err(); err != nil {
		log.Println("warning: redis not available:", err)
	} else {
		log.Println("connected to redis")
	}

	// Services
	authSvc := service.NewAuthService(db, cfg.JWTSecret)
	postSvc := service.NewPostService(db, rdb)
	categorySvc := service.NewCategoryService(db)
	tagSvc := service.NewTagService(db)
	commentSvc := service.NewCommentService(db)
	configSvc := service.NewConfigService(db)
	fileSvc := service.NewFileService(db)

	// Handlers
	authH := handler.NewAuthHandler(authSvc)
	postH := handler.NewPostHandler(postSvc)
	categoryH := handler.NewCategoryHandler(categorySvc)
	tagH := handler.NewTagHandler(tagSvc)
	commentH := handler.NewCommentHandler(commentSvc)
	configH := handler.NewConfigHandler(configSvc)
	fileH := handler.NewFileHandler(fileSvc, cfg.UploadDir)
	uploadH := handler.NewUploadHandler(cfg, fileSvc)

	// Router
	r := router.Setup(cfg, authH, postH, categoryH, tagH, commentH, configH, uploadH, fileH)

	log.Printf("server starting on :%s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatal("failed to start server:", err)
	}
}
