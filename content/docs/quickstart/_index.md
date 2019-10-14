---
title: Quick Start
description: Learn how to get keptn running in five minutes.
weight: 1
icon: setup
layout: quickstart
menu: main
---

### 1. Setup your platform

* [Preparing Azure Kubernetes Engine (AKS)](/docs/quickstart/setup_platform/setup_aks)
* [Preparing Amazon Elastic Kubernetes Service (EKS)](/docs/quickstart/setup_platform/setup_eks)
* [Preparing Google Kubernetes Engine (GKE)](/docs/quickstart/setup_platform/setup_gke)
* [Preparing OpenShift](/docs/quickstart/setup_platform/setup_openshift)
* [Preparing Pivotal Container Service (PKS)](/docs/quickstart/setup_platform/setup_pks)

### 2. Install Keptn

#### 2.1 Install the Keptn CLI
The Keptn CLI is the one-stop-shop for all operations related to Keptn.

##### 2.1.1 Automatic install of the Keptn CLI (Linux and Mac)
```console
curl -sL https://get.keptn.sh | sudo -E bash
```

This will download the *latest version*, unpack it and move it to `/usr/local/bin/keptn`.

##### 2.1.2 Manual install of the Keptn CLI
1. Download a release for your platform from the [release page](https://github.com/keptn/keptn/releases)
2. Unpack it
3. Run `keptn`


#### 3. Run the Keptn installer
Depending on the platform, Keptn install will prompt you different information needed to perform the installation.

```console
keptn install --platform=[aks|eks|gke|openshift|pks|kubernetes]
```

Keptn is now ready to be used.

### 4. Explore the usecases
With Keptn installed, have a look at the different [use cases](/docs/0.5.0/usecases) like

* [Onboarding a new Service](/docs/0.5.0/usecases/onboard-carts-service/)
* [Using Quality Gates for Deployments](/docs/0.5.0/usecases/deployments-with-quality-gates/)
* [Self-healing with Keptn](/docs/0.5.0/usecases/self-healing-with-keptn/)
* [Runbook Automation](/docs/0.5.0/usecases/runbook-automation-and-self-healing/)
* [Unbreakable Delivery](/docs/0.5.0/usecases/unbreakable-delivery-pipeline/)

### 5. Learn how Keptn works under the hood and how it can be adapted to your usecases
Review the [reference documentation](/docs/0.5.0/) for a full reference on all components of Keptn and how they can be combined and extended to your needs.

### 6. In case you need help
Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLTcxMzE0OWU1YzU5YjY3NjFhYTJlZTNjOTZjY2EwYzQyYWRkZThhY2I3ZDMzN2MzOThkZjIzOTdhOGViMDNiMzI) for any questions that may arise.

### 7. Uninstalling Keptn
```console
keptn uninstall
```
