#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# Termux proot Debian + XFCE + VNC - ONE CLICK
# Full Linux desktop on your phone, access from any PC via VNC
# Password: 123456
# ============================================================================

echo "========================================="
echo "  proot Debian + XFCE + VNC Setup"
echo "========================================="
echo ""

echo "[1/4] Updating Termux..."
pkg update -y && pkg upgrade -y

echo "[2/4] Installing proot-distro..."
pkg install proot-distro -y

echo "[3/4] Installing Debian (2-5 min)..."
proot-distro install debian || proot-distro install debian

echo "[4/4] Installing XFCE + VNC inside Debian (5-10 min)..."
proot-distro login debian -- bash -s << 'PROOT_SCRIPT'
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y -o Dpkg::Options::=--force-confnew --no-install-recommends \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common tigervnc-tools \
    dbus-x11 xauth xdg-utils menu

mkdir -p /root/.vnc /root/.config/tigervnc
chmod 700 /root/.vnc /root/.config/tigervnc

echo '123456' | vncpasswd -f > /root/.vnc/passwd

cat > /root/.vnc/xstartup << 'XSTARTUP'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startxfce4
XSTARTUP
chmod +x /root/.vnc/xstartup

echo "PROOT SETUP DONE"
PROOT_SCRIPT

echo ""
echo "========================================="
echo "  Starting desktop..."
echo "========================================="
proot-distro login debian -- vncserver -kill :1 2>/dev/null
proot-distro login debian -- vncserver :1 -localhost no

echo ""
echo "========================================="
echo "  DONE! Desktop is running."
echo "========================================="
echo "  From your PC:"
echo "  TightVNC Viewer -> PHONE-IP:5901"
echo "  Password: 123456"
echo ""
echo "  Find phone IP:  ifconfig wlan0 | grep inet"
echo "  Start:  proot-distro login debian -- vncserver :1 -localhost no"
echo "  Stop:   proot-distro login debian -- vncserver -kill :1"
echo "========================================="
