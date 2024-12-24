#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly RADARR_DOWNLOAD_URL="http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"

# Create 'radarr' user
useradd --system --no-create-home radarr
usermod -a -G media radarr
echo "Created user 'radarr' in the 'media' group"

# Download Radarr
if [ ! -f "/tmp/Radarr.tar.gz" ]; then
    wget -t 3 --content-disposition $RADARR_DOWNLOAD_URL -O /tmp/Radarr.tar.gz -q --show-progress
    echo "Downloaded Radarr from $RADARR_DOWNLOAD_URL"
fi

# Extract Sonarr
tar -xzf /tmp/Radarr.tar.gz -C /opt
chown -R radarr:media /opt/Radarr
chmod -R 764 /opt/Radarr
echo "Extracted Radarr to /opt/Radarr"

# Create Radarr files directory
mkdir -p /var/lib/radarr
cp services/radarr/assets/config.xml /var/lib/radarr/config.xml
chown -R radarr:media /var/lib/radarr
chmod -R 764 /var/lib/radarr
echo "Created Radarr directory at /var/lib/radarr"

# Create Radarr systemd unit
cp services/radarr/assets/radarr.service /etc/systemd/system/radarr.service
systemctl daemon-reload
systemctl enable radarr
systemctl start radarr
echo "Radarr service created and started"

echo "Radarr installed successfully"