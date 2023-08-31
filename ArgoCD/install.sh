#!/bin/bash

# Create the directory structure
mkdir -p argocd/installation

# Create kustomization.yaml file
cat <<EOT > argocd/installation/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
## changes to config maps
patchesStrategicMerge:
  - argocd-cmd-params-cm-patch.yml
namespace: argocd
EOT

# Create argocd-cmd-params-cm-patch.yml file
cat <<EOT > argocd/installation/argocd-cmd-params-cm-patch.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cmd-params-cm
data:
  server.insecure: "true"
EOT

# Run kubectl commands
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k argocd/installation