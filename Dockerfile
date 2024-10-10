
FROM php:8.1.0-apache

# Actualiza el sistema y instala las dependencias necesarias
RUN apt-get update && apt-get install --no-install-recommends -y \
    libzip-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    mariadb-client \
    zip \
    unzip \
    zlib1g-dev \
    libicu-dev \
    g++ \
    tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura y habilita la extensión intl
RUN docker-php-ext-configure intl && docker-php-ext-install intl

# Instala y habilita las extensiones de PHP necesarias
RUN pecl install zip pcov
RUN docker-php-ext-enable zip
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli

# Desactiva la exposición de información del servidor
RUN sed -ri -e 's!expose_php = On!expose_php = Off!g' $PHP_INI_DIR/php.ini-production \
    && sed -ri -e 's!ServerTokens OS!ServerTokens Prod!g' /etc/apache2/conf-available/security.conf \
    && sed -ri -e 's!ServerSignature On!ServerSignature Off!g' /etc/apache2/conf-available/security.conf \
    && sed -ri -e 's!KeepAliveTimeout .*!KeepAliveTimeout 65!g' /etc/apache2/apache2.conf \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN a2enmod rewrite

# Configura la zona horaria
ENV TZ America/Lima
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# Copia los archivos de la aplicación
COPY . /var/www/html/
RUN chmod -R a+r /var/www/html

