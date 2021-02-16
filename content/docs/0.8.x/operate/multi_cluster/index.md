---
title: Multi-cluster setup
description: Install Keptn control-plane and execution-plane separately.
weight: 60
keywords: [0.8.x-operate]
---


## Overview of an example setup

{{< popup_image
link="./assets/multi_cluster.png"
caption="Multi-cluster setup"
width="800px">}}

* **Keptn Control plane**
  * The control plane is the minimum set of components, which are required to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points.
  * The control plane orchestrates the task sequences defined in Shipyard, but does not actively execute the tasks.
  * Minimum [Cluster size](./k8s_support/#control-plane)

* **Keptn Execution plane**
  * The execution plane consists of all Keptn-services that are required to process all tasks (like deployment, test, etc.).
  * The execution plane is the cluster where you deploy your application too and execute certain tasks of a task sequence. 
  * Minimum [Cluster size](./k8s_support/#execution-plane)

## Create or bring two (or more) Kubernetes clusters

To operate Keptn in a multi-cluster setup, you need obviously at least two Kubernetes clusters: 
1. One that runs Keptn as control-plane
2. The second one that runs the execution-plane services for deploying, testing, executing remediation actions, etc.

* To create a Kubernetes cluster, please follow the instructions [here](../install/#create-or-bring-a-kubernetes-cluster).

## Prerequisites

* [keptn CLI](../install/#install-keptn-cli)
* [helm CLI](https://helm.sh/docs/intro/install/)

## Install Keptn Control plane

The **Control Plane** of Keptn is responsible for orchestrating your processes for Continous Delivery or Automated Operations.

* But before installing Keptn on your cluster, please also consider how you would like to expose Keptn.
Kubernetes provides the following four options:

  * Option 1: Expose Keptn via an **LoadBalancer**
  * Option 2: Expose Keptn via a **NodePort**
  * Option 3: Expose Keptn via a **Ingress**
  * Option 4: Access Keptn via a **Port-forward**

    The next figure shows an overview of the four ways to expose Keptn:

    {{< popup_image
    link="./assets/installation_options.png"
    caption="Installation options"
    width="1000px">}}

* Please make yourself familiar with the ways of exposing Keptn as explained [here](../install/#create-or-bring-a-kubernetes-cluster). Then come back and continue installing Keptn control-plane.

* To install the control plane , execute `keptn install` with the option you chose for exposing Keptn:

    ```console
    keptn install --endpoint-service-type=[LoadBalancer, NodePort, ClusterIP]
    ```

## Install Keptn Execution plane

In this release of Keptn, the execution plane services for deployment (`helm-service`) and testing (`jmeter-service`) can be installed via Helm Charts. Please find the Helm Charts here: 
- `helm-service`: 
- `jmeter-service`: 

* Download the Helm Charts 


* Adapt the Helm Charts to connect the services to the Keptn control-plane, identified by its endpoint and API token: 


* Deploy the execution plane services using `helm`

  ```console
  helm upgrade 
  ```

### Troubleshooting Execution plane

#### Are services connected to the Control plane? 
