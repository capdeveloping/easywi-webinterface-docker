#!/usr/bin/env bash

if [ -z `find "/home/easywi_web/htdocs/" -type f -exec echo found \;` ]; then
    cd /home/easywi_web/htdocs/
    DOWNLOAD_URL=`wget -q --timeout=60 -O - https://api.github.com/repos/easy-wi/developer/releases/latest | grep -Po '(?<="zipball_url": ")([\w:/\-.]+)'`

    curl -L $DOWNLOAD_URL -o web.zip

    unzip -u web.zip >/dev/null 2>&1
    rm -f web.zip

    HEX_FOLDER=`ls | grep 'easy-wi-developer-' | head -n 1`
    if [ "${HEX_FOLDER}" != "" ]; then
            mv ${HEX_FOLDER}/* ./
            rm -rf ${HEX_FOLDER}
    fi
    cd
fi

service php7.0-fpm stop
service php7.0-fpm start

service cron restart

nginx -g 'daemon off;'
