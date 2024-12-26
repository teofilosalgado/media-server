#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Install prerequisite packages
zypper --non-interactive install 7zip git libicu nodejs-default npm-default pnpm python311 python311-devel python311-pip sqlite3 unrar unzip wget yq
echo "Prerequisites installed successfully"

# Create the media group
groupadd -f media
echo "Created group 'media'"

# Create the media user
useradd -g media --system --no-create-home media
echo "Created user 'media'"

# Create the following file structure according to
# https://trash-guides.info/File-and-Folder-Structure/How-to-set-up/Native/
# /data
# ├── torrents
# │   ├── books
# │   ├── movies
# │   ├── music
# │   └── tv
# └── media
#     ├── books
#     ├── movies
#     ├── music
#     └── tv
declare -a directories=("books" "movies" "music" "tv")
for directory in "${directories[@]}"
do
    mkdir -p "/data/torrents/$directory"
    echo "Created '$directory' folder at '/data/torrents'"
    mkdir -p "/data/media/$directory"
    echo "Created '$directory' folder at '/data/media'"
done
chown -R media:media /data
chmod -R 770 /data
