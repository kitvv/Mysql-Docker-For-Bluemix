#!/bin/bash
set -e

StartMySQL ()
{
# Start the MySQL daemon in the background.
    /usr/bin/mysqld_safe 
}
#sure that "mysql" uses the same uid and gid as the host volume
ChangePermisson()
{
	echo '* Working around permission errors locally by making sure that "mysql" uses the same uid and gid as the host volume'
	TARGET_UID=$(stat -c "%u" /var/lib/mysql)
	echo '-- Setting mysql user to use uid '$TARGET_UID
	usermod -o -u $TARGET_UID mysql || true
	TARGET_GID=$(stat -c "%g" /var/lib/mysql)
	echo '-- Setting mysql group to use gid '$TARGET_GID
	groupmod -o -g $TARGET_GID mysql || true
	echo '-- Setting /var/run/mysqld/ '
	chown -R mysql:root /var/run/mysqld/
}
Initialize(){
	# Initialize empty data volume and create MySQL user
	if [[ ! -d /var/lib/mysql/mysql ]]; then
		echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
		echo "=> Installing MySQL ..."
		mysql_install_db --user=mysql >/dev/null 2>&1
		echo "=> Installing Done!"
	else
		echo "=> Using an existing volume of MySQL"
	fi
}
ChangePermisson
Initialize
StartMySQL
