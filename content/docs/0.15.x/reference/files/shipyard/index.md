---
title: shipyard.yaml
description: Control orchestation for a Keptn project
weight: 715
---

Each project has one, and only one, *shipyard.yaml* file, that defines the orchestration for that product.
You create the *shipyard* file with at least the stages defined
and pass that to the **keptn create project** command to create a project.

**Note:** At this time, you can not add or delete stages in the *shipyard* file for an existing project
although you can make other modifications.
See [KEP-70](https://github.com/keptn/enhancement-proposals/pull/70) for details
about the initiative to allow adding and removing stages from a *shipyard* file.

## Synopsis

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-<project-name>"
spec:
  stages:
    - name: "dev"
    - name: "hardening"
    - name: "production"
```

## Fields

**Meta-data**
* `apiVersion`: The version of the Shipyard specification in the format: `spec.keptn.sh/x.y.z`
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

**Sequence**

A stage consists of a list of sequences whereby a sequence is an ordered list of tasks that are triggered sequentially. A sequence has the properties:

* `name`: A unique name for the sequence
* `tasks`: An array of tasks executed by the sequence in the declared order.
* `triggeredOn` *(optional)*: An array of events that trigger the sequence. This property can be used to trigger a sequence once another sequence has been finished. In addition to specifying the sequence whose completion should activate the trigger,
it is also possible to define a `selector` that defines whether the sequence should be triggered if the preceeding sequence has been executed successfuly, or had a `failed` or `warning` result.
For example, the following sequence with the name `rollback` would only be triggered if the sequence `delivery` in production had a result of `failed`:

```
...
        - name: rollback
          triggeredOn:
          - event: production.delivery.finished
            selector:
              match:
                result: failed
...
```

It is also possible to refer to certain tasks within the preceeding sequence. For example, by changing the `match` to `release.result: failed`, the `rollback` sequence would only be executed if the task `release` of the sequence `delivery` had a result of `failed`:



```
...
        - name: rollback
          triggeredOn:
          - event: production.delivery.finished
            selector:
              match:
                release.result: failed
...
```

If no `selector` is specified, the sequence will only be triggered if the preceeding `delivery` sequence had a result of `pass`:
```
...
        - name: rollback
          triggeredOn:
          - event: production.delivery.finished
...
```


**Task**

A sequence consists of a list of tasks whereby a single task is the smallest executable unit. A task has the properties:

* `name`: A unique name of the task
* `triggeredAfter` *(optional)*: Wait time before task is triggered.
* `properties` *(optional)*: Task properties as individual `key:value` pairs. These properties precise the task and are
  consumed by the unit that executes the task.

The following tasks are reserved by Keptn:

* `approval`

    Defines the kind of approval that is required before deploying an artifact in a stage
    The approval strategy can be defined based on the evaluation result `pass` and `warning`
    Keptn supports the approval strategies for the evaluation results `pass` and `warning` set to:

        * `automatic`: Task sequence continues without requesting approval
        * `manual`:  Task sequence requests for approval before continuing

    *Usage:*
    ```yaml
    - name: approval
      properties:
        pass: automatic
        warning: manual
    ```

    > **Note:** By default, an `automatic` approval strategy is used for the `pass` and `warning` evaluation results.

* `deployment`

    Defines the deployment strategy used to deploy a new version of a service.
    For example, the *helm-service* supports the deployment `strategy` set to:

        * `direct`: Deploys a new version of a service by replacing the old version of the service.
        * `blue_green_service`: Deploys a new version of a service next to the old one.
        After a successful validation of this new version, it replaces the old one and is marked as stable.

    *Usage:*
    ```yaml
    - name: deployment
      properties:
        deploymentstrategy: blue_green_service
    ```

* `evaluation`

Defines the quality evaluation that is executed to verify the quality of a deplyoment based on its SLOs/SLIs.

*Usage:*
```yaml
- name: evaluation
```

* `release`

Defines the releasing task that is executed after a successful deployment happened.

*Usage:*
```yaml
- name: release
```

* `rollback`

Defines the rollback task that is executed when a rollback shall be triggered.

*Usage:*

```yaml
- name: rollback
```

* `remediation`

Defines whether remediation actions are enabled or not.

*Usage:*
```yaml
- name: remediation
```

* `test`

Defines the test strategy used to validate a deployment. Failed tests result in an automatic roll-back of the latest deployment in case of a blue/green deployment strategy. For example, the *jmeter-service* supports the `teststrategy` set to:
* `functional`: Test a deployment based on functional tests.
* `performance`: Test a deployment based on performance/load tests.

*Usage:*
```yaml
- name: test
  properties:
    teststrategy: functional
```



## Usage

## Example

## Differences between versions

## See also

