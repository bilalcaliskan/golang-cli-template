package options

import (
	"github.com/bilalcaliskan/golang-cli-template/cmd/root/options"
	"github.com/spf13/cobra"
)

var fooOptions = &FooOptions{}

// FooOptions contains frequent command line and application options.
type FooOptions struct {
	// Bar is the dummy option
	*options.RootOptions
	Bar string
}

// GetFooOptions returns the pointer of GolangCliTemplateOptions
func GetFooOptions() *FooOptions {
	return fooOptions
}

func (opts *FooOptions) InitFlags(cmd *cobra.Command) {
	cmd.PersistentFlags().StringVarP(&opts.Bar, "bar", "", "", "")
}
