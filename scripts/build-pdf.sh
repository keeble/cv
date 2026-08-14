#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Building Jekyll site..."
bundle exec jekyll build

echo "Generating PDF..."

# Find chromium binary (name varies by distro)
CHROMIUM=$(command -v chromium || command -v chromium-browser || echo "")
if [ -z "$CHROMIUM" ]; then
  echo "Error: chromium not found. Install chromium or chromium-browser." >&2
  exit 1
fi

"$CHROMIUM" \
  --headless \
  --no-sandbox \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$REPO_ROOT/cv.pdf" \
  "file://$REPO_ROOT/_site/index.html"

echo "PDF generated: cv.pdf"
