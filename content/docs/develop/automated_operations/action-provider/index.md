---
title: Action-Provider
description: Add an action-provider to Keptn to execte custom remediation actions.
weight: 5
icon: setup
---

Depending on the automation tools you have in place, you need to deploy the corresponding action provider. 
Besides, the remediation config must be extended by the action to tell Keptn which event to sent out. 

## Unleash Action-Provider




* To install the `unleash-service`, execute:

```console
kubectl apply -f https://github.com/keptn-contrib/unleash-service/blob/master/deploy/service.yaml
```

**Note:** The referenced service.yaml already contains the required distributor.

* Action that needs to be added to [**actionsOnOpen**](../remediation/#actions-on-open) in the remediation config:  

```yaml
- name: Toogle feature flag
  action: featuretoggle
  description: Toggle feature flag EnablePromotion from ON to OFF.
  value: 
    EnablePromotion: off
```

* **Functionality**: This action-provider toggles the feature flag specified by the *key-value* map in the value property. While the key declares the name of the feature toggle, the value specifies the target setting.   

## Helm Action-Provider

* The `helm-service` is installed by default. 

* Action that needs to be added to [**actionsOnOpen**](../remediation/#actions-on-open) in the remediation config: 

```yaml
- name: Scaling ReplicaSet by 1
  description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
  action: scaling
  value: 
    increment: +1
```

* **Functionality**: This action-provider increases the ReplicaSet of a Kubernetes deployment by the number defined by the value *increment*.  


## Add custom Action-Provider

* To create and add your custom SLI-Provider to Keptn, please follow the instructions [here](../../integrations/action_provider).