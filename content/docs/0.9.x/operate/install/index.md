---
title: Install CLI and Keptn
description: Install Keptn on your Kubernetes cluster and expose it.
weight: 10
keywords: [0.9.x-operate]
aliases:
  - /docs/0.9.0/operate/install/
---

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Create or bring a Kubernetes cluster

To create a Kubernetes cluster, select one of the following options:

<details><summary>Azure Kubernetes Service (AKS)</summary>
<p>

1. Install local tools
  - [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

1. Make sure you are logged in to your Azure account with `az login`

1. Create AKS cluster
  - [Master version:](../k8s_support/#supported-versions) `1.20.x` (tested version: `v1.20.7`)
  - One **D8s_v3** node

 </p>
</details>

<details><summary>Amazon Elastic Kubernetes Service (EKS)</summary>
<p>

1. Install local tools
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (version >= 1.16.156)

1. Create EKS cluster on AWS
  - [Master version:](../k8s_support/#supported-versions) `1.17` (tested version: `1.17`)
  - One `m5.2xlarge` node
  - Sample script using [eksctl](https://eksctl.io) to create such a cluster

    ```console
    eksctl create cluster --version=1.17 --name=keptn-cluster --node-type=m5.2xlarge --nodes=1 --region=eu-west-3
    ```

    <details><summary>**Known issue on EKS 1.13**</summary>

    Please note that for EKS version `1.13` in our testing we learned that the default CoreDNS that comes with certain EKS versions has a bug. To solve that issue we can use eksctl to update the CoreDNS service like this: 
    
    ```console
    eksctl utils update-coredns --name=keptn-cluster --region=eu-west-3 --approve
    ```
    
    </details>

</p>
</details>

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE! If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit, which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="https://bit.ly/keptngkecredit" target="_blank">Apply for your credit here</a>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)

2. Create GKE cluster
  - [Master version:](../k8s_support/#supported-versions) `1.17.x` and `1.18.x` (tested version: `1.18.12`)
  - One node with 8 vCPUs and 32 GB memory (e.g., one **n1-standard-8** node)
  - Image type `Ubuntu` or `COS` (**Note:** If you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../monitoring/dynatrace/).)
  - Sample script to create such a cluster:

    ```console
    // set environment variables
    PROJECT=<NAME_OF_CLOUD_PROJECT>
    CLUSTER_NAME=<NAME_OF_CLUSTER>
    ZONE=us-central1-a
    REGION=us-central1
    GKE_VERSION="1.18"
    IMAGE_TYPE="Ubuntu"
    ```

    ```console
    gcloud container clusters create $CLUSTER_NAME --project $PROJECT --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-8" --image-type "$IMAGE_TYPE" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-stackdriver-kubernetes --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-shielded-nodes --no-enable-autoupgrade
    ```
 </p>
</details>

<details><summary>OpenShift 4 & 3.11</summary>
<p>

**OpenShift 4**

1. Please bring your own OpenShift cluster in version 4 (tested version: `4.5`)

1. Install local tools

  - [oc CLI - v4.1](https://github.com/openshift/origin/releases/tag/v4.1.0)

1. Currently, there is the *known limitation* that the MongoDB of Keptn does not start. Please follow the troubleshooting guide provided here: [MongoDB on OpenShift 4 fails](../../troubleshooting/#mongodb-on-openshift-4-fails).

**OpenShift 3.11**

1. Please bring your own OpenShift cluster in version 3.11

1. Install local tools

  - [oc CLI - v3.11](https://github.com/openshift/origin/releases/tag/v3.11.0)


1. On the OpenShift master node, execute the following steps:

    - Set up the required permissions for your user:

      ```console
    oc adm policy --as system:admin add-cluster-role-to-user cluster-admin <OPENSHIFT_USER_NAME>
      ```

    - Set up the required permissions for the installer pod:

      ```console
    oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:default:default
    oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
      ```

    - Enable admission WebHooks on your OpenShift master node:

      ```console
    sudo -i
    cp -n /etc/origin/master/master-config.yaml /etc/origin/master/master-config.yaml.backup
    oc ex config patch /etc/origin/master/master-config.yaml --type=merge -p '{
      "admissionConfig": {
        "pluginConfig": {
          "ValidatingAdmissionWebhook": {
            "configuration": {
              "apiVersion": "apiserver.config.k8s.io/v1alpha1",
              "kind": "WebhookAdmission",
              "kubeConfigFile": "/dev/null"
            }
          },
          "MutatingAdmissionWebhook": {
            "configuration": {
              "apiVersion": "apiserver.config.k8s.io/v1alpha1",
              "kind": "WebhookAdmission",
              "kubeConfigFile": "/dev/null"
            }
          }
        }
      }
    }' >/etc/origin/master/master-config.yaml.patched
    if [ $? == 0 ]; then
      mv -f /etc/origin/master/master-config.yaml.patched /etc/origin/master/master-config.yaml
      /usr/local/bin/master-restart api && /usr/local/bin/master-restart controllers
    else
      exit
    fi
      ```
</p>
</details>

<details><summary>K3s</summary>
<p>

Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Here, a short guide on how to run Keptn on K3s is provided for a Linux environment. **Note:** If you are using macOS, you will need to run K3s using [multipass](https://multipass.run/) and as explained [here](https://medium.com/@zhimin.wen/running-k3s-with-multipass-on-mac-fbd559966f7c).
 
1. Download, install [K3s](https://k3s.io/) (tested with [versions 1.17 to 1.21](../k8s_support)) and run K3s using the following command:
   ```console
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.4+k3s1 K3S_KUBECONFIG_MODE="644" sh -s - --no-deploy=traefik
   ```
   This installs version `v1.20.4+k3s1` (please refer to the [K3s GitHub releases page](https://github.com/rancher/k3s/releases) for newer releases), sets file permissions `644` on `/etc/rancher/k3s/k3s.yaml` and disables `traefik` as an ingress controller.

1. Export the Kubernetes profile using
   ```console
   export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   ```
   
1. Verify that the connection to the cluster works
   ```console
   kubectl get nodes   
   ```

</p>
</details>

<details><summary>Minikube</summary>
<p>

1. Download and install [Minikube](https://github.com/kubernetes/minikube/releases) (tested with [versions 1.3 to 1.10](../k8s_support)).

1. Create a new Minikube profile (named keptn) with at least 6 CPU cores and 14 GB memory using:

    ```console
    minikube start -p keptn --cpus 6 --memory 14000
    ``` 

1. (Optional) Start the Minikube LoadBalancer service in a second terminal by executing:

    ```console
   minikube tunnel 
   ``` 
</p>
</details>

<details><summary>Any other Kubernetes distribution</summary>
<p>

Keptn should run on any other Kubernetes distribution as it only consists of Kubernetes deployments, services, RBAC rules, and PVCs.
However, if you are facing problems, please let us know on https://slack.keptn.sh.

</p>
</details>

## Quick Start

:bulb: If you would like to install Keptn in a default way, please go to [Quick Start](../../../quickstart/#2-install-keptn).

Use this page if you have already Keptn experience and would like to install it according to your needs.

## Install Keptn CLI

Every Keptn release provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from: [GitHub](https://github.com/keptn/keptn/releases/tag/0.9.0)
- Unpack the archive
- Find the `keptn` binary in the unpacked directory

  - *Linux / macOS*: Add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - *Windows*: Copy the executable to the desired folder and add the executable to your PATH environment variable.

- Now, verify that the installation has worked and that the version is correct by running:
    - *Linux / macOS*

    ```console
    keptn version
    ```

    - *Windows*

    ```console
    .\keptn.exe version
    ```

**Note:** For the rest of the documentation we will stick to the *Linux / macOS* version of the commands.

## Install Keptn

Keptn consists of a **Control Plane** and an **Execution Plane**:

* The **Control Plane** allows using Keptn for the [Quality Gates](../../../concepts/quality_gates/) and [Automated Operations](../../../concepts/automated_operations/) use cases. To install the control plane containing the components for *quality gates* and *automated operations*, execute: 

    ```console
    keptn install
    ```

* The **Control Plane with the Execution Plane (for Continuous Delivery)** allows to implement [Continuous Delivery](../../../concepts/delivery/) on top of *quality gates* and *automated operations* use cases. Please not that for this use-case [Istio](https://istio.io) is required as well, as this is used for traffic routing between blue/green versions during deployment. To install the control plane with the execution plane for continuous delivery, execute:

    ```
    keptn install --use-case=continuous-delivery
    ```

**How to access Keptn?**

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

1. **Install Keptn:** For installing Keptn on your cluster, please use the Keptn CLI.
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `--use-case=continuous-delivery`. Furthermore, if you are on OpenShift, please add `--platform=openshift`.
  ```console
  keptn install --endpoint-service-type=LoadBalancer (--use-case=continuous-delivery) (--platform=openshift)
  ```

1. **Get Keptn endpoint:**  Get the EXTERNAL-IP of the `api-gateway-ngix` using the command below. The Keptn API endpoint is: `http://<ENDPOINT_OF_API_GATEWAY>/api`
  ```console
  kubectl -n keptn get service api-gateway-nginx
  ```
  ```console
  NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
  api-gateway-nginx   ClusterIP   10.107.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
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
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `--use-case=continuous-delivery`. Furthermore, if you are on OpenShift, please add `--platform=openshift`.
  ```console
  keptn install --endpoint-service-type=NodePort (--use-case=continuous-delivery) (--platform=openshift)
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
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `--use-case=continuous-delivery`. Furthermore, if you are on OpenShift, please add `--platform=openshift`.
  ```console
  keptn install (--use-case=continuous-delivery) (--platform=openshift)
  ```

1. **Install an Ingress-Controller and create an Ingress:**
  Please first install your favorite Ingress-Controller and then apply an Ingress object in the `keptn` namespace, 
  which points to the service `api-gateway-nginx` on port 80. Note that the [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) allows to setup TLS encryption.

    Commonly used Ingress-Controller are e.g. Istio and NGINX:

    <details><summary>**Istio 1.8+** (recommended for use-case continuous delivery)</summary>
    <p>

    * Istio provides an Ingres Controller. To install Istio, please refer to the [official documentation](https://istio.io/latest/docs/setup/install/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n istio-system get svc istio-ingressgateway
      ```

    * Create an `ingress-manifest.yaml` manifest for an Ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example of an `ingress-manifest.yaml` manifest shown below, `nip.io` is used as wildcard DNS for the IP address.)

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

    <details><summary>**NGNIX Ingress**</summary>
    <p>

    * To install an NGINX Ingress Controller, please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/).

    * [Determine the ingress IP](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

      ```console
    kubectl -n ingress-nginx get svc ingress-nginx
      ```

    * Create an `ingress-manifest.yaml` manifest for an ingress object in which you set IP-ADDRESS or your hostname and then apply the manifest. (**Note:** In the example of an `ingress-manifest.yaml` manifest shown next, `nip.io` is used as wildcard DNS for the IP address.)

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
          - backend:
              serviceName: api-gateway-nginx
              servicePort: 80
      ```

      ```console
    kubectl apply -f ingress-manifest.yaml
      ```

    </p>
    </details>

1. **Get Keptn endpoint:** Get the HOST of the `api-keptn-ingress` using the command below. The Keptn API endpoint is: `http://<HOST>/api`

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
Depending on whether you would like to install the execution plane for continuous delivery, add the flag `--use-case=continuous-delivery`. Furthermore, if you are on OpenShift, please add `--platform=openshift`.
  ```console
  keptn install (--use-case=continuous-delivery) (--platform=openshift)
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

  
## Authenticate Keptn CLI

To authenticate the Keptn CLI against the Keptn cluster, the exposed Keptn endpoint and API token are required. 
After [installing Keptn](#install-keptn), you already have your Keptn endpoint.

<details><summary>Get API Token and Authenticate Keptn CLI on **Linux / MacOS**</summary>
<p>

* Set the environment variable `KEPTN_API_TOKEN`:

```console
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```console
keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

**Note**: If you receive a warning `Using a file-based storage for the key because the password-store seems to be not set up.` this is because a password store could not be found in your environment. In this case, the credentials are stored in `~/.keptn/.password-store` in your home directory.
</p>
</details>

<details><summary>Get API Token and Authenticate Keptn CLI on **Windows**</summary>
<p>

Please expand the corresponding section matching your CLI tool:

<details><summary>PowerShell</summary>
<p>

For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables.

* Set the environment variable `KEPTN_ENDPOINT`:

```console
$Env:KEPTN_ENDPOINT = 'http://<ENDPOINT_OF_API_GATEWAY>/api'
```

* Copy the following snippet and paste it in the PowerShell. The snippet retrieves the API token and sets the environment variable `KEPTN_API_TOKEN`:

```
$tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
$Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```
keptn auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
```

</p>
</details>

<details><summary>Command Line</summary>
<p>

In the Windows Command Line, a couple of steps are necessary.

* Set the environment variable `KEPTN_ENDPOINT`:

```console
set KEPTN_ENDPOINT=http://<ENDPOINT_OF_API_GATEWAY>/api
```

* Get the Keptn API Token encoded in base64:

```console
kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
```

```console
abcdefghijkladfaea
```

* Take the encoded API token - it is the value from the key `keptn-api-token` (in this example, it is `abcdefghijkladfaea`) and save it in a text file, e.g., `keptn-api-token-base64.txt`

* Decode the file:

```
certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
```

* Open the newly created file `keptn-api-token.txt`, copy the value and paste it into the next command:

```
set KEPTN_API_TOKEN=keptn-api-token
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```
keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
```

</p>
</details>
</p>
</details>

--- 

**Note:** *Suppress WebSocket communication when exposing Keptn via port-forward*

* The WebSocket communications cannot be used when the Keptn API is exposed via a port-forward. Hence, please add `--suppress-websocket` to all CLI commands, e.g.: `keptn create project PROJECTNAME --suppress-websocket` 

## Authenticate Keptn Bridge

After installing and exposing Keptn, you can access the Keptn Bridge by using a browser and navigating to the Keptn endpoint without the `api` path at the end of the URL. 

The Keptn Bridge has basic authentication enabled by default and the default user is `keptn` with an automatically generated password. 

* To get the user and password for authentication, execute:

```console
keptn configure bridge --output
```

* If you want to change the user and password for the authentication, follow the instructions [here](../../reference/bridge/basic_authentication/#enable-authentication).


## Change how to expose Keptn

If you would like to change the way of exposing Keptn, you can do this by [re-installing Keptn](#install-keptn)
and selecting the desired configuration. 
When the CLI asks you if you would like to overwrite the installation, confirm this with yes.
This will keep all your data including the Git repos and events.

## Advanced: Install Keptn using the Helm chart

Please see our guide at [Advanced Installation Options](../advanced_install_options) for more information.

## Troubleshooting

1. [Verify the Keptn installation](../../troubleshooting#verifying-a-keptn-installation).

1. [Generate a support-archive](../../reference/cli/commands/keptn_generate_support-archive) and ask for help in our [Slack channel](https://slack.keptn.sh).

1. Uninstall Keptn by executing the [keptn uninstall](../../reference/cli/commands/keptn_uninstall) command before conducting a re-installation.  
