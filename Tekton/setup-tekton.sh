
echo "Installing Tekon Pipelines"
kubectl apply -f tekton-pipelines

kubectl get pods --namespace tekton-pipelines


echo "Installing Tekon Triggers"
kubectl apply -f tekton-triggers

kubectl get pods --namespace tekton-triggers

echo "Installing Tekon Dashboard"
kubectl apply -f tekton-dashboard
kubectl get pods --namespace tekton-pipelines

echo "Patching Tekton Dashboard to NodePort *Reconfigure Random Port Assigned*"
kubectl patch svc tekton-dashboard -n tekton-pipeline s --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
kubectl get svc --namespace tekton-pipelines
