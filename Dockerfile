# Imagen base
FROM php:8.1-apache

# Instalar dependencias del sistema
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
    libc-client2007e-dev \
    && rm -rf /var/lib/apt/lists/*

# Configurar y compilar extensión IMAP
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install intl \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache

# Habilitar módulos de Apache
RUN a2enmod rewrite headers

# Copiar código de la aplicación
COPY . /var/www/html/

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponer puerto 80
EXPOSE 80

# Comando por defecto
CMD ["apache2-foreground"]
