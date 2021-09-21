---
title: Webhooks
description: Learn how to integrate external tooling using Webhooks
weight: 2
keywords: [0.10.x-integration]
---

Keptn has a built-in capability to integrate your webhooks into the sequence orchestration of Keptn. This lets you call custom HTTP endpoints when running a delivery or remediation sequence that triggers a certain task. By using this integration, you can easily send the state of a task to a third-party tool or service. This allows you to integrate tools such as testing services and incident management services. For example, using a webhook in combination with a testing tool lets you run a test based on a `test.triggered` event.  

Webhooks are created at a *Task* level and can be triggered by 3 task events: 

| Task events    	| Description                                         	|
|----------------	|-----------------------------------------------------	|
| Task triggered 	| The task has been triggered but is not yet running. 	|
| Task started   	| The task has begun running.                         	|
| Task finished  	| The task has finished.                              	|

## Create a Webhook 

To create a webhook, go to the *Uniform* page, select the *webhook-service*, and click the `Add subscription` button. 

{{< popup_image
link="./assets/add-webhook.png"
caption="Add task subscription for webhook-service"
width="700px">}}

In this form, provide the information for the subscription and webhook configuration: 

{{< popup_image
link="./assets/create-webhook.png"
caption="Form to create subscription and webhook configuration"
width="700px">}}

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

## Customize request payload

The output format of the webhook (i.e., payload of the request body) can be customized using event data to match the required input format of the tool you are integrating with. For doing so, put your course in the text field at the spot where you would like to customize the payload. Then click the *computer* icon that opens a list of data fields you can add to the payload. This list of data fields is derived from the event your webhook is subscribed to. 

{{< popup_image
link="./assets/customize-payload.png"
caption="Select event data to customize the request payload"
width="700px">}}

## Include sensitive data

When integrating tools by calling their endpoints, many times authentication is needed. This is done by storing an authentication token that is part of the webhook request. In Keptn you do this as follows: 

* Create a secret with a unique `name`, scope set to `webhook-service`, and a `key:value` pair whereas the key is a unique identifier of your secret and the value holds the sensitive data.

{{< popup_image
link="./assets/create-secret.png"
caption="Create a secret for webhook-service"
width="700px">}}

* When configuring your webhook, you can reference the sensitive data as part of the *URL*, *Custom header*, and in the *Custom payload*. Therefore, click the `key` icon that opens the list of available secrets. Select your secret and specify the key that refers to the sensitive data you would like to include at this point.  

{{< popup_image
link="./assets/add-secret-value.png"
caption="Usage of secrets to customize request"
width="700px">}}

## Advanced Webhook configuration

**Prerequisite:** It is required to have an upstream Git repo configured to get access to the configuration files.  

For more advanced configuration options, you can modify the raw request declared as [curl](https://curl.se/) command. Therefore, you need to access the `webhook.yaml` config file in the Git repo you set for an upstream. In this Git repo, you find the `webhook.yaml` file based on the filters you selected on the task subscription, e.g., if a filter is set for stage *production*, go to the *production* branch. 

Example of a `webhook.yaml` containing a webhook request declared as curl command: 

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

## Delete a Webhook

To delete a webhook, click on the trash can next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

{{< popup_image
link="./assets/delete-webhook.png"
caption="Delete a webhook"
width="700px">}}
