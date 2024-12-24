#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop sonarr
rm -rf /opt/Sonarr
rm -rf /var/lib/sonarr
rm -rf /etc/systemd/system/sonarr.service
systemctl -q daemon-reload

userdel -f sonarr
echo "Sonarr uninstalled successfully"