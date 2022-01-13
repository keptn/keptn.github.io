---
title: Custom SLI-Provider
description: Implement an SLI-provider that queries an external data source for SLIs.
weight: 5
keywords: [0.12.x-integration]
---

An *SLI-provider* is an implementation of a [*Keptn-service*](../custom_integration/#keptn-service) with a dedicated purpose. This type of service is responsible for querying an external data source for SLIs that are then used by Keptn to evaluate an SLO. To configure a query for an indicator, Keptn provides the concept of an [SLI configuration](https://github.com/keptn/spec/blob/0.2.2/service_level_indicator.md#service-level-indicators-sli).

* Create a SLI configuration defining tool-specific queries for indicators. An example of an SLI configuration looks as follows:

```yaml
spec_version: '1.0'
indicators:
  throughput: "metricSelector=builtin:service.requestCount.total:merge(\"dt.entity.service\"):sum&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
  error_rate: "metricSelector=builtin:service.errors.total.count:merge(\"dt.entity.service\"):avg&entitySelector=type(SERVICE),tag(keptn_project:$PROJECT),tag(keptn_stage:$STAGE),tag(keptn_service:$SERVICE),tag(keptn_deployment:$DEPLOYMENT)"
```

**Note:** This SLI configuration file will then be stored in Keptn's configuration store using the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command.

The [Keptn CloudEvents](#cloudevents) an *SLI-provider* has to subscribe to is:

- `sh.keptn.event.get-sli.triggered`

## Write your custom SLI-provider

Like a Keptn-service, an SLI-provider has the following characteristics: 

* has a **subscription** to an event (i.e., `sh.keptn.event.get-sli.triggered`)
* sends a **started event** to inform Keptn about receiving the event and acting on it
* processes functionality and can therefore leverage additional tools, e.g., through their REST interface
* sends a **finished event** to inform Keptn about its execution status and the result

### Subscription to Keptn event

An *SLI-provider* starts working, when receiving a Keptn CloudEvent of type:

- [sh.keptn.event.get-sli.triggered](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#get-sli) 

Next to event meta-data such as project, stage, or service name, the event contains information about the indicators, time frame, and labels to query. For more details, please see the specification [here](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#get-sli) and take a look at the example: 

```json
{
  "type": "sh.keptn.event.get-sli.triggered",
  "specversion": "1.0",
  "source": "https://github.com/keptn/keptn/lighthouse-service",
  "id": "f2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "data": {
    "get-sli": {
        "customFilters": [
          { "key" : "tags", "value": "test-subject:true" }
        ],
        "indicators": ["throughput", "error_rate", "request_latency_p95"],
        "start": "2019-10-28T15:44:27.152330783Z",
        "end": "2019-10-28T15:54:27.152330783Z",
        "sliProvider": "dynatrace"
    },
    "project": "sockshop",
    "service": "carts",
    "stage": "dev",
    "labels": {
      "testId": "4711",
      "buildId": "build-17",
      "owner": "JohnDoe"
    }
  }
}
```

**Distributor:**

* To subscribe your SLI-provider to the `sh.keptn.event.action.triggered` event, please follow [Subscription to Keptn event](../custom_integration/#subscription-to-keptn-event).


### Functionality


After receiving the `sh.keptn.event.get-sli.triggered` event, an SLI-provider must perform following tasks:

1. Process the incoming event to get the project, stage, and service name. Besides, you will need the indicators and time frame to query.  

2. Decide based on the `sliProvider` property whether the mentioned data source is supported by your SLI-provider. If the data source is not supported, no further task is required.

3. **Send a started event:** If the data source is supported, send a start event of type: `sh.keptn.event.get-sli.started`. This CloudEvent informs Keptn that your service takes care of fetching the SLIs. 

4. Get the SLI configuration from Keptn's configuration-service. This SLI configuration is identified by the `resourceURI`, which follows the pattern: `[tool-name]/sli.yaml` (e.g., `dynatrace/sli.yaml`). 
  * Service URL: http://configuration-service.keptn.svc.cluster.local:8080
  * Endpoint: `v1/project/{projectName}/stage/{stageName}/service/{serviceName}/resource/{resourceURI}`

5. Process the SLI configuration and use the defined queries to retrieve the values of each indicator. 

6. **Send a finished event:** Send a finished event of type: `sh.keptn.event.get-sli.finished` with the added properties:  

  * Add to the *header* of the event: 
      * `triggeredid`: The value of this property is the `id` of the `sh.keptn.event.get-sli.triggered` event. 

  * Add to the *data block* at least a value for `status`, `result` and `indicatorValues` in `data.get-sli`:
      * `status`: [succeeded, errored, unknown] - The status of the task execution
      * `result`: [pass, failed] - The result of a successful task execution
      * `indicatorValues`: List of indicators and their measured values

```json
{
  "type": "sh.keptn.event.get-sli.finished",
  "specversion": "1.0",
  "source": "dynatrace-service",
  "id": "ggb878d3-03c0-4e8f-bc3f-454bc1b3d888",
  "time": "2019-06-07T07:02:15.64489Z",
  "contenttype": "application/json",
  "shkeptncontext": "08735340-6f9e-4b32-97ff-3b6c292bc509",
  "triggeredid": "2b878d3-03c0-4e8f-bc3f-454bc1b3d79d",      # <- add triggeredid
  "data": {
    "get-sli": {                                             # <- add data.get-sli
      "status": "succeeded",
      "result": "pass",
      "indicatorValues": [
        {
          "metric":"request_latency_p95",
          "value": 1.1620000000000001,
          "success": true
        },
        {
          "metric":"error_rate",
          "value": 0,
          "success": true
        }
      ]
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

## Deploy SLI-provider with distributor

A default deployment manifest is provided in the keptn-service-template-go template, see: [deploy/service.yaml](https://github.com/keptn-sandbox/keptn-service-template-go/blob/master/deploy/service.yaml). 

* Change the deployment manifest for your *SLI-provider* and the apply it to the Kubernetes cluster where Keptn is running:

```console
kubectl apply -f service.yaml -n keptn
```
