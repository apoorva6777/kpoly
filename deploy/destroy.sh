cd ..
cd scripts-ff
kubectl delete -f deployment-django.yaml
kubectl delete -f deployment-nestjs.yaml
kubectl delete -f deployment-spring.yaml
sleep 60
kubectl delete -f service-django.yaml
kubectl delete -f service-java.yaml
kubectl delete -f service-nest.yaml

sleep 20
kubectl delete -f ingress-django.yaml
kubectl delete -f ingress-java.yaml
kubectl delete -f ingress-nestjs.yaml

echo "ingress done"
sleep 30
kubectl delete -f horizontal-pod-autoscaler-django.yaml
kubectl delete -f horizontal-pod-autoscaler-java.yaml
kubectl delete -f horizontal-pod-autoscaler-nginx.yaml
kubectl delete -f horizontal-pod-autoscaler-ping.yaml
sleep 60
