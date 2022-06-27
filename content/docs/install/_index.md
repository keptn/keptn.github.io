---
title: Installation
description: How to install and configure your Keptn environment
weight: 30
icon: concepts
---

The steps to install and configure your Keptn cluster are:

1. [Create or bring a Kubernetes cluster](k8s)
    * Check [Kubernetes support and cluster size](k8s-support)
    to ensure that your version of Kubernetes is compatible
    with the Keptn version you are installing
    and that you have adequate resources.

2. Decide [how you want to access Keptn](access).
   Kubernetes supports expsing Keptn via a LoadBalancer, a NodePort, an Ingress
   or using a Port-forward.

3. Install [Keptn CLI](cli-install)

4. Install Keptn
    * Using a [Helm chart](helm-install), all on one cluster
    * [Manually](../0.16.x/operate/install/#install-keptn),
    using **keptn install** commands (deprecated as of Release 0.17.x)
    * Install using a [Multi-clster setup](multi-cluster),
    meaning that the Keptn Control Plane is installed in one Kubernetes cluster
    and the Keptn Execution Plane is installed in one or more other Kubernetes clusters.

5. [Authenticate CLI and Bridge](authenticate-cli-bridge)

6. Install software to run Keptn tasks
    * [Job Executor Service](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/INSTALL.md)
        * The [Job Executor Service](https://github.com/keptn-contrib/job-executor-service)
         runs Kept customizable tasks as Kubernetes jobs.
         See [Job Executor Service Features](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/FEATURES.md) for more details.
        * Also see [Job Executor Service Architecture](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/ARCHITECTURE.md#example-configuration)
    * [Istio](istio)

7. If you are using [Quality Gates](../concepts/quality_gates),
   install the [monitoring service](monitoring)  you want to use.

8. Configure [webhooks](webhook_service) (optional)

9. If you have problems with your installation,
   check out the hints in [Troubleshooting the installation](troubleshooting)

You may also be interested in the following topics:

* [Upgrade Keptn](upgrade)

* [Uninstall Keptn](uninstall)
