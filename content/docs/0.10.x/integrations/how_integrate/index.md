---
title: How to integrate your tool
description: Learn which way of integration fits your use-case.
weight: 1
keywords: [0.10.x-integration]
---

There are multiple ways on how to interact with the Keptn control-plane. Besides the [Keptn API](../../reference/api/) and [Keptn CLI](../../reference/api/) there are more options how external tools can make use of the orchestration capabilities of Keptn. Those external tools can then be triggered by Keptn and therefore integrated in a Keptn sequence execution.

In the following, we'll have a look at different use cases to help you get started. If your use case is not listed, have a look at the generic option of Keptn service templates or feel free to [start a conversation in the #keptn-integrations channel in the Keptn Slack](https://slack.keptn.sh).

## General overview

In general, Keptn integration (also called Keptn services) integrate by receiving and sending events from and to the [Keptn control-plane](../../../concepts/architecture/). Once an integration is triggered, the integration (service) usually indicates its start and once completed, responds to the Keptn control-plane with a finished status. Some integrations, such as notifications (e.g., via Slack), might not want to indicate their progress, which is also possible. In the following, we will have a look at different use-cases for integrations and how they can be implemented.

{{< popup_image
link="./assets/integration-sequence.png"
caption="General execution sequence of Keptn integrations"
width="700px">}}



## Use Cases

### Testing tools

