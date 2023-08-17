# Use official PHP 8.2.5 image with Apache as web server
FROM php:8.2.8-apache-bullseye

# Expose ports
EXPOSE 80
EXPOSE 443

# Set the working directory to /var/www/html
WORKDIR /var/www/html

#Install required libraries and PHP extensions

RUN apt update
RUN apt upgrade -y
RUN apt install -y apt-utils
RUN apt install -y openssl
RUN apt install -y curl
RUN apt install -y libcurl3-dev
RUN docker-php-ext-install curl
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN apt install -y zip
RUN apt install -y unzip
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN apt install -y git
RUN apt install -y libmcrypt-dev
RUN apt install -y libicu-dev
RUN apt install -y libxml2-dev
RUN apt install -y libldb-dev
RUN apt install -y libldap2-dev
RUN apt install -y libxml2-dev
RUN apt install -y libssl-dev
RUN apt install -y libxslt-dev
RUN apt install -y libpq-dev
RUN apt install -y libsqlite3-dev
RUN apt install -y libsqlite3-0
RUN apt install -y libc-client-dev
RUN apt install -y libkrb5-dev
RUN apt install -y firebird-dev
RUN apt install -y redis-tools
RUN apt install -y libonig-dev
RUN apt-get install -y libpspell-dev
RUN apt-get install -y aspell-en
RUN apt-get install -y aspell-de  
RUN apt install -y libtidy-dev
RUN apt install -y libsnmp-dev
RUN apt install -y librecode0
RUN apt install -y librecode-dev
RUN apt install -y postgresql-client
RUN docker-php-ext-install -j$(nproc) intl
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install soap
RUN docker-php-ext-install ftp
RUN docker-php-ext-install xsl
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install calendar
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dba
RUN docker-php-ext-install dom
RUN docker-php-ext-install session
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install intl
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install gettext
RUN docker-php-ext-install iconv
RUN docker-php-ext-install pdo_firebird
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install phar
RUN docker-php-ext-install posix
RUN docker-php-ext-install pspell
RUN docker-php-ext-install shmop
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install snmp
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install tidy
RUN docker-php-ext-install xml

#RUN apt install -y libgmp-dev # idk
#RUN apt install -y freetds-dev # idk
#RUN apt install -y libreadline-dev # idk
#RUN apt install -y libxml2-dev # idk
#RUN docker-php-ext-install pdo_oci # idk
#RUN docker-php-ext-install pdo_odbc # idk
#RUN docker-php-ext-install gmp # idk
#RUN docker-php-ext-install odbc # idk
#RUN docker-php-ext-install pdo_dblib  # idk
#RUN docker-php-ext-install oci8 # idk
#RUN docker-php-ext-install readline # idk
#RUN docker-php-ext-install xmlreader # idk

# # RUN apt install -y php-apc
# # RUN apt install -y mysql-client
# # RUN apt install -y libcurl3
# # RUN apt install -y libzip
# # RUN pecl install apc
# # RUN yes | pecl install xdebug \
# #     && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
# #     && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
# #     && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
# # RUN docker-php-ext-install xmlwriter
# # RUN docker-php-ext-install xmlrpc
# # RUN docker-php-ext-install wddx
# # RUN docker-php-ext-install recode
# # RUN docker-php-ext-install interbase
# # RUN docker-php-ext-install mcrypt
# # RUN docker-php-ext-install hash
# # RUN docker-php-ext-install json
# # RUN docker-php-ext-install tokenizer


# Install Composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
# Set the COMPOSER_ALLOW_SUPERUSER environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

# Configure Apache with SSL
RUN a2enmod ssl
RUN a2ensite default-ssl

# Update Apache config to use the self-signed certificate
RUN sed -i 's/\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem/\/etc\/ssl\/certs\/localhost.crt/g' /etc/apache2/sites-available/default-ssl.conf
RUN sed -i 's/\/etc\/ssl\/private\/ssl-cert-snakeoil.key/\/etc\/ssl\/private\/localhost.key/g' /etc/apache2/sites-available/default-ssl.conf


# Enable default SSL site
RUN a2ensite default-ssl

# Restart Apache to apply changes
RUN service apache2 restart

# Start the Apache web server when the container starts
CMD ["apache2-foreground"]