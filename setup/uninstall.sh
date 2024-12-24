#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

zypper --non-interactive remove curl libicu sqlite3 openssl wget
groupdel -f media
userdel -f media
rm -rf /data
echo "Removed prerequisites, media directories, user and group successfully"