---
title: Quick Start
description: Familiarize yourself with Keptn without installation
icon: concepts
layout: quickstart
weight: 10
hidechildren: true # this flag hides all sub-pages in the sidebar-multicard.html
---

The [Keptn End-to-End Delivery](https://killercoda.com/keptn/scenario/keptn-end-to-end-delivery) exercise
uses [KillerCoda](https://killercoda.com/) to quickly introduce you to Keptn
without needing to install anything.
In less than an hour, you will learn about Keptn's main features and how to implement them.

## Next steps

If you like what you saw in the exercise, you can start using Keptn yourself by doing the following:

* Install Keptn on the Kubernetes cluster of your choice
* Create your own project

### Install Keptn on your Kubernetes cluster

You can install and run Keptn on virtually any Kubernetes cluster:

1. Install core control plane components and expose via a LoadBalancer:
```
helm repo add keptn https://charts.keptn.sh && helm repo update
helm install keptn keptn/keptn \
-n keptn --create-namespace \
--wait \
--set=control-plane.apiGatewayNginx.type=LoadBalancer
```

2. Install the execution plane components. These are additional microservices that will handle certain tasks:

```
helm install jmeter-service keptn/jmeter-service -n keptn
helm install helm-service keptn/helm-service -n keptn
```

See [Install Keptn using the Helm chart](../0.16.x/operate/advanced_install_options)
for more details.

Kubernetes provides methods other than LoadBalancer for exposing Keptn.
See [Access options](../0.16.x/operate/install/#access-options) for more information.

See [Kubernetes support & Cluster size](../0.16.x/operate/k8s_support)
for information about supported versions of Kubernetes and sizing information.

### Create your first Keptn project

Follow the information in [Manage Keptn Project/Service](../0.16.x/manage)
to create your first Keptn project.

## How to get more help?

Join the [Keptn slack channel](https://slack.keptn.sh) for any questions that may arise.
Use the `#help` channel to ask questions and get help from the Keptn team.
