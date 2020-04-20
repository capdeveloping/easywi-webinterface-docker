#!/bin/bash

useradd -md /home/easywi_web -g $WEBGROUPNAME -s /bin/bash -k /home/$MASTERUSER/skel/ easywi_web

mkdir /home/easywi_web/htdocs/
mkdir /home/easywi_web/logs/
mkdir /home/easywi_web/tmp/
mkdir /home/easywi_web/session/

chown -R easywi_web:easywi /home/easywi_web/

find /home/easywi_web/ -type f -exec chmod 0640 {} \;
find /home/easywi_web/ -mindepth 1 -type d -exec chmod 0750 {} \;

chown -cR easywi_web:$WEBGROUPNAME /home/easywi_web >/dev/null 2>&1

echo '0 */1 * * * easywi_web cd /home/easywi_web/htdocs && timeout 300 php ./reboot.php >/dev/null 2>&1
*/5 * * * * easywi_web cd /home/easywi_web/htdocs && timeout 290 php ./statuscheck.php >/dev/null 2>&1
*/1 * * * * easywi_web cd /home/easywi_web/htdocs && timeout 290 php ./startupdates.php >/dev/null 2>&1
*/5 * * * * easywi_web cd /home/easywi_web/htdocs && timeout 290 php ./jobs.php >/dev/null 2>&1
*/10 * * * * easywi_web cd /home/easywi_web/htdocs && timeout 290 php ./cloud.php >/dev/null 2>&1' >> /etc/crontab

service cron restart 1>/dev/null
