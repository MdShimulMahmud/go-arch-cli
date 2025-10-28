# Go Architecture CLI Makefile

# Variables
BINARY_NAME=go-arch-cli
VERSION=1.0.4
BUILD_DIR=build
DIST_DIR=dist

# Default target
.PHONY: all
all: clean build

# Build the application
.PHONY: build
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build -ldflags="-X 'github.com/MdShimulMahmud/go-arch-cli/cmd.Version=$(VERSION)'" -o $(BUILD_DIR)/$(BINARY_NAME)

# Build for multiple platforms
.PHONY: build-all
build-all: clean
	@echo "Building for multiple platforms..."
	@mkdir -p $(DIST_DIR)
	
	# Windows
	GOOS=windows GOARCH=amd64 go build -ldflags="-X 'github.com/MdShimulMahmud/go-arch-cli/cmd.Version=$(VERSION)'" -o $(DIST_DIR)/$(BINARY_NAME)-windows-amd64.exe
	
	# Linux
	GOOS=linux GOARCH=amd64 go build -ldflags="-X 'github.com/MdShimulMahmud/go-arch-cli/cmd.Version=$(VERSION)'" -o $(DIST_DIR)/$(BINARY_NAME)-linux-amd64
	
	# macOS
	GOOS=darwin GOARCH=amd64 go build -ldflags="-X 'github.com/MdShimulMahmud/go-arch-cli/cmd.Version=$(VERSION)'" -o $(DIST_DIR)/$(BINARY_NAME)-darwin-amd64
	GOOS=darwin GOARCH=arm64 go build -ldflags="-X 'github.com/MdShimulMahmud/go-arch-cli/cmd.Version=$(VERSION)'" -o $(DIST_DIR)/$(BINARY_NAME)-darwin-arm64

# Install the binary to local system
.PHONY: install
install: build
	@echo "Installing $(BINARY_NAME)..."
	@cp $(BUILD_DIR)/$(BINARY_NAME) /usr/local/bin/ || cp $(BUILD_DIR)/$(BINARY_NAME).exe $(USERPROFILE)/bin/ || echo "Please add $(BUILD_DIR)/$(BINARY_NAME) to your PATH manually"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR) $(DIST_DIR)

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	go test -v ./...

# Format code
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	go fmt ./...

# Lint code
.PHONY: lint
lint:
	@echo "Linting code..."
	golangci-lint run

# Run the application
.PHONY: run
run:
	@echo "Running $(BINARY_NAME)..."
	go run .

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all        - Clean and build the application"
	@echo "  build      - Build the application"
	@echo "  build-all  - Build for multiple platforms"
	@echo "  install    - Install the binary to local system"
	@echo "  clean      - Remove build artifacts"
	@echo "  test       - Run tests"
	@echo "  fmt        - Format code"
	@echo "  lint       - Lint code"
	@echo "  run        - Run the application"
	@echo "  help       - Show this help message"