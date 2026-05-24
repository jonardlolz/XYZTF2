# TF2 Server Complete Setup Guide

This guide will walk you through setting up and running your TF2 server.

## Prerequisites

### System Requirements
- Linux server (Ubuntu 20.04 LTS or newer recommended)
- At least 2GB RAM available
- 100GB free disk space (for server files)
- 1 Mbps upload speed minimum
- Static IP address (optional but recommended)

### Required Packages
The setup scripts will install these, but you can pre-install them:
```bash
sudo apt-get update
sudo apt-get install -y lib32gcc-s1 curl
```

## Step-by-Step Setup

### Step 1: Install SteamCMD
```bash
cd "/home/jonard/tf2 server"
cd steamcmd
chmod +x install_steamcmd.sh
./install_steamcmd.sh
```

This downloads the SteamCMD tool (~50MB) which is used to manage game server files.

**Expected output:**
```
Installing SteamCMD...
Installing dependencies...
Downloading SteamCMD...
SteamCMD installed successfully!
```

### Step 2: Download TF2 Server Files
```bash
cd steamcmd
chmod +x download_tf2.sh
./download_tf2.sh
```

This downloads the TF2 server files (~20GB). This step may take 20-60 minutes depending on your connection.

**What's happening:** 
- SteamCMD connects to Valve's servers
- Downloads official TF2 server binary and game files
- Validates all files are correct

**Expected output:**
```
Downloading TF2 Server files...
This may take several minutes...
...
TF2 Server files downloaded successfully!
```

### Step 3: Configure Your Server

Edit the server configuration:
```bash
nano configs/server.cfg
```

**Important settings to change:**

1. **Server Name** (Line 10)
   ```
   hostname "My Awesome TF2 Server"
   ```

2. **RCON Password** (Line 11) - **IMPORTANT: CHANGE THIS!**
   ```
   rcon_password "super_secure_password_here"
   ```

3. **Player Count** (Line 30)
   ```
   sv_maxplayers 32        // Choose: 12, 16, 24, or 32
   ```

4. **Server Region** (Line 26) - For better matchmaking
   ```
   sv_region 1             // 0=US East, 1=US West, 2=South America, etc.
   ```

### Step 4: Customize Map Rotation

Edit the map cycle:
```bash
nano configs/mapcycle.txt
```

Add or remove maps to your preference. The default includes popular vanilla maps:
- `cp_dustbowl` - 5CP Dustbowl
- `pl_badwater` - Payload Badwater
- `ctf_2fort` - Classic CTF 2Fort
- And more...

### Step 5: Start the Server

Make the startup script executable:
```bash
cd "/home/jonard/tf2 server"
chmod +x start_server.sh
```

Start the server:
```bash
./start_server.sh
```

**Expected output:**
```
Team Fortress 2 Server Startup
======================================================================
Starting TF2 Server...
Port: 27015
Max Players: 32
Starting Map: cp_dustbowl
Tickrate: 66
======================================================================

Server is running. Press Ctrl+C to stop.
```

### Step 6: Connect to Your Server

