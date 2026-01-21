#!/bin/bash

# SSH & Git Setup Script
set -e

# --- 1. Get User Input ---
read -p "👤 Enter your full name (for Git): " GIT_NAME
read -p "📧 Enter your email address: " GIT_EMAIL
read -p "🔑 Enter a name for your SSH key (default: id_ed25519): " KEY_INPUT

# Set default key name if input is empty
KEY_NAME=${KEY_INPUT:-id_ed25519}

# --- 2. Configure Git Identity ---
echo "⚙️  Configuring Git global settings..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# --- 3. SSH Key Creation ---
echo "🔑 Creating SSH key: $KEY_NAME..."
# Ensure .ssh directory exists
mkdir -p ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/$KEY_NAME -N ""

# --- 4. Updating SSH Config ---
echo "📝 Updating SSH config..."
if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
fi

# Add host configuration (using $KEY_NAME variable)
if ! grep -q "Host github.com" ~/.ssh/config; then
    cat >> ~/.ssh/config << EOF

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/$KEY_NAME
    
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/$KEY_NAME
EOF
fi

# --- 5. Start Agent and Add Key ---
echo "🚀 Starting SSH agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$KEY_NAME

echo ""
echo "✅ Setup complete!"
echo "👤 Git User:  $(git config --global user.name)"
echo "📧 Git Email: $(git config --global user.email)"
echo "📋 Copy this public key to GitHub/GitLab:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat ~/.ssh/$KEY_NAME.pub
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
