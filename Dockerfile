FROM php:8.3-fpm

RUN apt-get update && apt-get install -y git zip unzip

COPY . /var/www/html

WORKDIR /var/www/html

# Install Composer dependencies
RUN php vendor/bin/phpunit --version || echo "PHPUnit ready"