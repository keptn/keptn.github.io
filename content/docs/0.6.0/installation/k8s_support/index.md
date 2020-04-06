---
title: Kubernetes Support
description: Keptn and Kubernetes compatibility overview
weight: 30
keywords: setup
---

This document describes the maximum version skew supported between Keptn and Kubernetes.^

## Supported Version Skew

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology. Please refer to the table below to determine what Keptn version is compatible with your cluster.

**Keptn Installations:**

* **Control Plane**: Keptn components to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. Install option: `keptn install --use-case=quality-gates`
* **Control & Execution Plane**: Keptn control plane including all Keptn-services for continuous delivery and automated operations. Install option: `keptn install`

| Keptn Version /<br>Installation       | Kubernetes      | AKS    | EKS             | GKE             | OpenShift | Minikube | MicroK8s<br>(experimental) | Minishift<br>(experimental) |
|---------------------------------------|-----------------|--------|-----------------|-----------------|-----------|----------|----------------------------|-----------------------------|
| 0.6.x / <br>Control & Execution Plane | 1.15.x - 1.13.x | 1.15.x | 1.15.x - 1.14.x | 1.15.x - 1.13.x | 3.11      | 1.2      | 1.15.x - 1.13.x            | 1.34.2                      |
| 0.6.x / <br>Control Plane             | 1.15.x - 1.13.x | 1.15.x | 1.15.x - 1.14.x | 1.15.x - 1.13.x | 3.11      | 1.2      | 1.15.x - 1.13.x            | 1.34.2                      |

**Notes:**

* It is not recommended to use Keptn with a version of Kubernetes that is newer than the version it was tested against, as Keptn does not make any forward-compatibility guarantees.

* If you choose to use Keptn with a version of Kubernetes that it does not support, you are using it at your own risk.

**Abbreviations:**

* **AKS** ... Azure Kubernetes Service
* **EKS** ... Amazon Elastic Kubernetes Service
* **GKE** ... Google Kubernetes Engine
