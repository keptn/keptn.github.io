---
title: Write a Keptn-service
description: Implement your Keptn-service that listens to Keptn events and extends your Keptn with certain functionality.
weight: 2
keywords: [0.16.x-integration]
---

Here you learn how to add additional functionality to your Keptn installation with a custom [*Keptn-service*](#write-your-keptn-service), [*SLI-provider*](../sli_provider), or [*Action-provider*](../action_provider).

* A *Keptn-service* is responsible for implementing a continuous delivery or operations task.
* An *SLI-provider* is used to query Service-Level Indicators (SLI) from an external source like a monitoring or testing solution.
* An *Action-provider* is used to extend a task sequence for remediation with an additional action step.

## Template repository

A template for writing a new *Keptn-service*  is provided here: [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).
Please note that the master branch of this repository might represent a development state. Check out the [releases page](https://github.com/keptn-sandbox/keptn-service-template-go/releases) and download the code for a release that's compatible with the Keptn version you are going to develop for.

Since a *Keptn-service* is a Kubernetes service with a deployment and service template, the deployment manifest in the template repository can be re-used; see [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml).

This deployment manifest contains:

* Kubernetes **Deployment**, with two containers:
  * *keptn-service-template-go*: Replace the image of this container with the image of your implementation.
  * *distributor*: This container integrates with your Keptn and does the event handling. *Do not remove it.*
* Kubernetes **Service**

## Write your Keptn-service

A Keptn-service has the following characteristics:

* has a subscription to a **triggered event** that occurs during the execution of a task sequence (e.g., for continuous delivery or operations)
* sends a **started event** to inform Keptn about receiving the event and acting on it
* processes functionality and can therefore leverage additional tools, e.g., through their REST interface
* sends a **finished event** to inform Keptn about its execution status and the result

### Subscription to a triggered event

Your Keptn-service must have a subscription to at least one [Keptn CloudEvent](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md). The event type to subscribe to looks as follows:

- `sh.keptn.event.[task].triggered`

In this example, `[task]` works as a placeholder for tasks such as: `deployment`, `test`, `evaluation`, `remediation`, etc. The task defines the topic the Keptn-service is interested in. Assuming you are writing a Keptn-service for testing, the event type would be: `sh.keptn.event.test.triggered`.


**Distributor:**

* To subscribe your Keptn-service to the `sh.keptn.event.[task].triggered` event, a distributor with `PUBSUB_TOPIC` set to the specific event type is required, see example below. Alternatively, a default distributor listening to all events (e.g., `PUBSUB_TOPIC: sh.keptn.>`) is provided in the deployment manifest of the keptn-service-template-go template (see [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml)).

The `PUBSUB_TOPIC` variable sets the initial subscription for your service. If a subscription has been modified through the Bridge, Keptn will prioritize this information and it discards the value of `PUBSUB_TOPIC`. Please, look at the Bridge paragraph later on this page for more information on the subject.


```yaml
spec:
  containers:
  - name: distributor
    image: keptn/distributor:0.16.0
    ports:
    - containerPort: 8080
    resources:
      requests:
        memory: "16Mi"
        cpu: "25m"
      limits:
        memory: "128Mi"
        cpu: "250m"
    env:
      - name: PUBSUB_URL
        value: 'nats://keptn-nats-cluster'
      - name: PUBSUB_TOPIC
        value: 'sh.keptn.event.test.triggered'
      - name: PUBSUB_RECIPIENT
        value: '127.0.0.1'
```

In addition to forwarding received events for the subscribed topic to the Keptn-service, the distributor also provides the feature to act as a proxy to the Keptn API.
Using this feature, the following Keptn API services will be reachable for the Keptn-service via the following URLs, if the **distributor runs within the same K8s pod as the Keptn-service**:

- Mongodb-datastore:
    - `http://localhost:8081/mongodb-datastore`

- Configuration-service:
    - `http://localhost:8081/configuration-service`

- Shipyard-controller:
    - `http://localhost:8081/controlPlane`


To configure this distributor for your *Keptn-service*, the following environment variables can be adapted. However, in most scenarios only a subset of them needs to be configured. The full list of environment variables is as follows:

| Environment variable  | Description                                                                                                                              | Default Value               |
|-----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------------------------|
| KEPTN_API_ENDPOINT    | Keptn API Endpoint - needed when the distributor runs outside of the Keptn cluster                                                       | `""`                        |
| KEPTN_API_TOKEN       | Keptn API Token - needed when the distributor runs outside of the Keptn cluster                                                          | `""`                        |
| API_PROXY_PORT        | Port on which the distributor will listen for incoming Keptn API requests by its execution plane service                                 | `8081`.                     |
| API_PROXY_PATH        | Path on which the distributor will listen for incoming Keptn API requests by its execution plane service                                 | `/`.                        |
| HTTP_POLLING_INTERVAL | Interval (in seconds) in which the distributor will check for new triggered events on the Keptn API                                      | `10`                        |
| EVENT_FORWARDING_PATH | Path on which the distributor will listen for incoming events from its execution plane service                                           | `/event`                    |
| HTTP_SSL_VERIFY       | Determines whether the distributor should check the validity of SSL certificates when sending requests to a Keptn API endpoint via HTTPS | `true`                      |
| PUBSUB_URL            | The URL of the nats cluster the distributor should connect to when the distributor is running within the Keptn cluster                   | `nats://keptn-nats-cluster` |
| PUBSUB_TOPIC          | Comma separated list of topics (i.e. event types) the distributor should listen to                                                       | `""`                        |
| PUBSUB_RECIPIENT      | Hostname of the execution plane service the distributor should forward incoming CloudEvents to                                           | `http://127.0.0.1`          |
| PUBSUB_RECIPIENT_PORT | Port of the execution plane service the distributor should forward incoming CloudEvents to                                               | `8080`                      |
| PUBSUB_RECIPIENT_PATH | Path of the execution plane service the distributor should forward incoming CloudEvents to                                               | `/`                         |
| DISABLE_REGISTRATION  | Disables automatic registration of the Keptn integration to the control plane.                                                           | `false`                     |
| REGISTRATION_INTERVAL | Time duration between trying to re-register to the Keptn control plane.                                                                  |`10s`                        |
| LOCATION              | Location the distributor is running on, e.g. "executionPlane-A".                                                                         | `""`                        |
| DISTRIBUTOR_VERSION   | The software version of the distributor.                                                                                                 | `""`                        |
| VERSION               | The version of the Keptn integration.                                                                                                    | `""`                        |
| K8S_DEPLOYMENT_NAME   | Kubernetes deployment name of the Keptn integration.                                                                                     | `""`                        |
| K8S_POD_NAME          |  Kubernetes deployment name of the Keptn integration.                                                                                    | `""`                        |
| K8S_NAMESPACE         | Kubernetes namespace of the Keptn integration.                                                                                           | `""`                        |
| K8S_NODE_NAME         | Kubernetes node name the Keptn integration is running on.                                                                                | `""`                        |
| PROJECT_FILTER         | Filter events for a specific project, supports a comma-separated list of projects.                                                      | `""`                        |
| STAGE_FILTER         | Filter events for a specific stage, supports a comma-separated list of stages.                                                            | `""`                        |
| SERVICE_FILTER         | Filter events for a specific service, supports a comma-separated list of services.                                                      | `""`                        |

The above list of environment variables is pretty long, but in most scenarios only a few of them have to be set. The following examples show how to set the environment variables properly, depending on where the distributor and it's accompanying execution plane service should run:

<details><summary>*Distributor for Keptn-service that is running* **inside the Keptn control plane**: </summary>

<p>

| Environment variable  	| Setting 	|
|-----------------------	|:--------	|
| PUBSUB_RECIPIENT      	| Host name of the Keptn-service.        	|
| PUBSUB_RECIPIENT_PORT 	| Service port to receive the event (default: `8080`)        	|
| PUBSUB_RECIPIENT_PATH 	| Service endpoint to receive the event (default: `/`)        	|
| PUBSUB_TOPIC          	| Event(s) the Keptn-service is subscribed to. To subscribe to multiple events, declare a comma-separated list, e.g.: `sh.keptn.event.test.triggered, sh.keptn.event.evaluation.triggered` |

If your Keptn-service is running in the same pod as the distributor (which we recommend), and receives events at the port `8080` and the path `/`, you will only need to set the `PUBSUB_TOPIC` environment variable.

</p>
</details>


<details><summary>*Distributor for Keptn-service that is running* **outside the Keptn control plane (in execution plane)**: </summary>

<p>

| Environment variable  	| Setting 	|
|-----------------------	|:--------	|
| KEPTN_API_ENDPOINT       | The endpoint of the Keptn API, e.g. `https://my-keptn.dev/api`  	|
| KEPTN_API_TOKEN    | Keptn API token |
| HTTP_POLLING_INTERVAL            	| Polling interval in seconds   	|
| PUBSUB_RECIPIENT      	| Host name of the Keptn-service        	|
| PUBSUB_RECIPIENT_PORT 	| Service port to receive the event (default: `8080`)        	|
| PUBSUB_RECIPIENT_PATH 	| Service endpoint to receive the event (default: `/`)        	|
| PUBSUB_TOPIC          	| Event(s) the Keptn-service is subscribed to. To subscribe to multiple events, declare a comma-separated list, e.g.: `sh.keptn.event.test.triggered, sh.keptn.event.evaluation.triggered` |

If your Keptn-service is running in the same pod as the distributor (which we recommend), and receives events at the port `8080` and the path `/`, you will only need to set the `PUBSUB_TOPIC` environment variable.

</p>
</details>


**Bridge:**

After the application is deployed, its subscription can be changed directly in the Bridge.
For this, open Keptn Bridge, select a project, and go to the *Uniform* page.
Then select your service, and click the `Add subscription` button.

{{< popup_image
link="./assets/uniform_api.png"
caption="Add task subscription for your integration"
width="700px">}}

In this form, you can provide the information for the task subscription:

* *Task*: The task the integration should be fired on (e.g., `test` or `deployment`)
* *Task suffix*: The state of the task when the integration should be fired; select one of: `triggered`, `started`, of `finished`
* *Filter*: To restrict your integration to certain stages and services you can specify those using filters.

*Note:* multiple subscriptions can be added for the same service.

Keptn stores this subscriptions information also if the integration is not running.
By default, Keptn will still keep this information for 48h after the last contact with the integration.
This value can be configured using the [Advanced Install](../../operate/advanced_install_options/) option `shipyardController.config.uniformIntegrationTTL`.


### Send a started event

After receiving a `triggered` event for a particular task, your *Keptn-service* has to inform Keptn by sending an event of the type: 

- `sh.keptn.event.[task].started`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`.

**Send the event:**

To send the event to Keptn, two ways are possible:

1. Post it on the `v1/event` endpoint of Keptn
1. If the distributor is running as sidecar, post the event on `127.0.0.1:8081`

### Execute the functionality

The functionality of your *Keptn-service* depends on the capability you want to add to the continuous delivery or operational workflow. In many cases, the event payload -- containing meta-data such as the project, stage, or service name -- is first processed and then used to call the REST API of another tool.

### Send a finished event

After your *Keptn-service* has completed its functionality, it has to inform Keptn by sending an event of the type:

- `sh.keptn.event.[task].finished`

The request body needs to follow the [CloudEvent specification](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md) and the HTTP header attribute `Content-Type` has to be set to `application/cloudevents+json`.

**Add property to event header:**

Add to the *header* of the event:

  * `triggeredid`: The value of this property is the `id` of the `sh.keptn.event.[task].triggered` event.

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
        image: keptn/distributor:0.16.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "16Mi"
            cpu: "25m"
          limits:
            memory: "128Mi"
            cpu: "250m"
        env:
        - name: PUBSUB_URL
          value: 'nats://keptn-nats-cluster'
        - name: PUBSUB_TOPIC
          value: 'sh.keptn.event.deployment.finished'
        - name: PUBSUB_RECIPIENT
          value: '127.0.0.1'
        - name: VERSION
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: 'metadata.labels[''app.kubernetes.io/version'']'
        - name: K8S_DEPLOYMENT_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: 'metadata.labels[''app.kubernetes.io/name'']'
        - name: K8S_POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: K8S_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: K8S_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
```

To configure this distributor for your *Keptn-service*, two environment variables need to be adapted:

* `PUBSUB_RECIPIENT`: Defines the service address as specified in the Kubernetes service manifest (e.g., 127.0.0.1 or jmeter-service)
* `PUBSUB_TOPIC`: Defines the event type your *Keptn-service* is listening to (e.g. `sh.keptn.event.test.triggered`  or `sh.keptn.event.>`).

### Deploy Keptn-service and distributor

With a service and deployment manifest for your custom *Keptn-service* (`service.yaml`), you are ready to deploy both components in the K8s cluster where Keptn is installed:

```console
kubectl apply -f service.yaml -n keptn
```

## CloudEvents

CloudEvents have to be sent with the HTTP header `Content-Type` set to `application/cloudevents+json`. For a detailed look into CloudEvents, please go the Keptn [CloudEvent specification](https://github.com/keptn/spec/blob/0.2.3/cloudevents.md).

## Error Logging

By default, the distributor will automatically extract error logs from received `sh.keptn.<task>.finished` events with `data.status=errored` and/or `data.result=fail`, that have been sent by your service. These error messages will then be forwarded to Keptn's Log Ingestion API.

Additionally, for easier debugging of errors that occur either during the execution of a task of a sequence, or while performing any other operation, Keptn integration services can send error log events to the Keptn API via the distributor.
Examples for those events are listed below.

### Logging an error related task sequence execution:

If the error log event should be associated to an execution of a specific task that has been triggered by a `sh.keptn.event.<task>.triggered` event, the following properties need to be set in order to correlate them to the correct task sequence execution:

- `shkeptncontext`: The context of the task sequence execution. Can be adapted from the received `sh.keptn.event.<task>.triggered` event
- `triggeredid`: The `id` of the received `sh.keptn.event.<task>.triggered` event
- `data.task`: The name of the executed task.
- `data.message`: The message you would like to log

**Example event payload**

```json
{
  "specversion": "1.0",
  "id": "c4d3a334-6cb9-4e8c-a372-7e0b45942f53",
  "source": "source-service",
  "type": "sh.keptn.log.error",
  "datacontenttype": "application/json",
  "data": {
    "message": "an unexpected error occurred during the execution of my task",
    "task": "deployment"
  },
  "triggeredid": "3f9640b6-1d2a-4f11-95f5-23259f1d82d6",
  "shkeptncontext": "a3e5f16d-8888-4720-82c7-6995062905c1",
  "shkeptnspecversion": "0.2.3"
}
```

### Logging an error that is not related to the execution of a task

If the error log event should not be associated to an execution of a specific task, the properties `shkeptncontext`, `triggeredid`, and `data.task` are not required. In this case, an example payload would look as follows:

```json
{
  "specversion": "1.0",
  "id": "c4d3a334-6cb9-4e8c-a372-7e0b45942f53",
  "source": "source-service",
  "type": "sh.keptn.log.error",
  "datacontenttype": "application/json",
  "shkeptnspecversion": "0.2.3",
  "data": {
    "message": "an unexpected error occurred during the execution of my task",
    "task": "deployment"
  }
}
```
