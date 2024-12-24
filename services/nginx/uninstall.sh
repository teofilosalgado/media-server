#/bin/bash
# Check if the current user is root
if (( $EUID != 0 )); then
    echo "Please run this script as root."
    exit 1
fi

firewall-cmd --permanent --remove-service=http
firewall-cmd --permanent --remove-service=https
firewall-cmd --reload

zypper --non-interactive remove nginx

rm -rf /usr/local/nginx/ssl

rm /etc/nginx/conf.d/media_server.conf
rm /etc/nginx/proxy_params

echo "Removed services, certificates, sites and nginx successfully"