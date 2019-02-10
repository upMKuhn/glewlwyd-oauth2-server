#!/bin/bash

# Check config file

if ! [ -f "/var/glewlwyd/conf/glewlwyd.conf" ]
then
    echo "You need to generate your own configuration file!"
    echo "Mount a volume with file at /var/glewlwyd/conf/glewlwyd.conf"
    echo "More information at https://github.com/rafaelhdr/glewlwyd-oauth2-server#volumes"
fi

if ! [ -f "/var/glewlwyd/keys" ]
then
    echo "Mount a volume with file at /var/glewlwyd/keys"
    exit 1
fi

if ! [ -f "/var/glewlwyd/keys/ecdsa.pem" ]
then
    openssl ecparam -name sect571r1 -genkey -noout -out /var/glewlwyd/keys/ecdsa.pem
    openssl ec -in /var/glewlwyd/keys/ecdsa.pem -pubout -out /var/glewlwyd/keys/ecdsa.key
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
