From centos:7.4.1708

# irteam/irteamsu 환경 설정
RUN mkdir /home1
RUN useradd -m -d /home1/irteam irteam 
RUN useradd -m -d /home1/irteamsu irteamsu  
RUN usermod -G irteam irteamsu
RUN chmod 755 /home1/irteam
RUN chmod 755 /home1/irteamsu\
&& yum -y install sudo
RUN echo "irteamsu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN su - irteamsu
RUN sudo yum -y update
RUN sudo yum -y install net-tools git wget openssl openssl-devel libxml2-devel pcre-devel gcc expat-devel cmake gdbm gdbm-devel libjpeg-turbo-devel libpng-devel freetype-devel gd.x86_64 php-xml ncurses-devel cmake libaio-devel gcc-c++ perl-Data-Dumper
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
RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz 
RUN tar xvzf apache-tomcat-8.5.24.tar.gz
RUN ln -s apache-tomcat-8.5.24 tomcat
#instance 2개 생성
RUN mkdir instance1\
&& mkdir instance2
WORKDIR /home1/irteam/apps/tomcat
RUN cd /home1/irteam/apps/tomcat\
&& cp -R bin conf lib logs temp work /home1/irteam/apps/instance1\
&& cp -R bin conf lib logs temp work /home1/irteam/apps/instance2\
&& ln -s webapps/ /home1/irteam/apps/instance1/webapps\
&& ln -s webapps/ /home1/irteam/apps/instance2/webapps
WORKDIR /home1/irteam/apps/instance1/bin
RUN cd /home1/irteam/apps/instance1/bin\
&& touch startup_instance1.sh\
&& echo "cd /home1/irteam/apps/instance1/bin" >>startup_instance1.sh\
&& echo "./startup.sh" >> startup_instance1.sh\
&& chmod 755 startup_instance1.sh\
&& touch shutdown_instance1.sh\
&& echo "cd /home1/irteam/apps/instance1/bin" >> shutdown_instance1.sh\
&& echo "./shutdown.sh" >> shutdown_instance1.sh\
&& chmod 755 shutdown_instance1.sh
WORKDIR /home1/irteam/apps/instance2/bin
RUN cd /home1/irteam/apps/instance2/bin\
&& echo "cd /home1/irteam/apps/instance1/bin" >>startup_instance2.sh\
&& echo "./startup.sh" >> startup_instance2.sh\
&& chmod 755 startup_instance2.sh\
&& touch shutdown_instance2.sh\
&& echo "cd /home1/irteam/apps/instance1/bin" >> shutdown_instance2.sh\
&& echo "./shutdown.sh" >> shutdown_instance2.sh\
&& chmod 755 shutdown_instance2.sh


# jdk 설치
WORKDIR /home1/irteam/apps
RUN cd /home1/irteam/apps\
&& wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz\
&& tar xvzf jdk-8u161-linux-x64.tar.gz\
&& ln -s jdk1.8.0_161 jdk\
&& echo "export LD_LIBRARY_PATH=/home1/irteam/apps/python/lib:/usr/lib/:/usr/lib64/:/usr/include/:/home1/irteam/apps/net-snmp/lib:$LD_LIBRARY_PATH" >> ~/.bashrc\
&& echo "export APP_HOME=/home1/irteam" >> ~/.bashrc\
&& echo "export JAVA_HOME=$APP_HOME/apps/jdk" >> ~/.bashrc\
&& echo "export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH" >> ~/.bashrc\
&& echo "export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/jre/lib/ext" >> ~/.bashrc\
&& echo "export PATH=/home1/irteam/apps/mysql/bin:/home1/irteam/apps/cmake/bin:$PATH" >> ~/.bashrc\
&& echo "export CATALINA_HOME=${APP_HOME}/apps/tomcat" >> ~/.bashrc\
&& echo "export PYTHON_HOME=$APP_HOME/apps/python" >> ~/.bashrc\
&& echo "export PATH=$PYTHON_HOME/bin:$PATH" >> ~/.bashrc\
&& echo "export MYSQL_HOME=$APP_HOME/mysql" >> ~/.bashrc\
&& echo "export  PHP=$APP_HOME/php" >> ~/.bashrc\
&& source ~/.bashrc
# mod_jk설치

