# Use the PHP Alpine image
FROM php:8.2-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apk --update --no-cache add \
    libzip-dev \
    icu-dev \
    unzip \
    git \
    autoconf \
    g++ \
    make \
    pcre-dev \
    && docker-php-ext-install pdo_mysql zip intl \
    && apk del autoconf g++ make pcre-dev \
    && rm -rf /var/cache/apk/*

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

# Generate optimized autoload files
RUN composer dump-autoload --optimize

# Set up environment variables
COPY .env.example .env

# Set the correct permissions
RUN chown -R www-data:www-data storage bootstrap/cache public

# Generate the application key
RUN php artisan key:generate

# Expose port 80 for the built-in PHP server
EXPOSE 80

# Start Apache
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
