---
title: Quick Start
description: Learn how to get Keptn running in five minutes.
icon: concepts
layout: quickstart
weight: 1
---

### 1. Setup your platform

**Note**: For running the tutorials with Keptn 0.5 and newer, we recommend using a cluster with at least **6 vCPUs** and **12 GB memory**.

* [Preparing Azure Kubernetes Engine (AKS)](/docs/quickstart/setup_platform/setup_aks)
* [Preparing Amazon Elastic Kubernetes Service (EKS)](/docs/quickstart/setup_platform/setup_eks)
* [Preparing Google Kubernetes Engine (GKE)](/docs/quickstart/setup_platform/setup_gke)
* [Preparing Minikube](/docs/quickstart/setup_platform/setup_minikube)
* [Preparing OpenShift](/docs/quickstart/setup_platform/setup_openshift)
* [Preparing Pivotal Container Service (PKS)](/docs/quickstart/setup_platform/setup_pks)

### 2. Install Keptn

The following instructions will install the **latest stable Keptn CLI (0.6.2)** in a quick way. Please also look 
at our [detailed installation guide for Keptn 0.6.2](/docs/0.6.0/installation/setup-keptn/) if you need more information.

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
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes]
```
**Note:** For a Minikube setup, use option `--platform=kubernetes`.

After a successful installation, you can verify that Keptn is working by executing

```console
keptn status
```

Keptn is now ready to be used.

### 4. Explore the use cases
With Keptn installed, have a look at the different [tutorials](/docs/0.6.0/usecases) like:

* [Onboarding a new Service](/docs/0.6.0/usecases/onboard-carts-service/)
* [Deployments with Quality Gates](/docs/0.6.0/usecases/deployments-with-quality-gates/)
* [Self-healing with Keptn](/docs/0.6.0/usecases/self-healing-with-keptn/)
* [Runbook Automation](/docs/0.6.0/usecases/runbook-automation-and-self-healing/)

### 5. Learn how Keptn works under the hood and how it can be adapted to your use cases
Review the [reference documentation](/docs/0.6.0/) for a full reference on all components of Keptn and how they can be combined and extended to your needs.

### 6. You need help?
Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLWMzNmM1NDc4MmE0MmQ0MDgwYzMzMDc4NjM5ODk0ZmFjNTE2YzlkMGE4NGU5MWUxODY1NTBjNjNmNmI1NWQ1NGY)
 for any questions that may arise.

### 7. Uninstall Keptn

```console
keptn uninstall
```
