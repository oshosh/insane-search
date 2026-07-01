#!/bin/bash
# macOS/Linux Installer for insane-search plugin & skill

echo "[1/2] Installing plugin via Antigravity CLI..."
agy plugin install "$(dirname "$0")/.."

if [ $? -ne 0 ]; then
    echo "[ERROR] Antigravity CLI plugin installation failed."
    exit 1
fi

echo "[2/2] Registering skill in global search path..."
TARGET_DIR="$HOME/.gemini/antigravity-cli/skills/insane-search"

# Create directory if it does not exist
mkdir -p "$HOME/.gemini/antigravity-cli/skills"

# Clean up old files/links if exist
rm -rf "$TARGET_DIR"

# Create symbolic link to the deployed plugin skills folder
ln -s "$HOME/.gemini/config/plugins/insane-search/skills/insane-search" "$TARGET_DIR"

if [ $? -ne 0 ]; then
    echo "[WARNING] Could not create symbolic link. Copying files instead..."
    cp -r "$(dirname "$0")/../skills/insane-search" "$TARGET_DIR"
fi

echo "[SUCCESS] insane-search installed and registered! Please restart your agy session."
