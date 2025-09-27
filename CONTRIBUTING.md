# Contributing to Go Architecture CLI

Thank you for your interest in contributing to Go Architecture CLI! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Code Style](#code-style)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

## Getting Started

### Prerequisites

- Go 1.19 or higher
- Git
- Basic knowledge of Go and CLI development

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/your-username/go-arch-cli.git
   cd go-arch-cli
   ```

2. **Set up upstream remote**
   ```bash
   git remote add upstream https://github.com/MdShimulMahmud/go-arch-cli.git
   ```

3. **Install dependencies**
   ```bash
   go mod download
   ```

4. **Build and test**
   ```bash
   make build
   ./build/go-arch-cli generate --help
   ```

## How to Contribute

### Reporting Issues

- Check existing issues before creating a new one
- Use the issue template if available
- Include clear steps to reproduce
- Add relevant labels

### Suggesting Features

- Open an issue with the "feature request" label
- Describe the feature and its use case
- Explain why it would be valuable to users

### Adding New Architectures

To add a new architecture pattern:

1. **Add architecture to supported list**
   ```go
   // cmd/generate.go
   var supportedArchitectures = []string{
       // ... existing architectures
       "your-new-architecture",
   }
   ```

2. **Implement generator function**
   ```go
   // internal/generator/generator.go
   func generateYourNewArchitecture(module string) error {
       // Implementation here
   }
   ```

3. **Add preview function**
   ```go
   func previewYourNewArchitecture() string {
       // Return tree structure
   }
   ```

4. **Update documentation**
   - Add description in README.md
   - Update help text in generate.go

## Code Style

### Go Conventions

- Follow standard Go formatting (`gofmt`)
- Use meaningful variable and function names
- Add comments for exported functions
- Keep functions small and focused

### Project Structure

```
go-arch-cli/
├── cmd/                 # CLI commands
├── internal/
│   └── generator/       # Project generation logic
├── docs/               # Documentation
├── scripts/            # Build and utility scripts
└── README.md
```

### Naming Conventions

- **Files**: snake_case (Go convention)
- **Functions**: camelCase with exported functions PascalCase
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE for package level, camelCase for local

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
go test -cover ./...

# Test specific architecture generation
./build/go-arch-cli generate -a clean -m test/project
```

### Writing Tests

- Add tests for new features
- Test both success and error cases
- Use table-driven tests when appropriate
- Mock external dependencies

Example test structure:
```go
func TestGenerateClean(t *testing.T) {
    tests := []struct {
        name    string
        module  string
        wantErr bool
    }{
        {"valid module", "github.com/user/project", false},
        {"invalid module", "", true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := generateClean(tt.module)
            if (err != nil) != tt.wantErr {
                t.Errorf("generateClean() error = %v, wantErr %v", err, tt.wantErr)
            }
        })
    }
}
```

## Submitting Changes

### Pull Request Process

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow code style guidelines
   - Add tests for new functionality
   - Update documentation

3. **Test your changes**
   ```bash
   make test
   make build
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add support for microservices architecture"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use a clear title and description
   - Reference related issues
   - Add screenshots for UI changes

### Commit Message Convention

Use conventional commits format:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Build process or auxiliary tool changes

Examples:
```
feat: add hexagonal architecture support
fix: resolve module name validation issue
docs: update installation instructions
```

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Added tests for new functionality
- [ ] All existing tests pass
- [ ] Manually tested changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review of code completed
- [ ] Documentation updated
- [ ] No new warnings introduced
```

## Release Process

### Version Numbering

We use semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

### Release Checklist

- [ ] Update version in cmd/root.go
- [ ] Update CHANGELOG.md
- [ ] Create release tag
- [ ] Build binaries for all platforms
- [ ] Update documentation

## Getting Help

- **Documentation**: Check README.md and docs/
- **Issues**: Search existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions
- **Discord/Slack**: [Link if available]

## Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes
- GitHub contributors graph

Thank you for contributing to Go Architecture CLI! 🚀