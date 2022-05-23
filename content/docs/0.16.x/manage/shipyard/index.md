---
title: Shipyard
description: Information about shipyard, sequences and tasks to define processes and workflows.
weight: 25
keywords: [0.16.x-manage]
aliases:
---

## Declare Shipyard (before creating a project)

* A shipyard is defined at the level of a project. This means that all services in a project share the same shipyard definition.

* A shipyard defines the stages each deployment has to go through until it is released in the final stage, e.g., the production stage.

* A shipyard can consist of any number of stages; but at least one. A stage must have at least the name property.

* A stage can consist of any number of sequences; but at least one.


### Definition of Stage

A stage is declared by its name. This name is used for the branch in the Git repository and Kubernetes namespace to which services at this stage will be deployed.

**Example of a shipyard with three stages:**

```yaml
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

### Definition of Sequence in a Stage

After defining stages, sequences can be added to a stage. A sequence is an ordered list of tasks that are triggered sequentially. A `sequence` consists of the following properties:

* `name`: A unique name of the sequence
* `triggeredOn` (optional): An array of events that trigger the sequence.
* `tasks`: An array of tasks executed by the sequence in the declared order.

**Example:** Extended shipyard with a delivery sequence in all three stage:

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
      - name: "delivery"
        tasks: 
        - name: "deployment"
        - name: "release"

    - name: "hardening"
      sequences:
      - name: "delivery"
        triggeredOn:
          - event: "dev.delivery.finished"
        tasks: 
        - name: "deployment"
        - name: "release"

    - name: "production"
      sequences:
      - name: "delivery"
        triggeredOn:
          - event: "hardening.delivery.finished"
        tasks: 
        - name: "deployment"
        - name: "release"
```

### Reserved Keptn Tasks

Keptn supports a set of opinionated tasks for declaring a delivery or remediation sequence:

* action
* approval
* deployment
* evaluation
* get-action
* release
* rollback
* test

#### Action

The action task indicates that a remediation action should be executed by an action provider. It is used within a [remediation workflow](../../automated_operations/remediation).

**Usage:**

```
- name: action
```

#### Approval

The approval task intercepts the task sequence and waits for a user to approve or decline the open approval. This task can be added, for example, before deploying an artifact into the next stage. The approval strategy can be defined based on the evaluation result `pass` and `warning`. Keptn supports the following approval strategies for the evaluation results `pass` and `warning`:

* `automatic`: The artifact is deployed automatically.
* `manual`: The user is asked for approval before triggering the deployment.

This allows combinations as follows:

|                          | Evaluation result: pass           | Evaluation result: warning                 | Behavior  |
|--------------------------|-----------------------------------|--------------------------------------------|-----------|
| **Skip approval task:** | pass:automatic | warning:automatic | Regardless of the evaluation result, the approval task is skipped |
| **Depending on evaluation result:**   | pass:automatic | warning:manual    | If the evaluation result is a **warning**, an approval is required |
| **Depending on evaluation result:**   | pass:manual    | warning:automatic | If the evaluation result is a **pass**, an approval is required |
| **Mandatory approval task:**          | pass:manual    | warning:manual    | Regardless of the evaluation result, an approval is required |

By default, an `automatic` approval strategy is used for evaluation result `pass` and `warning`.

**Usage:**

```
- name: approval
  properties: 
    pass: automatic
    warning: manual
```

**Note:** If the approval is the first task of a sequence, the approval service is not provided with the result from a previous task. In this case, it always falls back to the `manual` approval strategy.

<details><summary>**Example:** Extended shipyard with a mandatory approval task in production</summary>

<p>

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
            - name: "approval"
              properties:
                pass: "manual"
                warning: "manual"
            - name: "release"
