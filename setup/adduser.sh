#!/bin/bash

# This installation script works on Ubuntu 14.04 and 16.04
# Run as root!

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -e

export DEBIAN_FRONTEND=noninteractive

# Setup MySQL user for Mailtrain
mysql -u root --password="$ROOT_PASS" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u root --password="$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON '$DB_USER'.* TO '$DB_USER'@'localhost';"
mysql -u "$DB_USER" --password="$DB_PASS" -e "CREATE database $DB_USER;"

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_USER" < setup/sql/mailtrain.sql

mysql -u mailtrain -p"$MYSQL_PASSWORD" mailtrain <<EOT
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('admin_email','admin@$HOSTNAME', 1) ON DUPLICATE KEY UPDATE \`value\`='admin@$HOSTNAME';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('default_address','admin@$HOSTNAME', 1) ON DUPLICATE KEY UPDATE \`value\`='admin@$HOSTNAME';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_hostname','localhost', 1) ON DUPLICATE KEY UPDATE \`value\`='localhost';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_disable_auth','', 1) ON DUPLICATE KEY UPDATE \`value\`='';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_user','mailtrain', 1) ON DUPLICATE KEY UPDATE \`value\`='mailtrain';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_pass','$SMTP_PASS', 1) ON DUPLICATE KEY UPDATE \`value\`='$SMTP_PASS';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_encryption','NONE', 1) ON DUPLICATE KEY UPDATE \`value\`='NONE';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('smtp_port','2525', 1) ON DUPLICATE KEY UPDATE \`value\`='2525';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('default_homepage','http://$HOSTNAME/', 1) ON DUPLICATE KEY UPDATE \`value\`='http://$HOSTNAME/';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('service_url','http://$HOSTNAME/', 1) ON DUPLICATE KEY UPDATE \`value\`='http://$HOSTNAME/';
INSERT INTO \`settings\` (\`key\`, \`value\`, \`saas_account_id\`) VALUES ('dkim_api_key','$DKIM_API_KEY', 1) ON DUPLICATE KEY UPDATE \`value\`='$DKIM_API_KEY';
EOT

echo "OK"
