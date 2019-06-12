---
title: Prepare PKS cluster
description: How to setup a PKS cluster on GCP for keptn.
weight: 30
icon: setup
keywords: setup
---

## Install local tools
- [pks](https://network.pivotal.io/products/pivotal-container-service) CLI - v1.4.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Create PKS cluster

## Install keptn 

To install keptn, please continue [here](../setup-keptn/).

During the installation process the keptn cli will ask for a CLUSTER_IPV4_CIDR and SERVICES_IPV4_CIDR. The values for these two properties you find in your PCF OpsManager. 

* Login to your PCF OpsManager
* Click on the **Enterprise PKS** tile and go to **Networking**
* The networking configuration shows the values for the *Kubernetes Pod Network CIDR Range* (CLUSTER_IPV4_CIDR) and *Kubernetes Service Network CIDR Range* (SERVICES_IPV4_CIDR):
  {{< popup_image link="./assets/cluster_services_ip.png" 
    caption="Kubernetes Pod and Services Network CIDR Range" width="40%">}}