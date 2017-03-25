FROM alpine:latest
MAINTAINER Kasper Franz <kasper@franz.guru>

# Install packages
RUN apk --no-cache add ca-certificates git php7 php7-json php7-zlib php7-mbstring php7-iconv php7-phar php7-session php7-openssl php7-mysqli php7-pdo php7-pdo_mysql php7-bcmath php7-fpm nginx supervisor --repository http://nl.alpinelinux.org/alpine/edge/testing/
RUN update-ca-certificates

#Install PHP memcached.
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev git
RUN set -xe \
    && apk add --no-cache \
        --virtual .memcached-deps \
        $MEMCACHED_DEPS \
    && git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && docker-php-ext-configure /usr/src/php/ext/memcached \
        --disable-memcached-sasl \
    && docker-php-ext-install /usr/src/php/ext/memcached \
    && rm -rf /usr/src/php/ext/memcached \
    && apk del .memcached-deps

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY src/ /var/www/html/

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
