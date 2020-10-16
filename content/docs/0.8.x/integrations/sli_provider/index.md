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


The [Keptn CloudEvents](#cloudevents) a SLI-provider has to subscribe to is:

- sh.keptn.internal.event.get-sli

## Implement custom SLI-provider

**Incoming Keptn CloudEvent:** An *SLI-provider* listens to one specific Keptn CloudEvent type, which is the [sh.keptn.internal.event.get-sli](https://github.com/keptn/spec/blob/0.1.2/cloudevents.md#get-sli) event. Next to event meta-data such as project, stage or service name, the event contains information about the indicators, time frame, and labels to query. For more details, please see the specification [here](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md#get-sli). 

**Functionality:** The functionality of an *SLI-provider* focuses on querying indicator values from an external data source. Before a query can be fired towards the data source, the following steps are necessary:

1. Process the incoming event to get the project, stage, and service name. Besides, you will need the indicators and time frame to query.  

1. Get the SLI configuration from Keptn's configuration-service. This SLI configuration is identified by the `resourceURI`, which follows the pattern: `[tool-name]/sli.yaml` (e.g., `dynatrace/sli.yaml`). 
  * Service URL: http://configuration-service.keptn.svc.cluster.local:8080
  * Endpoint: `v1/project/{projectName}/stage/{stageName}/service/{serviceName}/resource/{resourceURI}`

1. Process the SLI configuration and use the defined queries to retrieve the values of each indicator. 

**Outgoing Keptn CloudEvent:** An *SLI-provider* returns one specific Keptn CloudEvent type, which is the [sh.keptn.internal.event.get-sli.done](https://github.com/keptn/spec/blob/0.1.6/cloudevents.md#get-sli-done) event. This event contains the retrieved value of each queried indicator.  

**Deployment and service template:** Like any custom *Keptn-service*, an SLI-provider is a regular Kubernetes service with a deployment and service template. See [here](../custom_integration/#example-jmeter-service) how to define those templates for your SLI-provider. 

## Subscribe SLI-provider to Keptn event

**Distributor:** To subscribe your SLI-provider to the `sh.keptn.internal.event.get-sli` event, a distributor is required. A distributor comes with a deployment manifest as shown by the example below:

```yaml
## dynatrace-sli-provider: sh.keptn.internal.event.get-sli
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dynatrace-sli-provider-distributor
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
          value: 'sh.keptn.internal.event.get-sli'
        - name: PUBSUB_RECIPIENT
          value: 'dynatrace-sli-provider'
```

To configure this distributor for your *SLI-provider*, the environment variables `PUBSUB_RECIPIENT` has to refer to the service name of the SLI-provider in the Kubernetes service manifest. Besides, make sure the environment variable `PUBSUB_TOPIC` has the value `sh.keptn.internal.event.get-sli`.