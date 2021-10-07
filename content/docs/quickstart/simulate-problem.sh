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

PROJECT="podtatohead"
SERVICE="helloservice"

print_headline "Preparation of Auto-remediation in Production"

echo "Adding SLIs for Prometheus"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/prometheus/sli.yaml --resourceUri=prometheus/sli.yaml
echo "Adding SLO definition file for the quality gate"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/slo.yaml --resourceUri=slo.yaml
echo "Adding Remediation Configuration"
keptn add-resource --project=$PROJECT --stage=production --service=$SERVICE --resource=./demo/remediation.yaml --resourceUri=remediation.yaml

print_headline "Disable Helm-service"
kubectl scale deployment/helm-service -n keptn --replicas=0

print_headline "Deploy Job Executor"

#kubectl apply -f https://raw.githubusercontent.com/keptn-sandbox/job-executor-service/0.1.4/deploy/service.yaml -n keptn
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=production --resource=./demo/job/config.yaml --resourceUri=job/config.yaml

print_headline "Simulate Alert (Problem)"
echo -e "{\"type\": \"sh.keptn.event.production.remediation.triggered\",\"specversion\":\"1.0\",\"source\":\"https:\/\/github.com\/keptn\/keptn\/prometheus-service\",\"id\": \"f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d\",  \"time\": \"2019-06-07T07:02:15.64489Z\",  \"contenttype\": \"application\/json\", \"data\": {\"project\": \"podtatohead\",\"stage\": \"production\",\"service\": \"helloservice\",\"problem\": { \"problemTitle\": \"response_time_p90\",\"rootCause\": \"Response time degradation\"}}}" > remediation_trigger.json | keptn send event -f remediation_trigger.json

print_headline "Have a look at the Keptn Bridge and explore the demo project"

echo "You can run a new remediation sequence with the following command"
echo "keptn send event -f remediation_trigger.json"


