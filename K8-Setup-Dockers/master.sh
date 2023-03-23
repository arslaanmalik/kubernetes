#!/bin/bash

echo "Updating Yum...."
sudo yum -y update

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

echo "Checking the current status of selinux"
sudo sestatus

echo "Disabling SE Linux and Swap for You"
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

echo "Restaring your system to accept selinux disabled"
sudo init 6
