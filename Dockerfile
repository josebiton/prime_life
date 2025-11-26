FROM php:8.1-apache

# ----------------------------------------------------------------------
# 1. INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA
# ----------------------------------------------------------------------
# Instalamos TODO, incluyendo los headers para IMAP, SSL, y todas las otras extensiones.
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libkrb5-dev \
    libssl-dev \
    # Paquetes esenciales para la compilación de IMAP (UW IMAP client development headers)
    uw-mail-utils \
    build-essential \
    git \
    unzip \
    # Limpieza
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------
# 2. INSTALACIÓN Y CONFIGURACIÓN DE EXTENSIONES PHP
# ----------------------------------------------------------------------
# El comando docker-php-ext-install ahora debería encontrar los headers en /usr/include
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    # Instalamos todas las extensiones requeridas
    && docker-php-ext-install \
        intl \
        zip \
        mysqli \
        pdo \
        pdo_mysql \
        curl \
        xml \
        imap

# ----------------------------------------------------------------------
# 3. CONFIGURACIÓN DE APACHE, COMPOSER Y CÓDIGO
# ----------------------------------------------------------------------
# Habilitar mod_rewrite y permisos de .htaccess
RUN a2enmod rewrite && \
    sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Directorio de trabajo y copia de archivos
WORKDIR /var/www/html/

# Instalar dependencias de Composer (mejor hacerlo aquí para usar el caché de Docker)
COPY composer.* ./
RUN /usr/bin/composer install --no-dev --optimize-autoloader

# Copiar todo el código al directorio de trabajo
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
