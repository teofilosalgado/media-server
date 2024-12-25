#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

zypper --non-interactive remove plexmediaserver
zypper --non-interactive rr PlexRepo