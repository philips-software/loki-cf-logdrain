package handlers_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/philips-software/loki-cf-logdrain/handlers"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

var statusJSON = "{\"status\":\"UP\"}\n"

func TestHealth(t *testing.T) {
	// Setup
	e := echo.New()
	req := httptest.NewRequest(echo.GET, "/health", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	healthHandler := &handlers.HealthHandler{}
	handler := healthHandler.Handler(context.Background(), nil)

	// Assertions
	if assert.NoError(t, handler(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(t, statusJSON, rec.Body.String())
	}
}
