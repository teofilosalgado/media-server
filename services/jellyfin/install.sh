#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Constants
readonly JELLYFIN_SERVER_DIRECTORY_URL="https://repo.jellyfin.org/files/server/linux/latest-stable/amd64/"
readonly JELLYFIN_SERVER_PACKAGE_NAME=$(wget -q -O - $JELLYFIN_SERVER_DIRECTORY_URL | grep -o -P '(?<=href=")(jellyfin_.*amd64\.tar\.gz)(?=")')
readonly JELLYFIN_SERVER_DOWNLOAD_URL="$JELLYFIN_SERVER_DIRECTORY_URL/$JELLYFIN_SERVER_PACKAGE_NAME"

readonly JELLYFIN_FFMPEG_DIRECTORY_URL="https://repo.jellyfin.org/files/ffmpeg/linux/7.x/"
readonly JELLYFIN_FFMPEG_PACKAGE_VERSION=$(wget -q -O - $JELLYFIN_FFMPEG_DIRECTORY_URL | tac | grep -o -P -m 1 '(?<=href=")(.*)(?=")')
readonly JELLYFIN_FFMPEG_PACKAGE_NAME=$(wget -q -O - "$JELLYFIN_FFMPEG_DIRECTORY_URL/$JELLYFIN_FFMPEG_PACKAGE_VERSION/amd64" | grep -o -P '(?<=href=")(jellyfin-ffmpeg_.*\.tar\.xz)(?=")')
readonly JELLYFIN_FFMPEG_SERVER_DOWNLOAD_URL="$JELLYFIN_FFMPEG_DIRECTORY_URL/$JELLYFIN_FFMPEG_PACKAGE_VERSION/amd64/$JELLYFIN_FFMPEG_PACKAGE_NAME"

# Create 'jellyfin' user
useradd --system --no-create-home jellyfin
usermod -a -G media jellyfin
echo "Created user 'jellyfin' in the 'media' group"

# Download Jellyfin Server
if [ ! -f "/tmp/Jellyfin.tar.gz" ]; then
    wget -t 3 --content-disposition $JELLYFIN_SERVER_DOWNLOAD_URL -O /tmp/Jellyfin.tar.gz -q --show-progress
    echo "Downloaded Jellyfin Server from $JELLYFIN_SERVER_DOWNLOAD_URL"
fi

# Extract Jellyfin Server
tar -xzf /tmp/Jellyfin.tar.gz -C /opt
cp services/jellyfin/assets/jellyfin.sh /opt/jellyfin/jellyfin.sh
mkdir -p /opt/jellyfin/config
cp services/jellyfin/assets/network.xml /opt/jellyfin/config/network.xml
chown -R jellyfin:media /opt/jellyfin
chmod -R 764 /opt/jellyfin
echo "Extracted Jellyfin Server to /opt/jellyfin"

# Download Jellyfin FFmpeg
if [ ! -f "/tmp/Jellyfin FFmpeg.tar.xz" ]; then
    wget -t 3 --content-disposition $JELLYFIN_FFMPEG_SERVER_DOWNLOAD_URL -O "/tmp/Jellyfin FFmpeg.tar.xz" -q --show-progress
    echo "Downloaded Jellyfin FFmpeg from $JELLYFIN_FFMPEG_SERVER_DOWNLOAD_URL"
fi

# Extract Jellyfin FFmpeg
mkdir -p /usr/share/jellyfin-ffmpeg
tar -xf "/tmp/Jellyfin FFmpeg.tar.xz" -C /usr/share/jellyfin-ffmpeg
chown -R jellyfin:media /usr/share/jellyfin-ffmpeg
chmod -R 764 /usr/share/jellyfin-ffmpeg
echo "Extracted Jellyfin FFmpeg to /usr/share/jellyfin-ffmpeg"

# Create Jellyfin systemd unit
cp services/jellyfin/assets/jellyfin.service /etc/systemd/system/jellyfin.service
systemctl daemon-reload
systemctl enable jellyfin
systemctl start jellyfin
echo "Jellyfin service created and started"