Integrating (load and performance) test tools such as [JMeter](https://github.com/keptn/keptn/tree/master/jmeter-service), [Neoload](https://github.com/keptn-contrib/neoload-service), [Artillery](https://github.com/keptn-sandbox/artillery-service), or [Locust](https://github.com/keptn-sandbox/locust-service) is a common use-case in Keptn. In this section, we'll learn what is needed to integrate such tools.

Usually, a testing tool integration is getting triggered upon a `sh.keptn.event.test.triggered` event. This event is sent by the Keptn control plane and the tool integration only has to listen for this type of event. In order to make sure that this event is sent by the Keptn control plane, a `test` task needs to be present in the [shipyard](../../manage/shipyard/).

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
Files can be added to Keptn via the [keptn add-resource](../../reference/cli/commands/keptn_add-resource/) Keptn CLI command. Let's assume we have a project "sockshop" with a "carts" microservice, the following command will add the local resource `locustfile.py` to Keptn in both the two sequences mentioned in our shipyard.

```
keptn add-resource --project=sockshop --stage=test-automation --service=carts --resource=./locustfile.py --resourceUri=locust/locustfile.py
```

Once a `test` task is defined in the shipyard, and the test definitions are added to Keptn, the integration needs to register for the test events.
Depending on how your integration is built, this can be done either via [adding the subscription in the distributor](../custom_integration/#subscription-to-a-triggered-event) or by adding the subscription to the [job-executor definition](https://github.com/keptn-sandbox/job-executor-service#how).
Since the tests might run for some time, it is important that once the integration receives the `sh.keptn.event.test.triggered` event, it will response with a `sh.keptn.event.test.started` event, and once finished it sends a `sh.keptn.event.test.finished` event.

### Notification tools

Let's have a look at notification tool integrations such as Slack, or MS Team where you want to push (specific) events to a channel to notify members of it.

Usually, a notification tool reacts on a specific type of event or a set of events. The tool integration will subscribe these event types and then send a defined payload to the channels. Typically, there is no need to indicate that a notification integration starts and finishes the distribution of messages (i.e., no `*.started` or `*.finished` event has to be sent).

One way to build an integration is to use a [Keptn-service template](https://github.com/keptn-sandbox?q=template&type=&language=&sort=). The events the integration should listen for [can be added as a subscription in the distributor](../custom_integration/#subscription-to-a-triggered-event).

### Monitoring/observability tools (SLI-providers)

Keptn quality gates are defined by [SLOs and SLIs](../../../concepts/quality_gates/) and the data will be provided via SLI-providers. The job of an SLI provider is to:

1. listen for a `sh.keptn.event.get-sli.triggered` event and
2. respond with a `sh.keptn.event.get-sli.started` event once the retrieval of the data is started and
3. with a `sh.keptn.event.get-sli.finished` event including the SLIs as the payload once the retrieval of the data is finished.

Please have a look at the [Keptn service template](https://github.com/keptn-sandbox/keptn-service-template-go) that provides a stub about how to build your own SLI provider in the `eventhanders.go` file.


### Any other tool

The integration of tools with the Keptn control-plane is not limited to specific use-cases. Any tool can be integrated by interacting with the Keptn control plane via cloud events.
As an inspiration, please have a look at the [Keptn sandbox repository](https://github.com/keptn-sandbox) that lists community contributions of all kind. A lot of them have been using the [Keptn service template](https://github.com/keptn-sandbox?q=template&type=&language=&sort=) as a starting point, however, please have a look in the next section on different ways how to integrate with Keptn.

## Integration options

### Service Templates

The Keptn community currently provides two [Keptn service templates](https://github.com/keptn-sandbox?q=service-template&type=&language=&sort=):

1. [Keptn service template written in Go](https://github.com/keptn-sandbox/keptn-service-template-go)
2. [Keptn service template written in Python](https://github.com/keptn-sandbox/keptn-service-template-python)

The service templates provide the best starting point for integrations that need to stay in full control how to integrate with the Keptn control-plane while still making use of some utility functions.
It is also best for integrations which business logic goes beyond a single execution of an action. For example, if a authentication, execution, status check, error handling, etc is needed, the Keptn service templates allow to handle this.


### Job Executor

The [Keptn job executor](https://github.com/keptn-sandbox/job-executor-service) is used best for integrations that can be executed via the command-line interface. The job executor will handle the interaction with the Keptn control-plane for sending `*.started` and `*.finished` events and is able to provide a list of files (e.g., test instructions) that are needed for integrations. Find all information regarding the capabilities and usage of the [job executor in its Github repository](https://github.com/keptn-sandbox/job-executor-service).


### Generic Executor

The purpose of the [generic-executor-service](https://github.com/keptn-sandbox/generic-executor-service) is to allow users to provide either `.sh` (shell scripts), `.py` (Python3) or `.http` (HTTP Request) files that will be executed when Keptn sends different events, e.g: you want to execute a specific script when a deployment-finished event is sent.

### Webhook Integration

Keptn has a built-in capability to integrate your webhooks into the sequence orchestration. This lets you call custom HTTP endpoints when running a sequence that triggers a task the webhook should be called on. By using this integration, you can easily send the state of a sequence task to a third-party tool or service. This allows you to integrate tools such as testing services and incident management services. For example, using a webhook in combination with a testing tool lets you ...

*Overview:*

Webhooks are created at a *Task* level and can be triggered by 3 task events: 

| Task events    	| Description                                         	|
|----------------	|-----------------------------------------------------	|
| Task triggered 	| The task has been triggered but is not yet running. 	|
| Task started   	| The task has begun running.                         	|
| Task finished  	| The task has finished.                              	|

#### Create a Webhook 

To create a webhook, go to the *Uniform* page, select the *webhook-service* and click the `Add subscription` button. In this form, provide the information for the subscription and webhook configuration: 

> Screenshot needed

*Subscription:*

* *Task* - The task the webhook should be fired on.
* *Task suffix* - The state of the task when the webhook should be fired. Select of: [`triggered`, `started`, `finished`]
* *Filter* - To restrict the webhook to certain stages or services you can specify those here. 

*Webhook configuration:*

* *Request Method*: Choose the request method (POST, PUT, or GET)
* *URL:* The endpoint URL is where the webhook will send the request. 
* *Custom headers:* You can use the custom headers field to add HTTP headers to the request, such as unique identifiers or authentication credentials.
* *Custom payload:* Modify the payload to match the format requested by the receiving endpoint. (more details provided below)
* *Proxy*: If required, you can specify a proxy the request has to go through.

Click **Create subscription** to save and enable the webhook for your integration.

#### Custom payload

The output format of the webhook (i.e., payload of the request body) can be customized using event data to match the required input format of the tool you are integrating with. For doing so, put your course in the text field at the spot where you would like to customize the payload. Then click the *computer* icon that opens a list of data fields you can add to the payload. This list of data fields is derived from the event your webhook is subscribed to. 

> Screenshot needed

#### Include sensitive data

When integrating tools by calling their endpoints, many times authentication is needed. This is done by storing an authentication token that is part of the webhook request. In Keptn you do this as follows: 

* Create a secret with a unique `name`, scope set to `webhook-service`, and a `key:value` pair whereas the key is a unique identifier of your secret and the value holds the sensitive data.

> Screenshot needed

* When configuring your webhook, you can reference the sensitive data as part of the *URL*, *Custom header*, and in the *Custom payload*. Therefore, click the `key` icon that opens the list of available secrets. Select your secret and specify the key that refers to the sensitive data you would like to include at this point.  

> Screenshot needed

#### Advanced Webhook configuration

* **Prerequisite:** An upstream Git repo configured to get access to the configuration files.  

For more advanced configuration options, you can modify the raw request declared as [curl](https://curl.se/) command. Therefore, you need to access the `webhook.yaml` config file in the Git repo you set for an upstream. In this Git repo, you find the `webhook.yaml` file based on the filters you selected, e.g., if a filter is set for stage *production*, go to the *production*  branch. 

Example of a webhook declared as curl command: 
  ```
  apiVersion: webhookconfig.keptn.sh/v1alpha1
  kind: WebhookConfig
  metadata:
    name: webhook-configuration
  spec:
    webhooks:
      - type: sh.keptn.event.evaluation.finished
        requests:
          - "curl --request POST --data '{\"text\":\"Evaluation {{.data.evaluation.result}} with a score of {{.data.evaluation.score}} \"}'
            https://hooks.slack.com/services/{{.env.secretKey}}"
  ```

* You can customize the curl depending on your needs. 

* Adding a webhook by just extending this file is not supported, since the subscription to the event type is still missing. 

#### Delete a Webhook

To delete a webhook, click on the trash can next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

> Screenshot needed


