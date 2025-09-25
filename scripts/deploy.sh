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
npx --yes vsce package --no-dependencies --allow-star-activation || {
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
echo "Publishing to VS Code Marketplace..."
if npx --yes vsce publish; then
  echo "VS Code Marketplace publish succeeded."
else
  if [[ -n "${VSCE_PAT_VAR}" ]]; then
    echo "Retrying VS Code publish with PAT..."
    npx --yes vsce publish --pat "$VSCE_PAT_VAR" || {
      echo "VS Code publish failed. Ensure you're logged in (npx vsce login <publisher>) or set VSCE_PAT." >&2
      exit 1
    }
  else
    echo "VS Code publish failed. You're likely not logged in. Run: npx vsce login <publisher> or set VSCE_PAT and retry." >&2
    exit 1
  fi
fi

OVSX_PAT_VAR="${OVSX_PAT:-${OVSX_TOKEN:-}}"
echo "Publishing to Open VSX..."
if npx --yes ovsx publish "$VSIX_FILE"; then
  echo "Open VSX publish succeeded."
else
  if [[ -n "${OVSX_PAT_VAR}" ]]; then
    echo "Retrying Open VSX publish with PAT..."
    npx --yes ovsx publish "$VSIX_FILE" --pat "$OVSX_PAT_VAR" || {
      echo "Open VSX publish failed. Ensure you're logged in (npx ovsx login) or set OVSX_PAT." >&2
      exit 1
    }
  else
    echo "Open VSX publish failed. You're likely not logged in. Run: npx ovsx login or set OVSX_PAT and retry." >&2
    exit 1
  fi
fi

echo "Done."


