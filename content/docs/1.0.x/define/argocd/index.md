---
title: Orchestrate ArgoCD from Keptn
description: How Keptn can orchestrate ArgoCD deployments
weight: 235
---

ArgoCD is a powerful tool for GitOps-based deployments
but it does not run tests or evaluation on the deployment.
Keptn can execute tests and evaluate the ArgoCD deployment,
based on the [SLO's](../../reference/files/slo) that you define.

You have two options for implementing this:

* Keptn controls the deployment by calling ArgoCD
  as well as the testing and SLO evaluation that you define.
  In other words, Keptn controls the whole process, end-to-end.

* ArgoCD manages the deployment then the ArgoCD webhook sends an event to Keptn
  which triggers a Keptn project that contains a sequence
  that does the testing and SLO evaluation that you define.

Each of these is discussed below.

## Keptn controls the deployment through ArgoCD

For this implementation option, you create a Keptn project
that calls ArgoCD to deploy the software
and orchestrates the testing and evaluation that you want.

The [Using ArgoCD with Keptn](https://www.youtube.com/watch?v=fEiauT1OzTE) video
discusses how to set Keptn up to validate your deployment
then call ArgoCD to deploy the software,
using a pull request (PR) to initiate the process.

The [Our Journey in Integrating GitOps Tools into Delivery Pipelines](https://www.youtube.com/watch?v=TO_d-HWXP5A) video
discusses some of the challenges involved when adopting GitOps in Keptn
and then shows how Keptn can orchestrate ArgoCD
to incorporate application health and release validation
into your deployment pipeline.

## ArgoCD calls Keptn for testing and evaluation

For this implementation option, ArgoCD manages the deployment
then calls a Keptn project to do the testing and evaluation.
To implement this:

* Create a Keptn project with one or more sequences for testing and evaluation.

* Have the ArgoCD Webhook send an event to Keptn after it does the deployment
  to trigger that sequence.

For example, if your sequence is called "evaluation",
you can send the following event to the Keptn API Endpoint to trigger an event:

```
{
  "data": {
    "deployment": {
      "deploymentURIsPublic": [
        "<YOUR http://theURLoftheappArgoCDjustdeployed>"
      ]
    },
    "labels": {
      "ArgoCD": "<YOUR https://thiscouldbealinkbacktoyourargocd>",
      "Release": "Release-123456",
      "buildId": "somebuildId",
      "Additonalinfo": "whatever else you want"
    },
    "project": "<YOUR-Keptn-ProjectName>",
    "service": "<YOUR-Keptn-ServiceName>",
    "stage": "<YOUR-keptn-StageName>"
  },
  "source": "argocd",
  "specversion": "1.0",
  "type": "sh.keptn.event.<YOURSTAGE>.<YOURSEQUENCENAME>.triggered"
}
```
