---
title: Custom Action-Provider
description: Implement an action-provider that executes a remedation action as response to a problem.
weight: 10
keywords: [0.7.x-integration]
---

An *action-provider* is an implementation of a [*Keptn-service*](../custom_integration/#keptn-service) with a dedicated purpose. This type of service is responsible for executing a remediation action and therefore might even use another tool.  

The [Keptn CloudEvents](#cloudevents) an action-provider has to subscribe to is:

- sh.keptn.event.action.triggered

## Implement custom Action-provider

**Incoming Keptn CloudEvent:** An *action-provider* starts working, when receiving a Keptn CloudEvent of type: [sh.keptn.event.action.triggered](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#action-triggered) event. Next to meta-data such as project, stage or service name, the event contains information about the action to execute and a value property. For more details, please see the specification [here](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#action-triggered) and take a look at the example: 

```json
{
  "type": "sh.keptn.event.action.triggered",
  "specversion": "0.2",
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
      // contains all problem details
    },
    "project": "sockshop",
    "stage": "production",
    "service": "carts"
  }
}
```

**Functionality:** After receiving the triggered event, an action-provider must perform following tasks:

1.  Process the incoming Keptn CloudEvent to receive meta-data such as project, stage, and service name. Besides, the action and value properties are required.

2. Decide based on the `action` property whether the action is supported. If the action is not supported, no further task is required.

3. **Send start event:** If the action is supported, send a start event of type: [sh.keptn.event.action.started](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#action-started). This CloudEvent informs Keptn that a service takes care of executing the action. 

4. Execute the implemented functionality. At this step, the action-provider can make use of another automation tool. 

5. **Send finished event:** Send a finished event of type: [sh.keptn.event.action.finished](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md#action-finished). This informs Keptn to proceed in the remediation or operational workflow. 

**Deployment and service template:** Like any custom *Keptn-service*, an action-provider is a regular Kubernetes service with a deployment and service template. See [here](../custom_integration/#example-jmeter-service) how to define those templates for your action-provider. 

## Subscribe Action-provider to Keptn event

**Distributor:** To subscribe your action-provider to the `sh.keptn.event.action.triggered` event, a distributor is required. A distributor comes with a deployment manifest as shown by the example below:

```yaml
## action-provider: sh.keptn.event.action.triggered
apiVersion: apps/v1
kind: Deployment
metadata:
  name: action-provider-distributor
  namespace: keptn
spec:
  selector:
    matchLabels:
      run: distributor
  replicas: 1
  template:
    metadata:
      labels:
        run: distributor
    spec:
      containers:
      - name: distributor
        image: keptn/distributor:0.7.2
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "32Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "500m"
        env:
        - name: PUBSUB_URL
          value: 'nats://keptn-nats-cluster'
        - name: PUBSUB_TOPIC
          value: 'sh.keptn.event.action.triggered'
        - name: PUBSUB_RECIPIENT
          value: 'action-provider'
```

To configure this distributor for your *action-provider*, the environment variables `PUBSUB_RECIPIENT` has to refer to the service name of the action-provider in the Kubernetes service manifest. Besides, make sure the environment variable `PUBSUB_TOPIC` has the value `sh.keptn.event.action.triggered`.