---
title: Setup Dynatrace
description: How to setup Dynatrace monitoring.
weight: 15
icon: setup
keywords: setup
---

In order to evaluate the quality gates and allow self-healing in production, we have to set up monitoring to provide the needed data.

## Setup Dynatrace

1. Bring your Dynatrace SaaS or Dynatrace-managed tenant

    If you don't have a Dynatrace tenant, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

1. Create a Dynatrace API Token

    Log in to your Dynatrace tenant, and go to **Settings > Integration > Dynatrace API**. Then, create a new API token with the following permissions:

    - Access problem and event feed, metrics and topology
    - Access logs
    - Configure maintenance windows
    - Read configuration
    - Write configuration
    - Capture request data
    - Real user monitoring JavaScript tag management

    {{< popup_image
    link="./assets/dt_api_token.png"
    caption="Dynatrace API Token"
    width="500px">}}

1. Create a Dynatrace PaaS Token

    In your Dynatrace tenant, go to **Settings > Integration > Platform as a Service**, and create a new PaaS Token.

1. Clone the install repository and setup your credentials by executing the following steps:
```console
git clone --branch 0.2.2 https://github.com/keptn/installer
cd installer/scripts
./defineDynatraceCredentials.sh
```
  When the  script asks for your Dynatrace tenant, please enter your tenant according to the appropriate pattern:
    - Dynatrace SaaS tenant: `{your-environment-id}.live.dynatrace.com`
    - Dynatrace-managed tenant: `{your-domain}/e/{your-environment-id}`

1. Execute the installation script `deployDynatrace.sh`:
  ```console
  ./deployDynatrace.sh
  ```
  When this script is finished, the Dynatrace OneAgent and the dynatrace-service are deployed in your cluster. Execute the following command to verify the deployment of the dynatrace-service.

    ```console
    kubectl get ksvc dynatrace-service -n keptn
    ```

    ```console
    NAME                DOMAIN                                      LATESTCREATED             LATESTREADY               READY
    dynatrace-service   dynatrace-service.keptn.svc.cluster.local   dynatrace-service-26sm4   dynatrace-service-26sm4   True
    ```

**Note 1:** To monitor the services that are already onboarded in the `dev`, `staging`, and `production` namespace, make sure to restart the pods. If you defined different environments in your shipyard file, please adjust the values accordingly. 
```console
kubectl delete pods --all --namespace=sockshop-dev
kubectl delete pods --all --namespace=sockshop-staging
kubectl delete pods --all --namespace=sockshop-production
```

**Note 2:** If the nodes in your cluster run on *Container-Optimized OS (cos)*, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `deployDynatrace.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

## See keptn events in Dynatrace

The Dynatrace service will take care of pushing events of the keptn workflow to the artifacts that have been onboarded with keptn. For example, the deployment as well as custom infos like starting and finishing of tests will appear in the details screen of your services in your Dynatrace tenant.
    {{< popup_image
    link="./assets/custom_events.png"
    caption="keptn events"
    width="500px">}}


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

