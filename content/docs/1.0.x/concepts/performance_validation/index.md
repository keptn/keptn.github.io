---
title: Continuous Performance Verification
description: Learn about continuous performance verification with Keptn.
weight: 3
keywords: [keptn, use-cases]
---

> Performance verification is often a manual task overseen by performance engineers that start performance tests, monitor the execution, and evaluate the test results. However, this approach is cumbersome when it comes to microservice environments where the sheer amount of microservices and tests for them cannot be tackled in a manual approach. 

Keptn helps automate your tests by having Keptn trigger the test execution and evaluate the results of these performance tests. The results can then be automatically processed or presented in the Keptn Bridge to take further decisions. You can even expand this use case by letting Keptn deploying new versions of your applications to a test environment, succeeded by triggering and evaluating the tests. 

Keptn can also trigger functional tests and security scans and can send notifications of the results or can be set up to automatically take action, such as deploying the software to production if the test results meet certain criteria.  Tests can also be run against your production environment, where Keptn can even be set up to perform remediation in some cases, such as spinning up additional resources when performance issues are detected.

## Test Automation Process

The following image shows the general process of how Keptn is providing continuous performance verification. An underlying core concept for this process it the SLO/SLI-based deployment and release validation as explained in [Quality Gates](../quality_gates/).

1. Keptn is triggered by an external event. 

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
