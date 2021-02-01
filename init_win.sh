#!/bin/bash
# Init for Docker-NOSH

set -e
# if ! [ -x "$(command -v docker)" ]; then
#     echo 'Error: docker is not installed.' >&2
#     exit 1
# fi
# if ! [ -x "$(command -v docker-compose)" ]; then
#     echo 'Error: docker-compose is not installed.' >&2
#     exit 1
# fi
read -e -r -p "What is your domain name where NOSH will be served? (example.com); leave blank if none" -i "" domain
echo "Docker installed, generating keys..."
winpty docker run -it -v /"$(pwd)":/data alpine //bin/sh -c "apk update \
&& apk add --no-cache openssl shadow \
&& rm -rf /var/cache/apk/* \
&& cd /data \
&& openssl rand -hex 32 > key \
&& sed -i '1s/^/1;/' key \
&& openssl rand -hex 16 > .key \
&& openssl enc -aes-256-cbc -md sha1 -kfile .key -in key -out key.enc \
&& openssl rand -hex 16 > .db_password \
&& openssl rand -hex 16 > .db_root_password \
&& echo -n 'base64:' > .nosh_app_key \
&& cat /dev/urandom | head -c 32 | base64 >> .nosh_app_key"
sed -i "s=\./=/$(pwd)/=" docker-compose.yml
if [[ -n $domain ]]; then
    read -e -r -p "What is your email address?  This is to register your SSL certificate." -i "" email
    cp nginx_ssl.conf nginx.conf
    sed -i "s/example.org/$domain/" nginx.conf
    echo "https://$domain/nosh" > nosh_uri.txt
    domains=("$domain" www."$domain")
    rsa_key_size=4096
    data_path="$(pwd)/certbot"
    staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits
    if [ -d "$data_path" ]; then
        read -r -p "Existing data found for $domain. Continue and replace existing certificate? (y/N) " decision
        if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
            exit
        fi
    fi
    if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
        echo "Downloading recommended TLS parameters ..."
        mkdir -p "$data_path/conf"
        curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
        curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
        echo
    fi
    echo "Creating dummy certificate for $domain ..."
    path="/etc/letsencrypt/live/$domain"
    mkdir -p "$data_path/conf/live/$domain"
    winpty docker-compose run --rm --entrypoint "\
        openssl req -x509 -nodes -newkey rsa:1024 -days 1\
            -keyout '$path/privkey.pem' \
            -out '$path/fullchain.pem' \
            -subj '/CN=localhost'" certbot
    echo
    echo "Starting nginx ..."
    winpty docker-compose up --force-recreate -d webserver
    echo
    echo "Deleting dummy certificate for $domain ..."
    winpty docker-compose run --rm --entrypoint "\
        rm -Rf /etc/letsencrypt/live/$domain && \
        rm -Rf /etc/letsencrypt/archive/$domain && \
        rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot
    echo
    echo "Requesting Let's Encrypt certificate for $domain ..."
    # Join $domains to -d args
    domain_args=""
    for domain1 in "${domains[@]}"; do
      domain_args="$domain_args -d $domain1"
    done
    # Select appropriate email arg
    case "$email" in
      "") email_arg="--register-unsafely-without-email" ;;
      *) email_arg="--email $email" ;;
    esac
    # Enable staging mode if needed
    if [ $staging != "0" ]; then staging_arg="--staging"; fi
    winpty docker-compose run --rm --entrypoint "\
        certbot certonly --webroot -w /var/www/certbot \
            $staging_arg \
            $email_arg \
            $domain_args \
            --rsa-key-size $rsa_key_size \
            --agree-tos \
            --force-renewal" certbot
    echo
    echo "Reloading nginx ..."
    winpty docker-compose exec webserver webserver -s reload
else
    cp nginx_old.conf nginx.conf
fi
echo "Running NOSH..."
winpty docker-compose up -d
exit 0
