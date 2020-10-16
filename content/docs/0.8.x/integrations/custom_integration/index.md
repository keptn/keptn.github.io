---
title: Write a Keptn-service
description: Implement your Keptn-service that listens to Keptn events and extends your Keptn with certain functionality.
weight: 1
keywords: [0.8.x-integration]
---

Here you learn how to add additional functionality to your Keptn installation with a custom [*Keptn-service*](#keptn-service), [*SLI-provider*](../sli_provider), or [*Action-provider*](../action_provider). 

* A *Keptn-service* is responsible for implementing a continuous delivery or operations task.
* An *SLI-provider* is used to query Service-Level Indicators (SLI) from an external source like a monitoring or testing solution. 
* An *Action-provider* is used to extend a task sequence for remediation with an additional action step.  

## Template Repository

We provide a fully functioning template for writing new services: [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).

## Write your Keptn-service

* must have a **subscription** to an event that occurs during the execution of a task sequence for continuous delivery or operations. 
* sends out a **started event** to inform Keptn about receiving the event.
* processes its functionality and can therefore integrate additional tools by accessing their REST interfaces. 
* sends out a **finished event** to inform Keptn about its execution and the result. 

### Subscription to Keptn event

A Keptn-service must have a subscription to at least one [Keptn CloudEvent](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md). The event type to subscribe to looks as follows:

- `sh.keptn.event.[task].triggered`

The `[task]` in the above example works as placeholder for tasks such as: `deployment`, `test`, `evaluation`, `remediation`, etc. In other words, the task defines the topic the Keptn-service is interested in. Assuming you writing a Keptn-service for testing, the event type would be: `sh.keptn.event.test.triggered`.

From a technical perspective, the Keptn-service has to listen on the `/` POST endpoint to receive this event. The integration with Keptn is managed by a Keptn component - *distributor* - explained below. 

### Send a started event

After receiving a `triggered` event for a particular task, a Keptn-service has to inform Keptn by sending an event of the type: 

- `sh.keptn.event.[task].started`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. 

To send the event to Keptn, two ways a possible: 

1. Post it on the `v1/event` endpoint of Keptn.
1. If the distributor is running as sidecar, post the event on `127.0.0.1:8081`.

### Execute the functionality

The functionality of your *Keptn-service* depends on the capability you want to add to the continuous delivery or operational workflow. In many cases, the event payload -- containing meta-data such as the project, stage, or service name -- is first processed and then used to call the REST API of another tool.  

### Send a finished event

After your *Keptn-service* has completed its functionality, it has to inform Keptn by sending an event of the type: 

- `sh.keptn.event.[task].finished`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. 

To send the event to Keptn, two ways a possible: 

1. Post it on the `v1/event` endpoint of Keptn.
1. If the distributor is running as sidecar, post the event on `127.0.0.1:8081`.

## Deployment and service template

A *Keptn-service* is a regular Kubernetes service with a deployment and service template. As a starting point for your service, the deployment and service manifest from the *keptn-service-template-go* can be re-used that can be found in the [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml).

This template contains: 

* **Deployment**, with two containers:
  * *keptn-service-template-go*: Replace the image of this container with the image of your implementation. 
  * *distributor*: This container integrates with your Keptn and does the event handling. Do not remove it.
* **Service**

### Subscribe service to Keptn event

**Distributor:** To subscribe your service to a Keptn event, a distributor is required. A distributor is part of the above mentioned deployment manifest and as shown by the example below:

```yaml
## jmeter-service: sh.keptn.events.deployment-finished
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jmeter-service-deployment-distributor
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
          value: 'sh.keptn.events.deployment-finished'
        - name: PUBSUB_RECIPIENT
          value: 'jmeter-service'
```

To configure this distributor for your *Keptn-service*, two environment variables need to be adapted: 

* `PUBSUB_RECIPIENT`: Defines the service name as specified in the Kubernetes service manifest.
* `PUBSUB_TOPIC`: Defines the event type your *Keptn-service* is listening to. 


## Deploy Keptn-service and distributor

With a service and deployment manifest for your custom *Keptn-service* (`service.yaml`) and a deployment manifest for the distributor (`distributor.yaml`), you are ready to deploy both components in the K8s cluster where Keptn is installed: 

```console
kubectl apply -f service.yaml
```

```console
kubectl apply -f distributor.yaml
```

## Summary
You will need to provide the following when you want to write a custom service:

- Your *Keptn-service* implementation including a Docker container. We recommend writing the service in *Go*
- The application needs to provide a REST endpoint at `/` that accepts `POST` requests for JSON objects.
- A `service.yaml` file containing the templates for the service and deployment manifest of your *Keptn-service*.
- A `distributor.yaml` file containing the template for the distributor and properly configured for your *Keptn-service*.


## CloudEvents

Please note that CloudEvents have to be sent with the HTTP header `Content-Type: application/cloudevents+json` to be set.
For a detailed look into CloudEvents, please go the Keptn [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md). 

## Logging

To inspect your service's log messages for a specific deployment run, you can use the `shkeptncontext` property of the incoming CloudEvents. Your service has to output its log messages in the following format:

```json
{
  "keptnContext": "<KEPTN_CONTEXT>",
  "logLevel": "INFO | DEBUG | WARNING | ERROR",
  "keptnService": "<YOUR_SERVICE_NAME>",
  "message": "logging message"
}
```

**Note:** For implementing logging into your *Go* service, you can import the [go-utils](https://github.com/keptn/go-utils) package that already provides common logging functions. 


To inspect your service's log messages for a specific deployment run, you can use the `shkeptncontext` property of the incoming CloudEvents. Your service has to output its log messages in the following format:

```json
{
  "keptnContext": "<KEPTN_CONTEXT>",
  "logLevel": "INFO | DEBUG | WARNING | ERROR",
  "keptnService": "<YOUR_SERVICE_NAME>",
  "message": "logging message"
}
```

**Note:** For implementing logging into your *Go* service, you can import the [go-utils](https://github.com/keptn/go-utils) package that already provides common logging functions. 
