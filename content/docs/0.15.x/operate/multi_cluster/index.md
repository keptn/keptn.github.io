---
title: Multi-cluster setup
description: Install Keptn control-plane and execution-plane separately.
weight: 60
keywords: [0.15.x-operate]
---


## Overview of an example setup

{{< popup_image
link="./assets/multi_cluster.png"
caption="Multi-cluster setup"
width="600px">}}

* **Keptn Control plane**
  * The control plane is the minimum set of components, which are required to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points.
  * The control plane orchestrates the task sequences defined in Shipyard, but does not actively execute the tasks.
  * Minimum [Cluster size](../k8s_support/#cluster-size)

* **Keptn Execution plane**
  * The execution plane consists of all Keptn-services that are required to process all tasks (like deployment, test, etc.).
  * The execution plane is the cluster where you deploy your application too and execute certain tasks of a task sequence.
  * Minimum [Cluster size](../k8s_support/#cluster-size)

## Create or bring two (or more) Kubernetes clusters

To operate Keptn in a multi-cluster setup, you need obviously at least two Kubernetes clusters:

1. One that runs Keptn as control plane
2. The second one that runs the execution-plane services for deploying, testing, executing remediation actions, etc.

To create a Kubernetes cluster, please follow the instructions [here](../install/#create-or-bring-a-kubernetes-cluster).

## Prerequisites

* [keptn CLI](../install/#install-keptn-cli)
* [helm CLI](https://helm.sh/docs/intro/install/)

## Install Keptn Control plane

The **Control Plane** of Keptn is responsible for orchestrating your processes for continuous delivery or automated operations.

* Before starting the installation, make yourself familiar with the ways of exposing Keptn as explained [here](../install/#install-keptn). Then come back and continue installing Keptn control plane.

* To install the control plane, execute `keptn install` with the option you chose for exposing Keptn:

    ```console
    keptn install --endpoint-service-type=[LoadBalancer, NodePort, ClusterIP]
    ```

* Before continuing, please retrieve:

  * `KEPTN_ENDPOINT`: Follow the instructions [here](../install/#install-keptn), depending on the option you chose for exposing Keptn.
  * `KEPTN_API_TOKEN`: Follow the instructions [here](../install/#authenticate-keptn-cli).

## Install Keptn Execution plane

In this release of Keptn, the execution plane services for deployment (`helm-service`) and testing (`jmeter-service`) can be installed via Helm Charts.

Please find the Helm Charts here:

* `helm-service`: GitHub Release for [0.15.0](https://github.com/keptn/keptn/releases/tag/0.15.0) at **Assets** > `helm-service-0.15.0.tgz`

* `jmeter-service`: GitHub Release for [0.15.0](https://github.com/keptn/keptn/releases/tag/0.15.0) at **Assets** > `jmeter-service-0.15.0.tgz`

### How to deploy an execution plane services?

* Download the `values.yaml` from the release branch, e.g., for the jmeter-service:

    ```
    wget https://raw.githubusercontent.com/keptn/keptn/0.15.0/jmeter-service/chart/values.yaml
    ```

* Edit the `values.yaml` to connect the services to the Keptn control plane, identified by its endpoint and API token. Therefore, set the values (1) - (5):

    ```
    remoteControlPlane:
      enabled: true                         # < (1) set to true
      api:
        protocol: "http"                    # < (2) set protocol: http or https
        hostname: ""                        # < (3) set Keptn endpoint (without /api)
        apiValidateTls: true                # < (4 - optional) option to skip TLS verification
        token: ""                           # < (5) set Keptn API token
    ```

* Depending on your setup of the multi-cluster environment and the approach you modeled your staging process, one stage can be for example on a separate cluster. Let's assume the following setup:

  * Project: `sockshop`
  * Service: `carts`
  * Stages:
    * `hardening` - on Cluster-A
    * `production` - on Cluster-B

    To properly configure the execution plane services that run, for example, on **Cluster-A**, the distributor in the `values.yaml` needs to be configured:

    ```
    distributor:
      projectFilter: ""                     # set the project, e.g., "sockshop" to get events for this project.
      stageFilter: "hardening"              # set the stage, e.g., "hardening" to get events for the stage.
      serviceFilter: ""                     # set the service, e.g., "carts" to get events for the service.
    ```

    **Note:** `projectFilter`, `stageFilter`, and `serviceFilter` allow a comma-separated list of values.

* Deploy the execution plane service (e.g., jmeter-service) from release assets with your `values.yaml` and by using `helm`:

    ```console
    helm install jmeter-service https://github.com/keptn/keptn/releases/download/0.15.0/jmeter-service-0.15.0.tgz -n keptn-exec --create-namespace --values=values.yaml
    ```

* Test connection to Keptn control plane using:

    ```console
    helm test jmeter-service -n keptn-exec
    ```

    ```console
    Pod jmeter-service-test-api-connection pending
    Pod jmeter-service-test-api-connection succeeded
    NAME: jmeter-service
    LAST DEPLOYED: Thu Feb 25 15:55:24 2021
    NAMESPACE: keptn-exec
    STATUS: deployed
    REVISION: 1
    TEST SUITE:     jmeter-service-test-api-connection
    Last Started:   Thu Feb 25 15:55:40 2021
    Last Completed: Thu Feb 25 15:55:42 2021
    Phase:          Succeeded
    ```

### How to uninstall an execution plane services?

* To uninstall an execution plane service, e.g., jmeter-service, just execute:

    ```console
    helm uninstall jmeter-service -n keptn-exec
    ```

### Summary of values to configure execution plane service

See the configuration parameters of the supported execution plane services:

* `helm-service`: [Helm Chart values](https://github.com/keptn/keptn/blob/0.15.0/helm-service/chart/README.md#configuration)

* `jmeter-service`: [Helm Chart values](https://github.com/keptn/keptn/blob/0.15.0/jmeter-service/chart/README.md#configuration)

The important once that are used in the above example are:

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `distributor.stageFilter` | Sets the stage this service belongs to | `""` |
| `distributor.serviceFilter` | Sets the service this service belongs to | `""` |
| `distributor.projectFilter` | Sets the project this service belongs to | `""` |
| `remoteControlPlane.enabled` | Enables remote execution plane mode | `false` |
| `remoteControlPlane.api.protocol` | Used protocol (http, https) | `"https"` |
| `remoteControlPlane.api.hostname` | Hostname of the control plane cluster (and port) | `""` |
| `remoteControlPlane.api.apiValidateTls` | Defines if the control plane certificate should be validated | `true` |
| `remoteControlPlane.api.token` | Keptn API token | `""` |

## Troubleshooting

### Execution plane service does not start working

If you see in the Keptn Bridge that an event was triggered but no service was reacting upon this trigger, test the connectivity from the execution plane service to the control plane. (as mentioned above) The Helm Charts for the `helm-service` and `jmeter-service` have a built in sanity check that validates whether the connection to the control plane can be established.

<details><summary>Expand instructions</summary>
<p>

**Test (sanity check):**

*Prerequisites:*

* [helm CLI](https://helm.sh/docs/intro/install/)

* Connect you to the cluster where the execution plane is running

* For example, you want to test `jmeter-service` that is running in `keptn-exec` namespace, execute:

  ```console

helm test jmeter-service -n keptn-exec

  ```

* The expected outcome should be:

  ```console
Pod jmeter-service-test-api-connection pending
Pod jmeter-service-test-api-connection succeeded
NAME: jmeter-service
LAST DEPLOYED: Thu Feb 25 15:55:24 2021
NAMESPACE: keptn-exec
STATUS: deployed
REVISION: 1
TEST SUITE:     jmeter-service-test-api-connection
Last Started:   Thu Feb 25 15:55:40 2021
Last Completed: Thu Feb 25 15:55:42 2021
Phase:          Succeeded
  ```

**Help:**

1. Validate the properties set in the `values.yaml`:

  ```
remoteControlPlane:
  enabled: true                         # < (1) set to true
  api:
    protocol: "http"                    # < (2) set protocol: http or https
    hostname: ""                        # < (3) set Keptn hostname (without /api)
    apiValidateTls: true                # < (4 - optional) option to skip TLS verification
    token: ""                           # < (5) set Keptn API token
  ```

* Is `enabled` set to `true`?
* Is the Keptn API endpoint on `http` or `https`?
* Is the hostname of the Keptn API endpoint correct, e.g. `my.keptn-dev.company.com` (without `/api`)
* Do you want to skip TLS verification?
* Is the Keptn API token correct? (You can find it in the Keptn Bridge, or by following the guide for [authenticating](../install/#authenticate-keptn-cli))

</p></details>
