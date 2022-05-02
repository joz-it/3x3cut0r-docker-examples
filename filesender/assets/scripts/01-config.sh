#!/bin/bash

# setup environment

# user data
USER='www-data'
USER_ID="$(cat /etc/passwd | grep www-data | cut -d ':' -f 3)"
GROUP_ID="$(cat /etc/passwd | grep www-data | cut -d ':' -f 4)"
USER_UID=${USER_UID:-$USER_ID}
USER_GID=${USER_GID:-$GROUP_ID}

# database
DB_HOST=${DB_HOST:-"localhost"}
DB_NAME=${DB_NAME:-"filesender"}
DB_USER=${DB_USER:-"filesender"}
DB_PASSWORD=${DB_PASSWORD:-"filesender"}
DB_TYPE=${DB_TYPE:-"mysql"}
if [ "$DB_TYPE" = "mysql" ]; then
  # default port for mysql
  DB_PORT=${DB_PORT:-3306}
else
  # default port for postgresql
  DB_PORT=${DB_PORT:-5432}
fi

# filesender
FILESENDER_DIR="/opt/filesender"
FILESENDER_CONFIG_DIR="/config/filesender"
FILESENDER_SERIES=${FILESENDER_V%%.*}
FILESENDER_AUTHTYPE=${FILESENDER_AUTHTYPE:-"saml"}
FILESENDER_AUTHSAML=${FILESENDER_AUTHSAML:-"filesender-sqlauth"}
FILESENDER_URL=${FILESENDER_URL:-"http://localhost"}
FILESENDER_TRUSTED_DOMAINS=${FILESENDER_TRUSTED_DOMAINS:-"localhost.localdomain"}
FILESENDER_LOGOUT_URL=${FILESENDER_LOGOUT_URL:-"$FILESENDER_URL/login.php"}
FILESENDER_STORAGE=${FILESENDER_STORAGE:-"filesystem"}
FILESENDER_FORCE_SSL=${FILESENDER_FORCE_SSL:-false}

ADMIN_USERS=${ADMIN_USERS:-"admin"}
ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@abcde.edu"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"password"}

# simplesaml
SIMPLESAML_DIR="/opt/simplesamlphp"
SIMPLESAML_CONFIG_DIR="/config/simplesamlphp"
SIMPLESAML_MODULES="admin core cas exampleauth saml sqlauth"
SIMPLESAML_SESSION_COOKIE_SECURE=${SIMPLESAML_SESSION_COOKIE_SECURE:-false}
SIMPLESAML_LANGUAGE_DEFAULT=${SIMPLESAML_LANGUAGE_DEFAULT:-"en"}
SAML_TECHC_NAME=${SAML_TECHC_NAME:-"support"}
SAML_TECHC_EMAIL=${SAML_TECHC_EMAIL:-"support@abcde.edu"}
if [ "$FILESENDER_AUTHTYPE" = "shibboleth" ]; then
    # Attributes passed via environment variables from shibboleth
    SAML_MAIL_ATTR=${SAML_MAIL_ATTR:-"HTTP_SHIB_MAIL"}
    SAML_NAME_ATTR=${SAML_NAME_ATTR:-"HTTP_SHIB_CN"}
    SAML_UID_ATTR=${SAML_UID_ATTR:-"HTTP_SHIB_UID"}
elif [ "$FILESENDER_AUTHTYPE" = "fake" ]; then
    # Manually set attribute values for v2.0 "fake authentication"
    SAML_MAIL_ATTR=${SAML_MAIL_ATTR:-"fakeuser@abcde.edu"}
    SAML_NAME_ATTR=${SAML_NAME_ATTR:-"Fake User"}
    SAML_UID_ATTR=${SAML_UID_ATTR:-"fakeuser"}
else
    # Attributes passed from simplesamlphp
    SAML_MAIL_ATTR=${SAML_MAIL_ATTR:-"mail"}
    SAML_NAME_ATTR=${SAML_NAME_ATTR:-"cn"}
    SAML_UID_ATTR=${SAML_UID_ATTR:-"uid"}
fi

# fpm
PHP_FPM_PORT=${PHP_FPM_PORT:-9000}
FPM_MIN_SPARE_SERVERS=${FPM_MIN_SPARE_SERVERS:-1}
FPM_MAX_SPARE_SERVERS=${FPM_MAX_SPARE_SERVERS:-5}

