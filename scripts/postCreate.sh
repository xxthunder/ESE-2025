#!/bin/bash

# Post-create script for devcontainer setup
# This script runs after the container is created

set -e

echo "Running post-create setup..."

# Initialize and update git submodules
echo "Initializing git submodules..."
git submodule update --init --recursive

# Install Claude Code using native installer
echo "Installing Claude Code CLI..."
curl -fsSL https://claude.ai/install.sh | bash

# Update npm to latest version
echo "Updating npm..."
npm install -g npm@latest

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

# PDF generation dependencies
echo "Installing PDF generation tools..."
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    pandoc \
    python3-pip \
    fonts-noto-color-emoji \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    libcairo2 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libasound2

fc-cache -f
python3 -m pip install --user --break-system-packages weasyprint
npm install -g @mermaid-js/mermaid-cli

# Ensure ~/.local/bin is in PATH for weasyprint
if ! grep -q '.local/bin' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "Post-create setup complete!"
