# Termux Debian Desktop + VNC

Full Linux desktop (proot Debian + XFCE) on your Android phone, accessed from any PC via VNC.

## Quick Commands (daily use)

```bash
# START the desktop (first time: it asks you to set a VNC password)
proot-distro login debian -- vncserver :1 -localhost no

# STOP the desktop
proot-distro login debian -- vncserver -kill :1

# Find your phone IP
ifconfig wlan0 | grep inet
```

On your PC: open **TightVNC Viewer** (https://www.tightvnc.com/download.php), connect to `PHONE-IP:5901`, enter your VNC password.

## Setup (one time, step by step)

Run each command one at a time in Termux. Wait for it to finish before the next one.

### 1. Install Termux

From **F-Droid**, not the Play Store:
- https://f-droid.org/packages/com.termux/

### 2. Update Termux

```bash
pkg update -y && pkg upgrade -y
```

### 3. Install proot-distro

```bash
pkg install proot-distro -y
```

### 4. Install Debian (~5 min)

```bash
proot-distro install debian
```

### 5. Enter Debian

```bash
proot-distro login debian
```

You should now see a `root@localhost` prompt. Everything below happens inside Debian.

### 6. Update Debian

```bash
apt update -y
```

### 7. Install desktop + VNC (~10 min)

```bash
apt install -y xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 xauth xdg-utils menu
```

### 8. Create the VNC startup file

```bash
mkdir -p ~/.vnc ~/.config/tigervnc
printf '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec dbus-launch --exit-with-session startxfce4\n' > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
```

### 9. Leave Debian, back to Termux

```bash
exit
```

### 10. Start the desktop

```bash
proot-distro login debian -- vncserver :1 -localhost no
```

First run: it asks you to create a VNC password (max 8 chars). Remember it.

### 11. Connect from your PC

1. Install TightVNC Viewer on Windows
2. Phone and PC on the same WiFi
3. Open TightVNC Viewer, enter `PHONE-IP:5901`
4. Enter your VNC password

Done. You have a Linux desktop on your PC, powered by your phone.

## Install apps inside Debian

```bash
proot-distro login debian
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
- Disable battery optimization for Termux (Settings > Battery > Termux > Don't optimize)

**"pkg cannot run as root"?**
Your shell is inside a root session. Type `exit` until you see the normal `~ $` prompt, then run the command again.

**Forgot your VNC password?**
```bash
proot-distro login debian -- vncpasswd
```

**Want audio?**
```bash
# In Termux (base, not inside Debian)
pkg install pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
```

## Why proot instead of native Termux?

Native Termux is faster but can't run glibc apps (Claude Code, OpenCode, Codex CLI). proot Debian runs everything, and over VNC the speed difference is negligible.

## License

MIT
