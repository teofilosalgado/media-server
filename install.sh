#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Install prerequisites and create file structure
source setup/install.sh

# Install Nginx
source services/nginx/install.sh

# Install qBittorrent
source services/qbittorrent-nox/install.sh

# Install Sonarr
source services/sonarr/install.sh

# Install Radarr
source services/radarr/install.sh

# Install Bazarr
source services/bazarr/install.sh

# Install Prowlarr
source services/prowlarr/install.sh

# Install Jellyfin
source services/jellyfin/install.sh

# Install Recyclarr