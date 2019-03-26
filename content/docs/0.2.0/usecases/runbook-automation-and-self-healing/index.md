---
title: Runbook Automation and Self-healing
description: Gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use automation tools for executing and managing the runbooks.
weight: 20
keywords: [self-healing]
aliases:
---

This use case gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use Service Now workflows that are triggered to remediate incidents.

## About this use case

## Prerequisites

- ServiceNow instance or [free ServiceNow developer instance](https://developer.servicenow.com)
- Dynatrace Tenant [free trial](https://www.dynatrace.com/trial)

## Configure keptn

```
kubectl -n keptn create secret generic dynatrace --from-literal="DT_TENANT_ID=xxx" --from-literal="DT_API_TOKEN=xxx"
```

```
kubectl -n keptn create secret generic servicenow --from-literal="tenant=xxx" --from-literal="user=xxx" --from-literal="token=xxx"
```

## Setup the Workflow in ServiceNow

A ServiceNow Update Set is provided to run this use case. To install the Update Set follow these steps:

1. Login to your ServiceNow instance.
1. Search for `update` in the left search box and navigate to **Update Sets to Commit** 
    {{< popup_image
    link="./assets/service-now-update-set-overview.png"
    caption="Service Now Update Set">}}

1. Click on **Import Update Set from XML** 
1. Import the file from this URL: `https://raw.githubusercontent.com/keptn/servicenow-service/master/demo/remediationworkflow-updateset.xml`

1. Open the Update Set
    {{< popup_image
    link="./assets/service-now-update-set-list.png"
    caption="Service Now Update Sets List">}}

1. In the right upper corner, click on **Preview Update Set** and once previewed, click on **Commit Update Set** to apply it to your instance
    {{< popup_image
    link="./assets/service-now-update-set-commit.png"
    caption="Service Now Update Set Commit">}}

1. After importing, navigate to **Workflow Versions** by typing this as a search term into the upper left search box.

1. add credentials and remediation url in the table

1. Find the `keptn-carts-remediation` workflow.

1. **TODO add instructions if changes to workflow have to be made**


## Setup a Dynatrace Problem Notification

In order to create incidents in ServiceNow and to trigger workflows, an integration with Dynatrace has to be set up.

1. Login to your Dynatrace tenant.
1. Navigate to **Settings -> Integration -> Problem Notifications**
1. Click on **Set up notifications** and select **Custom Notification**
1. Choose a name for your integration, e.g., _keptn integration_
1. In the webhook URL, paste the value of your keptn endpoint appended by `/dynatrace`, e.g., `https://control.keptn.XX.XXX.XXX.XX.xip.io/dynatrace`
1. Additionally, a Authorization Header is needed to authorize against the keptn server. 
    - Click on **Add header**
    - The name for the header is: `Authorization`
    - The value has to be set to the following: `Bearer KEPTN_API_TOKEN` where KEPTN_API_TOKEN has to be replaced with your actual Api Token that was received during installation. You can always retrieve the token again by executing `kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode` from a shell/bash. 

1. As the custom payload, a valid Cloud Event has to be defined:

    ```json
    {
        "specversion":"0.2",
        "type":"sh.keptn.events.problem",
        "shkeptncontext": "{PID}",
        "source":"dynatrace",
        "id":"{PID}",
        "time":"",
        "contenttype":"application/json",
        "data": {
            "State":"{State}",
            "ProblemID":"{ProblemID}",
            "PID":"{PID}",
            "ProblemTitle":"{ProblemTitle}",
            "ProblemDetails":{ProblemDetailsJSON},
            "ImpactedEntities":{ImpactedEntities},
            "ImpactedEntity":"{ImpactedEntity}"
        }
    }
    ```

    {{< popup_image
    link="./assets/dynatrace-problem-notification-integration.png"
    caption="Dynatrace Problem Notification Integration">}}

## Run the Use Case

### Load generation

### Configuration change at runtime

can't be detected by keptn

### Problem Detections by Dynatrace


### Workflow execution by ServiceNow

