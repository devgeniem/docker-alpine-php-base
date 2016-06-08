# Dependency for php7: libwebp library doesn't work correctly with alpine:v3.3 so we are using alpine:edge
FROM alpine:edge
MAINTAINER Onni Hakala - Geniem Oy. <onni.hakala@geniem.com>


RUN cd /tmp/ && \

    # Install dependencies and small amount of devtools
    apk --update add curl bash mysql-client nginx ca-certificates \
    # Libs for php
    libssh2 libpng freetype libjpeg-turbo libgcc libxml2 libstdc++ icu-libs libltdl libmcrypt \
    # For sending mail from container
    msmtp \
    # Set timezone according your location
    tzdata && \
    # Upgrade musl
    apk add -u musl && \

    ##
    # Install php7
    # - These repositories are in 'testing' repositories but it's much more stable/easier than compiling our own php.
    ##
    apk add --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ \
    php7 php7-pdo_mysql php7-mysqli php7-mysqlnd php7-mcrypt php7-redis \
    php7-session php7-fpm php7-json php7-zlib php7-xml php7-pdo php7-phar \
    php7-gd php7-curl php7-opcache php7-ctype php7-mbstring php7-soap \
    php7-intl php7-bcmath php7-dom php7-xmlreader php7-openssl  && \

    # Small fixes to php & nginx
    ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \

    # Remove nginx user because we will create a user with correct permissions dynamically
    deluser nginx && \

    ##
    # Add S6-overlay to use S6 process manager
    # source: https://github.com/just-containers/s6-overlay/#the-docker-way
    ##
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz \
    | tar -xvzC /  && \

    ##
    # Install wp-cli
    # source: http://wp-cli.org/
    ##
    curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp-cli && \
    chmod +rx /usr/local/bin/wp-cli && \

    ##
    # Install cronlock for running cron correctly with mulitple container setups
    # https://github.com/kvz/cronlock
    ##
    curl -L https://raw.githubusercontent.com/kvz/cronlock/master/cronlock -o /usr/local/bin/cronlock && \
    chmod +rx /usr/local/bin/cronlock && \

    # Remove cache and tmp files
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
