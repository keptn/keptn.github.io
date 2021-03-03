---
title: Multi-stage delivery
description: Customize your delivery and staging process.
weight: 1
keywords: [0.8.x-cd]
---

The definition of a multi-stage delivery manifests in a so-called **shipyard**. It can hold multiple stages with dedicated and opinionated delivery tasks to execute. Following this declarative approach, there is no need to write imperative pipeline code. Keptn takes the shipyard and creates a sequence for multi-stage delivery.

## Declare Shipyard (before creating a project)

* A shipyard is defined at the level of a project. This means that all services in a project share the same shipyard definition. 

* A shipyard defines the stages each deployment has to go through until it is released in the final stage, e.g., the production stage. 

* A shipyard can consist of any number of stages; but at least one. A stage must have at least the name property.

* A stage can consist of any number of seqeunces; but at least one. 

### Definition of Stage 

A stage is declared by its name. This name will be used for the branch in the Git repository and Kubernetes namespace to which services at this stage will be deployed to. 

**Example of a shipyard with three stages:**

```yaml
apiVersion: spec.keptn.sh/0.2.0
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
* `on` (optional): An array of events that trigger the sequence.
* `tasks`: An array of tasks executed by the sequence in the declared order.

**Example:** Extended shipyard with a delivery sequence in all three stage:

```yaml
apiVersion: spec.keptn.sh/0.2.0
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

* approval
* deployment
* evaluation
* release
* remediation
* rollback
* test

#### Approval

The approval task intercepts the sequence and waits for a required approval (e.g., before deploying an artifact into the next stage). The approval strategy can be defined based on the evaluation result `pass` and `warning`. Keptn supports the following approval strategies for the evaluation results `pass` and `warning`:

  * `automatic`: The artifact is deployed automatically.
  * `manual`: The user is asked for approval before triggering the deployment.

This allows combinations as follows: 

|                          | Evaluation result: pass           | Evaluation result: warning                 | Behavior  |
|--------------------------|-----------------------------------|--------------------------------------------|-----------|
| **Skip approval task:** | pass:automatic | warning:automatic | Regardless of the evaluation result, the approval task is skipped |
| **Depending on evaluation result:**   | pass:automatic | warning:manual    | If the evaluation result is a **warning**, an approval is required |
| **Depending on evaluation result:**   | pass:manual    | warning:automatic | If the evaluation result is a **pass**, an approval is required |
| **Mandatory approval task:**          | pass:manual    | warning:manual    | Regardless of the evaluation result, an approval is required |

Per default, an `automatic` approval strategy is used for evaluation result `pass` and `warning`.

**Usage:**

```
- name: approval
  properties: 
    pass: automatic
    warning: manual
```

<details><summary>**Example:** Extended shipyard with a mandatory approval task in production</summary>

<p>

```yaml
apiVersion: spec.keptn.sh/0.2.0
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

Defines the deployment strategy used to deploy a new version of a service. Keptn supports deployment strategies of type: 

  * `direct`: Deploys a new version of a service by replacing the old version of the service.
  * `blue_green_service`: Deploys a new version of a service next to the old one. After a successful validation of this new version, it replaces the old one and is marked as stable (i.e., it becomes the `primary`-version).

**Usage:**

```
- name: deployment
  properties: 
    deploymentstrategy: blue_green_service
```

<details><summary>**Example:** Extended shipyard with direct deployment in dev and blue/green deployment in hardening and production
</summary>

<p>

```yaml
apiVersion: spec.keptn.sh/0.2.0
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
            - name: "evaluation"
            - name: "release"

    - name: "hardening"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "dev.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "evaluation"
            - name: "release"

    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "staging.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

</p>
</details>

#### Evaluation

Defines the quality evaluation that is executed to verify the quality of a deployment based on its SLOs/SLIs.

**Usage:**
```
- name: evaluation
```

#### Release

Defines the releasing task that is executed after a successful deployment happened. This means that production traffic is shifted towards the new deployment in this task. 

**Usage:**
```
- name: release
```

#### Remediation

Defines whether remediation actions are enabled or not.

**Usage:**
```
- name: remediation
```

#### Rollback

Defines the rollback task that is executed when a rollback shall be triggered.

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
apiVersion: spec.keptn.sh/0.2.0
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

## Create project with multi-stage delivery

After declaring the delivery for a project in a shipyard, you are ready to create a Keptn project as explained in [create a project](../../manage/project/#create-a-project).

## Trigger a multi-stage delivery

After creating a project and [onboarding your service(s)](../../manage/service), you can trigger a delivery using the Keptn CLI or API.


<details><summary>**Trigger via Keptn CLI**</summary>
<p>

* Use the command [keptn trigger delivery](../../reference/cli/commands/keptn_trigger_delivery/):

```
keptn trigger delivery --project=$PROJECTNAME --service=$SERVICENAME --image=$IMAGE --tag=$TAG
```

</p>
</details>

<details><summary>**Trigger via Keptn API**</summary>
<p>

* Specify a valid Keptn CloudEvent of type `sh.keptn.event.[STAGENAME].delivery.triggered` and store it as JSON file, e.g., `trigger_delivery.json`

```json
{
  "contenttype": "application/json",
  "data": {
    "project": "[PROJECTNAME]",
    "service": "[SERVICENAME]",
    "stage": "[STAGENAME]",
    "configurationChange": {
      "values": {
        "image": "keptn-examples/carts:0.11.3"
      }
    }
  },
  "source": "https://github.com/keptn/keptn/cli",
  "specversion": "1.0",
  "type": "sh.keptn.event.[STAGENAME].delivery.triggered"
}
```

* Trigger a delivery with a POST request on `/event`:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/event" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./trigger_delivery.json
```

</p>
</details>




