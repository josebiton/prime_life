# Base image
FROM php:8.1-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libkrb5-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libonig-dev \
    libzip-dev \
    build-essential \
    wget \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Instalar IMAP desde PECL (compatible con PHP 8.1)
RUN wget https://www2.informatik.hu-berlin.de/~stefan/imap/imap-2007e.tar.gz \
    && tar -xzf imap-2007e.tar.gz \
    && cd imap-2007e \
    && phpize \
    && ./configure --with-kerberos --with-imap-ssl \
    && make && make install \
    && echo "extension=imap.so" > /usr/local/etc/php/conf.d/imap.ini \
    && cd .. && rm -rf imap-2007e imap-2007e.tar.gz

# Instalar extensiones PHP comunes
RUN docker-php-ext-install intl zip mysqli pdo_mysql opcache

# Habilitar módulos Apache necesarios
RUN a2enmod rewrite headers

# Copiar código de la aplicación
COPY . /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponer puerto 80
EXPOSE 80

# Ejecutar Apache
CMD ["apache2-foreground"]
