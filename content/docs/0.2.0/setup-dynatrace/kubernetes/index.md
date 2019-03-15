---
title: Install the Dynatrace OneAgent on your keptn Kubernetes cluster
description: Demonstrates how to install the Dynatrace OneAgent on your keptn Kubernetes cluster. 
weight: 36
keywords: [dynatrace, install]
---

To deploy the Dynatrace OneAgent in your Kubernetes cluster, follow these instructions:

## Step 1: Get your Dynatrace Tenant

If you don't have a Dynatrace tenant yet, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

## Step 2: Create a Dynatrace APi Token
Log in to your Dynatrace tenant, and go to **Settings > Integration > Dynatrace API**. Then, create a new API Token with the following permissions:

    
  - Access problem and event feed, metrics and topology
  - Access logs
  - Configure maintenance windows
  - Read configuration
  - Write configuration
  - Capture request data
  - Real user monitoring JavaScript tag management

  {{< popup_image
  link="./assets/dt_api_token.png"
  caption="Dynatrace API token">}}

## Step 3: Create a Dynatrace PaaS Token
In your Dynatrace tenant, go to **Settings > Integration > Platfrom as a Service**, and create a new PaaS Token.

## Step 4: Deploy the Dynatrace OneAgent:
In your keptn directory, navigate to `install/scripts`. Afterwards, execute the script `defineDynatraceCredentials.sh`:

  ```console
  $ ./defineDynatraceCredentials.sh
  ```

This script will ask you for your **Dynatrace Tenant ID**, as well as the **Dynatrace API Token** and the **Dynatrace PaaS Token** you created earlier.
When the script is finished, you should see a file called `creds_dt.json` with those values in the `install/scripts` directory.

Afterwards, execute the script `deployDynatrace.sh`:

  ```console
  $ ./deployDynatrace.sh
  ```

When this script is finished, the Dynatrace OneAgent will be deployed in your cluster.

  **Note:** To see the services running in your cluster, make sure to restart the pods they are running in.

  **Note 2:** If the nodes in your cluster run on *Container-Optimized OS (cos)*, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `deployDynatrace.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

<!--
## Step 5: Add Dynatrace information to Jenkins


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
## Step 5: (optional) Create process group naming rule in Dynatrace

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

