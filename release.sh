#!/usr/bin/env bash
set -euo pipefail

# release.sh
# Build cross-platform binaries, generate SHA256SUMS and optionally create a GitHub
# release using the gh CLI. Intended to be run locally for pre-release testing or
# CI when gh is available.

BINARY_NAME="go-arch-cli"
REPO="MdShimulMahmud/go-arch-cli"
VERSION_TAG="${1:-}"
OUTDIR="dist"

PLATFORMS=("linux amd64" "linux arm64" "darwin amd64" "darwin arm64" "windows amd64")

mkdir -p "$OUTDIR"

build_all() {
  echo "Building binaries into $OUTDIR..."
  for p in "${PLATFORMS[@]}"; do
    read -r GOOS GOARCH <<< "$p"
    ext=""
    if [[ "$GOOS" == "windows" ]]; then ext=".exe"; fi
    name="${BINARY_NAME}-${GOOS}-${GOARCH}${ext}"
    echo "- building $name"
    env GOOS="$GOOS" GOARCH="$GOARCH" go build -ldflags "-s -w" -o "$OUTDIR/$name" ./
  done
}

generate_checksums() {
  echo "Generating SHA256SUMS..."
  pushd "$OUTDIR" >/dev/null
  sha256sum * > SHA256SUMS || {
    # macOS: use shasum
    shasum -a 256 * > SHA256SUMS
  }
  popd >/dev/null
}

create_release() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found; skipping GitHub release creation. Install from https://cli.github.com/"
    return
  fi

  if [[ -z "$VERSION_TAG" ]]; then
    echo "No version tag provided. Please pass a tag like './release.sh v1.2.3' to create a GitHub release."
    return
  fi

  echo "Creating GitHub release for $VERSION_TAG"
  gh release create "$VERSION_TAG" "$OUTDIR"/* --title "$VERSION_TAG" --notes "Release $VERSION_TAG"
}

main() {
  if [[ -n "$VERSION_TAG" ]]; then
    echo "Preparing release for $VERSION_TAG"
  else
    echo "Preparing local distribution (no GitHub release will be made unless version provided)"
  fi
  rm -rf "$OUTDIR" && mkdir -p "$OUTDIR"
  build_all
  generate_checksums
  create_release
  echo "Done. Artifacts in $OUTDIR"
}

main "$@"
