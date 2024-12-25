#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

# Allow HTTPS and HTTP traffic
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
echo "HTTP and HTTPS firewall services added"

# Allow auto-discovery ports
firewall-cmd --permanent --add-port=1900/udp 
firewall-cmd --permanent --add-port=7359/udp 
firewall-cmd --reload
echo "Auto-discovery firewall ports added"

# Create self-signed certificate
if [[ ! -f "/usr/local/nginx/ssl/certificate.key" && ! -f "/usr/local/nginx/ssl/certificate.crt" ]]; then
    mkdir -p /usr/local/nginx/ssl
    openssl req -batch -quiet -x509 -nodes -newkey rsa:2048 \
        -keyout /usr/local/nginx/ssl/certificate.key \
        -out /usr/local/nginx/ssl/certificate.crt \
        -days 365 -subj "/O=Media Server/CN=media-server"
    echo "Created SSL certificate at /usr/local/nginx/ssl"
fi

# Install Nginx
zypper --non-interactive install nginx
echo "Nginx installed successfully"

# Create new site
cp services/nginx/assets/media_server.conf /etc/nginx/conf.d/media_server.conf
cp services/nginx/assets/proxy_params /etc/nginx/proxy_params
echo "Site created"

# Restart Nginx service
systemctl restart nginx
echo "Nginx service restarted"

echo "Nginx installed successfully"
