---
title: Kubernetes support & Cluster size
description: Keptn and Kubernetes compatibility overview.
weight: 30
keywords: [0.7.x-operate]
---

This document describes the maximum version skew supported between Keptn and Kubernetes.

## Supported Versions

Keptn versions are expressed as `x.y.z`, where `x` is the major version, `y` is the minor version, and `z` is the patch version, following [Semantic Versioning](https://semver.org/spec/v2.0.0.html) terminology. Please refer to the table below to determine what Keptn version is compatible with your cluster.

**Keptn Installations:**

* **Control Plane**: Keptn components to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. Install option: `keptn install`

* **Control & Execution Plane**: Keptn control plane including all Keptn-services for continuous delivery and automated operations. Install option: `keptn install --use-case=continuous-delivery`

<!-- use https://www.tablesgenerator.com/markdown_tables# for editing -->

| Keptn Version /<br>Installation                         | Kubernetes        | AKS               | EKS                   | GKE               | OpenShift   | K3s         | Minikube                                         | MicroK8s       | Minishift                 |
|---------------------------------------------------------|:-----------------:|:-----------------:|:---------------------:|:-----------------:|:-----------:|:-----------:|:------------------------------------------------:|:--------------:|:--------------------------|
| **0.7.x** / <br>Control & Execution Plane<br>*see: (3)* | 1.19 - 1.14 | 1.16 - 1.15<br>*see: (1)* | 1.16 - 1.14         | 1.17 - 1.14       | 4, 3.11     | 1.19 - 1.16 | 1.10.1<br>(K8s:1.18.2) -<br> 1.3.1<br>(K8s:1.15) | -              | 1.34.2<br>(K8s: 1.11)     |
| **0.7.x** / <br>Control Plane                           | 1.19 - 1.14 | 1.16 - 1.15<br>*see: (1)* | 1.16 - 1.14         | 1.17 - 1.14       | 4, 3.11     | 1.19 - 1.16 | 1.10.1<br>(K8s:1.18.2) -<br> 1.3.1<br>(K8s:1.15) | 1.19 - 1.16    | 1.34.2<br>(K8s: 1.11)     |
| 0.6.x / <br>Control & Execution Plane              | 1.15 - 1.13 | 1.15<br>*see: (1)*        | 1.15 - 1.14<br>*see: (2)* | 1.15 - 1.14<br>*see: (2)* | 3.11 | -         | -                                                | -              | 1.34.2<br>(K8s: 1.11)     |
| 0.6.x / <br>Control Plane                          | 1.16 - 1.13 | 1.16 - 1.15<br>*see: (1)* | 1.15 - 1.14<br>*see: (2)* | 1.15 - 1.14<br>*see: (2)* | 3.11 | -         | 1.2<br>(K8s:1.15)                                | 1.18           | 1.34.2<br>(K8s: 1.11)     |

**Remarks:**

* (1): AKS with K8s version before 1.15 might fail (see: [#1429](https://github.com/keptn/keptn/issues/1429)), due to a known AKS issue: [#69262](https://github.com/kubernetes/kubernetes/issues/69262)
* (2): GKE and EKS did not provide K8s 1.16 clusters for testing (checked on: 9th April, 2020)
* (3): Requires sufficient resources (e.g., >= 8 vCPUs and 14 GB memory for deploying sockshop in multiple stages) depending on your use-case and workloads.

**Notes:**

* It is not recommended to use Keptn with a version of Kubernetes that is newer than the version it was tested against, as Keptn does not make any forward-compatibility guarantees.
* If you choose to use Keptn with a version of Kubernetes that it does not support, you are using it at your own risk.

**Abbreviations:**

* **AKS** ... Azure Kubernetes Service
* **EKS** ... Amazon Elastic Kubernetes Service
* **GKE** ... Google Kubernetes Engine
* **K3s** ... A certified Kubernetes distribution built for IoT & Edge computing: [k3s.io](https://k3s.io/)

**Test Strategy for Kubernetes support:**

* With a new Keptn release, Keptn is tested based on the default K8s version of each Cloud Provider: AKS, EKS and GKE available at the release date.

* Internally, a test pipeline with newer Kubernetes versions is verifying the master branch of Keptn. Known-limitations identified by these tests are referenced at the corresponding Keptn release. 

## Cluster size

Please note that the size of the Keptn control- and execution plane have been derived manually based on the last release.

### Keptn control plane

| Deployment                          	| Memory (requested) 	| CPU (requested) 	| Memory (limit) 	| CPU (limit) 	| Storage 	|
|-------------------------------------	|:------------------:	|:----------------:	|:--------------:	|:------------:	|:--------:	|
| api-gateway-nginx                   	| 32                 	| 50              	| 128            	| 500         	|         	|
| api-service                         	| 64                 	| 50              	| 256            	| 500         	|         	|
| bridge                              	| 64                 	| 50              	| 128            	| 500         	|         	|
| configuration-service               	| 64                 	| 50              	| 128            	| 500         	|         	|
| configuration-service > distributor 	| 32                 	| 50              	| 128            	| 500         	|         	|
| configuration-volume                	|                    	|                 	|                	|             	| 100Mi   	|
| eventbroker-go                      	| 32                 	| 50              	| 128            	| 500         	|         	|
| lighthouse-service                  	| 128                	| 50              	| 1024           	| 500         	|         	|
| lighthouse-service > distributor    	| 32                 	| 50              	| 128            	| 500         	|         	|
| mongodb                             	| 64                	| 50              	| 300            	| 100         	|         	|
| mongodata                           	|                    	|                 	|                	|             	| 5Gi     	|
| mongodb-datastore                   	| 32                 	| 50              	| 128            	| 500         	|         	|
| mongodb-datastore > distributor     	| 32                 	| 50              	| 128            	| 500         	|         	|
| remediation-service                 	| 64                 	| 50              	| 1024           	| 500         	|         	|
| remediation-service > distributor   	| 32                 	| 50              	| 128            	| 500         	|         	|
| shipyard-service                    	| 32                 	| 50              	| 128            	| 500         	|         	|
| shipyard-service > distributor      	| 32                 	| 50              	| 128            	| 500         	|         	|
| **Sum:**                             	| **736**           	| **750**          	| **4012**       	| **7100**     	|         	|

### Keptn execution plane

| Deployment                          	| Memory (requested) 	| CPU (requested) 	| Memory (limit) 	| CPU (limit) 	| Storage 	|
|-------------------------------------	|:------------------:	|:----------------:	|:--------------:	|:------------:	|:--------:	|
| gatekeeper-service               	    | 32  	              | 50 	              | 128            	| 500          	|         	|
| gatekeeper-service > distributor    	| 32  	              | 50 	              | 128 	          | 500         	|         	|
| helm-service                        	| 128               	| 50              	| 512            	| 1000 	        |         	|
| helm-service > distributor          	| 32                	| 50              	| 128           	| 500         	|         	|
| jmeter-service                      	| -                   | -   	            | -               | -            	|         	|
| jmeter-service > distributor        	| 32                	| 50 	              | 128           	| 500         	|         	|
| **Sum:**                             	| **256**            	| **250**          	| **1024**       	| **3000**     	|         	|
