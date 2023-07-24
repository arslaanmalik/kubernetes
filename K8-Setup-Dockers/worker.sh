#!/bin/bash

echo "Updating Yum...."
#sudo yum -y update && sudo systemctl reboot

echo "Installing Kubelet, Kubeadm and Kubectl......"
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

#sudo yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo yum -y install epel-release vim git curl wget kubelet-1.23.2 kubeadm-1.23.2-0 kubectl-1.23.2 --disableexcludes=kubernetes

echo "Your Kubeadm version is......"
sudo kubeadm version

echo "Disabling SE Linux and Swap for you :)"
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

echo "Configuring sysctl...."
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# echo "Installing Docker..."
# sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# sudo yum install -y docker-ce docker-ce-cli containerd.io
# sudo mkdir /etc/docker
# sudo mkdir -p /etc/systemd/system/docker.service.d

# sudo tee /etc/docker/daemon.json <<EOF
# {
# "exec-opts": ["native.cgroupdriver=systemd"],
# "log-driver": "json-file",
# "log-opts": {
# "max-size": "100m"
# }
# }
# EOF

# echo "Daemon Reload, Enable and Restart Docker"
# sudo systemctl daemon-reload
# sudo systemctl restart docker
# sudo systemctl enable docker

echo "Your Docker Version is :"
sudo docker --version

echo "Disabling Firewall if enabled"
sudo systemctl disable --now firewalld

echo "Now your worker node is setting up :)"
lsmod | grep br_netfilter
sudo systemctl enable kubelet
