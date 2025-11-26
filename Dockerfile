FROM php:8.1-apache

# Actualizar paquetes e instalar dependencias
RUN apt-get update && apt-get install -y \
    git \
    cron \
    g++ \
    gettext \
    libicu-dev \
    openssl \
    libkrb5-dev \
    libxml2-dev \
    libfreetype6-dev \
    libgd-dev \
    bzip2 \
    libbz2-dev \
    libtidy-dev \
    libcurl4-openssl-dev \
    libxslt1-dev \
    pkg-config \
    libzip-dev \
    unzip \
    ca-certificates \
    libc6-dev \
    libpam0g-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar IMAP desde PECL
RUN docker-php-source extract \
    && git clone https://github.com/php/pecl-mail-imap.git /usr/src/php/ext/imap \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-source delete

# Extensiones comunes de PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql intl zip bcmath exif

# Habilitar Apache rewrite
RUN a2enmod rewrite
