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

echo "Checking Netfilter Availability"
lsmod | grep br_netfilter

echo "Enabling Kubelet"
sudo systemctl enable kubelet
sudo kubeadm config images pull

echo "Kubeadm Intialzing Advertising the Public IP on This Master Node"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --upload-certs

echo "Creating Folders and giveing permissions to run Kubectl Commands"
sudo mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

#Fix the Error – The connection to the server localhost:8080 was refused
#export KUBECONFIG=/etc/kubernetes/admin.conf

echo "Bootstrapping Kubectl Commands"
echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc

echo "Checking Status of Nodes"
kubectl get nodes

echo "Installing Flannel Cli"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
echo "Checking if Flannel and Core DNS is Installed"
kubectl get pods -n kube-system

echo "Checking Status of Nodes After CNI "
sudo kubectl get nodes

echo"Setting Alias k for kubectl"
alias k=kubectl

#Note: By default control node will not be able to launch the pod, so to enable execute below command:
#kubectl taint nodes k8-master node-role.kubernetes.io/master-
#Revert the taint to make master disable scheduling pods on master
#kubectl taint nodes k8-master node-role.kubernetes.io/master:NoSchedule
