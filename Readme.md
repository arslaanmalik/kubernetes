**How to use**
Run Master.sh First and after it restarts Run Master2.sh

**Kubeadm Init Pre-Req**

You need to add entery of ip in /etc/hosts in order to execute Kubeadm init
Create a user and change the user to other than root when running mkdir commands
Change the Control Plan --apiserver-advertise-address=$PublicIP

**Refernece Article for K8 Jenkins Setup**
https://betterprogramming.pub/how-we-scaled-jenkins-in-less-than-a-day-ccbcada8e4a4

**Refernece Article for K8 Jenkins Agent Setup**
https://devopscube.com/docker-containers-as-build-slaves-jenkins/
#service url for jenkins url configuration could be like this
http://jenkins-service.default.svc.cluster.local:8080
Use Websocet option.
#Using Docker ps command in pod. 
https://estl.tech/accessing-docker-from-a-kubernetes-pod-68996709c04b

Docker group is 992 by using the command cat /etc/group check it. Then go to manage nodes and cloudes, configure clouds. Go to Pod Template and under RAW Yaml for the pod write this and then use merge option not the overwrite option
spec:
securityContext:
fsGroup: 992

**Refernece Article for K8 Kubeadm Setup**
https://computingforgeeks.com/install-kubernetes-cluster-on-centos-with-kubeadm/

Issue if Worker does not start, after installing the worker script but not running any join command
Make sure you use the join command first on worker node only then the kubelet will start. 

---------------------------------------------------------------------------------------------------------------------------------------------
**MS-TEAM WIKI**

K8s Links
Last edited: Just now
Youtube Links
https://www.youtube.com/watch?v=jPrVuJ8cz8U&list=PLKse5vnrrZ2mknVuTt9_SOaRg6l-vGURy
 
Calico
https://projectcalico.docs.tigera.io/networking/migrate-pools

#Installation of Calico
https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart

Flannel
#Installation of Flannel
Setup Kubernetes 1.14 Cluster on CentOS 7.6 (tekspace.io)

Kubeadm
Reset Kubeadm
https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-reset/

Installation
#Run pods on master node
https://computingforgeeks.com/how-to-schedule-pods-on-kubernetes-control-plane-node/
#Installation with Ubuntu
https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
#Installation with Centos 7
https://computingforgeeks.com/install-kubernetes-cluster-on-centos-with-kubeadm/
#Offical guide Installation 
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
If you do not have the token, you can get it by running the following command on the control-plane node:

kubeadm token list
Jenkins CICD with K8
https://chathura-siriwardhana.medium.com/configure-jenkins-with-kubernetes-e3175e02ca8
#K8 Deployment YAML for Jenkins
https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-kubernetes
#How to version docker images with build number in Jenkins to deploy as Kubernetes deployment?
https://www.titanwolf.org/Network/q/1088ed78-d582-44eb-961c-d1fb94c35cf3/y
#Install Jenkins on K8
https://computingforgeeks.com/how-to-install-jenkins-server-on-kubernetes-openshift/
This one Worked
https://betterprogramming.pub/how-we-scaled-jenkins-in-less-than-a-day-ccbcada8e4a4
#Deployment on K8 using Jenkins Pods and JenkinsFile
https://github.com/justmeandopensource/kubernetes
Installation of Dashboard and Service Account
https://computingforgeeks.com/how-to-install-kubernetes-dashboard-with-nodeport/
https://computingforgeeks.com/create-admin-user-to-access-kubernetes-dashboard/
#Service account linked with one namespace
https://computingforgeeks.com/restrict-kubernetes-service-account-users-to-a-namespace-with-rbac/
#If Kubeadm init goes wrong run this on Master and Workers:
 kubeadm reset && rm -rf /etc/cni/net.d
