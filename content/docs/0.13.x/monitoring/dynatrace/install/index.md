---
title: Install
description: Set up Dynatrace monitoring and Keptn integration
weight: 1
icon: setup
---

## Deploy Dynatrace Operator on Kubernetes

Bring your Dynatrace SaaS or Dynatrace-managed tenant. If you do not have a Dynatrace tenant, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

To set up Dynatrace monitoring on your Kubernetes cluster, please follow the official Dynatrace documentation on [Deploy Dynatrace Operator](https://www.dynatrace.com/support/help/technology-support/container-platforms/kubernetes/monitor-kubernetes-environments/). 

**Notes:**

* By default, most Kubernetes clusters only offer a self-signed certificate. In such cases, please select *Skip SSL Security Check* when deploying the Dynatrace Operator.

* When deploying the Dynatrace Operator to a cluster running on a *Container-Optimized OS (COS)*, which includes GKE, Anthos, CaaS and PKS environments, please select the *Enable volume storage* option.

* To verify that the Dynatrace Operator is working properly, check the status of the pods by using the kubectl command:

    A status of `Running` indicates that the Dynatrace Operator is functioning normally, while `Error` or `CrashLoopBackOff` are signs of a problem.

    ```console
    kubectl get pods -n dynatrace
    ```

* To ensure that existing workloads are being monitored, restart the pods. For example, to restart the pods in the `sockshop-dev` namespace:
 
    ```console
    kubectl delete pods --all --namespace=sockshop-dev
    ```

## Install Dynatrace Keptn integration

### 1. Gather Dynatrace credentials

To function correctly, the *dynatrace-service* requires access to a Dynatrace tenant, specified through `DT_TENANT` and `DT_API_TOKEN`:

* The `DT_TENANT` has to be set according to the appropriate pattern:
    - Dynatrace SaaS tenant: `{your-environment-id}.live.dynatrace.com`
    - Dynatrace-managed tenant: `{your-domain}/e/{your-environment-id}`

* To create a Dynatrace API token `DT_API_TOKEN`, log in to your Dynatrace tenant and go to **Settings > Integration > Dynatrace API**. In this settings page, create a new API token with the following permissions:
    - Read metrics
    - Ingest metrics
    - Read logs
    - Read entities
    - Read problems
    - Access problem and event feed, metrics, and topology
    - Read configuration
    - Write configuration
    - Capture request data

    {{< popup_image
    link="./assets/dt_api_token.png"
    caption="Dynatrace API Token"
    width="500px">}}

* If running on a Unix/Linux based system, you can use environment variables to simplify the process of creating the credentials secret. Alternatively, It is also fine to just replace the variables with values in the `keptn` command in the following section.

    ```console
    DT_API_TOKEN=<DT_API_TOKEN>
    DT_TENANT=<DT_TENANT>
    ```

### 2. Create a secret with credentials

* Create a secret (named `dynatrace` by default) containing the credentials for the Dynatrace Tenant (`DT_API_TOKEN` and `DT_TENANT`).

    ```console
   keptn create secret dynatrace --scope="dynatrace-service" --from-literal="DT_TENANT=$DT_TENANT" --from-literal="DT_API_TOKEN=$DT_API_TOKEN"
    ```

### 3. Gather Keptn credentials

The *dynatrace-service* also requires access to the Keptn API, provided through the `KEPTN_API_URL`, `KEPTN_API_TOKEN` and optionally `KEPTN_BRIDGE_URL`:

* To get the values for `KEPTN_API_URL` (also known as `KEPTN_ENDPOINT`), please see [Authenticate Keptn CLI](../../../operate/install/#authenticate-keptn-cli).

* By default the `KEPTN_API_TOKEN` is read from the `keptn-api-token` secret (i.e. the secret from the control-plane) and does not need to be set during installation.

* If you would like to use backlinks from your Dynatrace tenant to the Keptn Bridge, provide the service with `KEPTN_BRIDGE_URL`. For further details about this value, please see [Authenticate Keptn Bridge](../../../operate/install/#authenticate-keptn-bridge).

* Similarly to the Dynatrace tenant credentials, if running on a Unix/Linux based system, you can use environment variables to set the values of the credentials. It is also fine to just replace the variables with values in the `helm` command in the following section.

    ```console
    KEPTN_API_URL=<KEPTN_API_URL>
    KEPTN_BRIDGE_URL=<KEPTN_BRIDGE_URL> # optional
    ```

### 4. Deploy the Dynatrace Keptn integration

The Dynatrace integration into Keptn is handled by the *dynatrace-service*.

* Specify the version of the dynatrace-service you want to deploy. Please see the [compatibility matrix](https://github.com/keptn-contrib/dynatrace-service/blob/master/documentation/compatibility.md) of the dynatrace-service to pick the version that works with your Keptn.

    ```console
    VERSION=<VERSION>   # e.g.: VERSION=0.22.0
    ```

*  To install the *dynatrace-service*, execute:

    ```console
    helm upgrade --install dynatrace-service -n keptn \
      https://github.com/keptn-contrib/dynatrace-service/releases/download/$VERSION/dynatrace-service-$VERSION.tgz \
      --set dynatraceService.config.keptnApiUrl=$KEPTN_ENDPOINT \
      --set dynatraceService.config.keptnBridgeUrl=$KEPTN_BRIDGE_URL \
      --set dynatraceService.config.generateTaggingRules=true \
      --set dynatraceService.config.generateProblemNotifications=true \
      --set dynatraceService.config.generateManagementZones=true \
      --set dynatraceService.config.generateDashboards=true \
      --set dynatraceService.config.generateMetricEvents=true
    ```

* This installs the `dynatrace-service` in the `keptn` namespace, which you can verify using:

    ```console
    kubectl -n keptn get deployment dynatrace-service -o wide
    kubectl -n keptn get pods -l run=dynatrace-service
    ```

## Verify Dynatrace configuration

When you execute the [`keptn configure monitoring`](../../../reference/cli/commands/keptn_configure_monitoring/) command, the *dynatrace-service* will configure the Dynatrace tenant by creating *tagging rules*, a *problem notification*, an *alerting profile* as well as a project-specific *dashboard* and *management zone*.

- *Tagging rules:* When you navigate to **Settings > Tags > Automatically applied tags** in your Dynatrace tenant, you will find following tagging rules:
    - keptn_deployment
    - keptn_project
    - keptn_service
    - keptn_stage

    This means that Dynatrace will automatically apply tags to your onboarded services.

- *Problem notification:* A problem notification has been set up to inform Keptn of any problems with your services to allow auto-remediation. You can check the problem notification by navigating to **Settings > Integration > Problem notifications** and you will find a **keptn remediation** problem notification.

- *Alerting profile:* An alerting profile with all problems set to *0 minutes* (immediate) is created. You can review this profile by navigating to **Settings > Alerting > Alerting profiles**.

- *Dashboard and Management zone:* When creating a new Keptn project or executing the [keptn configure monitoring](../../../reference/cli/commands/keptn_configure_monitoring/) command for a particular project (see Note 1), a dashboard and management zone will be generated reflecting the environment as specified in the shipyard.

**Note:** If you already have created a project using Keptn and would like to enable Dynatrace monitoring for that project, please execute the following command:

```console
keptn configure monitoring dynatrace --project=PROJECTNAME
```