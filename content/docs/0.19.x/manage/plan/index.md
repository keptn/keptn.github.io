---
title: Plan your project
description: Create and delete a project in Keptn.
weight: 10
keywords: [0.16.x-manage]
aliases:
---

It is useful to think about what you want your Keptn project to do
before you begin implementing it.
This page summarizes some things you should consider.
You can then use the [Create project](../project) page
for instructions about implementing a project.

It is important to understand that a Keptn project is **not** a pipeline.
Instead, activities are triggered by specific events.
For a broader explanation of this, you can read the seminal
[Continuous Delivery without pipelines -- How it works and why you need it](https://medium.com/keptn/continuous-delivery-without-pipelines-7e84db8c8261) article.

## What should this project do?

Before you can run the Keptn command to create a project,
you must populate a [shipyard.yaml](../../reference/files/shipyard) file
that defines the `stages` for your project.
At the current time, it is not possible to add or remove stages
after you create your project.

A stage is a grouping of activities to be executed and it consistes of one or more sequences that define the actual tasks to perform. The shipyard.yaml file you use to create a project must show the stages to be used – at least one stage is required but most projects have multiple stages – and each stage must have a name property defined. For example,:

```
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
    - name: "hardening"
    - name: "production"
```

In order to do any work, each stage must have at least one sequence and most sequences will contain one or more tasks but this information can be added to the shipyard after you create your project.

A `stage` corresponds to a phase in your Continuous Delivery process.
You can name your stage what you want;
some common stage types are:

* development
* testing, qa, validation
* staging, hardening
* production

Your project could have multiple stages for one of these phases.
For example, you might have one stage for testing your Java application
and another stage for testing the associated database.

The [Define a Project](../../define) section contains pages
about how to implement the different types of stages.

## What tools do you want to use with Keptn?

Keptn orchestrates what to do.
You can integrate almost any tool you like to define how this task is accomplished.
You must identify each tool you use to Keptn;
this can be done in a variety of ways.
See [Keptn and other tools](../../../concepts/keptn-tools) for more information.

## Are you using quality gates evaluation?

Most projects use quality gates to evaluate their software.
See [Quality Gates](../../../concepts/quality_gates) for more information.
You can (and probably will) modify the details of your quality gates
as you test and develop your project but it is useful to consider your goals from the beginning.

If you are using quality gates, you need to consider the following:

* What are you using for your data provider, also called the SLI provider?
An SLI (Service-Level Indicator) provides quantitative data
such as response time.
You can use an observability platform
(integrations are currently provided for DataDog, Dynatrace, and Prometheus)
or you can define another SLI provider by following the instructions in
[Custom SLI-Provider](../../integrations/sli_provider).
* What are your SLO's (Service-Level Objectives) for each stage?
For example, for an SLI that measures response time,
you could define an SLO with an absolute value (less than 100ms)
or a relative value (no more than 5% slower than previous evaluations.
Absolute and relative results can be combined into a `total_score` for the evaluation.
See [SLO](../../reference/files/slo) for more details.
* What service will you use to deploy your artifact for quality gates evaluation?
The most common choice is `helm-service`.
See [Deploying Services](../../define/service) for more information.
* Will you pass your artifact to the next stage
(for example, from testing to hardening or from staging to production)
automatically if the SLO results meet the specified goals
or will you require manual intervention.
Note that you can have your project
automatically deploy your artifact to the next stage under certain conditions
and require manual intervention under other conditions.

## Should your project evaluate and remediate the production site?

A Keptn project can regularly evaluate the production site that runs your deployed software
and can provide remediation ("self-healing") for problems that are found.
For example, if the response time is too slow,
Keptn could add pods to your Kubernetes cluster.
For certain other issues, it could roll back the software to the previous version.

If you want your project to evaluate and remediate issues on your production site,
you should consider the following:

* What conditions should Keptn monitor on the production site?
* What issues should Keptn attempt to remediate automatically?
* What action providers do you want to use for remediation?

