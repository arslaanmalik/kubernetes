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

