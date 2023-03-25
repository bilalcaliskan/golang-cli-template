package foo

import (
	"github.com/bilalcaliskan/golang-cli-template/cmd/foo/options"

	rootopts "github.com/bilalcaliskan/golang-cli-template/cmd/root/options"

	"github.com/bilalcaliskan/golang-cli-template/internal/logging"
	"github.com/rs/zerolog"
	"github.com/spf13/cobra"
)

func init() {
	logger = logging.GetLogger()
	fooOpts = options.GetFooOptions()
	fooOpts.InitFlags(FooCmd)
}

var (
	logger  zerolog.Logger
	fooOpts *options.FooOptions
	// FooCmd represents the bar command
	FooCmd = &cobra.Command{
		Use:   "foo",
		Short: "",
		PreRunE: func(cmd *cobra.Command, args []string) error {
			logger = cmd.Context().Value(rootopts.LoggerKey{}).(zerolog.Logger)
			rootOpts := cmd.Context().Value(rootopts.OptsKey{}).(*rootopts.RootOptions)
			fooOpts.RootOptions = rootOpts

			// flag validation logic here

			return nil
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			logger.Info().Str("rootOptsKey", fooOpts.RootOptions.Key).Msg("hello guys")

			return nil
		},
	}
)
