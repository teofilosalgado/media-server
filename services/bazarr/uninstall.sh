#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

systemctl -q stop bazarr
rm -rf /opt/Bazarr
rm -rf /etc/systemd/system/bazarr.service
systemctl -q daemon-reload

userdel -f bazarr
echo "Bazarr uninstalled successfully"