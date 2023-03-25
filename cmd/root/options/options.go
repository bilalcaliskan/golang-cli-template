package options

import "github.com/spf13/cobra"

var rootOptions = &RootOptions{}

type (
	OptsKey   struct{}
	LoggerKey struct{}
)

// RootOptions contains frequent command line and application options.
type RootOptions struct {
	// Key is the dummy option
	Key string
}

// GetRootOptions returns the pointer of GolangCliTemplateOptions
func GetRootOptions() *RootOptions {
	return rootOptions
}

func (opts *RootOptions) InitFlags(cmd *cobra.Command) {
	cmd.PersistentFlags().StringVarP(&opts.Key, "key", "", "", "")
}
