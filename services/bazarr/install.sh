#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly BAZARR_DOWNLOAD_URL="https://github.com/morpheus65535/bazarr/releases/latest/download/bazarr.zip"

# Create 'bazarr' user
useradd --system --no-create-home bazarr
usermod -a -G media bazarr
echo "Created user 'bazarr' in the 'media' group"

# Download Bazarr
if [ ! -f "/tmp/Bazarr.zip" ]; then
    wget -t 3 --content-disposition $BAZARR_DOWNLOAD_URL -O /tmp/Bazarr.zip -q --show-progress
    echo "Downloaded Bazarr from $BAZARR_DOWNLOAD_URL"
fi

# Extract Bazarr
unzip -o -q /tmp/Bazarr.zip -d /opt/Bazarr
echo "Extracted Bazarr to /opt/Bazarr"

# Create Python virtual environment
python3 -m venv /opt/Bazarr/.venv
echo "Created virtual environment at /opt/Bazarr/.venv"

# Install Python packages
/opt/Bazarr/.venv/bin/python3 -m pip install --upgrade pip
/opt/Bazarr/.venv/bin/python3 -m pip install -r /opt/Bazarr/requirements.txt 
echo "Python packages installed successfully"

# Update Bazarr settings
mkdir -p /opt/Bazarr/data/config
cp services/bazarr/assets/config.yaml /opt/Bazarr/data/config/config.yaml
echo "Bazarr settings updated"

# Update ownership
chown -R bazarr:media /opt/Bazarr
chmod -R 764 /opt/Bazarr
echo "Ownership updated"

# Create Bazarr systemd unit
cp services/bazarr/assets/bazarr.service /etc/systemd/system/bazarr.service
systemctl daemon-reload
systemctl enable bazarr
systemctl start bazarr
echo "Bazarr service created and started"

echo "Bazarr installed successfully"