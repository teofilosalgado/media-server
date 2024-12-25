#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Uninstall Jellyfin
source services/jellyfin/uninstall.sh

# Uninstall Prowlarr
source services/prowlarr/uninstall.sh

# Uninstall Bazarr
source services/bazarr/uninstall.sh

# Uninstall Radarr
source services/radarr/uninstall.sh

# Uninstall Sonarr
source services/sonarr/uninstall.sh

# Uninstall qBittorrent
source services/qbittorrent-nox/uninstall.sh

# Uninstall Nginx
source services/nginx/uninstall.sh

# Uninstall prerequisites and create file structure
source setup/uninstall.sh