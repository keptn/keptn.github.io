---
title: Remediation Action
description: Configure a remediation action and add it to your service.
weight: 1
icon: setup
---

The *Remediation Action* configuration defines micro-operations to execute in response to a problem. These micro-operations are interpreted by Keptn to trigger the proper remediation and to provide self-healing for an application without modifying code.

## Remediation Action

* A remediation maps to a problem.
* A remediation declares an action to executed as a response to the problem. 

**Example of a remediation action configuration:**

```yaml
remediations:
- name: "Response time degradation"
  actions:
  - action: scaling
    value: +1
- name: "Failure rate increase"
  actions:
  - action: featuretoggle
    value: EnablePromotion:off
```

A remediation action is configured based on two properties:

* The **name** refers to the title of a problem. 
* The **actions** takes a list of actions (currently only one is supported). An **action** can be set to `scaling` or `featuretoggle`. 
  * *scalling*: scales the Kubernetes pod of the deployment based on the specified value. 
  * *featuretoggle*: toggles a feature flag specified by the value and controlled by the Unleash framework.

## Add a Remediation Action to a Service

**Important:** In the following command, the value of the `resourceUri` must be set to `remediation.yaml`.

* To add an remediation action to a service, use the [keptn add-resource](../../../reference/cli/commands/keptn_add-resource) command:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=remediation.yaml --resourceUri=remediation.yaml
    ```