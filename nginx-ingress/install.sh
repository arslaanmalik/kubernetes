#!/bin/bash

echo "What Port do you want to set the K8 ingress port to?"
# $http=
# $https=


echo "Installing K8 Ingress"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/baremetal/deploy.yaml

echo "Get Services Before Patching with NodePort"
kubectl get svc -n ingress-nginx
echo "Create Patching Yaml for Nodeport Dashboard"
cat << EOF > ingress_svc-nodeport_patch.yaml
spec:
  ports:
  - appProtocol: http
    name: http
    nodePort: 30000
    port: 80
    protocol: TCP
    targetPort: http
  - appProtocol: https
    name: https
    nodePort: 30001
    port: 443
    protocol: TCP
    targetPort: https
EOF

echo "Apply Patch"
kubectl -n ingress-nginx patch svc ingress-nginx-controller --patch "$(cat ingress_svc-nodeport_patch.yaml)"

echo "Get Services After Patching with NodePort"
kubectl get svc -n ingress-nginx
