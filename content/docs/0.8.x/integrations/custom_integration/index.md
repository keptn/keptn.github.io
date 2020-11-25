---
title: Write a Keptn-service
description: Implement your Keptn-service that listens to Keptn events and extends your Keptn with certain functionality.
weight: 1
keywords: [0.8.x-integration]
---

Here you learn how to add additional functionality to your Keptn installation with a custom [*Keptn-service*](#write-your-keptn-service), [*SLI-provider*](../sli_provider), or [*Action-provider*](../action_provider). 

* A *Keptn-service* is responsible for implementing a continuous delivery or operations task.
* An *SLI-provider* is used to query Service-Level Indicators (SLI) from an external source like a monitoring or testing solution. 
* An *Action-provider* is used to extend a task sequence for remediation with an additional action step.  

## Template repository

A template for writing a new *Keptn-service*  is provided here: [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).

Since a *Keptn-service* is a Kubernetes service with a deployment and service template, the deployment manifest in the template repository can be re-used; see [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml).

This deployment manifest contains: 

* Kubernetes **Deployment**, with two containers:
  * *keptn-service-template-go*: Replace the image of this container with the image of your implementation. 
  * *distributor*: This container integrates with your Keptn and does the event handling. *Do not remove it.*
* Kubernetes **Service**

## Write your Keptn-service

A Keptn-service has the following characteristics: 


* has a **subscription** to an event that occurs during the execution of a task sequence for continuous delivery or operations
* sends a **started event** to inform Keptn about receiving the event and acting on it
* processes functionality and can therefore leverage additional tools, e.g., through their REST interface
* sends a **finished event** to inform Keptn about its execution status and the result

### Subscription to Keptn event

Your Keptn-service must have a subscription to at least one [Keptn CloudEvent](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md). The event type to subscribe to looks as follows:

- `sh.keptn.event.[task].triggered`

In this example, the `[task]` works as a placeholder for tasks such as: `deployment`, `test`, `evaluation`, `remediation`, etc. The task defines the topic the Keptn-service is interested in. Assuming you are writing a Keptn-service for testing, the event type would be: `sh.keptn.event.test.triggered`.

**Distributor:**

* To subscribe your Keptn-service to the `sh.keptn.event.[task].triggered` event, a distributor is required. A default distributor is provided in the deployment manifest of the keptn-service-template-go template (see [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml)) and as shown by the example below:

```yaml
spec:
  containers:
  - name: distributor
    image: keptn/distributor:0.8.0
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
    - name: CONNECTION_TYPE
      value: 'nats'
    - name: PUBSUB_URL
      value: 'nats://keptn-nats-cluster'
    - name: PUBSUB_TOPIC
      value: 'sh.keptn.event.test.triggered'
    - name: PUBSUB_RECIPIENT
      value: 'jmeter-service'
```

To configure this distributor for your *Keptn-service*, three environment variables need to be adapted: 

<details><summary>*Distributor for Keptn-service that is running* **inside the Keptn control plane**: </summary>

<p>

| Environment variable  	| Setting 	|
|-----------------------	|:--------	|
| CONNECTION_TYPE       	| `nats`   	|
| PUBSUB_URL            	| `nats://keptn-nats-cluster`   	|
| PUBSUB_RECIPIENT      	| Service name as specified in the Kubernetes service manifest mentioned below.        	|
| PUBSUB_RECIPIENT_PORT 	| Service port to receive the event (default: `8080`)        	|
| PUBSUB_RECIPIENT_PATH 	| Service endpoint to receive the event (default: `/`)        	|
| PUBSUB_TOPIC          	| Event(s) the Keptn-service is subsribed to. To subscribe to multiple events, declare a comma-separated list, e.g.: `sh.keptn.event.test.triggered, sh.keptn.event.evaluation.triggered` |

</p>
</details>


<details><summary>*Distributor for Keptn-service that is running* **outside the Keptn control plane (in execution plane)**: </summary>

<p>

| Environment variable  	| Setting 	|
|-----------------------	|:--------	|
| CONNECTION_TYPE       	| `http`   	|
| HTTP_EVENT_POLLING_ENDPOINT       | The endpoint to poll for triggered events. It must end with: `/v1/event/triggered` (default: `http://shipyard-controller:8080/v1/event/triggered`)  	|
| HTTP_EVENT_ENDPOINT_AUTH_TOKEN    | Keptn API token |
| HTTP_POLLING_INTERVAL            	| Polling interval in minutes   	|
| HTTP_EVENT_FORWARDING_ENDPOINT | The endpoint to send the `started` and `finished` event   	|
| PUBSUB_RECIPIENT      	| Service name as specified in the Kubernetes service manifest mentioned below.        	|
| PUBSUB_RECIPIENT_PORT 	| Service port to receive the event (default: `8080`)        	|
| PUBSUB_RECIPIENT_PATH 	| Service endpoint to receive the event (default: `/`)        	|
| PUBSUB_TOPIC          	| Event(s) the Keptn-service is subsribed to. To subscribe to multiple events, declare a comma-separated list, e.g.: `sh.keptn.event.test.triggered, sh.keptn.event.evaluation.triggered` |
</p>
</details>

### Send a started event

After receiving a `triggered` event for a particular task, your *Keptn-service* has to inform Keptn by sending an event of the type: 

- `sh.keptn.event.[task].started`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. 

**Send the event:**

To send the event to Keptn, two ways are possible: 

1. Post it on the `v1/event` endpoint of Keptn
1. If the distributor is running as sidecar, post the event on `127.0.0.1:8081`

### Execute the functionality

The functionality of your *Keptn-service* depends on the capability you want to add to the continuous delivery or operational workflow. In many cases, the event payload -- containing meta-data such as the project, stage, or service name -- is first processed and then used to call the REST API of another tool.  

### Send a finished event

After your *Keptn-service* has completed its functionality, it has to inform Keptn by sending an event of the type: 

- `sh.keptn.event.[task].finished`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`. 

**Add data to event payload:**

You can send data back to Keptn by adding it to the data block in the event payload. In more details, the data block has a reserved space depending on the event type. If, for example, your Keptn service has a subscription to a `sh.keptn.event.test.finished` event, the reserved space is `data.test`. Your Keptn-service is allowed to add data there, but must provide at least a value for `status` and `result`:

* `status`: [succeeded, errored, unknown] - The status of the task execution. 
* `result`: [pass, failed] - The result of a successful task execution. 

```json
{
  "type": "sh.keptn.event.test.finished",
  "specversion": "1.0",
  "source": "https://github.com/keptn/keptn/jmeter-service",
  "id": "ggb878d3-03c0-4e8f-bc3f-454bc1b3d888",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "triggeredid" : "f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",
  "data": {
    "test": {
      "status": "succeeded",
      "result": "pass"
    },
    "project": "sockshop",
    "stage": "staging",
    "service": "carts",
    "labels": {
      "testId": "4711",
      "buildId": "build-17",
      "owner": "JohnDoe"
    }
  }
}
```

**Send the event:**

To send the event to Keptn, two ways are possible: 

1. Post it on the `v1/event` endpoint of Keptn
1. If the distributor is running as sidecar, post the event on `127.0.0.1:8081`

## Deploy Keptn-service with distributor

### Subscribe service to Keptn event

**Distributor:** To subscribe your service to a Keptn event, a distributor is required. A distributor is part of the above mentioned deployment manifest and shown by the example below:

```yaml
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
        image: keptn/distributor:0.7.3
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

With a service and deployment manifest for your custom *Keptn-service* (`service.yaml`), you are ready to deploy both components in the K8s cluster where Keptn is installed: 

```console
kubectl apply -f service.yaml -n keptn
```

## CloudEvents

CloudEvents have to be sent with the HTTP header `Content-Type` set to `application/cloudevents+json`. For a detailed look into CloudEvents, please go the Keptn [CloudEvent specification](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md). 

## Logging

To inspect the log messages of your Keptn-service for a specific deployment run, you can use the `shkeptncontext` property of the incoming CloudEvents. Your service has to output its log messages in the following format:

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
