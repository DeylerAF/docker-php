# Use official PHP 8.2.5 image with Apache as web server
FROM php:8.2.5-apache-bullseye

# Expose port 80 for access to web server
EXPOSE 80

# Copy composer.json to the correct location
#COPY composer.json /var/www/html

# Copy php.ini to the correct location
COPY php.ini /usr/local/etc/php/

# Install required libraries and PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zip \
    unzip \
    curl \
    redis-tools \
    libonig-dev \
    libzip-dev \
    git \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli bcmath zip mbstring exif pcntl \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug mysqli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the COMPOSER_ALLOW_SUPERUSER environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Clone the repository into the container's /var/www/html directory
RUN git clone https://github.com/DeylerAF/app-php.git /var/www/html

# Copy the application files to the container's /var/www/html directory
#COPY /src /var/www/html

# Set the working directory to /var/www/html
WORKDIR /var/www/html