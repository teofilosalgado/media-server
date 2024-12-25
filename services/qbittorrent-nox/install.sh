#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Install Nginx
zypper --non-interactive install qbittorrent-nox
echo "qBittorrent installed successfully"

# Create 'qbtuser' user
useradd --system --create-home qbtuser
usermod -a -G media qbtuser
echo "Created user 'qbtuser' in the 'media' group"

# Configure qBittorrent
cp services/qbittorrent-nox/assets/qBittorrent.conf /home/qbtuser/.config/qBittorrent/qBittorrent.conf
chown -R qbtuser:media /home/qbtuser/.config/qBittorrent
echo "Configured qBittorrent"

# Create qBittorrent systemd unit
cp services/qbittorrent-nox/assets/qbittorrent-nox.service /etc/systemd/system/qbittorrent-nox.service
systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl start qbittorrent-nox
echo "qBittorrent service created and started"

echo "qBittorrent installed successfully"