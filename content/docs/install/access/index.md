---
title: Choose access options
description: Choose the method to use to access Keptn
weight: 30
---
 
## Access options

Before installing Keptn on your cluster, please also consider how you would like to access Keptn.
Kubernetes provides the following four options:

* Option 1: Expose Keptn via an **LoadBalancer**
* Option 2: Expose Keptn via a **NodePort**
* Option 3: Expose Keptn via a **Ingress**
* Option 4: Access Keptn via a **Port-forward**

An overview of the four options is provided in the graphic below and the respective steps of all options are described below.

{{< popup_image
link="./assets/installation_options.png"
caption="Installation options"
width="1000px">}}

### Option 1: Expose Keptn via a LoadBalancer
This option exposes Keptn externally using a cloud provider's load balancer (if available).

1. **Install Keptn:** For installing Keptn on your cluster, please use the Helm CLI.
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
  ```console
   helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuousDelivery.enabled=true,apiGatewayNginx.type=LoadBalancer
  ```

1. **Get Keptn endpoint:**  Get the EXTERNAL-IP of the `api-gateway-nginx` using the command below. The Keptn API endpoint is: `http://<ENDPOINT_OF_API_GATEWAY>/api`
  ```console
  kubectl -n keptn get service api-gateway-nginx
  ```
  ```console
  NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
  api-gateway-nginx   ClusterIP   10.117.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
  ```

    *Optional:* Store Keptn API endpoint in an environment variable.

    For Linux and Mac:
    ```console
    KEPTN_ENDPOINT=http://<ENDPOINT_OF_API_GATEWAY>/api
    ```

    For Windows:
    ```console
    $Env:KEPTN_ENDPOINT = 'http://<ENDPOINT_OF_API_GATEWAY>/api'
    ```

:warning: **Warning:** If you do not set up TLS encryption, all your traffic to and from the Keptn endpoint is not encrypted.

### Option 2: Expose Keptn via a NodePort
This option exposes Keptn on each Kubernetes Node's IP at a static port. Therefore, please make sure that you can access the Kubernetes Nodes in your network.

1. **Install Keptn:** For installing Keptn on your cluster, please use the Keptn CLI.
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
  ```console
  helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuousDelivery.enabled=true,apiGatewayNginx.type=NodePort
  ```

1. **Get Keptn endpoint:** Get the mapped port of the `api-gateway-nginx` using the command below.

    ```console
    API_PORT=$(kubectl get svc api-gateway-nginx -n keptn -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
    ```
    Next, get the internal or external IP address of any Kubernetes node:

    ```console
    EXTERNAL_NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
    INTERNAL_NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
    ```

    The Keptn API endpoint (either via the internal or external IP; try both if unsure) is: `http://${INTERNAL_NODE_IP}:${API_PORT}/api` or `http://${EXTERNAL_NODE_IP}:${API_PORT}/api`

    *Optional:* Store Keptn API endpoint in an environment variable.

    For Linux and Mac:
    ```console
    KEPTN_ENDPOINT=http://${EXTERNAL_NODE_IP}:${API_PORT}/api
    ```

    For Windows:
    ```console
    $Env:KEPTN_ENDPOINT = 'http://${EXTERNAL_NODE_IP}:${API_PORT}/api'
    ```

:warning: **Warning:** If you do not set up TLS encryption, all your traffic to and from the Keptn endpoint is not encrypted.

### Option 3: Expose Keptn via an Ingress

1. **Install Keptn:** For installing Keptn on your cluster, please use the Keptn CLI.
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
  ```console
  helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuousDelivery.enabled=true
  ```

