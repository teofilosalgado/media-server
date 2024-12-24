#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop prowlarr
rm -rf /opt/Prowlarr
rm -rf /var/lib/prowlarr
rm -rf /etc/systemd/system/prowlarr.service
systemctl -q daemon-reload

userdel -f prowlarr
echo "Prowlarr uninstalled successfully"