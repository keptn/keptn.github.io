---
title: Keptn Quality Gates Installation using manifests (experimental)
description: Explains how to install Keptn Quality Gates on Kubernetes by applying manifests with kubectl
weight: 92
---

## Introduction
The following installation instructions provide a way to manually install Keptn Quality Gates without any installer job.
Furthermore, no NGINX will be installed using these instructions.

Following these manual installation instructions is not the recommended way to install Keptn.
But in case you cannot use the [prepared installer](../../installation/setup-keptn/) because you e.g. need to exactly control
what is installed in your Kubernetes cluster, the instructions can be used.

**Important note:** These instructions are experimental.

**Important note:** No upgrade script or instructions are provided for a manual installation of Keptn.

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup Keptn Quality Gates

1. Select the Keptn version 0.6.2:
```console
export KEPTN-VERSION=0.6.2
```

1. Apply the Keptn namespace:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/keptn/namespace.yaml
```

1. Apply NATS resources:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/nats/nats-operator-prereqs.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/nats/nats-operator-deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/nats/nats-cluster.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/keptn/rbac.yaml
```

1. Install the Keptn Datastore:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/mongodb/pvc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/mongodb/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/mongodb/svc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/mongodb-datastore/k8s/mongodb-datastore.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/logging/mongodb-datastore/mongodb-datastore-distributor.yaml
```

1. Create a Keptn API-token:
```console
KEPTN_API_TOKEN=$(head -c 16 /dev/urandom | base64)
kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
```

1. Install the Keptn Core:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/keptn/core.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/keptn/keptn-domain-configmap.yaml
```

1. Install Keptn Quality Gates:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/$KEPTN-VERSION/installer/manifests/keptn/quality-gates.yaml
```

## Access the Keptn API
In order to access the Keptn API you can either use a `LoadBalancer` or a `Port-forward`.

  <details><summary>Using a `LoadBalancer`</summary>
  <p>

  Expose the Keptn API by patching the service `api-gateway-nginx` :
  ```console
  kubectl patch svc api-gateway-nginx -n keptn -p '{"spec": {"type": "LoadBalancer"}}'
  ```

  Query the IP 
  ```console
  export KEPTN_ENDPOINT=http://$(kubectl get svc api-gateway-nginx -n keptn -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
  ```
  or the hostname (for EKS)
  ```console
  export KEPTN_ENDPOINT=http://$(kubectl get svc api-gateway-nginx -n keptn -ojsonpath='{.status.loadBalancer.ingress[0].hostname}')
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

**Important Note:** Always add the flag `--scheme=http` to **all** CLI commands. Otherwise, the CLI uses `https` which is not configured in this installation. 

**Important Note:** The Websocket communications cannot be used when the API is exposed via a `Port-forward`.
Hence, please add `--suppress-websocket` to **all** CLI commands.

## Setup Quality Gates for your Existing Services
Now you are able to continue with the use case as described [here](../../usecases/quality-gates).
