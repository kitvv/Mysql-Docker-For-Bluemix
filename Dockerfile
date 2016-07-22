FROM centos:centos6.8

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN yum -y update; yum clean all
RUN yum -y erase mysql mysql-server
RUN yum -y install mysql-server mysql bash-completion psmisc net-tools epel-release; yum clean all
RUN rm -rf /var/lib/mysql

VOLUME /var/lib/mysql

COPY blue.sh /blue.sh
RUN chmod 755 /blue.sh

ENTRYPOINT ["/blue.sh"]
EXPOSE 3306
CMD ["/bin/bash"]
