#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop jellyfin
rm -rf /opt/jellyfin
rm -rf /usr/share/jellyfin-ffmpeg
rm -rf /etc/systemd/system/jellyfin.service
systemctl -q daemon-reload

userdel -f jellyfin
echo "Jellyfin uninstalled successfully"