RUN wget http://apache.tt.co.kr/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz\
&& tar xvzf tomcat-connectors-1.2.42-src.tar.gz\
&& cd /home1/irteam/apps/tomcat-connectors-1.2.42-src/native
WORKDIR /home1/irteam/apps/tomcat-connectors-1.2.42-src/native
RUN ./configure --with-apxs=/home1/irteam/apps/apache/bin/apxs \
&& make\
&& make install\
&& cd /home1/irteam/apps/tomcat-connectors-1.2.42-src/native/apache-2.0
WORKDIR /home1/irteam/apps/tomcat-connectors-1.2.42-src/native/apache-2.0
RUN chmod 755 mod_jk.so\
&& cp mod_jk.so /home1/irteam/apps/apache/modules

# mysql설치
WORKDIR /home1/irteam/apps
RUN cd /home1/irteam/apps\
&& wget https://downloads.mysql.com/archives/get/file/mysql-5.6.35.tar.gz\
&& tar xvzf mysql-5.6.35.tar.gz
WORKDIR /home1/irteam/apps/mysql-5.6.35
RUN cd /home1/irteam/apps/mysql-5.6.35\
&& cmake . -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DMYSQL_DATADIR=/home1/irteam/apps/mysql/data/ -DCMAKE_INSTALL_PREFIX=/home1/irteam/apps/mysql -DINSTALL_LAYOUT=STANDALONE -DENABLED_PROFILING=ON -DMYSQL_MAINTAINER_MODE=OFF -DWITH_DEBUG=OFF -DDEFAULT_CHARSET=utf8 -DENABLED_LOCAL_INFILE=TRUE -DWITH_ZLIB=bundled -DWITH_INNOBASE_STORAGE_ENGINE=1 -DMYSQL_TCP_PORT=13306 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_UNIX_ADDR=/home1/irteam/apps/mysql/run/mysql.sock\
&& make\
&& make install 
WORKDIR /home1/irteam/apps/mysql/scripts
RUN cd /home1/irteam/apps/mysql/scripts\
&& ./mysql_install_db --user=irteam --datadir=/home1/irteam/apps/mysql/data --basedir=/home1/irteam/apps/mysql --defaults-file=/home1/irteam/apps/mysql/my.cnf
WORKDIR /home1/irteam/apps/mysql 
RUN cd /home1/irteam/apps/mysql\
&& echo "innodb_buffer_pool_size = 1G" >> my.cnf\
&& echo "port = 13306" >> my.cnf \
&& echo "basedir = /home1/irteam/apps/mysql" >> my.cnf \
&& echo "datadir = /home1/irteam/apps/mysql" >> my.cnf \
&& echo "sock = /home1/irteam/apps/mysql/run/mysql.sock" >> my.cnf \
&& mkdir run \
&& mkdir logs
WORKDIR /home1/irteam/apps/mysql/bin
RUN cd /home1/irteam/apps/mysql/bin
RUN ./mysqld --basedir=/home1/irteam/apps/mysql --datadir=/home1/irteam/apps/mysql/data --plugin-dir=/home1/irteam/apps/mysql/lib/plugin --log-error=/home1/irteam/apps/mysql/logs/error.log --pid-file=/home1/irteam/apps/mysql/run/mysqld.pid --socket=/home1/irteam/apps/mysql/run/mysql.sock --port=13306 
RUN ./mysql -u root -S /home1/irteam/apps/mysql/run/mysql.sock
RUN use mysql;
RUN update user set password=password('123456') where user='root';
RUN flush privileges;
RUN \q








EXPOSE 80
EXPOSE 443
