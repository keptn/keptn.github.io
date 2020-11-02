---
title: Best Practices
description: Best practices for Dynatrace monitoring
weight: 3
icon: setup
---

## Set DT_CUSTOM_PROP before onboarding a service

The created tagging rules in Dynatrace expect the environment variable `DT_CUSTOM_PROP` for your onboarded service. Consequently, make sure to specify the environment variable for deployment in the Helm chart of the service you are going to onboard with the following value: 

```yaml
env:
- name: DT_CUSTOM_PROP
  value: "keptn_project={{ .Values.keptn.project }} keptn_service={{ .Values.keptn.service }} keptn_stage={{ .Values.keptn.stage }} keptn_deployment={{ .Values.keptn.deployment }}"
```

## Automatic detection of Kubernetes labels

You can specify [Kubernetes labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) in the deployment definition of your application. Dynatrace automatically detects all labels attached to pods at application deployment time. All you have to do is grant sufficient privileges to the pods that allow for reading the metadata from the Kubernetes REST API endpoint.

* Please follow the official Dynatrace documentation to [grant viewer role to service accounts](https://www.dynatrace.com/support/help/shortlink/kubernetes-tagging#grant-viewer-role-to-service-accounts).

* If you want to automatically detect the Kuberentes labels for Keptn, grant the viewer role to the `keptn-default` service account: 

```console
kubectl -n keptn create rolebinding default-view --clusterrole=view --serviceaccount=keptn:keptn-default
```

As a result, Dynatrace will add the recommended Kuberentes labels to the processes, e.g.: 

{{< popup_image
    link="./assets/k8s_labels.png"
    caption="Disabling frequent issue detection"
    width="700px">}}

## Disable frequent issue detection

When using Keptn for automating operations, e.g., to trigger remediation actions to resolve a problem identified by Dynatrace, it is recommended to disable the *Frequent Issue Detection* within Dynatrace. If this feature is disabled, Dynatrace sends *brand new* alerts every time a problem is detected. To disable it, go to **Settings > Anomaly Detection > Frequent Issue Detection**, and toggle all switches found in this menu:

{{< popup_image
    link="./assets/disable-fid.png"
    caption="Disabling frequent issue detection"
    width="700px">}}

## Create a process group naming rule

While it is not a technical requirement, we encourage you to set up a process group naming rule within Dynatrace for better visibility of services, e.g.:

Screenshot shows the applied rules in action
{{< popup_image 
link="./assets/pg_example.png"
caption="Dynatrace naming rule in action"
width="800px">}}

To configure this rule, follow these steps:

  1. Go to **Settings**, **Process and containers**, and click on **Process group naming**.
  1. Create a new process group naming rule with **Add new rule**.
  1. Edit that rule:
      * Rule name: `Keptn Processgroup Naming`
      * Process group name format: `{ProcessGroup:Environment:keptn_project}.{ProcessGroup:Environment:keptn_stage}.{ProcessGroup:Environment:keptn_service} [{ProcessGroup:Environment:keptn_deployment}]`
      * Condition: `keptn_deployment (Environment)` > `exists`
  1. Click on **Preview** and **Save**.

    Screenshot shows this rule definition.
    {{< popup_image 
    link="./assets/pg_naming.png"
    caption="Dynatrace naming rule"
    width="400px">}}

## See Keptn events

The *dynatrace-service* in Keptn will take care of pushing events of the Keptn workflow to the artifacts that have been onboarded. For example, the deployment and custom infos - like starting and finishing of tests - will appear in the details screen of your services in your Dynatrace tenant.
    {{< popup_image
    link="./assets/custom_events.png"
    caption="Keptn events"
    width="500px">}}
