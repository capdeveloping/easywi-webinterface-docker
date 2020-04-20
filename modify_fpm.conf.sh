#!/bin/bash
mkdir /home/$MASTERUSER/fpm-pool.d/

FILE_NAME_POOL=/home/$MASTERUSER/fpm-pool.d/easywi.conf

echo "[$SERVERNAME]" > $FILE_NAME_POOL
echo "user = easywi_web" >> $FILE_NAME_POOL
echo "group = www-data" >> $FILE_NAME_POOL
echo "listen = ${PHP_SOCKET}" >> $FILE_NAME_POOL
echo "listen.owner = easywi_web" >> $FILE_NAME_POOL
echo "listen.group = www-data" >> $FILE_NAME_POOL
echo "pm = dynamic" >> $FILE_NAME_POOL
echo "pm.max_children = 1" >> $FILE_NAME_POOL
echo "pm.start_servers = 1" >> $FILE_NAME_POOL
echo "pm.min_spare_servers = 1" >> $FILE_NAME_POOL
echo "pm.max_spare_servers = 1" >> $FILE_NAME_POOL
echo "pm.max_requests = 500" >> $FILE_NAME_POOL
echo "chdir = /" >> $FILE_NAME_POOL
echo "access.log = /home/easywi_web/logs/fpm-access.log" >> $FILE_NAME_POOL
echo "php_flag[display_errors] = off" >> $FILE_NAME_POOL
echo "php_admin_flag[log_errors] = on" >> $FILE_NAME_POOL
echo "php_admin_value[error_log] = /home/easywi_web/logs/fpm-error.log" >> $FILE_NAME_POOL
echo "php_admin_value[memory_limit] = 32M" >> $FILE_NAME_POOL
echo "php_admin_value[open_basedir] = /home/easywi_web/htdocs/:/home/easywi_web/tmp/" >> $FILE_NAME_POOL
echo "php_admin_value[upload_tmp_dir] = /home/easywi_web/tmp" >> $FILE_NAME_POOL
echo "php_admin_value[session.save_path] = /home/easywi_web/session" >> $FILE_NAME_POOL

chown $MASTERUSER:www-data $FILE_NAME_POOL
