#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly SONARR_DOWNLOAD_URL="https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64"

# Create 'sonarr' user
useradd --system --no-create-home sonarr
usermod -a -G media sonarr
echo "Created user 'sonarr' in the 'media' group"

# Download Sonarr
if [ ! -f "/tmp/Sonarr.tar.gz" ]; then
    wget -t 3 --content-disposition $SONARR_DOWNLOAD_URL -O /tmp/Sonarr.tar.gz -q --show-progress
    echo "Downloaded Sonarr from $SONARR_DOWNLOAD_URL"
fi

# Extract Sonarr
tar -xzf /tmp/Sonarr.tar.gz -C /opt
chown -R sonarr:media /opt/Sonarr
chmod -R 764 /opt/Sonarr
echo "Extracted Sonarr to /opt/Sonarr"

# Create Sonarr files directory
mkdir -p /var/lib/sonarr
cp services/sonarr/assets/config.xml /var/lib/sonarr/config.xml
chown -R sonarr:media /var/lib/sonarr
chmod -R 764 /var/lib/sonarr
echo "Created Sonarr directory at /var/lib/sonarr"

# Create Sonarr systemd unit
cp services/sonarr/assets/sonarr.service /etc/systemd/system/sonarr.service
systemctl daemon-reload
systemctl enable sonarr
systemctl start sonarr
echo "Sonarr service created and started"

echo "Sonarr installed successfully"