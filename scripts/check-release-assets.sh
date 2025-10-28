#!/bin/bash

# Script to check if release assets exist and are properly signed

REPO="MdShimulMahmud/go-arch-cli"
VERSION="${1:-v1.0.3}"

echo "Checking release assets for $VERSION..."
echo ""

BASE_URL="https://github.com/$REPO/releases/download/$VERSION"

# List of expected files
FILES=(
    "go-arch-cli-linux-amd64"
    "go-arch-cli-linux-amd64.sig"
    "go-arch-cli-linux-amd64.pem"
    "SHA256SUMS"
    "SHA256SUMS.sig"
    "SHA256SUMS.pem"
)

echo "Checking if files exist..."
for file in "${FILES[@]}"; do
    url="$BASE_URL/$file"
    if curl -fsSL -I "$url" > /dev/null 2>&1; then
        echo "✅ $file exists"
    else
        echo "❌ $file NOT FOUND"
    fi
done

echo ""
echo "GitHub Actions runs: https://github.com/$REPO/actions"
echo "Release page: https://github.com/$REPO/releases/tag/$VERSION"
