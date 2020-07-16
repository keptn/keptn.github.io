---
title: Quick Start
description: Learn how to get Keptn running in five minutes.
icon: concepts
layout: quickstart
weight: 1
hidechildren: true # this flag hides all sub pages in the sidebar-multicard.html
---

### 1. Setup Kubernetes cluster

Select one of the following options:

<details><summary>Google Kubernetes Engine (GKE)</summary>
<p>

Run your Keptn installation for free on GKE!
If you [sign up for a Google Cloud account](https://console.cloud.google.com/getting-started), Google gives you an initial $300 credit. For deploying Keptn you can apply for an additional $200 credit which you can use towards that GKE cluster needed to run Keptn.<br><br>
<a class="button button-primary" href="https://bit.ly/keptngkecredit" target="_blank">Apply for your credit here</a>

1. Install local tools
  - [gcloud](https://cloud.google.com/sdk/gcloud/)
  - [python 2.7](https://www.python.org/downloads/release/python-2716/) (required for Ubuntu 19.04)

2. Create GKE cluster
  - [Master version](../operate/k8s_support/#supported-versions): `1.15.x` (tested version: `1.15.9-gke.22`)
  - One **n1-standard-8** node
  - Image type `Ubuntu` or `COS` (**Note:** If you plan to use Dynatrace monitoring, select `Ubuntu` for a more [convenient setup](../monitoring/dynatrace/install/#notes).)
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


<details><summary>K3s</summary>
<p>

**Note**: Please refer to the [official homepage of K3s](https://k3s.io) for detailed installation instructions. Within 
 this page we only provide a very short guide on how we run Keptn on K3s.
 
1. Download, install [K3s](https://k3s.io/) (tested with [versions 1.16 to 1.18](../operate/k8s_support/#supported-versions)) and run K3s using the following command:
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

<details><summary>Other options</summary>
<p>
We also support installation on the following platforms:

* AWS Elastic Kubernetes Service (EKS)
* Azure Kubernetes Service (AKS)
* Minikube
* OpenShift 3.11
* Pivotal Container Service

For details on these, please visit our [detailed installation guide](../operate/install/).

</p>
</details>

### 2. Install Keptn

The following instructions will install the **latest stable Keptn CLI (0.6.2)** in a quick way. Please also look 
at our [detailed installation guide for Keptn](../operate/install/) if you need more information.

#### 2.1 Install the Keptn CLI
The Keptn CLI is the one-stop-shop for all operations related to Keptn.

Please make sure you have `kubectl` installed (see [kubernetes.io/docs/tasks/tools/install-kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)).

##### 2.1.1 Automatic install of the Keptn CLI (Linux and Mac)
1. This will download the *latest stable Keptn version* from [GitHub](https://github.com/keptn/keptn/releases), unpack it and move it to `/usr/local/bin/keptn`.
```console
curl -sL https://get.keptn.sh | sudo -E bash
```

2. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

##### 2.1.2 Manual install of the Keptn CLI
1. Download a release for your platform from the [release page](https://github.com/keptn/keptn/releases)

1. Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)

1. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

#### 3. Run the Keptn installer
Depending on the platform, Keptn install will prompt you different information needed to perform the installation.

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes] --use-case=continuous-delivery
```
**Note:** For a Minikube setup, use option `--platform=kubernetes`.

This will install the full version of Keptn supporting all continuous-delivery use cases. 
After a successful installation, you can verify that Keptn is working by executing

```console
keptn status
```

Keptn is now ready to be used.

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

- [Operate Keptn](../operate)
- [Manage Keptn](../manage)
- [Continuous Delivery](../continuous_delivery)
- [Quality Gates](../quality_gates)
- [Automated Operations](../automated_operations)
- [Custom Integrations](../integrations)

### 6. You need help?

Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLWMzNmM1NDc4MmE0MmQ0MDgwYzMzMDc4NjM5ODk0ZmFjNTE2YzlkMGE4NGU5MWUxODY1NTBjNjNmNmI1NWQ1NGY)
 for any questions that may arise.

### 7. Uninstall Keptn

```console
keptn uninstall
```
