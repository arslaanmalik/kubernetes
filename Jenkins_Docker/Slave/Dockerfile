FROM jenkins/jnlp-slave

USER root
RUN apt update -y
#Installing Tools
RUN apt install -y apt-transport-https  ca-certificates  curl  gnupg2  software-properties-common git vim unzip 

#Installing Docker and Docker Compose
RUN mkdir -p /tmp/download && \
 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz | tar -xz -C /tmp/download && \
 rm -rf /tmp/download/docker/dockerd && \
 mv /tmp/download/docker/docker* /usr/local/bin/ && \
 rm -rf /tmp/download && \
 groupadd -g 999 docker && \
 usermod -aG staff,docker jenkins
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
#VOLUME /root/.docker

#Installing Kubernetes CLI
RUN cd /usr/bin && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.2/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl
COPY config /root/.kube/
#Installing Helm Cli
RUN wget -O /root/helm.tar.gz https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz
RUN cd /root && tar -zxvf helm.tar.gz
RUN cd /root && mv /root/linux-amd64/helm /usr/bin/helm
RUN chmod +x /usr/bin/helm
RUN cp -a /usr/bin/helm /usr/local/bin/helm
RUN helm init --upgrade
#Installing AWS Cli
RUN wget -O /root/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" 
RUN cd /root && unzip awscliv2.zip
RUN ./root/aws/install -i /usr/local/aws-cli -b /usr/local/bin
RUN chmod +x /usr/local/bin/aws-cli

USER jenkins