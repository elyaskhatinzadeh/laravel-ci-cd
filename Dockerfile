# Use the official PHP Alpine image
FROM php:8.2-alpine

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install dependencies
RUN apk --no-cache add \
    libzip-dev \
    icu-dev \
    unzip \
    git \
    apache2

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

# Copy application files
COPY . .

# Generate optimized autoload files
RUN composer dump-autoload --optimize

# Set up environment variables
COPY .env.example .env

# Set the correct permissions
RUN chown -R www-data:www-data storage bootstrap/cache public

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Generate the application key
RUN php artisan key:generate

# Copy Apache configuration
COPY apache-config.conf /etc/apache2/conf.d/000-default.conf

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["httpd", "-D", "FOREGROUND"]
