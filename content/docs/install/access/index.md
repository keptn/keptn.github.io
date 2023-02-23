---
title: Access options and Installation of Keptn using Helm chart
description: Choose the method to use to access Keptn and install Keptn on a single cluster using the Helm chart
weight: 30
aliases:
  - /docs/0.19.x/api/git_provisioning
  - /docs/0.17.0/operate/install
  - /docs/0.17.1/operate/install
  - /docs/0.18.0/operate/install
  - /docs/0.18.1/operate/install
  - /docs/0.18.2/operate/install
  - /docs/0.19.0/operate/install
  - /docs/0.19.1/operate/install
  - /docs/0.19.2/operate/install
  - /docs/0.19.3/operate/install
  - /docs/0.19.x/operate/install/
  - /docs/0.19.x/operate/advanced_install_options/
  - /docs/1.0.0/operate/install
  - /docs/1.0.x/operate/install/
  - /docs/1.0.x/operate/advanced_install_options/
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


## Add Keptn repo
The following command will help you in adding Helm chart repository of Keptn in your local system after which you will be able to access and install keptn in your system.

```
helm repo add keptn https://charts.keptn.sh
```

### Option 1: Expose Keptn via a LoadBalancer
This option exposes Keptn externally using a cloud provider's load balancer (if available).

1. **Install Keptn:** Use the Helm CLI to install Keptn on your cluster.
If you want to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
  ```console
   helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=continuousDelivery.enabled=true,apiGatewayNginx.type=LoadBalancer
  ```

1. **Get Keptn endpoint:**  Get the EXTERNAL-IP of the `api-gateway-nginx` using the command below. The Keptn API endpoint is: `http://<ENDPOINT_OF_API_GATEWAY>/api`
  ```console
  kubectl -n keptn get service api-gateway-nginx
  ```
  ```console
  NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
  api-gateway-nginx   LoadBalancer   10.117.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
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

1. **Install Keptn:** Use the Keptn CLI to install Keptn on your cluster.
If you want to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
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

1. **Install Keptn:** Use the Keptn CLI to install Keptn on your cluster.
If you want to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
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

    <details><summary>**NGINX Ingress**</summary>
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

    <details><summary>**NGINX Ingress on Openshift 3.11**</summary>
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

1. **Install Keptn:** Use the Keptn CLI to install Keptn on your cluster.
If you want to install the execution plane for continuous delivery, add the flag `continuousDelivery.enabled=true`.
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

## Install Keptn using the Helm chart

Keptn is installed from a Helm chart using the Helm CLI.
You must install the [Helm CLI](https://helm.sh)
before attempting to install Keptn.

You should also install the [Keptn CLI](../cli-install/)
before installing Keptn although this is optional.
It is possible to do most of what you need to do on modern releases of Keptn without the Keptn CLI
but the CLI provides additional functionality that is useful
such as uploading [SLI and SLO](../../concepts/quality_gates/#what-is-a-service-level-indicator-sli) definitions..
If you install the Keptn CLI,
you must [authenticate](../authenticate-cli-bridge/#authenticate-keptn-cli)
it to Keptn after you install Keptn. 

Keptn consists of a **Control Plane** and an **Execution Plane**.

* The **Control Plane** is the minimum set of components that are required
  to run a Keptn instance and to manage projects, stages, and services;
  to handle events; and to provide integration points.
  The control plane orchestrates the task sequences defined in Shipyard
  but does not actively execute the tasks.
  The Keptn Control Plane can run with no Execution Plane configured.

  The Control Plane can implement the [Quality Gates](../../concepts/quality_gates/)
  and [Automated Operations](../../concepts/automated_operations/) features
  but does not run microservices that integrate other tools with Keptn.

* The **Execution Plane** refers to the microservices that integrate other tools with Keptn;
  see [Keptn and other tools](../../concepts/keptn-tools/).
  For example, the JMeter test tool 
  and the [Job Executor Service](https://artifacthub.io/packages/keptn/keptn-integrations/job-executor-service)
  execute on the Execution Plane.

See [Architecture](../../concepts/architecture/) for more information
about the Control Plane and the Execution Plane.

You have the following installation options:

* Both the Keptn Control Plane and the Execution Plane
can be installed on an existing Kubernetes cluster that hosts other software
or on a dedicated Keptn Kubernetes cluster.
* The Control Plane and Execution Plane can also be installed on separate Kubernetes clusters;
see [Multi-cluster setup](../multi-cluster/) for instructions.
* In a multi-cluster setup, one Keptn Control Plane can support multiple Execution Planes
that are installed on different clusters.

## Install Control Plane

To install the Control Plane, you must do the following:

* Define the Keptn chart repository
* Install Keptn into the `keptn` namespace on the Kubernetes cluster
* Expose the [API gateway](../../concepts/architecture/#api-gateway-nginx) service
  that controls how Keptn communicates with the internet.
  See [Choose access option](../access/) for details about all the options
  that are available and how to install and use them.
  You can also do this after installation.
* You may also want to modify the Keptn configuration options.
  This is discussed more below.

### Simple Keptn installation

The following commands provide a basic Keptn installation.
This set of commands is useful for creating a basic Keptn installation
to use for study or demonstration.
It is not adequate for a production Keptn installation.

Watch a video demonstration of this simple installation
[here](https://www.youtube.com/watch?v=neAqh4fAz-k).

The following command sequence installs the Keptn control plane
and exposes it using port-forwarding:

```
helm repo add keptn https://charts.keptn.sh
helm install keptn keptn/keptn -n keptn --create-namespace
kubectl -n keptn port-forward svc/api-gateway-nginx 8080:80
```
We use **kubectl** to forward port `8080` from our local machine
to port `80` on the Keptn API Gateway service in the cluster.

### Full Keptn installation

  This section gives some sample commands
  that are appropriate for installing a fully-functional production Keptn instance.
  They use the following options:

  * `--version 0.19.3` -- Keptn release to be installed.
     If you do not specify the release, Helm uses the latest release.

   * `--repo=https://charts.keptn.sh` -- the location of the Helm chart.
     You can use this option rather than running the `helm repo add` command as shown above).
   * `apiGatewayNginx.type=<access-option>` -- this is necessary to access
     Keptn.
     `<access-option>` must be `LoadBalancer`, `NodePort`, or `ClusterIP`.
     See [Choose access options](../access/) for details.
   * `--create-namespace` -- creates the `keptn` namespace if it does not already exist.

