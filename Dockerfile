FROM futoase/docker-centos-base:utc

MAINTAINER Keiji Matsuzaki <futoase@gmail.com>

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

# install supervisor
RUN yum -y install --enablerepo=epel,remi supervisor

# create growthforecast user
RUN useradd -m growthforecast
RUN mkdir -p /home/growthforecast/scripts

# setup perlbrew
RUN export PERLBREW_ROOT=/opt/perlbrew && curl -L http://install.perlbrew.pl | bash
RUN source /opt/perlbrew/etc/bashrc && perlbrew install perl-5.18.2
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && perlbrew install-cpanm

# setup mysql
ADD ./scripts/mysqld-setup.sh /home/growthforecast/scripts/mysqld-setup.sh
RUN chmod +x /home/growthforecast/scripts/mysqld-setup.sh
RUN /home/growthforecast/scripts/mysqld-setup.sh

# setup nginx
ADD ./template/nginx.conf /etc/nginx/conf.d/growthforecast.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/conf.d/example_ssl.conf
RUN service nginx restart

# install growthforecast
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && cpanm -n GrowthForecast
RUN source /opt/perlbrew/etc/bashrc && perlbrew use perl-5.18.2 && cpanm -n DBD::mysql
RUN mkdir -p /home/growthforecast/GrowthForecast

# setup supervisor
RUN sed -i -e "s/nodaemon=false/nodaemon=true/g" /etc/supervisord.conf
ADD ./template/supervisor.conf /tmp/growthforecast.conf
RUN cat /tmp/growthforecast.conf >> /etc/supervisord.conf
RUN rm /tmp/growthforecast.conf

# startup
ENV PATH /opt/perlbrew/perls/perl-5.18.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV MYSQL_USER growthforecast
ENV MYSQL_PASSWORD growthforecast

ADD ./startup.sh /home/growthforecast/scripts/startup.sh
RUN chmod +x /home/growthforecast/scripts/startup.sh

EXPOSE 80
CMD ["/home/growthforecast/scripts/startup.sh"]
