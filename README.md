# Go Architecture CLI

A command-line tool to generate Go projects with different architectural patterns. This tool helps developers quickly scaffold Go projects with well-organized, industry-standard architectural structures.

## Features

- **11 Architecture Patterns**: Support for popular Go project architectures
- **Interactive Mode**: User-friendly dropdown selection with project preview
- **Non-Interactive Mode**: Command-line flags for automation and scripting
- **Enhanced Tree Preview**: Professional directory structure visualization
- **Input Validation**: Comprehensive validation for module names and architectures
- **Error Handling**: Clear error messages and helpful suggestions
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Easy Installation**: Multiple installation methods available
- **Production Ready**: Professional output with next steps guidance

## Supported Architectures

| Architecture | Description                                                 |
| ------------ | ----------------------------------------------------------- |
| `flat`       | Simple flat structure for small projects                    |
| `ddd`        | Domain-Driven Design with clear domain boundaries           |
| `clean`      | Clean Architecture with dependency inversion                |
| `feature`    | Feature-based structure organized by business functionality |
| `hexagonal`  | Hexagonal Architecture (Ports & Adapters pattern)           |
| `modular`    | Modular monolith with independent modules                   |
| `monorepo`   | Monorepo structure for multiple services                    |
| `cqrs`       | Command Query Responsibility Segregation                    |
| `onion`      | Onion Architecture with layered dependencies                |
| `common`     | Standard Go project layout (go-standards/project-layout)    |
| `layered`    | Traditional layered architecture (MVC-style)                |

## Installation

### Quick Install (Recommended)

#### Linux/macOS
```bash
# Download and run installation script
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.sh | bash

# Or with custom directory
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.sh | bash -s -- "$HOME/bin"
```

#### Windows
```powershell
# Download and run installation script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.bat -OutFile install.bat && .\install.bat
```

### From Source

```bash
git clone https://github.com/MdShimulMahmud/go-arch-cli.git
cd go-arch-cli
make build
# Binary will be in ./build/go-arch-cli
```

### Using Go Install

```bash
go install github.com/MdShimulMahmud/go-arch-cli@latest
```

### Direct Download

Download the latest binary from the [releases page](https://github.com/MdShimulMahmud/go-arch-cli/releases).

## Usage

### Interactive Mode

Run the tool without any flags to use the interactive mode:

```bash
go-arch-cli generate
```

This will prompt you to:
1. Select an architecture from a dropdown menu
2. Enter your Go module name
3. Preview the project structure
4. Confirm generation

### Non-Interactive Mode

Use command-line flags for automation:

```bash
go-arch-cli generate -a <architecture> -m <module-name>
```

#### Examples

```bash
# Generate a clean architecture project
go-arch-cli generate -a clean -m github.com/user/my-project

# Generate a DDD project
go-arch-cli generate -a ddd -m github.com/company/service

# Generate a hexagonal architecture project
go-arch-cli generate -a hexagonal -m github.com/user/hexagonal-app
```

## Command Reference

### Main Command

```
go-arch-cli generate [flags]
```

### Flags

- `-a, --arch string`: Architecture type (required for non-interactive mode)
- `-m, --module string`: Go module name (required for non-interactive mode)
- `-h, --help`: Show help information

### Help Commands

```bash
# General help
go-arch-cli --help

# Generate command help
go-arch-cli generate --help
```

## Project Structure Examples

### Clean Architecture
```
project_clean/
├── cmd/app/main.go
├── internal/entities/user.go
├── internal/usecases/user_service.go
├── internal/repository/user_repo.go
├── internal/delivery/http/user_handler.go
├── README.md
├── .gitignore
└── go.mod
```

### DDD (Domain-Driven Design)
```
project_ddd/
├── cmd/app/main.go
├── internal/user/handler.go
├── internal/user/service.go
├── internal/user/repository.go
├── internal/user/user.go
├── internal/product/handler.go
├── internal/product/service.go
├── internal/product/repository.go
├── README.md
├── .gitignore
└── go.mod
```

### Hexagonal Architecture
```
project_hexagonal/
├── cmd/app/main.go
├── internal/core/user/entity.go
├── internal/core/user/usecase.go
├── internal/adapters/database/user_repo.go
├── internal/adapters/api/user_handler.go
├── internal/ports/user_repository.go
├── internal/ports/user_service.go
├── README.md
├── .gitignore
└── go.mod
```

## Generated Files

Each generated project includes:

- **main.go**: Application entry point
- **go.mod**: Go module file with your specified module name
- **README.md**: Project documentation with architecture information
- **.gitignore**: Standard Go gitignore patterns
- **Architecture-specific files**: Handlers, services, repositories, etc.

## Requirements

- Go 1.19 or higher
- Terminal with interactive support (for interactive mode)

## Development

### Building from Source

```bash
git clone https://github.com/MdShimulMahmud/go-arch-cli.git
cd go-arch-cli
go mod tidy
make build
```

### Available Make Targets

```bash
make build      # Build the application
make build-all  # Build for multiple platforms
make install    # Install to local system
make test       # Run tests
make clean      # Clean build artifacts
make fmt        # Format code
make help       # Show all available targets
```

### Testing

```bash
# Test interactive mode
./build/go-arch-cli generate

# Test non-interactive mode
./build/go-arch-cli generate -a clean -m test/project

# Run all tests
make test
```

## Dependencies

- [Cobra](https://github.com/spf13/cobra) - CLI framework
- [Survey](https://github.com/AlecAivazis/survey) - Interactive prompts

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by various Go project layout standards
- Architecture patterns from the Go community
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/MdShimulMahmud/go-arch-cli/issues) on GitHub.