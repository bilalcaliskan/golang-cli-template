package options

import (
	"testing"

	"github.com/spf13/cobra"
	"github.com/stretchr/testify/assert"
)

func TestGetFooOptions(t *testing.T) {
	opts := GetFooOptions()
	assert.NotNil(t, opts)
}

func TestFooOptions_InitFlags(t *testing.T) {
	cmd := cobra.Command{}
	opts := GetFooOptions()
	opts.InitFlags(&cmd)
}
