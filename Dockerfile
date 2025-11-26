FROM php:8.1-apache

# ----------------------------------------------------------------------
# 1. INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA
# ----------------------------------------------------------------------
# Incluye paquetes de desarrollo requeridos para compilar PHP extensions (ej. intl, zip, IMAP)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    # 🚨 CORRECCIÓN CLAVE: libc-client-dev es obsoleto. Usamos libimap-dev.
    libimap-dev \
    libkrb5-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libonig-dev \
    libzip-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------
# 2. INSTALACIÓN Y CONFIGURACIÓN DE EXTENSIONES PHP
# ----------------------------------------------------------------------

# Extensiones estándar (intl, zip, etc.)
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl zip mysqli pdo pdo_mysql curl xml

# Compilar IMAP (Usando el método estándar de docker-php-ext-install)
# Si libimap-dev está instalado correctamente, esto debería funcionar.
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# ----------------------------------------------------------------------
# 3. CONFIGURACIÓN DE APACHE
# ----------------------------------------------------------------------
# Habilitar mod_rewrite
RUN a2enmod rewrite
# Permitir que el archivo .htaccess anule la configuración (requerido para frameworks MVC)
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# ----------------------------------------------------------------------
# 4. INSTALAR COMPOSER Y CÓDIGO
# ----------------------------------------------------------------------
# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Directorio de trabajo y copia de archivos
WORKDIR /var/www/html/

# Instalar dependencias de Composer antes de copiar el resto del código
COPY composer.* ./
RUN /usr/bin/composer install --no-dev --optimize-autoloader

# Copiar todo el código al directorio de trabajo
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
