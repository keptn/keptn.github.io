#!/bin/bash
set -e

INGRESS_IP=127.0.0.1
INGRESS_PORT=8082

PROJECT="podtatohead"
SERVICE="helloservice"
IMAGE="ghcr.io/podtato-head/podtatoserver"
VERSION=v0.1.0

echo "Downloading demo resources"
echo "git clone https://github.com/cncf/podtato-head.git --single-branch"
git clone https://github.com/cncf/podtato-head.git --single-branch

cd podtato-head/delivery/keptn

echo "Create a Keptn project"
echo "keptn create project $PROJECT --shipyard=./shipyard.yaml"
keptn create project $PROJECT --shipyard=./shipyard.yaml


echo "Onboard a Keptn service"
echo "keptn onboard service $SERVICE --project=$PROJECT --chart=./helm-charts/helloserver"
keptn onboard service $SERVICE --project="${PROJECT}" --chart=./helm-charts/helloserver

echo "Trigger the delivery sequence with Keptn"
echo "keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=v$VERSION"
keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=$VERSION

echo "Following the multi stage delivery in Keptn's bridge while we are setting up Prometheus and configure quality gates"
echo "Find the details here: http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge/project/podtatohead/sequence"
echo "Opening bridge in 5 seconds..."
echo "Demo setup will continue in the background while you can explore the Keptn's bridge..."
sleep 5
open http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge/project/podtatohead/sequence

## adding quality gates
echo "Installing Prometheus"
kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus --namespace monitoring

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: istio
  name: prometheus-ingress
  namespace: monitoring
spec:
  rules:
  - host: prometheus.$INGRESS_IP.nip.io
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: prometheus-server
            port:
              number: 80
EOF

echo "Setting up Prometheus integration"
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.5.0/deploy/role.yaml -n monitoring
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.5.0/deploy/service.yaml 

kubectl set env deployment/prometheus-service -n keptn --containers="prometheus-service" PROMETHEUS_NS="monitoring"
kubectl set env deployment/prometheus-service -n keptn --containers="prometheus-service" ALERT_MANAGER_NS="monitoring"

promsecretdata="url: http://prometheus-server.monitoring.svc.cluster.local:80"
echo "kubectl create secret generic -n keptn prometheus-credentials-$PROJECT --from-literal=prometheus-credentials=$promsecretdata"

kubectl create secret generic -n keptn prometheus-credentials-$PROJECT --from-literal=prometheus-credentials="$promsecretdata"



echo "Installing Prometheus SLI service"
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-sli-service/release-0.3.0/deploy/service.yaml


echo "Adding SLIs for Prometheus"
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=prometheus/sli.yaml --resourceUri=prometheus/sli.yaml
echo "Adding SLO definition file for the quality gate"
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=slo.yaml --resourceUri=slo.yaml

echo "Configuring Prometheus with Keptn"
keptn configure monitoring prometheus --project=$PROJECT --service=$SERVICE


## adding tests to the service
echo "Adding some load tests"
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml



keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=$VERSION
