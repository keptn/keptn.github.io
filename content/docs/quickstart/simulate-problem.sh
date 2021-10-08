#!/bin/bash
set -e

#source <(curl -s https://raw.githubusercontent.com/keptn/keptn/0.8.5/test/utils.sh)

function print_headline() {
  HEADLINE=$1
  
  echo ""
  echo "---------------------------------------------------------------------"
  echo $HEADLINE
  echo "---------------------------------------------------------------------"
  echo ""
}

# wait for a deployment to be up and running
function wait_for_deployment_in_namespace() {
  DEPLOYMENT=$1; NAMESPACE=$2;
  RETRY=0; RETRY_MAX=10;

  while [[ $RETRY -lt $RETRY_MAX ]]; do
    DEPLOYMENT_LIST=$(eval "kubectl get deployments -n ${NAMESPACE} | awk '/$DEPLOYMENT /'" | awk '{print $1}') # list of multiple deployments when starting with the same name
    if [[ -z "$DEPLOYMENT_LIST" ]]; then
      RETRY=$((RETRY+1))
      echo "Retry: ${RETRY}/${RETRY_MAX} - Deployment not found - waiting 5s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
      sleep 5
    else
      READY_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT" -n "$NAMESPACE" -o=jsonpath='{$.status.availableReplicas}')
      WANTED_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT"  -n "$NAMESPACE" -o=jsonpath='{$.spec.replicas}')
      UNAVAILABLE_REPLICAS=$(eval kubectl get deployments "$DEPLOYMENT"  -n "$NAMESPACE" -o=jsonpath='{$.status.unavailableReplicas}')
      if [[ "$READY_REPLICAS" = "$WANTED_REPLICAS" && "$UNAVAILABLE_REPLICAS" = "" ]]; then
        echo "Found deployment ${DEPLOYMENT} in namespace ${NAMESPACE}: ${DEPLOYMENT_LIST}"
        break
      else
          RETRY=$((RETRY+1))
          echo "Retry: ${RETRY}/${RETRY_MAX} - Unsufficient replicas for deployment - waiting 5s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
          sleep 5
      fi
    fi
  done

  if [[ $RETRY == "$RETRY_MAX" ]]; then
    print_error "Could not find deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
    exit 1
  fi
}

PROJECT="podtatohead"
SERVICE="helloservice"

print_headline "Preparation of Auto-remediation in Production"

echo "Adding SLIs for Prometheus"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/prometheus/sli.yaml --resourceUri=prometheus/sli.yaml
echo "Adding SLO definition file for the quality gate"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/slo.yaml --resourceUri=slo.yaml
echo "Adding Remediation Configuration"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/remediation.yaml --resourceUri=remediation.yaml

print_headline "Deploy Job Executor"

kubectl apply -f ./demo/job/job-executor.yaml
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=production --resource=./demo/job/config.yaml --resourceUri=job/config.yaml

wait_for_deployment_in_namespace "job-executor-service" "keptn"

print_headline "Simulate Alert (Problem)"
echo -e "{\"type\": \"sh.keptn.event.production.remediation.triggered\",\"specversion\":\"1.0\",\"source\":\"https:\/\/github.com\/keptn\/keptn\/prometheus-service\",\"id\": \"f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d\",  \"time\": \"2019-06-07T07:02:15.64489Z\",  \"contenttype\": \"application\/json\", \"data\": {\"project\": \"podtatohead\",\"stage\": \"production\",\"service\": \"helloservice\",\"problem\": { \"problemTitle\": \"out_of_memory\",\"rootCause\": \"Response time degradation\"}}}" > remediation_trigger.json | keptn send event -f remediation_trigger.json

print_headline "Have a look at the Keptn Bridge and explore the demo project"

echo "You can run a new remediation sequence with the following command"
echo "keptn send event -f remediation_trigger.json"


