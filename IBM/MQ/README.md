Note that these steps have been tested with MQ Image 9.1.4.0-r1 on OCP 4.2. These steps show you how you can deploy an ephimeral Queue Manager on OCP 4.2 with SSL enabled. IBM MQ Helm charts can be used to deploy on Kubernetes or on OCP 4.3 and earlier. Note that IBM MQ helm charts have been deprecated and MQ operator should be used to deploy on OCP 4.4 onwards.
The steps show you how you can build MQ custom image with SSL configurations baked into the image.

# Step1: Generate SSL keys
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=foo.bar.com"

Give the CN value as appropriate

# Step2: 
Put the tls.key and tls.cert in same folder as that of Dockerfile. If you put them in other directory, make sure to update path of Dockerfile
Also create mqsc file if you want to do some configurations. In this example, we are creating a channel and disable chalauth & connauth on queue manager. Look at config.mqsc file

# Step3: 
Build the docker image and push to OCP registry. Below is example of commands. Make sure to update as per your environment/tag/ocp registry url/namespace etc
docker build -t mymqimage:1.7 .

docker tag mymqimage:1.7 default-route-openshift-image-registry.apps.myocp.os.fyre.ibm.com/mq/mymqimage:1.7

docker push default-route-openshift-image-registry.apps.myocp.os.fyre.ibm.com/mq/mymqimage:1.7

# Step4:
Update Deployment yaml with the image url

# Step 5:
Perform deployment, create service and route. Below is an example

oc apply -f QM_Deployment.yaml

oc expose deploy/qm2 --name=qm2 --port=1414 --type=ClusterIP

oc expose svc/qm2

# Step 6:
To connect to the queue manager externally, follow the below blog to create the route for the channel and import tls.crt into the truststore of client.
https://developer.ibm.com/integration/blog/2020/02/28/connecting-to-a-queue-manager-on-cloud-pak-for-integration/
