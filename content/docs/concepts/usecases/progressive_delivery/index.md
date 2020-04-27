---
title: Scriptless Delivery
description: Learn about the core use-case of scriptless delivery.
weight: 1
keywords: [use-cases]
---

Keptn follows the approach of *scriptless delivery*, thus, there is no need to write *any* imperative pipeline code. Instead, a multi-stage delivery workflow is defined declaratively. 

The definition is manifested in a so-called *shipyard* file that defines a delivery workflow. It can hold multiple stages, each with a dedicated *deployment strategy*, *test strategy*, as well as a *remediation strategy*. Following this declarative approach, there is no need to write imperative pipeline code. Keptn takes the shipyard file and creates a multi-stage workflow each stage having a deployment strategy (e.g., blue/green), testing strategy (e.g., functional tests or performance tests), as well as an optional automated remediation strategy to trigger self-healing actions.

  {{< popup_image
  link="./assets/progressive-delivery.png"
  caption="Progressive delivery workflow"
  width="700px">}}

Please take a look at an example of a multi-stage delivery workflow with a *dev*, *hardening*, and *production* stage with blue/green deployment and automated problem remediation.

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "hardening"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
    remediation_strategy: "automated"
```

According to the example, Keptn will perform a direct deployment (i.e., replacing the previous version of a microservice with a new one) and trigger functional tests in the *dev* stage. In the *hardening* stage, Keptn will perform a blue/green deployment (i.e., having two deployments at the same time but routing the traffic to only one) and trigger performance tests. Finally, the *production* stage even defines an automated remediation strategy to trigger counter actions to any issues detected by a monitoring system.