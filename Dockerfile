# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Instalamos extensiones necesarias de PHP y utilidades
RUN apt-get update && apt-get install -y \
        libonig-dev \
        libzip-dev \
        zip \
        unzip \
        git \
        mariadb-client \
    && docker-php-ext-install pdo pdo_mysql mbstring zip \
    && a2enmod rewrite

# Copiamos los archivos del proyecto al contenedor
COPY . /var/www/html/

# Instalamos Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalamos dependencias de PHP del proyecto
RUN composer install --no-dev --optimize-autoloader

# Ajustamos permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponemos el puerto 80 para Apache
EXPOSE 80

# Arrancamos Apache en primer plano
CMD ["apache2-foreground"]
