#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly RECYCLARR_DOWNLOAD_URL="https://github.com/recyclarr/recyclarr/releases/latest/download/recyclarr-linux-x64.tar.xz"

# Download Recyclarr
if [ ! -f "/tmp/Recyclarr.tar.gz" ]; then
    wget -t 3 --content-disposition $RECYCLARR_DOWNLOAD_URL -O /tmp/Recyclarr.tar.gz -q --show-progress
    echo "Downloaded Recyclarr from $RECYCLARR_DOWNLOAD_URL"
fi

# Extract Recyclarr
tar -xf /tmp/Recyclarr.tar.gz -C /usr/local/bin
echo "Extracted Recyclarr to /usr/local/bin/recyclarr"

# Synchronize settings
recyclarr sync --config services/recylarr/assets/recyclarr.yaml
echo "Synchronized settings"

echo "Recyclarr installed successfully"