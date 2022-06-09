---
title: shipyard
description: Control orchestation for a Keptn project
weight: 715
---

The shipyard is configured in the  *shipyard.yaml* file,
which defines the activities to be performed for a Keptn project
and the order in which those activities are executed.

Each project must have one, and only one, *shipyard.yaml* file
which is passed to the [**keptn create project**](../../cli/commands/keptn_create_project/) command.

* Each *shipyard* contains  one or more `stages`, which can be given any name that is meaningful.
Examples are "development", "hardening", "production", and "remediation".
A `stage` is a grouping of activities to be executed until the project is deployed and,
optionally, a "production" stage that defines remediation activities
that can be executed in response to issues detected on the production site.

* Each `stage` must have one or more `sequences`, which can be given any name that is meaningful.
A `sequence` defines the `tasks` to be performed and, optionally, an event that triggers that sequence.

The following **Synopsis** shows all the constructions that are supported for a *shipyard*
although most projects only use some of the constructions.

## Synopsis

    apiVersion: spec.keptn.sh/0.2.3
    kind: "Shipyard"
    metadata:
      name: "shipyard-<project-name>"
    spec:
      stages:
        - name: "<stagename-1>"
          sequences:
          - name: "delivery"
            tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct" | "blue_greem_service" | "user_managed"
            - name: "release"
        - name: "hardening"
        - name: "production"
          sequences:
          - name: "<delivery-sequence>"
            triggeredOn:
               - event: "<event>.finished"
             tasks:
             - name: "delivery"
          - name: "remediation-sequence>"
            triggeredOn:
               -event: "<event>"
                selector:
                  match:
                    evaluation.result: "<result>"
             tasks:
                - name: "get-action"
                - name: "action"
                - name: "evaluation"
                  triggeredAfter: "<timeframe>"
                  properties:
                    timeframe: "<xx>m"

## Fields

**Meta-data**
* `apiVersion`: The version of the shipyard specification in the format: `spec.keptn.sh/x.y.z`
* `kind`: is `Shipyard`
* `metadata`:
    `name`: Unique name for this *shipyard* file
    Typically, this is the string `shipyard` followed by a dash and the project name; for example, `shipyard-sockshop`
* `spec`: Consists of the property stages.
    * `stages`: An array of stages, each of which has a name and a sequence of tasks to execute

**Stage**

A stage is named for the particular activity to be performed,
such as `development`, `hardening`, `staging`, or `production`.
Each *shipyard* file must have at least one `stage`.
The name of the stage becomes the name of the branch in the upstream Git repository
and the Kubernetes namespace to which services are deployed.
A stage has the properties:

