#!/bin/bash

echo "Trying to initialize services..."

service postgresql start

service memcached start

service php7.0-fpm start

service nginx start

service cron start

echo "Done!"

echo ""

echo "Trying to install Composer's instance libraries..."

composer install -d /var/www/app

echo "Done!"

echo ""

if su - postgres -c "psql -lqt | cut -d \| -f 1 | grep -vE 'postgres|template0|template1' | grep -v -e '^[[:space:]]*$'"; then
    echo "Instance database already loaded!"
else
    echo "Creating and loading instance database..."
	
	su - postgres -c "createuser -E titan"
    su - postgres -c "createdb -E utf8 -O titan -T template0 instance"
    su - postgres -c "psql -d instance -U titan < db/last.sql"
	
	echo "Done!"
fi

echo ""

echo "All done!"

read trash
