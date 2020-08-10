---
title: Continuous Performance Verification
description: Learn about continuous performance verification with Keptn.
weight: 3
keywords: [keptn, use-cases]
---

> **Challenge:** Today, performance verification is often a manual task overseen by performance engineers that start performance tests, monitor the execution, and evaluate the test results. However, this approach is cumbersome when it comes to microservice environments where the sheer amount of microservices and tests for them cannot be tackled in a manual approach. 

Keptn helps automating your tests by having Keptn triggering the test execution and evaluating the result of these performance tests. The result can then be automatically processed or presented in the Keptn Bridge to take further decisions. You can even expand this use case by letting Keptn deploying new versions of your applications to a test environment, succeeded by triggering and evaluating the tests. 

## Test Automation Process

The following image shows the general process of how Keptn is providing continuous performance verification. An underlying core concept for this process it the SLO/SLI validation as explained in [Quality Gates](../quality_gates/).

1. Keptn gets triggered by an external event. 

1. Keptn deploys the new version of the application that should be tested. (This is an optional step and can also be skipped if you have already set up this task.)

1. Keptn triggers the execution of the tests by having integrations with multiple testing tools. 

1. Keptn fetches the results of the test and service-level indicators (SLIs).

1. Keptn evaluates and scores the test execution as well as the service-level indicators (SLIs) based on service-level objectives(SLOs).

1. Finally, the performance verification of the tests is then returned as a result back to the user.

  {{< popup_image
  link="./assets/test-automation.png"
  caption="Keptn Test Automation"
  width="700px">}}

## References

- [SLO Validation as a self-Service](https://www.neotys.com/blog/neotyspac-slo-validation-self-service-keptn-quality-gates/)