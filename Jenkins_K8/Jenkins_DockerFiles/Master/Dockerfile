FROM jenkins/jenkins:centos7-jdk11
USER root

RUN yum -y update
RUN yum install -y yum-utils
#Adding Docker Repo
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN  yum install -y docker-ce docker-ce-cli containerd.io
RUN usermod -aG docker jenkins

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

USER jenkins