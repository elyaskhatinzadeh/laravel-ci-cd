#!/bin/bash

set -e

# Run migrations
php artisan migrate

# Run seeders
php artisan db:seed

# Start Apache or your web server
apache2-foreground
