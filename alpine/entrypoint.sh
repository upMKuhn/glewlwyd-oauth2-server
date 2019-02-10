#!/bin/bash

# Check config file

if ! [ -f "/var/glewlwyd/conf/glewlwyd.conf" ]
then
    echo "You need to generate your own configuration file!"
    echo "Mount a volume with file at /var/glewlwyd/conf/glewlwyd.conf"
    echo "More information at https://github.com/rafaelhdr/glewlwyd-oauth2-server#volumes"
fi

if ! [ -d "/var/glewlwyd/keys/" ]
then
    echo "Mount a volume with file at /var/glewlwyd/keys"
    exit 1
fi

if ! [ -f "/var/glewlwyd/keys/ecdsa.pem" ]
then
    openssl ecparam -name sect571r1 -genkey -out /var/glewlwyd/keys/ecdsa.key
    openssl ec -in /var/glewlwyd/keys/ecdsa.key -pubout -out /var/glewlwyd/keys/ecdsa.pem
fi

if [ -d "/var/cache/glewlwyd/" ]
then
    if ! [ -f "/var/cache/glewlwyd/glewlwyd.db" ]
    then
        mkdir -p /var/cache/glewlwyd
        cat /usr/share/init-db/init-sqlite3-sha512.sql | grep -v "VALUES ('admin" >  /usr/share/init-db/init-sqlite3-sha512.sql
        echo "INSERT INTO g_user (gu_login, gu_name, gu_email, gu_password, gu_enabled) VALUES ('admin', 'Admin', '$ADMIN_EMAIL', '$ADMIN_PASS_HASH', 1);" >> /usr/share/init-db/init-sqlite3-sha512.sql
        cat /usr/share/init-db/database/init-sqlite3-sha512.sql | sqlite3  cat /usr/share/init-db/database/init-sqlite3-sha512.sql | sqlite3 /var/cache/glewlwyd/glewlwyd.db
    fi
fi

# Run application
/usr/bin/glewlwyd --config-file=/var/glewlwyd/conf/glewlwyd.conf

# Error code
status_code=$?
if [ "$status_code" != "0" ]
then
    if [ "$status_code" = "2" ]
    then
        echo "Error on database connection!"
    else
        echo "Error on glewlwyd!"
    fi
fi
