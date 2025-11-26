FROM php:8.1-apache

# Actualizar repos
RUN apt-get update

# Instalar dependencias válidas para Debian 12/13
RUN apt-get install -y \
    cron \
    g++ \
    gettext \
    libicu-dev \
    openssl \
    libc-client2007e-dev \
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
    ca-certificates

# Extensiones PHP comunes
RUN docker-php-ext-install intl bcmath bz2 tidy xsl zip

# Configurar y compilar GD
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    && docker-php-ext-install gd

# Instalar IMAP correctamente en Debian moderno
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# Habilitar módulos de Apache
RUN a2enmod rewrite

# Copiar proyecto
COPY . /var/www/html/

# Ajustar permisos
RUN chown -R www-data:www-data /var/www/html
