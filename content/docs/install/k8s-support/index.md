---
title: Kubernetes support & Cluster size
description: Keptn and Kubernetes compatibility overview and required cluster size.
weight: 20
aliases:
- /docs/0.19.x/operate/k8s_support/
- /docs/1.0.x/operate/k8s_support/
---

This document describes the maximum version skew supported between Keptn and Kubernetes.

## Supported Versions

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology. Please refer to the table below to determine what Keptn version is compatible with your cluster.

**Keptn Installations:**

* **Control plane**: Keptn components to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. Install option: `keptn install`

* **Control & Execution plane**: Keptn control plane including all Keptn-services for continuous delivery and automated operations. Install option: `keptn install --use-case=continuous-delivery`

<!-- use https://www.tablesgenerator.com/markdown_tables# for editing -->

| Keptn Version /<br>Installation                           | Kubernetes  | AKS                       | EKS                       | GKE           | OpenShift   | K3s         | Minishift               |
|-----------------------------------------------------------|:-----------:|:-------------------------:|:-------------------------:|:-------------:|:-----------:|:-----------:|:------------------------|
| **0.18.x**, **0.19.x** / <br>Control & Execution plane<br>*see: (1)*   | 1.24 - 1.17 | 1.24 - 1.19 | 1.24 - 1.19 | 1.24 - 1.19   | 4, 3.11     | 1.24 - 1.19 | 1.34.2<br>(K8s: 1.11)   |
| **0.18.x**, **0.19.x** / <br>Control plane                             | 1.24 - 1.17 | 1.24 - 1.19 | 1.24 - 1.19 | 1.24 - 1.19   | 4, 3.11     | 1.24 - 1.19 | 1.34.2<br>(K8s: 1.11)   |

**Remarks:**

* (1): Requires sufficient resources (e.g., >= 8 vCPUs and 14 GB memory for deploying sockshop in multiple stages) depending on your use-case and workloads.

**Notes:**

* It is not recommended to use Keptn with a version of Kubernetes that is newer than the version it was tested against, as Keptn does not make any forward-compatibility guarantees.
* If you choose to use Keptn with a version of Kubernetes that it does not support, you are using it at your own risk.
* Installing Keptn on lightweight Kubernetes platforms such as KIND, Minikube, Microk8s, etc... *might* work (we recommend using *K3s*), but is not tested nor guaranteed. Please refer to the column called *Kubernetes* for the basic supported Kubernetes version.

**Abbreviations:**

* **AKS** ... Azure Kubernetes Service
* **EKS** ... Amazon Elastic Kubernetes Service
* **GKE** ... Google Kubernetes Engine
* **K3s** ... A certified Kubernetes distribution built for IoT & Edge computing: [k3s.io](https://k3s.io/)
* **K3d** ... A lightweight wrapper that runs k3s (Rancher Lab’s minimal Kubernetes distribution) in Docker: [k3d.io](https://k3d.io/v5.3.0/)

**Test Strategy for Kubernetes support:**

* With a new Keptn release, Keptn is tested based on the default Kubernetes version of each Cloud Provider: AKS, EKS and GKE available at the release date.

* Internally, a test pipeline with newer Kubernetes versions is verifying the master branch of Keptn. Known-limitations identified by these tests are referenced at the corresponding Keptn release.

## Cluster size

The size of the Keptn control plane has been derived automatically and is also reported at the latest release; see *Kubernetes Resource Data* at: [https://github.com/keptn/keptn/releases](https://github.com/keptn/keptn/releases).

The predefined resource values for the Keptn services are available in the [Helm Charts](https://github.com/keptn/keptn/blob/0.17.0/installer/manifests/keptn/charts/control-plane/templates/core.yaml).

As a rule of thumb, Keptn control plane will run with 2 vCPUs, 4 GB of memory and roughly 10 GB of additional disk space (Docker Images + Persistent Volumes).
For execution plane services with continuous-delivery support, your Kubernetes cluster requires additional resources.
This depends on the number of projects and workloads you deploy, as well as the number of stages in your Shipyard, and whether you are using direct or blue-green deployments.

In particular, with growing the number of projects and their size, it is recommended to increase:

* the CPU limits of *shipyard-controller* and *resource-service*, and
* the RAM limits of *resource-service*.

As guidance, we ran a stress test of a Keptn installation with 50 projects, each project having 5 stages and 50 services. Every second we run an evaluation sequence for a total of 5000 sequences.
During the execution, we observed *shipyard-controller* to require 1 full CPU and roughly 180MB of RAM. Similarly, the *resource-service* required around 3 CPUs and 240MB of RAM. 

