#!/bin/bash
set -e

#source <(curl -s https://raw.githubusercontent.com/keptn/keptn/0.8.3/test/utils.sh)

function print_headline() {
  HEADLINE=$1
  
  echo ""
  echo "---------------------------------------------------------------------"
  echo $HEADLINE
  echo "---------------------------------------------------------------------"
  echo ""
}

function print_error() {
  echo "::error file=${BASH_SOURCE[1]##*/},line=${BASH_LINENO[0]}::$(timestamp) ${*}"
}

function verify_test_step() {
  if [[ $1 != '0' ]]; then
    print_error "$2"
    print_error "Keptn test step failed"
    exit 1
  fi
}

# wait for a deployment to be up and running
function wait_for_deployment_in_namespace() {
  DEPLOYMENT=$1; NAMESPACE=$2;
  RETRY=0; RETRY_MAX=20;

  while [[ $RETRY -lt $RETRY_MAX ]]; do
    DEPLOYMENT_LIST=$(eval "kubectl get deployments -n ${NAMESPACE} | awk '/$DEPLOYMENT /'" | awk '{print $1}') # list of multiple deployments when starting with the same name
    if [[ -z "$DEPLOYMENT_LIST" ]]; then
      RETRY=$((RETRY+1))
      echo "Retry: ${RETRY}/${RETRY_MAX} - Deployment not found - waiting 15s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
      sleep 15
    else
      READY_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{$.status.availableReplicas}')
      WANTED_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT"  -n "$NAMESPACE" -o=jsonpath='{$.spec.replicas}')
      UNAVAILABLE_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT"  -n "$NAMESPACE" -o=jsonpath='{$.status.unavailableReplicas}')
      if [[ "$READY_REPLICAS" = "$WANTED_REPLICAS" && "$UNAVAILABLE_REPLICAS" = "" ]]; then
        echo "Found deployment ${DEPLOYMENT} in namespace ${NAMESPACE}: ${DEPLOYMENT_LIST}"
        break
      else
          RETRY=$((RETRY+1))
          echo "Retry: ${RETRY}/${RETRY_MAX} - Unsufficient replicas for deployment - waiting 15s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
          sleep 15
      fi
    fi
  done

  if [[ $RETRY == "$RETRY_MAX" ]]; then
    print_error "Could not find deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
    exit 1
  fi
}

# ingress settings
INGRESS_PORT=$2
INGRESS_IP=127.0.0.1

if [ -z "$INGRESS_PORT" ]; then
 	INGRESS_PORT=8082
fi

# retries for opening the bridge
MAX_RETRIES=5
SLEEP_TIME=5


print_headline "Configuring Ingress for your local installation"

# Applying ingress-manifest
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-keptn-ingress
  namespace: keptn
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-gateway-nginx
            port:
              number: 80
EOF

verify_test_step $? "Applying public gateway failed"


# Disable Bridge authentication (running on localhost)
print_headline "Disabling authentication for Keptn's Bridge (since we are running locally)"
kubectl -n keptn delete secret bridge-credentials --ignore-not-found=true

echo "Restart Keptn's Bridge to load new settings"
kubectl -n keptn delete pods --selector=app.kubernetes.io/name=bridge --wait

# Authenticating Keptn CLI against the current Keptn installation
print_headline "Authenticating Keptn CLI against Keptn installation"
echo "keptn auth --endpoint=http://$INGRESS_IP.nip.io:$INGRESS_PORT --api-token=*****"
keptn auth --endpoint=http://$INGRESS_IP.nip.io:$INGRESS_PORT --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)

wait_for_deployment_in_namespace "bridge" "keptn"

# Opening bridge
print_headline "Opening Keptn's Bridge..."
http_code=$(curl -LI http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge -o /dev/null -w '%{http_code}\n' -s)
retries=1

while [ $retries -le $MAX_RETRIES ];
do
  # echo "retries:  $retries / $MAX_RETRIES" 
  if [ ${http_code} -eq 200 ]; then
    echo "Attempting to open Keptn's bridge on http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge"
    if ! command -v open &> /dev/null
    then
      echo "Open command not found. Printing connection details instead"
      break
    else
      open http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge
      break
    fi
  fi
  echo "Keptn's bridge not yet available, waiting $SLEEP_TIME seconds and then trying again"
  retries=$[$retries +1]
  sleep $SLEEP_TIME
  http_code=$(curl -LI http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge -o /dev/null -w '%{http_code}\n' -s)
done

if [ $retries -ge $MAX_RETRIES ]; then
  echo "Bridge not yet available at http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge"
  echo "Please check the log for any errors that might have happened."
else
  print_headline "Welcome aboard!"
  echo "Find the Keptn's Bridge at http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge "
  echo "Find the Keptn API at http://$INGRESS_IP.nip.io:$INGRESS_PORT/api "
  echo "For more information please visit https://keptn.sh "
  echo ""
fi
