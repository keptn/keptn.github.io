---
title: Define Keptn Projects
description: Define what a project does
weight: 350
icon: setup
---

This section provides information about the activities your Keptn project can do
and how to implement them.

For information about the "mechanics" of working with Keptn projects,
see [Manage Keptn Projects](../manage/).

Keptn is most frequently used as an orchestrator for delivery orchestration.
You can orchestrate any sequence and leverage the built-in Keptn SLO validation.
Keptn connects your tools and makes data-driven orchestration decisions
without requiring you to do large amounts of custom coding..

This section provides information and samples to illustrate common practices
with the following pages:

* [Tasks and sequences](task-sequence) explains the components of the
  [shipyard](../reference/files/shipyard) file
  that are populated to define what Keptn orchestrates.

* [A simple project](simple-project) illustrates the *shipyard* for a multi-stage project
  with `dev`, `hardening` or `staging`, and `production` stages
  that runs functional tests in the `hardening` stage,
  and performance tests in the `hardening` stage.

  This project uses the following capabilities:

  * The [triggeredOn](triggers/#use-triggeredon-in-a-sequence) property
  * The [Deployment with Helm](deployment_helm) functionality

* [Delivery sequence](delivery_sequence) builds the *shipyard* for another multi-stage project
  but it utilizes the [deployment strategies](deployment_helm) more extensively.

* [Quality Gates](quality-gates) discusses how to set up a `quality-gates` stage
  that evaluates a deployment or release using metrics from the observability platform of your choice,
  based on criteria you define.

  This page also includes a short video that steps you through the implementation process
  for a quality gate evaluation.

* [Delivery Assistant](delivery_assistant) illustrates how to implement
  a *shipyard* that has both manual and automatic delivery options,
  depending on the results of the quality gates `evaluation`.

Keptn can also be used to monitor your released software and software site
and, if it finds problems, can be set up to "self heal" --
in other words, to automatically take steps to remediate the problem.
For example, it can scale your resources up or down
or roll back the software to a previous release
or send notifications to staff members.

* [Remediation Sequence](remediation-sequence)
  discusses how to implement automatic remediation on your site.

Other examples of what you can do with Keptn:

* [Demo: Quality gate evaluation using metrics from another tool](infracost)
  provides a video demonstration of how Keptn can run a quality gate evaluation
  based on metrics from a tool that is not actually an observability platform.

* [Orchestrate security checks](security) provides a video
  that discusses how Keptn can analyze your code for security vulnerabilities
  before and after it is deployed into production.

* [Orchestrate ArgoCD from Keptn](argocd) provides links to videos
  that discuss how to use Keptn to add testing and evaluation
  to the deployment run with ArgoCD.

* [Orchestrate Argo Rollouts from Keptn](argo-rollouts)
  provides links to a video and tutorial about how to implement a Keptn workflow
  that deploys your software with Argo Rollouts with other features
  to ensure the health of your deployment.

