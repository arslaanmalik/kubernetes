#!/bin/bash

sudo openssl version
echo "You do not have oppenssl 1.1.1 which is required go to 'https://gist.github.com/Bill-tran/5e2ab062a9028bf693c934146249e68c' to setup"


echo "Creating Registry folder at /registry "
sudo mkdir -p /registry && cd "$_"
echo "Creating OpenSSL Certificats"
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt -subj "/CN=docker-registry" -addext "subjectAltName = DNS:docker-registry"

echo "Creating Folder Auth at /registry"
sudo mkdir auth
sudo docker run --rm --entrypoint htpasswd registry:2.6.2 -Bbn myuser mypasswd > auth/htpasswd
ls -R /registry/

echo "Creating TLS Certs"
kubectl create secret tls certs-secret --cert=/registry/certs/tls.crt --key=/registry/certs/tls.key

echo "Creating Docker Login Secret from Htpasswd"
kubectl create secret generic auth-secret --from-file=/registry/auth/htpasswd

echo "Applying the Yamls"
kubectl create -f Docker-Registry

echo "Exporing the Registry Name"
export REGISTRY_NAME="docker-registry"

echo "Fetching the Interal IP of Regsitry Service Running as Cluster IP using kubectl json"

echo "Exporing the Registry ClusterIP"
export REGISTRY_IP="$DockerRegistryServiceClusterIP"

echo "Exporing the Registry ClusterIP"
for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do ssh root@$x "echo '$REGISTRY_IP $REGISTRY_NAME' >> /etc/hosts"; done

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do ssh root@$x "rm -rf /etc/docker/certs.d/$REGISTRY_NAME:5000;mkdir -p /etc/docker/certs.d/$REGISTRY_NAME:5000"; done

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do scp /registry/certs/tls.crt root@$x:/etc/docker/certs.d/$REGISTRY_NAME:5000/ca.crt; done
