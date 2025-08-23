#!/usr/bin/env fish

# Setup script to symlink config files to their proper locations
set -l config_root (dirname (realpath (status --current-filename)))

echo "🔗 Setting up symlinks for config files..."

# Function to create symlink with backup
function create_symlink
    set -l source $argv[1]
    set -l target $argv[2]
    
    # Check if target already exists
    if test -e $target
        if test -L $target
            echo "  ✓ $target already symlinked"
            return
        else
            echo "  📦 Backing up existing $target to $target.bak"
            mv $target $target.bak
        end
    end
    
    # Create parent directory if it doesn't exist
    mkdir -p (dirname $target)
    
    # Create symlink
    ln -sf $source $target
    echo "  ✓ Linked $source -> $target"
end

# Claude config
create_symlink $config_root/claude ~/.claude

# Fish config
create_symlink $config_root/fish ~/.config/fish

# Ghostty config
create_symlink $config_root/ghostty ~/.config/ghostty

# Neovim config
create_symlink $config_root/nvim ~/.config/nvim

echo "🎉 All config symlinks created successfully!"
echo "💡 If you had existing configs, they've been backed up with .bak extension"