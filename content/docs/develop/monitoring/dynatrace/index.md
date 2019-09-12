---
title: Dynatrace
description: How to setup Dynatrace monitoring.
weight: 15
icon: setup
keywords: setup
---

In order to evaluate the quality gates and allow self-healing in production, we have to set up monitoring to provide the needed data.

## Prerequisites

Please make sure to have the following tool(s) installed:

- [jq](https://stedolan.github.io/jq/) - a lightweight and flexible command-line JSON processor. 

<details><summary>Open for installation instructions</summary>
<p>

  ```console
  sudo apt-get update
  sudo apt install jq -y
  ```

</p>
</details>

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
  git clone --branch 0.2.0 https://github.com/keptn-contrib/dynatrace-service --single-branch
  ```
  ```console
  cd dynatrace-service/deploy/scripts
  ```
  ```console
  ./defineDynatraceCredentials.sh
  ```
    When the  script asks for your Dynatrace tenant, please enter your tenant according to the appropriate pattern:
      - Dynatrace SaaS tenant: `{your-environment-id}.live.dynatrace.com`
      - Dynatrace-managed tenant: `{your-domain}/e/{your-environment-id}`

1. Execute the installation script for your platform:

  - If you are on **Azure AKS**, please execute

    ```console
    ./deployDynatraceOnAKS.sh
    ```

    - If you are on **AWS EKS**, please execute

    ```console
    ./deployDynatraceOnEKS.sh
    ```

  - If you are on **Google GKE**, please execute

    ```console
    ./deployDynatraceOnGKE.sh
    ```

  - If you are on **OpenShift**, please execute

    ```console
    ./deployDynatraceOnOpenshift.sh
    ```

When this script is finished, the Dynatrace OneAgent and the *dynatrace-service* are deployed in your cluster. Execute the following command to verify the deployment of the *dynatrace-service*.

```console
kubectl get svc dynatrace-service -n keptn
```

```console
NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
dynatrace-service   ClusterIP   10.0.44.191   <none>        8080/TCP   2m48s
```

**Note 1:** To monitor the services that are already onboarded in the `dev`, `staging`, and `production` namespace, make sure to restart the pods. If you defined different environments in your shipyard file, please adjust the values accordingly. 
```console
kubectl delete pods --all --namespace=sockshop-dev
```
```console
kubectl delete pods --all --namespace=sockshop-staging
```
```console
kubectl delete pods --all --namespace=sockshop-production
```

**Note 2:** If the nodes in your cluster run on *Container-Optimized OS (cos)*, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `deployDynatrace.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

### What was set up?

In your Dynatrace tenant, when you navigate to **Settings > Tags > Automatically applied tags** you will find two entries:

- environment
- service

This means that Dynatrace will automatically apply tags to your onboarded services.

In addition, a Problem Notification has automatically been set up to inform your Keptn installation of any problems with your services to allow auto-remediation. This will be described in more detail in the [runbook automation and self-healing use case](../../usecases/runbook-automation-and-self-healing/). You can check the problem notification by navigating to **Settings > Integration > Problem notifications** and you will find a **keptn remediation** problem notification.


## See Keptn events in Dynatrace

The Dynatrace service will take care of pushing events of the Keptn workflow to the artifacts that have been onboarded with Keptn. For example, the deployment as well as custom infos like starting and finishing of tests will appear in the details screen of your services in your Dynatrace tenant.
    {{< popup_image
    link="./assets/custom_events.png"
    caption="Keptn events"
    width="500px">}}


## (optional) Create process group naming rule in Dynatrace

1. Create a naming rule for process groups
    1. Go to **Settings**, **Process and containers**, and click on **Process group naming**.
    1. Create a new process group naming rule with **Add new rule**.
    1. Edit that rule:
        * Rule name: `Container.Namespace`
        * Process group name format: `{ProcessGroup:KubernetesContainerName}.{ProcessGroup:KubernetesNamespace}`
        * Condition: `Kubernetes namespace` > `exits`
    1. Click on **Preview** and **Save**.

    Screenshot shows this rule definition.
    {{< popup_image
    link="./assets/pg_naming.png"
    caption="Dynatrace naming rule">}}

## Uninstall Dynatrace

If you want to uninstall Dynatrace, there are scripts provided to do so. Uninstalling Keptn will not automatically uninstall Dynatrace.

1. (optional) If you do not have the *dynatrace-service* repository, clone the latest release using:

  ```console
  git clone --branch 0.2.0 https://github.com/keptn-contrib/dynatrace-service --single-branch
  ```

1. Go to correct folder and execute the `uninstallDynatrace.sh` script:

  ```console
  cd dynatrace-service/deploy/scripts
  ```

  ```console
  ./uninstallDynatrace.sh
  ```