```

</p>
</details>

#### Deployment

Defines the deployment strategy (see [Continuous Delivery](../../continuous_delivery/)) used to deploy a new version of a service. Keptn supports deployment strategies of type:

* `direct`: Deploys a new version of a service by replacing the old version of the service.
* `blue_green_service`: Deploys a new version of a service next to the old one. After a successful validation of this new version, it replaces the old one and is marked as stable (i.e., it becomes the `primary`-version).
* `user_managed` (experimental): Deploys a new version of a service by fetching the current helm-chart from the git repo, and just updating certain values.

**Usage:**

```
- name: deployment
  properties: 
    deploymentstrategy: blue_green_service
```

```
- name: deployment
  properties: 
    deploymentstrategy: direct
```

```
- name: deployment
  properties: 
    deploymentstrategy: user_managed
```

#### Evaluation

Defines the quality evaluation that is executed to verify the quality of a deployment based on its SLOs/SLIs.

**Usage:**
```
- name: evaluation
```

#### Get-Action

The get-action task is used to extract the desired remediation action from a remediation.yaml within a [remediation workflow](../../automated_operations/remediation).

**Usage:**

```
- name: get-action
```

#### Release

Defines the releasing task that is executed after a successful deployment happens. This means that production traffic is shifted towards the new deployment in this task.

**Usage:**
```
- name: release
```

#### Action

Defines the execution of a remediation action retrieved by `get-action`.

**Usage:**
```
- name: action
```

#### Rollback

Defines the rollback task that is executed when a rollback is triggered.

**Usage:**
```
- name: rollback
```

#### Test

Defines the test strategy used to validate a deployment. Keptn supports tests of type:

* `functional`: Test a deployment based on functional tests.
* `performance`: Test a deployment based on performance/load tests.

**Usage:**
```
- name: test
  properties: 
    teststrategy: functional
```

<details><summary>**Example:** Extended shipyard with functional tests in dev and performance tests in hardening
</summary>

<p>

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

    - name: "staging"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "dev.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "performance"
            - name: "evaluation"
            - name: "release"

``` 

</p>
</details>


## Updating a Shipyard

This section provides examples on how to update a shipyard file.

### Add/Remove a task to/from a task sequence

If you want to add or remove an additional task to a sequence, you can do this by adding/removing the task directly in the shipyard: 

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Use-case:** To intervene in the delivery process, I would like to add an `approval` task before the `release` task.

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "approval"
            - name: "release"
```

**Result:** The next time Keptn triggers this sequence, the task is executed, meaning that a `sh.keptn.event.[task].triggered` event is sent out. Be sure to have a Keptn-service that listens to this event type and can execute it. 

### Add/Remove a task sequence to/from a stage

If you want to add or remove an additional task sequence to a stage, you can do this by adding/removing the sequence directly in the shipyard: 

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Use-case 1:** I would like to add an additional delivery process to the production stage that allows rolling out a hotfix without testing and evaluation. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

        - name: "hotfix-delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

**Result:** After extending the shipyard as shown above, you can trigger this sequence using: 

```
keptn trigger delivery --project=<project> --service=<service> --image=<image> --tag=<tag> --sequence=hotfix-delivery
```

**Use-case 2:** I would like to add a remediation sequence to the production stage that allows executing remediation actions when problems occur.

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"


        - name: "remediation"
          triggeredOn:
            - event: "production.remediation.finished"
              selector:
                match:
                  evaluation.result: "fail"
          tasks:
            - name: "get-action"
            - name: "action"
            - name: "evaluation"
              triggeredAfter: "10m"
              properties:
                timeframe: "10m"
```

**Result:** After extending the shipyard as shown above, remediations should be executed when a problem event is retrieved (see [remediation workflow](../../automated_operations/remediation)).

### Define a trigger for a sequence 

An advanced and powerful feature of the shipyard is that you can define *triggers* to kick-off a sequence. Therefore, a sequence offers the `triggeredOn` property where a list of events can be specified. The event types you can list there are events that refer to the status of a sequence execution. Their name follows the pattern:

* `[stage_name].[sequence_name].finished` 

