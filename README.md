# Termux XFCE Desktop + VNC

One-click Linux desktop on your Android phone, accessible from any PC via VNC.

## One-Click Install (Easiest)

Open Termux and paste this ENTIRE line, then press Enter. Password will be `123456`:

```bash
pkg update -y && pkg upgrade -y && pkg install -y x11-repo xfce4 tigervnc dbus && mkdir -p ~/.vnc && printf '123456' | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd && printf '#!/data/data/com.termux/files/usr/bin/sh\nexec dbus-launch --exit-with-session xfce4-session\n' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup && vncserver -kill :1 2>/dev/null; vncserver -localhost no :1
```

Wait 5-15 minutes for install, then the desktop starts automatically.

## Connect from PC

1. Install [TightVNC Viewer](https://www.tightvnc.com/download.php) (free, 2MB)
2. Phone and PC on same WiFi
3. Find your phone IP: `ifconfig wlan0 | grep inet`
4. Open TightVNC Viewer, enter `phone-IP:5901`
5. Password: `123456`

## Manual Install (One by One)

```bash
pkg update -y && pkg upgrade -y
pkg install x11-repo -y
pkg install xfce4 tigervnc dbus -y
vncpasswd
mkdir -p ~/.vnc
printf '#!/data/data/com.termux/files/usr/bin/sh\nexec dbus-launch --exit-with-session xfce4-session\n' > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
vncserver -localhost no :1
```

## Commands

| Action | Command |
|--------|---------|
| Start desktop | `vncserver -localhost no :1` |
| Stop desktop | `vncserver -kill :1` |
| Find phone IP | `ifconfig wlan0 \| grep inet` |

## Requirements

- Android 7.0+
- Termux (from [F-Droid](https://f-droid.org/packages/com.termux/) or [GitHub](https://github.com/termux/termux-app/releases))
- ~500MB free storage
- WiFi connection

## FAQ

**Black screen on VNC?**
```bash
vncserver -kill :1
vncserver -localhost no :1
```

**Can't connect from PC?**
- Make sure `-localhost no` is in the start command
- Check phone and PC are on same WiFi
- Try `ifconfig wlan0` to find your phone IP

**"pkg cannot run as root"?**
- Your shell is running as root (tsu or proot session). Type `exit` until you see the normal `~ $` prompt, or open a new Termux session.

**Change VNC password?**
```bash
vncpasswd
```

**Want audio?**
```bash
pkg install pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
# Then add to ~/.vnc/xstartup before the xfce4-session line:
# export PULSE_SERVER=127.0.0.1
```

## What This Installs

- **XFCE** - Lightweight desktop environment
- **TigerVNC** - Remote desktop server (PC access)
- **dbus** - Required for XFCE to function (not auto-installed)
- **x11-repo** - Unlocks GUI packages in Termux

Runs on native Termux. No root, no proot, no chroot needed.

## License

MIT
