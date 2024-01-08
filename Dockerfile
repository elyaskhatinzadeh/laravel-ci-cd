# Use the PHP Alpine image
FROM php:8.2-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the local PHP application to the container
COPY ./ /var/www/html/

# Expose port 80 for the built-in PHP server
EXPOSE 80

# Command to run the PHP built-in server
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
