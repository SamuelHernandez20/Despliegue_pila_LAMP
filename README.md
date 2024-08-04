# Instalación de la Pila LAMP en 2 niveles
Para esta práctica el proposito era realizar una instalación normal de la pila LAMP, pero el objetivo era trocearla en 2 maquinas distintas, una que estuviera destinada para la parte frontal (frontend), y otra que se encargue de la gestión de la parte trasera (backend). Por lo tanto obtendremos una arquitectura de 2 máquinas.

Para ello tendremos una configuración de archivos y directorios de esta forma:

``````
.
├── README.md
├── conf
│   └── 000-default.conf
└── scripts
    ├── .env
    ├── install_lamp_frontend.sh
    ├── install_lamp_backend.sh
    ├── setup_letsencrypt_https.sh    
    └── deploy_fontend.sh
    └── deploy_backend.sh

``````

## 1. Configuración del Frontend:

### 1.1 Despliegue del install_lamp_frontend.sh:

Instalamos apache

``````
apt install apache2 -y
``````

Instalacion del php

``````
apt install php libapache2-mod-php php-mysql -y
``````

Copiar el archivo de conf de apache

``````
cp ../conf/000-default.conf /etc/apache2/sites-available 
``````

Reiniciar servicio

``````
systemctl restart apache2
``````

copiar archivo php:

``````
cp ../php/index.php /var/www/html
``````
modificar el propietario y grupo de /var/www/html para usuario de apache

``````
chown -R www-data:www-data /var/www/html
``````
### 1.2 Despliegue del deploy_fontend.sh:

Incluir variables
``````
source .env
``````
Eliminar descargas previas:

``````
rm -rf /tmp/wp-cli.phar 
``````
Descargamos utilidad wp-cli:

``````
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp
``````
Permisos de ejecución al archivo:

``````
chmod +x /tmp/wp-cli.phar
``````
Movemos la utlidad y de esta forma lo podemos usar sin poner la ruta completa:``````

``````
mv /tmp/wp-cli.phar /usr/local/bin/wp
``````
Eliminamos instalaciones previas del Wordpress

``````
rm -rf /var/www/html/*
``````
Descargamos codigo fuente Wordpress en /var/www/html

``````
wp core download --locale=es_ES --path=/var/www/html --allow-root
``````
Creamos el archivo de configruacion 
``````
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$WORDPRESS_DB_HOST \
  --path=/var/www/html \
  --allow-root
``````
 Una vez que tenemos la base de datos creada y el archivo de configuración preparado podemos realizar la instalación de WordPress 
``````
wp core install \
  --url=$dominio \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN\
  --admin_password=$WORDPRESS_PASS \
  --admin_email=$WORDPRESS_email \
  --path=/var/www/html \
  --allow-root
``````
Actualizacion

``````
wp core update --path=/var/www/html --allow-root
``````
Instalamos un tema:

``````
wp theme install sydney --activate --path=/var/www/html --allow-root
``````
Instalamos un algunos plugins:

``````
wp plugin update --path=/var/www/html --all --allow-root
``````
Instalamos el plugin bbpress:

``````
wp plugin install bbpress --activate --path=/var/www/html --allow-root
``````
Instalar plugin para ocultar el **wp-admin**
``````
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root
``````
Nombre de la entrada

``````
wp rewrite structure '/%postname%/' \
  --path=/var/www/html \
  --allow-root
``````
``````
wp option update whl_page "candado" --path=/var/www/html --allow-root
``````
Reescritura

``````
a2enmod rewrite
``````
copiar **.htaccess** a **/var/www/html/**
``````
cp /home/ubuntu/practica01-09/htaccess/.htaccess /var/www/html/
``````
Cambiar propietario:
``````
chown -R www-data:www-data /var/www/html
``````
## 2. Configuración del Backend:

### 2.1 Despliegue del install_lamp_backend.sh

Instalar SGBD de mysql

``````
apt install mysql-server -y
``````
Nos traemos las variables del **.env**

``````
source .env
``````
Configuramos el mysql  para que acepete conxiones desde la ip privada, para ello se hará de una manera automatizada
para permitir que se acepten no solo conexiones desde la misma máquina, y decirle desde que interfaz va a estar escuchando (ip del backend):

``````
sed -i "s/127.0.0.1/$MYSQL_PRIVATE/" /etc/mysql/mysql.conf.d/mysqld.cnf
``````

Reiniciamos servicio

``````
systemctl restart mysql
``````
### 2.2 Despliegue del deploy_backend.sh:

Muestra comandos que se van ejecutando por si falla

``````
set -x
``````
Desde este otro archivo incluiremos nuevamente las variables del **.env**:

``````
source .env
``````

Realizamos la creación del usuario, base de datos y otorgación de permisos (la dirección ip qdel usuario que se permitirá sera la de la maquina frontend, su ip privada):

``````
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
``````


