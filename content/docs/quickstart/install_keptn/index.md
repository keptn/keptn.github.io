---
title: Download & Install keptn
description: Shows you how to download the keptn CLI and install it on your k8s platform
weight: 20
keywords: setup
---

## 1. Download and Install the Keptn CLI
```console
curl -o keptn-linux.tar https://github.com/keptn/keptn/releases/download/0.3.0/0.3.0_keptn-linux.tar
tar -zxvf keptn-linux.tar
chmod +x keptn
mv keptn /usr/local/bin/keptn
```

## 2. Install keptn on your k8s cluster
Depending on the type of k8s keptn install will prompt you different information in order to connect to your k8s cluster.
Keptn will also prompt you for a GitHub Organization, GitHub Username and Token as keptn follows GitOps where all configuration is stored in a repository in your GitHub Org.

### 2a. Install keptn on GKE
```console
keptn install --platform=gke
```
Keptn will prompt you for your GKE Cluster Name, Zone and Region in order to connect to your GKE cluster via gcloud.

### 2b. Install keptn on OpenShift 3.11:
```console
keptn install --platform=openshift
```
Keptn will prompt you for your OpenShift Server URL, user, password in order to connect via OC CLI.

### 2c. Install keptn on AKS:
```console
keptn install --platform=aks
```
Keptn will prompt you for your resource group and cluster name in order to connect with the AZ CLI

### 2d. Install keptn on other k8s distributions:
```console
keptn install --platform=kubernetes
```
Keptn assumes that kubectl is already connected to your k8s cluster and will run the installation there.