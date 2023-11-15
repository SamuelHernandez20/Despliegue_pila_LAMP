#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repos

apt update

# Actualizar paquetes 

#apt upgrade

#Instalar apache

apt install apache2 -y

#Instalacion del php

apt install php libapache2-mod-php php-mysql -y


#Copiar el archivo de conf de apache

cp ../conf/000-default.conf /etc/apache2/sites-available 

# Crear usuario con ip privada del frontend para que se conecte a la base de datos

DROP USER IF EXISTS '$DB_USER'@'$IP_MAQUINA_CLIENTE';
CREATE USER '$DB_USER'@'$IP_MAQUINA_CLIENTE' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$DB_USER'@'$IP_MAQUINA_CLIENTE';

e2enmod rewrite


#Copiar el archivo de conf de apache

cp ../conf/000-default.conf /etc/apache2/sites-available 

#Reiniciar servicio

systemctl restart apache2

# copiar archivo php 

cp ../php/index.php /var/www/html

# modificar el propietario y grupo de /var/www/html para usuario de apache

chown -R www-data:www-data /var/www/html


