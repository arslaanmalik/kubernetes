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
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

#sudo yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo yum -y install epel-release vim git curl wget kubelet-1.26.3 kubeadm-1.26.3-0 kubectl-1.26.3 --disableexcludes=kubernetes

echo "Your Kubeadm version is......"
sudo kubeadm version

echo "Disabling SE Linux and Swap for you :)"
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
echo "Configuring Systemctl ModProbe Overlay and Netfilter"
sudo modprobe overlay
sudo modprobe br_netfilter
echo "Enabling IP forwarding so that our pods can communicate with each other"
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

sleep 30

echo "Installing Containerd..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y && yum install -y containerd.io
# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml
echo "Seting the cgroup driver for runc to systemd which is required for the kubelet."
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd

echo "Seting crictl CLI"
# To execute crictl CLI commands, ensure we create a configuration file as mentioned below
echo -e "runtime-endpoint: unix:///run/containerd/containerd.sock\nimage-endpoint: unix:///run/containerd/containerd.sock\ntimeout: 2" > /etc/crictl.yaml
echo "Now you can use crictl commands like crictl images"

echo "Your Containerd Version is :"
sudo ctr --version

echo "Disabling Firewall if enabled"
sudo systemctl disable --now firewalld

echo "Now your worker node is setting up :) Dont worry if your status of Kubelet is not started once you add the master join command of kubeadm it will get started"
lsmod | grep br_netfilter
sudo systemctl enable kubelet
