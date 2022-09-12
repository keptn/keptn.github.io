---
title: A simple project
description: A simple project with dev, hardening, and production stages
weight: 30
keywords: [0.19.x-define]
aliases:
---

This page walks through the process of populating
a [shipyard](../../reference/files/shipyard) file that defines
a simple, multi-stage project.


**Example of a shipyard with three stages:**

This is a minimalist *shipyard* file that can be used to create the project
as discussesd in [Start a project](../manage/project):

    apiVersion: spec.keptn.sh/0.2.3
    kind: "Shipyard"
    metadata:
      name: "shipyard-sockshop"
    spec:
      stages:
        - name: "dev"
        - name: "hardening"
        - name: "production"

This is enough to set up the project.
To make it do something useful, you must populate
[tasks and sequences](task-sequence).
These are illustrated below.

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

