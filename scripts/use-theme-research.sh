#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/_config.yml"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: _config.yml not found at $CONFIG_FILE" >&2
  exit 1
fi

if grep -qE '^style:' "$CONFIG_FILE"; then
  sed -i -E 's|^style:[[:space:]]*.*$|style:  research-dossier|' "$CONFIG_FILE"
else
  printf '\nstyle:  research-dossier\n' >> "$CONFIG_FILE"
fi

echo "Theme set to research-dossier in $CONFIG_FILE"
