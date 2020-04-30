---
title: Keptn Quality Gates install using only manifests (experimental)
description: Explains how to install Keptn Quality Gates on Kubernetes by applying manifests with kubectl
weight: 92
---

## Intro
In case you cannot use the [prepared installer](../../installation/setup-keptn/) because you e.g. need to exactly control
what is installed in your Kubernetes cluster,
you can follow the instructions below.

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup Keptn Quality Gates v0.6.1

1. Keptn namespace
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/keptn/namespace.yaml
```

1. NATS
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/nats/nats-operator-prereqs.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/nats/nats-operator-deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/nats/nats-cluster.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/keptn/rbac.yaml
```

1. Install Datastore
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/mongodb/pvc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/mongodb/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/mongodb/svc.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/mongodb-datastore/k8s/mongodb-datastore.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/logging/mongodb-datastore/mongodb-datastore-distributor.yaml
```

1. Create a Keptn API-token
```console
KEPTN_API_TOKEN=$(head -c 16 /dev/urandom | base64)
kubectl create secret generic -n keptn keptn-api-token --from-literal=keptn-api-token="$KEPTN_API_TOKEN"
```

1. Install Keptn Core
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/keptn/core.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/keptn/keptn-domain-configmap.yaml
```

1. Install Keptn Quality Gates
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/installer/manifests/keptn/quality-gates.yaml
```

## Access the Keptn API
1. In order to access the Keptn API you can either use a `LoadBalancer` or a `Port-forward`.

    <details><summary>Using a `LoadBalancer`</summary>
    <p>

      Expose the `api` by patching the service:
      ```console
      kubectl patch svc api -n keptn -p '{"spec": {"type": "LoadBalancer"}}'
      ```

      Query the IP:
      ```console
      export KEPTN_ENDPOINT=http://$(kubectl get svc api -n keptn -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
      ```
    
    </p>
    </details>


    <details><summary>Using a `Port-forward`</summary>
    <p>

      Make a port-forward with:
      ```console
      kubectl port-forward svc/api -n keptn 8080:80
      ```

      ```console
      export KEPTN_ENDPOINT=http://localhost:8080
      ```
    
    </p>
    </details>

## Use the Keptn CLI
For this installation, a **custom CLI** is needed which allows to use `http` as URL scheme.

1. Download the **custom** version for your operating system:

  - Linux [tgz](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-linux.tar.gz), [zip](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-linux.zip)

  - Mac [tgz](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-macOS.tar.gz), [zip](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-macOS.zip)

  - Windows [tgz](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-windows.tar.gz), [zip](https://storage.googleapis.com/keptn-cli/feature-1630-support-http-scheme/keptn-windows.zip)

1. Follow the remaining Keptn CLI install instructions as explained [here](../../installation/setup-keptn/#install-keptn-cli).

1. Authenticate your CLI
```
./keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN --scheme=http
```

**Important Note:** Please always add `--scheme=http` to **all** CLI commands. Otherwise, the CLI uses `https` which is not configured in this installation. 

**Important Note:** The Websocket communications cannot be used when the API is exposed via a `Port-forward`.
Hence, please add `--suppress-websocket` to **all** CLI commands.

## Setup Quality Gates for your Existing Services
Now you are able to continue with the use case as described [here](../../usecases/quality-gates).
