package handler

import (
	"strconv"

	"github.com/gin-gonic/gin"
)

func getUserID(c *gin.Context) uint {
	if uid, exists := c.Get("user_id"); exists {
		return uint(uid.(float64))
	}
	return 0
}

// parseUint parses a URL path parameter as uint, returns 0 and sends 400 on error.
func parseUint(c *gin.Context, param string) (uint, bool) {
	id, err := strconv.ParseUint(param, 10, 32)
	if err != nil {
		BadRequest(c, "无效的ID参数")
		return 0, false
	}
	return uint(id), true
}

// defaultQueryInt returns the query parameter as int, or defaultVal if invalid.
func defaultQueryInt(c *gin.Context, key string, defaultVal int) int {
	v, err := strconv.Atoi(c.DefaultQuery(key, strconv.Itoa(defaultVal)))
	if err != nil || v < 1 {
		return defaultVal
	}
	return v
}

// parseUintOptional parses an optional query parameter. Returns 0 if empty.
func parseUintOptional(s string) (uint, bool) {
	if s == "" {
		return 0, true
	}
	v, err := strconv.ParseUint(s, 10, 32)
	if err != nil {
		return 0, false
	}
	return uint(v), true
}