**Note:** It is not required to specify the full qualified event name which would be `sh.keptn.event.[stage_name].[sequence_name].finished` in this case

In addition, a *match selector* can be added to an event to work as a filter on the `result` property of the event. Consequently, you can filter based on sequence executions that *failed* or *passed*, shown by the next example that filters on `failed`:

```
sequences:
  - name: "rollback"
    triggeredOn:
      - event: "production.delivery.finished"
        selector:
          match:
            result: failed
```

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Use-case:** I would like to add a process (additional sequence) that covers a failed delivery in the production stage by a notification and rollback task. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

        - name: "rollback"
          triggeredOn:
            - event: "production.delivery.finished"
                selector:
                  match:
                    result: failed
          tasks:
            - name: "notification"
            - name: "rollback"
```

**Result:** When, for example, the *delivery* sequence failed due to a failed test task, the event `sh.keptn.event.production.delivery.finished` with `result=failed` is sent out. Consequently, the *rollback* sequence is triggered based on the configuration of the `triggeredOn` and selector.

## Trigger a sequence

A shipyard file can contain multiple sequences in multiple stages.
A specific `sequence` can be run by using the `POST /event` [Keptn API](../../reference/api/) with the following template:

```json
{
    "data": {
      "project": "[project]",
      "service": "[service]",
      "stage": "[stage]"
    },
    "source": "[my-source]",
    "specversion": "1.0",
    "type": "sh.keptn.event.[stage].[sequence-name].triggered",
    "shkeptnspecversion": "0.2.3"
}
```

The values between square brackets (`[]`) should be replaced based on your configuration:

* `project`: your project name;
* `service`: your service name;
* `stage`: the stage in which your sequence is defined;
* `sequence-name`: the sequence to trigger;
* `my-source`: your source. More info are available in the [CloudEvents spec](https://github.com/cloudevents/spec/blob/v1.0/spec.md#source).

### Examples

In the following example, we define the `podtato-example` project that has the `helloservice` service. The shipyard file for the project defines three sequences:

* `delivery` in the *hardening* stage;
* `evaluation-only` in the *hardening* stage;
* `delivery` in the *production* stage.

```yaml
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "podtato-example"
spec:
  stages:
    - name: "hardening"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "performance"
            - name: "evaluation"
            - name: "release"
        - name: "evaluation-only"
          tasks:
            - name: "evaluation"
              properties:
                teststrategy: "performance"
    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "hardening.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

To trigger the `delivery` sequence in the *hardening* stage, post the following payload to the `POST /event` endpoint.

```json
{
  "data": {
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "hardening"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:50:04.720Z",
  "type": "sh.keptn.event.hardening.delivery.triggered",
  "shkeptnspecversion": "0.2.3"
}
```

To trigger the `delivery` sequence in the *production* stage, post the following payload to the `POST /event` endpoint.

```json
{
  "data": {
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "production"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:50:04.720Z",
  "type": "sh.keptn.event.production.delivery.triggered",
  "shkeptnspecversion": "0.2.3"
}
```

To trigger the `evaluation-only` sequence in the *hardening* stage, post the following payload to the `POST /event` endpoint.
Since we want to trigger an evaluation, we need to provide addition properties about the evaluation timeframe. More information is provided in the
[Quality Gates](../../quality_gates/get_started/) section of our documentation.

```json
{
  "data": {
    "evaluation": {
      "end": "2022-02-01T09:36:11.311Z",
      "start": "2022-02-01T09:31:11.311Z",
      "timeframe": ""
    },
    "project": "podtato-example",
    "service": "helloservice",
    "stage": "hardening"
  },
  "source": "https://github.com/keptn/keptn/cli#configuration-change",
  "specversion": "1.0",
  "time": "2022-02-01T12:11:50.120Z",
  "type": "sh.keptn.event.hardening.evaluation-only.triggered",
  "shkeptnspecversion": "0.2.3"
}
```
