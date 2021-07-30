---
title: How to integrate your tool
description: Learn which way of integration fits your use-case.
weight: 1
keywords: [0.8.x-integration]
---

There are multiple ways on how to interact with the Keptn control-plane. Besides the [Keptn API](../../reference/api/) and [Keptn CLI](../../reference/api/) there are more ways how external tools can make use of the orchestration capabilities of Keptn. Those external tools can then be triggered by Keptn and therefore integrated in a Keptn sequence execution.

## Use Cases

### Testing tools

Integrating (load and performance) test tools such as [JMeter](https://github.com/keptn/keptn/tree/master/jmeter-service), [Neoload](https://github.com/keptn-contrib/neoload-service), [Artillery](https://github.com/keptn-sandbox/artillery-service), or [Locust](https://github.com/keptn-sandbox/locust-service) is a common use-case in Keptn. In this section, we'll learn what is needed to integrate such tools.

Usually, a testing tool integration is getting triggered upon a `sh.keptn.event.test.triggered` event. This event will be sent by the Keptn control plane and the tool integration only has to listen for this type of event. In order to make sure that this event is sent by the Keptn control plane, a `test` task needs to be present in the [shipyard](../../manage/shipyard/).

**Example shipyard** with a test task:
```
apiVersion: spec.keptn.sh/0.2.2
kind: "Shipyard"
metadata:
  name: "test-shipyard"
spec:
  stages:
    - name: "test-automation"
      sequences:
      - name: "functionaltests"
        tasks: 
        - name: "test" # your integration gets triggered here
          properties:
            teststrategy: "functional"
        - name: "evaluation"
      - name: "performancetests"
        tasks: 
        - name: "test" # your integration gets triggered here
          properties:
            teststrategy: "performance"
        - name: "evaluation"
...
```

Please note that in general the task can be renamed, the important part is that both the event-type and the task name correlate for your integration.

Typically, test tools rely on some way of test definition files, such as a `*.jmx` file for JMeter or `locustfile.py` for Locust. These files have to be added to Keptn and will be managed by Keptn. 
To add such a file, for example a `locustfile.py` it has to be added to Keptn, e.g., via the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) Keptn CLI command. Let's assume we have a project "sockshop" with a "carts" microservice and the two sequences mentioned in our shipyard, the following command will add the local resource `locustfile.py` to Keptn.

```
keptn add-resource --project=sockshop --stage=test-automation --service=carts --resource=./locustfile.py --resourceUri=locust/locustfile.py
```

Once a `test` task is defined in the shipyard, and the test definitions are added to Keptn, the integration needs to register for the test events. 
Depending on how your integration is built, this can be done either via [adding the subscription in the distributor](../custom_integration/#subscription-to-a-triggered-event) or by adding the subscription to the [job-executor definition](https://github.com/keptn-sandbox/job-executor-service#how).




### Notification tools

### Configuration tools

### Any other tool

## Integration options

### Service Templates

### Job Executor

### Webhook Integration

