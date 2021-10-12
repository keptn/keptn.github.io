---
title: Slack Integration
description: Learn how to integrate Slack using Webhooks
weight: 1
keywords: [0.10.x-integration]
---

... Intro

## Create Slack Webhook

First, you need to create an incoming Slack webhook which will become our integration point. Therefore, please follow the official Slack instructions provided here: https://api.slack.com/incoming-webhooks

This is a four step approach that returns a URL similar to: `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`

*warning*: Please be aware that the last part of the webhook URL - the `X...` in the given example - is sensitive data. It this data is known by others parties, they can exploit it to send messages to your Slack channel. 

## Store sensitiv data in a secret

To secure the sensitive data of your webhook URL, a secret needs to be created: 

* Go to **Uniform page** > **Secret** and click the **Add Secret**
* Specify a *name* (e.g., `slack-secret`) and select `keptn-webhook-service` for the secret *scope*
* Specify a unique name for the *key* (e.g., `webhook-identifier`)
* Copy-paste the last part of the webhook URL into the *value* field: 

  {{< popup_image
  link="./assets/slack-secret.png"
  caption="Create a secret for storing the Slack webhook identifier"
  width="700px">}}

## Create Slack integration 

To create a webhook integration, a subscription needs to be created: 

* Go to **Uniform page** > **Uniform**, select the *webhook-service*, and click the **Add secret** button. 

* For this integration, we would like to get a Slack message when an *evaluation* task in the *dev* and *staging* stage finished. Therefore, you need to select/specify:
  * *Task*: `evaluation`
  * *Task suffix*: `finished`
  * *Filter*: `Stage:dev`, `Stage:staging` 

* Once the above configured event gets fired, the Slack webhook has to be called. Therefore, you need to select/specify: 
  * *Request method*: `POST`
  * *URL*: The webhook URL without the webhook identifier: `https://hooks.slack.com/services/T00000000/B00000000/`
  * Add the webhook identifier by clicking on the *lock* icon, selecting the secret `slack-secret`, and the key `webhook-identifier`. This will reference the secret value containing the sensitive data of your webhook URL.
  * *Custom payload*: For the custom payload, please copy-paste the following snippet: 
  ```
  {
    "text": "Evaluation in {{.data.stage}} finished with result {{.data.evaluation.result}} and score {{.data.evaluation.score}}."
  }
  ```

  *Note:* You can enrich the message with event data you like. 


* Finally, click **Create subscription** to save and enable the webhook for your integration.