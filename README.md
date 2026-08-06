# Termux XFCE Desktop + VNC

One-liner Linux desktop on your Android phone, accessible from any PC via VNC.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/paulablaza/termux-xfce-vnc/main/setup.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/paulablaza/termux-xfce-vnc.git
cd termux-xfce-vnc
bash setup.sh
```

## What This Does

Installs XFCE desktop + TigerVNC on native Termux (no proot, no root needed).

- **XFCE** - Lightweight desktop environment
- **TigerVNC** - Remote desktop server
- **dbus** - Required for XFCE to function

## Connect from PC

1. Install [TightVNC Viewer](https://www.tightvnc.com/download.php) (free, 2MB)
2. Phone and PC on same WiFi
3. Open TightVNC Viewer, enter `phone-IP:5901`
4. Enter your VNC password

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

**Want audio?**
```bash
# In Termux
pkg install pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

# Add to ~/.vnc/xstartup before the xfce4-session line:
# export PULSE_SERVER=127.0.0.1
```

## License

MIT
