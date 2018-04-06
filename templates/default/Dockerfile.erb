FROM jenkins/jenkins:latest

USER root
RUN apt-get update && apt-get install -y python-pip jq
RUN pip install scalr-ctl

RUN /usr/local/bin/install-plugins.sh github

# copy script to container
COPY add_admin.groovy /usr/share/jenkins/ref/init.groovy.d/add_admin.groovy

# drop back to the regular jenkins user - good practice
USER jenkins
RUN scalr-ctl
