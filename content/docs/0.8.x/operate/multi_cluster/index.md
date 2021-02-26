---
title: Multi-cluster setup
description: Install Keptn control-plane and execution-plane separately.
weight: 60
keywords: [0.8.x-operate]
---


## Overview of an example setup

{{< popup_image
link="./assets/multi_cluster.png"
caption="Multi-cluster setup"
width="600px">}}

* **Keptn Control plane**
  * The control plane is the minimum set of components, which are required to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points.
  * The control plane orchestrates the task sequences defined in Shipyard, but does not actively execute the tasks.
  * Minimum [Cluster size](./k8s_support/#control-plane)

* **Keptn Execution plane**
  * The execution plane consists of all Keptn-services that are required to process all tasks (like deployment, test, etc.).
  * The execution plane is the cluster where you deploy your application too and execute certain tasks of a task sequence. 
  * Minimum [Cluster size](./k8s_support/#execution-plane)

## Create or bring two (or more) Kubernetes clusters

To operate Keptn in a multi-cluster setup, you need obviously at least two Kubernetes clusters: 
1. One that runs Keptn as control plane
2. The second one that runs the execution-plane services for deploying, testing, executing remediation actions, etc.

* To create a Kubernetes cluster, please follow the instructions [here](../install/#create-or-bring-a-kubernetes-cluster).

## Prerequisites

* [keptn CLI](../install/#install-keptn-cli)
* [helm CLI](https://helm.sh/docs/intro/install/)

## Install Keptn Control plane

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

* Please make yourself familiar with the ways of exposing Keptn as explained [here](../install/#create-or-bring-a-kubernetes-cluster). Then come back and continue installing Keptn control plane.

* To install the control plane, execute `keptn install` with the option you chose for exposing Keptn:

    ```console
    keptn install --endpoint-service-type=[LoadBalancer, NodePort, ClusterIP]
    ```

## Install Keptn Execution plane

In this release of Keptn, the execution plane services for deployment (`helm-service`) and testing (`jmeter-service`) can be installed via Helm Charts. 

* Please find the Helm Charts here: 

  - `helm-service`: GitHub Release for [0.8.0](https://github.com/keptn/keptn/releases/tag/0.8.0) at **Assets** > `helm-service-0.8.0-dev.tgz`

  - `jmeter-service`: GitHub Release for [0.8.0](https://github.com/keptn/keptn/releases/tag/0.8.0) at **Assets** > `jmeter-service-0.8.0-dev.tgz`

* Download the corresponding Helm Chart and unzip it locally. 

* Adapt the Helm Charts to connect the services to the Keptn control plane, identified by its endpoint and API token. Therefore, open the `values.yaml` in the Helm Chart and set: 

  ```
remoteControlPlane:
  enabled: true                         # < (1) set to true
  api:
    protocol: "http"                    # < (2) set protocol: http or https
    hostname: ""                        # < (3) set Keptn hostname (without /api)
    apiValidateTls: true                # < (4 - optional) option to skip TLS verification
    token: ""                           # < (5) set Keptn API token
  ```

* Depending on your setup of the multi-cluster environment and the approach you modeled your staging process, one stage can be for example on a seperate cluster. Let's assume the following setup: 
  
  * Project: `sockshop`
  * Service: `carts`
  * Stages: 
      * `hardening` - on Cluster-A
      * `production` - on Cluster-B  

    To properly configure the execution plane services that run, for example, on **Cluster-A**, the distributor in the `values.yaml` needs to be configured:

  ```
distributor:
  projectFilter: ""                     # set the project, e.g., "sockshop" (to get events for the entire project)
  stageFilter: ""                       # set the stage, e.g., "hardening" (to get events for the stage)
  serviceFilter: ""                     # set the service, e.g., "carts" (to get events for the service )
  ``` 

* Deploy the execution plane service (e.g., jmeter-service) with `helm`:

  ```console
helm install jmeter-service ./jmeter-service -n keptn-exec --create-namespace
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

  - Is `enabled` set to `true`?
  - Is the Keptn API endpoint on `http` or `https`? 
  - Is the hostname of the Keptn API endpoint correct, e.g. `my.keptn-dev.company.com` (without `/api`)
  - Do you want to skip TLS verification?
  - Is the Keptn API token correct. (You can find it in the Keptn Bridge)

</p></details>