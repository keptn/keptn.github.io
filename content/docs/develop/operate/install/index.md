---
title: Install CLI and Keptn
description: Install Keptn on your Kubernetes cluster and expose it.
weight: 1
keywords: setup
---

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Create Kubernetes cluster

To create a Kubernetes cluster, select one of the following options:

<details><summary>Azure Kubernetes Service (AKS)</summary>
<p>

1. Install local tools
  - [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

1. Make sure you are logged in to your Azure account with `az login`

1. Create AKS cluster
  - [Master version:](../k8s-support/#supported-version) `1.15.x` (tested version: `1.15.10`)
  - One **D8s_v3** node
 
 </p>
</details>

<details><summary>Amazon Elastic Kubernetes Service (EKS)</summary>
<p>

1. Install local tools
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (version >= 1.16.156)

1. Create EKS cluster on AWS
  - [Master version:](../k8s-support/#supported-version) `1.15` (tested version: `1.15`)
  - One `m5.2xlarge` node
  - Sample script using [eksctl](https://eksctl.io/introduction/installation/) to create such a cluster

    ```console
    eksctl create cluster --version=1.15 --name=keptn-cluster --node-type=m5.2xlarge --nodes=1 --region=eu-west-3
    ```

    <details><summary>**Known bug in EKS 1.13**</summary>

    Please note that for EKS version `1.13` in our testing we learned that the default CoreDNS that comes with certain EKS versions has a bug. To solve that issue we can use eksctl to update the CoreDNS service like this: 
    
    ```console
    eksctl utils update-coredns --name=keptn-cluster --region=eu-west-3 --approve
    ```
    
    </details>

</p>
</details>

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE! If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="https://bit.ly/keptngkecredit" target="_blank">Apply for your credit here</a>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

2. Create GKE cluster
  - [Master version:](../k8s-support/#supported-version): `1.15.x` (tested version: `1.15.9-gke.22`)
  - One **n1-standard-8** node
  - Image type `Ubuntu` or `COS` (**Note:** If you plan to use Dynatrace monitoring, select `ubuntu` for a more [convenient setup](../../reference/monitoring/dynatrace/).)
  - Sample script to create such cluster:

    ```console
    // set environment variables
    PROJECT=<NAME_OF_CLOUD_PROJECT>
    CLUSTER_NAME=<NAME_OF_CLUSTER>
    ZONE=us-central1-a
    REGION=us-central1
    GKE_VERSION="1.15"
    ```

    ```console
    gcloud container clusters create $CLUSTER_NAME --project $PROJECT --zone $ZONE --no-enable-basic-auth --cluster-version $GKE_VERSION --machine-type "n1-standard-8" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-stackdriver-kubernetes --no-enable-ip-alias --network "projects/$PROJECT/global/networks/default" --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade
    ```
 </p>
</details>

<details><summary>OpenShift 3.11</summary>
<p>

1. Please note that you have to bring your own OpenShift cluster in version 3.11

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

Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Here a short guide on how to run Keptn on K3s is provided.
 
1. Download, install [K3s](https://k3s.io/) (tested with [versions 1.16 to 1.18](../k8s_support)) and run K3s using the following command:
   ```console
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.18.3+k3s1 K3S_KUBECONFIG_MODE="644" sh -s - --no-deploy=traefik
   ```
   This installs version `v1.18.3+k3s1` (please refer to the [K3s GitHub releases page](https://github.com/rancher/k3s/releases) for newer releases), sets file permissions `644` on `/etc/rancher/k3s/k3s.yaml` and disables `traefik` as an ingress controller.

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

1. Create a new Minikube profile (named keptn) with at least 6 CPU cores and 12 GB memory using:

    ```console
    minikube start -p keptn --cpus 6 --memory 12200
    ``` 

1. (Optional) Start the Minikube LoadBalancer service in a second terminal by executing:

    ```console
   minikube tunnel 
   ``` 

</p>
</details>

## Install Keptn CLI

Every Keptn release provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from: [github.com/keptn/](https://github.com/keptn/keptn/releases/tag/0.6.2)
- Unpack the archive
- Find the `keptn` binary in the unpacked directory

  - *Linux / macOS*: Add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - *Windows*: Copy the executable to the desired folder and add the executable to your PATH environment variable.

- Now, you should be able to run the Keptn CLI: 
    - Linux / macOS

    ```console
    keptn --help
    ```
    
    - Windows

    ```console
    .\keptn.exe --help
    ```

**Note:** For the rest of the documentation we will stick to the *Linux / macOS* version of the commands.

## Install Keptn

When installing Keptn, you have three possibilities to expose Keptn onto an external IP address that is outside of your cluster. The three possibilities are reflected by the following three Kubernetes *ServiceTypes*:

* **ClusterIP**: Exposes Keptn on a cluster-internal IP, this is the default setting.
* **NodePort**: Exposes Keptn on each Node's IP at a static port.
* **LoadBalancer**: Exposes Keptn externally using a cloud provider's load balancer.

To select the approach of exposing Keptn that best fits your needs, you can set the flag `keptn-api-service-type` when launching the Keptn installation:

  ```console
--keptn-api-service-type=[ClusterIP | NodePort | LoadBalancer]
  ```

Depending on the selected approach and especially when going with *ClusterIP*, additional steps are required for a successful Keptn installation. The next flow chart guides you through the installation process depending on your decisions.   

{{< popup_image
link="./assets/installation_process.png"
caption="Installation process"
width="500px">}}

<br>
Brief explanation of the flow chart for the installation process: 

* When using *NodePort* or *LoadBalancer*, just the authentication of the Keptn CLI is required: [(5) Authenticate Keptn CLI](./#5-authenticate-keptn-cli)
* When using *ClusterIP*, a decision must me made whether to use
    * Ingress: [(3) Install ingress controller and apply an ingress object](./#3-install-ingress-controller-and-apply-an-ingress-object) or,
    * Port-forward: [(4) Use port-forward to access Keptn](./#4-use-port-forward-to-access-keptn) to accesss Keptn. 

### (1) Consider install recommendations

|            | LoadBalancer | NodePort | ClusterIP |
|------------|:------------:|:--------:|:---------:|
| Kubernetes                                |              |          |     ?     |
| Azure Kubernetes Service (AKS)            |     x (1)    |          |           |
| Amazon Elastic Kubernetes Service (EKS)   |     x (1)    |          |           |
| Google Kubernetes Engine (GKE)            |     x (1)    |          |           |
| OpenShift 3.11                            |              |          |     x     |
| K3s                                       |              |          |     x     |
| Minikube                                  |              |     x    |           |
| MicroK8s (experimental)                   |              |     x    |           |
| Minishift (experimental)                  |       ?      |     ?    |     ?     |

**Remarks:**

* (1) Please be aware that the Cloud Provider will charge you for a *LoadBalancer*. 

### (2) Install Keptn on your cluster

**Keptn Control Plane**

This installation allows you to use Keptn for the [Quality Gates](../../quality_gates/) and [Automated Operations](../../automated_operations/) use cases.

* To install Keptn on a Kubernetes cluster, execute the [keptn install](../../reference/cli/commands/keptn_install) command. If you want to roll-out Keptn on OpenShift, set the flag `--platform=openshift`; by default, this flag is set to `--platform=kubernetes`

  ```console
keptn install
  ```

* By default, the service type *ClusterIP* is used for exposing Keptn. Hence, set the flag `xyz` and `keptn-bridge-service-type` if you want to use another option.

  ```console
keptn install --keptn-api-service-type=[ClusterIP | NodePort | LoadBalancer]
  ```

**Keptn Control Plane + Execution Plane (for Continous Delivery)**

If you want to install Keptn with [Continuous Delivery](../../continuous_delivery/) use cases, you have the option to roll-out Keptn **with** components for the execution plane. 

* To install Keptn on a Kubernetes cluster with CD support, the `use-case` flag must be set to `continuous-delivery`:

  ```console
keptn install --use-case=continuous-delivery
  ```

### (3) Install ingress controller and apply an ingress object

<details><summary>**Istio**</summary>
<p>

* To install an Istio Ingress Controller, please refer to the [official Istio documentation](https://istio.io/latest/docs/setup/install/).

* [Determine the ingress IP and ports](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

  ```console
kubectl -n istio-system get svc istio-ingressgateway
  ```

* Create a `ingress-manifest.yaml` manifest for an ingress object in which you set set IP-ADDRESS and PORT. Finally, apply the manifest:

  ```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: istio
  name: api-keptn-ingress
spec:
  rules:
  - host: <IP-ADDRESS>
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: <PORT>
  ```

  ```console
kubectl apply -f ingress-manifest.yaml
  ```

</p>
</details>

<details><summary>**NGNIX Ingress**</summary>
<p>

* To install an NGINX Ingress Controller, please refer to the [official documentation](https://kubernetes.github.io/ingress-nginx/).

* From where do we get the IP/PORT? <!-- TODO: How to get IP/PORT? -->

* Create the `ingress-manifest.yaml` manifest for an ingress object in which you set IP-ADDRESS and PORT. Finally, apply the manifest:

  ```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: keptn-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: <IP-ADDRESS>
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: <PORT>
  ```

  ```console
kubectl apply -f ingress-manifest.yaml
  ```

</p>
</details>

<details><summary>**Traefik**</summary>
<p>

* To install a Traefik Ingress Controller, please refer to the [official documentation](https://docs.traefik.io/getting-started/install-traefik).

* From where do we get the IP/PORT? <!-- TODO: How to get IP/PORT? -->

* Create the `ingress-manifest.yaml` manifest for an ingress object in which you set IP-ADDRESS and PORT. Finally, apply the manifest:

  ```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: keptn-ingress
spec:
  rules:
  - host: <IP-ADDRESS>
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: <PORT>
  ```

  ```console
kubectl apply -f ingress-manifest.yaml
  ```

</p>
</details>

### (4) Use port-forward to access Keptn

If you have not exposed Keptn via *NodePort* or *LoadBalancer* and you don't want to install an ingress on your Kubernetes cluster, you can use `kubectl port-forward` to connect to Keptn.

* Please make sure that your `kubectl` CLI is configured to communicate with your cluster.

* Execute `kubectl port-forward` to access Keptn:

  ```console
kubectl -n keptn port-forward service/api-gateway-nginx 8080:80
  ```

### (5) Authenticate Keptn CLI

To authenticate the Keptn CLI against the Keptn cluster, the exposed Keptn endpoint and API token are required. 

* Get the Keptn endpoint from the `api-gateway-nginx`. (If you are using port-forward to expose Keptn, your endpoint is `localhost` and the `port` you forwarded Keptn to, e.g.: `http://localhost:8080`) 

  ```console
kubectl -n keptn get service api-gateway-nginx
  ```

  ```console
NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
api-gateway-nginx   ClusterIP   10.107.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
  ```

<details><summary>Retrive API Token and Authenticate Keptn CLI on **Linux / MacOS**</summary>
<p>

* Set the environment variable `KEPTN_ENDPOINT`:

```console
KEPTN_ENDPOINT=<ENDPOINT_OF_API_GATEWAY>
```

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

<details><summary>Retrive API Token and Authenticate Keptn CLI on **Windows**</summary>
<p>

Please expand the corresponding section matching your CLI tool:

<details><summary>PowerShell</summary>
<p>

For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables.

* Set the environment variable `KEPTN_ENDPOINT`:

```console
$Env:KEPTN_ENDPOINT = '<ENDPOINT_OF_API_GATEWAY>'
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
set KEPTN_ENDPOINT=<ENDPOINT_OF_API_GATEWAY>
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

## Change how to expose Keptn

If you would like to change the way of exposing Keptn, you can do this by changing the Kubernetes service type.

* Change api-gateway-nginx service type from ClusterIP to LoadBalancer:

  ```console
kubectl patch service api-gateway-nginx -n keptn -p '{"spec": {"type": "LoadBalancer"}}'
  ```

* Change api-gateway-nginx service type from ClusterIP to NodePort:

  ```console
kubectl patch service api-gateway-nginx -n keptn -p '{"spec": {"type": "NodePort"}}'
  ```

## Troubleshooting

In case of any errors, the install process might leave some files in an inconsistent state. Therefore [keptn install](../../reference/cli/commands/keptn_install) cannot be executed a second time without [keptn uninstall](../../reference/cli/commands/keptn_uninstall). To address a unsuccessful installation: 

1. [Verify the Keptn installation](../../../reference/troubleshooting#verifying-a-keptn-installation).

1. Uninstall Keptn by executing the [keptn uninstall](../../reference/cli/commands/keptn_uninstall) command before conducting a re-installation.  
