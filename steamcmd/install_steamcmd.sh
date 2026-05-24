#!/bin/bash

# Install SteamCMD for TF2 Server setup
# This script downloads and extracts SteamCMD

set -e

STEAMCMD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing SteamCMD..."

# Check if steamcmd already exists
if [ -f "$STEAMCMD_DIR/steamcmd.sh" ]; then
    echo "SteamCMD already installed!"
    exit 0
fi

# Install required dependencies
echo "Installing dependencies..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y lib32gcc-s1 curl
elif command -v yum &> /dev/null; then
    sudo yum install -y glibc.i686 libstdc++.i686 curl
else
    echo "Could not detect package manager. Please install 32-bit glibc manually."
    exit 1
fi

# Download SteamCMD
echo "Downloading SteamCMD..."
cd "$STEAMCMD_DIR"
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xvz

# Accept Steam license
mkdir -p "$STEAMCMD_DIR/Steam/steamapps/common"

echo "SteamCMD installed successfully!"
echo "Location: $STEAMCMD_DIR/steamcmd.sh"
