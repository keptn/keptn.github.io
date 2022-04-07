---
title: Action-Provider
description: Add an action-provider to execute custom remediation actions.
weight: 5
icon: setup
keywords: [0.15.x-automated-operations]
---

Depending on the action that should be executed in course of a remediation (or operational), a corresponding action-provider must be deployed. This action-provider receives a Keptn event, performs its action, and notifies Keptn about the execution. 

To plug-in an action-provider into a remediation, the remediation config must be extended by an action supported by the provider. Consequently, Keptn - as control plane and responsible for orchestrating the remediation - can send out the proper event for the action-provider.  

## Unleash Action-Provider

This action-provider toggles the feature flag specified by the *key-value* map in the value property. While the key declares the name of the feature toggle, the value specifies the target setting.  

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

**Note:** The referenced `service.yaml` already contains the required distributor.

## Helm Action-Provider

This action-provider increases the ReplicaSet of a Kubernetes deployment by the number defined by the value *increment*.  

* Action that needs to be added to [actionsOnOpen](../remediation/#actions-on-open) in the remediation config: 

```yaml
- name: Scaling ReplicaSet by 1
  description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
  action: scaling
  value: "1"
```

* The `helm-service` is installed by default. 

## Add a custom Action-Provider

* To create and add your custom action-provider to Keptn, please follow the instructions [here](../../integrations/action_provider).
