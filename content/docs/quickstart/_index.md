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
without requiring you to install anything.
In less than an hour, you will learn about the main features of Keptn and how to implement them.

**Note:** The kilrcoda session expires after an hour or if it is idle for five minutes or longer
so you should plan to sit down and do the exercise without interruptions..

## Next steps

If you like what you saw in the exercise, you can start using Keptn yourself by doing the following:

* Install Keptn on the Kubernetes cluster of your choice
* Create your own project

### Install Keptn on your Kubernetes cluster

You can install and run Keptn on virtually any Kubernetes cluster:

1. Download the Keptn Command Line Tool:

```
curl -sL https://get.keptn.sh | bash
```

2. Install the core Keptn control plane components and expose them via a LoadBalancer:
```
helm repo add keptn https://charts.keptn.sh && helm repo update
helm install keptn keptn/keptn \
-n keptn --create-namespace \
--wait \
--set=control-plane.apiGatewayNginx.type=LoadBalancer
```

3. Install some standard Keptn execution plane components. These are additional microservices that handle specific tasks:

```
helm install jmeter-service keptn/jmeter-service -n keptn
helm install helm-service keptn/helm-service -n keptn
```

  Note that you do not have to use these particular microservices.
  See [Deploying Services](../0.16.x/manage/service) for more information.

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
