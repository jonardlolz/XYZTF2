#!/bin/bash

# Download Team Fortress 2 Server Files
# App ID: 232250 (TF2 Server)

set -e

STEAMCMD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF2_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/server_files"

# Create directories
mkdir -p "$TF2_DIR"
mkdir -p "$STEAMCMD_DIR/Steam"

# Check if SteamCMD exists
if [ ! -f "$STEAMCMD_DIR/steamcmd.sh" ]; then
    echo "Error: SteamCMD not found. Please run install_steamcmd.sh first."
    exit 1
fi

echo "Downloading TF2 Server files..."
echo "This may take several minutes..."

# Download TF2 Server (App ID: 232250)
"$STEAMCMD_DIR/steamcmd.sh" \
    +force_install_dir "$TF2_DIR" \
    +login anonymous \
    +app_update 232250 validate \
    +quit

echo ""
echo "TF2 Server files downloaded successfully!"
echo "Installation directory: $TF2_DIR"
echo ""
echo "Next steps:"
echo "1. Configure the server: Edit configs/server.cfg"
echo "2. Start the server: cd .. && ./start_server.sh"
