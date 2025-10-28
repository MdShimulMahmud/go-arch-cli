package cmd

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"

	"github.com/MdShimulMahmud/go-arch-cli/internal/generator"
	"github.com/spf13/cobra"
	"golang.org/x/term"
)

var archFlag string
var moduleFlag string
var noFuzzy bool

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
			// Select architecture using robust fallback:
			// 1) go-fuzzyfinder when running in a TTY
			// 2) external fzf if present
			// 3) numeric menu fallback
			sel, err := selectArchitecture(supportedArchitectures)
			if err != nil {
				fmt.Printf("Error selecting architecture: %v\n", err)
				return
			}
			arch = sel

			// Prompt for module name using stdin
			reader := bufio.NewReader(os.Stdin)
			fmt.Printf("Go module name [%s]: ", "github.com/user/project")
			input, _ := reader.ReadString('\n')
			input = strings.TrimSpace(input)
			if input == "" {
				module = "github.com/user/project"
			} else {
				module = input
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
			// simple confirm prompt
			reader := bufio.NewReader(os.Stdin)
			fmt.Printf("Do you want to overwrite the existing directory? [y/N]: ")
			resp, _ := reader.ReadString('\n')
			resp = strings.TrimSpace(resp)
			if resp == "" {
				overwrite = false
			} else {
				overwrite = strings.HasPrefix(strings.ToLower(resp), "y")
			}

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
			// confirm generation via stdin
			reader := bufio.NewReader(os.Stdin)
			fmt.Printf("Generate project? [Y/n]: ")
			resp, _ := reader.ReadString('\n')
			resp = strings.TrimSpace(resp)
			var confirm bool
			if resp == "" {
				confirm = true
			} else {
				confirm = strings.HasPrefix(strings.ToLower(resp), "y")
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
	generateCmd.Flags().BoolVar(&noFuzzy, "no-fuzzy", false, "Disable fuzzy UI and use numeric selection")
}

// selectArchitecture chooses an architecture from the provided list using a
// production-ready strategy: external fzf (if present and allowed) -> numeric menu.
func selectArchitecture(options []string) (string, error) {
	// If the user disabled fuzzy, skip trying external fzf
	if !noFuzzy {
		// Only try fzf in interactive terminals
		if term.IsTerminal(int(os.Stdout.Fd())) {
			if path, err := exec.LookPath("fzf"); err == nil && path != "" {
				out, err := runExternalFzf(options)
				if err == nil {
					sel := strings.TrimSpace(out)
					for _, o := range options {
						if o == sel {
							return o, nil
						}
					}
				}
			}
		}
	}

	// Numeric fallback: print numbered list and ask user
	fmt.Println()
	for i, o := range options {
		fmt.Printf("%2d) %s\n", i+1, o)
	}
	fmt.Print("Select architecture by number: ")
	reader := bufio.NewReader(os.Stdin)
	for {
		line, err := reader.ReadString('\n')
		if err != nil && err != io.EOF {
			return "", err
		}
		line = strings.TrimSpace(line)
		if line == "" {
			fmt.Print("Please enter a number: ")
			continue
		}
		n, err := strconv.Atoi(line)
		if err != nil || n < 1 || n > len(options) {
			fmt.Printf("Invalid selection. Enter 1-%d: ", len(options))
			continue
		}
		return options[n-1], nil
	}
}

func runExternalFzf(options []string) (string, error) {
	cmd := exec.Command("fzf", "--ansi")
	// pipe options into fzf stdin
	stdin, err := cmd.StdinPipe()
	if err != nil {
		return "", err
	}
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = os.Stderr

	if err := cmd.Start(); err != nil {
		stdin.Close()
		return "", err
	}
	for _, o := range options {
		io.WriteString(stdin, o+"\n")
	}
	stdin.Close()
	if err := cmd.Wait(); err != nil {
		return "", err
	}
	return out.String(), nil
}
