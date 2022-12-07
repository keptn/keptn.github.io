---
title: Multi-cluster setup
description: Install Keptn control-plane and execution-plane on separate clusters
weight: 50
aliases:
- /docs/0.19.x/operate/multi_cluster/
- /docs/1.0.x/operate/multi_cluster/
---


## Overview of an example setup

{{< popup_image
link="./assets/multi_cluster.png"
caption="Multi-cluster setup"
width="600px">}}

* **Keptn Control plane**
  * The control plane is the minimum set of components, which are required to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points.
  * The control plane orchestrates the task sequences defined in Shipyard, but does not actively execute the tasks.
  * Minimum [Cluster size](../k8s-support/#cluster-size)

* **Keptn Execution plane**
  * The execution plane consists of all Keptn-services that are required to process all tasks (like deployment, test, etc.).
  * The execution plane is the cluster where you deploy your application too and execute certain tasks of a task sequence. 
  * Minimum [Cluster size](../k8s-support/#cluster-size)
  * Execution plane services are normally Kubernetes based containers but you could regularly poll the Keptn API and therefore run a non-containerised process as a Keptn execution integration.

## Create or bring two (or more) Kubernetes clusters

To operate Keptn in a multi-cluster setup, you need obviously at least two Kubernetes clusters:

1. One that runs Keptn as control plane
2. The second one that runs the execution-plane services for deploying, testing, executing remediation actions, etc.

To create a Kubernetes cluster, please follow the instructions [here](../k8s).

## Prerequisites

* [keptn CLI](../cli-install)
* [helm CLI](https://helm.sh/docs/intro/install/)

## Install Keptn Control plane

The **Control Plane** of Keptn is responsible for orchestrating your processes for continuous delivery or automated operations.

* Before starting the installation, familiarize yourself with the ways of exposing Keptn as explained in
[Choose access options](../access).
Then come back and continue installing the Keptn control plane.

* To install the control plane, execute `helm install` with the option you chose for exposing Keptn:

    ```console
    helm install keptn keptn/keptn -n keptn --version=$KeptnVersion --create-namespace --set=apiGatewayNginx.type=[LoadBalancer, NodePort, ClusterIP]
    ```

* Before continuing, please retrieve:

    * `KEPTN_ENDPOINT`: Follow the instructions for the option you chose for exposing Keptn
    in the [Choose access option](../access) section.
    * `KEPTN_API_TOKEN`: Follow the instructions
    in [Authenticate Keptn CLI and Bridge](../authenticate-cli-bridge).

## Install Keptn Execution plane

In this release of Keptn, the execution plane services for deployment (`helm-service`) and testing (`jmeter-service`) can be installed via Helm Charts.

Please find the Helm Charts here:

  - `helm-service`: GitHub Release for [0.19.3](https://github.com/keptn/keptn/releases/tag/0.19.3) at **Assets** > `helm-service-0.19.3.tgz`

  - `jmeter-service`: GitHub Release for [0.19.3](https://github.com/keptn/keptn/releases/tag/0.19.3) at **Assets** > `jmeter-service-0.19.3.tgz`

### How to deploy an execution plane service?

* Download the `values.yaml` from the release branch, e.g., for the jmeter-service:

    ```
    wget https://raw.githubusercontent.com/keptn/keptn/0.19.3/jmeter-service/chart/values.yaml
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

* If your cluster includes multiple execution planes that run the same integration service,
  you must configure a unique name for each execution plane.
  By default, Keptn uses the execution plane service name and version to identify the execution plane.
  Multiple execution planes that run the same integration service thus have the same identifier,
  so only one instance of the integration service is displayed on the integration page in the Bridge
  and Keptn assigns the same set of event subscriptions to them all
  unless you assign a different name to each remote execution plane service.

  You can assign a unique name label and distributor service name for the execution plane
  in either of the following ways:

  * Set the `K8S_DEPLOYMENT_NAME` environment variable on each execution plane to a unique name.
    See the [distributor](../../0.19.x/reference/miscellaneous/distributor) reference page
    for more information about this and other environment variables that configure the distributor.
    For example:

    ```
    K8S_DEPLOYMENT_NAME: "server001-helm-server"
    ```

  * Some integrations (such as `helm-service` and `jmeter`
    can configure the `K8S_DEPLOYMENT_NAME` value
    based on the value of the `app.kubernetes.io/name` Kubernetes label.
    For these integrations, you can edit the `values.yaml` on each execution plane
    and set a unique value for the `nameOverride` value.
    For example:

    ```
    nameOverride: "server001-helm-server"
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
    helm install jmeter-service https://github.com/keptn/keptn/releases/download/0.19.3/jmeter-service-0.19.3.tgz -n keptn-exec --create-namespace --values=values.yaml
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

### How to uninstall an execution plane service?

* To uninstall an execution plane service -- in this case, the `jmeter-service`, execute:

    ```console
    helm uninstall jmeter-service -n keptn-exec
    ```

### Summary of values to configure execution plane service

See the configuration parameters of the supported execution plane services:

  - `helm-service`: [Helm Chart values](https://github.com/keptn/keptn/blob/0.19.3/helm-service/chart/README.md#configuration)

  - `jmeter-service`: [Helm Chart values](https://github.com/keptn/keptn/blob/0.19.3/jmeter-service/chart/README.md#configuration)

The important ones that are used in the above example are:

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `distributor.stageFilter` | Sets the stage to which this service | `""` |
| `distributor.serviceFilter` | Sets the service to which this service | `""` |
| `distributor.projectFilter` | Sets the project to which this service | `""` |
| `remoteControlPlane.enabled` | Enables remote execution plane mode | `false` |
| `remoteControlPlane.api.protocol` | Used protocol (http, https) | `"https"` |
| `remoteControlPlane.api.hostname` | Hostname of the control plane cluster (and port) | `""` |
| `remoteControlPlane.api.apiValidateTls` | Defines if the control plane certificate should be validated | `true` |
| `remoteControlPlane.api.token` | Keptn API token | `""` |
| `nameOverride` | Sets a unique name for this execution plane | `""` |

## Troubleshooting

### Execution plane service does not start working

If you see in the Keptn Bridge that an event was triggered but no service was reacting upon this trigger, test the connectivity from the execution plane service to the control plane. (as mentioned above) The Helm Charts for the `helm-service` and `jmeter-service` have a built in sanity check that validates whether the connection to the control plane can be established.

<details><summary>Expand instructions</summary>
<p>

**Test (sanity check):**

*Prerequisites:*

* [helm CLI](https://helm.sh/docs/intro/install/)

* Connect you to the cluster where the execution plane is running

* For example, to test `jmeter-service` that is running in the `keptn-exec` namespace, execute:

  ```
  helm test jmeter-service -n keptn-exec
  ```

* The expected outcome is:

  ```
  Pod jmeter-service-test-api-connection pending
  Pod jmeter-service-test-api-connection succeeded
  NAME: jmeter-service
  LAST DEPLOYED: Thu Feb 25 15:55:24 2022
  NAMESPACE: keptn-exec
  STATUS: deployed
  REVISION: 1
  TEST SUITE:     jmeter-service-test-api-connection
  Last Started:   Thu Feb 25 15:55:40 2022
  Last Completed: Thu Feb 25 15:55:42 2022
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

  - Is `enabled` set to `true`?
  - Is the Keptn API endpoint on `http` or `https`?
  - Is the hostname of the Keptn API endpoint correct, e.g. `my.keptn-dev.company.com` (without `/api`)
  - Do you want to skip TLS verification?
  - Is the Keptn API token correct? (You can find it in the Keptn Bridge, or by following the guide for [authenticating](../authenticate-cli-bridge)

</p></details>

### Keptn sees only one instance of an integration deployed on multiple execution planes

The same integration service can be deployed to multiple execution planes in your Keptn installation.
For example, you might deploy the `helm-services` integration
to the execution plane that runs the `dev` stage as well as the execution plane that runs the `prod` stage.
However, you must explicitly configure each execution plane name as described above
so that Keptn can differentiate the two instances of the integration.

If you do not correctly configure the execution plane names,
you will see two issues:

* Only one instance of the integration (such as `helm-service`)
is displayed on the integration page in the Keptn Bridge.
* All events for that integration are delivered to all execution planes that run the service,
so that the execution plane for the `dev` stage
also receives events intended for the `prod` stage.

To correct this situation, follow the instructions above
to set a unique name label and distributor service name for each execution plane
that runs this integration service.

