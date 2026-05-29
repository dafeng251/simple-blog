package service

import (
	"context"
	"fmt"
	"mime/multipart"
	"os"
	"path/filepath"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

// Storage defines the interface for file storage backends.
type Storage interface {
	// Save uploads the file and returns (publicUrl, storagePath, error).
	// storagePath is stored in the DB for later deletion.
	Save(file *multipart.FileHeader, filename string) (url string, path string, err error)
	Delete(path string) error
}

// LocalStorage saves files to the local filesystem.
type LocalStorage struct {
	uploadDir string
}

func NewLocalStorage(uploadDir string) *LocalStorage {
	return &LocalStorage{uploadDir: uploadDir}
}

func (s *LocalStorage) Save(file *multipart.FileHeader, filename string) (string, string, error) {
	dst := filepath.Join(s.uploadDir, filename)
	src, err := file.Open()
	if err != nil {
		return "", "", err
	}
	defer src.Close()

	dstFile, err := os.Create(dst)
	if err != nil {
		return "", "", err
	}
	defer dstFile.Close()

	if _, err := dstFile.ReadFrom(src); err != nil {
		return "", "", err
	}
	return "/uploads/" + filename, dst, nil
}

func (s *LocalStorage) Delete(path string) error {
	return os.Remove(path)
}

// RustFSStorage saves files to a RustFS (S3-compatible) bucket.
type RustFSStorage struct {
	client *s3.Client
	bucket string
	domain string // custom domain for public URL, e.g. https://cdn.example.com
}

func NewRustFSStorage(endpoint, accessKey, secretKey, bucket, domain string) *RustFSStorage {
	client := s3.New(s3.Options{
		Region:       "us-east-1",
		BaseEndpoint: aws.String(endpoint),
		Credentials:  credentials.NewStaticCredentialsProvider(accessKey, secretKey, ""),
	})
	return &RustFSStorage{
		client: client,
		bucket: bucket,
		domain: strings.TrimRight(domain, "/"),
	}
}

func (s *RustFSStorage) Save(file *multipart.FileHeader, filename string) (string, string, error) {
	f, err := file.Open()
	if err != nil {
		return "", "", err
	}
	defer f.Close()

	contentType := file.Header.Get("Content-Type")
	if contentType == "" {
		contentType = "application/octet-stream"
	}

	_, err = s.client.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket:      aws.String(s.bucket),
		Key:         aws.String(filename),
		Body:        f,
		ContentType: aws.String(contentType),
	})
	if err != nil {
		return "", "", fmt.Errorf("rustfs upload failed: %w", err)
	}

	return s.domain + "/" + filename, filename, nil
}

func (s *RustFSStorage) Delete(path string) error {
	// path is the object key for RustFS files
	_, err := s.client.DeleteObject(context.TODO(), &s3.DeleteObjectInput{
		Bucket: aws.String(s.bucket),
		Key:    aws.String(path),
	})
	return err
}

// NewStorage creates a Storage instance based on the storage type from config.
// storageType: "local" or "rustfs"
// configSvc: used to read RustFS configuration from site_config
func NewStorage(storageType string, configSvc *ConfigService, uploadDir string) (Storage, error) {
	switch storageType {
	case "rustfs":
		endpoint, _ := configSvc.GetByKey("rustfs_endpoint")
		accessKey, _ := configSvc.GetByKey("rustfs_access_key")
		secretKey, _ := configSvc.GetByKey("rustfs_secret_key")
		bucket, _ := configSvc.GetByKey("rustfs_bucket")
		domain, _ := configSvc.GetByKey("rustfs_domain")
		if endpoint == "" || accessKey == "" || secretKey == "" || bucket == "" {
			return nil, fmt.Errorf("rustfs storage is not fully configured")
		}
		if domain == "" {
			domain = endpoint
		}
		return NewRustFSStorage(endpoint, accessKey, secretKey, bucket, domain), nil
	default:
		return NewLocalStorage(uploadDir), nil
	}
}
