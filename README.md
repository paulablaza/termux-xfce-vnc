# Termux Desktop + VNC (Hybrid)

Linux desktop on your Android phone, accessed from any PC via VNC.

- **Native XFCE** desktop + TigerVNC on Termux (fast, no proot overhead)
- **proot Debian** as the app layer for anything glibc (Hermes Agent, Camoufox, Firefox ESR, Claude Code, OpenCode)
- Bridge proot apps onto the native desktop with `pdrun`

## Quick Commands (daily use)

```bash
# START the desktop (first time: it asks you to set a VNC password)
vncserver :1 -localhost no

# STOP the desktop
vncserver -kill :1

# Find your phone IP
ifconfig wlan0 | grep inet

# Enter proot Debian (Hermes, Firefox, coding agents)
proot-distro login debian

# Run a proot app on the native desktop
pdrun firefox-esr
```

On your PC: open **TightVNC Viewer** (https://www.tightvnc.com/download.php), connect to `PHONE-IP:5901`, enter your VNC password.

## Setup (one time, step by step)

Run each command one at a time in Termux. Wait for it to finish before the next one.

### Part 1: Native Desktop + VNC

**1. Install Termux**

From **F-Droid**, not the Play Store:
- https://f-droid.org/packages/com.termux/

**2. Update Termux**

```bash
pkg update -y && pkg upgrade -y
```

**3. Unlock GUI packages**

```bash
pkg install x11-repo -y
```

**4. Install desktop + VNC**

```bash
pkg install xfce4 tigervnc dbus -y
```

**5. Create the VNC startup file**

```bash
mkdir -p ~/.vnc
printf '#!/data/data/com.termux/files/usr/bin/sh\nexec dbus-launch --exit-with-session xfce4-session\n' > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
```

**6. Start the desktop**

```bash
vncserver :1 -localhost no
```

First run: it asks you to create a VNC password (max 8 chars). Remember it.

**7. Connect from your PC**

1. Install TightVNC Viewer on Windows
2. Phone and PC on the same WiFi
3. Open TightVNC Viewer, enter `PHONE-IP:5901`
4. Enter your VNC password

### Part 2: proot Debian (for apps that need real Linux)

**8. Install proot-distro**

```bash
pkg install proot-distro -y
```

**9. Install Debian (~5 min)**

```bash
proot-distro install debian
```

**10. Install apps inside Debian**

```bash
proot-distro login debian
apt update -y
apt install -y firefox-esr
```

Hermes Agent, Camoufox, Claude Code and other glibc apps also go here.

**11. Put proot apps on the native desktop**

```bash
# In Termux (base), after installing sabamdarif's bridge:
pdrun firefox-esr
```

## Install Hermes Agent (inside proot Debian)

```bash
proot-distro login debian
apt install -y curl git python3 python3-pip python3-venv
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
hermes setup
```

Control it from anywhere via Telegram:

```bash
hermes gateway setup
```

## FAQ

**"Process completed (signal 9)" crash?**
Android 12+'s phantom process killer is killing Termux. Fix:
1. Settings > Battery > App battery management > Termux > Don't optimize
2. `termux-wake-lock`
3. ADB wireless debugging, then:
```bash
adb shell device_config put activity_manager max_phantom_processes 214181594
adb shell device_config set_sync_disabled_for_tests persistent
```

**Black screen when connecting?**
```bash
vncserver -kill :1
vncserver :1 -localhost no
```

**Desktop feels laggy?**
- Lower the resolution:
```bash
vncserver -kill :1
vncserver :1 -localhost no -geometry 1280x720 -depth 16
```
- Turn off compositor effects:
```bash
xfconf-query -c xfwm4 -p /general/use_compositing -s false
```
- Disable battery optimization for Termux (Settings > Battery > Termux > Don't optimize)

**"pkg cannot run as root"?**
Your shell is inside a root session. Type `exit` until you see the normal `~ $` prompt, then run the command again.

**Forgot your VNC password?**
```bash
vncpasswd
```

**Want audio?**
```bash
pkg install pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
```

## Why this hybrid setup?

| Layer | What runs there | Why |
|---|---|---|
| Native Termux | XFCE desktop, VNC, Fennec | Fast, no ptrace overhead |
| proot Debian | Hermes, Camoufox, Firefox ESR, coding agents | Needs glibc, native can't run them |

Native Termux uses Android's bionic libc, not glibc. Most real Linux apps
(and Hermes' recommended path) need glibc, so they live in proot. The
desktop stays native so it stays fast.

## License

MIT
