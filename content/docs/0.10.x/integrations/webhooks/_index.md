---
title: Webhook Integration
description: Learn how to integrate external tooling using Webhooks
weight: 2
keywords: [0.10.x-integration]
---

Keptn has a built-in capability to integrate your webhooks into the sequence orchestration of Keptn. This lets you call
custom HTTP endpoints when running a delivery or remediation sequence that triggers a certain task. By using this 
integration, you can easily send the state of a task to a third-party tool or service. This allows you to integrate
various tools such as testing services, existing CI/CD pipelines, and incident management services. 


## Create a Webhook integration

Webhooks are created at a *Task* level and can be triggered by the following [event types](https://github.com/keptn/spec/blob/0.2.2/cloudevents.md#task-events):

| Event types     | Description                                           |
|---------------- |-----------------------------------------------------  |
| Task triggered  | The task has been triggered but is not yet running.   |
| Task started    | The task has begun running.                           |
| Task finished   | The task has finished.                                |

To create a webhook integration, open Keptn Bridge, select a project, and go to the *Uniform* page. Then select
*webhook-service*, and click the `Add subscription` button. 

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
* *Task suffix*: The state of the task when the webhook should be fired; select one of: `triggered`, `started`, of `finished`
* *Filter*: To restrict the webhook to certain stages and services you can specify those using filters. 

*Webhook configuration:*

* *Request method*: Choose the request method; select one of: `GET`, `POST` or `PUT`.
* *URL*: The endpoint URL is where the webhook will send the request.
* *Custom headers*: You can use the custom headers field to add HTTP headers to the request, such as unique identifiers or authentication credentials.
* *Custom payload*: Modify the payload to match the format requested by the receiving endpoint. (more details provided below)
* *Proxy*: If required, you can specify a proxy the request has to go through.

Click **Create subscription** to save and enable the webhook for your integration.

## Customize request payload

The output format of the webhook (i.e., the payload of the request body) can be customized using event data to match the 
required input format of the tool you are integrating with. Therefore, you can reference the data field (event property) 
using a templating mechanism. For example, if you would like to get the value of the `project` property from the 
subscribed event, type in: `{{.data.project}}`. A look at the example event can help to identify the proper data field. 

* An example of a customized request payload:   

```
{
  "text": "Evaluation in {{.data.stage}} finished with result {{.data.evaluation.result}} and score {{.data.evaluation.score}}."
}
```

<details><summary>*Preview* of customization support released with 0.11.0</summary>
<p>

For a more convenient way, a feature is planned where you can put your cursor in the text field at the spot where you would like to customize the payload. Then click the *computer* icon that opens a list of data fields you can add to the payload. This list of data fields is derived from the event your webhook is subscribed to. 

{{< popup_image
link="./assets/customize-payload.png"
caption="Select event data to customize the request payload"
width="700px">}}

</p>
</details>

## Include sensitive data

When integrating tools by calling their endpoints, many times authentication is needed. This is done by storing an authentication token that is part of the webhook request. In Keptn, you do this as follows: 

* Create a secret with a unique `name`, secret scope set to `keptn-webhook-service`, and a `key:value` pair whereas the key is a unique identifier of your secret and the value holds the sensitive data.
  {{< popup_image
  link="./assets/create-secret.png"
  caption="Create a secret for webhook-service"
  width="700px">}}

* When configuring your webhook, you can reference the sensitive data as part of the *URL*, *Custom header*, and in the *Custom payload*. Therefore, click the *key* icon that opens the list of available secrets. Select your secret and specify the key that refers to the sensitive data you would like to include at this point.  
  {{< popup_image
  link="./assets/add-secret-value.png"
  caption="Usage of secrets to customize request"
  width="700px">}}

  The key-value pair will be automatically inserted into the selected field in the format `{{.secret.name.key}}`. 
  
  
<details><summary>*Implementation details*</summary>
<p>

When the webhook configuration is saved, the secret will be parsed into a different format, which looks like this: `{{.env.secret_name_key}}`. This format represents a unique name that is a referrer to an entry in the `envFrom` property in the `webhook.yaml` file. This `envFrom` property contains added secrets with a referrer name, the given secret name, and secret key.

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
<!--
{{< popup_image
link="./assets/webhook-secret.png"
caption="envFrom property in webhook.yaml"
width="700px">}}

{{< popup_image
link="./assets/webhook-secret-usage.png"
caption="Usage of envFrom property in webhook.yaml"
width="700px">}}
-->

</p>
</details>


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

### Configure Webhook to not auto-respond with a finished event

If you subscribe your webhook to an event of type `triggered`, Keptn automatically sends a `started` event, executes
the webhook request via `curl`, and automatically generates a `finished` event.

In certain cases, you do want to have more control about this behaviour, e.g., to run a long-running test on Jenkins, 
and let the receiving tool (in this case Jenkins) decide when to send the `finished` event.

To achieve this, you need to edit your webhook configuration as follows:

* Configure the webhook to not send the `finished` event by setting the flag `sendFinished` to `false`:

```
apiVersion: webhookconfig.keptn.sh/v1alpha1
kind: WebhookConfig
metadata:
  name: webhook-configuration
spec:
  webhooks:
    - type: sh.keptn.event.test.triggered
      sendFinished: false 
      requests:
        - "curl --request POST'
          https://my.jenkins.127.0.0.1.nip.io/job/My-Job/buildWithParameters?token={{.env.jenkinsToken}}&triggeredid={{.id}}&shkeptncontext={{.shkeptncontext}}"
```

* In addition, you will need to pass the following data in order for the receiving tool to properly respond with a `finished` event:
  * `{{.id}}` - required in the `triggeredid` attribute of the `finished` event
  * `{{.shkeptncontext}}` - required in the `shkeptncontext` attribute of the `finished` event
  * Optional, but depends on your implementation: `{{.data.project}}`, `{{.data.service}}`, `{{.data.stage}}`
  
*Note*: Those fields can be either passed within the Data block, or as query params in the URL, depending on the receiving tools configuration.

* Finally, since no `finished` event is sent by Keptn, it is required to configure the receiving tool to send a `finished` event to the `/v1/event` endpoint of the Keptn API.

## Delete a Webhook integration

To delete a webhook integration, click on the *trash can* icon next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

{{< popup_image
link="./assets/delete-webhook.png"
caption="Delete a webhook"
width="700px">}}

*Note*: Deleting a webhook means that the subscription in Uniform is deleted, as well as the webhook configuration file within the Git repo.
