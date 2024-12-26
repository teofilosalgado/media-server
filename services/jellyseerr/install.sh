#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

readonly JELLYSEERR_DOWNLOAD_URL="https://github.com/Fallenbagel/jellyseerr.git"

# Download Jellyseerr FFmpeg
if [ ! -d "/opt/jellyseerr" ]; then
    mkdir -p /opt/jellyseerr
    git clone --single-branch --branch main $JELLYSEERR_DOWNLOAD_URL /opt/jellyseerr
    echo "Downloaded Jellyseerr from $JELLYSEERR_DOWNLOAD_URL"
fi

# Install dependencies
zypper --non-interactive install yq nodejs-default npm-default pnpm
echo "Node.js, NPM and PNPM installed successfully"

# Fix Node.js reporting its own version with a "v" prefix to PNPM causing a
# ERR_PNPM_UNSUPPORTED_ENGINE error
git -C /opt/jellyseerr apply "$PWD/services/jellyseerr/assets/fix_node_version.patch"
# Define Next.js "basePath" as "/jellyseerr"
# git -C /opt/jellyseerr apply "$PWD/services/jellyseerr/assets/fix_nextjs_base_path.patch"
# Define Express API base path
# git -C /opt/jellyseerr apply "$PWD/services/jellyseerr/assets/fix_api_base_path.patch"
echo "Patches applied"

# Build Jellyseerr
set CYPRESS_INSTALL_BINARY=0
pnpm --dir /opt/jellyseerr install --frozen-lockfile
pnpm --dir /opt/jellyseerr run build
echo "Built Jellyseerr"
