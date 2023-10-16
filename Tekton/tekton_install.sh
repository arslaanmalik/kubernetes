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
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/triggers/main/examples/rbac.yaml

echo "Installing tekton cli"
rpm -Uvh https://github.com/tektoncd/cli/releases/download/v0.31.2/tektoncd-cli-0.31.2_Linux-64bit.rpm

echo "Installing tekton tasks"

kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/buildah/0.6/buildah.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/npm/0.1/npm.yaml

echo "You might need storage class for Tekton. For more details read README"