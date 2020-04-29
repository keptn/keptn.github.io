---
title: Automated Operations
description: Learn about the core use-case of automated operations.
weight: 4
keywords: [keptn, use-cases]
---

> **Challenge:** In modern microservices environments, you have to deal with systems that can expose unpredictable behavior due to the high number of interdependencies. For example, changing the configuration of one component might have an impact on a totally different part of the system. Besides, problems evolve over time and are often dynamic. The nature and impact of a problem can also change drastically over time.

Keptn addresses this challenge by introducing the concept of micro-operations that declare remediation actions for resolving certain problem types or operational tasks.

## Micro Operations

Micro operations follow a declarative approach and are atomic building blocks.

### Declarative Operations as Code

Below is an example of a declarative `remediation file` as used in Keptn. The file defines two situations and the respective remediation actions. In case of a response time degradation, new instances are scaled up and in the case of an increase in failure rate, a new feature is disabled.

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

* This *remediation file* can be interpreted by an automation component and versioned in a Git repository

* This *remediation file* declares what needs to be done and leaves all the details to other components. This approach also follows the operator pattern that’s used prominently in Kubernetes.

* The *remediation actions* are defined by the developer for all artifacts (i.e., containers images) that are created. These operations instructions become additional metadata for each artifact.

* Using a declarative approach, there is no need to worry about the actual execution details. Developers can leave the details to the platform engineering teams while leveraging the functionality.

### Atomic Building Blocks

Micro operations are called *micro* because they define operational instructions not for an entire application, but rather for individual microservices. Declarative instructions procedures are written on a per-microservice basis. This provides you with atomic actions, which you can select and combine as needed.

## Automated Remediation Process

Assuming a developer has deployed a new artifact with a remediation file, the automated remedation process looks as follows:

1. The process gets triggered by a problem event sent out by a monitoring solution.

1. Keptn receives this problem event and retrieves the remediation file from the Git repository.

1. An internal Keptn-service interprets the remediation file and fires events for remediation providers. Remediation providers are microservices that implement a micro-operation. 

1. Depending on the problem type, the remediation provider then executes its action and informs Keptn about the execution. 

1. Keptn triggers a re-evaluation of the quality gate in this stage. 

1. Based on the result of this evaluation, Keptn sends out an event to escalate the problem or to mark it as resolved.

  {{< popup_image
  link="./assets/automated_remediation.png"
  caption="Automated remediation workflow"
  width="700px">}}
