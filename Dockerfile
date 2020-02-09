FROM ubuntu:18.04

MAINTAINER mmattox@mattoxengineering.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    apache2 \
    libapache2-mod-php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php7.2-imap \
    php7.2-apcu \
    php-imagick \
    openssl \
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    locales \
    sqlite3 \
    ca-certificates \
    git \
    sendmail \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

##Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

##Configure PHP
COPY php.ini /etc/php/7.2/mods-available/
RUN phpenmod osticket
RUN a2enmod rewrite expires
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername

##Configure Apache
COPY apache.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite apache.conf
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

##Moving Install Files osTicket
COPY public_html/* /var/www/src/

EXPOSE 80

CMD /bin/run.sh
