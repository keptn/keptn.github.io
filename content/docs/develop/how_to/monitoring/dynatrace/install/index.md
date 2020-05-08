---
title: Install
description: Setup Dynatrace monitoring
weight: 1
icon: setup
keywords: setup
---

## Install Dynatrace

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

    If running on a Unix/Linux based system, you can use variables for ease of use. Naturally, it is also fine to just replace the values in the `kubectl` command itself.

    ```console
    DT_TENANT=yourtenant.live.dynatrace.com
    DT_API_TOKEN=yourAPItoken
    DT_PAAS_TOKEN=yourPAAStoken
    ```
    If you used the variables, the next command can be copied and pasted without modifications. If you have not set the variable, please make sure to set the right values in the next command.
    ```console
    kubectl -n keptn create secret generic dynatrace --from-literal="DT_TENANT=$DT_TENANT" --from-literal="DT_API_TOKEN=$DT_API_TOKEN"  --from-literal="DT_PAAS_TOKEN=$DT_PAAS_TOKEN"
    ```

1. The Dynatrace integration into Keptn is handled by the *dynatrace-service*. To install the *dynatrace-service*, execute:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/0.7.0/deploy/manifests/dynatrace-service/dynatrace-service.yaml
    ```

1. When the service is deployed, use the following command to install Dynatrace on your cluster. If Dynatrace is already deployed, the current deployment of Dynatrace will not be modified.

    ```console
    keptn configure monitoring dynatrace
    ```

## Verify Dynatrace setup in your cluster

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
oneagent-5lcqh                                 1/1     Running   0          53s
oneagent-ps6t4                                 1/1     Running   0          53s
```

## Verify Dynatrace configuration

- *Tagging rules:* When you navigate to **Settings > Tags > Automatically applied tags** in your Dynatrace tenant, you will find following tagging rules:
    - keptn_deployment
    - keptn_project
    - keptn_service
    - keptn_stage
  
    This means that Dynatrace will automatically apply tags to your onboarded services.

- *Problem notification:* A problem notification has been set up to inform Keptn of any problems with your services to allow auto-remediation. You can check the problem notification by navigating to **Settings > Integration > Problem notifications** and you will find a **keptn remediation** problem notification.

- *Alerting profile:* An alerting profile with all problems set to *0 minutes* (immediate) is created. You can review this profile by navigating to **Settings > Alerting > Alerting profiles**.

- *Dashboard and Mangement zone:* When creating a new Keptn project or executing the [keptn configure monitoring](../../cli/#keptn-configure-monitoring) command for a particular project (see Note 1), a dashboard and management zone will be generated reflecting the environment as specified in the shipyard file.

## Notes

**Note 1:** If you already have created a project using Keptn and would like to enable Dynatrace monitoring for that project, please execute the following command:

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
