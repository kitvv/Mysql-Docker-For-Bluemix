# Mysql-Docker-For-Bluemix

This is the Git repo of the docker image for mysql.
It based on offical centos image [centos:centos6.8] and you can mount bluemix space volume to mysql data in IBM Containers

why use this image?
  --> bluemix volume is NFS4
  --> when containers is start and the user namespace is enabled for docker engine,The effective root inside the container is a non-root       user out side the container process.
  --> UID:GID is 1010:1010 or 0:0
  --> can not chown where volume is mounted, like /var/lib/mysql

quickly start
  1 sudo cf ic cpi kitvv/mysql-nfs registry.ng.bluemix.net/your private namespace/image_name:image_tag
  2 sudo cf ic volume create myvol
  3 sudo cf ic run -d --name mysql --volume myvol:/var/lib/mysql registry.ng.bluemix.net/your private namespace/image_name:image_tag
  4 sudo cf ic exec -it mysql bash
or using Dockerfile to build your image
  1 sudo docker build -t "registry.ng.bluemix.net/your private namespace/image_name" .
  2 sudo push "registry.ng.bluemix.net/your private namespace/image_name"
  3 sudo cf ic volume create myvol (same as quickly start)
or using other mysql images follow this work-around 
  1 add mysql gourp and user
  2 install mysql-server
  3 rm -rf /var/lib/mysql
  4 do not start or initialize in CMD
  5 write entry point script
  6 do not using chown for /var/lib/mysql,but instead, userID en goupID of mysql should be changed to match /var/lib/mysql
      something like:
      usermod -o -u `stat -c %u /var/lib/mysql` mysql
      groupmod -o -g `stat -c %g /var/lib/mysql` mysql
      chown -R mysql:root /var/run/mysqld/
  7 initialize mysql if your bluemix volume is empty
  8 start mysql
