# Use the PHP Alpine image
FROM php:8.2-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies using apk
RUN apk --update --no-cache add \
    libzip-dev \
    icu-dev \
    unzip \
    git

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the environment variable to allow Composer to run as superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy the composer.json and composer.lock
COPY composer.json composer.lock ./

# Install application dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the local PHP application to the container
COPY ./ /var/www/html/

# Expose port 80 for the built-in PHP server
EXPOSE 80

# Command to run the PHP built-in server
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
