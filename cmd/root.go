package cmd

import (
	"os"

	"github.com/bilalcaliskan/golang-cli-template/internal/logging"
	"github.com/bilalcaliskan/golang-cli-template/internal/options"
	"github.com/bilalcaliskan/golang-cli-template/internal/version"
	"github.com/spf13/cobra"
	"go.uber.org/zap"
)

var (
	opts *options.GolangCliTemplateOptions
	ver  = version.Get()
)

func init() {
	opts = options.GetGolangCliTemplateOptions()
	rootCmd.PersistentFlags().StringVarP(&opts.Foo, "foo", "", "", "")
}

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:     "golang-cli-template",
	Short:   "",
	Long:    ``,
	Version: ver.GitVersion,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		/*if _, err := os.Stat("build/ci/banner.txt"); err == nil {
			bannerBytes, _ := os.ReadFile("build/ci/banner.txt")
			banner.Init(os.Stdout, true, false, strings.NewReader(string(bannerBytes)))
		}*/

		logging.GetLogger().Info("golang-cli-template is started",
			zap.String("appVersion", ver.GitVersion),
			zap.String("goVersion", ver.GoVersion),
			zap.String("goOS", ver.GoOs),
			zap.String("goArch", ver.GoArch),
			zap.String("gitCommit", ver.GitCommit),
			zap.String("buildDate", ver.BuildDate))
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
