---
title: Install CLI and Keptn
description: Install Keptn on one of the supported Kubernetes platforms.
weight: 1
keywords: setup
---

## Prerequisites
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup Kubernetes cluster

Select one of the following options:

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

    Please note that for EKS version `1.13` in our testing we learned that the default CoreDNS that comes with certain EKS versions has a bug. In order to solve that issue we can use eksctl to update the CoreDNS service like this: 
    
    ```console
    eksctl utils update-coredns --name=keptn-cluster --region=eu-west-3 --approve
    ```
    
    </details>

</p>
</details>

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE!
If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit which you can use towards that GKE cluster needed to run Keptn.<br><br>
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
    PROJECT=nameofgcloudproject
    CLUSTER_NAME=nameofcluster
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

<details><summary>Pivotal Container Service (PKS)</summary>
<p>

1. Install local tools
  - [pks CLI - v1.0.4](https://docs.pivotal.io/runtimes/pks/1-4/installing-pks-cli.html)

1. Create PKS cluster on GCP
  - Use the provided instructions for [Enterprise Pivotal Container Service (Enterprise PKS) installation on GCP](https://docs.pivotal.io/runtimes/pks/1-4/gcp-index.html)

  - Create a PKS cluster by using the PKS CLI and executing the following command:

    ```console
    // set environment variables
    CLUSTER_NAME=name_of_cluster
    HOST_NAME=host_name
    PLAN=small
    ```

    ```console
    pks create-cluster $CLUSTER_NAME --external-hostname $HOST_NAME --plan $PLAN
    ```
</p>
</details>

<details><summary>K3s</summary>
<p>

**Note**: Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Within 
 this page we only provide a very short guide on how we run Keptn on K3s.
 
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
Every release of Keptn provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

- Download the version for your operating system from [github.com/keptn/](https://github.com/keptn/keptn/releases/tag/0.6.2)
- Unpack the download
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

To install the latest release of Keptn on a Kuberntes cluster, execute the [keptn install](../../reference/cli/commands/keptn_install) command with the ``platform`` flag specifying the target platform you would like to install Keptn on. Currently, supported platforms are:

- Azure Kubernetes Services (AKS):

```console
keptn install --platform=aks
```
  
- Amazon Elastic Kubernetes Service (EKS):

```console
keptn install --platform=eks
```

- Google Kubernetes Engine (GKE):

```console
keptn install --platform=gke
```

- OpenShift 3.11:

```console
keptn install --platform=openshift
```

- Pivotal Container Service (PKS):

```console
keptn install --platform=pks
```

- K3s:

    **Note**: If the Keptn installer is having trouble getting an IP address, try to install with `--gateway=NodePort`.


```console
keptn install --platform=kubernetes
```

- Minikube:

    **Note**: If you are using `minikube tunnel` you don't need to use `--gateway=NodePort`.

```console
keptn install --platform=kubernetes --gateway=NodePort
```

In the Kubernetes cluster, this command creates the **keptn** and the **keptn-datastore** namespace containing all Keptn core components.
This installation will allow you to use Keptn for the [Keptn Quality Gates](../../quality_gates/) and [Automated Operations](../../automated_operations/) use cases.
    <details><summary>The *keptn* and *keptn-datastore* namespace contain:</summary>
        <ul>
        <li>mongoDb database for the Keptn's log</li>
        <li>NATS cluster</li>
        <li>Keptn core services:</li>
            <ul>
                <li>api</li>
                <li>bridge</li>
                <li>configuration-service</li>
                <li>distributors</li>
                <li>eventbroker</li>
                <li>gatekeeper-service</li>
                <li>helm-service</li>
                <li>lighthouse-service</li>
                <li>mongodb-datastore</li>
                <li>remediation-service</li>
                <li>shipyard-service</li>
                <li>wait-service</li>
            </ul>
        <li>Services to deploy artifacts and to demonstrate the self-healing use cases:</li>
            <ul>
                <li>prometheus-service</li>
                <li>servicenow-service</li>
                <li>openshift-route-service (OpenShift only)</li>
            </ul>
        </ul>
    </details>


**Note:** If you want to install the complete Keptn version supporting [Keptn Continuous Delivery use case](../../continuous_delivery/), you have the option to roll-out Keptn **with** additional components for automated delivery and operations. Therefore, the `use-case` flag must be set to `continuous-delivery`:

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes] --use-case=continuous-delivery
```

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

To authenticate, you will need to set `$KEPTN_ENDPOINT` and `$KEPTN_API_TOKEN`. For retrieving the value on `$KEPTN_ENDPOINT`,
please follow the instructions above. The value of `$KEPTN_API_TOKEN` can be retrieved using:

```
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
```

Afterwards, execute the following command to authenticate at the Keptn API:

```
./keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

**Please note:** The WebSocket communications cannot be used when the API is exposed via a `Port-forward`. Hence, please add `--suppress-websocket` to **all** CLI commands.

## Configure an Istio Ingress (required for continuous delivery)

To be able to reach your onboarded services, Istio has to be installed, and the `istio-ingressgateway` service, as well as the `public-gateway` in the `istio-system` namespace
have to be available. To install Istio, please refer to the [official Istio documentatio](https://istio.io/latest/docs/setup/install/).
When that is done, the next step is to determine the IP and the port of your Istio ingress. To do so, please refer to the following section
of the Istio documentation: [Determining the ingress IP and ports](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports).

Once that is done, create the `ingress-config` ConfigMap in the `keptn` namespace:

```
INGRESS_IP=<IP_OF_YOUR_INGRESS>
INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
INGRESS_PROTOCOL=<PROTOCOL> # either "http" or "https"
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_IP}.xip.io --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} -oyaml --dry-run | kubectl replace -f -
```

If you have already set up set up a domain that points to your Istio Ingress, you can use that one for the `INGRESS_HOSTNAME_SUFFIX`. In this case, use the following command to create the ConfigMap:

```
INGRESS_HOSTNAME=<YOUR_HOSTNAME>
INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
INGRESS_PROTOCOL=<PROTOCOL> # either "http" or "https"
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} -oyaml --dry-run | kubectl replace -f -
```

After the ConfigMap has been created, restart the `helm-service`, using the following command:

```
kubectl delete pod -n keptn -lrun=helm-service
```

If you are on OpenShift, also restart the `openshift-route-service`:

```
kubectl delete pod -n keptn -lrun=openshift-route-service
```

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore [keptn install](../../reference/cli/commands/keptn_install) cannot be executed a second time without [keptn uninstall](../../reference/cli/commands/keptn_uninstall). To address a unsuccessful installation: 

1. [Verify the Keptn installation](../../troubleshooting#verifying-a-keptn-installation).

1. Uninstall Keptn by executing the [keptn uninstall](../../reference/cli/commands/keptn_uninstall) command before conducting a re-installation.  
