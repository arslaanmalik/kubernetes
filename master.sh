#!/bin/bash

echo "Updating Yum...."
#sudo yum -y update && sudo systemctl reboot

echo "Installing Kubelet, Kubeadm and Kubectl......"
sudo tee /etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-
x86_64
enabled=1
gpgcheck=1repo_gpgcheck=1gpgkey=https://packages.cloud.google.com/yu
m/doc/yum-key.gpghttps://packages.cloud.google.com/yum/doc/rpmpackage-key.gpg
EOF

sudo yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --
disableexcludes=kubernetes

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

echo "Installing Docker..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo
https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
sudo mkdir /etc/docker
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2",
"storage-opts": [
"overlay2.override_kernel_check=true"
]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

echo "Your Docker Version is :"
sudo docker --version

echo "Disabling Firewall if enabled"
sudo systemctl disable --now firewalld

echo "Now your master node is setting up :)"
$ lsmod | grep br_netfilter
br_netfilter 22256 0
bridge 151336 2 br_netfilter,ebtable_broute
sudo systemctl enable kubelet
sudo kubeadm config images pull
echo"Your Pod netwrok cidr will be 10.244.0.0/16"
sudo kubeadm init --control-plane-endpoint=192.168.100.99
echo"Extract the token to join your worker nodes with your master otherwise you                                                                                              can not connect each other"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
