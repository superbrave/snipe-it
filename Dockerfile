ARG COMPOSER_INSTALL_ARGS='--no-dev --optimize-autoloader --no-interaction'
ARG APP_ENV=prod
ARG PHP_VERSION=8.5

FROM ghcr.io/superbrave/php:${PHP_VERSION} AS php

LABEL org.opencontainers.image.source=https://github.com/superbrave/snipe-it

ARG COMPOSER_INSTALL_ARGS
ARG APP_ENV

USER root
WORKDIR /var/www

COPY .docker/php.conf.d/ /usr/local/etc/php/conf.d
COPY --chown=www-data:www-data . /var/www/

RUN apk update && apk upgrade

USER www-data

ENV APP_ENV=$APP_ENV
ENV COMPOSER_INSTALL_ARGS=$COMPOSER_INSTALL_ARGS

RUN composer install $(echo $COMPOSER_INSTALL_ARGS | tr -d '"')

RUN rm -f /var/www/.env.local /var/www/.env.test

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD ["cgi-fcgi", "-bind", "-connect", "127.0.0.1:9000"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["/usr/local/sbin/php-fpm", "-c", "/usr/local/etc/php-fpm.conf"]
