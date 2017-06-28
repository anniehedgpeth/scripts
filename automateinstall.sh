#!/bin/bash

# Set values for variables
set -e

ADMIN_USERNAME=$1
AUTOMATE_DOWNLOAD_URL=$2
AUTOMATE_LICENSE=$3
AUTOMATE_CHEF_USER_KEY=$4
CHEF_SERVER_FQDN=$5
ORGANIZATION_SHORT_NAME=$6
AUTOMATE_SERVER_FQDN=$7
ENTERPRISE_NAME=$8
SUPERMARKET_FQDN=$9

# Install Chef Automate server with rpm
rpm -Uvh $AUTOMATE_DOWNLOAD_URL

# Do a preflight-check
automate-ctl prelight-check

# Configure Automate server; ensure that the delivery.license is on the Chef Server
automate-ctl setup --license "/home/$ADMIN_USERNAME/$AUTOMATE_LICENSE" \ 
                   --key "$AUTOMATE_CHEF_USER_KEY" \ 
                   --server-url https://$CHEF_SERVER_FQDN/organizations/$ORGANIZATION_SHORT_NAME \ 
                   --fqdn $AUTOMATE_SERVER_FQDN \ 
                   --enterprise $ENTERPRISE_NAME \
                   --supermarket-fqdn $SUPERMARKET_FQDN \
                   --configure

# Reconfigure
automate-ctl reconfigure
