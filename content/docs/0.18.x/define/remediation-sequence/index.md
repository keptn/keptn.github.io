---
title: Remediation Sequence
description: Implement a remediation sequence
weight: 80
icon: setup
---

A remediation sequence implements self-healing for a problem
detected by a monitoring solution and sent to Keptn
The remediation defines the action to take
to attempt to correct the problem.
It is most commonly used in production stages but can be used in any type of stage.

To implement a remediation sequence, you must:

* Install an [action-provider](../../reference/files/action-provider)
  that performs the corrective actions to be taken
* Configure a [remediation](../../reference/files/remediation)
  that calls each required action in order and configure it
* Configure a `remediation` sequence in the project's [shipyard](../../reference/files/shipyard)

## Example remediation sequence in shipyard

The definition of a remediation sequence is done in the project's [Shipyard](../../manage/shipyard) file.

**Example**: Simple shipyard file with a remediation sequence in a single stage

    apiVersion: "spec.keptn.sh/0.2.3"
    kind: "Shipyard"
    metadata:
      name: "shipyard-sockshop"
    spec:
      stages:
        - name: "production"
          sequences:
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

## Example remediation configuration

Below is an example of a [remediation](../../reference/files/remediation) configuration
that uses the [Helm action-provider](../../reference/files/action-provider/#helm-action-provider)
to add pods to the cluster:

**Example of a remediation configuration:**

    apiVersion: spec.keptn.sh/0.1.4
    kind: Remediation
    metadata:
      name: serviceXYZ-remediation
    spec:
      remediations:
        - problemType: Response time degradation
          actionsOnOpen:
            - action: scaling
              name: Scaling ReplicaSet by 1
              description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
              value: "1"

