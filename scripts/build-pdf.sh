#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Building Jekyll site..."
bundle exec jekyll build

echo "Generating PDF..."

# Find browser binary (name varies by distro/CI image)
CHROMIUM=$(command -v chromium || command -v chromium-browser || command -v google-chrome || command -v google-chrome-stable || echo "")
if [ -z "$CHROMIUM" ]; then
  echo "Error: chromium/chrome not found. Install chromium, chromium-browser, or google-chrome." >&2
  exit 1
fi

"$CHROMIUM" \
  --headless \
  --no-sandbox \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$REPO_ROOT/cv.pdf" \
  "file://$REPO_ROOT/_site/index.html"

# Ensure the published site contains the generated PDF.
cp "$REPO_ROOT/cv.pdf" "$REPO_ROOT/_site/cv.pdf"

echo "PDF generated: cv.pdf"
