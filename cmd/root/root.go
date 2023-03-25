package root

import (
	"context"
	"os"

	"github.com/bilalcaliskan/golang-cli-template/cmd/foo"
	"github.com/bilalcaliskan/golang-cli-template/cmd/root/options"

	"github.com/bilalcaliskan/golang-cli-template/internal/logging"
	"github.com/bilalcaliskan/golang-cli-template/internal/version"
	"github.com/spf13/cobra"
)

var (
	opts *options.RootOptions
	ver  = version.Get()
	//bannerFilePath = "build/ci/banner.txt"
)

func init() {
	opts = options.GetRootOptions()
	opts.InitFlags(rootCmd)

	rootCmd.AddCommand(foo.FooCmd)
}

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:     "golang-cli-template",
	Short:   "",
	Long:    ``,
	Version: ver.GitVersion,
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		//if _, err := os.Stat("build/ci/banner.txt"); err == nil {
		//	bannerBytes, _ := os.ReadFile("build/ci/banner.txt")
		//	banner.Init(os.Stdout, true, false, strings.NewReader(string(bannerBytes)))
		//}

		logger := logging.GetLogger()
		logger.Info().Str("appVersion", ver.GitVersion).Str("goVersion", ver.GoVersion).Str("goOS", ver.GoOs).
			Str("goArch", ver.GoArch).Str("gitCommit", ver.GitCommit).Str("buildDate", ver.BuildDate).
			Msg("golang-cli-template is started!")

		cmd.SetContext(context.WithValue(cmd.Context(), options.LoggerKey{}, logger))
		cmd.SetContext(context.WithValue(cmd.Context(), options.OptsKey{}, opts))

		return nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
