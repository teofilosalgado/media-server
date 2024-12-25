#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop qbittorrent-nox
rm -rf /etc/systemd/system/qbittorrent-nox.service
systemctl -q daemon-reload
userdel -f qbtuser

zypper --non-interactive remove qbittorrent-nox
rm -rf /home/qbtuser

echo "qBittorrent uninstalled successfully"