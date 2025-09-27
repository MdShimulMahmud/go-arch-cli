package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var Version = "1.0.0"

var rootCmd = &cobra.Command{
	Use:     "go-arch-cli",
	Short:   "Generate Go project architectures",
	Long:    "A CLI tool to generate Go projects with different architectural patterns.",
	Version: Version,
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
