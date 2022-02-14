---
title: Webhook Integration
description: Learn how to integrate external tooling using Webhooks
weight: 2
keywords: [0.13.x-integration]
---

Keptn has a built-in capability call a custom HTTP endpoints when running a delivery or remediation sequence following a task event. Webhook configurations, referred to as subscriptions, are created at a *Task* level and are configured to listen to one of the the following task [event types](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#task-events):

| Event types     | Description                                           |
|---------------- |-----------------------------------------------------  |
| Task triggered  | The task has been triggered but is not yet running.   |
| Task started    | The task has begun running.                           |
| Task finished   | The task has finished.                                |

By using this integration, you can easily send the state of a task to a third-party tool or service. This allows you to integrate various tools such as testing services, existing CI/CD pipelines, and incident management services. 

## Webhook subscription types

Broadly, there are two types:
* *Non-interactive* - These webhooks subscribes to task `started` or `finished` events to just call a downstream system.  Or they can subscribe to a task `triggered` event and the webhook services sends back the `finished` task event to complete the sequence.  
* *Interactive* - These webhooks subscribes to task `triggered` events and used when when the downstream system is able and must to send back a `finished` task event to complete the sequence.  

## Configure Non Interactive on task "started" or "finished" events

For this use case, the webhook subscription is configured to listen to task `started` or `finished` events. For this to work, the task is responsible to send the `started` and `finished` events.

One example is the `evaluation` task that sends the `finished` event with the Service Level Objective (SLO) results. By subscribing to the `finished` event, these SLO results can be sent to some downstream system such as a slack notification using the webhook subscription custom payload.

**Step 1: Add subscription**

To create a webhook integration, open Keptn Bridge, select a project, and go to the *Uniform* page. Then select *webhook-service*, and click the `Add subscription` button. 

{{< popup_image
link="./assets/add-webhook.png"
caption="Add task subscription for webhook-service"
width="700px">}}

In this form, provide the information for the task subscription and webhook configuration: 

{{< popup_image
link="./assets/create-webhook.png"
caption="Form to create subscription and webhook configuration"
width="700px">}}

*Subscription:*

* *Task*: The task the webhook should be fired on (e.g., `test` or `deployment`)
* *Task suffix*: The state of the task when the webhook should be fired; select one of: `started`, of `finished`
* *Filter*: To restrict the webhook to certain stages and services you can specify those using filters. 

*Webhook configuration:*

* *Request method*: Choose the request method; select one of: `GET`, `POST` or `PUT`.
* *URL*: The endpoint URL is where the webhook will send the request.
* *Custom headers*: You can use the custom headers field to add HTTP headers to the request, such as unique identifiers or authentication credentials.
* *Custom payload*: Modify the payload to match the format requested by the receiving endpoint. (more details provided below)
* *Proxy*: If required, you can specify a proxy the request has to go through.
* Click **Create subscription** to save and enable the webhook for your integration.

*Important Notes:* 

* Many APIs require `Content-Type: application/json` so be sure to add this as a custom header. 
* Webhook subscriptions are stored in clear text within the GIT project repository, so be sure to store tokens or other secret data as Keptn secrets. Details on creating and using secrets this is [described below](#include-sensitive-data).

**Step 2: Customize request payload**

The output format of the webhook (i.e., the payload of the request body) can be customized using event data to match the 
required input format of the tool you are integrating with. Therefore, you can reference the data field (event property) 
using [Go templating](https://blog.gopheracademy.com/advent-2017/using-go-templates/). For example, if you would like to get the value of the `project` property from the 
subscribed event, type in: `{{.data.project}}`. A look at the example event can help to identify the proper data field. 

*An example of a customized request payload:*   

```
{
  "text": "Evaluation in {{.data.stage}} finished with result {{.data.evaluation.result}} and score {{.data.evaluation.score}}."
}
```

Based on the Go templating capabilities, you can: 

* Define conditions: `"{{if .fieldName}}{{.fieldName}}{{ else }}No field name set{{ end }}"` 
* Access an array element: `"{{ index .articles.Content 0 }}"`
* Refer to attributes with non-string characters `"(index .data "incident-management-tool").url"`

*An example of a customized request payload using a condition on an array element:*

```
{
  "deploymentURL": "{{if index .data.deployment.deploymentURIsPublic 0}}{{index .data.deployment.deploymentURIsPublic 0}}{{else}}No deployment URL provided{{end}}"
}
```

<details><summary>*Preview* of customization support released with 0.12.0</summary>
<p>

For a more convenient way, a feature is planned where you can put your cursor in the text field at the spot where you would like to customize the payload. Then click the *computer* icon that opens a list of data fields you can add to the payload. This list of data fields is derived from the event your webhook is subscribed to. 

{{< popup_image
link="./assets/customize-payload.png"
caption="Select event data to customize the request payload"
width="700px">}}

</p>
</details>

## Configure Non-interactive on task "triggered" events

For this use case, a downstream system is called and the Keptn webhook service sends the task `finished` event to complete the sequence. This type is called *Non-interactive* because the downstream system does not send back a `finished` task event. An example of this is setting a feature flag where the downstream system can't send confirmation that it set the flag.

The details are explained below, but the webhook subscription must be configured with `sendFinished: true` so that the Keptn webhook service will send the `finished` task event. 

**Step 1: Add subscription**

1. Follow the same steps above to add a new webhook subscription, but configure it to listen to a Task suffix of `triggered`. 
1. Click **Create subscription** to save the webhook for your integration.

**Step 2: Adjust subscription**

A UI enhancement is coming, but for now, you need to edit your webhook configuration within your Git project Repo as follows:

1. Open up the project in your git upstream repo and adjust the `webhook.yaml` file.

1. Configure the `webhook.yaml` file to not send the `finished` event by adding the attribute `sendFinished: true` as shown below.

  ```
  apiVersion: webhookconfig.keptn.sh/v1alpha1
  kind: WebhookConfig
  metadata:
    name: webhook-configuration
  spec:
    webhooks:
      - type: sh.keptn.event.test.triggered
        sendFinished: true 
        requests:
          - "curl --request POST --data
          '{\"event_type\":\"silent\",\"client_payload\":{\"type\":\"{{.type}}\
          \",\"project\":\"{{.data.project}}\",\"service\":\"{{.data.service}}\
          \",\"stage\":\"{{.data.stage}}\",\"shkeptncontext\":\"{{.shkeptnconte\
          xt}}\",\"id\":\"{{.id}}\"}}''
            https://example.com?token={{.env.secret_api_token}}"
  ```

*Note:* Once you edit the webhook file in GIT, you should not edit the webhook in the Web UI else the `sendFinished` setting will need to be manually re-added back.

## Configure Interactive webhook on task "triggered" events

This type is called *Interactive* because the downstream system must to send back a `finished` task event. An example of this is to trigger a system to open an incident management ticket and send back the newly created incident ticket number within the task `finished` event so that the sequence can continue.

**Prerequisite:** This requires access to the [upstream Git repo](../../manage/git_upstream/) in order to modify the webhook configuration files.  

**Step 1: Add subscription**

1. Follow the same steps above to add a new webhook subscription, but configure it to listen to a Task suffix of `triggered`  
1. The custom payload should include the following data in order for the receiving tool to properly respond with a `finished` event:
  * `{{.id}}` - required in the `triggeredid` attribute of the `finished` event
  * `{{.shkeptncontext}}` - required in the `shkeptncontext` attribute of the `finished` event
  * Optional, but depends on your implementation: `{{.data.project}}`, `{{.data.service}}`, `{{.data.stage}}`
1. Click **Create subscription** to save the webhook for your integration.
  
*Note*: Custom payload fields can be either passed within the Data block, or as query params in the URL, depending on the receiving tools configuration.

**Step 2: Downstream system**

Since no `finished` event is sent by Keptn, the downstream system must send a `finished` event to the `/v1/event` endpoint of the Keptn API. The Keptn cloud event must contain the following attributes:
  * `type` - required event type in format of `sh.keptn.event.[REPLACE WITH YOUR TASK NAME].finished`
  * `triggeredid` - required `id` from the task `triggered` cloud event
  * `shkeptncontext` - required `shkeptncontext` from the task `triggered` cloud event
  * Optional, but depends on your implementation: `data.project`, `data.service`, `data.stage`
  
For example:

  ```
  curl -X POST "https://KEPTP_URL/api/v1/event" -H "accept: application/json" -H "x-token: KEPTN_API_TOKEN" -H "Content-Type: application/json" -d JSON_DATA

  JSON_DATA example:
  {
    "data": {
      "project":"YOUR PROJECT",
      "stage":"YOUR STAGE",
      "service": "YOUR SERVICE",
      "status": "succeeded",
      "result": "pass"
    },
    "source": "keptn-project",
    "specversion": "1.0",
    "type": "sh.keptn.event.[REPLACE WITH YOUR TASK NAME].finished",
    "shkeptncontext": "REPLACE WITH SHKEPTNCONTEXT FROM THE TRIGGERED EVENT",
    "triggeredid": "REPLACE WITH ID FROM THE TRIGGERED EVENT"
  }
  ```

The downsteam system can also send back custom information within the `finished` event and it will be automatically appended to every remaining `triggered` task event in the sequence.  The data much be passed in a attribute with the name of the task.  

For example for a task named `createTicket`, the following is sent back:

  ```
  {
    "data": {
      "project":"YOUR PROJECT",
      "stage":"YOUR STAGE",
      "service": "YOUR SERVICE",
      "status": "succeeded",
      "result": "pass",
      "createTicket": {
        "customKey1":"customData1",
        "customKey2":"customData2"
      } 
    },
    "source": "keptn-project",
    "specversion": "1.0",
    "type": "sh.keptn.event.[REPLACE WITH YOUR TASK NAME].finished",
    "shkeptncontext": "REPLACE WITH SHKEPTNCONTEXT FROM THE TRIGGERED EVENT",
    "triggeredid": "REPLACE WITH ID FROM THE TRIGGERED EVENT"
  }
  ```

## Delete a Webhook

To delete a webhook integration, click on the *trash can* icon next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

{{< popup_image
link="./assets/delete-webhook.png"
caption="Delete a webhook"
width="700px">}}

*Note*: Deleting a webhook means that the subscription in Uniform is deleted, as well as the webhook configuration file within the Git repo.

## Include sensitive data

When integrating tools by calling their endpoints, many times authentication is needed. This is done by storing an authentication token that is part of the webhook request. Since Webhook subscriptions are stored in clear text within the GIT project repository, so be sure to store tokens or other secret data as Keptn secrets as follows: 

* Create a secret with a unique `name`, secret scope set to `keptn-webhook-service`, and a `key:value` pair whereas the key is a unique identifier of your secret and the value holds the sensitive data.
  {{< popup_image
  link="./assets/create-secret.png"
  caption="Create a secret for webhook-service"
  width="700px">}}

* When configuring your webhook, you can reference the sensitive data as part of the *URL*, *Custom header*, and in the *Custom payload*. Therefore, click the *key* icon that opens the list of available secrets. Select your secret and specify the key that refers to the sensitive data you would like to include at this point and the key-value pair will be automatically inserted into the selected field in the format `{{.secret.name.key}}`. 

  {{< popup_image
  link="./assets/add-secret-value.png"
  caption="Usage of secrets to customize request"
  width="700px">}}

* For example, a secret called `api` with key called `api-token` used in a webhook URL for triggering a Jenkins job would look like: 

  ```
  https://example.com?token={{.secret.api.api-token}}"
  ```

*Note*: When the webhook configuration is saved, the secret will be parsed into a different format, which looks like this: `{{.env.secret_name_key}}`. This format represents a unique name that is a referrer to an entry in the `envFrom` property in the `webhook.yaml` file. This `envFrom` property contains added secrets with a referrer name, the given secret name, and secret key.

```
apiVersion: webhookconfig.keptn.sh/v1alpha1
kind: WebhookConfig
metadata:
  name: webhook-configuration
spec:
  webhooks:
    - type: sh.keptn.event.deployment.started
      envFrom:
        - name: secret_api_token
          secretRef:
            name: api
            key: api-token
        
      requests:
        - "curl --request POST https://example.com?token={{.env.secret_api_token}}"
```

## Advanced Webhook configuration

**Prerequisite:** This requires access to the [upstream Git repo](../../manage/git_upstream/) in order to modify the webhook configuration files.  

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

* **Note**: Adding a webhook by just extending this file is not supported, since the subscription to the event type is still missing. 

## Examples

See [Keptn Integrations](../../../integrations) for examples.