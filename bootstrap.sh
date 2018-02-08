#!/bin/bash

echo "Start provisioner script..."

echo "Updating, upgrading and dist upgrading..."

apt-get -y update
apt-get -y upgrade

echo "Done!"

echo "Install a lot of dependencies..."

echo "postfix postfix/mailname string localhost" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install -y antiword curl default-jdk git libav-tools locales mailutils memcached nginx php7.0-fpm php7.0-cli php7.0-curl php7.0-dev php7.0-gd php7.0-imagick php7.0-ldap php7.0-mbstring php7.0-mcrypt php7.0-memcached php7.0-pgsql php7.0-sqlite postfix postgresql-9.6 unzip vim xpdf-utils

echo "Done!"

echo "Configuring locales..."

locale-gen "en_US.UTF-8"
locale-gen "es_ES.UTF-8"
locale-gen "pt_BR.UTF-8"

echo -e 'LANG="en_US.utf8"' > /etc/default/locale

dpkg-reconfigure --frontend=noninteractive locales

echo "Done!"

echo "Installing PHP Composer..."

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "Done!"

echo "Cleaning apt-get..."

apt-get autoremove
apt-get clean -y
apt-get autoclean -y

find /var/lib/apt -type f | xargs rm -f

echo "Done!"

echo "Configuring services..."

echo "Vim..."

cp -f /root/docker/settings/defaults.vim /usr/share/vim/vim80/defaults.vim

echo "Done!"

echo "PostgreSQL..."

cp -f /root/docker/settings/pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf

cp -f /root/docker/settings/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf

service postgresql restart

echo "Done!"

echo "Memcached..."

cp -f /root/docker/settings/memcached.conf /etc/memcached.conf

service memcached restart

echo "Done!"

echo "PHP 7.0 FPM..."

cp -f /root/docker/settings/php-fpm.ini /etc/php/7.0/fpm/php.ini

cp -f /root/docker/settings/php-cli.ini /etc/php/7.0/cli/php.ini

cp -f /root/docker/settings/php-www.conf /etc/php/7.0/fpm/pool.d/www.conf

service php7.0-fpm restart

echo "Done!"

echo "Nginx..."

rm -rf /var/www/html

mkdir -p /var/www/log

cp -f /root/docker/settings/nginx-default /etc/nginx/sites-available/default

service nginx restart

echo "Done!"

echo "CRON..."

cp /root/docker/settings/cron /etc/cron.d/titan

service cron reload
service cron restart

echo "Done!"

echo "Getting Titan Framework..."

composer create-project titan-framework/install /var/www/titan

chown -R root:staff /var/www/titan
find /var/www/titan -type d -exec chmod 775 {} \;
find /var/www/titan -type f -exec chmod 664 {} \;

echo "Done!"

echo "All done!"
