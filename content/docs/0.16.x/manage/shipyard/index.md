---
title: Working with shipyard files
description: Information about shipyard, sequences and tasks to define processes and workflows.
weight: 25
keywords: [0.16.x-manage]
aliases:
---

A [shipyard.yaml](../../reference/files/shipyard) file is defined at the level of a project.
This means that all services in a project share the same shipyard definition.

* A shipyard defines the stages each deployment has to go through until it is released in the final stage, e.g., the production stage.

* A shipyard can consist of any number of stages; but at least one. Each stage must have at least the name property.

* A stage can contain any number of sequences but must have at least one.

**Example of a shipyard with three stages:**

    apiVersion: spec.keptn.sh/0.2.3
    kind: "Shipyard"
    metadata:
      name: "shipyard-sockshop"
    spec:
      stages:
        - name: "dev"
        - name: "hardening"
        - name: "production"

**Example:** Extended shipyard with a delivery sequence in all three stage:

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


          - name: "delivery"
            triggeredOn:
              - event: "hardening.delivery.finished"
            tasks: 
            - name: "deployment"
            - name: "release"

<details><summary>**Example:** Extended shipyard with functional tests in dev and performance tests in hardening
</summary>

<p>

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

**Result:** The next time this sequence gets triggered by Keptn, the task will be executed meaning that a `sh.keptn.event.[task].triggered` event is sent out. Make sure to have a Keptn-service that listens to this event type and can execute it. 

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

**Use-case 1:** I would like to add an additional delivery process to the production stage that allows rolling-out a hotfix without testing and evaluation. 

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

**Result:** After extending the shipyard as shown above,
remediations should be executed when a problem event is retrieved.
See [Remediation sequences](../remediation-sequence).

