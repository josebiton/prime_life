# Imagen base PHP 8.1 + Apache
FROM php:8.1-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libkrb5-dev \
    libxml2-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Extensiones PHP principales
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    curl \
    xml

# Instalar IMAP correctamente
RUN docker-php-source extract \
    && rm -rf /usr/src/php/ext/imap \
    && git clone https://github.com/php/pecl-mail-imap.git /usr/src/php/ext/imap \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-source delete

# Activar mod_rewrite de Apache
RUN a2enmod rewrite

# Configurar Apache para permitir .htaccess
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar proyecto al contenedor
COPY . /var/www/html/

# Establecer permisos recomendados
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Puerto expuesto
EXPOSE 80

# Comando final
CMD ["apache2-foreground"]
