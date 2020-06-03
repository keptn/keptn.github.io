---
title: Remediation Action
description: Configure a remediation action and add it to your service.
weight: 1
icon: setup
---

The *Remediation Action* configuration defines micro-operations to execute in response to a problem. These micro-operations are interpreted by Keptn to trigger the proper remediation and to provide self-healing for an application without modifying code.

## Configure Remediation Action

A remediation action is configured based on two properties:

* The **problemType** maps a problem to a remediation. 
* The **actionsOnOpen** declares a list of actions triggered in course of the remediation.

**Example of a remediation action configuration:**

```yaml
---
version: 0.2.0
kind: Remediation
metadata:
  name: remediation-service-abc
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
    - name: Scaling ReplicaSet by 1
      description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
      action: scaling
      values: 
        increment: +1
```

### Problem type

The problem type maps a problem to a remediation. Therefore, the problem title must match.

* It is allows to specify multiple proplem types for a remediation: 

```yaml
version: 0.2.0
kind: Remediation
metadata:
  name: remedation-service-abc
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
  - problemType: Failure rate increase
    actionsOnOpen:
```

* For the case of triggering a remediation based on an unknown problem, the `default` proplem type is supported: 

```yaml
version: 0.2.0
kind: Remediation
metadata:
  name: remedation-service-abc
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
  - problemType: Failure rate increase
    actionsOnOpen:
  - problemType: default
    actionsOnOpen:
```

### Actions on open

* An **action** has a name used for display purposes.
* The **description** provides more details about the action.
* The **action** property specifies a unique name required by the Keptn-service (action provider) that executes the action.
* The **values** property allows to add an abritray list of values to the action (to configure the action).

If multiple actions are specified, they are called in sequential order. Given the below example, the `scaling` action is triggered before the `featuretoggle` action is triggered. 

```yaml
---
version: 0.2.0
kind: Remediation
metadata:
  name: remediation-service-abc
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
    - name: Scaling ReplicaSet by 1
      description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
      action: scaling
      values: 
        increment: +1
    - name: Toogle feature flag
      action: featuretoggle
      description: Toggle feature flag EnablePromotion from ON to OFF.
      values: 
        EnablePromotion: off
```

## Add Remediation Action to a Service

**Important:** In the following command, the value of the `resourceUri` must be set to `remediation.yaml`.

* To add an remediation action to a service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
    ```