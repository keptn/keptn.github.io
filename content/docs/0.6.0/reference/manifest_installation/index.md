---
title: Keptn Quality Gates Installation using manifests (experimental)
description: Install Keptn Quality Gates on Kubernetes by applying manifests with kubectl
weight: 35
---

The following installation instructions provide a way to manually install Keptn Quality Gates without any installer job. Furthermore, no NGINX will be installed using these instructions.

Following these manual installation instructions is not the recommended way to install Keptn.
But in case you cannot use the [prepared installer](../../installation/setup-keptn/) because you e.g. need to exactly control what is installed in your Kubernetes cluster, the instructions can be used.

**WARNING**:

* These instructions are experimental.
* No upgrade script or instructions are provided for a manual installation of Keptn.
* The keptn CLI command `keptn configure bridge` will not work with this setup.


## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup Keptn Quality Gates

1. Select the Keptn version 0.6.2:
```console
export KEPTNVERSION=0.6.2
```

1. Apply the Keptn namespace:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/namespace.yaml
```

1. Apply NATS resources:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/nats/nats-operator-prereqs.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/nats/nats-operator-deploy.yaml
```
Please give the nats operator a few seconds to start, before applying the next manifests:
```
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/nats/nats-cluster.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/rbac.yaml
```

1. Install the Keptn Datastore:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/mongodb/pvc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/mongodb/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/mongodb/svc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/mongodb-datastore/k8s/mongodb-datastore.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/logging/mongodb-datastore/mongodb-datastore-distributor.yaml
```

1. Create a Keptn API-token, as explained [here](../api_token/#create-api-token).



1. Install the Keptn Core:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/core.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/keptn-domain-configmap.yaml
```

1. Install Keptn API Gateway NGINX (Note: this has nothing to do with an ingress gateway):
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/api-gateway-nginx.yaml
```

1. Install Keptn Quality Gates (Control Plane):
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTNVERSION/installer/manifests/keptn/quality-gates.yaml
```

### Summary of applied images

By following the *DockerHub* link, you will find the built image on DockerHub. The referenced Dockerfile shows how the image was built. 

* Apply NATS resources:
  * `connecteverything/nats-operator:0.6.0` - [DockerHub](https://hub.docker.com/layers/connecteverything/nats-operator/0.6.0/images/sha256-f83368baa5092a632c2e941ee7ba8cb6f925d0a068996a0a47ef4047edf2f12b)

* Install the Keptn Datastore:
  * `centos/mongodb-36-centos7:1` - [DockerHub](https://hub.docker.com/r/centos/mongodb-36-centos7)
  * `keptn/mongodb-datastore:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/mongodb-datastore/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/mongodb-datastore/Dockerfile)]
  * `keptn/distributor:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/distributor/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/distributor/Dockerfile)]

