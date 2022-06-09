---
title: remediation
description: Configure remediation actions for a service
weight: 650
---

The remediation configuration describes a remediation workflow
that is called by a `remediation` sequence in the project's [shipyard](../shipyard) configuration.
It defines what needs to be done but leaves the details to other components.

## Synopsis

    apiVersion: spec.keptn.sh/0.1.4
    kind: Remediation
    metadata:
      name: <service>-remediation
    spec:
      remediations:
        - problemType: <Description>
          actionsOnOpen:
            - action: scaling
              name: Scaling ReplicaSet by 1
              description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
              value: "1"

## Fields

* `apiVersion`:
  Must be set to `spec.keptn.sh/0.1.4`

* `kind`:
  Must be set to `Remediation`

* `metadata`: `name`:
    Unique name for this *remediation* configuration.
    Typically, this is a string that defines the service with which this remediation is associated,
    followed by a dash and `remediation`.

* `remediations`:
  Definitions of the problems this service can identify
  and the corrective action to take for each problem.

  A remediation is configured based on two properties:

  * `problemType`: Maps a problem to a remediation that matches a problem title
    defined in the [Action-Provider](../../../automated_operations/action-provider).
    One remediation can declare multiple problem types.
    The `default` problem type is supported to trigger a remediation for an unknown problem.

  * `actionsOnOpen`: Declares a list of actions triggered in course of the remediation.

    * `action` -- specifies a unique name that matches a definition for the
      [Action Provider](../../../automated_operations/action-provider) (Keptn-service)
      that executes the action
    * `description` -- provides more details about the action
    * `value` -- property allows adding an arbitrary list of values for configuring the action

    If multiple actions are declared, Keptn sends out events in sequential order.

## Usage

## Examples

The following example shows a remediation configured for the problem types
`Response time degradation` and `Failure rate increase`
as well as the `default` problem type that is used for any unknown problem:

    apiVersion: spec.keptn.sh/0.1.4
    kind: Remediation
    metadata:
      name: serviceXYZ-remediation
    spec:
      remediations:
      - problemType: Response time degradation
        actionsOnOpen:
      - problemType: Failure rate increase
        actionsOnOpen:
      - problemType: default
        actionsOnOpen:

## Configuration command

To add a remediation config to a service,
use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

    keptn add-resource --project=<project> --stage=<stage> --service=<service> --resource=remediation.yaml --resourceUri=remediation.yaml

For this command:

* The value of the `resourceUri` argument must be set to `remediation.yaml`.
* The value of the `project` argument must match the value of the argument to the `metadata`/`name` field
in the [shipyard](../shipyard/) configuration.
* The value of `stage` argument must match the name assigned to the appropriate stage in the
[shipyard](../shipyard/) configuration.

## Files

## Differences between versions

## See also

