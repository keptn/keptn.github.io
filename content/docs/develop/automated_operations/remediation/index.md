---
title: Remediation Config
description: Configure a remediation and add it to your service.
weight: 1
icon: setup
---

The remediation config describes a remediation workflow in a declarative manner. Hence, it only defines what needs to be done and leaves all the details to other components. 

## Configure Remediation

Below is an example of a declarative remediation config: 

**Example of a remediation configuration:**

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

A remediation is configured based on two properties:

* **problemType**: Maps a problem to a remediation. 
* **actionsOnOpen**: Declares a list of actions triggered in course of the remediation.

### Problem type

The problem type maps a problem to a remediation by a matching problem title. 

-	It is possible to declare multiple problem types for a remediation. 
-	For the case of triggering a remediation based on an unknown problem, the problem type `default` is supported. 

The below example shows a remediation configured for the problem type *Response time degradation* and *Failure rate increase* as well as any unknown problem.

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
* The **action** property specifies a unique name required by the action-provider (Keptn-service) that executes the action.
* The **value** property allows adding an arbitrary list of values for configuring the action.

If multiple actions are declared, Keptn sends out events in sequential order. Given the below example, the event for triggering `scaling` is sent out before the event for `featuretoggle` is fired. 

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
      value: 
        increment: +1
    - name: Toogle feature flag
      action: featuretoggle
      description: Toggle feature flag EnablePromotion from ON to OFF.
      value: 
        EnablePromotion: off
```

## Add Remediation Config to a Service

**Important:** In the following command, the value of `resourceUri` must be set to `remediation.yaml`.

* To add an remediation config to a service, use the [keptn add-resource](../../reference/cli/commands/keptn_add-resource) command:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
    ```