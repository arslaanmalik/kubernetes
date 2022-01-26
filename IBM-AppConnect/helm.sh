helm version
helm registry login --username AWS --password $(aws ecr get-login-password --region us-east-2) 736505676141.dkr.ecr.us-east-2.amazonaws.com
export HELM_EXPERIMENTAL_OCI=1
helm pull oci://736505676141.dkr.ecr.us-east-2.amazonaws.com/ace-deployment --version 0.1.0
tar -zxvf ace-deployment-0.1.0.tgz
