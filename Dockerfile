FROM debian:stretch
MAINTAINER Captain < capdeveloping95 at gmail dot com >

ENV MASTERUSER easywi
ENV PASSWORD password
ENV HOME_MASTERUSER /home/$MASTERUSER
ENV INSTALLER_VERSION 2.5
ENV GAMESERVERUPDATEHOURS "1-6"

ENV SERVERNAME _
ENV EMAIL example@example.com

ENV WEBGROUPNAME www-data
ENV WEBGROUPTMPID 33
ENV WEBGROUPPATH /var/www
ENV WEBGROUPCOMMENT Webserver

ENV USE_PHP_VERSION 7.0
ENV PHP_SOCKET /var/run/php/php$USE_PHP_VERSION-fpm.sock

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl wget dialog apt-utils locales cron software-properties-common unzip\
    && sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen \
    && dpkg-reconfigure --frontend noninteractive locales

RUN useradd -m -b /home/ -s /bin/bash $MASTERUSER \
    && echo $MASTERUSER:$PASSWORD | chpasswd

RUN mkdir $HOME_MASTERUSER/sites-enabled/ \
    && mkdir $HOME_MASTERUSER/skel \
    && mkdir $HOME_MASTERUSER/skel/htdocs \
    && mkdir $HOME_MASTERUSER/skel/logs \
    && mkdir $HOME_MASTERUSER/skel/sessions \
    && mkdir $HOME_MASTERUSER/skel/tmp \
    && chown -cR $MASTERUSER:$WEBGROUPNAME $HOME >/dev/null 2>&1

RUN apt-get -y install php$USE_PHP_VERSION-common php$USE_PHP_VERSION-curl php$USE_PHP_VERSION-gd php${USE_PHP_VERSION}-mcrypt php$USE_PHP_VERSION-mysql php$USE_PHP_VERSION-cli php$USE_PHP_VERSION-xml php$USE_PHP_VERSION-mbstring php$USE_PHP_VERSION-zip php$USE_PHP_VERSION-fpm \
    && apt-get -y install nginx-full \
    && rm /etc/php/7.0/fpm/pool.d/www.conf \
    && rm /etc/nginx/sites-enabled/default \
    && echo "/bin/false" >> /etc/shells

ADD ./easywi.conf /etc/nginx/sites-enabled/easywi.conf
ADD ./fpm-easywi.conf /etc/php/$USE_PHP_VERSION/fpm/pool.d/easywi.conf
ADD ./cronfile  /etc/cron.d/easywi
ADD ./entrypoint.sh /etc/entrypoint.sh

RUN useradd -md /home/easywi_web -g $WEBGROUPNAME -s /bin/bash -k /home/$MASTERUSER/skel/ easywi_web \
    && mv /home/easywi_web/sessions /home/easywi_web/session \
    && find /home/easywi_web/ -type f -exec chmod 0640 {} \; \
    && find /home/easywi_web/ -mindepth 1 -type d -exec chmod 0750 {} \; \
    && chown -cR easywi_web:$WEBGROUPNAME /home/easywi_web >/dev/null 2>&1

RUN chown -R $MASTERUSER:$WEBGROUPID /home/$MASTERUSER/ \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

VOLUME /home/easywi_web/htdocs/

ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
