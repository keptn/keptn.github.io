---
title: Installation
description: How to install and configure your Keptn environment.  Scroll down for a reference list of tasks.
weight: 210
icon: concepts
---

The steps to install and configure your Keptn instance are:

1. Keptn can run on existing Kubernetes clusters or you can create a Kubernetes cluster just for Keptn.
    * Check [Kubernetes support and cluster size](k8s-support)
      to ensure that your version of Kubernetes is compatible
      with the Keptn version you are installing
      and that you have adequate resources.
    * [Create or bring a Kubernetes cluster](k8s) gives links to installation instructions
      for many of the most popular Kubernetes options

2. Decide [how you want to access Keptn](access).
   Kubernetes supports exposing Keptn via a LoadBalancer, a NodePort, an Ingress
   or using Port-forwarding.
   You need this information when you install Keptn.

3. Install [Keptn CLI](cli-install) on the cloud shell machine
   that is used to access your cloud provider, Kubernetes cluster, etc (recommended).

4. Install the [Helm CLI](https://helm.sh).

5. Install Keptn using a Helm chart:
    * [Helm chart](helm-install) gives instructions for installing all of Keptn on one Kubernetes cluster.
    * [Multi-cluster setup](multi-cluster) gives instructions for installing Keptn
      so that the Keptn Control Plane is installed in one Kubernetes cluster
      and the Keptn Execution Plane is installed in one or more other Kubernetes clusters.

5. [Authenticate CLI and Bridge](authenticate-cli-bridge)

6. Install software to run Keptn tasks
    * [Job Executor Service](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/INSTALL.md)
        * The [Job Executor Service](https://github.com/keptn-contrib/job-executor-service)
         runs Keptn customizable tasks as Kubernetes jobs.
         See [Job Executor Service Features](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/FEATURES.md) for more details.
        * Also see [Job Executor Service Architecture](https://github.com/keptn-contrib/job-executor-service/blob/main/docs/ARCHITECTURE.md#example-configuration)

7. If your project does [Deployment with Helm](../define/deployment_helm),
   install [Istio](istio).

8. If you are using [Quality Gates](../concepts/quality_gates),
   install the [monitoring service](monitoring) you want to use.

9. Configure [webhooks](webhook_service) (optional)

10. If you have problems with your installation,
    check out the hints in [Troubleshooting the installation](troubleshooting)

You may also be interested in the following topics:

* [Upgrade Keptn](upgrade)

* [Uninstall Keptn](uninstall)
