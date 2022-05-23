---
title: Jenkins Integration
description: Example to integrate Jenkins using Webhooks
weight: 1
keywords: [0.16.x-integration]
---

With a Jenkins integration, you can call existing Jenkins Pipelines from Keptn. In addition, with the optional [keptn-jenkins-library](https://github.com/keptn-sandbox/keptn-jenkins-library/)
you can even provide information back to Keptn (e.g., `test.finished` with `result=fail`).

*Note*: The instructions on this page assume that you do **not** have `jmeter-service` installed.

## Configure Jenkins

*Note*: Keptn needs to reach your Jenkins installation (either directly or via a proxy). This goes way beyond our documentation, therefore we suggest reaching out to your Jenkins administrator.

* Open your Jenkins UI, log in as an administrator, and configure the pipeline you want to call
* Select the pipeline you want to call, and click on "Configure".
* Select "Build triggers" and tick "Trigger builds remotely"
* Create an authentication token (e.g., using a local password manager) - you will need this token later when creating the webhook in Keptn
* Also note down the URL shown below (e.g., `http://jenkins.127.0.0.1.nip.io/jobs/build?token=`) - you will need it later when creating the webhook in Keptn

  {{< popup_image
  link="./assets/jenkins-trigger-builds-remotely.png"
  caption="Enable Trigger builds remotely on Jenkins"
  width="700px">}}

## Store sensitive data in a secret

To secure the sensitive data of your Jenkins webhook URL, a secret needs to be created:

* Go to **Uniform page** > **Secret** and click the **Add Secret**
* Enter a *name* (e.g., `jenkins-secret`) and select `keptn-webhook-service` as a secret *scope*
* Enter a unique name for the *key* (e.g., `my-pipeline-secret`)
* Copy-paste the authentication token from the previous step into the *value* field:

  {{< popup_image
  link="./assets/jenkins-uniform-secret.png"
  caption="Create a secret for storing the Jenkins authentication token"
  width="700px">}}



## Set up Jenkins integration via Webhook

To create a webhook integration, a subscription needs to be created:

* Go to **Uniform page** > **Uniform**, select the *webhook-service*, and click the **Add subscription** button.

* For this integration, we would like trigger a Jenkins pipeline when a *test* task in the *dev* and *staging* stage is triggered. Therefore, you need to select:
    * *Task*: `test`
    * *Task suffix*: `triggered`
    * *Filter*: `Stage:dev`, `Stage:staging`


* Once the above-configured event gets fired, the Jenkins pipeline has to be triggered. Therefore, you need to select/enter:
    * *Request method*: `GET`
    * *URL*: The webhook URL from above: `http://jenkins.127.0.0.1.nip.io/jobs/build?token=`
    * Reference the secret to add the webhook identifier at the end of the URL by clicking on the *key* icon, select the secret `jenkins-secret` and the key `my-pipeline-secret`. This will reference the secret value containing the sensitive data of your webhook URL: `http://jenkins.127.0.0.1.nip.io/jobs/build?token={{.secret.jenkins-secret.my-pipeline-secret}}`

  {{< popup_image
  link="./assets/jenkins-webhook-subscription.png"
  caption="Create a secret for storing the Jenkins authentication token"
  width="700px">}}


* Finally, click **Create subscription** to save and enable the webhook for your Slack integration.

With those steps done, Keptn is triggering a Jenkins Pipeline whenever a `test.triggered` event occurs.

## Advanced: Integrate Jenkins response

While the previous example just triggers a Jenkins Pipeline, it does not tell Keptn whether the pipeline has succeeded or not.

In order to do this, the following steps are needed:

* Change the webhook to use `/buildWithParameters` instead of `/build` 
* Append parameters to the webhook URL, e.g., `/buildWithParameters?token={{.secret.jenkins-secret.my-pipeline-secret}}&triggeredid={{.id}}&shkeptncontext={{.shkeptncontext}}&stage={{.data.stage}}`
* Change the webhook configuration [to not auto-respond with a .finished event](../#configure-webhook-to-not-auto-respond-with-a-finished-event) (`sendFinished: false`)
* Install [keptn-jenkins-library](https://github.com/keptn-sandbox/keptn-jenkins-library/) on your Jenkins Server
* Configure the secrets and environments variable as detailed in the install instructions of keptn-jenkins-library
* Modify the Jenkins Pipeline to accept `triggeredid`, `shkeptncontext` and `stage` (see example below)
* Use the keptn-jenkins-library function `sendFinishedEvent` at the end of your pipeline (see example below)

**Modified webhook.yaml**
```yaml
apiVersion: webhookconfig.keptn.sh/v1alpha1
kind: WebhookConfig
metadata:
  name: webhook-configuration
spec:
  webhooks:
    - type: sh.keptn.event.test.triggered
      requests:
        - curl --request GET
          http://jenkins.127.0.0.1.nip.io/job/my-pipeline/buildWithParameters?token={{.secret.jenkins-secret.my-pipeline-secret}}&shkeptncontext={{.shkeptncontext}}&triggeredid={{.id}}&stage={{.data.stage}} --fail-with-body
      sendFinished: false
      envFrom: ...
```

**Jenkinsfile**
```groovy
@Library('keptn-library@5.0')_
def keptn = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'stage', description: 'Stage of your Keptn project where tests are triggered in', name: 'stage', trim: false), 
         string(defaultValue: '', description: 'Keptn Context ID', name: 'shkeptncontext', trim: false), 
         string(defaultValue: '', description: 'Triggered ID', name: 'triggeredid', trim: false), 
        ])
    ])

    def commit_id

    stage('Preparation') {
        checkout scm
    }

    stage('Initialize Keptn') {
        keptn.keptnInit project:"sockshop", service:"carts", stage:"${params.stage}"
    }

    stage('Test') {
        // Run your tests here
    }

    stage('Send Finished Event Back to Keptn') {
        // Send test.finished Event back
        def keptnContext = keptn.sendFinishedEvent eventType: "test", keptnContext: "${params.shkeptncontext}", triggeredId: "${params.triggeredid}", result:"pass", status:"succeeded", message:"jenkins tests succeeded"
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
    }
}
```


## Cleanup

To delete a webhook, click on the *trash can* icon next to the subscription. Note that deleting a webhook is permanent and cannot be reversed. Once deleted, Keptn will no longer send requests to the endpoint.

