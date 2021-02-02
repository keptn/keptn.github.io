---
title: Kubernetes support & Cluster size
description: Keptn and Kubernetes compatibility overview.
weight: 30
keywords: [0.8.x-operate]
---

This document describes the maximum version skew supported between Keptn and Kubernetes.

## Supported Versions

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology. Please refer to the table below to determine what Keptn version is compatible with your cluster.

**Keptn Installations:**

* **Control plane**: Keptn components to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. Install option: `keptn install`

* **Control & Execution plane**: Keptn control plane including all Keptn-services for continuous delivery and automated operations. Install option: `keptn install --use-case=continuous-delivery`

<!-- use https://www.tablesgenerator.com/markdown_tables# for editing -->

| Keptn Version /<br>Installation                           | Kubernetes  | AKS                       | EKS         | GKE           | OpenShift   | K3s         | Minishift               |
|-----------------------------------------------------------|:-----------:|:-------------------------:|:-----------:|:-------------:|:-----------:|:-----------:|:------------------------|
| **0.8.x** / <br>Control & Execution plane<br>*see: (3)*   | 1.19 - 1.16 | 1.16 - 1.15<br>*see: (1)* | 1.18 - 1.16 | 1.16 - 1.14   | 4, 3.11     | 1.19 - 1.16 | 1.34.2<br>(K8s: 1.11)   |
| **0.8.x** / <br>Control plane                             | 1.19 - 1.16 | 1.16 - 1.15<br>*see: (1)* | 1.18 - 1.16 | 1.16 - 1.14   | 4, 3.11     | 1.19 - 1.16 | 1.34.2<br>(K8s: 1.11)   |

**Remarks:**

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

**Test Strategy for Kubernetes support:**

* With a new Keptn release, Keptn is tested based on the default K8s version of each Cloud Provider: AKS, EKS and GKE available at the release date.

* Internally, a test pipeline with newer Kubernetes versions is verifying the master branch of Keptn. Known-limitations identified by these tests are referenced at the corresponding Keptn release. 

## Cluster size

The size of the Keptn control- and execution plane has been derived automatically and is also reported at the latest release; see *Kubernetes Resource Data* at: https://github.com/keptn/keptn/releases

### Control plane

| Pod | Container | lim.cpu | lim.mem | req.cpu | req.mem |
|-----|-----------|---------|---------|---------|---------|
| api-gateway-nginx | api-gateway-nginx | 500m | 128Mi | 50m | 32Mi |
| api-service | api-service | 500m | 256Mi | 50m | 64Mi |
| api-service | distributor | 250m | 32Mi | 25m | 16Mi |
| bridge | bridge | 500m | 128Mi | 50m | 64Mi |
| configuration-service | configuration-service | 500m | 128Mi | 50m | 64Mi | 
| configuration-service | distributor | 250m | 32Mi | 25m | 16Mi |
| lighthouse-service | lighthouse-service | 500m | 1Gi | 50m | 128Mi |
| lighthouse-service | distributor | 250m | 32Mi | 25m | 16Mi |
| mongodb | mongodb | 100m | 300Mi | 50m | 64Mi |
| mongodb-datastore | mongodb-datastore | 500m | 128Mi | 50m | 32Mi |
| mongodb-datastore | distributor | 250m | 32Mi | 25m | 16Mi |
| remediation-service | remediation-service | 500m | 1Gi | 50m | 64Mi |
| remediation-service | distributor | 250m | 32Mi | 25m | 16Mi |
| shipyard-controller | shipyard-controller | 500m | 128Mi | 50m | 32Mi | 
| shipyard-controller | distributor | 250m | 32Mi | 25m | 16Mi | 
| statistics-service | statistics-service | 500m | 128Mi | 50m | 32Mi |
| statistics-service | distributor | 250m | 32Mi | 25m | 16Mi |
| **Sum:** | | **6350** | **3596** | **675** | **688** |

### Execution plane

| Pod | Container | lim.cpu | lim.mem | req.cpu | req.mem |
|-----|-----------|---------|---------|---------|---------|
| gatekeeper-service | gatekeeper-service | 500m | 128Mi | 50m | 32Mi |
| gatekeeper-service | distributor | 250m | 32Mi | 25m | 16Mi |
| helm-service | helm-service | 1 | 512Mi | 50m | 128Mi |
| helm-service | distributor | 250m | 32Mi | 25m | 16Mi |
| jmeter-service | jmeter-service | - | - | 50m | 64Mi |
| jmeter-service | distributor | 250m | 32Mi | 25m | 16Mi |
| **Sum:** | | **2250** | **736** | **225** | **272** |

