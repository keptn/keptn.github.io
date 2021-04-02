---
title: Automated Operations
description: Learn about the core use-case of automated operations.
weight: 4
keywords: [keptn, use-cases]
---

> In modern microservices environments, you have to deal with systems that can expose unpredictable behavior due to the high number of interdependencies. For example, changing the configuration of one component might have an impact on a different part of the system. Besides, problems evolve and are often dynamic. The nature and impact of a problem can also change drastically over time.

Keptn addresses this challenge by introducing the concept of micro-operations that declare remediation actions for resolving certain problem types or triggering any operational tasks. Micro-operations follow a declarative approach, are atomic building blocks, and get triggered by events.

## Declarative Operations as Code

Keptn complies with a declarative approach for configuring remediation and operations workflows as code on the level of individual microservices (rather than on applications). Consequently, this declaration is versioned next to the operational config and deployed with each new version of the microservice.

Below is an example of a declarative `remediation.yaml` file as used in Keptn. The file defines two problem types and the respective remediation actions. In case of a response time degradation, new instances are scaled up and in the case of a failure rate increase, a feature is disabled. To learn more about the remediation configuration, please continue [here](../../0.7.x/automated_operations/remediation). 

```yaml
version: 0.2.0
kind: Remediation
metadata:
  name: remediation-service-carts
spec:
  remediations:  
  - problemType: Response time degradation
    actionsOnOpen:
    - name: Scaling ReplicaSet by 1
      description: Scaling the ReplicaSet of a Kubernetes Deployment by 1
      action: scaling
      value: 
        increment: +1
  - problemType: Failure rate increase
    actionsOnOpen:
    - name: Toogle feature flag
      action: featuretoggle
      description: Toggle feature flag PromotionCampaign from ON to OFF.
      value: 
        PromotionCampaign: off
```

* This *remediation file* is interpreted by the provided remediation-service and versioned in a Git repository

* This *remediation file* declares what needs to be done and leaves all the details to other components.

* The *remediation actions* are defined by the developer for all services that are created. These operations instructions become additional metadata for each service.

* Using a declarative approach, there is no need to worry about the actual execution details. Developers can leave the details to the platform engineering teams while leveraging the functionality.

## Atomic Building Blocks

In Keptn, a remediation action or operational task is implemented as micro-operation. Such a micro-operation is reduced to the max, meaning that it is designed to execute a single action. This action is implemented for a single microservice rather than an entire application. Consequently, declarative instructions procedures are written on a per-microservice basis, which you can select and combine as needed.

A micro-operation is implemented by an [action-provider](../../0.7.x/integrations/custom_integration/), which is a Keptn-service with a dedicated purpose. This type of service is responsible for executing an action (aka. micro-operation) and therefore might even use another tool. An action-provider starts working, when receiving a Keptn CloudEvent of type: `sh.keptn.event.action.triggered`. To learn more about the implementation of a micro-operation by an action-provider, please continue [here](../../0.7.x/automated_operations/action-provider). 

## Event-driven Choreography

Assuming a developer has deployed a new artifact with a remediation file, the task sequence of an automated remediation looks as follows:

1. The process gets triggered by a problem event sent out by a monitoring solution.

1. Keptn receives this problem event and retrieves the remediation file from the Git repository.

1. An internal Keptn-service interprets the remediation file and sends out events for action-providers. 

1. Depending on the problem type, the action-providers executes its action and informs Keptn about the execution. 

1. Keptn triggers a re-evaluation of the quality gate in this stage. 

1. Based on the result of this evaluation, Keptn sends out an event to escalate the problem or to mark it as resolved.

  {{< popup_image
  link="./assets/automated_remediation.png"
  caption="Task sequence of an automated remediation"
  width="700px">}}

## References

- [Micro operations — A new operations model for the micro services age](https://medium.com/@alois.reitbauer_97826/micro-operations-a-new-operations-model-for-the-micro-services-age-e29cd1bbd0cd)
- [Closed-loop Remediation with custom Integrations](https://medium.com/link-is-missing)
