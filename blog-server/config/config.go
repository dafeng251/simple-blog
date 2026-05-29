package config

import "os"

type Config struct {
	Port      string
	DBDSN     string
	JWTSecret string
	UploadDir string
	RedisAddr string
	RedisPwd  string
	RedisDB   string
}

func Load() *Config {
	return &Config{
		Port:      envOr("PORT", "8080"),
		DBDSN:     envOr("DB_DSN", "root:123456@tcp(127.0.0.1:3306)/blog?charset=utf8mb4&parseTime=True&loc=Local"),
		JWTSecret: envOr("JWT_SECRET", "change-me-in-production"),
		UploadDir: envOr("UPLOAD_DIR", "uploads"),
		RedisAddr: envOr("REDIS_ADDR", "127.0.0.1:6379"),
		RedisPwd:  envOr("REDIS_PWD", ""),
		RedisDB:   envOr("REDIS_DB", "2"),
	}
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
