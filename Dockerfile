FROM centos

MAINTAINER Keiji Matsuzaki <futoase@gmail.com>

# setup network
# reference from https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# setup remi repository
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN curl -O http://rpms.famillecollet.com/RPM-GPG-KEY-remi; rpm --import RPM-GPG-KEY-remi
RUN rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

# setup nginx repository
ADD ./template/nginx.repo /etc/yum.repos.d/nginx.repo

# setup tools
# reference from http://blog.nomadscafe.jp/2013/12/centos-65dockergrowthforecast.html
RUN yum -y groupinstall --enablerepo=epel,remi "Development Tools"
RUN yum -y install --enablerepo=epel,remi pkgconfig glib2-devel gettext libxml2-devel pango-devel cairo-devel git ipa-gothic-fonts
RUN yum -y install --enablerepo=epel,remi mysql mysql-server mysql-devel

# install nginx
RUN yum -y install --enablerepo=nginx nginx

# setup perlbrew
RUN export PERLBREW_ROOT=/opt/perlbrew && curl -L http://install.perlbrew.pl | bash
RUN source /opt/perlbrew/etc/bashrc && perlbrew install perl-5.18.2
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && perlbrew install-cpanm

# setup mysql
RUN chkconfig --level 2345 mysqld on
RUN service mysqld start && mysqladmin -h localhost -u root create growthforecast
RUN service mysqld start && mysql -u root -e "GRANT CREATE, ALTER, DELETE, INSERT, UPDATE, SELECT ON growthforecast.* TO 'growthforecast'@'localhost' IDENTIFIED BY 'growthforecast';"

# setup nginx
ADD ./template/nginx.conf /etc/nginx/conf.d/growthforecast.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/conf.d/example_ssl.conf
RUN service nginx restart

# install growthforecast
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && cpanm -n GrowthForecast
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && cpanm -n DBD::mysql
RUN mkdir -p /root/GrowthForecast

# startup
ENV PATH /opt/perlbrew/perls/perl-5.18.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV MYSQL_USER growthforecast
ENV MYSQL_PASSWORD growthforecast

ADD ./startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

EXPOSE 80
CMD ["/root/startup.sh"]
