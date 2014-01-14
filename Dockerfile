# Docker Drupal
#
# VERSION       0.1
# DOCKER-VERSION        0.7.2
FROM    centos:latest
MAINTAINER Lee Faus <lee@cloudninepartners.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install tar wget git mysql-server httpd pwgen python-setuptools vim php php-mysql php-apc php-dom php-gd memcached php-pecl-memcache php-pear-Console-Table mc


# Still need drush
RUN wget --quiet -O - http://ftp.drupal.org/files/projects/drush-7.x-4.5.tar.gz | tar -zxf - -C /usr/local/share
RUN ln -s /usr/local/share/drush/drush /usr/local/bin/drush

RUN yum -y update

# Make mysql listen on the outside
RUN sed -i "s/^bind-address/#bind-address/" /etc/my.cnf
ADD supervisord /etc/supervisord.conf
ADD dbscript.sh /tmp/dbscript.sh 
RUN chmod 775 /tmp/dbscript.sh
RUN /etc/init.d/mysqld start ; ./tmp/dbscript.sh drupaldb drupal drupal

RUN easy_install supervisor

# Retrieve drupal
RUN rm -rf /var/www/html ; cd /var/www ; drush dl drupal ; mv /var/www/drupal*/ /var/www/html
RUN chmod a+w /var/www/html/sites/default ; mkdir /var/www/html/sites/default/files ; chown -R apache:apache /var/www/html ; chmod 775 /var/www/html/sites/default/files

EXPOSE 80
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]