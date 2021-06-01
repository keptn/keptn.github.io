#!/bin/bash
set -e

source <(curl -s https://raw.githubusercontent.com/keptn/keptn/0.8.3/test/utils.sh)

function print_headline() {
  HEADLINE=$1
  
  echo "---------------------------------------------------------------------"
  echo $HEADLINE
  echo "---------------------------------------------------------------------"
  echo ""
}

INGRESS_PORT=$1
INGRESS_IP=127.0.0.1

if [ -z "$INGRESS_PORT" ]; then
 	INGRESS_PORT=8082
fi

PROJECT="podtatohead"
SERVICE="helloservice"
IMAGE="ghcr.io/podtato-head/podtatoserver"
VERSION=v0.1.0

print_headline "Downloading demo resources"
echo "git clone https://github.com/cncf/podtato-head.git --single-branch"
git clone https://github.com/cncf/podtato-head.git --single-branch

cd podtato-head/delivery/keptn

print_headline "Create a Keptn project"
echo "keptn create project $PROJECT --shipyard=./shipyard.yaml"
keptn create project $PROJECT --shipyard=./shipyard.yaml
verify_test_step $? "keptn create project command failed."

print_headline "Onboard a Keptn service"
echo "keptn onboard service $SERVICE --project=$PROJECT --chart=./helm-charts/helloserver"
keptn onboard service $SERVICE --project="${PROJECT}" --chart=./helm-charts/helloserver
verify_test_step $? "keptn onboard carts failed."

# check which namespaces exist
echo "Verifying that the following namespaces are available:"

verify_namespace_exists "$PROJECT-hardening"
verify_namespace_exists "$PROJECT-production"

print_headline "Trigger the delivery sequence with Keptn"
echo "keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=v$VERSION"
keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=$VERSION
verify_test_step $? "Trigger delivery for helloservice failed"

echo "Following the multi stage delivery in Keptn's bridge while we are setting up Prometheus and configure quality gates"
echo "Find the details here: http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge/project/podtatohead/sequence"
echo "Opening bridge in 5 seconds..."
echo "Demo setup will continue in the background while you can explore the Keptn's bridge..."
sleep 5

if ! command -v open &> /dev/null
then
  echo http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge/project/podtatohead/sequence
else
  open http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge/project/podtatohead/sequence
fi

# lets wait a little bit until we are sure that helloservice has been deployed
wait_for_deployment_in_namespace $SERVICE "$PROJECT-hardening"
verify_test_step $? "Deployment $SERVICE  not available, exiting..."

# adding quality gates
print_headline "Installing Prometheus"
kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus --namespace monitoring --wait

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

print_headline "Setting up Prometheus integration"
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


# adding tests to the service
print_headline "Adding some load tests"
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
keptn add-resource --project=$PROJECT --stage=hardening --service=$SERVICE --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml

# check for prometheus to be available at this point
wait_for_deployment_in_namespace "prometheus-service" "keptn"
wait_for_deployment_in_namespace "prometheus-sli-service" "keptn"
wait_for_deployment_in_namespace "prometheus-server" "monitoring"

# triggering new delivery
print_headline "Trigger the new delivery sequence with Keptn"
keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=$VERSION
verify_test_step $? "Trigger delivery for helloservice failed"

echo "Have a look at the Keptn's Bridge and explore the demo project"
echo "You can run a new delivery sequence with the following command"
echo "keptn trigger delivery --project=$PROJECT --service=$SERVICE --image=$IMAGE --tag=$VERSION"

