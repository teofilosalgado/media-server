#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly PROWLARR_DOWNLOAD_URL="http://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"

# Create 'prowlarr' user
useradd --system --no-create-home prowlarr
usermod -a -G media prowlarr
echo "Created user 'prowlarr' in the 'media' group"

# Download Prowlarr
if [ ! -f "/tmp/Prowlarr.tar.gz" ]; then
    wget -t 3 --content-disposition $PROWLARR_DOWNLOAD_URL -O /tmp/Prowlarr.tar.gz -q --show-progress
    echo "Downloaded Prowlarr from $PROWLARR_DOWNLOAD_URL"
fi

# Extract Prowlarr
tar -xzf /tmp/Prowlarr.tar.gz -C /opt
chown -R prowlarr:media /opt/Prowlarr
chmod -R 764 /opt/Prowlarr
echo "Extracted Prowlarr to /opt/Prowlarr"

# Create Prowlarr files directory
mkdir -p /var/lib/prowlarr
cp services/prowlarr/assets/config.xml /var/lib/prowlarr/config.xml
chown -R prowlarr:media /var/lib/prowlarr
chmod -R 764 /var/lib/prowlarr
echo "Created Prowlarr directory at /var/lib/prowlarr"

# Create Prowlarr systemd unit
cp services/prowlarr/assets/prowlarr.service /etc/systemd/system/prowlarr.service
systemctl daemon-reload
systemctl enable prowlarr
systemctl start prowlarr
echo "Prowlarr service created and started"

echo "Prowlarr installed successfully"