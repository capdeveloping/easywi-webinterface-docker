FROM debian:stretch
MAINTAINER Captain < capdeveloping95 at gmail dot com >

ENV MASTERUSER easywi
ENV PASSWORD password
ENV HOME /home/$MASTERUSER
ENV INSTALLER_VERSION 2.5

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

RUN mkdir $HOME/sites-enabled/ \
    && mkdir $HOME/skel \
    && mkdir $HOME/skel/htdocs \
    && mkdir $HOME/skel/logs \
    && mkdir $HOME/skel/sessions \
    && mkdir $HOME/skel/tmp \
    && chown -cR $MASTERUSER:$WEBGROUPNAME $HOME >/dev/null 2>&1

RUN apt-get -y install php$USE_PHP_VERSION-common php$USE_PHP_VERSION-curl php$USE_PHP_VERSION-gd php${USE_PHP_VERSION}-mcrypt php$USE_PHP_VERSION-mysql php$USE_PHP_VERSION-cli php$USE_PHP_VERSION-xml php$USE_PHP_VERSION-mbstring php$USE_PHP_VERSION-zip php$USE_PHP_VERSION-fpm \
    && apt-get -y install nginx-full \
    && rm /etc/nginx/sites-enabled/default \
    && rm /etc/nginx/sites-available/default \
    && sed -i "s/include=\/etc\/php\/7.0\/fpm\/pool.d\/\*.conf/include=\/home\/$MASTERUSER\/fpm-pool.d\/\*.conf/g" /etc/php/7.0/fpm/php-fpm.conf \
    && sed -i "\/etc\/nginx\/sites-enabled\/\*;/a \ \ \ \ \ \ \ \ include \/home\/$MASTERUSER\/sites-enabled\/\*;" /etc/nginx/nginx.conf \
    && echo "/bin/false" >> /etc/shells

ADD ./modify_fpm.conf.sh /root/modify_fpm.conf.sh
ADD ./install_easywi.sh /root/install_easywi.sh
ADD ./easywi.conf /home/$MASTERUSER/sites-enabled/easywi.conf
ADD ./entrypoint.sh /etc/entrypoint.sh

RUN chown -R $MASTERUSER:$WEBGROUPID /home/$MASTERUSER/ \
    && sed -i "s/%SERVERNAME%/$SERVERNAME/" /home/$MASTERUSER/sites-enabled/easywi.conf \
    && sed -i "s#%PHP_SOCKET%#$PHP_SOCKET#" /home/$MASTERUSER/sites-enabled/easywi.conf \
    && chown $MASTERUSER:$WEBGROUPNAME /home/$MASTERUSER/sites-enabled/easywi.conf \
    && bash /root/install_easywi.sh \
    && bash /root/modify_fpm.conf.sh \
    && service php${USE_PHP_VERSION}-fpm stop \
    && service php${USE_PHP_VERSION}-fpm start \
    && nginx -c /etc/nginx/nginx.conf -t \
    && service nginx restart \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

VOLUME /home/easywi_web/htdocs/

ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
