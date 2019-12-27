#!/bin/bash
set +o pipefail

MARIAKEY1=./key
MARIAKEY2=./key.enc
MARIAKEY3=./.key
openssl rand -hex 32 > $MARIAKEY1
sed -i '1s/^/1;/' $MARIAKEY1
openssl rand -hex 16 > $MARIAKEY3
openssl enc -aes-256-cbc -md sha1 -kfile $MARIAKEY3 -in $MARIAKEY1 -out $MARIAKEY2

# Create MariaDB password
MARIAPWD=./.db_password
MARIAROOTPWD=./.db_root_password
openssl rand -hex 16 > $MARIAPWD
openssl rand -hex 16 > $MARIAROOTPWD

# Create Laravel key files
echo -n "base64:" > ./.nosh_app_key
NOSH_APP_KEY="$(cat /dev/urandom | head -c 32 | base64 >> ./.nosh_app_key)"
echo "Database and app keys for NOSH created."
