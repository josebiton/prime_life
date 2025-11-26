# Imagen base de PHP 8.1 con Apache
FROM php:8.1-apache

# Instalar dependencias del sistema y extensiones de PHP
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
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configurar y compilar extensiones de PHP necesarias
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install intl \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache

# Habilitar módulos de Apache si es necesario
RUN a2enmod rewrite headers

# Copiar el código de la aplicación al contenedor
COPY . /var/www/html/

# Establecer permisos correctos (opcional, según tu proyecto)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponer el puerto 80 para Apache
EXPOSE 80

# Comando por defecto para iniciar Apache en primer plano
CMD ["apache2-foreground"]
