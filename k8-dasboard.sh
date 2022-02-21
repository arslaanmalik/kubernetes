#!/bin/bash

echo "Installing K8 Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
echo "Get Services"
kubectl get svc -n kubernetes-dashboard
echo "Patch Service to Change Cluster IP to Node"
kubectl --namespace kubernetes-dashboard patch svc kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'
echo "Get Services"
kubectl get svc -n kubernetes-dashboard
echo "Create Patching Yaml for Nodeport Dashboard"
cat << EOF > nodeport_dashboard_patch.yaml
spec:
  ports:
  - nodePort: 32000
    port: 443
    protocol: TCP
    targetPort: 8443
EOF
echo "Apply Patch"
kubectl -n kubernetes-dashboard patch svc kubernetes-dashboard --patch "$(cat nodeport_dashboard_patch.yaml)"
echo "Check for Deployments in K8-Dashboard Namespace"
kubectl get deployments -n kubernetes-dashboard             
echo "Check if Service is changed to Nodeport"
kubectl get service -n kubernetes-dashboard  

echo "Creating Service Account (dashboard-admin) for the Dashboard"
kubectl apply -f dashboard-rbac.yaml
echo "Set a variable to store the name of the service account."
SA_NAME="dashboard-admin"
echo "Print the token for the admin user created"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep ${SA_NAME} | awk '{print $1}')

#echo "Check for the Service "
#curl -k https://$WORKER_IP:32000

