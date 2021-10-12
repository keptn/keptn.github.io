---
title: Slack Integration
description: Learn how to integrate Slack using Webhooks
weight: 1
keywords: [0.10.x-integration]
---

With a Slack integration, you and your teams can get notifications for certain events that are part of a delivery or remediation process. Your teams can also use a Dynatrace-integrated Slack channel to discuss incidents, evaluate solutions, and link to similar problems.

## Create Slack Webhook

* First, generate the *Slack Incoming Webhook* that will become our integration point. Instructions for this step are provided [here](https://api.slack.com/incoming-webhooks).

* After completing the instructions, you get a webhook URL similar to: `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`

*warning* Please be aware that the last part of the webhook URL - the `X...` in the given example - is sensitive data. If this data is known by other parties, they can exploit your webhook to send messages to your Slack channel. 

## Store sensitive data in a secret

To secure the sensitive data of your webhook URL, a secret needs to be created: 

* Go to **Uniform page** > **Secret** and click the **Add Secret**
* Enter a *name* (e.g., `slack-secret`) and select `keptn-webhook-service` for the secret *scope*
* Enter a unique name for the *key* (e.g., `webhook-identifier`)
* Copy-paste the last part of the webhook URL - the `X...` in the given example - into the *value* field: 

  {{< popup_image
  link="./assets/slack-secret.png"
  caption="Create a secret for storing the Slack webhook identifier"
  width="700px">}}

## Set up Slack integration 

To create a webhook integration, a subscription needs to be created: 

* Go to **Uniform page** > **Uniform**, select the *webhook-service*, and click the **Add subscription** button. 

* For this integration, we would like to get a Slack message when an *evaluation* task in the *dev* and *staging* stage is finished. Therefore, you need to select:
  * *Task*: `evaluation`
  * *Task suffix*: `finished`
  * *Filter*: `Stage:dev`, `Stage:staging` 

* Once the above-configured event gets fired, the Slack webhook has to be called. Therefore, you need to select/enter: 
  * *Request method*: `POST`
  * *URL*: The webhook URL without the webhook identifier: `https://hooks.slack.com/services/T00000000/B00000000/`
  * Reference the secret to add the webhook identifier at the end of the URL. Therefore, clicking on the *key* icon, select the secret `slack-secret` and the key `webhook-identifier`. This will reference the secret value containing the sensitive data of your webhook URL: `https://hooks.slack.com/services/T00000000/B00000000/{{.env.secretKey}}`
  * *Custom payload*: For the custom payload that represents the Slack message, please copy-paste the following snippet:

  ```
  {
    "text": "Evaluation in {{.data.stage}} finished with result {{.data.evaluation.result}} and score {{.data.evaluation.score}}."
  }
  ```

* (optional) You can enrich and customize the message with event data described [here](../../webhooks/#customize-request-payload). 

* Finally, click **Create subscription** to save and enable the webhook for your Slack integration.

## Delete a Webhook

To delete a webhook, click on the *trash can* icon next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

## Troubleshooting

The Slack Incoming Webhook URL created by the Slack admin is specific to a single user and a single channel. If an existing webhook is tied to an account that is no longer active, the webhook URL will be invalid, the integration will be broken, and you will no longer receive messages on that Slack channel. This could be the case when you have a working webhook URL and an account is removed from Slack. If this occurs, the Slack admin will need to generate a new webhook URL using a valid account and channel. Once a new URL is generated, update the webhook URL in the event subscription. 