---
title: Setup Dynatrace
description: How to setup Dynatrace monitoring.
weight: 15
icon: setup
keywords: setup
---

In order to evaluate the quality gates, we have to set up monitoring to provide the needed data.

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

1. Start the following script:
  ```console
  cd ~/keptn/install/scripts
  ./defineDynatraceCredentials.sh
  ```
  When the  script asks for your Dynatrace tenant, please enter your tenant according to the appropriate pattern:
    - Dynatrace SaaS tenant: `{your-environment-id}.live.dynatrace.com`
    - Dynatrace-managed tenant: `{your-domain}/e/{your-environment-id}`

1. Execute the installation script:
  ```console
  ./deployDynatrace.sh
  ```

When this script is finished, the Dynatrace OneAgent will be deployed in your cluster.

  **Note 1:** To see the services running in your cluster, make sure to restart the pods they are running in.
  ```
  kubectl delete pods --all -n keptn
  ```

  **Note 2:** If the nodes in your cluster run on *Container-Optimized OS (cos)*, make sure to [follow the instructions](https://www.dynatrace.com/support/help/cloud-platforms/google-cloud-platform/google-kubernetes-engine/deploy-oneagent-on-google-kubernetes-engine-clusters/#expand-134parameter-for-container-optimized-os-early-access) for setting up the Dynatrace OneAgent Operator. This means that after the initial setup with `deployDynatrace.sh`, which is a step below, the `cr.yml` has to be edited and applied again. In addition, all pods have to be restarted.

## Configure Jenkins

1. Go to Jenkins at `http://jenkins.keptn.<EXTERNAL_IP>.xip.io/` and login with the default credentials `admin` / `AiTx4u8VyUV8tCKk` or with the updated credentials you set after the installation. You can retrieve the URL of Jenkins with the following command:
  ```
  echo http://jenkins.keptn.$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~').xip.io/configure
  ``` 
  
1. In the **Jenkins** > **Manage Jenkins** > **Configure System** screen, scroll to the environment variables and **Add** two new environment variables:
    - `DT_TENANT_URL` with the Dynatrace tenant URL as value
      -  Dynatrace SaaS tenant: `https://{your-environment-id}.live.dynatrace.com`
      - Dynatrace-managed tenant: `https://{your-domain}/e/{your-environment-id}`
    - `DT_API_TOKEN` with the Dynatrace API token as value
  {{< popup_image link="./assets/jenkins-env-vars.png" caption="Jenkins environment variables">}}

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

