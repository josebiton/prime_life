FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libc-client-dev \
    libkrb5-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Compilar IMAP SIN usar PECL (método correcto en PHP 8.1)
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

# Extensiones adicionales
RUN docker-php-ext-install mysqli pdo pdo_mysql zip curl xml

# Habilitar mod_rewrite
RUN a2enmod rewrite
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
