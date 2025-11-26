# Dockerfile definitivo (Base PHP 8.2 con Apache)

# Usamos la imagen base de PHP 8.2 con Apache
FROM php:8.2-apache

# Establecemos el directorio de trabajo (donde se ejecutarán los comandos y donde irá el código)
WORKDIR /var/www/html

# ----------------------------------------------------------------------
# 1. INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA
# ----------------------------------------------------------------------
# Instalamos los paquetes de desarrollo necesarios para compilar las extensiones de PHP.
RUN apt-get update && apt-get install -y \
    # Dependencias para PHP, incluyendo IMAP (uw-mail-utils) y compilación
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libkrb5-dev \
    libssl-dev \
    uw-mail-utils \
    build-essential \
    git \
    unzip \
    mariadb-client \
    # Limpieza
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------
# 2. INSTALACIÓN Y CONFIGURACIÓN DE EXTENSIONES PHP
# ----------------------------------------------------------------------
# 1. Configurar y compilar IMAP con soporte SSL/Kerberos
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl

# 2. Instalar todas las extensiones requeridas en una sola línea
RUN docker-php-ext-install \
    intl \
    zip \
    mysqli \
    pdo \
    pdo_mysql \
    curl \
    xml \
    mbstring \
    imap

# ----------------------------------------------------------------------
# 3. CONFIGURACIÓN DE APACHE Y COMPOSER
# ----------------------------------------------------------------------
# Habilitar mod_rewrite y permitir .htaccess
RUN a2enmod rewrite && \
    sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Instalar Composer (copiamos el binario desde la imagen oficial de Composer)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiamos solo los archivos de Composer para poder instalar las dependencias con caché
COPY composer.* ./
RUN composer install --no-dev --optimize-autoloader

# Copiamos el resto del código del proyecto al directorio de trabajo
COPY . /var/www/html/

# Ajustamos permisos finales para Apache (www-data)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponemos el puerto 80 para Apache
EXPOSE 80

# Comando para arrancar Apache
CMD ["apache2-foreground"]
