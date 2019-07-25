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
With keptn installed, jave a look at the different use cases like
