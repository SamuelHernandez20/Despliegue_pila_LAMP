# Crear usuario con ip privada del frontend para que se conecte a la base de datos

DROP USER IF EXISTS '$DB_USER'@'$IP_MAQUINA_CLIENTE';
CREATE USER '$DB_USER'@'$IP_MAQUINA_CLIENTE' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$DB_USER'@'$IP_MAQUINA_CLIENTE';