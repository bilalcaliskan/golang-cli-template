package options

var golangCliTemplateOptions = &GolangCliTemplateOptions{}

// GolangCliTemplateOptions contains frequent command line and application options.
type GolangCliTemplateOptions struct {
	// Foo is the dummy option
	Foo string
}

// GetGolangCliTemplateOptions returns the pointer of OreillyTrialOptions
func GetGolangCliTemplateOptions() *GolangCliTemplateOptions {
	return golangCliTemplateOptions
}
