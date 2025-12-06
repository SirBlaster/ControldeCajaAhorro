# usa una versión concreta
FROM php:8.2-apache

# instalar dependencias del sistema que puedan ser necesarias (opcional)
RUN apt-get update && apt-get install -y --no-install-recommends \
    zip unzip git \
  && rm -rf /var/lib/apt/lists/*

# instalar extensiones PHP necesarias
# NOTA: no instalamos 'pdo' por separado, solo pdo_mysql y mysqli
RUN docker-php-ext-install mysqli pdo_mysql

# habilitar mod_rewrite
RUN a2enmod rewrite

# directorio de trabajo
WORKDIR /var/www/html

# copiar la aplicación (útil para imagen de producción)
COPY ./src/ /var/www/html/

# permitir .htaccess (edita si tu apache.conf es diferente)
# remplazamos AllowOverride None por AllowOverride All en todo el archivo
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# permisos (ajusta según tu necesidad)
RUN chown -R www-data:www-data /var/www/html \
  && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
