---
title: Demo: Quality gate evaluation using metrics from another tool
description: How to use a tool to provide metrics for a quality gate evaluation
weight: 105
---

The following video illustrates how Keptn can orchestrate a quality evaluation
based on metrics that come from a tool that is not itself an observability platform:

[Keptn Job Executor Service + Quality Gate](https://www.youtube.com/watch?v=L8AWjCAHv-4)

For this exercise, we use [Infracost](https://www.infracost.io/) to measure the cost of a deployment.
The flow is:

* Install and run the [Job Executor Service](https://artifacthub.io/packages/keptn/keptn-integrations/job-executor-service)
  to execute Infracost in a container as a Kubernetes job that is orchestrated by Keptn
* Execute a Python script that runs Infracost
  and pushes Infracost metrics to a backend.  We use Prometheus.
* Add an `evaluation` sequence to the [shipyard](../../reference/files/shipyard).
  This sequence is triggered after the Python script finishes.
  It executes a quality gate evaluation that checks the deployment,
  based on the Infracost metrics it receives from Prometheus
* Use the [Keptn Bridge](../../bridge) to trigger and monitor the sequence