# smtp
EMAIL_FROM_ADDRESS=${EMAIL_FROM_ADDRESS:-"filesender@your.org"}
EMAIL_FROM_NAME=${EMAIL_FROM_NAME:-"{cfg:site_name} - {cfg:site_url}"}
SMTP_SERVER=${SMTP_SERVER:-"localhost"}
SMTP_PORT=${SMTP_PORT:-"25"}
SMTP_TLS=${SMTP_TLS:-"on"}
SMTP_AUTH=${SMTP_AUTH:-"on"}
SMTP_USER=${SMTP_USER:-"missing"}
SMTP_PASSWORD=${SMTP_PASSWORD:-"secret"}
SMTP_FROM=${SMTP_FROM:-${EMAIL_FROM_ADDRESS}}

# redis
REDIS_HOST=${REDIS_HOST:-"localhost"}
REDIS_PORT=${REDIS_PORT:-6379}

# misc
DB_STATUS_FILE=${FILESENDER_CONFIG_DIR}/.setup-db
LOG_DETAIL=${LOG_DETAIL:-"info"}
TEMPLATE_DIR="/config/config-templates"
TEMPLATE_WARNING=${TEMPLATE_WARNING:-"// !!! DO NOT EDIT THIS FILE! It is regenerated from environment variables every time the container starts !!!"}
TRANSFER_MAX_DAYS_VALID=${TRANSFER_MAX_DAYS_VALID:-20}
TRANSFER_DEFAULT_DAYS=${TRANSFER_DEFAULT_DAYS:-7}
TZ=${TZ:-"Europe/Berlin"}

function sed_file {
    if [ "$2" = "" ]; then
        SRCFILE="$1.default"
        DSTFILE="$1"
    if [ ! -f "$SRCFILE" ]; then
        cp "$1" "$SRCFILE"
    fi
    else
        SRCFILE="$1"
        DSTFILE="$2"
    fi

    cat "$SRCFILE" | sed \
        -e "s|{USER_UID}|${USER_UID}|g" \
        -e "s|{USER_GID}|${USER_GID}|g" \
        \
        -e "s|{DB_HOST}|${DB_HOST}|g" \
        -e "s|{DB_NAME}|${DB_NAME}|g" \
        -e "s|{DB_USER}|${DB_USER}|g" \
        -e "s|{DB_PASSWORD}|${DB_PASSWORD}|g" \
        -e "s|{DB_TYPE}|${DB_TYPE}|g" \
        -e "s|{DB_PORT}|${DB_PORT}|g" \
        \
        -e "s|{FILESENDER_DIR}|${FILESENDER_DIR}|g" \
        -e "s|{FILESENDER_CONFIG_DIR}|${FILESENDER_CONFIG_DIR}|g" \
        -e "s|{FILESENDER_SERIES}|${FILESENDER_SERIES}|g" \
        -e "s|{FILESENDER_AUTHTYPE}|${FILESENDER_AUTHTYPE}|g" \
        -e "s|{FILESENDER_AUTHSAML}|${FILESENDER_AUTHSAML}|g" \
        -e "s|{FILESENDER_URL}|${FILESENDER_URL}|g" \
        -e "s|{FILESENDER_TRUSTED_DOMAINS}|${FILESENDER_TRUSTED_DOMAINS}|g" \
        -e "s|{FILESENDER_LOGOUT_URL}|${FILESENDER_LOGOUT_URL}|g" \
        -e "s|{FILESENDER_STORAGE}|${FILESENDER_STORAGE}|g" \
        -e "s|{FILESENDER_FORCE_SSL}|${FILESENDER_FORCE_SSL}|g" \
        \
        -e "s|{ADMIN_USERS}|${ADMIN_USERS:-admin}|g" \
        -e "s|{ADMIN_EMAIL}|${ADMIN_EMAIL}|g" \
        -e "s|{ADMIN_PASSWORD}|${ADMIN_PASSWORD}|g" \
        \
        -e "s|{SIMPLESAML_DIR}|${SIMPLESAML_DIR}|g" \
        -e "s|{SIMPLESAML_CONFIG_DIR}|${SIMPLESAML_CONFIG_DIR}|g" \
        -e "s|{SIMPLESAML_MODULES}|${SIMPLESAML_MODULES}|g" \
        -e "s|{SIMPLESAML_SESSION_COOKIE_SECURE}|${SIMPLESAML_SESSION_COOKIE_SECURE}|g" \
        -e "s|{SIMPLESAML_LANGUAGE_DEFAULT}|${SIMPLESAML_LANGUAGE_DEFAULT}|g" \
        -e "s|{SIMPLESAML_SALT}|${SIMPLESAML_SALT}|g" \
        -e "s|{SAML_MAIL_ATTR}|${SAML_MAIL_ATTR}|g" \
        -e "s|{SAML_NAME_ATTR}|${SAML_NAME_ATTR}|g" \
        -e "s|{SAML_UID_ATTR}|${SAML_UID_ATTR}|g" \
        -e "s|{SAML_TECHC_NAME}|${SAML_TECHC_NAME}|g" \
        -e "s|{SAML_TECHC_EMAIL}|${SAML_TECHC_EMAIL}|g" \
        \
        -e "s|{PHP_FPM_PORT}|${PHP_FPM_PORT}|g" \
        -e "s|{FPM_MIN_SPARE_SERVERS}|${FPM_MIN_SPARE_SERVERS}|g" \
        -e "s|{FPM_MAX_SPARE_SERVERS}|${FPM_MAX_SPARE_SERVERS}|g" \
        \
        -e "s|{EMAIL_FROM_ADDRESS}|${EMAIL_FROM_ADDRESS}|g" \
        -e "s|{EMAIL_FROM_NAME}|${EMAIL_FROM_NAME}|g" \
        -e "s|{SMTP_SERVER}|${SMTP_SERVER}|g" \
        -e "s|{SMTP_HOST}|${SMTP_SERVER}|g" \
        -e "s|{SMTP_PORT}|${SMTP_PORT}|g" \
        -e "s|{SMTP_TLS}|${SMTP_TLS}|g" \
        -e "s|{SMTP_AUTH}|${SMTP_AUTH}|g" \
        -e "s|{SMTP_USER}|${SMTP_USER}|g" \
        -e "s|{SMTP_PASSWORD}|${SMTP_PASSWORD}|g" \
        -e "s|{SMTP_FROM}|${SMTP_FROM}|g" \
        \
        -e "s|{REDIS_HOST}|${REDIS_HOST}|g" \
        -e "s|{REDIS_PORT}|${REDIS_PORT}|g" \
        \
        -e "s|{LOG_DETAIL}|${LOG_DETAIL}|g" \
        -e "s|{TEMPLATE_DIR}|${TEMPLATE_DIR}|g" \
        -e "s|{TEMPLATE_WARNING}|${TEMPLATE_WARNING}|g" \
        -e "s|{TRANSFER_MAX_DAYS_VALID}|${TRANSFER_MAX_DAYS_VALID}|g" \
        -e "s|{TRANSFER_DEFAULT_DAYS}|${TRANSFER_DEFAULT_DAYS}|g" \
        -e "s|{TZ}|${TZ}|g" \
    > "$DSTFILE"
}

