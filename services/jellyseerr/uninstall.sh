#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop jellyseerr
rm -rf /opt/jellyseerr
rm -rf /etc/jellyseerr
rm -rf /etc/systemd/system/jellyseerr.service
systemctl -q daemon-reload

userdel -f jellyseerr
echo "Jellyseerr uninstalled successfully"
