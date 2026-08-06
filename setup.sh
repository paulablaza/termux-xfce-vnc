#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# Termux XFCE Desktop + VNC
# Access a Linux desktop from your PC via VNC
# ============================================================================
# Sources: Termux Wiki, sabamdarif, LinuxDroidMaster, Ivon's Blog
# ============================================================================

echo "========================================="
echo "  Termux XFCE Desktop Setup"
echo "========================================="
echo ""

# Step 1: Update packages
echo "[1/4] Updating packages..."
pkg update -y && pkg upgrade -y

# Step 2: Install desktop + VNC
echo "[2/4] Installing XFCE, TigerVNC, dbus..."
pkg install x11-repo -y
pkg install xfce4 tigervnc dbus -y

# Step 3: Set VNC password
echo "[3/4] Setting VNC password..."
echo "You'll be prompted for a password (max 8 chars)."
echo "This is NOT your Termux password, just for VNC connection."
echo ""
vncpasswd

# Step 4: Create xstartup
echo "[4/4] Creating VNC startup file..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh
exec dbus-launch --exit-with-session xfce4-session
EOF
chmod +x ~/.vnc/xstartup

echo ""
echo "========================================="
echo "  DONE! Starting VNC server..."
echo "========================================="
echo ""

# Start VNC (accessible from PC)
vncserver -localhost no :1

# Show connection info
IP=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
if [ -z "$IP" ]; then
    IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
fi

echo ""
echo "========================================="
echo "  Connect from your PC:"
echo "  Address: ${IP}:5901"
echo "  Password: (the one you just set)"
echo ""
echo "  VNC client: TightVNC Viewer (free)"
echo "  Download: https://www.tightvnc.com/download.php"
echo ""
echo "  To stop:  vncserver -kill :1"
echo "  To start: vncserver -localhost no :1"
echo "========================================="
