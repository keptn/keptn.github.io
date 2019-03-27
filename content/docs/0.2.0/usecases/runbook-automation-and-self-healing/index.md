---
title: Runbook Automation and Self-healing
description: Gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use automation tools for executing and managing the runbooks.
weight: 20
keywords: [self-healing]
aliases:
---

This use case gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use Service Now workflows that are triggered to remediate incidents.

## About this use case

TODO

## Prerequisites

- ServiceNow instance or [free ServiceNow developer instance](https://developer.servicenow.com)
- Dynatrace Tenant [free trial](https://www.dynatrace.com/trial)

## Configure keptn

In order for keptn to use both ServiceNow and Dynatrace, the corresponding credentials have to be stored as Kubernetes secrets in the cluster.
Please adapt the following commands with your personal credentials:

Create Dynatrace secret to leverage the Dynatrace API.
```
kubectl -n keptn create secret generic dynatrace --from-literal="DT_TENANT_ID=xxx" --from-literal="DT_API_TOKEN=xxx"
```

Create ServiceNow secret to create/update incidents in ServiceNow and run workflows.
For the sake of simplicity, you can use your ServiceNow user, e.g., _admin_ as user and your ServiceNow password as the token.
```
kubectl -n keptn create secret generic servicenow --from-literal="tenant=xxx" --from-literal="user=xxx" --from-literal="token=xxx"
```

## Setup the Workflow in ServiceNow

A ServiceNow Update Set is provided to run this use case. To install the Update Set follow these steps:

1. Login to your ServiceNow instance.
1. Search for _update set_ in the left search box and navigate to **Update Sets to Commit** 
    {{< popup_image
    link="./assets/service-now-update-set-overview.png"
    caption="Service Now Update Set">}}

1. Click on **Import Update Set from XML** 

1. Import the file from this URL: https://raw.githubusercontent.com/keptn/keptn.github.io/docs-v0.2/content/docs/0.2.0/usecases/runbook-automation-and-self-healing/scripts/keptn_demo_remediation_updateset.xml TODO update URL

1. Open the Update Set
    {{< popup_image
    link="./assets/service-now-update-set-list.png"
    caption="Service Now Update Sets List">}}

1. In the right upper corner, click on **Preview Update Set** and once previewed, click on **Commit Update Set** to apply it to your instance
    {{< popup_image
    link="./assets/service-now-update-set-commit.png"
    caption="Service Now Update Set Commit">}}

1. After importing, enter **keptn** as the search term into the upper left search box.
    {{< popup_image 
    link="./assets/service-now-keptn-creds.png"
    caption="ServiceNow keptn credentials">}}
1. Click on **New** and enter your Dynatrace API token as well as your Dynatrace tenant ID.

1. _(Optional)_ You can also take a look at the predefined workflow that is able to handle Dynatrace problem notifications and remediate issues.
    - Navigate to the workflow editor by typing **Workflow Editor** and clicking on the item **Workflow -> Workflow Editor**
    - The workflow editor is opened in a new window/tab
    - Search for the workflow **keptn_demo_remediation** (it might as well be on the second or third page)
    {{< popup_image 
    link="./assets/service-now-workflow-list.png"
    caption="ServiceNow keptn workflow">}}
    - Open the workflow by clicking on it. It will look similar to the following image. By clicking on the workflow notes you can further investigate each step of the workflow.
    {{< popup_image 
    link="./assets/service-now-keptn-workflow.png"
    caption="ServiceNow keptn workflow">}}

## Setup a Dynatrace Problem Notification

In order to create incidents in ServiceNow and to trigger workflows, an integration with Dynatrace has to be set up.

1. Login to your Dynatrace tenant.
1. Navigate to **Settings -> Integration -> Problem Notifications**
1. Click on **Set up notifications** and select **Custom Notification**
1. Choose a name for your integration, e.g., _keptn integration_
1. In the webhook URL, paste the value of your keptn external eventbroker endpoint appended by `/dynatrace`, e.g., `https://event-broker-ext.keptn.XX.XXX.XXX.XX.xip.io/dynatrace`
    - Note: retrieve the base URL by running:

    ```
    kubectl get ksvc event-broker-ext -n keptn
    ```
    Please click the checkbox **Accept any SSL certificate**
1. Additionally, an Authorization Header is needed to authorize against the keptn server. 
    - Click on **Add header**
    - The name for the header is: `Authorization`
    - The value has to be set to the following: `Bearer KEPTN_API_TOKEN` where KEPTN_API_TOKEN has to be replaced with your actual Api Token that was received during installation. You can always retrieve the token again by executing:

    ```
    kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode
    ```

1. As the custom payload, a valid Cloud Event has to be defined:

    ```json
    {
        "specversion":"0.2",
        "type":"sh.keptn.events.problem",
        "shkeptncontext":"{PID}",
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

Now that all pieces are in place we can run the use case. Therefore, we will start by generating some load on the `carts` service in our production environment. Afterwards we will change configuration of this service at runtime. This will cause some troubles in our production environment, Dynatrace will detect the issue and will create a problem ticket. Thanks to the problem notification we just set up, keptn will be informed about the problem and will forward it to the ServiceNow service that in turn creates an incident in ServiceNow. This incident will trigger a workflow that is able to remediate the issue at runtime. Along the remediation, comments and details on configuration changes are posted to Dynatrace.

### Load generation

1. Download the script provided for the load generation: https://raw
1. Run the script 
    ```
    ./add-to-cart.sh "carts.production.$(kubectl get svc istio-ingressgateway -n istio-system -o yaml | yq - r status.loadBalancer.ingress[0].ip).xip.io"
    ```
1. 

### Configuration change at runtime

can't be detected by keptn

### Problem Detections by Dynatrace


### Workflow execution by ServiceNow

