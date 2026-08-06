# Termux Debian Desktop + VNC

Full Linux desktop (proot Debian + XFCE) on your Android phone, accessed from any PC via VNC. The "phone is a PC" setup.

## Quick Commands (what you'll use daily)

```bash
# START the desktop
proot-distro login debian -- vncserver :1 -localhost no

# STOP the desktop
proot-distro login debian -- vncserver -kill :1

# Find your phone IP
ifconfig wlan0 | grep inet
```

Then on your PC:
1. Open **TightVNC Viewer** (https://www.tightvnc.com/download.php)
2. Enter `PHONE-IP:5901`
3. Password: `123456`

## Setup Tutorial (one time only)

### Step 1: Install Termux

Install from **F-Droid**, NOT the Play Store:
- https://f-droid.org/packages/com.termux/

(Play Store version is outdated and broken.)

### Step 2: Run the one-click installer

Open Termux and paste this whole line, then press Enter:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/paulablaza/termux-xfce-vnc/main/setup.sh)"
```

It will:
1. Update Termux
2. Install proot-distro
3. Install Debian (~5 min)
4. Install XFCE desktop + TigerVNC inside Debian (~10 min)
5. Start the desktop automatically

Total time: 15-20 minutes. Let it run.

### Step 3: Connect from your PC

1. Install TightVNC Viewer on Windows
2. Find your phone IP (run `ifconfig wlan0 | grep inet` in Termux)
3. Phone and PC on same WiFi
4. Open TightVNC Viewer, enter `PHONE-IP:5901`
5. Password: `123456`

### Step 4: Enter Debian (for installing apps)

```bash
proot-distro login debian
```

You're now in Debian. Install anything:

```bash
# Example
apt install -y python3 pip git
```

## FAQ

**Black screen when connecting?**
```bash
proot-distro login debian -- vncserver -kill :1
proot-distro login debian -- vncserver :1 -localhost no
```

**Desktop feels laggy?**
- Lower the resolution:
```bash
proot-distro login debian -- vncserver -kill :1
proot-distro login debian -- vncserver :1 -localhost no -geometry 1280x720 -depth 16
```
- Turn off compositor effects:
```bash
proot-distro login debian -- xfconf-query -c xfwm4 -p /general/use_compositing -s false
```
- Disable Oppo's battery optimization for Termux (Settings > Battery > Termux > Don't optimize)

**"pkg cannot run as root"?**
Your shell is inside a root session. Type `exit` until you see the normal `~ $` prompt, then run the command again.

**Change VNC password?**
```bash
proot-distro login debian -- vncpasswd
```

**Want audio?**
```bash
# In Termux (base)
pkg install pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
```

## What's inside

- **proot Debian** - full Linux container (no root needed)
- **XFCE** - lightweight desktop
- **TigerVNC** - remote desktop server
- **dbus-x11** - required for XFCE (not auto-installed)

## Why proot instead of native Termux?

Native Termux is faster but can't run glibc apps (Claude Code, OpenCode, Codex CLI). proot Debian runs everything, and over VNC the speed difference is negligible.

## License

MIT
