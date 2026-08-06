#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# Termux XFCE Desktop + VNC - ONE CLICK
# Paste one line, get a desktop. Password: 123456
# ============================================================================

pkg update -y && pkg upgrade -y && pkg install -y x11-repo xfce4 tigervnc dbus && mkdir -p ~/.vnc && printf '123456' | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd && printf '#!/data/data/com.termux/files/usr/bin/sh\nexec dbus-launch --exit-with-session xfce4-session\n' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup && vncserver -kill :1 2>/dev/null; vncserver -localhost no :1

echo ""
echo "========================================="
echo "  DONE! Desktop is running."
echo "========================================="
echo "  From your PC:"
echo "  TightVNC Viewer -> PHONE-IP:5901"
echo "  Password: 123456"
echo ""
echo "  Find phone IP:  ifconfig wlan0 | grep inet"
echo "  Stop:  vncserver -kill :1"
echo "  Start: vncserver -localhost no :1"
echo "========================================="
