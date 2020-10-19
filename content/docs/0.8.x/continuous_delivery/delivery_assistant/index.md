---
title: Delivery Assistant
description: Approval of deployment for manual approval strategy
weight: 50
keywords: [0.7.x-cd]
aliases:
  - /docs/0.7.x/reference/bridge/delivery_assistent/
---

If you configured approval-strategy `manual` within your [multi-stage delivery](../multi_stage/#approval-strategy), Keptn will ask for an approval before deploying the artefact in the current stage, e.g.:


{{< popup_image
  link="./assets/bridge_approval_triggered.png"
  caption="Keptn Bridge Approval Triggered"
  width="764px">}}


You can approve or decline this deployment by sending an `approval.finished` CloudEvent via the Keptn CLI, Keptn Bridge or directly via the API.

## Approve or decline an open approval with Keptn CLI

* To fetch a list of open approvals, Keptn CLI provides the [`keptn get event approval.triggered`](../../reference/cli/commands/keptn_get_event_approval.triggered/) command:

    ```console
    $ keptn get event approval.triggered --project=sockshop --stage=production
    Starting to get approval.triggered events
    {
        "contenttype": "application/json",
        "data": {
            "deploymentstrategy": "blue_green_service",
            "image": "docker.io/keptnexamples/carts",
            "labels": null,
            "project": "sockshop",
            "result": "warning",
            "service": "carts",
            "stage": "production",
            "tag": "0.11.2",
            "teststrategy": "performance"
        },
        "id": "5bf26759-4afa-4045-8ccf-81bc398c2fcd",
        "shkeptncontext": "654c80b0-4a02-4d36-96f3-7447df1cdf41",
        "source": "gatekeeper-service",
        "specversion" : "1.0",
        "time": "2020-09-17T14:41:14.039Z",
        "type": "sh.keptn.event.approval.triggered"
    }
    ```
* In addition, by using the command [`keptn send-event approval.finished`](../../reference/cli/commands/keptn_send_event_approval.finished/) the CLI will print a list of open approvals and allows you to choose which one you want to approve/decline:

    ```console
    $ keptn send event approval.finished --project=ck-sockshop --stage=production --service=carts
    Starting to send approval.finished event
    
     OPTION	VERSION	EVALUATION	
     (1)	0.11.2	n/a		
    Select the option to approve or decline: 
    1
    Do you want to (a)pprove or (d)ecline: 
    a
    ID of Keptn context: 654c80b0-4a02-4d36-96f3-7447df1cdf41
    ```


## Approve or decline an open approval with Keptn Bridge
 
* To approve/decline an approval, open the *Environment* view, click on the stage that has a pending approval. When there are pending approvals for a service available, the service tile is expanded automatically. Additionally you can filter the services to see only services with pending approvals by clicking on the blue icon.

* By clicking on the green checkmark, the deployment will be approved. You can also decline by clicking on the red abort button. 

    {{< popup_image
      link="./assets/bridge_environment_assisteddelivery.png"
      caption="Keptn Bridge Assisted Delivery">}}

## Approve or decline an open approval with Keptn API

* Note down the keptn-context (`shkeptncontext`) and `id` (maps to `triggeredid`) of the [sh.keptn.event.approval.triggered](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#approval-triggered) CloudEvent, e.g., 
```
  "shkeptncontext": "654c80b0-4a02-4d36-96f3-7447df1cdf41",
  "id": "5bf26759-4afa-4045-8ccf-81bc398c2fcd",
```

* Specify a valid Keptn CloudEvent of type [sh.keptn.event.approval.finished](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#approval-finished) and store it as JSON file, e.g., `approval_finished.json`

```json
{
  "shkeptncontext": "654c80b0-4a02-4d36-96f3-7447df1cdf41",
  "source": "https://github.com/keptn/keptn/cli#approval.finished",
  "specversion" : "1.0",
  "type": "sh.keptn.event.approval.finished",
  "contenttype": "application/json",
  "triggeredid": "5bf26759-4afa-4045-8ccf-81bc398c2fcd",
  "data": {
    "approval": {
      "result": "pass",
      "status": "succeeded"
    },
    "deploymentstrategy": "blue_green_service",
    "eventContext": null,
    "image": "docker.io/keptnexamples/carts",
    "labels": null,
    "project": "ck-sockshop",
    "service": "carts",
    "stage": "production",
    "tag": "0.11.2",
    "teststrategy": "performance"
  }
}
```

* Send the approval finished event to the `/event` endpoint:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/event" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./approval_finished.json
```
