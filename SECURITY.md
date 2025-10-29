# Security Policy

## 🔒 Security Measures for Release Packages

This document outlines the comprehensive security measures implemented for `go-arch-cli` release packages to ensure supply chain security and prevent tampering.

## 🛡️ Security Features

### 1. **Vulnerability Scanning**
- **Tool**: `govulncheck` (official Go vulnerability scanner)
- **Scope**: All dependencies and code paths
- **Frequency**: Every release build
- **Action**: Build fails if high-severity vulnerabilities found

### 2. **Security Linting**
- **Tool**: `gosec` (Go security analyzer)
- **Coverage**: Static analysis for common security issues
- **Output**: SARIF format for detailed reporting
- **Integration**: GitHub Security tab integration

### 3. **Hardened Build Process**
- **Static Compilation**: `CGO_ENABLED=0` for no external dependencies
- **Strip Symbols**: `-s -w` flags remove debug information
- **Build ID Removal**: `-buildid=` for reproducible builds
- **Trimmed Paths**: `-trimpath` removes local build paths
- **Static Linking**: `-extldflags '-static'` for self-contained binaries

### 4. **Reproducible Builds**
- **Fixed Timestamp**: `SOURCE_DATE_EPOCH=1640995200`
- **Deterministic Output**: Same source = same binary
- **Verification**: Community can verify build reproducibility

### 5. **Digital Signatures**
- **Tool**: Cosign (CNCF project)
- **Method**: Keyless signing with OIDC
- **Coverage**: All binaries, checksums, and SBOM
- **Verification**: Public transparency log

### 6. **Cryptographic Checksums**
- **SHA256**: Primary integrity verification
- **SHA512**: Additional security layer
- **Coverage**: All release binaries
- **Usage**: Users can verify download integrity

### 7. **Software Bill of Materials (SBOM)**
- **Format**: SPDX JSON
- **Tool**: Syft (Anchore)
- **Content**: Complete dependency inventory
- **Purpose**: Supply chain transparency

## 🔍 Verification Instructions

### Verify Binary Signatures

1. **Install Cosign**:
   ```bash
   # Linux/macOS
   curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
   sudo mv cosign-linux-amd64 /usr/local/bin/cosign
   sudo chmod +x /usr/local/bin/cosign
   ```

2. **Download Binary and Signature**:
   ```bash
   # Example for Linux binary
   VERSION="v1.0.4"  # Replace with actual version
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/go-arch-cli-linux-amd64
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/go-arch-cli-linux-amd64.sig
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/go-arch-cli-linux-amd64.pem
   ```

3. **Verify Signature**:
   ```bash
   cosign verify-blob \
     --signature go-arch-cli-linux-amd64.sig \
     --certificate go-arch-cli-linux-amd64.pem \
     go-arch-cli-linux-amd64
   ```

### Verify Checksums

1. **Download Checksums**:
   ```bash
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/SHA256SUMS
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/SHA512SUMS
   ```

2. **Verify Binary Integrity**:
   ```bash
   # Verify SHA256
   sha256sum -c SHA256SUMS
   
   # Verify SHA512
   sha512sum -c SHA512SUMS
   ```

### Inspect SBOM

1. **Download SBOM**:
   ```bash
   wget https://github.com/MdShimulMahmud/go-arch-cli/releases/download/${VERSION}/go-arch-cli-sbom.spdx.json
   ```

2. **View Dependencies**:
   ```bash
   # Pretty print the SBOM
   cat go-arch-cli-sbom.spdx.json | jq '.packages[] | select(.name != null) | {name: .name, version: .versionInfo}'
   ```

## 🚨 Reporting Security Vulnerabilities

If you discover a security vulnerability in go-arch-cli, please report it responsibly:

### Preferred Method: GitHub Security Advisories
1. Go to [Security Advisories](https://github.com/MdShimulMahmud/go-arch-cli/security/advisories)
2. Click "Report a vulnerability"
3. Provide detailed information about the vulnerability

### Email Contact
- **Email**: [security@yourdomain.com] (replace with actual security contact)
- **PGP Key**: [Provide PGP key if available]

### What to Include
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested remediation (if any)

## 🎯 Security Commitment

We are committed to:

- **Transparency**: All security measures are documented and verifiable
- **Rapid Response**: Security issues are addressed with high priority
- **Community Collaboration**: Working with security researchers and users
- **Continuous Improvement**: Regularly updating security practices

## 📋 Security Checklist for Users

Before using go-arch-cli in production:

- [ ] Download from official GitHub releases only
- [ ] Verify digital signatures with Cosign
- [ ] Check SHA256/SHA512 checksums
- [ ] Review the SBOM for unexpected dependencies
- [ ] Monitor security advisories for updates
- [ ] Use the latest available version
- [ ] Report any suspicious behavior

## 🔄 Update Policy

- **Security Updates**: Released immediately for critical vulnerabilities
- **Regular Updates**: Monthly security review and updates
- **Version Support**: Latest major version receives security updates
- **EOL Policy**: 6 months notice before ending security support

## 🌟 Supply Chain Security Standards

This project follows:

- **SLSA Level 2**: Supply-chain Levels for Software Artifacts
- **NIST SSDF**: Secure Software Development Framework
- **OpenSSF Best Practices**: Open Source Security Foundation guidelines

## 📚 Additional Resources

- [Go Security Policy](https://golang.org/security)
- [SLSA Framework](https://slsa.dev/)
- [Sigstore Documentation](https://docs.sigstore.dev/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

**Last Updated**: October 2025  
**Version**: 1.0.3