# reconfigure nginx/sites-available/default config
sed_file ${TEMPLATE_DIR}/nginx/sites-available/default /etc/nginx/sites-available/default

# reconfigure fpm config
sed_file ${TEMPLATE_DIR}/fpm/filesender.conf /config/fpm/filesender.conf


# reconfigure msmtp config
sed_file ${TEMPLATE_DIR}/msmtp/msmtprc /etc/msmtprc


# reconfigure simplesamlphp config
if [ "$SIMPLESAML_SALT" = "" ]; then
    SIMPLESAML_SALT=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=32 count=1 2>/dev/null;echo`
fi

sed_file "${TEMPLATE_DIR}/simplesamlphp/config/acl.php" "${SIMPLESAML_CONFIG_DIR}/config/acl.php"
sed_file "${TEMPLATE_DIR}/simplesamlphp/config/authsources.php" "${SIMPLESAML_CONFIG_DIR}/config/authsources.php"
sed_file "${TEMPLATE_DIR}/simplesamlphp/config/config.php" "${SIMPLESAML_CONFIG_DIR}/config/config.php"

for MODULE in $SIMPLESAML_MODULES; do
    if [ -d ${SIMPLESAML_DIR}/modules/$MODULE ]; then
        touch "${SIMPLESAML_DIR}/modules/$MODULE/enable"
    fi
done


# reconfigure filesender config
if [ -f ${TEMPLATE_DIR}/filesender/www/login.php ]; then
    sed_file ${TEMPLATE_DIR}/filesender/www/login.php ${FILESENDER_CONFIG_DIR}/www/login.php
    chmod o+rwx ${FILESENDER_CONFIG_DIR}/www/login.php
    ln -s ${FILESENDER_CONFIG_DIR}/www/login.php ${FILESENDER_DIR}/www/login.php
fi

sed_file ${TEMPLATE_DIR}/filesender/config/config.php ${FILESENDER_CONFIG_DIR}/config/config.php
