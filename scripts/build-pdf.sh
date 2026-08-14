#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "Building Jekyll site..."
bundle exec jekyll build

echo "Generating PDF..."

PDF_HTML="$REPO_ROOT/_site/index.pdf.html"
cp "$REPO_ROOT/_site/index.html" "$PDF_HTML"
# Force screen stylesheet for PDF output so typography matches on-screen rendering.
sed -i -E 's/(href="media\/[^"]+)-print\.css"([^>]*media=")print("[^>]*>)/\1-screen.css"\2all\3/' "$PDF_HTML"

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
  "file://$PDF_HTML"

rm -f "$PDF_HTML"

# Ensure the published site contains the generated PDF.
cp "$REPO_ROOT/cv.pdf" "$REPO_ROOT/_site/cv.pdf"

echo "PDF generated: cv.pdf"
