# Mediawiki

Este container corre [Mediawiki](https://www.mediawiki.org/wiki/MediaWiki/es) en su version 1.32.2.

## Variables de entorno

Se utilizan una serie de variables para la configuracion de la aplicacion.

```
# Datos sobre el servidor de base de datos (MySQL)
MW_DB_TYPE: mysql
MW_DB_SERVER: mysql
MW_DB_NAME: mediawiki
MW_DB_USER: mediawiki
MW_DB_PASSWORD: mediawiki
MW_DB_INSTALLDB_USER: mediawiki
MW_DB_INSTALLDB_PASS: mediawiki

# Datos sobre el usuario administrador
MW_ADMIN_USER: admin
MW_ADMIN_PASS: mediawiki

# Configuracion especifica de la aplicacion
MW_WEB_PATH: /
MW_SITE_LANG: es
MW_PARSOID_URL: http://parsoid:8000
MW_REST_DOMAIN: mediawiki
PHP_ERROR_REPORTING: E_ALL & ~E_DEPRECATED & ~E_STRICT
MW_PARSOID_WIKI_DOMAIN: mediawiki
MW_SITE_SERVER: http://localhost
MW_SEC_KEY: somesecretkey
MW_SITE_NAME: Mi Wiki
MW_NOTIFY_USERS: MW_NOTIFY_USERS=Admin
```

## Puerto

El servicio esta expuesto en el puerto 80.

## Volumenes

Esta aplicacion requiere persistencia para los ficheros subidos a `/var/www/html/images` y para `LocalSettings.php`, ver ejemplo en `docker-compose.yml`.

## Ejemplo

Se incluye un `docker-compose.yml` donde se ejemplifican todos los componentes anteriores. Es necesario utilizar una base de datos y una docker network dentro del compose.

**NOTA**

Se incluye variables para configurar parsoid aunque no se incluyen esos detalles en este repositorio.
