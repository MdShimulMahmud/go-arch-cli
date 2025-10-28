#!/bin/bash
set -e

# Go Architecture CLI - Secure Installation Script
# This script downloads and installs go-arch-cli with signature verification

REPO="MdShimulMahmud/go-arch-cli"
BINARY_NAME="go-arch-cli"
# Optional parameter: version tag to install (defaults to latest)
VERSION_TAG="$1"
INSTALL_DIR="${2:-$HOME/.local/bin}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install cosign if not present
install_cosign() {
    if ! command_exists cosign; then
        log_info "Installing Cosign for signature verification..."
        local cosign_url="https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            cosign_url="https://github.com/sigstore/cosign/releases/latest/download/cosign-darwin-amd64"
        fi
        
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        curl -sLO "$cosign_url"
        chmod +x cosign-*
        
        # Try to install to system location, fallback to user location
        if sudo mv cosign-* /usr/local/bin/cosign 2>/dev/null; then
            log_success "Cosign installed to /usr/local/bin/cosign"
        else
            mkdir -p "$HOME/.local/bin"
            mv cosign-* "$HOME/.local/bin/cosign"
            log_success "Cosign installed to $HOME/.local/bin/cosign"
            
            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                log_warning "Add $HOME/.local/bin to your PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
            fi
        fi
        
        cd - >/dev/null
        rm -rf "$temp_dir"
    else
        log_info "Cosign is already installed"
    fi
}

# Detect OS and architecture
detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    
    case "$arch" in
        x86_64|amd64) arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *) log_error "Unsupported architecture: $arch"; exit 1 ;;
    esac
    
    case "$os" in
        linux) platform="linux-${arch}" ;;
        darwin) platform="darwin-${arch}" ;;
        *) log_error "Unsupported OS: $os"; exit 1 ;;
    esac
    
    echo "$platform"
}

# Get latest release version
get_latest_version() {
    log_info "Fetching latest release version..."
    local version=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -z "$version" ]]; then
        log_error "Failed to fetch latest version"
        exit 1
    fi
    echo "$version"
}

# Download file with progress
download_file() {
    local url="$1"
    local output="$2"
    log_info "Downloading $(basename "$output")..."
    
    if command_exists curl; then
        curl -fsSL --progress-bar "$url" -o "$output"
    elif command_exists wget; then
        wget --progress=bar:force "$url" -O "$output"
    else
        log_error "Neither curl nor wget is available"
        exit 1
    fi
}

# Verify file signature
verify_signature() {
    local file="$1"
    local signature="$2"
    local certificate="$3"
    
    log_info "Verifying signature for $(basename "$file")..."
    
    if ! cosign verify-blob --signature "$signature" --certificate "$certificate" "$file" >/dev/null 2>&1; then
        log_error "Signature verification failed for $(basename "$file")"
        return 1
    fi
    
    log_success "Signature verified for $(basename "$file")"
}

# Verify checksums
verify_checksums() {
    local binary_file="$1"
    local checksum_file="$2"
    
    log_info "Verifying checksums..."
    
    local expected_checksum=$(grep "$(basename "$binary_file")" "$checksum_file" | cut -d' ' -f1)
    if [[ -z "$expected_checksum" ]]; then
        log_error "Checksum not found for $(basename "$binary_file")"
        return 1
    fi
    
    local actual_checksum
    if command_exists sha256sum; then
        actual_checksum=$(sha256sum "$binary_file" | cut -d' ' -f1)
    elif command_exists shasum; then
        actual_checksum=$(shasum -a 256 "$binary_file" | cut -d' ' -f1)
    else
        log_warning "No SHA256 tool available, skipping checksum verification"
        return 0
    fi
    
    if [[ "$expected_checksum" != "$actual_checksum" ]]; then
        log_error "Checksum verification failed"
        log_error "Expected: $expected_checksum"
        log_error "Actual: $actual_checksum"
        return 1
    fi
    
    log_success "Checksum verified"
}

main() {
    log_info "Starting secure installation of go-arch-cli..."
    
    # Check for required tools
    if ! command_exists curl && ! command_exists wget; then
        log_error "Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
    
    # Install cosign for signature verification
    install_cosign
    
    # Detect platform
    local platform=$(detect_platform)
    log_info "Detected platform: $platform"
    
    # Determine version to download
    local version="${VERSION_TAG:-}"
    if [[ -z "$version" ]]; then
        version=$(get_latest_version)
    fi
    log_info "Using version: $version"
    
    # Set up file names
    local binary_name="${BINARY_NAME}-${platform}"
    [[ "$platform" == *"windows"* ]] && binary_name="${binary_name}.exe"
    
    local base_url="https://github.com/$REPO/releases/download/$version"
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download binary and verification files
    download_file "$base_url/$binary_name" "$binary_name"
    download_file "$base_url/${binary_name}.sig" "${binary_name}.sig"
    download_file "$base_url/${binary_name}.pem" "${binary_name}.pem"
    download_file "$base_url/SHA256SUMS" "SHA256SUMS"
    download_file "$base_url/SHA256SUMS.sig" "SHA256SUMS.sig"
    download_file "$base_url/SHA256SUMS.pem" "SHA256SUMS.pem"
    
    # Verify checksums file signature first
    if ! verify_signature "SHA256SUMS" "SHA256SUMS.sig" "SHA256SUMS.pem"; then
        log_error "Checksum file signature verification failed"
        exit 1
    fi
    
    # Verify binary signature
    if ! verify_signature "$binary_name" "${binary_name}.sig" "${binary_name}.pem"; then
        log_error "Binary signature verification failed"
        exit 1
    fi
    
    # Verify checksums
    if ! verify_checksums "$binary_name" "SHA256SUMS"; then
        log_error "Checksum verification failed"
        exit 1
    fi
    
    # Install binary
    mkdir -p "$INSTALL_DIR"
    local install_path="$INSTALL_DIR/$BINARY_NAME"
    
    cp "$binary_name" "$install_path"
    chmod +x "$install_path"
    
    log_success "go-arch-cli installed to $install_path"
    
    # Verify installation
    if "$install_path" --version >/dev/null 2>&1; then
        log_success "Installation verified successfully"
        log_info "Version: $("$install_path" --version)"
    else
        log_error "Installation verification failed"
        exit 1
    fi
    
    # Clean up
    cd - >/dev/null
    rm -rf "$temp_dir"
    
    # Add to PATH if needed
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        log_warning "Add $INSTALL_DIR to your PATH:"
        log_warning "  export PATH=\"$INSTALL_DIR:\$PATH\""
        log_warning "Or add it to your shell profile (~/.bashrc, ~/.zshrc, etc.)"
    fi
    
    log_success "Installation completed successfully!"
    log_info "Run 'go-arch-cli --help' to get started"
}

# Run main function
main "$@"