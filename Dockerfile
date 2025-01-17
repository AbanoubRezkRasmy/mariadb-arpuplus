FROM mariadb/server:10.4

##Install MariaDB.
RUN 
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db && \
  echo "deb http://mariadb.mirror.iweb.com/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config && \
  RUN apt-get update && \
  RUN apt-get install -y  software-properties-common && \
  RUN apt-key adv --keyserver keyserver.ubuntu.com --recv BC19DDBA && \
  RUN add-apt-repository 'deb https://releases.galeracluster.com/galera-3/ubuntu trusty main' && \
  RUN add-apt-repository 'deb https://releases.galeracluster.com/mysql-wsrep-5.6/ubuntu trusty main' && \


  RUN apt-get update && \
  RUN apt-get install -y galera-3 galera-arbitrator-3 mysql-wsrep-5.6 rsync && \

  COPY my.cnf /etc/mysql/my.cnf && \
  ENTRYPOINT ["mysqld"]

# Define mountable directories.
  VOLUME ["/etc/mysql", "/var/lib/mysql" , "/var/log/mysql"]

# Define working directory.
  WORKDIR /data

# Define default command.
  CMD ["mysqld_safe"]

# Expose ports.
  EXPOSE 3306
  EXPOSE 8080 
