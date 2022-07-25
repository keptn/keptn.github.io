---
title: How to integrate your tool?
description: Learn which way of integration fits your use case.
weight: 1
keywords: [0.18.x-integration]
---

There are multiple ways on how to interact with the Keptn control-plane. Besides the [Keptn API](../../reference/api/) and [Keptn CLI](../../reference/api/), there are more options how external tools can make use of the orchestration capabilities of Keptn. Those external tools can be triggered by Keptn and therefore integrated into a Keptn sequence execution.

In the following sections we look at different use cases to help you get started. If your use case is not listed, have a look at the generic option of Keptn service templates or feel free to [start a conversation in the #keptn-integrations channel in the Keptn Slack](https://slack.keptn.sh).

## General overview

In general, Keptn integrations (also called Keptn-services) integrate by receiving and sending events from and to the [Keptn control-plane](../../../concepts/architecture/). Once an integration is triggered, the integration (service) usually indicates its start and once completed, responds to the Keptn control-plane with a finished status. Some integrations, such as notifications (e.g., via Slack), might not want to indicate their progress, which is also possible. In the following, we will have a look at different use cases for integrations and how they can be implemented.

{{< popup_image
link="./assets/integration-sequence.png"
caption="General execution sequence of Keptn integrations"
width="700px">}}

## Use Cases

### Testing tools

Integrating (load and performance) test tools such as [JMeter](https://github.com/keptn/keptn/tree/master/jmeter-service), [Neoload](https://github.com/keptn-contrib/neoload-service), [Artillery](https://github.com/keptn-sandbox/artillery-service), [Locust](https://github.com/keptn-sandbox/locust-service), etc. is a common use case in Keptn. In this section, we will learn what is needed to integrate such tools.

Usually, a testing tool integration is getting triggered upon a `sh.keptn.event.test.triggered` event. This event is sent by the Keptn control-plane and the tool integration only has to listen for this type of event. In order to make sure that this event is sent by the Keptn control-plane, a `test` task needs to be present in the [shipyard](../../manage/shipyard/).

**Example shipyard** with a test task in each sequence:
```
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "test-shipyard"
spec:
  stages:
    - name: "test-automation"
      sequences:
      - name: "functionaltests"
        tasks:
        - name: "test"                  # your integration gets triggered here
          properties:
            teststrategy: "functional"
        - name: "evaluation"

      - name: "performancetests"
        tasks:
        - name: "test"                  # your integration gets triggered here
          properties:
            teststrategy: "performance"
        - name: "evaluation"
...
```

**Please note**: In general the task can be renamed. However, the important part is that both the event type and the task name correlate with your integration.

* Typically, test tools rely on some sort of test definition file, such as a `*.jmx` file for JMeter or `locustfile.py` for Locust. These files must be added to Keptn and will be managed by Keptn. Files can be added to Keptn via the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) Keptn CLI command. For example, if we have a project *sockshop* with a *carts* microservice, the following command adds the local resource `locustfile.py` to Keptn for each of the two sequences mentioned in our shipyard.

```
keptn add-resource --project=sockshop --stage=test-automation --service=carts --resource=./locustfile.py --resourceUri=locust/locustfile.py
```

* After a `test` task is defined in the shipyard and the test definitions are added to Keptn, the integration must subscribe to the test events. Depending on how your integration is built, this can be done by adding the subscription either in the [distributor](../custom_integration/#subscription-to-a-triggered-event) or to the [job-executor definition](https://github.com/keptn-sandbox/job-executor-service#how).

* Since the tests might run for some time, it is important that once the integration receives the `sh.keptn.event.test.triggered` event, it will respond with a `sh.keptn.event.test.started` event, and once finished it sends a `sh.keptn.event.test.finished` event.

### Notification tools

Let us have a look at notification tool integrations such as Slack, or MS Team where you want to push (specific) events to a channel to notify members of it.

* Usually, a notification tool reacts to a specific type of event or a set of events. The tool integration subscribes to these event types and then sends a defined payload to the channels. Consequently, there is no need to indicate that a notification integration starts and finishes the distribution of messages (i.e., no `*.started` or `*.finished` event is required).

* The easiest way to set up such an integration is by configuring a [Webhook Integration](./#webhook-integration). 

### Tools for your use cases

The integration of tools with the Keptn control-plane is not limited to specific use cases. Any tool can be integrated by interacting with the Keptn control-plane via CloudEvents.
As an inspiration, please have a look at the [Keptn sandbox repository](https://github.com/keptn-sandbox) that lists community contributions of all kinds. A lot of them have been using the [Keptn service template](https://github.com/keptn-sandbox?q=template&type=&language=&sort=) as a starting point, however, please have a look in the next section on different ways how to integrate with Keptn.

## Integration options

### Service Templates

The Keptn community currently provides two [Keptn service templates](https://github.com/keptn-sandbox?q=service-template&type=&language=&sort=):

1. [Keptn service template written in Go](https://github.com/keptn-sandbox/keptn-service-template-go)
2. [Keptn service template written in Python](https://github.com/keptn-sandbox/keptn-service-template-python)

The service templates provide the best starting point for integrations that need to stay in full control of how they integrate with the Keptn control-plane while still making use of some utility functions.
It is also best for integrations where business logic goes beyond a single execution of an action. For example, the Keptn service templates can handle a check  that combines authentication, execution, status check, error handling, etc.


### Job Executor

The [Keptn job executor](https://github.com/keptn-sandbox/job-executor-service) is appropriate for integrations that can be executed via the command-line interface. The job executor handles the interaction with the Keptn control-plane for sending `*.started` and `*.finished` events and can provide a list of files (e.g., test instructions) that are needed for integrations. Find all information regarding the capabilities and usage of the [job executor in its Github repository](https://github.com/keptn-sandbox/job-executor-service).


### Generic Executor

The [generic-executor-service](https://github.com/keptn-sandbox/generic-executor-service) allows users to provide `.sh` (shell scripts), `.py` (Python3) or `.http` (HTTP Request) files that are executed when Keptn sends different events, such as executing a specific script when a deployment-finished event is sent.


### Webhook Integration

[Please see the detailed description provided here.](../webhooks/)