1. **Install an Ingress-Controller and create an Ingress:**
  Please first install your favorite Ingress-Controller and then apply an Ingress object in the `keptn` namespace, 
  which points to the service `api-gateway-nginx` on port 80. Note that the [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) allows to setup TLS encryption. **Note**: Using Openshift 3.11 requires to use a configuration for this platform.

    Commonly used Ingress controllers are Istio and NGINX:

    <details><summary>**Istio 1.8+** (recommended for use-case continuous delivery)</summary>
    <p>

    * Istio provides an Ingress Controller. To install Istio, please refer to the [official documentation](https://istio.io/latest/docs/setup/install/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n istio-system get svc istio-ingressgateway
      ```

    * Create an `ingress-manifest.yaml` manifest for an Ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example below, `nip.io` is used as wildcard DNS for the IP address.)

      ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      annotations:
        kubernetes.io/ingress.class: istio
      name: api-keptn-ingress
      namespace: keptn
    spec:
      rules:
      - host: <IP-ADDRESS>.nip.io
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-gateway-nginx
                port:
                  number: 80
      ```

      ```console
    kubectl apply -f ingress-manifest.yaml
      ```

    </p>
    </details>

    <details><summary>**Istio 1.8+ on OpenShift 3.11**</summary>
    <p>

    * Istio provides an Ingress Controller. To install Istio, please refer to the [official documentation](https://istio.io/latest/docs/setup/install/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n istio-system get svc istio-ingressgateway
      ```

    * Create an `ingress-manifest.yaml` manifest for an Ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example below, `nip.io` is used as wildcard DNS for the IP address.)

      ```yaml
    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      annotations:
        kubernetes.io/ingress.class: istio
      name: api-keptn-ingress
      namespace: keptn
    spec:
      rules:
      - host: <IP-ADDRESS>.nip.io
        http:
          paths:
          - backend:
              serviceName: api-gateway-nginx
              servicePort: 80
      ```

      ```console
    kubectl apply -f ingress-manifest.yaml
      ```

    </p>
    </details>

    <details><summary>**NGNIX Ingress**</summary>
    <p>

    * To install an NGINX Ingress Controller, please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n ingress-nginx get svc ingress-nginx
      ```

    * Create an `ingress-manifest.yaml` manifest for an ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example below, `nip.io` is used as wildcard DNS for the IP address.)

      ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      annotations:
        kubernetes.io/ingress.class: nginx
      name: api-keptn-ingress
      namespace: keptn
    spec:
      rules:
      - host: <IP-ADDRESS>.nip.io
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-gateway-nginx
                port:
                  number: 80
      ```

      ```console
    kubectl apply -f ingress-manifest.yaml
      ```

    </p>
    </details>

    <details><summary>**NGNIX Ingress on Openshift 3.11**</summary>
    <p>

    * To install an NGINX Ingress Controller, please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n ingress-nginx get svc ingress-nginx
      ```

    * Create an `ingress-manifest.yaml` manifest for an ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example below, `nip.io` is used as wildcard DNS for the IP address.)

      ```yaml
    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      annotations:
        kubernetes.io/ingress.class: nginx
      name: api-keptn-ingress
      namespace: keptn
    spec:
      rules:
      - host: <IP-ADDRESS>.nip.io
        http:
          paths:
          - backend:
              serviceName: api-gateway-nginx
              servicePort: 80
      ```

      ```console
    kubectl apply -f ingress-manifest.yaml
      ```

    </p>
    </details>

2. **Get Keptn endpoint:** Get the HOST of the `api-keptn-ingress` using the command below. The Keptn API endpoint is: `http://<HOST>/api`

    ```console
  kubectl -n keptn get ingress api-keptn-ingress
    ```

    ```console
  NAME                HOSTS                  ADDRESS         PORTS   AGE
  api-keptn-ingress   <HOST>                 x.x.x.x   80      48m
    ```

    *Optional:* Store Keptn API endpoint in an environment variable.

    For Linux and Mac:
    ```console
    KEPTN_ENDPOINT=http://<HOST>/api
    ```

    For Windows:
    ```console
    $Env:KEPTN_ENDPOINT = 'http://<HOST>/api'
    ```

:warning: **Warning:** If you do not set up TLS encryption, all your traffic to and from the Keptn endpoint is not encrypted.

### Option 4: Access Keptn via a Port-forward
This option does not expose Keptn to the public but exposes Keptn on a *cluster-internal* IP.

1. **Install Keptn:** For installing Keptn on your cluster, please use the Keptn CLI.
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
  ```console
  helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuousDelivery.enabled=true
  ```

1. **Setup a Port-Forward:** Configure the port-forward by using the command below.
  ```console
  kubectl -n keptn port-forward service/api-gateway-nginx 8080:80
  ```
  <details><summary>To listen on any local address</summary>
  <p>
  By default, `kubectl port-forward` binds to `127.0.0.1`. If you want to listen on any local address, add `--address 0.0.0.0`:
    
    ```console
    kubectl -n keptn port-forward service/api-gateway-nginx 8080:80 --address 0.0.0.0
    ```
  </p>
  </details>

1. **Get Keptn endpoint:** 
  The Keptn API endpoint is: `http://localhost:8080/api`

    *Optional:* Store Keptn API endpoint in an environment variable:
    ```console
    KEPTN_ENDPOINT=http://localhost:8080/api
    ```

## Change how to expose Keptn

If you would like to change the way of exposing Keptn,
you can do this by [re-installing Keptn](../helm-install)
and selecting the desired configuration.
When the CLI asks you if you would like to overwrite the installation, confirm this with yes.
This retains ell your data, including the Git repos and events.

