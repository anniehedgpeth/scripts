#!/bin/bash

# Set values for variables
set -e

USERNAME=$1
FIRST_NAME=$2
LAST_NAME=$3
USER_EMAIL=$4
PASSWORD=$5
ORGANIZATION_SHORT_NAME=$6
ORGANIZATION_FULL_NAME=$7

# Install chef server with rpm
rpm -Uvh https://packages.chef.io/files/stable/chef-server/12.15.7/el/7/chef-server-core-12.15.7-1.el7.x86_64.rpm

# Configure the server to get all services and database on it
chef-server-ctl reconfigure

# Wait
sleep 5

# Create admin user
chef-server-ctl user-create $USERNAME $FIRST_NAME $LAST_NAME $USER_EMAIL $PASSWORD --filename /home/$USERNAME/$USERNAME.pem

# Create organization
chef-server-ctl org-create $ORGANIZATION_SHORT_NAME \'$ORGANIZATION_FULL_NAME\` --filename ~/$ORGANIZATION_SHORT_NAME-validator.pem

# Add user to organization as an administrator
chef-server-ctl org-user-add $ORGANIZATION_SHORT_NAME $USERNAME --admin

# Install chef manage (web console)
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure
chef-server-ctl install chef-manage

# Reconfigure and start the server
chef-server-ctl reconfigure
chef-server-ctl stop
chef-server-ctl start

# Next command prompts for agreement; it cannot be automated.
# opscode-reporting-ctl reconfigure

# **** This may be able to be automated if the opscode file exits at install.
# Change FQDN in chef-server.rb
# cat >> /etc/opscode/chef-server.rb <<EOF
# api_fqdn = 'testmanagechef.southcentralus.cloudapp.azure.com'
# EOF

# Install certificates according to https://docs.chef.io/config_rb_analytics.html. Add the following lines manually to /etc/opscode/chef-server.rb.
# cat >> /etc/opscode/chef-server.rb <<EOF
# nginx['ssl_certificate']  =
# "/see/your/docs.pem"
# nginx['ssl_certificate_key']  =
# "/see/your/docs.pem"
# nginx['ssl_ciphers'] = "see:your:docs"
# nginx['ssl_protocols'] = 'see your docs'
# EOF

# Reconfigure manage chef manually. This command prompts for agreement; it cannot be automated.
# chef-manage-ctl reconfigure

# Reconfigure and start the server again
# chef-server-ctl reconfigure
# chef-server-ctl stop
# chef-server-ctl start