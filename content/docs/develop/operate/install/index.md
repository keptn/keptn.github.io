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

2. Create AKS cluster
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


In the Kubernetes cluster, this command creates the **keptn**, **keptn-datastore**, and **istio-system** namespace. While istio-system contains all Istio related resources, keptn and keptn-datastore contain the complete infrastructure to run Keptn. 
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
                <li>jmeter-service</li>
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


**Note:** If you want to install Keptn just for the use case of [Keptn Quality Gates](../../usecases/quality-gates/), you have the option to roll-out Keptn **without** components for automated delivery and operations. Therefore, the `use-case` flag must be set to `quality-gates`:

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes] --use-case=quality-gates
```

## Configure a custom domain

If you have a custom domain or cannot use *xip.io* (e.g., when running Keptn on EKS with an ELB (Elastic Load Balancer) from AWS), there is the 
CLI command [keptn configure domain](../../reference/cli/commands/keptn_configure_domain) to configure Keptn for your custom domain:

```console
keptn configure domain YOUR_DOMAIN
```

## Troubleshooting

Please note that in case of any errors, the install process might leave some files in an inconsistent state. Therefore [keptn install](../../reference/cli/commands/keptn_install) cannot be executed a second time without [keptn uninstall](../../reference/cli/commands/keptn_uninstall). To address a unsuccessful installation: 

1. [Verify the Keptn installation](../../../reference/troubleshooting#verifying-a-keptn-installation).

1. Uninstall Keptn by executing the [keptn uninstall](../../reference/cli/commands/keptn_uninstall) command before conducting a re-installation.  
