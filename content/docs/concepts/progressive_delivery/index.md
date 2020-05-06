---
title: Scriptless Delivery
description: Learn about the core use-case of scriptless delivery.
weight: 1
keywords: [use-cases]
---

> **Challenge:** Today, many organization build their continuous delivery workflows by hand and in an imperative way. This can lead to a lot of manual work when, for example, a scripted delivery pipeline - with slight modifications - is spread across the organization and re-used by different teams. Just imagine the difficulty to keep all variations of this pipeline up-to-date and to consider future changes in the delivery workflow of a new artifact. 

Keptn follows the approach of *scriptless delivery* meaning that there is no need to write *any* imperative pipeline code. Instead, a multi-stage delivery workflow is defined declaratively. 

## Shipyard for Delivery Declaration

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

### References

- [How your delivery pipeline will become your next big legacy-code challenge](https://medium.com/keptn/how-your-delivery-pipeline-will-become-your-next-big-legacy-code-challenge-4e520999693f)
- [Continuous Delivery without pipelines — How it works and why you need it
](https://medium.com/keptn/continuous-delivery-without-pipelines-7e84db8c8261)