package options

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

// TestGetGolangCliTemplateOptions function tests if GetGolangCliTemplateOptions function running properly
func TestGetGolangCliTemplateOptions(t *testing.T) {
	t.Log("fetching default options.GolangCliTemplate")
	opts := GetGolangCliTemplateOptions()
	assert.NotNil(t, opts)
	t.Logf("fetched default options.GolangCliTemplateOptions, %v\n", opts)
}
