# TF2 Server Setup

This folder contains a fully configured Team Fortress 2 server using SteamCMD.

## Server Configuration
- **Type**: Public Vanilla+ Server
- **Game Modes**: Casual with Quickplay-style settings
- **Features**: Old map timers, team switching enabled, mixed map rotation

## Quick Start

### 1. Install Dependencies
```bash
sudo apt-get update
sudo apt-get install -y lib32gcc-s1 curl
```

### 2. Download SteamCMD
```bash
cd steamcmd
./install_steamcmd.sh
```

### 3. Download TF2 Server Files
```bash
cd steamcmd
./download_tf2.sh
```

### 4. Configure the Server
Edit `configs/server.cfg` with your server settings (server name, RCON password, etc.)

### 5. Start the Server
```bash
./start_server.sh
```

## File Structure
- `steamcmd/` - SteamCMD binary and scripts
- `server_files/` - Downloaded TF2 server files
- `configs/` - Server configuration files
- `start_server.sh` - Main server startup script
- `server.log` - Server logs (generated when running)

## Common Commands

**Start the server:**
```bash
./start_server.sh
```

**Stop the server:**
Press `Ctrl+C` in the terminal, or connect via RCON:
```
rcon quit
```

**Check server status:**
```bash
ps aux | grep srcds_linux
```

## Server Configuration
Edit `configs/server.cfg` to customize:
- Server name and password
- RCON password
- Number of players
- Map rotation
- Game rules

## Useful Resources
- [TF2 Server Documentation](https://wiki.teamfortress.com/wiki/Dedicated_Server_Program)
- [SRCDS Commands](https://wiki.teamfortress.com/wiki/Dedicated_Server_Configuration)
- [Map List](https://wiki.teamfortress.com/wiki/Map_versions)

## Troubleshooting

**Port Already in Use**: Change the port in `start_server.sh`
**Server crashes on startup**: Check server logs for errors
**Can't connect from outside**: Check firewall and port forwarding
