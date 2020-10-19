---
title: Custom SLI-Provider
description: Implement an SLI-provider that queries an external data source for SLIs.
weight: 5
keywords: [0.8.x-integration]
---

An *SLI-provider* is an implementation of a [*Keptn-service*](../custom_integration/#keptn-service) with a dedicated purpose. This type of service is responsible for querying an external data source for SLIs that are then used by Keptn to evaluate an SLO. To configure a query for an indicator, Keptn provides the concept of an [SLI configuration](https://github.com/keptn/spec/blob/0.1.5/service_level_indicator.md#service-level-indicators-sli).

* Create a SLI configuration defining tool-specific queries for indicators. An example of an SLI configuration looks as follows:

```yaml
spec_version: '1.0'
indicators:
 throughput: "builtin:service.requestCount.total:merge(0):count?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
 error_rate: "builtin:service.errors.total.count:merge(0):avg?scope=tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
```

**Note:** This SLI configuration file will then be stored in Keptn's configuration store using the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command.

The [Keptn CloudEvents](#cloudevents) an *SLI-provider* has to subscribe to is:

- `sh.keptn.event.get-sli.triggered`

## Write your custom SLI-provider

Like a Keptn-service, an SLI-provider has the following characteristics: 

* has a **subscription** to an event
* sends a **started event** to inform Keptn about receiving the event and acting on it. 
* processes the functionality and integrates additional tools by accessing their REST interfaces. 
* sends a **finished event** to inform Keptn about its execution and the result. 

### Subscription to Keptn event

An *SLI-provider* starts working, when receiving a Keptn CloudEvent of type:

- [sh.keptn.event.get-sli.triggered](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md#get-sli) 

Next to event meta-data such as project, stage or service name, the event contains information about the indicators, time frame, and labels to query. For more details, please see the specification [here](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md#get-sli) and take a look at the example: 

```json
{
  "type": "sh.keptn.event.get-sli.triggered",
  "specversion": "0.2",
  "source": "https://github.com/keptn/keptn/lighthouse-service",
  "id": "f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "data": {
    "customFilters": [
      { "key" : "tags", "value": "test-subject:true" }
    ],
    "deployment": "direct",
    "deploymentstrategy": "direct",
    "indicators": ["throughput", "error_rate", "request_latency_p95"],
    "project": "sockshop",
    "service": "carts",
    "stage": "dev",
    "start": "2019-10-28T15:44:27.152330783Z",
    "end": "2019-10-28T15:54:27.152330783Z",
    "sliProvider": "dynatrace",
    "teststrategy":"manual",
    "labels": {
      "testId": "4711",
      "buildId": "build-17",
      "owner": "JohnDoe"
    }
  }
}
```

**Distributor:**

* To subscribe your SLI-provider to the `sh.keptn.event.action.triggered` event, a distributor is required. A default distributor is provided in the deployment manifest in the [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go) project. For an SLI-provider, it would look as follows:

```yaml
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
      value: 'sh.keptn.event.get-sli.triggered'
    - name: PUBSUB_RECIPIENT
      value: 'dynatrace-sli-provider'
```

To configure this distributor for your *SLI-provider*, two environment variables need to be set: 

* `PUBSUB_RECIPIENT`: Defines the service name of the SLI-provider as specified in the Kubernetes service manifest (mentioned below).
* `PUBSUB_TOPIC`: Has to be set to: `sh.keptn.event.get-sli.triggered`

**Receive event:**

From a technical perspective, your SLI-provider needs to listen on the `/` POST endpoint to receive the event from the distributor.

### Functionality

After receiving the `sh.keptn.event.get-sli.triggered` event, an SLI-provider must perform following tasks:

1. Process the incoming event to get the project, stage, and service name. Besides, you will need the indicators and time frame to query.  

1. Decide based on the `sliProvider` property whether the mentioned data source is supported by your SLI-provider. If the data source is not supported, no further task is required.

1. **Send a started event:** If the data source is supported, send a start event of type: [sh.keptn.event.get-sli.started](). This CloudEvent informs Keptn that your service takes care of fetching the SLIs. 

1. Get the SLI configuration from Keptn's configuration-service. This SLI configuration is identified by the `resourceURI`, which follows the pattern: `[tool-name]/sli.yaml` (e.g., `dynatrace/sli.yaml`). 
  * Service URL: http://configuration-service.keptn.svc.cluster.local:8080
  * Endpoint: `v1/project/{projectName}/stage/{stageName}/service/{serviceName}/resource/{resourceURI}`

1. Process the SLI configuration and use the defined queries to retrieve the values of each indicator. 

1. **Send a finished event:** Send a finished event of type: [sh.keptn.event.get-sli.finished](). This informs Keptn to proceed in evaluating the SLOs. 

## Deploy SLI-provider with distributor

With a service and deployment manifest for your custom *action-provider* (`service.yaml`), you are ready to deploy the *Keptn-service* in the Kubernetes cluster where Keptn is installed:

```console
kubectl apply -f service.yaml -n keptn
```

**Note:** A default manifest is provided in the keptn-service-template-go project, see: [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml). 