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
# apache 설치
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
# tomcat 설치
RUN cd /home1/irteam/apps
WORKDIR /home1/irteam/apps
RUN wget http://mirror.navercorp.com/apache/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz
RUN tar xvzf apache-tomcat-8.5.24.tar.gz
RUN ln -s apache-tomcat-8.5.24 tomcat
# jdk 설치
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz
RUN tar xvzf jdk-8u161-linux-x64.tar.gz
RUN ln -s jdk1.8.0_161 jdk
RUN echo "export LD_LIBRARY_PATH=/home1/irteam/apps/python/lib:/usr/lib/:/usr/lib64/:/usr/include/:/home1/irteam/apps/net-snmp/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
RUN echo "export APP_HOME=/home1/irteam" >> ~/.bashrc
RUN echo "export JAVA_HOME=$APP_HOME/apps/jdk" >> ~/.bashrc
RUN echo "export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH" >> ~/.bashrc
RUN echo "export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/jre/lib/ext" >> ~/.bashrc
RUN echo "export PATH=/home1/irteam/apps/mysql/bin:/home1/irteam/apps/cmake/bin:$PATH" >> ~/.bashrc
RUN echo "export CATALINA_HOME=${APP_HOME}/apps/tomcat" >> ~/.bashrc
RUN echo "export PYTHON_HOME=$APP_HOME/apps/python" >> ~/.bashrc
RUN echo "export PATH=$PYTHON_HOME/bin:$PATH" >> ~/.bashrc
RUN echo "export MYSQL_HOME=$APP_HOME/mysql" >> ~/.bashrc
RUN echo "export  PHP=$APP_HOME/php" >> ~/.bashrc
RUN source ~/.bashrc
# mod_jk설치
RUN wget http://apache.tt.co.kr/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz
RUN tar xvzf tomcat-connectors-1.2.42-src.tar.gz
RUN cd /home1/irteam/apps/tomcat-connectors-1.2.42-src/native
WORKDIR /home1/irteam/apps/tomcat-connectors-1.2.42-src/native
RUN ./configure --with-apxs=/home1/irteam/apps/apache/bin/apxs
RUN make 
RUN cd /home1/irteam/apps/tomcat-connectors-1.2.42-src/native/apache-2.0
WORKDIR /home1/irteam/apps/tomcat-connectors-1.2.42-src/native/apache-2.0
RUN chmod 755 mod_jk.so
RUN cp mod_jk.so /home1/irteam/apps/apache/modules

EXPOSE 80
EXPOSE 443
