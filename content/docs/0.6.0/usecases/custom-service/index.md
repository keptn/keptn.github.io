---
title: Write your own Keptn Service
description: Explains you how to implement your own Keptn service that listens to Keptn events and extends your Keptn with certain functionality.
weight: 90
keywords: [service, custom]
aliases:
---

Explains you how to implement your own Keptn service that listens to Keptn events and extends your Keptn with certain functionality.

## About this tutorial

The goal of this tutorial is to describe how you can add additional functionality to your Keptn installation by implementing your own custom services. You can react to certain events that occur during your continuous delivery pipeline runs and integrate additional tools into your pipeline by accessing their REST interfaces with your custom services. At the moment the events you can subscribe to include:

- sh.keptn.events.new-artifact
- sh.keptn.events.configuration-changed
- sh.keptn.events.deployment-finished
- sh.keptn.events.tests-finished
- sh.keptn.events.evaluation-done
- sh.keptn.events.problem

## Writing your own service

As a reference for writing your own service, please have a look at our implementation of the [JMeter Service](https://github.com/keptn/keptn/blob/0.6.0.beta2/jmeter-service). Essentially, this service is a *Go* application that accepts POST requests at its `/` endpoint. To be more specific, the request body needs to follow the [Cloud Event specification](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. Of course, you can write your own service in any language, as long as it provides the endpoint to receive events.

A Keptn service is a regular Kubernetes service with a deployment and service template. The deployment and service manifest for the *jmeter-service* can be found in the [deploy/service.yaml](https://github.com/keptn/keptn/blob/0.6.0.beta2/jmeter-service/deploy/service.yaml) file in `jmeter-service` directory of the Keptn GitHub repository:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jmeter-service
  namespace: keptn
spec:
  selector:
    matchLabels:
      run: jmeter-service
  replicas: 1
  template:
    metadata:
      labels:
        run: jmeter-service
    spec:
      containers:
      - name: jmeter-service
        image: keptn/jmeter-service:0.6.0.beta2
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: jmeter-service
  namespace: keptn
  labels:
    run: jmeter-service
spec:
  ports:
  - port: 8080
    protocol: TCP
  selector:
    run: jmeter-service
```

## Subscribe service to Keptn events 

To subscribe your service to certain Keptn event, a **distributor** is required. A distributor comes with a deployment manifest as shown below:

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
        image: keptn/distributor:latest
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

To configure this distributor for the `jmeter-service`, two environment variables need to be set:
1. `PUBSUB_RECIPIENT` - Defines the service name.
1. `PUBSUB_TOPIC` - Defines the event type the service is listening to. 

## Deploy service and distributor

With a service and deployment manifest for your custom service (`service.yaml`) as well as a deployment manifest for the distributor (`distributor.yaml`), you are ready to deploy both components:

```console
kubectl apply -f service.yaml
```

```console
kubectl apply -f distributor.yaml
```

## Conclusion
You will need to provide the following when you want to write a custom service:

- Your service implementation including a Docker container, we recommend writing the service in *Go*
- The application needs to provide a REST endpoint at `/` that accepts `POST` requests for JSON objects.
- A `service.yaml` file containing the templates for the service and deployment manifest of your service.
- A `distributor.yaml` file containing the template for the distributor and properly configured for your service.

**Note:** This documentation will be replaced with an extensive step-by-step guide in the future.

## Cloud Events

Please note that Cloud Events have to be sent with the HTTP header `Content-Type: application/cloudevents+json` to be set.
For a detailed look into Cloud Events, please go the Keptn [Cloud Event specification](https://github.com/keptn/spec/blob/0.1.1/cloudevents.md). 

## Logging

To inspect your service's log messages for a specific deployment run, you can use the `shkeptncontext` property of the incoming Cloud Events. Your service has to output its log messages in the following format:

```json
{
  "keptnContext": "<KEPTN_CONTEXT>",
  "logLevel": "INFO | DEBUG | WARNING | ERROR",
  "keptnService": "<YOUR_SERVICE_NAME>",
  "message": "logging message"
}
```

**Note:** For implementing logging into your *Go* service, you can import the [go-utils](https://github.com/keptn/go-utils) package that already provides common logging functions. 
