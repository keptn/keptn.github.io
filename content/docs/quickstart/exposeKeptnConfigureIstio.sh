#!/bin/bash
set -e

# istio settings
ISTIO_VERSION=1.10.0
INGRESS_IP=127.0.0.1
INGRESS_PORT=8082

# retries for opening the bridge
MAX_RETRIES=5
SLEEP_TIME=5


echo "Setup up Istio for Ingress and traffic shifting for blue/green deployments"
echo "curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

echo "Install Istio"
echo "./istio-$ISTIO_VERSION/bin/istioctl install -y"
./istio-$ISTIO_VERSION/bin/istioctl install -y

echo "Removing downloaded Istio resources"
rm -rf ./istio-$ISTIO_VERSION

echo "Configuring Ingress for your local installation"
if [ -z "$INGRESS_IP" ] || [ "$INGRESS_IP" = "Pending" ] ; then
 	echo "INGRESS_IP is empty. Make sure that the Ingress gateway is ready"
	exit 1
fi

# Applying ingress-manifest
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: istio
  name: api-keptn-ingress
  namespace: keptn
spec:
  rules:
  - host: $INGRESS_IP.nip.io
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: api-gateway-nginx
            port:
              number: 80
EOF

# Applying public gateway
kubectl apply -f - <<EOF
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: public-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      name: http
      number: 80
      protocol: HTTP
    hosts:
    - '*'
EOF

echo "Disabling authentication for Keptn's Bridge (since we are running locally)"
kubectl -n keptn delete secret bridge-credentials --ignore-not-found=true

echo "Restart Keptn's Bridge to load new settings"
kubectl -n keptn delete pods --selector=app.kubernetes.io/name=bridge --wait

# Creating Keptn ingress config map
echo "Creating Ingress config for Keptn"
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}') --from-literal=ingress_port=$INGRESS_PORT --from-literal=ingress_protocol=http --from-literal=istio_gateway=public-gateway.istio-system -oyaml --dry-run=client | kubectl apply -f -

# Restart helm service
echo "Restarting helm-service to load new settings"
kubectl delete pod -n keptn -lapp.kubernetes.io/name=helm-service

echo "Authenticating Keptn CLI against Keptn installation"
echo "keptn auth --endpoint=http://$INGRESS_IP.nip.io:$INGRESS_PORT --api-token=*****"
keptn auth --endpoint=http://$INGRESS_IP.nip.io:$INGRESS_PORT --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)


# Opening bridge
echo "Opening Keptn's Bridge..."
http_code=$(curl -LI http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge -o /dev/null -w '%{http_code}\n' -s)
retries=1

while [ $retries -le $MAX_RETRIES ];
do
  # echo "retries:  $retries / $MAX_RETRIES" 
  if [ ${http_code} -eq 200 ]; then
    echo "Trying to opening Keptn's bridge on http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge"
    open http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge
    break
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
  echo "Welcome aboard!"
  echo "Find the Keptn's Bridge at http://$INGRESS_IP.nip.io:$INGRESS_PORT/bridge "
  echo "Find the Keptn API at http://$INGRESS_IP.nip.io:$INGRESS_PORT/api "
fi



