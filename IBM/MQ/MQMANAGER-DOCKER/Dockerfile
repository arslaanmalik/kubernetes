FROM ibmcom/mq:latest
COPY configure.mqsc /etc/mqm/
COPY tls.* /etc/mqm/pki/keys/default/
EXPOSE 1414 9443
ENV LICENSE accept