---
title: Multi-cluster setup
description: Install Keptn control-plane and execution-plane separately.
weight: 40
keywords: [0.8.x-operate]
---


## Overview of an example setup

    {{< popup_image
    link="./assets/multi_cluster.png"
    caption="Multi-cluster setup"
    width="300px">}}


> Explanation is missing

## Create or bring two (or more) Kubernetes clusters

To operate Keptn in a multi-cluster setup, you need obviously at least two Kubernetes clusters: 
1. One that runs Keptn as control-plane
2. The second one that runs the execution-plane services for deploying, testing, executing remediation actions, etc.

* To create a Kubernetes cluster, please follow the instructions [here](../install/#create-or-bring-a-kubernetes-cluster).

## Prerequisits

* If you don't have the Keptn CLI installed locally, please install it as explained [here](../install/#install-keptn-cli).

## Install Keptn Control-plane

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

## Install Keptn Execution-plane


> Explanation is missing