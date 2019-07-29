---
title: Quick Start
description: Learn how to get keptn running in five minutes.
weight: 1
icon: setup
layout: quickstart
menu: main
---

### 1. Setup your platform

* [Preparing Google Kubernetes Engine (GKE)](/docs/quickstart/setup_platform/setup_gke)
* [Preparing Amazon Kubernetes Engine (AKS)](/docs/quickstart/setup_platform/setup_aks)
* [Preparing OpenShift](/docs/quickstart/setup_platform/setup_openshift)

### 2. Install keptn

#### 2.1 Install the keptn CLI
The keptn CLI is the one-stop-shop for all operations related to keptn.

##### 2.1.1 Automatic install of the keptn CLI (Linux and Mac)
```console
curl -sL https://get.keptn.sh | sudo -E bash
```

This will download the keptn CLI, unpack it and move it to `/usr/local/keptn`.

##### 2.1.2 Manual install of the keptn CLI
1. Download a a release for your platform from the [release page](https://github.com/keptn/keptn/releases)
2. Unpack it
3. Run `keptn`


#### 3. Run the keptn installer
Depending on the platform, keptn install will prompt you different information needed to perform the installation.
Keptn will also prompt you for a GitHub Organization, GitHub Username and Token as keptn follows GitOps where all configuration is stored in a repository in your GitHub Org.

```console
keptn install --platform=[gke|aks|openshift|kubernetes]
```

keptn is now ready to be used.

### 4. Explore the usecases
With keptn installed, have a look at the different [use cases](/docs/0.4.0/usecases) like

* [Onboarding a new service](/docs/0.4.0/usecases/onboard-carts-service/)
* [Using quality gates for deployments](/docs/0.4.0/usecases/deployments-with-quality-gates/)
* [Runbook automation and self-healing](/docs/0.4.0/usecases/runbook-automation-and-self-healing/)
* [Unbreakable delivery](/docs/0.4.0/usecases/unbreakable-delivery-pipeline/)

### 5. Learn how keptn works under the hood and how it can be adapted to your usecases
Review the [reference documentation](/docs/0.4.0/) for a full reference on all components of keptn and how they can be combined and extended to your needs.

### 6. In case you need help
Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLTcxMzE0OWU1YzU5YjY3NjFhYTJlZTNjOTZjY2EwYzQyYWRkZThhY2I3ZDMzN2MzOThkZjIzOTdhOGViMDNiMzI) for any questions that may arise.

### 7. Uninstalling keptn
##### 7.1. Clone Installer Repo
```console
git  clone --branch 0.4.0 https://github.com/keptn/installer
```

##### 7.2a. Uninstall for GKE, AKS, k8s
```console
cd  ./installer/scripts/common
./uninstallKeptn.sh
```

##### 7.2b. Uninstall for OpenShift
```console
cd  ./installer/scripts/openshift
./uninstallKeptn.sh
```