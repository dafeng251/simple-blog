package router

import (
	"blog-server/config"
	"blog-server/handler"
	"blog-server/middleware"

	"github.com/gin-gonic/gin"
)

func Setup(
	cfg *config.Config,
	authH *handler.AuthHandler,
	postH *handler.PostHandler,
	categoryH *handler.CategoryHandler,
	tagH *handler.TagHandler,
	commentH *handler.CommentHandler,
	configH *handler.ConfigHandler,
	uploadH *handler.UploadHandler,
) *gin.Engine {
	r := gin.Default()

	r.Use(middleware.CORS())
	r.Use(middleware.Logger())

	// Serve uploaded files
	r.Static("/uploads", cfg.UploadDir)

	api := r.Group("/api")

	// Public routes
	api.GET("/posts", postH.List)
	api.GET("/posts/:slug", postH.GetBySlug)
	api.GET("/categories", categoryH.List)
	api.GET("/tags", tagH.List)
	api.POST("/comments", commentH.Create)

	// Admin routes
	admin := api.Group("/admin")
	admin.POST("/login", authH.Login)

	auth := admin.Group("")
	auth.Use(middleware.JWTAuth(cfg.JWTSecret))
	{
		auth.GET("/posts", postH.AdminList)
		auth.POST("/posts", postH.Create)
		auth.PUT("/posts/:id", postH.Update)
		auth.DELETE("/posts/:id", postH.Delete)

		auth.GET("/categories", categoryH.List)
		auth.POST("/categories", categoryH.Create)
		auth.PUT("/categories/:id", categoryH.Update)
		auth.DELETE("/categories/:id", categoryH.Delete)

		auth.GET("/tags", tagH.List)
		auth.POST("/tags", tagH.Create)
		auth.PUT("/tags/:id", tagH.Update)
		auth.DELETE("/tags/:id", tagH.Delete)

		auth.GET("/comments", commentH.AdminList)
		auth.PUT("/comments/:id", commentH.UpdateStatus)
		auth.DELETE("/comments/:id", commentH.Delete)

		auth.GET("/config", configH.GetAll)
		auth.PUT("/config", configH.Update)

		auth.POST("/upload", uploadH.Upload)
	}

	return r
}
