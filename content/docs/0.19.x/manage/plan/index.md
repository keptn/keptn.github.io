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
that at least defines the `stages` for your project.
At the current time, it is not possible to add or remove stages
after you create your project.

A stage defines the stages and sequences of tasks that your Keptn project can orchestrate.
The *shipyard.yaml* file you use to create a project must show the stages to be used
– at least one stage is required but most projects have multiple stages –
and each stage must have a name property defined.
For example, a *shipyard.yaml* file like the following is enough to create the project:

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

You can add the sequences and tasks for the project to the *shipyard*
either before or after you create the project.

A `stage` corresponds to a phase in your Continuous Delivery process.
Each stage that is defined for the project
becomes a branch in the upstream repo when you create the project.
.
A stage can be given any meaningful name
that conforms to the naming rules described in the
[shipyard.yaml](../../reference/files/shipyard) reference page;
some common stage types are:

* **development** -- typically used for basic functional testing before deploying the artifact to testing stages.
* **testing, qa, validation** - typically used for more advanced testing
  or perhaps testing that cannot be fully automated such as usability testing.
  Your project could have multiple testing stages.
  For example, you might have a `qa-java-app` stage for testing your Java application
  and a `validate-database` stage for testing the associated database.
* **staging, hardening** -- typically used for performance and security testing
  before the artifact is deployed into production
* **production** -- Keptn can monitor your active production site
  for performance, stability, and functionality.
  It can perform remediation (also called "self-healing") for some issues
  and generate appropriate notifications for other issues.

The [Define a Project](../../define) section contains pages
about how to implement the different types of stages.

## What tools do you want to use with Keptn?

Keptn orchestrates **what** to do.
You can integrate almost any tool you like to define **how** this task is accomplished.
You must identify each tool you use to Keptn;
this can be done in a variety of ways.
See [Keptn and other tools](../../../concepts/keptn-tools) for more information.

## Who calls whom?

When integrating certain tools with Keptn,
you have a choice of having your tool call Keptn
or having Keptn call your tool.
For example, you may have a Jenkins Pipeline that builds and tests your software.
You want Keptn to take that artifact and run an evaluation
before deploying the software.
You can either have Jenkins call Keptn or you can have Keptn call Jenkins.

The preferred solution for current Keptn releases is be to use
Keptn [Webhooks](../../integrations/webhooks) to have Keptn call Jenkins.
This is easier to implement, allows you to break up your Jenkins Pipeline,
and you get the `evaluation` "for free".

For example, you can define a Keptn sequence that you can trigger like this:

```
sequence:
  - name: doMyDeployment
    tasks:
      - name: "deploy"
      - name: "evaluation"
      - name: "test"
```

Then configure the Keptn webhook service to fire on the `deploy.triggered` event
and have Jenkins return the `deploy.finished` event.
Keptn automatically runs your
[quality gate](../../../concepts/quality_gates/) evaluation when it receives the event.
When the evaluation is finished, Keptn triggers the `test` task.
You could again use the Keptn webhook service to trigger Jenkins
to implement any test you wanted.

The [Trigger Webhook Integrations from Keptn](https://youtu.be/ehI23d7s-dY?t=60) video
shows how to trigger Jenkins from a Jenkins task inside a sequence.
This is also documented on the [Jenkins Integration](../../integrations/webhooks/jenkins/) page.

You can instead have Jenkins call Keptn.
This is the only implementation that is supported for Keptn 0.12.x and earlier releases.
To do this, use the
[Jenkins Shared Library](https://artifacthub.io/packages/keptn/keptn-integrations/jenkins-library) integration.

To implement this functionality:

* Create a Keptn project that includes a `stage` with a Keptn `sequence`
that includes a single `evaluation` task.
* Use the **curl** command to call Keptn from Jenkins, then wait for the response.
* Code the wait logic into your Jenkins Pipeline.

This approach is more difficult to implement
and provides less functionality than using the Keptn webhooks strategy described above.

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

  If you are already using an observability platform,
  you probably want to just configure Keptn to use that tool.
  If you need to choose a platform, the following may be useful
  or you can search for other resources:

  * [Dynatrace, Prometheus, and others -- Comparison](https://medium.com/@balajijk/dynatrace-prometheus-and-others-comparison-debc897cb7a5)
  * [Datadog vs Dynatrace comparison](https://www.peerspot.com/products/comparisons/datadog_vs_dynatrace)
  * [Datadog vs Prometheus -- Key features and differences](https://signoz.io/blog/datadog-vs-prometheus/)

* What are your SLO's (Service-Level Objectives) for each stage?
For example, for an SLI that measures response time,
you could define an SLO with an absolute value (less than 100ms)
or a relative value (no more than 5% slower than previous evaluations.
Absolute and relative results can be combined into a `total_score` for the evaluation.
See [SLO](../../reference/files/slo) for more details.
* What service will you use to deploy your artifact for quality gates evaluation?
The most common choice is `helm-service`.
See [Create a service](../service) for more information.
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

