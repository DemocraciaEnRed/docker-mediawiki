#!/bin/bash

# Directorio de la instalacion
cd /var/www/html

# Verificar base de datos o salir
tablas=$(mysql -D $MW_DB_NAME -h $MW_DB_SERVER -u$MW_DB_USER -P 3306 -p$MW_DB_PASSWORD --batch --skip-column-names -e "show tables")

if [ $? -eq 0 ]; then
  if [ -z "$tables" ]; then
    echo '[INFO] La base de datos esta vacia'
    return 1
  else
    echo '[INFO] La base de datos no esta vacia'
    return 0
  fi
else
  echo '[INFO] Error al conectarse al servidor de MySQL'
  exit 1
fi


# Verificar si esta es la primera vez que corre el container segun el nombre de LocalSettings.php.
if [ ! -s LocalSettings.php ]
then
  php maintenance/install.php \
    --confpath "/" \
    --dbserver "$MW_DB_SERVER" \
    --dbtype "$MW_DB_TYPE" \
    --dbname "$MW_DB_NAME" \
    --dbuser "$MW_DB_USER" \
    --dbpass "$MW_DB_PASSWORD" \
    --installdbuser "$MW_DB_INSTALLDB_USER" \
    --installdbpass "$MW_DB_INSTALLDB_PASS" \
    --server "$MW_SITE_SERVER" \
    --scriptpath "$MW_WEB_PATH" \
    --lang "$MW_SITE_LANG" \
    --pass "$MW_ADMIN_PASS" \
    "$MW_SITE_NAME" \
    "$MW_ADMIN_USER"

  mv LocalSettingsINIT.php LocalSettings.php
  php maintenance/update.php --quick
  php maintenance/populateContentModel.php --ns=1 --table=revision
  php maintenance/populateContentModel.php --ns=1 --table=archive
  php maintenance/populateContentModel.php --ns=1 --table=page
fi

mv /opt/icons /var/www/html/images/icons
chown -R www-data:www-data /var/www/html

exec apachectl -e info -D FOREGROUND
