package handler

import "github.com/gin-gonic/gin"

func getUserID(c *gin.Context) uint {
	if uid, exists := c.Get("user_id"); exists {
		return uint(uid.(float64))
	}
	return 0
}
