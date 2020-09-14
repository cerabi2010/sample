#FROM registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat7-openshift
#FROM registry.redhat.io/jboss-webserver-3/webserver31-tomcat7-openshift
FROM docker-registry.default.svc:5000/openshift/webserver31-tomcat7-openshift:latest

#FROM tomcat7-base:latest
    
USER root
#USER 185
#RUN useradd -u 185 -G root tomcat

# RUN yum -y update \
# RUN yum -y install openssh-clients.x86_64 
 
 
  
  
ARG TOMCAT_PATH=/opt/webserver
RUN rm -rf ${TOMCAT_PATH}/conf/server.xml
RUN rm -rf ${TOMCAT_PATH}/conf/log4j.properties
RUN rm -rf ${TOMCAT_PATH}/conf/web.xml
#ARG TOMCAT_PATH=/usr/local/tomcat/apache-tomcat-7.0.62
   
# Lib
COPY mysql-connector-java-commercial-5.1.29-bin.jar ${TOMCAT_PATH}/lib/
COPY postgresql-42.2.9.jar ${TOMCAT_PATH}/lib/

# app
ADD files/webapps/simple ${TOMCAT_PATH}/webapps/simple
# conf
COPY server.xml ${TOMCAT_PATH}/conf/
COPY web.xml ${TOMCAT_PATH}/conf/
COPY log4j.properties ${TOMCAT_PATH}/lib/

# for valut
COPY files/vault/tomcat-vault.jar ${TOMCAT_PATH}/lib/
COPY files/vault/catalina.properties ${TOMCAT_PATH}/conf/
COPY files/vault/vault.properties ${TOMCAT_PATH}/conf/
COPY files/vault/crm.keystore ${TOMCAT_PATH}/conf/
COPY files/vault/VAULT.dat ${TOMCAT_PATH}/conf/



# Direcotry Permission
RUN chmod 777 ${TOMCAT_PATH}/conf ${TOMCAT_PATH}/lib -R \
  && chown -R 185:root ${TOMCAT_PATH}/conf ${TOMCAT_PATH}/lib ${TOMCAT_PATH}/webapps/simple
     
# App 복사
#ADD files/webapps/simple ${TOMCAT_PATH}/webapps/simple
#ADD files/webapps/web ${TOMCAT_PATH}/webapps/web
#ADD files/webapps/web2 ${TOMCAT_PATH}/webapps/web2

# Allow arbitrary
USER 185
  
EXPOSE 8080
   
#ENTRYPOINT ["catalina.sh", "run"]
