# Go Project Architecture CLI

[![CI](https://github.com/MdShimulMahmud/go-arch-cli/workflows/CI/badge.svg)](https://github.com/MdShimulMahmud/go-arch-cli/actions)
[![Go Version](https://img.shields.io/github/go-mod/go-version/MdShimulMahmud/go-arch-cli)](https://golang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A command-line tool to generate Go projects with different architectural patterns. This tool helps developers quickly scaffold Go projects with well-organized, industry-standard architectural structures.

## Features

- **11 Architecture Patterns**: Support for popular Go project architectures
- **Interactive Mode**: User-friendly selection (prefers external `fzf` when available) with project preview. Falls back to a simple numeric menu when `fzf` isn't present. Use `--no-fuzzy` to disable fuzzy selection in CI or scripted runs.
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

Choose your installation method based on your security requirements:

### Option 1: Quick Installation (Standard)

Fast installation without signature verification. Suitable for development environments and quick testing.

#### Linux/macOS
```bash
# Install latest version
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.sh | bash

# Install to custom directory
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.sh | bash -s -- "v1.0.5" "$HOME/bin"
```

#### Windows
```powershell
# Download and run installation script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install.bat -OutFile install.bat
.\install.bat
```

**What it does:**
- Downloads the binary from GitHub releases
- Installs to `/usr/local/bin` (Linux/macOS) or `C:\Program Files\go-arch-cli` (Windows)
- No signature verification

---

### Option 2: 🔒 Secure Installation (Recommended for Production)

Installation with full cryptographic verification. **Recommended for production environments, CI/CD pipelines, and security-conscious users.**

#### Linux/macOS
```bash
# Install latest version with signature verification
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install-secure.sh | bash

# Install to custom directory (defaults to $HOME/.local/bin)
curl -fsSL https://raw.githubusercontent.com/MdShimulMahmud/go-arch-cli/master/install-secure.sh | bash -s -- "v1.0.5" "$HOME/bin"
```

**What it does:**
- ✅ Installs cosign if not present
- ✅ Verifies binary signatures using Cosign (keyless OIDC)
- ✅ Verifies SHA256 checksums
- ✅ Ensures supply chain integrity
- ✅ Fails if any verification step fails

**Security guarantees:**
- Cryptographic proof that binaries were built by the official CI pipeline
- Protection against tampered or malicious binaries
- Checksum verification ensures file integrity during download

---

###Other Installation Methods

#### Using Go Install
```bash
go install github.com/MdShimulMahmud/go-arch-cli@latest
```

**Note:** The Go module proxy may cache older versions. To ensure you get the latest version, use:
```bash
GOPROXY=direct go install github.com/MdShimulMahmud/go-arch-cli@v1.0.5
```

#### From Source
```bash
git clone https://github.com/MdShimulMahmud/go-arch-cli.git
cd go-arch-cli
make build
# Binary will be in ./build/go-arch-cli
```

#### Direct Download

Download pre-built binaries from the [releases page](https://github.com/MdShimulMahmud/go-arch-cli/releases).

For manual verification instructions, see the [Security](#-security) section below.

## 🔒 Security

All release binaries are secured with multiple verification mechanisms:

- **🔐 Digital Signatures**: All binaries signed with Cosign (keyless OIDC)
- **✅ Checksums**: SHA256 and SHA512 hashes provided
- **🛡️ Vulnerability Scanning**: Dependencies scanned with govulncheck
- **📋 SBOM**: Software Bill of Materials included
- **🏗️ Hardened Builds**: Static compilation with security flags
- **🔍 Reproducible Builds**: Deterministic build process

### Manual Verification Example

If you download binaries manually, you can verify them:

```bash
# Example: Verify Linux AMD64 binary for v1.0.5
# Download binary and verification files
wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/v1.0.5/go-arch-cli-linux-amd64
wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/v1.0.5/go-arch-cli-linux-amd64.sig
wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/v1.0.5/go-arch-cli-linux-amd64.pem
wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/v1.0.5/SHA256SUMS

# Verify signature (requires cosign)
cosign verify-blob \
  --signature go-arch-cli-linux-amd64.sig \
  --certificate go-arch-cli-linux-amd64.pem \
  go-arch-cli-linux-amd64

# Verify checksum
sha256sum -c SHA256SUMS --ignore-missing
```

For detailed security information, see [SECURITY.md](SECURITY.md).

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

## Architecture Patterns & Project Structures

### 🏗️ Flat Structure
**Best for**: Small projects, prototypes, simple applications
```
project_flat/
├── main.go           # Application entry point
├── handler.go        # HTTP handlers
├── service.go        # Business logic
├── repository.go     # Data access layer
├── config.go         # Configuration management
├── utils.go          # Utility functions
├── README.md         # Project documentation
├── .gitignore        # Git ignore patterns
└── go.mod            # Go module definition
```

### 🎯 Domain-Driven Design (DDD)
**Best for**: Complex domains, team separation by business domains
```
project_ddd/
├── cmd/
│   └── app/
│       └── main.go           # Application bootstrap
├── internal/
│   ├── user/                 # User domain
│   │   ├── handler.go        # User HTTP handlers
│   │   ├── service.go        # User business logic
│   │   ├── repository.go     # User data access
│   │   └── user.go           # User domain entity
│   └── product/              # Product domain
│       ├── handler.go        # Product HTTP handlers
│       ├── service.go        # Product business logic
│       └── repository.go     # Product data access
├── README.md
├── .gitignore
└── go.mod
```

### 🧹 Clean Architecture
**Best for**: Testable applications, dependency inversion, SOLID principles
```
project_clean/
├── cmd/
│   └── app/
│       └── main.go                 # Application entry point
├── internal/
│   ├── entities/
│   │   └── user.go                 # Core business entities
│   ├── usecases/
│   │   └── user_service.go         # Application business rules
│   ├── repository/
│   │   └── user_repo.go            # Data access interface implementation
│   └── delivery/
│       └── http/
│           └── user_handler.go     # HTTP delivery mechanism
├── README.md
├── .gitignore
└── go.mod
```

### 🌟 Feature-Based Structure
**Best for**: Large applications, feature teams, microservices preparation
```
project_feature/
├── cmd/
│   └── app/
│       └── main.go                     # Application bootstrap
├── internal/
│   ├── user/                           # User feature module
│   │   ├── handler/
│   │   │   └── user_handler.go         # User HTTP handlers
│   │   ├── service/
│   │   │   └── user_service.go         # User business logic
│   │   ├── repository/
│   │   │   └── user_repo.go            # User data access
│   │   └── user.go                     # User domain model
│   └── product/                        # Product feature module
│       ├── handler/
│       │   └── product_handler.go      # Product HTTP handlers
│       ├── service/
│       │   └── product_service.go      # Product business logic
│       ├── repository/
│       │   └── product_repo.go         # Product data access
│       └── product.go                  # Product domain model
├── pkg/
│   └── logger.go                       # Shared utilities
├── README.md
├── .gitignore
└── go.mod
```

### 🔆 Hexagonal Architecture (Ports & Adapters)
**Best for**: Highly testable applications, external system isolation
```
project_hexagonal/
├── cmd/
│   └── app/
│       └── main.go                     # Application bootstrap
├── internal/
│   ├── core/                           # Core business logic (hexagon center)
│   │   └── user/
│   │       ├── entity.go               # Core business entities
│   │       └── usecase.go              # Core business use cases
│   ├── adapters/                       # External adapters
│   │   ├── database/
│   │   │   └── user_repo.go            # Database adapter
│   │   └── api/
│   │       └── user_handler.go         # HTTP API adapter
│   └── ports/                          # Ports (interfaces)
│       ├── user_repository.go          # Repository port
│       └── user_service.go             # Service port
├── README.md
├── .gitignore
└── go.mod
```

### 🧩 Modular Monolith
**Best for**: Large teams, independent module development, gradual microservices migration
```
project_modular/
├── user_module/                        # Independent user module
│   ├── handler/                        # User HTTP handlers
│   ├── service/                        # User business logic
│   ├── repository/                     # User data access
│   ├── user.go                         # User domain model
│   └── go.mod                          # Module-specific dependencies
├── product_module/                     # Independent product module
│   ├── handler/                        # Product HTTP handlers
│   ├── service/                        # Product business logic
│   ├── repository/                     # Product data access
│   ├── product.go                      # Product domain model
│   └── go.mod                          # Module-specific dependencies
├── api_gateway/                        # API Gateway
│   ├── main.go                         # Gateway entry point
│   └── go.mod                          # Gateway dependencies
├── configs/                            # Shared configurations
├── README.md
└── .gitignore
```

### 🏢 Monorepo Structure
**Best for**: Multiple services, shared libraries, unified development
```
project_monorepo/
├── services/
│   └── user-service/                   # User microservice
│       ├── cmd/
│       │   └── main.go                 # Service entry point
│       ├── internal/
│       │   ├── handler/                # HTTP handlers
│       │   ├── service/                # Business logic
│       │   ├── repository/             # Data access
│       │   └── models/                 # Domain models
│       └── go.mod                      # Service dependencies
├── libs/                               # Shared libraries
│   ├── logging/                        # Shared logging library
│   ├── authentication/                 # Shared auth library
│   └── utils/                          # Common utilities
├── go.mod                              # Root module
├── README.md
└── .gitignore
```

### ⚡ CQRS (Command Query Responsibility Segregation)
**Best for**: High-performance applications, read/write separation, event sourcing
```
project_cqrs/
├── cmd/
│   └── app/
│       └── main.go                     # Application entry point
├── internal/
│   ├── commands/                       # Write operations
│   │   ├── create_user.go              # Create user command
│   │   ├── update_user.go              # Update user command
│   │   └── delete_user.go              # Delete user command
│   ├── queries/                        # Read operations
│   │   └── get_user.go                 # Get user query
│   ├── repositories/
│   │   └── user_repo.go                # Data persistence
│   ├── models/
│   │   └── user.go                     # Domain models
│   └── services/
│       └── user_service.go             # Business services
├── README.md
├── .gitignore
└── go.mod
```

### 🧅 Onion Architecture
**Best for**: Dependency inversion, testability, infrastructure independence
```
project_onion/
├── cmd/
│   └── your-app/
│       └── main.go                             # Application entry point
├── internal/
│   ├── domain/                                 # Core domain (innermost layer)
│   │   ├── entity.go                           # Domain entities
│   │   └── service.go                          # Domain services
│   ├── application/                            # Application layer
│   │   └── usecase.go                          # Application use cases
│   └── infrastructure/                         # Infrastructure layer (outermost)
│       ├── persistence/
│       │   └── repository.go                   # Data persistence
│       └── api/
│           └── handler.go                      # HTTP API
├── README.md
├── .gitignore
└── go.mod
```

### 📋 Common/Standard Go Layout
**Best for**: Large applications, open-source projects, following Go community standards
```
project_common/
├── cmd/
│   └── myapp/
│       └── main.go                             # Application entry point
├── internal/                                   # Private application code
│   ├── app/
│   │   └── myapp/
│   │       ├── handler.go                      # HTTP handlers
│   │       └── service.go                      # Business logic
│   ├── pkg/
│   │   └── myprivlib/                          # Private shared libraries
│   ├── domain/
│   │   ├── entity.go                           # Domain entities
│   │   └── service.go                          # Domain services
│   └── infrastructure/
│       ├── persistence/
│       │   └── repository.go                   # Data access
│       ├── api/
│       │   └── handler.go                      # API handlers
│       └── messaging/
│           └── producer.go                     # Message producers
├── pkg/
│   └── mypubliclib/                            # Public shared libraries
├── api/
│   └── api_spec.yaml                           # API specifications
├── web/
│   ├── static/                                 # Static web assets
│   └── templates/                              # HTML templates
├── configs/
│   └── config.yaml                             # Configuration files
├── init/
│   └── myapp.service                           # System init files
├── scripts/
│   ├── build.sh                                # Build scripts
│   └── install.sh                              # Installation scripts
├── build/
│   ├── package/                                # Packaging configs
│   └── ci/                                     # CI configurations
├── deployments/
│   └── kubernetes/                             # Deployment configs
├── test/
│   └── data/                                   # Test data
├── docs/
│   └── architecture.md                         # Documentation
├── tools/
│   └── mytool/                                 # Supporting tools
├── examples/
│   └── example_usage.go                        # Usage examples
├── third_party/                                # External tools/utilities
├── githooks/                                   # Git hooks
├── assets/                                     # Project assets
├── website/
│   └── index.html                              # Project website
├── README.md
├── .gitignore
└── go.mod
```

### 🏛️ Layered Architecture
**Best for**: Traditional MVC applications, familiar patterns, rapid development
```
project_layered/
├── cmd/
│   └── app/
│       └── main.go                     # Application entry point
├── internal/
│   ├── presentation/                   # Presentation layer
│   │   └── user_handler.go             # HTTP handlers/controllers
│   ├── service/                        # Service/business layer
│   │   └── user_service.go             # Business logic
│   ├── repository/                     # Data access layer
│   │   └── user_repo.go                # Data access objects
│   └── domain/                         # Domain/model layer
│       └── user.go                     # Domain entities/models
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

- Go 1.24 or higher
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
- Interactive selection: prefers external `fzf` binary (if available). The CLI falls back to a numeric selection menu when `fzf` is not installed. Use `--no-fuzzy` to force non-fuzzy behaviour (useful in CI).

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