#!/bin/bash
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

echo "Checking Netfilter Availability"
lsmod | grep br_netfilter

echo "Enabling Kubelet"
sudo systemctl enable kubelet
sudo kubeadm config images pull

echo "Kubeadm Intialzing Advertising the Public IP on This Master Node"
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --upload-certs --control-plane-endpoint=$YOUR_IP

sudo mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

echo "Bootstrapping Kubectl Commands"
echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc

#Fix the Error – The connection to the server localhost:8080 was refused
export KUBECONFIG=/etc/kubernetes/admin.conf

echo "Checking Status of Nodes"
kubectl get nodes

echo "Installing Calico Network"
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml 

#kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
#echo "Installing Calico Cli ETCD"
#kubectl apply -f https://docs.projectcalico.org/manifests/calicoctl-etcd.yaml

echo "Checking Status of Nodes After Applying Calico Network"
sudo kubectl get nodes

echo"Setting Alias k for kubectl"
alias k=kubectl

#Note: By default control node will not be able to launch the pod, so to enable execute below command:
#kubectl taint nodes k8-master node-role.kubernetes.io/master-
#Revert the taint to make master disable scheduling pods on master
#kubectl taint nodes k8-master node-role.kubernetes.io/master:NoSchedule
