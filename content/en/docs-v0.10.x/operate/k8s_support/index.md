---
title: Kubernetes support & Cluster size
description: Keptn and Kubernetes compatibility overview and required cluster size.
weight: 70
keywords: [0.10.x-operate]
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
| **0.10.x** / <br>Control & Execution plane<br>*see: (3)*   | 1.21 - 1.16 | 1.20 - 1.15<br>*see: (1)* | 1.18 - 1.16<br>*see: (2)* | 1.19 - 1.15   | 4, 3.11     | 1.21 - 1.16 | 1.34.2<br>(K8s: 1.11)   |
| **0.10.x** / <br>Control plane                             | 1.21 - 1.16 | 1.20 - 1.15<br>*see: (1)* | 1.18 - 1.16<br>*see: (2)* | 1.19 - 1.15   | 4, 3.11     | 1.21 - 1.16 | 1.34.2<br>(K8s: 1.11)   |

**Remarks:**

* (1): AKS with K8s version before 1.15 might fail (see: [#1429](https://github.com/keptn/keptn/issues/1429)), due to a known AKS issue: [#69262](https://github.com/kubernetes/kubernetes/issues/69262)
* (2): EKS did not provide K8s 1.19 clusters for testing (checked on: 3rd March, 2021)
* (3): Requires sufficient resources (e.g., >= 8 vCPUs and 14 GB memory for deploying sockshop in multiple stages) depending on your use-case and workloads.

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

As a rule of thumb, Keptn control-plane will run with 2 vCPUs, 4 GB of memory and roughly 10 GB of additional disk space (Docker Images + Persistent Volumes).
For execution plane services with continuous-delivery support, your Kubernetes cluster requires additional resources.
This depends on the number of projects and workloads you deploy, as well as the number of stages in your Shipyard, and whether you are using direct or blue-green deployments.

### Control plane

| Pod | Container | Memory (requested) | CPU (requested) | Memory (limit) | CPU (limit) | Images |
|-----|-----------|--------------------|-----------------|----------------|-------------|--------|
| api-gateway-nginx | api-gateway-nginx | 64Mi | 50m | 128Mi | 250m | docker.io/nginxinc/nginx-unprivileged:1.19.4-alpine | 
| api-service | api-service | 64Mi | 50m | 256Mi | 500m | docker.io/keptn/api:0.9.0 | 
| api-service | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 |
| bridge | bridge | 64Mi | 50m | 128Mi | 500m | docker.io/keptn/bridge2:0.9.0 | 
| configuration-service | configuration-service | 64Mi | 50m | 128Mi | 500m | docker.io/keptn/configuration-service:0.9.0 |
| lighthouse-service | lighthouse-service | 128Mi | 50m | 1Gi | 500m | docker.io/keptn/lighthouse-service:0.9.0 | 
| lighthouse-service | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 
| mongodb | mongodb | 64Mi | 50m | 300Mi | 100m | docker.io/centos/mongodb-36-centos7:1 | 
| mongodb-datastore | mongodb-datastore | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/mongodb-datastore:0.9.0 | 
| mongodb-datastore | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 
| remediation-service | remediation-service | 64Mi | 50m | 1Gi | 500m | docker.io/keptn/remediation-service:0.9.0 | 
| remediation-service | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 
| secret-service | secret-service | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/secret-service:0.9.0 | 
| shipyard-controller | shipyard-controller | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/shipyard-controller:0.9.0 | 
| shipyard-controller | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 
| statistics-service | statistics-service | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/statistics-service:0.9.0 | 
| statistics-service | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 


### Execution plane

| Pod | Container | Memory (requested) | CPU (requested) | Memory (limit) | CPU (limit) | Images |
|-----|-----------|--------------------|-----------------|----------------|-------------|--------|
| approval-service | approval-service | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/approval-service:0.9.0 | 
| approval-service | distributor | 16Mi | 25m | 32Mi | 250m | docker.io/keptn/distributor:0.9.0 | 
| helm-service | helm-service | 128Mi | 50m | 512Mi | 1 | docker.io/keptn/helm-service:0.9.0 | 
| helm-service | distributor | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/distributor:0.9.0 | 
| jmeter-service | jmeter-service | 768Mi | 1 | - | - | docker.io/keptn/jmeter-service:0.9.0 | 
| jmeter-service | distributor | 32Mi | 50m | 128Mi | 500m | docker.io/keptn/distributor:0.9.0 | 