* Install the Keptn Core:
  * `keptn/api:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/api/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/api/Dockerfile)]
  * `keptn/bridge2:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/bridge2/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/bridge/Dockerfile)]
  * `keptn/eventbroker-go:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/eventbroker-go/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/eventbroker/Dockerfile)]
  * `keptn/helm-service:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/helm-service/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/helm-service/Dockerfile)]
  * `keptn/distributor:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/distributor/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/distributor/Dockerfile)]
  * `keptn/shipyard-service:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/shipyard-service/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/shipyard-service/Dockerfile)]
  * `keptn/configuration-service:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/configuration-service/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/configuration-service/Dockerfile)]

* Install Keptn API Gateway NGINX:
  * `nginx:1.17.9` - [DockerHub](https://hub.docker.com/layers/nginx/library/nginx/1.17.9/images/sha256-39f53d91433cac929ec9caadf8719c6dc205c74129c90b76054bee43337996b5)

* Install Keptn Quality Gates:
  * `keptn/lighthouse-service:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/lighthouse-service/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/lighthouse-service/Dockerfile)]
  * `keptn/distributor:0.6.2` - [[DockerHub](https://hub.docker.com/r/keptn/distributor/tags?page=1&name=0.6.2), [Dockerfile](https://github.com/keptn/keptn/blob/0.6.2/distributor/Dockerfile)]

## Access the Keptn API
In order to access the Keptn API, you can use a `LoadBalancer` (if provided by your cloud platform), `NodePort` (if the Kubernetes nodes have appropriate firewall/forwarding rules), an Ingress Object (if you have an ingress controller installed), or as a last resort a `Port-forward`:

  <details><summary>Using Kubernetes service-type `LoadBalancer`</summary>
  <p>

  Expose the Keptn API via a LoadBalancer by patching the service `api-gateway-nginx`:
  ```console
  kubectl patch svc api-gateway-nginx -n keptn -p '{"spec": {"type": "LoadBalancer"}}'
  ```
  
  Please allow your cloud-provider a couple of seconds (up to 5 minutes) to assign you an IP address. Watch the process using
  ```console
  kubectl get svc api-gateway-nginx -n keptn -w
  ```

  Query the IP:
  ```console
  export KEPTN_ENDPOINT=http://$(kubectl get svc api-gateway-nginx -n keptn -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
  ```
  or the hostname (for EKS)
  ```console
  export KEPTN_ENDPOINT=http://$(kubectl get svc api-gateway-nginx -n keptn -ojsonpath='{.status.loadBalancer.ingress[0].hostname}')
  ```
  
  </p>
  </details>

  <details><summary>Using Kubernetes service-type `NodePort`</summary>
  <p>
  
  Please note: For this to work, you either need to be on the same Network as your Kubernetes VM (e.g., when using K3s, Minikube, ...), or in some cases (e.g., GKE) you have to set up certain firewall rules (which is beyond this documentation).

  Expose the Keptn API on the node by patching the service `api-gateway-nginx`:
  ```console
  kubectl patch svc api-gateway-nginx -n keptn -p '{"spec": {"type": "NodePort"}}'
  ```

  Get the Port of `api-gateway-nginx`:
  ```console
  API_PORT=$(kubectl get svc api-gateway-nginx -n keptn -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
  ```

  Get the internal and external ip of current kubernetes node
  ```console
  EXTERNAL_NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
  INTERNAL_NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
  ```

  Define Keptn API Endpoint (either via the internal or external IP; try both if unsure):
  ```console
  # either
  export KEPTN_ENDPOINT=http://${INTERNAL_NODE_IP}:${API_PORT}/
  # or
  export KEPTN_ENDPOINT=http://${EXTERNAL_NODE_IP}:${API_PORT}/
  ```
  
  </p>
  </details>
  
  <details><summary>Using a Kubernetes ingress object</summary>
  <p>
  
  **Please note**: The description here is very generic. Please refer to the [official docs about ingress controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) for more details.
  
  Here is a quick list of Ingress controllers that *should* work:
  
  * istio
  * nginx-ingress
  * traefik
  * cloud-provider specific ingress controllers
  
  Ensure you have an ingress-controller has an IP address (e.g., `5.6.7.8`) or domain that you can reach.
  
  Configure the `api-gateway-nginx` service to use `ClusterIP` (`NodePort` and `LoadBalancer` might work, but that's not the goal here):
  ```console
  kubectl patch svc api-gateway-nginx -n keptn -p '{"spec": {"type": "ClusterIP"}}'
  ```
  
  Create an ingress object for `api-gateway-nginx`, which might look similar to this (replace `api-keptn.5-6-7-8.nip.io` with your desired hostname and `INSERT_INGRESS_CLASS_HERE` with the ingress class you are using):
```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: INSERT_INGRESS_CLASS_HERE
  name: your-api-keptn-ingress
  namespace: keptn
spec:
  rules:
  - host: api-keptn.5-6-7-8.nip.io
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: 80
  - host: api.keptn
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: 80
```
  **Note**: The section with `host: api.keptn` is crucial and needs to be included for the keptn CLI 0.6.2 and before!
  
  To verify that creating an ingress object works, execute
  ```console
  kubectl describe ingress -n keptn
  ```
  The output should look like this:
```
Name:             your-api-keptn-ingress
Namespace:        keptn
Address:          5.6.7.8
Default backend:  default-http-backend:80 (10.16.0.8:8080)
TLS:
  keptn-api-tls terminates *.5-6-7-8.nip.io
Rules:
  Host                           Path  Backends
  ----                           ----  --------
  api-keptn.5-6-7-8.nip.io  
                                    api-gateway-nginx:80 (10.16.0.27:80)
  api.keptn                      
                                    api-gateway-nginx:80 (10.16.0.27:80)

```

  Verify that you can access the API in your Browser, e.g., by going to `http://api-keptn.5-6-7-8.nip.io/swagger-ui/` or if you enabled SSL/TLS even `https://api-keptn.5-6-7-8.nip.io/swagger-ui/`.

  Finally, store the hostname you used in the manifest:
  ```console
  export KEPTN_ENDPOINT=http://api-keptn.5-6-7-8.nip.io/
  ```
  
  </p>
  </details>


  <details><summary>Using OpenShift 3.11 built-in routes</summary>
  <p>
  
  OpenShift 3.11 ships built-in routing functionality, which allows exposing the API using

  ```console
  oc create route edge api --service=api-gateway-nginx --port=http --insecure-policy='None' -n keptn
  oc create route edge api.keptn --service=api-gateway-nginx --port=http --insecure-policy='None' -n keptn --hostname=api.keptn
  ```
  **Note**: The second route with `api.keptn` as a hostname is necessary for Keptn 0.6.x CLI to work.
  
  You can then get the hostname by inspecting the route using
  ```console
  oc get route -n keptn
  ```
  which should look like this:
  ```
  NAME        HOST/PORT                         PATH      SERVICES            PORT      TERMINATION   WILDCARD
  api         api-keptn.1.2.3.4.nip.io                    api-gateway-nginx   http      edge/None     None
  api.keptn   api.keptn                                   api-gateway-nginx   http      edge/None     None
  ```
 
  Set the hostname using
  ```console
  KEPTN_ENDPOINT=https://$(oc get route -n keptn api -ojsonpath='{.status.ingress[0].host}')  
  ``` 
  
  </p>
  </details>

  <details><summary>Using a `Port-forward`</summary>
  <p>

  Make a port-forward with:
  ```console
  kubectl port-forward svc/api-gateway-nginx -n keptn 8080:80
  ```

  ```console
  export KEPTN_ENDPOINT=http://localhost:8080
  ```
  
  </p>
  </details>

## Use the Keptn CLI

1. Follow the [Keptn CLI install instructions](../../installation/setup-keptn/#install-keptn-cli). 

    **Important:** The Keptn CLI in version 0.6.2 or above is required.

1. Authenticate your CLI

```
./keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN --scheme=http
```

**Please note:** Always add the flag `--scheme=http` to **all** CLI commands. Otherwise, the CLI uses `https` which is not configured in this installation. 

**Please note:** The WebSocket communications cannot be used when the API is exposed via a `Port-forward`. Hence, please add `--suppress-websocket` to **all** CLI commands.

## Setup Quality Gates for your existing services

Now, you are able to continue with the use case as described [here](../../usecases/quality-gates).
