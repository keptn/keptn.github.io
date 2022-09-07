---
title: Installation
description: How to install and configure your Keptn environment
weight: 30
icon: concepts
---

The steps to install and configure your Keptn instance are:

1. [Create or bring a Kubernetes cluster](k8s)
    * Check [Kubernetes support and cluster size](k8s-support)
    to ensure that your version of Kubernetes is compatible
    with the Keptn version you are installing
    and that you have adequate resources.

2. Install [Keptn CLI](cli-install)

3. Decide [how you want to access Keptn](access).
   Kubernetes can expose Keptn using a LoadBalancer, a NodePort, an Ingress,
   or using Port-forwarding.

4. Install Keptn, specifying the access method you have chosen
    * Using a [Helm chart](helm-install), all on one cluster
    * [Manually](../0.16.x/operate/install/#install-keptn),
    using **keptn install** commands (deprecated as of Release 0.17.x)
    * Install using a [Multi-cluster setup](multi-cluster),
    meaning that the Keptn Control Plane is installed in one Kubernetes cluster
    and the Keptn Execution Plane is installed in one or more other Kubernetes clusters.

5. [Authenticate CLI and Bridge](authenticate-cli-bridge)

6. If you have problems with your installation,
   check out the hints in [Troubleshooting the installation](troubleshooting)


At this point, you should have a functional Keptn instance running.

You may also be interested in the following topics:

* [Upgrade Keptn](upgrade)

* [Uninstall Keptn](uninstall)

Additional software may need to be installed and configured
to support the needs of the projects you are running:

* Install software to run Keptn tasks
    * [Job Executor Service](https://artifacthub.io/packages/keptn/keptn-integrations/job-executor-service)
     that runs customizable Keptn tasks as Kubernetes jobs:
        * Install the Integration on the Kubernetes cluster(s)
        where the Keptn Execution Plane is installed.
        * Follow the installation instructions for the integration.
    * If you are using services that Keptn deploys using `helm-service`,
      install and configure [Istio](istio) on the Kubernetes cluster(s)
      where those services are installed.

* If you are using [Quality Gates](../concepts/quality_gates),
   install the [monitoring service](monitoring) you want to use
   following the instructions for that Integration:
   * [DataDog](https://artifacthub.io/packages/keptn/keptn-integrations/datadog-service)
   * [Dynatrace](https://artifacthub.io/packages/keptn/keptn-integrations/dynatrace-service)
   * [Prometheus](https://artifacthub.io/packages/keptn/keptn-integrations/prometheus-service)
   * To use a different Observability Platform as your data source,
   follow the instructions in [Custom Integrations](../0.18.x/integrations)
   to create an integration for your Observability Platform.
   or start a conversation in the #keptn-integrations channel in the [Keptn Slack](https://keptn.slack.com).

* Install any Webhook integrations you want
   and configure [webhooks](webhook_service) them (optional).
