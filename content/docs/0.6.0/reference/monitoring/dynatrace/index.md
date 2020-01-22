---
title: Dynatrace
description: How to setup Dynatrace monitoring.
weight: 15
icon: setup
keywords: setup
---

To evaluate the quality gates and allow self-healing in production, we have to set up monitoring to get the needed data.

## Setup Dynatrace

1. Bring your Dynatrace SaaS or Dynatrace-managed tenant

    If you don't have a Dynatrace tenant, sign up for a [free trial](https://www.dynatrace.com/trial/) or a [developer account](https://www.dynatrace.com/developer/).

1. Create a Dynatrace API Token

    Log in to your Dynatrace tenant and go to **Settings > Integration > Dynatrace API**. Then, create a new API token with the following permissions:

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

1. Store your credentials in a Kubernetes secret by executing the following command. The `DT_TENANT` has to be set according to the appropriate pattern:
  - Dynatrace SaaS tenant: `{your-environment-id}.live.dynatrace.com`
  - Dynatrace-managed tenant: `{your-domain}/e/{your-environment-id}`

    ```console
    kubectl -n keptn create secret generic dynatrace --from-literal="DT_API_TOKEN=<DT_API_TOKEN>" --from-literal="DT_TENANT=<DT_TENANT>" --from-literal="DT_PAAS_TOKEN=<DT_PAAS_TOKEN>"
    ```

