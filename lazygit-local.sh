#!/bin/bash

# Install lazygit locally
set -e

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

echo "📦 Fetching latest lazygit version..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

echo "⬇️  Downloading lazygit v$LAZYGIT_VERSION..."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

echo "📂 Extracting..."
tar xf lazygit.tar.gz lazygit

echo "📍 Installing to $INSTALL_DIR..."
mv lazygit "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/lazygit"

echo "🧹 Cleaning up..."
rm lazygit.tar.gz

# Define the path entry
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

# Determine which config file to use
if [[ "$SHELL" == */zsh ]]; then
    CONF_FILE="$HOME/.zshrc"
elif [[ "$SHELL" == */bash ]]; then
    CONF_FILE="$HOME/.bashrc"
else
    # Fallback to .profile if shell is unknown
    CONF_FILE="$HOME/.profile"
fi

echo "✅ lazygit installed successfully!"
echo "📍 Location: $INSTALL_DIR/lazygit"

# Check if the PATH line already exists in the file
if grep -Fxq "$PATH_LINE" "$CONF_FILE"; then
    echo "Check: PATH is already configured in $CONF_FILE"
else
    echo "Adding $INSTALL_DIR to PATH in $CONF_FILE..."
    echo "" >> "$CONF_FILE"
    echo "# Added by lazygit installer script" >> "$CONF_FILE"
    echo "$PATH_LINE" >> "$CONF_FILE"
    echo "alias lg='lazygit'" >> "$CONF_FILE"
    
    echo "🚀 PATH updated! Please run 'source $CONF_FILE' or restart your terminal."
fi
