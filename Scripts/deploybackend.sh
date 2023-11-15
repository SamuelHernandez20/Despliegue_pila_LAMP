<<<<<<< HEAD
#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repos

apt update


source .env


mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
=======
# Crear usuario con ip privada del frontend para que se conecte a la base de datos

DROP USER IF EXISTS '$DB_USER'@'$IP_MAQUINA_CLIENTE';
CREATE USER '$DB_USER'@'$IP_MAQUINA_CLIENTE' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$DB_USER'@'$IP_MAQUINA_CLIENTE';
>>>>>>> 5e0df79bbddf56588026933e23bd5d77a0267b40
