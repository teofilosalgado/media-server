#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

rpm --import https://downloads.plex.tv/plex-keys/PlexSign.key
zypper ar -efgc 'https://downloads.plex.tv/repo/rpm/$basearch/' PlexRepo
zypper --non-interactive install plexmediaserver