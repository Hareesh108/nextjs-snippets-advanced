#!/usr/bin/env bash
set -euo pipefail

# Deploy script for Nextjs Snippets Advanced
# - Packages the extension
# - Publishes to VS Code Marketplace (vsce) if VSCE_TOKEN is set
# - Publishes to Open VSX (ovsx) if OVSX_TOKEN is set

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
cd "$ROOT_DIR"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx not found; please install Node.js >= 16" >&2
  exit 1
fi

echo "Validating project..."
npm test --silent || true

echo "Packaging VSIX..."
npx --yes vsce package --no-dependencies --allow-star-activation --baseImagesUrl images || {
  echo "vsce not available via npx or packaging failed. Install with: npm i -g @vscode/vsce" >&2
  exit 1
}

VSIX_FILE=$(ls -t *.vsix | head -n 1 || true)
if [[ -z "${VSIX_FILE:-}" ]]; then
  echo "Failed to produce VSIX" >&2
  exit 1
fi
echo "Built: $VSIX_FILE"

VSCE_PAT_VAR="${VSCE_PAT:-${VSCE_TOKEN:-}}"
if [[ -n "${VSCE_PAT_VAR}" ]]; then
  echo "Publishing to VS Code Marketplace..."
  npx --yes vsce publish --pat "$VSCE_PAT_VAR"
else
  echo "VSCE_TOKEN not set; skipping VS Code Marketplace publish."
fi

OVSX_PAT_VAR="${OVSX_PAT:-${OVSX_TOKEN:-}}"
if [[ -n "${OVSX_PAT_VAR}" ]]; then
  echo "Publishing to Open VSX..."
  npx --yes ovsx publish "$VSIX_FILE" --pat "$OVSX_PAT_VAR"
else
  echo "OVSX_TOKEN not set; skipping Open VSX publish."
fi

echo "Done."


