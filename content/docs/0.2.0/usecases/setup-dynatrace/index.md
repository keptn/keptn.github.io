---
title: Dynatrace Setup
description: Instructions for monitoring your keptn cluster with Dynatrace. 
weight: 15
keywords: [dynatrace, install]
---

To deploy the Dynatrace OneAgent in your Kubernetes cluster, follow these instructions:


## Deploy the Dynatrace OneAgent on your cluster:
1. Make sure you have executed the `defineDynatraceCredentials.sh` script during the [installation of keptn](../../installation/).

1. Execute the installation script:

  ```console
  $ cd keptn/install/scripts
  $ ./deployDynatrace.sh
  ```

When this script is finished, the Dynatrace OneAgent will be deployed in your cluster.

  **Note:** To see the services running in your cluster, make sure to restart the pods they are running in.

  **Note 2:** If the nodes in your cluster run on *Container-Optimized OS (cos)*, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `deployDynatrace.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

<!--
## Add Dynatrace information to Jenkins


  ```
  ...
  env:
    - name: DT_TENANT_URL
      value: yourID.live.dynatrace.com
    - name: DT_API_TOKEN
      value: 123apitoken
  ...
  ```
-->
## (Optional) Create process group naming rule in Dynatrace

1. Create a naming rule for process groups
    1. Go to **Settings**, **Process and containers**, and click on **Process group naming**.
    1. Create a new process group naming rule with **Add new rule**.
    1. Edit that rule:
        * Rule name: `Container.Namespace`
        * Process group name format: `{ProcessGroup:KubernetesContainerName}.{ProcessGroup:KubernetesNamespace}`
        * Condition: `Kubernetes namespace`> `exits`
    1. Click on **Preview** and **Save**.

    Screenshot shows this rule definition.
    {{< popup_image
    link="./assets/pg_naming.png"
    caption="Dynatrace naming rule">}}

