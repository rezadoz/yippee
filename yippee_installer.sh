#!/bin/bash

INSTALL_PATH="$HOME/.yippee.py"
SCRIPT_URL="https://raw.githubusercontent.com/rezadoz/yippee/refs/heads/main/yippee.py"

echo ":: starting yippee installation ::"

install_script() {
    echo "-> downloading yippee script..."
    if ! curl -sfL "$SCRIPT_URL" -o "$INSTALL_PATH"; then
        echo "ERROR: failed to download script from $SCRIPT_URL"
        exit 1
    fi

    echo "-> setting executable permissions..."
    chmod +x "$INSTALL_PATH"
    echo "SUCCESS: script installed to $INSTALL_PATH"
}

add_alias() {
    local shell_config=$1
    local alias_line="alias yay='$INSTALL_PATH'  # yippee wrapper for yay"

    if [ -f "$shell_config" ]; then
        echo "-> checking $shell_config..."
        if ! grep -q "yippee wrapper for yay" "$shell_config"; then
            echo "-> adding alias to $shell_config"
            echo "$alias_line" >> "$shell_config"
            echo "SUCCESS: updated $shell_config"
        else
            echo "-> alias already exists in $shell_config - skipping"
        fi
    else
        echo "-> $shell_config not found - skipping"
    fi
}

update_shell_configs() {
    echo "-> updating shell configurations..."
    add_alias "$HOME/.bashrc"
    add_alias "$HOME/.zshrc"
    add_alias "$HOME/.config/fish/config.fish"
}

final_steps() {
    echo ""
    echo ":: installation complete ::"
    echo "you may need to:"
    echo "1. start a new terminal session"
    echo "2. or run: source ~/.bashrc (or your shell config)"
    echo "3. drink water"
}

install_script
update_shell_configs
final_steps
