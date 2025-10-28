#!/bin/bash

# Go Architecture CLI Installation Script

set -e

BINARY_NAME="go-arch-cli"
REPO="MdShimulMahmud/go-arch-cli"
# Allow passing a version tag as first argument (defaults to latest)
VERSION_ARG="$1"
INSTALL_DIR="/usr/local/bin"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for system-wide installation
check_permissions() {
    if [[ $EUID -ne 0 && "$INSTALL_DIR" == "/usr/local/bin" ]]; then
        print_warning "System-wide installation requires sudo privileges"
        print_info "You can also install to your home directory by setting INSTALL_DIR=\$HOME/bin"
        exit 1
    fi
}

# Detect OS and architecture
detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    
    case $OS in
        linux)
            PLATFORM="linux-${ARCH}"
            ;;
        darwin)
            PLATFORM="darwin-${ARCH}"
            ;;
        *)
            print_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac
    
    print_info "Detected platform: $PLATFORM"
}

# Download and install binary
install_binary() {
    print_info "Installing Go Architecture CLI..."
    
    # Create install directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"
    
    # Download release (use provided version if given)
    if [[ -n "${VERSION_ARG}" ]]; then
        DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION_ARG}/${BINARY_NAME}-${PLATFORM}"
    else
        DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}-${PLATFORM}"
    fi
    
    print_info "Downloading from: $DOWNLOAD_URL"
    
    if command -v curl >/dev/null 2>&1; then
        curl -L "$DOWNLOAD_URL" -o "$INSTALL_DIR/$BINARY_NAME"
    elif command -v wget >/dev/null 2>&1; then
        wget "$DOWNLOAD_URL" -O "$INSTALL_DIR/$BINARY_NAME"
    else
        print_error "Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
    
    # Make binary executable
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
    
    print_success "Go Architecture CLI installed to $INSTALL_DIR/$BINARY_NAME"
}

# Verify installation
verify_installation() {
    if command -v "$BINARY_NAME" >/dev/null 2>&1; then
        print_success "Installation verified successfully!"
        print_info "Version: $($BINARY_NAME --version)"
    else
        print_warning "Binary installed but not in PATH. Please add $INSTALL_DIR to your PATH."
        echo "Add this line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
}

# Build from source (fallback)
build_from_source() {
    print_info "Building from source..."
    
    # Check if Go is installed
    if ! command -v go >/dev/null 2>&1; then
        print_error "Go is not installed. Please install Go first: https://golang.org/dl/"
        exit 1
    fi
    
    # Clone repository
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    print_info "Cloning repository..."
    git clone "https://github.com/${REPO}.git"
    cd "$(basename "$REPO")"
    
    # Build binary
    print_info "Building binary..."
    go build -o "$INSTALL_DIR/$BINARY_NAME"
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    print_success "Built and installed from source"
}

# Main installation process
main() {
    print_info "Go Architecture CLI Installation Script"
    echo "========================================"
    
    # Allow custom install directory
    if [[ -n "$1" ]]; then
        INSTALL_DIR="$1"
        print_info "Using custom install directory: $INSTALL_DIR"
    fi
    
    check_permissions
    detect_platform
    
    # Try to install binary, fallback to source build
    if ! install_binary 2>/dev/null; then
        print_warning "Failed to download binary, trying to build from source..."
        build_from_source
    fi
    
    verify_installation
    
    echo ""
    print_success "Installation complete!"
    print_info "Try running: $BINARY_NAME generate --help"
}

# Run main function
main "$@"