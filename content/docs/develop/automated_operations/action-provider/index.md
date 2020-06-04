---
title: Action-Provider
description: Add a remediation action provider to Keptn to execte custom actions.
weight: 5
icon: setup
---

Depending on the automation tools you have in place, you need to deploy the corresponding remediation action provider. 
For demo purposes, the following action providers can be added to Keptn.

## Unleash

* Deploy `unleash-service` by executing (the referenced service.yaml contains distributor):

```console
kubectl apply -f https://github.com/keptn-contrib/unleash-service/blob/master/deploy/service.yaml
```

* Action that needs to be added to [**actionsOnOpen**](../remediation/#actions-on-open) in the remediation config:  

```yaml
- name: Toogle feature flag
  action: featuretoggle
  description: Toggle feature flag EnablePromotion from ON to OFF.
  values: 
    EnablePromotion: off
```

## Helm

* The `helm-service` is installed by default. 

* Action that needs to be added to [**actionsOnOpen**](../remediation/#actions-on-open) in the remediation config: 

```yaml
- name: Scaling ReplicaSet by 1
  description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
  action: scaling
  values: 
    increment: +1
```

## Add custom Action-Provider

* To create and add your custom SLI-Provider to Keptn, please follow the instructions [here](../../integrations/sli_provider).