In TF2, open the console (press `` ` `` key) and type:
```
connect YOUR_SERVER_IP:27015
```

Or use the server browser:
1. Launch TF2
2. Click "Play" → "Browse Community Servers"
3. Search for your server name

## Configuration Details

### server.cfg - Key Settings

#### Game Modes
The current config supports these modes automatically:
- **Capture Point (CP)** - Control all points to win
- **Payload (PL)** - Push cart to enemy spawn
- **Capture The Flag (CTF)** - Grab and return enemy flag
- **King of the Hill (KOTH)** - Control central point

#### Vanilla+ Features
- Old-style map timers (30 min) instead of rounds
- Team switching enabled (like old Quickplay)
- No friendly fire
- Automatic team balancing
- Mixed map rotation

#### Performance Settings
- **Tickrate: 66** - Standard for casual servers
- **FPS: 66** - Optimal for 66-tick servers
- **sv_pure: 1** - Prevents custom models/skins

### Ports and Firewall

Your server uses these ports:
- **27015** - Game port (required)
- **27020** - HLTV port (optional, for spectator relay)

If you're behind a router, you need to **port forward**:
1. Access your router settings (usually 192.168.1.1)
2. Forward port 27015 (TCP/UDP) to your server's internal IP
3. Find your external IP at [whatismyipaddress.com](https://whatismyipaddress.com)

### Server Commands (via RCON or Console)

Connect via RCON:
```bash
./rcon_console.sh    # If created
```

Common commands:
```
rcon changelevel cp_well
rcon sv_maxplayers 24
rcon mp_timelimit 45
rcon say "Server message to all players"
rcon kick @all              # Kick all players
rcon quit                   # Shutdown server
```

## Running the Server

### Basic Operation

**Start server:**
```bash
./start_server.sh
```

**Stop server:**
Press `Ctrl+C` in the terminal

**Keep running after disconnect:**
Use `screen` or `tmux`:
```bash
screen -S tf2 ./start_server.sh
# Then: Ctrl+A, D to detach

# To reconnect:
screen -r tf2
```

Or use `nohup`:
```bash
nohup ./start_server.sh > server.log 2>&1 &
```

### Monitoring

**Check if server is running:**
```bash
ps aux | grep srcds
```

**View logs:**
```bash
tail -f server_files/tf/logs/*.log
```

**Monitor performance:**
```bash
top
```

## Troubleshooting

### Server won't start
**Problem:** srcds_run not found
**Solution:** Re-run `./steamcmd/download_tf2.sh`

### Port already in use
**Problem:** "Address already in use" error
**Solution:** Edit `start_server.sh` and change PORT to something else (e.g., 27016)

### Can't connect from outside
**Problem:** "Connection refused" or "Connection timed out"
**Solution:** 
1. Check firewall: `sudo ufw allow 27015`
2. Verify port forwarding on your router
3. Check your server is actually running: `ps aux | grep srcds`

### Server crashes immediately
**Problem:** Server process exits with no output
**Solution:**
1. Check logs: `ls -la server_files/tf/logs/`
2. Try running with more verbose output
3. Verify TF2 files downloaded completely

### Players can see server but can't connect
**Problem:** Server appears in browser but connection fails
**Solution:**
1. Ensure `sv_pure 1` is set (prevents custom content issues)
2. Check max players limit isn't exceeded
3. Verify password is correct (if set)

### Poor performance/high latency
**Problem:** Server lags or stutters
**Solution:**
1. Increase tickrate carefully: Set to 100 for high-end hardware
2. Reduce max players
3. Check CPU/RAM usage: `top`
4. Reduce number of running processes on the server

## Advanced Configuration

### Enable HLTV (Spectator Relay)
Edit `server.cfg` and uncomment:
```
tv_enable 1
tv_port 27020
tv_maxclients 128
tv_name "HLTV"
```

### Custom Game Modes

For competitive setups, create a `competitive.cfg`:
```
// 6v6 Competitive
sv_maxplayers 12
mp_tournament_mode 1
mp_tournament_allow_teamchange 0
mp_friendlyfire 1
mp_timelimit 0
```

Load with: `rcon exec competitive.cfg`

### Ban/Whitelist Management

Create `banned_users.cfg` and `banned_ip.cfg` in `server_files/tf/cfg/`

Ban a player:
```
banid 0 [STEAM_ID] [reason]
writeid
```

## Performance Tuning

### CPU Optimization
```
// In server.cfg
fps_max 100             // Increase if CPU can handle
sv_parallel_sendsleep 0
sv_parallel_packetsend 1
```

### Bandwidth Optimization
```
sv_minrate 20000
sv_maxrate 96000
```

### Network Settings
```
sv_client_min_interp_ratio 1
sv_client_max_interp_ratio 1
```

## Maintenance

### Regular Updates
TF2 gets updates regularly. Periodically run:
```bash
cd steamcmd && ./download_tf2.sh
```

This updates your server to the latest version.

### Backing Up Configuration
```bash
cp -r configs configs.backup
```

### Rotating Logs
Logs grow over time. Archive them:
```bash
cd server_files/tf/logs
tar -czf logs-$(date +%Y%m%d).tar.gz *.log
rm *.log
```

## Resources

- [Official TF2 Server Wiki](https://wiki.teamfortress.com/wiki/Dedicated_Server_Program)
- [SRCDS Commands List](https://wiki.teamfortress.com/wiki/Dedicated_Server_Configuration)
- [TF2 Community](https://teamfortress.tv/)
- [Map Collection](https://maps.tf/)

## Next Steps

1. **Customize server name and RCON password**
2. **Adjust map rotation in `mapcycle.txt`**
3. **Test connection locally**
4. **Set up port forwarding if behind NAT**
5. **Monitor performance during first run**
6. **Invite friends to test**

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review server logs: `server_files/tf/logs/`
3. Verify all files are in place
4. Check [TF2 Community Forums](https://teamfortress.tv/)

Good luck with your server!
