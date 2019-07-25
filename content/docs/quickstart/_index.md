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
##### 2.1. Download and Install the Keptn CLI
```console
curl -o keptn-linux.tar https://github.com/keptn/keptn/releases/download/0.3.0/0.3.0_keptn-linux.tar
tar -zxvf keptn-linux.tar
chmod +x keptn
mv keptn /usr/local/bin/keptn
```

##### 2.2. Run the keptn installer
Depending on the platform, keptn install will prompt you different information needed to perform the installation.
Keptn will also prompt you for a GitHub Organization, GitHub Username and Token as keptn follows GitOps where all configuration is stored in a repository in your GitHub Org.

```console
keptn install --platform=[gke|aks|openshift|kubernetes]
```

keptn is now ready to be used.

### 3. Explore the usecases
With keptn installed, jave a look at the different [use cases](/docs/0.4.0/usecases) like

* [Onboarding a new service](/docs/0.4.0/usecases/onboard-carts-service/)
* [Using quality gates for deployments](/docs/0.4.0/usecases/deployments-with-quality-gates/)
* [Runbook automation and self-healing](/docs/0.4.0/usecases/runbook-automation-and-self-healing/)
* [Unbreakable delivery](/docs/0.4.0/usecases/unbreakable-delivery-pipeline/)

### 4. Learn how keptn works under the hood and how it can be adapted to your usecases
Review the [reference documentation](/docs/0.4.0/) for a full reference on all components of keptn and how they can be combined and extended to your needs.

### 5. In case you need help
Join [our slack channel](https://join.slack.com/t/keptn/shared_invite/enQtNTUxMTQ1MzgzMzUxLTcxMzE0OWU1YzU5YjY3NjFhYTJlZTNjOTZjY2EwYzQyYWRkZThhY2I3ZDMzN2MzOThkZjIzOTdhOGViMDNiMzI) for any questions that may arise.

### 6. Uninstalling keptn
##### 6.1. Clone Installer Repo
```console
git  clone --branch 0.3.0 https://github.com/keptn/installer
```

##### 6.2a. Uninstall for GKE, AKS, k8s
```console
cd  ./installer/scripts/common
./uninstallKeptn.sh
```

##### 6.2b. Uninstall for OpenShift
```console
cd  ./installer/scripts/openshift
./uninstallKeptn.sh
```