* `name`: A unique name for the stage
such as `development`, `hardening`, `staging`, or `production.
* `sequences`: An array of sequences that define the tasks to be performed
and, optionally, the events that trigger each task.

At this time, you can not add or delete stages in the *shipyard* file for an existing project
although you can make other modifications.
See [KEP-70](https://github.com/keptn/enhancement-proposals/pull/70) for details
about the ongoing initiative to overcome this limitation.

**Sequence**

A sequence is an ordered list of `task`s that are triggered sequentially
and are part of a `stage`.
By default, a sequence is a standalone section that runs and finishes,
unless you specify the `triggeredOn` property to form a chain of sequences.

A sequence has the properties:

* `name`: A unique name for the sequence
* `tasks`: An array of tasks executed by the sequence in the declared order.
* `triggeredOn` *(optional)*: An array of events that trigger the sequence.
    This property can be used to trigger a sequence once another sequence has been finished,
    essentially forming chains of sequences.
    In addition to specifying the sequence whose completion should activate the trigger,
    you can define a `selector` that defines whether the sequence should be triggered
    if the preceeding sequence has been executed successfuly, or had a `failed` or `warning` result.
    For example, the following sequence with the name `rollback` is only triggered
    if the sequence `delivery` in production had a result of `failed`:

        - name: rollback
          triggeredOn:
          - event: production.delivery.finished
            selector:
              match:
                result: failed

    It is also possible to refer to certain tasks within the preceeding sequence.
    For example, if `match` is changed to `release.result: failed`,
    the `rollback` sequence is executed only if the task `release` of the sequence `delivery`
    has a result of `failed`:

        - name: rollback
          triggeredOn:
          - event: production.delivery.finished
            selector:
              match:
                release.result: failed

    If no `selector` is specified, the sequence is triggered
    only if the preceeding `delivery` sequence has a result of `pass`:

        - name: rollback
          triggeredOn:
          - event: production.delivery.finished

**Task**

A single `task` is the smallest executable unit and is contained in a `sequences` block.
A task has the properties:

* `name`: A unique name for the task
* `triggeredAfter` *(optional)*: Wait time before the task is triggered.
* `properties` *(optional)*: Task properties as individual `key:value` pairs.
  These properties are properties that the actioning tool requires
  and are consumed by the tool that executes the task.
  Typically, properties are passed in at runtime using JSON data
  rather than having the data hardcoded into the *shipyard* file.

Keptn supports a set of opinionated tasks for declaring a delivery or remediation sequence.
Additional tasks may be defined for the services you integrate.

* action
* approval
* deployment
* evaluation
* get-action
* rollback

In addition, the following two tasks are reserved
although they are associated with specific services:

* release (helm-service only)
* test (jmeter-service only)

Each of these are discussed below.

* `action`

    Indicates that a remediation action should be executed by an action provider
    that is defined in a [remediation](../remediation) configuration.

* `approval`

    Intercepts the `task` sequence and waits for a user to approve or decline the open approval.
    This task can be added, for example, before deploying an artifact into the next stage. 
    The approval strategy is defined based on the `evaluation` result `pass` and `warning`.
    The approval strategies for the evaluation results `pass` and `warning` can be set to:

    - `automatic`: Task sequence continues without requesting approval
    - `manual`:  Task sequence requests for approval before continuing

    *Synopsis:*

        - name: approval
           properties:
             pass: automatic
             warning: manual

    This allows combinations as follows:
    
    |                          | Evaluation result: pass           | Evaluation result: warning                 | Behavior  |
    |--------------------------|-----------------------------------|--------------------------------------------|-----------|
    | **Skip approval task:** | pass:automatic | warning:automatic | Regardless of the evaluation result, the approval task is skipped |
    | **Depending on evaluation result:**   | pass:automatic | warning:manual    | If the evaluation result is a **warning**, an approval is required |
    | **Depending on evaluation result:**   | pass:manual    | warning:automatic | If the evaluation result is a **pass**, an approval is required |
    | **Mandatory approval task:**          | pass:manual    | warning:manual    | Regardless of the evaluation result, an approval is required |


    By default, an `automatic` approval strategy is used for the `pass` and `warning` evaluation results.

* `evaluation`

    Defines the quality evaluation that is executed to verify the quality of a deplyoment based on its SLOs/SLIs.

    Use the optional `triggeredAfter` parameter to specify when to trigger the evaluation.

    Set the `timeframe` property to specify the timespan to be evaluated.
    For example, `timeframe: 5m` says that the quality gate evaluation looks at the previous five minutes.

    `timeframe` must be specified but
    you can specify the `timeframe` as part of the JSON payload
    and pass it in when you trigger the sequence using curl
    rather than hard-coding it in the file.
    This makes the timeframe value dynamic.  For example:

        {
         "type": "sh.keptn.event.SomeStage.MySequence.triggered",
         # Other fields removed for brevity
         "data": {
           "evaluation": {
             "timeframe": "5m"
           }
        }

* `get-action`
    Extracts the desired remediation action from a [remediation](../remediation) configuration.

* `release`

    Defines the releasing task that is executed after a successful deployment occurs.
    This task shifts production trafic towards the new deployment.

* `rollback`

    Defines the rollback task that is executed when a rollback is triggered.

* `remediation`

    Defines whether remediation actions are enabled or not.

For historical reasons and backward compatibility, the following tasks are reserved in Keptn
although they are actually associated with services that run on the execution plane
rather than on the control plane.

* `deployment`

    Defines the deployment strategy used to deploy a new version of a service.
    This is part of  *helm-service*, which assumes that Istio is installed on the cluster
    unless the Job Executor Service is installed in the cluster.
    The deployment `strategy` is set to one of the following:

    * `direct`: Deploys a new version of a service by replacing the old version of the service.
    See [Direct deployments](../../../continuous_delivery/deployment_helm/#direct-deployments)
    * `blue_green_service`: Deploys a new version of a service next to the old one.
    After a successful validation of this new version, it replaces the old one and is marked as stable.
    See [Direct deployments](../../../continuous_delivery/deployment_helm/#blue-green-deployments)
    * `user_managed`: Deploys a new version of a service
    by fetching the current Helm chart from the Git repo and updating appropriate values.
    See [Direct deployments](../../../continuous_delivery/deployment_helm/#user-managed-deployments)

* `test`

    Defines the test strategy used to validate a deployment with the *jmeter-service*.
    The *jmeter-service* supports setting the `teststrategy` to one of the following:

    * `functional`: Test a deployment based on functional tests.
    * `performance`: Test a deployment based on performance/load tests.

    Failed tests result in an automatic `rollback` of the latest deployment
    when using a blue/green deployment strategy.

        - name: test
          properties:
            teststrategy: functional | performance

    For example, you may run `functional` tests in a `dev` stage
    and `performance` tests in a `hardening` or `staging stage.

## Usage

A [shipyard.yaml](../../reference/files/shipyard) file is defined at the level of a project.
This means that all services in a project share the same shipyard definition.

At this time, you can not add or delete stages in the *shipyard* file for an existing project
although you can make other modifications.

* See [KEP-70](https://github.com/keptn/enhancement-proposals/pull/70) for details
about the initiative to allow adding/removing stages to/from a *shipyard* file.
* See [Updating a shipyard](../../../manage/shipyard/#updating-a-shipyard)
for information about modifications that can be made to a *shipyard* file.

As a workaround, you can temporarily skip the execution of a particular stage by doing either of the following:

* Temporarily remove the `triggeredOn` attribute for the stage you want to skip
* Add an `approval` step as the first task of the stage you want to skip
and then `Deny` the approvals 

## Example

The **See also** section of this page references other pages in this documentation set
that contain annotated examples for accomplishing various tasks.

## Files

* Your *shipyard* is stored in the upstage Git repo for the project
and  named to match the value of the `Metadata` name field in the shipyard file.

## Differences between versions

* [KEP-70](https://github.com/keptn/enhancement-proposals/pull/70) is active
to allow `stage`s to be added to and removed from a *shipyard* in an existing project.

## See also

* [Working with shipyard files](../../../manage/shipyard)
* [Multi-stage delivery](../../../continuous_delivery/multi_stage)
* [Triggers](../../../manage/triggers)
* [Remediation Config](../../../automated_operations/remediation)
