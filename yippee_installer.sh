#!/bin/bash

install_path="$HOME/.yippee.py"
script_url="https://raw.githubusercontent.com/rezadoz/yippee/main/yippee.py"

echo ":: starting yippee installation ::"

install_script() {
    echo "-> downloading yippee script..."
    if ! curl -sfL "$script_url" -o "$install_path"; then
        echo "error: failed to download script from $script_url"
        exit 1
    fi

    echo "-> setting executable permissions..."
    chmod +x "$install_path"
    echo "success: script installed to $install_path"
}

add_alias() {
    local shell_config=$1
    local alias_line=""

    if [[ "$shell_config" == *"fish/config.fish" ]]; then
        alias_line="alias yay \"$install_path\""
    else
        alias_line="alias yay='$install_path'"
    fi

    if [ -f "$shell_config" ]; then
        echo "-> checking $shell_config..."
        if ! grep -q "yippee wrapper for yay" "$shell_config"; then
            echo "-> adding alias to $shell_config"
            echo "$alias_line  # yippee wrapper for yay" >> "$shell_config"
            echo "success: updated $shell_config"
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
    echo "start a new terminal session"
    echo "or instead run 'source ~/.bashrc' or 'source ~/.zshrc'"
    echo "for fish: you can run 'source ~/.config/fish/config.fish'"
    echo "you may also need to hydrate"
    echo ""
    echo "now would be a good time to execute yay and verify yippee is working"
}

install_script
update_shell_configs
final_steps
