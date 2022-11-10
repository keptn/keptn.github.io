---
title: Orchestrate ArgoCD from Keptn
description: How Keptn can orchestrate ArgoCD deployments
weight: 235
---

ArgoCD is a powerful tool for GitOps-based deployments.
Keptn can orchestrate ArgoCD and then execute tests and evaluate the deployment,
based on the [SLO's](../../reference/files/slo) that you define.
This can be implemented using Webhooks and notifications;
it does not require an integration.

The [Using ArgoCD with Keptn](https://www.youtube.com/watch?v=fEiauT1OzTE) video
discusses how to set Keptn up to validate your deployment
then call ArgoCD to deploy the software,
using a pull request (PR) to initiate the process.

The [Our Journey in Integrating GitOps Tools into Delivery Pipelines](https://www.youtube.com/watch?v=TO_d-HWXP5A) video
discusses some of the challenges involved when adopting GitOps in Keptn
and then shows how Keptn can orchestrate ArgoCD
to incorporate application health and release validation
into your deployment pipeline.
