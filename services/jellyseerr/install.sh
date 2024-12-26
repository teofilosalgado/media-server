#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

readonly JELLYSEERR_DOWNLOAD_URL="https://github.com/Fallenbagel/jellyseerr.git"

# Create 'jellyseerr' user
useradd --system --no-create-home jellyseerr
usermod -a -G media jellyseerr
echo "Created user 'jellyseerr' in the 'media' group"

# Download Jellyseerr FFmpeg
if [ ! -d "/opt/jellyseerr" ]; then
    mkdir -p /opt/jellyseerr
    git clone --single-branch --branch main $JELLYSEERR_DOWNLOAD_URL /opt/jellyseerr
    echo "Downloaded Jellyseerr from $JELLYSEERR_DOWNLOAD_URL"
fi

# Fix Node.js reporting its own version with a "v" prefix to PNPM causing a
# ERR_PNPM_UNSUPPORTED_ENGINE error
git -C /opt/jellyseerr apply "$PWD/services/jellyseerr/assets/fix_node_version.patch"
echo "Patches applied"

# Build Jellyseerr
# set CYPRESS_INSTALL_BINARY=0
# pnpm --dir /opt/jellyseerr install --frozen-lockfile
# pnpm --dir /opt/jellyseerr run build
# echo "Built Jellyseerr"

# Update ownership
mkdir -p /etc/jellyseerr
cp services/jellyseerr/assets/jellyseerr.conf /etc/jellyseerr/jellyseerr.conf
chown -R jellyseerr:media /etc/jellyseerr /opt/jellyseerr
chmod -R 764 /etc/jellyseerr /opt/jellyseerr
echo "Ownership updated"

# Create Jellyseerr systemd unit
cp services/jellyseerr/assets/jellyseerr.service /etc/systemd/system/jellyseerr.service
systemctl daemon-reload
systemctl enable jellyseerr
systemctl start jellyseerr
echo "Jellyseerr service created and started"