#!/bin/bash

# Team Fortress 2 Server Startup Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF2_DIR="$SCRIPT_DIR/server_files"
CONFIG_DIR="$SCRIPT_DIR/configs"

# ====================================================================
# Configuration - Customize these values
# ====================================================================

PORT=27015                            # Game port
SRCDS_PORT=27015                      # Source engine port
TV_PORT=27020                         # HLTV port (optional)
MAXPLAYERS=32                         # Max players
MAP="cp_dustbowl"                     # Starting map
TICKRATE=66                           # Server tick rate

# ====================================================================
# Pre-flight checks
# ====================================================================

echo "Team Fortress 2 Server Startup"
echo "======================================================================"

if [ ! -d "$TF2_DIR" ]; then
    echo "Error: TF2 server files not found at $TF2_DIR"
    echo "Please run: cd steamcmd && ./download_tf2.sh"
    exit 1
fi

if [ ! -f "$TF2_DIR/srcds_run" ]; then
    echo "Error: srcds_run not found. TF2 may not be fully downloaded."
    exit 1
fi

if [ ! -f "$CONFIG_DIR/server.cfg" ]; then
    echo "Warning: server.cfg not found at $CONFIG_DIR/server.cfg"
    echo "Using default configuration."
fi

# ====================================================================
# Server startup
# ====================================================================

echo "Starting TF2 Server..."
echo "Port: $PORT"
echo "Max Players: $MAXPLAYERS"
echo "Starting Map: $MAP"
echo "Tickrate: $TICKRATE"
echo "======================================================================"
echo ""
echo "Server is running. Press Ctrl+C to stop."
echo ""

# Create logs directory if it doesn't exist
mkdir -p "$TF2_DIR/tf/logs"

# Build server command line
cd "$TF2_DIR"

./srcds_run \
    -game tf \
    -console \
    -usercon \
    +ip 0.0.0.0 \
    +port $PORT \
    +map $MAP \
    +maxplayers $MAXPLAYERS \
    -tickrate $TICKRATE \
    +exec server.cfg \
    +sv_pure 1 \
    -pidfile /tmp/srcds.pid \
    -logfile console

# If we reach here, the server has stopped
echo ""
echo "Server stopped."
