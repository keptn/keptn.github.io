#!/bin/bash
set -e

keptn delete project podtatohead
rm -rf podtato-head
kubectl delete deploy -n keptn prometheus-service --ignore-not-found=true
kubectl delete deploy -n keptn prometheus-sli-service --ignore-not-found=true
kubectl delete secret -n keptn prometheus-credentials-podtatohead  --ignore-not-found=true
kubectl delete ns monitoring --ignore-not-found=true