**Use a LoadBalancer for api-gateway-nginx**

  ```
  helm upgrade keptn keptn --install -n keptn --create-namespace --wait \
    --version=0.19.3 --repo=https://charts.keptn.sh \
    --set=apiGatewayNginx.type=LoadBalancer
  ```

**Install Keptn with an Ingress object**

  If you are already using an [Ingress Controller](../access/#option-3-expose-keptn-via-an-ingress)
  and want to create an ingress object for Keptn,
  you can leverage the `ingress` section of the Helm chart.

  The Helm chart allows customizing the ingress object to your needs.
  When `ingress.enabled` is set to `true` (by default, `enabled` is set to `false`),
  the chart allows you to specify optional parameters
  of `host`, `path`, `pathType`, `tls`, and `annotations`.
  This supports many different Ingress-Controllers and configurations.

  ```
  helm upgrade keptn keptn --install -n keptn --create-namespace
  --set=ingress.enabled=true,
       ingress.annotations=<YOUR_ANNOTATIONS>,
       ingress.host=<YOUR_HOST>,
       ingress.path=<YOUR_PATH>,
       ingress.pathType=<YOUR_PATH_TYPE>,  
       ingress.tls=<YOUR_TLS>
  ```

### Confirm Installation

After you issue the **helm install** command,
it takes a couple of minutes for the installation to finish.
Use the following command to watch the progress:

```
kubectl -n keptn get pods
```

Wait until all the pods in the Keptn namespace are in `Running` state.
before proceeding.

Use the following command to view all the services that are installed in the Keptn namespace:

```
kubectl -n keptn get services
```
[Troubleshooting the Installation](../troubleshooting/)
has information that may help if your installation was not successful.

### Access the Keptn Bridge

The [Keptn Bridge](../../0.19.x/bridge/) is the graphical user interface
you can use to manage and view Keptn projects running in your instance.
To access it:

1. Expose the API Gateway NGINX.  This can be done in either of two ways:

   * Set the `apiGatewayNginx` parameter during installation
   * Issue the following command after installation:
     ```
     kubectl -n keptn port-forward svc/api-gateway-nginx 8080:80
     ```
2. Open a browser window to `localhost:8080`

3. Log into the Keptn Bridge.
   The following commands give you the username and randomly-generated password
   to use if your site uses [Basic Authentication](../../0.19.x/bridge/basic_authentication/):

   ```
   kubectl -n keptn get secret bridge-credentials -o jsonpath-{.data.BASIC_AUTH_USERNAME} | base64 -d
   kubectl -n keptn get secret bridge-credentials -o jsonpath-{.data.BASIC_AUTH_PASSWORD} | base64 -d
   ```
   You can also use [OpenID Authentication](../../0.19.x/bridge/oauth/) to access the Keptn Bridge.

## Install Execution Plane

To install the Execution Plane in the same namespace as the Control Plane,
install a microservice.
For example, the following two commands install the Jmeter and Helm-service microservices:

```
helm install jmeter-service https://github.com/keptn-contrib/jmeter-service/releases/download/0.18.1/jmeter-service-0.18.1.tgz  \
  -n keptn --create-namespace --wait

helm install helm-service https://github.com/keptn-contrib/helm-service/releases/download/0.18.1/helm-service-0.18.1.tgz \
  -n keptn --create-namespace --wait
```

The Execution Plane (or multiple Execution Planes) can also be installed on different Kubernetes clusters.
See [Multi-cluster setup](../multi-cluster/) for details.

## The --set flag

The `helm install` and `helm upgrade` commands offer a flag called `--set`,
which can be used to specify several configuration options using the format `key1=value1,key2=value2,...`.
The full list of available flags can be found
in the [helm-charts](https://github.com/keptn/keptn/tree/master/installer/manifests/keptn).


* The **Control Plane with the Execution Plane** and a `LoadBalancer` for exposing Keptn can be installed by the following command:
```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.19.3 --repo=https://charts.keptn.sh --set=apiGatewayNginx.type=LoadBalancer
```

## Install Keptn using a user-provided API token

You can provide your own API token for Keptn to use by setting the secret name
in the `apiService.tokenSecretName` Helm value during installation.
For Helm-Service and JMeter-Service,
you can also provide the API token by using the `remoteControlPlane.tokenSecretName` Helm value.

The user-provided secret needs to live in the same namespace where Keptn will be installed.
The user-provided secret should contain a single key `keptn-api-token`
with a token consisting of numbers and letters as its value.

## Execute Helm upgrade without Internet connectivity

The following section contains instructions for installing Keptn in an air-gapped / offline installation scenario.

The following artifacts must be available locally:

* Keptn Helm Chart (control-plane + helm + jmeter)
* Several Docker Images (e.g., pushed into a private registry)
* Helper scripts
* Keptn CLI (optional, but recommended for future use)

**Download Keptn Helm Charts**

Download the Helm charts from the [Keptn 0.19.x release](https://github.com/keptn/keptn/releases/tag/0.19.3):

* Keptn Control Plane: https://github.com/keptn/keptn/releases/download/0.19.3/keptn-0.19.3.tgz
* helm-service (if needed): https://github.com/keptn-contrib/helm-service/releases/download/0.18.1/helm-service-0.18.1.tgz
* jmeter-service (if needed): https://github.com/keptn-contrib/jmeter-service/releases/download/0.18.1/jmeter-service-0.18.1.tgz

Move the Helm Charts to a directory on your local machine, e.g., `offline-keptn`.

For convenience, the following script creates this directory and downloads the required Helm Charts into it:

```
mkdir offline-keptn
cd offline-keptn
curl -L https://github.com/keptn/keptn/releases/download/0.19.3/keptn-0.19.3.tgz -o keptn-0.19.3.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.19.3/helm-service-0.19.3.tgz -o helm-service-0.19.3.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.19.3/jmeter-service-0.19.3.tgz -o jmeter-service-0.19.3.tgz
cd ..
```

**Download Containers/Images**

Within the Helm Charts several Docker Images are referenced (Keptn specific and some third party dependencies).
We recommend pulling, re-tagging and pushing those images to a local registry that the Kubernetes cluster can reach.

A helper script is provided for this in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/pull_and_retag_images.sh

For convenience, you can use the following commands to download and execute the script:

```
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.19.3/installer/airgapped/pull_and_retag_images.sh -o pull_and_retag_images.sh
chmod +x pull_and_retag_images.sh
KEPTN_TAG=0.19.3 ./pull_and_retag_images.sh "your-registry.localhost:5000/"
cd ..
```

Be sure to include the trailing slash for the registry url (e.g., `your-registry.localhost:5000/`).

**Installation**

Keptn's Helm chart allows you to specify the name of all images, which can be especially handy in air-gapped systems where you cannot access DockerHub for pulling the images.

A helper script for this is provided in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/install_keptn.sh

For convenience, you can use the following commands to download and execute the script:

```
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.19.3/installer/airgapped/install_keptn.sh -o install_keptn.sh
chmod +x install_keptn.sh
./install_keptn.sh "your-registry.localhost:5000/" keptn-0.19.3.tgz helm-service-0.19.3.tgz jmeter-service-0.19.3.tgz
cd ..
```

## Install Keptn using a Root-Context

The Helm Chart allows customizing the root-context for the Keptn API and Bridge.
By default, the Keptn API is located under `http://HOSTNAME/api` and the Keptn Bridge is located under `http://HOSTNAME/bridge`.
By specifying a value for `prefixPath`, the prefix used for the root-context can be configured.
For example, if a user sets `prefixPath=/mykeptn` in the Helm install/upgrade command,
the Keptn API is located under `http://HOSTNAME/mykeptn/api` and the Keptn Bridge is located under `http://HOSTNAME/mykeptn/bridge`:

```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.19.3 --repo=https://charts.keptn.sh --set=apiGatewayNginx.type=LoadBalancer,prefixPath=/mykeptn
```

## Install Keptn with externally hosted MongoDB

If you want to use an externally hosted MongoDB instead of the MongoDB installed by Keptn, please use the `helm upgrade` command as shown below. Basically, provide the MongoDB host, port, user, and password in form of a connection string.

```
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=mongo.enabled=false,
      mongo.external.connectionString=<YOUR_MONGODB_CONNECTION_STRING>,
      mongo.auth.database=<YOUR_DATABASE_NAME>
```

Keptn has no opinion about how to fine-tune the database connection.
We recommend that the user specify any special configuration via the
[connection string](https://www.mongodb.com/docs/manual/reference/connection-string/) parameter
in the `mongo.external.connectionString` helm value.



## Change how to expose Keptn

If you would like to change the way of exposing Keptn,
you can do this by [re-installing Keptn](../helm-install/)
and selecting the desired configuration.
When the CLI asks you if you would like to overwrite the installation, confirm this with yes.
This retains ell your data, including the Git repos and events.

