---
title: Runbook Automation and Self-healing
description: Gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use automation tools for executing and managing the runbooks.
weight: 30
keywords: [self-healing]
aliases:
---

This use case gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use ServiceNow workflows that are triggered to remediate incidents.

## About this use case

Configuration changes during runtime are sometimes necessary to increase flexibility. A prominent example are feature flags that can be toggled also in a production environment. In this use case we will change the promotion rate of a shopping cart service, which means that a defined percentage of interactions with the shopping cart will add promotional items (e.g., small gifts) to the shopping carts of our customers. However, we will experience troubles with this configuration change. Therefore, we will set means in place that are capable of auto-remediating issues at runtime. In fact, we will leverage workflows in ServiceNow. 

## Prerequisites

- ServiceNow instance or [free ServiceNow developer instance](https://developer.servicenow.com)
- [Setup of Dynatrace](../../monitoring/dynatrace/) is mandatory for this usecase 
- Complete [onboarding a service](../onboard-carts-service) use case
- Clone the GitHub repository with the necessary files for the use case:
    
    ```
    git clone --branch 0.1.0 https://github.com/keptn/servicenow-service.git
    cd servicenow-service
    ```

## Configure keptn

In order for keptn to use both ServiceNow and Dynatrace, the corresponding credentials have to be stored as Kubernetes secrets in the cluster. 

### Dynatrace Secret 

The Dynatrace secret should already have been created the Dynatrace secret for you and stored some needed information in environment variables.
Please verify by executing the following commands:

```
kubectl get secret dynatrace -n keptn -o yaml
```
The output should include the `DT_API_TOKEN` as well as the `DT_TENANT_ID` (both will be shown in base64 encoding):
```yaml
apiVersion: v1
data:
  DT_API_TOKEN: xxxxxx
  DT_TENANT_ID: xxxxxx
kind: Secret
metadata:
  creationTimestamp:
  ...
```

Additionally, we verify that the enviroment variables are set (execute line by line):
```
export DT_TENANT_ID=$(kubectl get secret dynatrace -n keptn -o=yaml | yq - r data.DT_TENANT_ID | base64 --decode)
export DT_API_TOKEN=$(kubectl get secret dynatrace -n keptn -o=yaml | yq - r data.DT_API_TOKEN | base64 --decode)
echo $DT_TENANT_ID
echo $DT_API_TOKEN
```

### ServiceNow Secret 

Create the ServiceNow secret to create/update incidents in ServiceNow and run workflows. For the command below, use your ServiceNow tenant id (8-digits), your ServiceNow user (e.g., *admin*) as user, and your ServiceNow password as token:
```
kubectl -n keptn create secret generic servicenow --from-literal="tenant=xxx" --from-literal="user=xxx" --from-literal="token=xxx"
```

## Setup the Workflow in ServiceNow

A ServiceNow *Update Set* is provided to run this use case. To install the *Update Set* follow these steps:

1. Login to your ServiceNow instance.
1. Look for *update set* in the left search box and navigate to **Update Sets to Commit** 
    {{< popup_image
    link="./assets/service-now-update-set-overview.png"
    caption="ServiceNow Update Set">}}

1. Click on **Import Update Set from XML** 

1. *Import* and *Upload* the file from your file system that you find in your `servicenow-service/usecase` folder: `keptn_demo_remediation_updateset.xml`

1. Open the *Update Set*
    {{< popup_image
    link="./assets/service-now-update-set-list.png"
    caption="ServiceNow Update Sets List">}}

1. In the right upper corner, click on **Preview Update Set** and once previewed, click on **Commit Update Set** to apply it to your instance
    {{< popup_image
    link="./assets/service-now-update-set-commit.png"
    caption="ServiceNow Update Set Commit">}}

1. After importing, enter **keptn** as the search term into the upper left search box.
    {{< popup_image 
    link="./assets/service-now-keptn-creds.png"
    caption="ServiceNow keptn credentials">}}

1. Click on **New** and enter your Dynatrace API token as well as your Dynatrace tenant ID.

1. *(Optional)* You can also take a look at the predefined workflow that is able to handle Dynatrace problem notifications and remediate issues.
    - Navigate to the workflow editor by typing **Workflow Editor** and clicking on the item **Workflow** > **Workflow Editor**
    - The workflow editor is opened in a new window/tab
    - Look for the workflow **keptn_demo_remediation** (it might as well be on the second or third page)
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
1. Navigate to **Settings** > **Integration** > **Problem notifications**
1. Click on **Set up notifications** and select **Custom integration**
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

1. Click on **Send test notification** and then on  **Save**.

    {{< popup_image
    link="./assets/dynatrace-problem-notification-integration.png"
    caption="Dynatrace Problem Notification Integration">}}

## Adjust Anomaly Detection in Dynatrace

The Dynatrace platform is built on top of AI which is great for production use cases but for this demo we have to override some default settings in order for Dynatrace to trigger the problem.

Before you adjust this setting, make sure to have some traffic on the service in order for Dynatrace to detect and list the service. The easiest way to generate traffic is to use the provided file `add-to-carts.sh` in the `./usecase` folder. This script will add items to the shopping cart and can be stopped after a couple of added items by hitting <kbd>CTRL</kbd>+<kbd>C</kbd>.

1. Navigate to the _servicenow-service/usecase_ folder: 
    ```
    cd usecase
    ```

1. Run the script:
    ```
    ./add-to-cart.sh "carts.production.$(kubectl get svc istio-ingressgateway -n istio-system -o yaml | yq - r status.loadBalancer.ingress[0].ip).xip.io"
    ```

1. Once you generated some load, navigate to **Transaction & services** and find the service **ItemsController** in the _production_ environment. 

2. Open the service and click on the three dots button to **Edit** the service.
    {{< popup_image
        link="./assets/dynatrace-service-edit.png"
        caption="Edit Service">}}

1. In the section **Anomaly detection** override the global anomaly detection and set the value for the **failure rate** to use **fixed thresholds** and to alert if **10%** custom failure rate are exceeded. Finally, set the **Sensitiviy** to **High**.
    {{< popup_image
        link="./assets/dynatrace-service-anomaly-detection.png"
        caption="Edit Anomaly Detection">}}

## Run the Use Case

Now, all pieces are in place to run the use case. Therefore, we will start by generating some load on the `carts` service in our production environment. Afterwards, we will change configuration of this service at runtime. This will cause some troubles in our production environment, Dynatrace will detect the issue, and will create a problem ticket. Due to the problem notification we just set up, keptn will be informed about the problem and will forward it to the ServiceNow service that in turn creates an incident in ServiceNow. This incident will trigger a workflow that is able to remediate the issue at runtime. Along the remediation, comments, and details on configuration changes are posted to Dynatrace.

### Load generation

1. Run the script:
    ```
    ./add-to-cart.sh "carts.production.$(kubectl get svc istio-ingressgateway -n istio-system -o yaml | yq - r status.loadBalancer.ingress[0].ip).xip.io"
    ```

1. You should see some logging output each time an item is added to your shopping cart:
    ```
    ...
    adding item to cart...
    {"id":"3395a43e-2d88-40de-b95f-e00e1502085b","itemId":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","quantity":73,"unitPrice":0.0}
    adding item to cart...
    {"id":"3395a43e-2d88-40de-b95f-e00e1502085b","itemId":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","quantity":74,"unitPrice":0.0}
    adding item to cart...
    {"id":"3395a43e-2d88-40de-b95f-e00e1502085b","itemId":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","quantity":75,"unitPrice":0.0}
    ...
    ```

### Configuration change at runtime

1. Open another terminal to make sure the load generation is still running and again, navigate to the _servicenow-service/usecase_ folder.

1. _(Optional:)_ Verify that the environment variables you set earlier are still available:
    ```
    echo $DT_TENANT_ID
    echo $DT_API_TOKEN
    ```

1. Additionally, the DT_TENANT_ID and DT_API_TOKEN must be exported for this terminal (execute line by line):
    ```
    export DT_TENANT_ID=$(kubectl get secret dynatrace -n keptn -o=yaml | yq - r data.DT_TENANT_ID | base64 --decode)
    export DT_API_TOKEN=$(kubectl get secret dynatrace -n keptn -o=yaml | yq - r data.DT_API_TOKEN | base64 --decode)
    echo $DT_TENANT_ID
    echo $DT_API_TOKEN
    ```

1. Run the script:
    ```
    ./enable-promotion.sh "carts.production.$(kubectl get svc istio-ingressgateway -n istio-system -o yaml | yq - r status.loadBalancer.ingress[0].ip).xip.io" 30
    ```
    Please note the parameter `30` at the end, which is the value for the configuration change and can be interpreted as for 30 % of the shopping cart interactions a special item is added to the shopping cart. This value can be set from `0` to `100`. For this use case the value `30` is just fine.

1. You will notice that your load generation script output will include some error messages after applying the script:
    ```
    ...
    adding item to cart...
    {"id":"3395a43e-2d88-40de-b95f-e00e1502085b","itemId":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","quantity":80,"unitPrice":0.0}
    adding item to cart...
    {"timestamp":1553686899190,"status":500,"error":"Internal Server Error","exception":"java.lang.Exception","message":"promotion campaign not yet implemented","path":"/carts/1/items"}
    adding item to cart...
    {"id":"3395a43e-2d88-40de-b95f-e00e1502085b","itemId":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","quantity":81,"unitPrice":0.0}
    ...
    ```

### Problem Detection by Dynatrace

Navigate to the ItemsController service by clicking on **Transactions & services** and look for your ItemsController. Since our service is running in three different environment (dev, staging, and production) it is recommended to filter by the `environment:production` to make sure to find the correct service.
    {{< popup_image
        link="./assets/dynatrace-services.png"
        caption="Dynatrace Transactions & Services">}}

When clicking on the service, in the right bottom corner you can validate in Dynatrace that the configuration change has been applied.
    {{< popup_image
        link="./assets/dynatrace-config-event.png"
        caption="Dynatrace Custom Configuration Event">}}


After a couple of minutes, Dynatrace will open a problem ticket based on the increase of the failure rate.
    {{< popup_image
        link="./assets/dynatrace-problem-open.png"
        caption="Dynatrace Open Problem">}}


### Incident Creation & Workflow Execution by ServiceNow

The Dynatrace problem ticket notification is sent out to keptn which puts it into the problem channel where the ServiceNow service is subscribed. Thus, the ServiceNow service takes the event and creates a new incident in ServiceNow. 
In your ServiceNow instance, you can take a look at all incidents by typing in **incidents** in the top-left search box and click on **Service Desk** > **Incidents**. You should be able to see the newly created incident, click on it to view some details.
    {{< popup_image
        link="./assets/service-now-incident.png"
        caption="ServiceNow incident">}}

After creation of the incident, a workflow is triggered in ServiceNow that has been setup during the import of the *Update Set* earlier. The workflow takes a look at the incident, resolves the URL that is stored in the *Remediation* tab in the incident detail screen. Along with that, a new custom configuration change is sent to Dynatrace. Besides, the ServiceNow service running in keptn sends comments to the Dynatrace problem to be able to keep track of executed steps.

You can check both the new _custom configuration change_ on the service overview page in Dynatrace as well as the added comment on the problem ticket in Dynatrace.

Once the problem is resolved, Dynatrace sends out another notification which again is handled by the ServiceNow service. Now the incidents gets resolved and another comment is sent to Dynatrace. The image shows the updated incident in ServiceNow. The comment can be found if you navigate to the closed problem ticket in Dynatrace. 
    {{< popup_image
        link="./assets/service-now-incident-resolved.png"
        caption="Resolved ServiceNow incident">}}



## Troubleshooting

- Please note that Dynatrace has its feature called **Frequent Issue Detection** enabled by default. This means, that if Dynatrace detects the same problem multiple times, it will be classified as a frequent issue and problem notifications won't be sent out to third party tools. Therefore, the use case might not be able to be run a couple of times in a row. To disable the feature for your tenant please reach out to the Dynatrace support team.

- In ServiceNow you can take a look at the **System Log** > **All** to verify which actions have been executed. You should be able to see some logs on the execution of the keptn demo workflow as shown in the screenshot:
    {{< popup_image
        link="./assets/service-now-systemlog.png"
        caption="ServiceNow System Log">}}
