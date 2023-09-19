#!/bin/bash

echo "Installing tekton Pipelines"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "Installing triggers"
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml


echo "Installing dashboard for tekton"

kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml

