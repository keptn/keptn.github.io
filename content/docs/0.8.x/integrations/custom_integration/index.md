---
title: Write a Keptn-service
description: Implement your Keptn-service that listens to Keptn events and extends your Keptn with certain functionality.
weight: 1
keywords: [0.8.x-integration]
---

Here you learn how to add additional functionality to your Keptn installation with a custom [*Keptn-service*](#keptn-service), [*SLI-provider*](../sli_provider), or [*Action-provider*](../action_provider). 

* A *Keptn-service* is responsible for implementing a continuous delivery or operations task.
* An *SLI-provider* is used to query Service-Level Indicators (SLI) from an external source like a monitoring or testing solution. 
* An *Action-provider* is used to extend a task sequence for remediation with an individual action step.  

## Template Repository

We provide a fully functioning template for writing new services: [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).

## Keptn-service

A *Keptn-service* is intended to react to certain events that occur during the execution of a task sequence for continuous delivery or operations. After getting triggered by an event, a *Keptn-service* processes some functionality and can therefore integrate additional tools by accessing their REST interfaces.

A Keptn-service can subscribe to various [Keptn CloudEvents](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md), e.g.:

- sh.keptn.events.configuration-changed
- sh.keptn.events.deployment-finished
- sh.keptn.events.tests-finished
- sh.keptn.events.evaluation-done
- sh.keptn.events.problem

### Implement custom Keptn-service

If you are interested in writing your own testing service, have a look at the [jmeter-service](https://github.com/keptn/keptn/blob/0.7.2/jmeter-service).

### Example: JMeter Service

**Incoming Keptn CloudEvent:** The *jmeter-service* is a *Go* application that accepts POST requests at its `/` endpoint. To be more specific, the request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. Of course, you can write your service in any language, as long as it provides the endpoint to receive events.

**Functionality:** The functionality of your *Keptn-service* depends on the capability you want to add to the continuous delivery or operational workflow. In many cases, the event payload -- containing meta-data such as the project, stage, or service name as well as shipyard information -- is first processed and then used to call the REST API of another tool.  

**Outgoing Keptn CloudEvent:** After your *Keptn-service* has completed its functionality, it has to send a CloudEvent to the event broker of Keptn. This informs Keptn to continue a particular task sequence.  

**Deployment and service template:** A *Keptn-service* is a regular Kubernetes service with a deployment and service template. As a starting point for your service the deployment and service manifest of the *jmeter-service* can be used, which can be found in the [deploy/service.yaml](https://github.com/keptn/keptn/blob/0.7.2/jmeter-service/deploy/service.yaml):

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jmeter-service
  namespace: keptn
  labels:
    app.kubernetes.io/name: jmeter-service
    app.kubernetes.io/instance: keptn
    app.kubernetes.io/part-of: keptn
    app.kubernetes.io/component: execution-plane
    app.kubernetes.io/version: 0.7.2
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: jmeter-service
      app.kubernetes.io/instance: keptn
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: jmeter-service
        app.kubernetes.io/instance: keptn
        app.kubernetes.io/part-of: keptn
        app.kubernetes.io/component: execution-plane
        app.kubernetes.io/version: 0.7.2
    spec:
      containers:
      - name: jmeter-service
        image: keptn/jmeter-service:0.7.2
        livenessProbe:
          httpGet:
            path: /health
            port: 10999
          initialDelaySeconds: 5
          periodSeconds: 5
        ports:
        - containerPort: 8080
        env:
        - name: EVENTBROKER
          value: 'http://event-broker.keptn.svc.cluster.local/keptn'
---
apiVersion: v1
kind: Service
metadata:
  name: jmeter-service
  namespace: keptn
  labels:
    app.kubernetes.io/name: jmeter-service
    app.kubernetes.io/instance: keptn
    app.kubernetes.io/part-of: keptn
    app.kubernetes.io/component: execution-plane
spec:
  ports:
  - port: 8080
    protocol: TCP
  selector:
    app.kubernetes.io/name: jmeter-service
    app.kubernetes.io/instance: keptn
```

### Subscribe service to Keptn event

**Distributor:** To subscribe your service to a Keptn event, a distributor is required. A distributor comes with a deployment manifest as shown by the example below:

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
For a detailed look into CloudEvents, please go the Keptn [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.5/cloudevents.md). 

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
