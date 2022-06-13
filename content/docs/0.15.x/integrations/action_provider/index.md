---
title: Custom Action-Provider
description: Implement an action-provider that executes a remediation action as response to a problem.
weight: 10
keywords: [0.15.x-integration]
---

An *action-provider* is an implementation of a [*Keptn-service*](../custom_integration/#write-your-keptn-service) with a dedicated purpose. This type of service is responsible for executing a remediation action and therefore might even use another tool. The [Keptn CloudEvents](../custom_integration/#cloudevents) an action-provider has to subscribe to is:

- `sh.keptn.event.action.triggered`

## Write your custom Action-provider

Like a Keptn-service, an action-provider has the following characteristics:

- has a **subscription** to an event (i.e., `sh.keptn.event.action.triggered`)
- sends a **started event** to inform Keptn about receiving the event and acting on it
- processes functionality and can therefore leverage additional tools, e.g., through their REST interface
- sends a **finished event** to inform Keptn about its execution status and the result

### Subscription to Keptn event

An *action-provider* starts working, when receiving a Keptn CloudEvent of type:

- [sh.keptn.event.action.triggered](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#action-triggered)

Next to meta-data such as project, stage, or service name, the event contains information about the action to execute. For more details, please see the specification [here](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#action-triggered) and take a look at the example:

```json
{
  "type": "sh.keptn.event.action.triggered",
  "specversion": "1.0",
  "source": "https://github.com/keptn/keptn/remediation-service",
  "id": "f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "data": {    
    "action": {
      "name": "Toggle feature flag",
      "action": "featuretoggle",
      "description": "Toggle feature flag PromotionCampaign from ON to OFF.",
      "value": {
        "PromotionCampaign": "off"
      }
    },
    "problem": {
      // contains problem details
    },
    "project": "sockshop",
    "stage": "production",
    "service": "carts"
  }
}
```

**Distributor:**

- To subscribe your action-provider to the `sh.keptn.event.action.triggered` event, please follow [Subscription to Keptn event](../custom_integration/#subscription-to-a-triggered-event).

### Functionality

After receiving the `sh.keptn.event.action.triggered` event, an action-provider must perform following tasks:

1. Process the incoming Keptn CloudEvent to receive meta-data such as project, stage, and service name. Besides, the action and value properties are required.

2. Decide based on the `action` property whether the action is supported. If the action is not supported, no further task is required.

3. **Send a started event:** If the action is supported, send a start event of type: `sh.keptn.event.action.started`. This CloudEvent informs Keptn that a service takes care of executing the action.

4. Execute the implemented functionality. At this step, the action-provider can make use of another automation tool.

5. **Send a finished event:** Send a finished event of type: `sh.keptn.event.action.finished` with the added properties:  

- Add to the *header* of the event:
  - `triggeredid`: The value of this property is the `id` of the `sh.keptn.event.action.triggered` event.

- Add to the *data block* at least a value for `status` and `result` in `data.action`:
  - `status`: [succeeded, errored, unknown] - The status of the task execution
  - `result`: [pass, failed] - The result of a successful task execution

```json
{
  "type": "sh.keptn.event.action.finished",
  "specversion": "1.0",
  "source": "https://github.com/keptn/keptn/unleash-service",
  "id": "ggb878d3-03c0-4e8f-bc3f-454bc1b3d888",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "triggeredid": "2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",      # <- add triggeredid
  "data": {
    "action": {                                              # <- add data.action
      "status": "succeeded",
      "result": "pass"
    },
    "project": "sockshop",
    "service": "carts",
    "stage": "staging",
    "labels": {
      "testId": "4711",
      "buildId": "build-17",
      "owner": "JohnDoe"
    }
  }
}
```

## Deploy Action-provider with distributor

A default deployment manifest is provided in the keptn-service-template-go template, see: [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/tree/0.14.0/chart).

- Change the deployment manifest for your *action-provider* and the apply it to the Kubernetes cluster where Keptn is running:

```console
kubectl apply -f service.yaml -n keptn
```
