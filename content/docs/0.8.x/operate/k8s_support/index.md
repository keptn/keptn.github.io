---
title: Kubernetes Support
description: Keptn and Kubernetes compatibility overview.
weight: 30
keywords: [0.8.x-operate]
---

This document describes the maximum version skew supported between Keptn and Kubernetes.

## Supported Versions

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology. Please refer to the table below to determine what Keptn version is compatible with your cluster.

**Keptn Installations:**

* **Control Plane**: Keptn components to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. Install option: `keptn install`

* **Control & Execution Plane**: Keptn control plane including all Keptn-services for continuous delivery and automated operations. Install option: `keptn install --use-case=continuous-delivery`

<!-- use https://www.tablesgenerator.com/markdown_tables# for editing -->

| Keptn Version /<br>Installation                           | Kubernetes  | AKS                       | EKS         | GKE           | OpenShift   | K3s         | Minishift               |
|-----------------------------------------------------------|:-----------:|:-------------------------:|:-----------:|:-------------:|:-----------:|:-----------:|:------------------------|
| **0.8.x** / <br>Control & Execution Plane<br>*see: (3)*   | 1.19 - 1.16 | 1.16 - 1.15<br>*see: (1)* | 1.18 - 1.16 | 1.16 - 1.14   | 4, 3.11     | 1.19 - 1.16 | 1.34.2<br>(K8s: 1.11)   |
| **0.8.x** / <br>Control Plane                             | 1.19 - 1.16 | 1.16 - 1.15<br>*see: (1)* | 1.18 - 1.16 | 1.16 - 1.14   | 4, 3.11     | 1.19 - 1.16 | 1.34.2<br>(K8s: 1.11)   |

**Remarks**

* (1): AKS with K8s version before 1.15 might fail (see: [#1429](https://github.com/keptn/keptn/issues/1429)), due to a known AKS issue: [#69262](https://github.com/kubernetes/kubernetes/issues/69262)
* (2): Requires sufficient resources (e.g., >= 8 vCPUs and 14 GB memory for deploying sockshop in multiple stages) depending on your use-case and workloads.

**Notes:**

* It is not recommended to use Keptn with a version of Kubernetes that is newer than the version it was tested against, as Keptn does not make any forward-compatibility guarantees.
* If you choose to use Keptn with a version of Kubernetes that it does not support, you are using it at your own risk.
* Installing Keptn on lightweight Kubernetes platforms such as KIND, Minikube, Microk8s, etc... *might* work (we recommend using *K3s*), but is not tested nor guaranteed. Please refer to the column called *Kubernetes* for the basic supported Kubernetes version.

**Abbreviations:**

* **AKS** ... Azure Kubernetes Service
* **EKS** ... Amazon Elastic Kubernetes Service
* **GKE** ... Google Kubernetes Engine
* **K3s** ... A certified Kubernetes distribution built for IoT & Edge computing: [k3s.io](https://k3s.io/)

## Test Strategy for Kubernetes support

* With a new Keptn release, Keptn is tested based on the default K8s version of each Cloud Provider: AKS, EKS and GKE available at the release date.

* Internally, a test pipeline with newer Kubernetes versions is verifying the master branch of Keptn. Known-limitations identified by these tests are referenced at the corresponding Keptn release. 
