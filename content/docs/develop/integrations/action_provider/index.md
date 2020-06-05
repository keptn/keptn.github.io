---
title: Custom Action-Provider
description: Implement an action-provider that executes a remedation action as response to a problem.
weight: 10
---

An *action-provider* is an implementation of a [*Keptn-service*](../custom_integration/#keptn-service) with a dedicated purpose. This type of service is responsible for executing a remediation action with a specific automation tool. 

The [Keptn CloudEvents](#cloudevents) an action-provider has to subscribe to is:

- sh.keptn.event.action.triggered

## Implement custom Action-provider

**Incoming Keptn CloudEvent:** An *action-provider* listens to one specific Keptn CloudEvent type, which is the [sh.keptn.event.action.triggered](https://github.com/keptn/spec/blob/master/cloudevents.md#action-triggered) event. Next to event meta-data such as project, stage or service name, the event contains information about the action to execute and a value property. For more details, please see the specification [here](https://github.com/keptn/spec/blob/master/cloudevents.md#action-triggered). 

**Functionality:** The functionality of an *action-provider* focuses on executing an action to resolve an open problem. 

1. Process the incoming event to get the project, stage, and service name. Besides, you will need the `action` and `value` property. 

1. Based on the `action` property it must be verified, whether the action-provider supports the action. If the action is not supported, no action required.

1. If the action is supported, run the functionality the action-provider is designed for.

**Outgoing Keptn CloudEvent:** After executing the action, an *action-provider* returns one specific Keptn CloudEvent type, which is the [sh.keptn.event.action.finished](https://github.com/keptn/spec/blob/master/cloudevents.md#action-finished) event. This event contains the result and status of the executed action.

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
        image: keptn/distributor:0.6.2
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