#libwebp libraries don't work correctly with alpine:v3.3 so we are using edge
FROM alpine:edge
MAINTAINER Onni Hakala - Geniem Oy. <onni.hakala@geniem.com>

# Install dependencies
RUN apk --update add bash less vim nano git mysql-client nginx ca-certificates openssh-client \
    # Libs for php
    libssh2 curl libpng freetype libjpeg-turbo libgcc libxml2 libstdc++ icu-libs libltdl libmcrypt \
    # For mails
    msmtp \
    # Set timezone according your location
    tzdata \
    && apk add -u musl

##
# Install php7
# - These repositories are in 'testing' repositories but it's much more stable/easier than compiling our own php.
##
RUN apk add --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ \
    php7-pdo_mysql php7-mysqli php7-mysqlnd php7-mcrypt php7-xdebug \
    php7 php7-session php7-fpm php7-json php7-zlib php7-xml php7-pdo \
    php7-gd php7-curl php7-opcache php7-ctype php7-mbstring php7-soap \
    php7-intl php7-bcmath php7-dom php7-xmlreader php7-openssl php7-phar

# Small fixes to php & nginx
RUN ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    # Remove nginx user because we will create a user with correct permissions dynamically
    deluser nginx

##
# Install PhantomJS package
# - Add preconfigured phantomjs package build with: https://github.com/fgrehm/docker-phantomjs2
##
ADD lib/phantomjs-dependencies.tar.gz /

##
# Add S6-overlay to use S6 process manager
# source: https://github.com/just-containers/s6-overlay/#the-docker-way
##
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz

##
# Install ruby and integration testing tools
# - We install build libraries only for this one run so whole image can stay smaller size
##
RUN apk --update add ruby && \
    apk add --virtual build_deps build-base ruby-dev libc-dev linux-headers \
    openssl-dev postgresql-dev libxml2-dev libxslt-dev && \
    gem install rspec rspec-retry poltergeist capybara --no-ri --no-rdoc -- --use-system-libraries && \
    apk del build_deps

##
# Install composer & wp-cli
# source: https://getcomposer.org/download/ & http://wp-cli.org/
##
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp-cli
ADD https://getcomposer.org/installer /tmp/composer-setup.php
RUN cd /tmp && \
    php composer-setup.php && \
    rm  composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +rx /usr/local/bin/composer && \
    chmod +rx /usr/local/bin/wp-cli

# Remove cache and tmp files
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