1. * To install the *dynatrace-service*, execute:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/0.6.0/deploy/manifests/dynatrace-service/dynatrace-service.yaml
    ```

1. When the service is deployed, use the following command to install Dynatrace on your cluster. If Dynatrace is already deployed, the current deployment of Dynatrace will not be modified.

    ```console
    keptn configure monitoring dynatrace
    ```

**Verify deployment in your cluster**

When [keptn configure monitoring](../../cli/#keptn-configure-monitoring) is finished, the Dynatrace OneAgent is deployed in your cluster. Execute the following commands to verify the deployment of the OneAgent as well as of the *dynatrace-service*:

```console
kubectl get svc dynatrace-service -n keptn
```

```console
NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
dynatrace-service   ClusterIP   10.0.44.191   <none>        8080/TCP   2m48s
```

```console
kubectl get pods -n dynatrace
```

```console
NAME                                           READY   STATUS    RESTARTS   AGE
dynatrace-oneagent-operator-7f477bf78d-dgwb6   1/1     Running   0          12m
oneagent-5lcqh                                 0/1     Running   0          3s
oneagent-ps6t4                                 0/1     Running   0          3s
```

**Verify setup in Dynatrace**

- *Tagging rules:* When you navigate to **Settings > Tags > Automatically applied tags** in your Dynatrace tenant, you will find following tagging rules:
    - keptn_deployment
    - keptn_project
    - keptn_service
    - keptn_stage
  
    This means that Dynatrace will automatically apply tags to your onboarded services.

- *Problem notification:* Automatically a problem notification has been set up to inform Keptn of any problems with your services to allow auto-remediation. You can check the problem notification by navigating to **Settings > Integration > Problem notifications** and you will find a **keptn remediation** problem notification.

- *Alerting profile:* In addition to the problem notification, an alerting profile with all problems set to *0 minutes* (immediate) is created. You can review this profile by navigating to **Settings > Alerting > Alerting profiles**.

- *Dashboard and Mangement zone:* When creating a new Keptn project or executing the [keptn configure monitoring](../../cli/#keptn-configure-monitoring) command for a particular project (see Note 1), a Dashboard and Management zone will be generated reflecting the environment as specified in the shipyard file.


---

**Note 1:** If you already have created a project using Keptn and would like to enable Dynatrace monitoring for that project afterwards, please execute the following command:
  ```console
  keptn configure monitoring dynatrace --project=PROJECTNAME
  ```

**Note 2:** To monitor the services that are already onboarded in the **dev**, **staging**, and **production** namespace, make sure to restart the pods. If you defined different environments in your shipyard file, please adjust the parameters accordingly. 
```console
kubectl delete pods --all --namespace=sockshop-dev
```
```console
kubectl delete pods --all --namespace=sockshop-staging
```
```console
kubectl delete pods --all --namespace=sockshop-production
```

**Note 3:** If the nodes in your cluster run on *Container-Optimized OS (cos)* (default for GKE), the Dynatrace OneAgent might not work properly, and another step is necessary. To verify that the OneAgent does not work properly, the output of `kubectl get pods -n dynatrace` might look as follows:
```console
NAME                                           READY   STATUS             RESTARTS   AGE
dynatrace-oneagent-operator-7f477bf78d-dgwb6   1/1     Running            0          8m21s
oneagent-b22m4                                 0/1     Error              6          8m15s
oneagent-k7jn6                                 0/1     CrashLoopBackOff   6          8m15s
```

1. This means that after the initial setup you need to edit the OneAgent custom resource in the Dynatrace namespace and add the following entry to the env section:

        env:
        - name: ONEAGENT_ENABLE_VOLUME_STORAGE
          value: "true"

1. To edit the OneAgent custom resource: 

    ```console
    kubectl edit oneagent -n dynatrace
    ```

1. Finally, don't forget to restart the pods as described in **Note 2** above.

## Setup Dynatrace SLI provider

During the evaluation of a quality gate, the Dynatrace SLI provider is required that is implemented by an internal Keptn service, the *dynatrace-sli-service*. This service will fetch the values for the SLIs that are referenced in an SLO configuration.

* To install the *dynatrace-sli-service*, execute:

  ```console
  kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/0.3.0/deploy/service.yaml
  ```

* To verify that the deployment has worked, execute:

  ```console
  kubectl get pods -n keptn --selector run=dynatrace-sli-service
  ```

---

**Provider configuration:**

To tell the *dynatrace-sli-service* how to acquire the values of an SLI, the correct query needs to be configured. This is done by adding an SLI configuration to a project, stage, or service using the [add-resource](../../cli/#keptn-add-resource) command. The resource identifier must be `dynatrace/sli.yaml`.

* In the below example, the SLI configuration as specified in the `sli-config-dynatrace.yaml` file is added to the service `carts` in stage `hardening` from project `sockshop`. 

  ```console
  keptn add-resource --project=sockshop --stage=hardening --service=carts --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
  ```

**Note:** The add-resource command can be used to store a configuration on project-, stage-, or service-level. In the context of an SLI configuration, Keptn first uses SLI configuration stored on the service-level, then on the stage-level, and finally Keptn uses SLI configuration stored on the project-level.

---

**Provider secret:** 

If you don't monitor your Kubernetes cluster with Dynatrace (i.e., you have not completed the steps from [Setup Dynatrace](./#setup-dynatrace)), the *dynatrace-sli-service* needs a *secret* containing the **Tenant ID** and **API token** in a yaml file as shown below.

* Create a file `dt_credentials.yaml` with the following content (please note the two space indentation):
  
  ```yaml
  DT_TENANT: YOUR_TENANT_ID.live.dynatracelabs.com
  DT_API_TOKEN: XYZ123456789
  ```

* Before executing the next command, please adapt the instruction to match the name of your project. Then, create the secret in the **keptn** namespace using:

  ```console
  kubectl create secret generic dynatrace-credentials-PROJECTNAME -n "keptn" --from-file=dynatrace-credentials=dt_credentials.yaml
  ```

## Set DT_CUSTOM_PROP before onboarding a service

The created tagging rules in Dynatrace expect the environment variable `DT_CUSTOM_PROP` for your onboarded service. Consequently, make sure to specify the environment variable for deployment in the Helm chart of the service you are going to onboard with the following value: 

```yaml
  env:
  - name: DT_CUSTOM_PROP
    value: "keptn_project={{ .Values.keptn.project }} keptn_service={{ .Values.keptn.service }} keptn_stage={{ .Values.keptn.stage }} keptn_deployment={{ .Values.keptn.deployment }}"
```

## See Keptn events in Dynatrace

The *dynatrace-service* in Keptn will take care of pushing events of the Keptn workflow to the artifacts that have been onboarded. For example, the deployment and custom infos - like starting and finishing of tests - will appear in the details screen of your services in your Dynatrace tenant.
    {{< popup_image
    link="./assets/custom_events.png"
    caption="Keptn events"
    width="500px">}}

## Disable Frequent Issue Detection

Keptn relies on Dynatrace sending *brand new* alerts everytime a problem is detected. Therefore we need to disable the *Frequent Issue Detection* within Dynatrace. To do so, go to **Settings -> Anomaly Detection -> Frequent Issue Detection**, and disable all switches found in this menu:

{{< popup_image
    link="./assets/disable-fid.png"
    caption="Disabling frequent issue detection"
    width="700px">}}

## Create a process group naming rule in Dynatrace

While it is not a technical requirement, we encourage you to set up a process group naming rule within Dynatrace.

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
  git clone --branch 0.6.0 https://github.com/keptn-contrib/dynatrace-service --single-branch
  ```

1. Go to correct folder and execute the `uninstallDynatrace.sh` script:

  ```console
  ./dynatrace-service/deploy/scripts/uninstallDynatrace.sh
  ```