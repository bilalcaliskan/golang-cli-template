package cmd

import (
	"github.com/spf13/cobra"
	_ "go.uber.org/automaxprocs"
	"go.uber.org/zap"
	"golang-cli-template/internal/logging"
	"golang-cli-template/internal/options"
	"os"
)

func init() {
	opts := options.GetGolangCliTemplateOptions()
	rootCmd.PersistentFlags().StringVarP(&opts.Foo, "foo", "", "", "")
}

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "golang-cli-template",
	Short: "",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		opts := options.GetGolangCliTemplateOptions()
		logging.GetLogger().Info("", zap.Any("opts", opts))
		/*if err := oreilly.Generate(opts); err != nil {
			logging.GetLogger().Fatal("an error occurred while generating user", zap.String("error", err.Error()))
		}*/
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
