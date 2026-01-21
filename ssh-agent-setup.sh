#!/bin/bash

# Define the path to .bashrc
BASHRC="$HOME/.bashrc"

# The code block to be appended (using the more secure 'find' method)
AGENT_LOGIC='
# Attempt to connect to an existing agent owned by the current user
if [ -z "$SSH_AUTH_SOCK" ]; then
    # Look for a socket file owned by the current user in /tmp
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -user $USER -name "agent.*" 2>/dev/null | head -1)
fi

# If no agent found, start a new one
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
fi
'

# Check if the logic is already present to avoid duplicates
if grep -q "Attempt to connect to an existing agent" "$BASHRC"; then
    echo "SSH Agent logic already exists in $BASHRC. No changes made."
else
    echo "Appending secure SSH Agent logic to $BASHRC..."
    echo "$AGENT_LOGIC" >> "$BASHRC"
    echo "Done! Please run 'source ~/.bashrc' to apply changes."
fi
