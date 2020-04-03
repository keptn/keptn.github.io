---
title: Kubernetes Support
description: Keptn and Kubernetes compatibility overview
weight: 30
keywords: setup
---

This document describes the maximum version skew supported between Keptn and Kubernetes.^

## Supported Version Skew

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology.

Please refer to the tables below to determine what Keptn version is compatible with your cluster.

| Keptn Version | Supported Kubernetes Versions |
| --- | --- |
| 0.6.x | 1.15.x - 1.14.x |

**Notes:**

* It is not recommended to use Keptn with a version of Kubernetes that is newer than the version it was tested against, as Keptn does not make any forward compatiblility guarantees.

* If you choose to use Keptn with a version of Kubernetes that it does not support, you are using it at your own risk.

### Azure Kubernetes Service (AKS) 

| Keptn Version | Supported AKS Versions |
| --- | --- |
| 0.6.x | 1.15.x - 1.14.x |

### Amazon Elastic Kubernetes Service (EKS)

| Keptn Version | Supported EKS Versions |
| --- | --- |
| 0.6.x | 1.15.x - 1.14.x |

### Google Kubernetes Engine (GKE)

| Keptn Version | Supported GKE Versions |
| --- | --- |
| 0.6.x | 1.15.x - 1.14.x |

### OpenShift

| Keptn Version | OpenShift Versions |
| --- | --- |
| 0.6.x | 3.11 |

### Minikube

| Keptn Version | Minikube |
| --- | --- |
| 0.6.x | 1.2 |

### MicroK8s (experimental)

| Keptn Version | MicroK8s |
| --- | --- |
| 0.6.x | 1.2 |

### Minishift (experimental)

| Keptn Version | Minishift |
| --- | --- |
| 0.6.x | ? |
