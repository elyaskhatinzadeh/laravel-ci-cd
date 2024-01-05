# Use an official PHP runtime as a parent image
FROM php:8.2-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip

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
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 755 storage
RUN chmod -R 755 bootstrap/cache

# Copy entripoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Generate the application key
RUN php artisan key:generate

# Copy Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
