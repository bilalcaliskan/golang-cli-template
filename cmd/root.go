package cmd

import (
	"github.com/bilalcaliskan/golang-cli-template/internal/logging"
	"github.com/bilalcaliskan/golang-cli-template/internal/options"
	"github.com/bilalcaliskan/golang-cli-template/internal/version"
	"github.com/spf13/cobra"
	_ "go.uber.org/automaxprocs"
	"go.uber.org/zap"
	"os"
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
	Run: func(cmd *cobra.Command, args []string) {
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
	/*bannerBytes, _ := ioutil.ReadFile("banner.txt")
	banner.Init(os.Stdout, true, false, strings.NewReader(string(bannerBytes)))*/

	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
