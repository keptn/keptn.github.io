---
title: Action-Provider
description: Add an action-provider to execute custom remediation actions.
weight: 20
icon: setup
---

An action-provider defines the actions that can be declared in a [remediation](../remediation) configuration.
The action-provider receives a Keptn event, performs its action, and notifies Keptn about the execution.
Keptn serves as the control plane that orchestrates the remediation
but the action-provider executes the corrective action.

An action-provider can be a Keptn service that is installed in your Keptn environment
or a custom action-provider that you create.

## Unleash Action-Provider

The [Unleash](https://artifacthub.io/packages/keptn/keptn-integrations/unleash-service) action-provider
toggles the feature flag specified by the `key-value` map in the value property.
The `key` declares the name of the feature toggle and the `value` specifies the target setting. 

* Action that needs to be added to [actionsOnOpen](../remediation/#actions-on-open) in the remediation config:

```yaml
- name: Toogle feature flag
  action: featuretoggle
  description: Toggle feature flag EnablePromotion from ON to OFF.
  value:
    EnablePromotion: off
```

* To install the action-provider for Unleash, execute:

```console
kubectl apply -f kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/0.1.0/deploy/service.yaml
```

**Note:** The referenced `service.yaml` file already contains the required distributor.

## Helm Action-Provider

This action-provider increases the ReplicaSet of a Kubernetes deployment by the number defined by the value *increment*.

* Action that needs to add to [actionsOnOpen](../remediation/#actions-on-open) in the remediation config:

```yaml
- name: Scaling ReplicaSet by 1
  description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
  action: scaling
  value: "1"
```

* The `helm-service` is installed by default.

## Add a custom Action-Provider

* To create and add your custom action-provider to Keptn,
follow the instructions [Custom Action-Provider](../../../integrations/action_provider) page.
