FROM alpine:latest
MAINTAINER Kasper Franz <kasper@franz.guru>

# Install packages
RUN apk --no-cache add tar sed grep curl wget gzip cyrus-sasl-dev pcre	build-base zlib-dev autoconf libmemcached-dev && \
	apk --no-cache add ca-certificates git libmemcached php7 php7-json php7-zlib php7-mbstring php7-iconv php7-phar php7-session php7-openssl php7-mysqli php7-pdo php7-pdo_mysql php7-bcmath php7-fpm nginx supervisor \
	#  dependencies for php memcached build
	php7-dev \
    --repository http://nl.alpinelinux.org/alpine/edge/testing/ --repository http://dl-cdn.alpinelinux.org/alpine/edge/main
RUN update-ca-certificates

#Install PHP memcached.
RUN curl -o php7-memcached.tar.gz -SL https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz && \
    tar -xzf php7-memcached.tar.gz && \
    cd php-memcached-php7 && \
    phpize7 && \
    ./configure --prefix=/usr --disable-memcached-sasl --with-php-config=php-config7 && \
    make && \
    make install && \
    install -d /etc/php7/conf.d && \
    echo "extension=memcached.so" > /etc/php7/conf.d/20_memcached.ini && \
    cd .. && \
    rm -rf php7-memcached.tar.gz && \
    rm -rf php-memcached-php7 && \
  # prune the build deps for php7-memcached.
    apk del build-base zlib-dev cyrus-sasl-dev autoconf libmemcached-dev php7-dev


#setup composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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
