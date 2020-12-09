---
title: Multi-stage delivery
description: Customize your delivery and staging process.
weight: 1
keywords: [0.8.x-cd]
---

The definition of a multi-stage delivery manifests in a so-called **shipyard**. It can hold multiple stages with dedicated and opinionated delivery tasks to execute. Following this declarative approach, there is no need to write imperative pipeline code. Keptn takes the shipyard file and creates a task sequence for multi-stage delivery.

## Declare Shipyard (before creating a project)

The `shipyard.yml` file defines the stages each deployment has to go through until it is released in production. A shipyard file can consist of any number of stages with at least the name property. Besides, each stage can consist of sequence tasks (strategies) from the following list:

* approval_strategy
* deployment_strategy
* test_strategy

A shipyard is defined at the level of a project. This means that all services in a project share the same shipyard configuration. 

### Name 

The name of the stage. This name will be used for the branch in the Git repository and Kubernetes namespace to which services at this stage will be deployed to. 

**Example of a shipyard with three stages:**

```yaml
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
    - name: "hardening"
    - name: "production"
```

### Approval Strategy

The approval strategy specifies the kind of approval, which is required before deploying an artifact into the next stage. The approval strategy can be defined based on the evaluation result `pass` and `warning`. Keptn supports the following approval strategies for the evaluation results `pass` and `warning`:

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

**Extended shipyard with a mandatory approval task in production:**

```yaml
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "artifact-delivery"
          tasks:
            - name: "deployment"
            - name: "approval"
              properties:
                pass: "manual"
                warning: "manual"
            - name: "release"
```

### Deployment Strategy

Defines the deployment strategy used to deploy a new version of a service. Keptn supports deployment strategies of type: 

  * `direct`: Deploys a new version of a service by replacing the old version of the service.
  * `blue_green_service`: Deploys a new version of a service next to the old one. After a successful validation of this new version, it replaces the old one and is marked as stable (i.e., it becomes the `primary`-version).

**Extended shipyard with direct deployment in dev and blue/green deployment in hardening and production:**

```yaml
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
        - name: "artifact-delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct"
            - name: "evaluation"
            - name: "release"

    - name: "hardening"
      sequences:
        - name: "artifact-delivery"
          triggers:
            - "dev.artifact-delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "evaluation"
            - name: "release"

    - name: "production"
      sequences:
        - name: "artifact-delivery"
          triggers:
            - "staging.artifact-delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

### Test Strategy

Defines the test strategy used to validate a deployment. Failed tests result in an automatic roll-back of the latest deployment in case of a blue/green deployment strategy. Keptn supports tests of type:

  * `functional` 
  * `performance` 

**Extended shipyard with functional tests in dev and performance tests in hardening**

```yaml
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
        - name: "artifact-delivery"
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
        - name: "artifact-delivery"
          triggers:
            - "dev.artifact-delivery.finished"
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

## Create project with multi-stage delivery

After declaring the delivery for a project in a shipyard, you are ready to create a Keptn project as explained in [create a project](../../manage/project/#create-a-project).