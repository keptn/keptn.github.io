---
title: Quick Start
description: Learn how to get Keptn running in five minutes.
icon: concepts
layout: quickstart
weight: 1
hidechildren: true # this flag hides all sub pages in the sidebar-multicard.html
---

### 1. Create Kubernetes cluster

Select one of the following options:

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE! If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit, which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="https://bit.ly/keptngkecredit" target="_blank">Apply for your credit here</a>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)

2. Create GKE cluster
  - [Master version](../0.7.x/operate/k8s_support/#supported-versions): `1.17.x` and `1.18.x` (tested version: `1.18.12`)
  - One node with 8 vCPUs and 32 GB memory (e.g., one **n1-standard-8** node)
  - Change Image type from `COS` to `Ubuntu` (**Note:** In case you plan to use Dynatrace monitoring, we recommend `Ubuntu` for a more [convenient setup](../0.7.x/monitoring/dynatrace/install/#notes).)
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

<details><summary>K3s</summary>
<p>

Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Here, a short guide on how to run Keptn on K3s is provided for a Linux environment. **Note:** If you are using macOS, you will need to run K3s using [multipass](https://multipass.run/) and as explained [here](https://medium.com/@zhimin.wen/running-k3s-with-multipass-on-mac-fbd559966f7c).
 
1. Download, install [K3s](https://k3s.io/) (tested with [versions 1.16 to 1.19](../0.7.x/operate/k8s_support/#supported-versions)) and run K3s using the following command:
   ```console
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.19.5+k3s1 K3S_KUBECONFIG_MODE="644" sh -s - --no-deploy=traefik
   ```
   This installs version `v1.19.5+k3s1` (please refer to the [K3s GitHub releases page](https://github.com/rancher/k3s/releases) for newer releases), sets file permissions `644` on `/etc/rancher/k3s/k3s.yaml` and disables `traefik` as an ingress controller.

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

<details><summary>Other K8s options</summary>
<p>
We also support installation on:

* AWS Elastic Kubernetes Service (EKS)
* Azure Kubernetes Service (AKS)
* Minikube
* OpenShift 4 & 3.11

For details on the specific providers, please visit our [detailed installation guide](../0.7.x/operate/install/#create-or-bring-kubernetes-cluster).

</p>
</details>

### 2. Install Keptn

The following instructions will install the **latest stable Keptn CLI (0.7.3)** in a quick way. 

If you need more information, please look at the [install Keptn CLI](../0.7.x/operate/install/#install-keptn-cli) guide.

#### 2.1 Install Keptn CLI
The Keptn CLI is the one-stop-shop for all operations related to Keptn.

Please make sure you have `kubectl` installed (see [kubernetes.io/docs/tasks/tools/install-kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)).

##### 2.1.1 Automatic install of the Keptn CLI using Bash

**Note**: This will work on Linux (and WSL2), as well as MacOS. Windows users need `bash`, `curl` and `awk` installed (e.g., using Git Bash). 

1. This will download the *latest stable Keptn version* from [GitHub](https://github.com/keptn/keptn/releases), unpack it and move it to `/usr/local/bin/keptn`.

    ```console
    curl -sL https://get.keptn.sh | bash
    ```

2. Verify that the installation has worked and that the version is correct by running:

    ```console
    keptn version
    ```
    
    or if you are on Windows
    ```console
    ./keptn version
    ```

##### 2.1.2 Manual install of the Keptn CLI

1. Download a release for your platform from the [GitHub](https://github.com/keptn/keptn/releases)

1. Unpack the binary, rename and move it to a directory of your choice (e.g., `/usr/local/bin/`)

1. Verify that the installation has worked and that the version is correct by running:

    ```console
    keptn version
    ```

### 3. Install Keptn and authenticate Keptn CLI

* By executing the [keptn install](../0.7.x/reference/cli/commands/keptn_install) command as shown next, Keptn will be installed on your Kubernetes cluster supporting all continuous delivery use cases (including quality gates and automated operations):

    ```console
    keptn install --use-case=continuous-delivery
    ``` 

* After a successful installation, you need to expose Keptn. The official [install Keptn CLI](../0.7.x/operate/install/#install-keptn) guide provides different ways of exposing your Keptn. In this quick start, the port-forwarding mechanism from Kubernetes is applied: 

    ```console
    kubectl -n keptn port-forward service/api-gateway-nginx 8080:80
    ```

* When Keptn is exposed, the CLI can get authenticated: 

    ```console
    keptn auth --endpoint=http://localhost:8080 --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    ```

* Finally, verify that Keptn is working by executing:

    ```console
    keptn status
    ```

:rocket: Keptn is now ready to be used.

**Access Keptn Bridge**

By default, basic authentication is in place that protects the Keptn Bridge. 

* To get the `user` and `password`, execute the command:

    ```console
    keptn configure bridge --output
    ```

* To get the enpoint your Keptn is running on, execute the command: 

    ```console
    keptn status
    ```

* Consequently, follow the provided endpoint link and remove `api` at the end to get to the Keptn Bridge that will prompt for `user` and `password`. 

### 4. Explore tutorials to learn more about the Keptn use cases

With Keptn installed, have a look at the different [tutorials](https://tutorials.keptn.sh/) to learn hands-on about the Keptn use cases: 

<table class="highlight-table">
  <tr>
    <td colspan="6">
      <a href="https://tutorials.keptn.sh/?cat=full-tour">
        <strong>A full tour through Keptn: Continuous Delivery & Automated Operations</strong><br><br>
        Learn how to setup Keptn for a sample cloud native app where Keptn deploys, tests, validates, promotes and auto-remediates
      </a>
    </td>
  </tr>
  <tr>
    <td colspan="3" width="50%">
      <a href="https://tutorials.keptn.sh/?cat=quality-gates">
        <strong>Continuous Delivery with Deployment Validation</strong><br><br>
        Keptn deploys, tests, validates and promotes your artifacts across a multi-stage delivery process
      </a>
    </td>
    <td colspan="3">
      <a href="https://tutorials.keptn.sh/?cat=automated-operations">
        <strong>Automated Operations</strong><br><br>
        Keptn automates problem remediation in production through self-healing and runbook automation
      </a>
    </td>
  </tr>
  <tr>
    <td colspan="2" width="33%">
        <strong>Performance as a Self-Service</strong><br><br>
        Keptn deploys, tests and provides automated performance feedback of your artifacts
    </td>
    <td colspan="2" width="33%">
        <strong>Performance Testing as a Self-Service</strong><br><br>
        Let Keptn execute performance tests against your deployed software and provide automatic SLI/SLO based feedback
    </td>
    <td colspan="2">
        <strong>Deployment Validation (aka Quality Gates)</strong><br><br>
        Integrate Keptn into your existing CI/CD by automatically validating your monitored environment based on SLIs/SLOs
    </td>
  </tr>
</table>

### 5. Learn how Keptn works and how it can be adapted to your use cases

Review the documentaiton for a full reference on all Keptn cabilities and components and how they can be combined/extended to your needs:

- [Operate Keptn](../0.7.x//operate)
- [Manage Keptn](../0.7.x//manage)
- [Continuous Delivery](../0.7.x//continuous_delivery)
- [Quality Gates](../0.7.x//quality_gates)
- [Automated Operations](../0.7.x/automated_operations)
- [Custom Integrations](../0.7.x//integrations)

### 6. Do you need help?

Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLWMzNmM1NDc4MmE0MmQ0MDgwYzMzMDc4NjM5ODk0ZmFjNTE2YzlkMGE4NGU5MWUxODY1NTBjNjNmNmI1NWQ1NGY) for any questions that may arise.

### 7. Uninstall Keptn

```console
keptn uninstall
```
