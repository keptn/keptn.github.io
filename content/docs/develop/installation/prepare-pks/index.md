---
title: Prepare PKS cluster
description: How to setup a PKS cluster on GCP for keptn.
weight: 30
icon: setup
keywords: setup
---

## Install local tools
- [pks](https://docs.pivotal.io/runtimes/pks/1-4/installing-pks-cli.html)
- [kubectl](https://docs.pivotal.io/runtimes/pks/1-4/installing-kubectl-cli.html)

## Create PKS cluster on GCP
1. Use the provided instructions for [Enterprise Pivotal Container Service (Enterprise PKS) installation on GCP](https://docs.pivotal.io/runtimes/pks/1-4/gcp-index.html)

1. Create a PKS cluster by using the PKS CLI and executing the following command:
    ```console
    pks create-cluster your-cluster --external-hostname example.hostname --plan small
    ```

## Install keptn 

To install keptn, please continue [here](../setup-keptn/).

During the installation process the keptn cli asks for a *Cluster CIDR Range* and *Services CIDR Range*. The values for these two properties you find in your PCF OpsManager. 

* Login to your PCF OpsManager
* Click on the **Enterprise PKS** tile and go to **Networking**
* The networking configuration shows the values for the *Kubernetes Pod Network CIDR Range* (Cluster CIDR Range) and *Kubernetes Service Network CIDR Range* (Services CIDR Range):
  {{< popup_image link="./assets/cluster-services-ip.png" 
    caption="Kubernetes Pod and Services Network CIDR Range" width="40%">}}