cd ..
cd infra
cd registry
terraform init
terraform apply --auto-approve
cd ..
cd ..

REPO_NAME_NODE="nodetest"
REPO_NAME_PYTHON="djangotest" 
REPO_NAME_JAVA="springtest"

cd apps


#djnago
cd django-app

IMAGE_ID=$(docker build -q -t djangoapp:v0.1 .)

# Tag the image
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_PYTHON:v0.1

# Push the tagged image 
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_PYTHON:v0.1

cd ..

cd nest-app
IMAGE_ID=$(docker build -q -t nestjsapp:v0.1 .)

# Tag the image 
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_NODE:v0.1

# Push the tagged image
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_NODE:v0.1

cd ..
cd spring-app
mvn package

# Build the Docker image 
IMAGE_ID=$(docker build -q -t springbootapp:v0.1 .)

# Tag the image
docker tag $IMAGE_ID iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_JAVA:v0.1 

# Push the tagged image
docker push iad.ocir.io/idmaqhrbiuyo/$REPO_NAME_JAVA:v0.1
cd ..
cd ..

cd infra
cd kubernetes
terraform init
terraform apply --auto-approve

# CLUSTER CONNECT
CLUSTER_ID=$(terraform output -raw k8s-cluster-id)
TF_OUTPUT=$(terraform output k8s-node-pool-id)
TF_OUTPUT="${TF_OUTPUT%\"}"
TF_OUTPUT="${TF_OUTPUT#\"}"
oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file $HOME/.kube/config --region us-ashburn-1 --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
export KUBECONFIG=$HOME/.kube/config
kubectl get service

cd ..
cd ..

cd scripts
kubectl apply -f nginx.yaml
kubectl apply -f namespace.yaml
kubectl create secret docker-registry ocirsecret --docker-server=iad.ocir.io --docker-username=idmaqhrbiuyo/apoorva.alshi@impetus.com --docker-password='3(OQmu[P0g}2::CtP#Z9' --docker-email=apoorva.alshi@impetus.com -n app
kubectl apply -f deployment-django.yaml
kubectl apply -f deployment-nestjs.yaml
kubectl apply -f deployment-spring.yaml
sleep 60
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginxsvc/O=nginxsvc"
kubectl create secret tls tls-secret --key tls.key --cert tls.crt -n app
kubectl apply -f service-django.yaml
kubectl apply -f service-java.yaml
kubectl apply -f service-nest.yaml
sleep 20
kubectl apply -f ingress-django.yaml
kubectl apply -f ingress-java.yaml
kubectl apply -f ingress-nestjs.yaml

echo "ingress done"
kubectl apply -f metric-server.yaml
sleep 30
kubectl -n kube-system get deployment/metrics-server 
kubectl apply -f horizontal-pod-autoscaler-django.yaml
kubectl apply -f horizontal-pod-autoscaler-java.yaml
kubectl apply -f horizontal-pod-autoscaler-nginx.yaml
kubectl apply -f horizontal-pod-autoscaler-ping.yaml
sleep 60
kubectl get hpa -n app
sed -E "s|<REPLACE_WITH_DYNAMIC_VALUE>|$TF_OUTPUT|g" autoscaler.yaml > cluster-autoscaler.yaml
kubectl apply -f cluster-autoscaler.yaml
sleep 30
kubectl -n kube-system get cm cluster-autoscaler-status -oyaml    
echo "done"


# Get the external IP of the LoadBalancer service in the ingress-nginx namespace
EXTERNAL_IP=$(kubectl get svc -n ingress-nginx | grep LoadBalancer | awk '{print $4}')



# Print the URL for your Java application
echo "SpringBoot Application is accessible on: http://$EXTERNAL_IP/api/status"



# Print the URL for your NestJS application
echo "NestJS Application is accessible on: http://$EXTERNAL_IP/api/test"



# Print the URL for your Django application
echo "Django Application is accessible on: http://$EXTERNAL_IP/api/ping"