Misc Links
https://www.aquasec.com/cloud-native-academy/kubernetes-in-production/kubernetes-security-best-practices-10-steps-to-securing-k8s/
#CIDR to IPv4 Conversion
https://www.ipaddressguide.com/cidr
Patching Commands
#Check Dashboard Services
kubectl get svc -n kubernetes-dashboard
#Patch the dashboard svc to node port from external ip
kubectl --namespace kubernetes-dashboard patch svc kubernetes-dashboard -p '{​​​​​​​"spec": {​​​​​​​"type": "NodePort"}​​​​​​​}​​​​​​​'
FYI
Role: A role contains rules that represent a set of permissions. A role is used to grant access to resources within a namespace.
RoleBinding: A role binding is used to grant the permissions defined in a role to a user or set of users. It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted
Service Account: Account meant for for processes, which run in pods.
Debuging
https://pwittrock.github.io/docs/admin/kubeadm/
https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/
Master 
/var/log/kube-apiserver.log - API Server, responsible for serving the API
/var/log/kube-scheduler.log - Scheduler, responsible for making scheduling decisions
/var/log/kube-controller-manager.log - Controller that manages replication controllers
Worker Nodes
/var/log/kubelet.log - Kubelet, responsible for running containers on the node
/var/log/kube-proxy.log - Kube Proxy, responsible for service load balancing
https://k21academy.com/docker-kubernetes/the-connection-to-the-server-localhost8080-was-refused/
Fix the Error – The connection to the server localhost:8080 was refused
To manage the Kubernetes cluster, the client configuration and certificates are required. This configuration is created when kubeadm initialises the cluster. The command copies the configuration to the users home directory and sets the environment variable for use with the CLI.
 
1. Check if the kubeconfig environment variable is exported if not exported

export KUBECONFIG=/etc/kubernetes/admin.conf or $HOME/.kube/config
2. Check your  .kube or config in the home directory file. If you did not found it, then you need to move that to the home directory. using the following command

sudo cp /etc/kubernetes/admin.conf $HOME/
chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
Whenever you are starting Master Node you may require to set the environment variable. Hence it’s a repetitive task for you. It can be set permanently using the following command.

echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc

https://pwittrock.github.io/docs/admin/kubeadm/
kubeadm init
It is usually sufficient to run kubeadm init without any flags, but in some cases you might like to override the default behaviour. Here we specify all the flags that can be used to customise the Kubernetes installation.

--apiserver-advertise-address
This is the address the API Server will advertise to other members of the cluster. This is also the address used to construct the suggested kubeadm join line at the end of the init process. If not set (or set to 0.0.0.0) then IP for the default interface will be used.

This address is also added to the certifcate that the API Server uses.

--apiserver-bind-port
The port that the API server will bind on. This defaults to 6443.

--apiserver-cert-extra-sans
Additional hostnames or IP addresses that should be added to the Subject Alternate Name section for the certificate that the API Server will use. If you expose the API Server through a load balancer and public DNS you could specify this with

--apiserver-cert-extra-sans=kubernetes.example.com,kube.example.com,10.100.245.1
--cert-dir
The path where to save and store the certificates. The default is “/etc/kubernetes/pki”.

--config
A kubeadm specific config file. This can be used to specify an extended set of options including passing arbitrary command line flags to the control plane components.

Ports and Protocols
When running Kubernetes in an environment with strict network boundaries, such as on-premises datacenter with physical network firewalls or Virtual Networks in Public Cloud, it is useful to be aware of the ports and protocols used by Kubernetes components

| Control plane |
| Protocol  | Direction | Port Range | Purpose | Used By |
| ----------| ----------|------------|---------|---------|
| TCP | Inbound | 6443  | Kubernetes API server | All |
| TCP | Inbound | 2379-2380  | Kubernetes API server |kube-apiserver, etcd |
| TCP | Inbound | 10250  | Kubelet API  |Self, Control plane |
| TCP | Inbound | 10259  | kube-scheduler  |Self |
| TCP | Inbound | 10257  | kube-controller-manager  |Self |
Although etcd ports are included in control plane section, you can also host your own etcd cluster externally or on custom ports.

Worker node(s)
Protocol	Direction	Port Range	Purpose	Used By
TCP	Inbound	10250	Kubelet API	Self, Control plane
TCP	Inbound	30000-32767	NodePort Services†	All
 
AWS CLI in Jenkins + Kubernetes Secret Creation
Commands
Restart CoreDNS
kubectl -n kube-system rollout restart deployment coredns
 
Check Core DNS Logs
kubectl logs --namespace=kube-system coredns-XXX



