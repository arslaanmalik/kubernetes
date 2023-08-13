#!/bin/bash

echo "Installing OpenEBS"
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml

kubectl get pods -n openebs

echo "List Storage Classes"
kubectl get sc


echo "Create a Storage Class"
echo "Path for the Storage class in worker node  /var/local-hostpath" 
kubectl apply -f openebs-storageclass.yaml


kubectl get sc



