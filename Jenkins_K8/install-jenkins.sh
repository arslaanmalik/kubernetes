#!/bin/bash

echo "Create the PV directory first"

echo "Creating Namespace Jenkins "
kubectl create namespace jenkins

echo "Create Persistant Volume"
kubectl apply -f /Jenkins_K8_Yaml/pv.yml

echo "Setup Kubernetes Jenkins"
kubectl apply -f $workspace/jenkins-deployment.yml -n jenkins

