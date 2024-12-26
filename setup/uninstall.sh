#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

zypper --non-interactive remove 7zip git libicu sqlite3 openssl python311 python311-devel python311-pip unrar unzip wget
groupdel -f media
userdel -f media
rm -rf /data
echo "Removed prerequisites, media directories, user and group successfully"