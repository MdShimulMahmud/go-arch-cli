package cmd

import (
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/MdShimulMahmud/go-arch-cli/internal/generator"

	"github.com/AlecAivazis/survey/v2"
	"github.com/spf13/cobra"
)

var archFlag string
var moduleFlag string

// Supported architectures
var supportedArchitectures = []string{
	"flat", "ddd", "clean", "feature", "hexagonal",
	"modular", "monorepo", "cqrs", "onion", "common", "layered",
}

// validateModuleName checks if the module name is valid
func validateModuleName(module string) error {
	if module == "" {
		return fmt.Errorf("module name cannot be empty")
	}

	// Basic validation for Go module name
	moduleRegex := regexp.MustCompile(`^[a-zA-Z][a-zA-Z0-9._/\-]*[a-zA-Z0-9]$`)
	if !moduleRegex.MatchString(module) {
		return fmt.Errorf("invalid module name format: %s", module)
	}

	return nil
}

// validateArchitecture checks if the architecture is supported
func validateArchitecture(arch string) error {
	for _, supported := range supportedArchitectures {
		if arch == supported {
			return nil
		}
	}
	return fmt.Errorf("unsupported architecture: %s. Supported: %s",
		arch, strings.Join(supportedArchitectures, ", "))
}

// checkExistingProject checks if project directory already exists
func checkExistingProject(arch string) error {
	projectDir := fmt.Sprintf("project_%s", arch)
	if _, err := os.Stat(projectDir); !os.IsNotExist(err) {
		return fmt.Errorf("project directory '%s' already exists", projectDir)
	}
	return nil
}

var generateCmd = &cobra.Command{
	Use:   "generate",
	Short: "Generate Go project structure",
	Long: `Generate a Go project with the specified architecture pattern.

Supported architectures:
  flat        Simple flat structure
  ddd         Domain-Driven Design
  clean       Clean Architecture
  feature     Feature-based structure
  hexagonal   Hexagonal Architecture
  modular     Modular monolith
  monorepo    Monorepo structure
  cqrs        Command Query Responsibility Segregation
  onion       Onion Architecture
  common      Standard Go project layout
  layered     Layered architecture

Examples:
  go-arch-cli generate
  go-arch-cli generate -a clean -m github.com/user/project`,
	Run: func(cmd *cobra.Command, args []string) {
		var arch, module string

		// Use flags if provided
		if archFlag != "" && moduleFlag != "" {
			arch = archFlag
			module = moduleFlag

			// Validate inputs
			if err := validateArchitecture(arch); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}

			if err := validateModuleName(module); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}
		} else {
			// Interactive mode
			promptArch := &survey.Select{
				Message: "Select architecture:",
				Options: supportedArchitectures,
				Help:    "Choose the architecture pattern for your Go project",
			}
			if err := survey.AskOne(promptArch, &arch); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}

			promptModule := &survey.Input{
				Message: "Go module name:",
				Default: "github.com/user/project",
				Help:    "Enter a valid Go module name (e.g., github.com/username/project)",
			}
			if err := survey.AskOne(promptModule, &module); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}

			// Validate module name
			if err := validateModuleName(module); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}
		}

		// Check if project directory already exists
		if err := checkExistingProject(arch); err != nil {
			fmt.Printf("Warning: %v\n", err)
			var overwrite bool
			survey.AskOne(&survey.Confirm{
				Message: "Do you want to overwrite the existing directory?",
				Default: false,
			}, &overwrite)

			if !overwrite {
				fmt.Println("Generation cancelled.")
				return
			}
		}

		// Show project structure preview
		fmt.Printf("\nProject structure preview (%s):\n", arch)
		tree := generator.PreviewStructure(arch)
		fmt.Println(tree)

		// Confirm generation (skip if using flags)
		if archFlag == "" || moduleFlag == "" {
			var confirm bool
			if err := survey.AskOne(&survey.Confirm{
				Message: "Generate project?",
				Default: true,
			}, &confirm); err != nil {
				fmt.Printf("Error: %v\n", err)
				return
			}

			if !confirm {
				fmt.Println("Generation cancelled.")
				return
			}
		}

		// Generate project
		fmt.Println("Generating project...")
		if err := generator.GenerateProject(arch, module); err != nil {
			fmt.Printf("Error: Failed to generate project: %v\n", err)
			return
		}

		fmt.Printf("\n✅ Project generated successfully!\n")
		fmt.Printf("📁 Module: %s\n", module)
		fmt.Printf("🏗️  Architecture: %s\n", arch)
		fmt.Printf("📂 Location: ./project_%s/\n\n", arch)
		fmt.Println("Next steps:")
		fmt.Printf("  cd project_%s\n", arch)
		fmt.Println("  go mod tidy")
		fmt.Println("  go run .")
	},
}

func init() {
	rootCmd.AddCommand(generateCmd)
	generateCmd.Flags().StringVarP(&archFlag, "arch", "a", "", "Architecture type")
	generateCmd.Flags().StringVarP(&moduleFlag, "module", "m", "", "Go module name")
}
