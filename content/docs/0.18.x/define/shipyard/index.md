---
title: Define project in a shipyard
description: Overview of using a shipyard, sequences and tasks to define a project
weight: 30
keywords: [0.18.x-manage]
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

