#!/usr/bin/env bash

if [ -z "$(find "home/easywi_web/htdocs/" -maxdepth 1 -type f -exec echo Found {} \;)" ]; then
    sed -i "s/%USER%/easywi_web/g" /etc/nginx/sites-enabled/easywi.conf
    sed -i "s/%SERVERNAME%/$SERVERNAME/g" /etc/nginx/sites-enabled/easywi.conf
    sed -i "s#%PHP_SOCKET%#$PHP_SOCKET#g" /etc/nginx/sites-enabled/easywi.conf

    sed -i "s/%GAMESERVERUPDATEHOURS%/$GAMESERVERUPDATEHOURS/g" /etc/cron.d/easywi

    sed -i "s/%USER%/easywi_web/g" /etc/php/$USE_PHP_VERSION/fpm/pool.d/easywi.conf
    sed -i "s#%PHP_SOCKET%#$PHP_SOCKET#g" /etc/php/$USE_PHP_VERSION/fpm/pool.d/easywi.conf

    nginx -c /etc/nginx/nginx.conf -t

    cd /home/easywi_web/htdocs/
    DOWNLOAD_URL=`wget -q --timeout=60 -O - https://api.github.com/repos/easy-wi/developer/releases/latest | grep -Po '(?<="zipball_url": ")([\w:/\-.]+)'`

    curl -L $DOWNLOAD_URL -o web.zip

    unzip -u web.zip >/dev/null 2>&1
    rm -f web.zip

    HEX_FOLDER=`ls | grep 'easy-wi-developer-' | head -n 1`
    if [ "${HEX_FOLDER}" != "" ]; then
            cp -r ${HEX_FOLDER}/* ./
            rm -rf ${HEX_FOLDER}
    fi
    chown -R easywi_web:$WEBGROUPNAME /home/easywi_web/
fi

service php$USE_PHP_VERSION-fpm stop
service php$USE_PHP_VERSION-fpm start

service cron restart

nginx -g 'daemon off;'
