#!/bin/bash
# Generate PDF from German Testing Magazin article
# Usage: bash scripts/generate-pdf.sh [input.md] [output.pdf]

set -e

export PATH="$HOME/.local/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

INPUT="${1:-$REPO_ROOT/docs/german_testing_magazin/index.md}"
OUTPUT="${2:-${INPUT%.md}.pdf}"
STYLE="${INPUT%/*}/style.css"
WORK_DIR=$(mktemp -d)

trap 'rm -rf "$WORK_DIR"' EXIT

echo "=== Generating PDF ==="
echo "Input:  $INPUT"
echo "Output: $OUTPUT"

# Check dependencies
for cmd in pandoc mmdc weasyprint; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' not found. Run devcontainer rebuild or install manually."
        exit 1
    fi
done

# Step 1: Pandoc markdown → HTML (with mermaid filter)
echo "[1/2] Converting Markdown to HTML (rendering Mermaid diagrams)..."
export MERMAID_OUT_DIR="$WORK_DIR"
export PUPPETEER_CONFIG="$SCRIPT_DIR/puppeteer-config.json"

pandoc "$INPUT" \
    --from=markdown+raw_html \
    --to=html5 \
    --standalone \
    --lua-filter="$SCRIPT_DIR/mermaid-filter.lua" \
    --metadata title="" \
    --resource-path="$(dirname "$INPUT")" \
    -o "$WORK_DIR/article.html"

# Post-process HTML: inject CSS and mark figure captions
python3 -c "
import re

with open('$WORK_DIR/article.html', 'r') as f:
    html = f.read()

# Mark paragraphs that are figure captions (only contain <em>Abbildung...</em>)
html = re.sub(
    r'<p><em>(Abbildung \d+:)',
    r'<p class=\"figure-caption\"><em>\1',
    html
)

# Inject custom CSS
css_path = '$STYLE'
try:
    with open(css_path, 'r') as f:
        css = f.read()
    html = html.replace('</head>', '<style>' + css + '</style></head>')
except FileNotFoundError:
    pass

with open('$WORK_DIR/article.html', 'w') as f:
    f.write(html)
"

# Step 2: HTML → PDF via WeasyPrint
echo "[2/2] Generating PDF with WeasyPrint..."
weasyprint \
    --base-url "$(cd "$(dirname "$INPUT")" && pwd)/" \
    "$WORK_DIR/article.html" \
    "$OUTPUT"

echo "=== Done: $OUTPUT ==="
