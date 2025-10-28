# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-27

### Added
- Initial release of Go Architecture CLI
- Support for 11 different Go project architectures:
  - Flat structure
  - Domain-Driven Design (DDD)
  - Clean Architecture
  - Feature-based structure
  - Hexagonal Architecture
  - Modular monolith
  - Monorepo structure
  - Command Query Responsibility Segregation (CQRS)
  - Onion Architecture
  - Standard Go project layout
  - Layered architecture
- Interactive mode with dropdown architecture selection
- Non-interactive mode with command-line flags
- Enhanced tree preview of project structures
- Input validation for module names and architectures
- Comprehensive error handling with helpful messages
- Cross-platform support (Windows, macOS, Linux)
- Professional installation scripts
- Automated build system with Makefile
- GitHub Actions CI/CD workflows
- Comprehensive documentation

### Features
- `generate` command for creating project structures
- `--version` flag for version information
- `--arch` and `--module` flags for non-interactive usage
- Project preview before generation
- Overwrite protection for existing projects
- Professional output formatting with next steps

### Documentation
- Comprehensive README with installation and usage instructions
- Contributing guidelines for developers
- MIT License
- Installation scripts for all platforms
- GitHub Actions workflows for CI/CD

### Technical
- Built with Go 1.19+
- Uses Cobra CLI framework
- Uses Survey for interactive prompts
- Uses fuzzy finder (fzf-like via `go-fuzzyfinder`) for selection and stdin prompts for text/confirm
- Supports Go modules
- Cross-platform binary releases