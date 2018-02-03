From centos:7

# irteam/irteamsu 환경 설정
RUN mkdir /home1
RUN useradd -m -d /home1/irteam irteam -s /bin/bash
RUN useradd -m -d /home1/irteamsu irteamsu -s /bin/bash
RUN usermod -G irteam irteamsu
RUN chmod 755 /home1/irteam
RUN chmod 755 /home1/irteamsu
RUN echo "irteamsu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN yum -y install rpm
RUN yum -y update
RUN yum -y install net-tools git wget openssl openssl-devel libxml2-devel pcre-devel gcc expat-devel cmake gdbm gdbm-devel libjpeg-turbo-devel libpng-devel freetype-devel gd.x86_64 php-xml ncurses-devel cmake libaio-devel gcc-c++ perl-Data-Dumper
RUN exit
RUN su - irteam
RUN cd /home1/irteam
WORKDIR /home1/irteam
RUN mkdir apps
RUN cd /home1/irteam/apps
WORKDIR /home1/irteam/apps
RUN wget http://mirror.navercorp.com/apache//httpd/httpd-2.4.29.tar.gz
RUN tar xvzf httpd-2.4.29.tar.gz
RUN cd /home1/irteam/apps/httpd-2.4.29/srclib/
WORKDIR /home1/irteam/apps/httpd-2.4.29/srclib/
RUN wget http://apache.mirror.cdnetworks.com//apr/apr-1.6.3.tar.gz
RUN wget http://apache.mirror.cdnetworks.com//apr/apr-util-1.6.1.tar.gz
RUN wget http://apache.mirror.cdnetworks.com//apr/apr-iconv-1.2.2.tar.gz
RUN tar xvzf apr-1.6.3.tar.gz
RUN tar xvzf apr-util-1.6.1.tar.gz
RUN tar xvzf apr-iconv-1.2.2.tar.gz
RUN ln -s apr-1.6.3 apr
RUN ln -s apr-util-1.6.1 apr-util
RUN ln -s apr-iconv-1.2.2 apr-iconv
RUN cd /home1/irteam/apps/httpd-2.4.29
WORKDIR /home1/irteam/apps/httpd-2.4.29
RUN ./configure --prefix=/home1/irteam/apps/apache --with-included-apr --enable-ssl=yes
RUN make
RUN make install

EXPOSE 80
EXPOSE 443
