---
title: Test Automation
description: Learn about test automation with Keptn.
weight: 3
keywords: [keptn, use-cases]
---

With Keptn you can automate your tests by having Keptn triggering the test execution and evaluating the result, or even by letting Keptn deploying new versions of your applications to a test environment, triggering the test execution and eventually evaluating the result. 


The following image shows the general workflow of how Keptn is automating your tests:

1. Keptn gets triggered by an external event. 

1. Keptn deploys the new version of the application that should be tested. (This is an optional step and can also be skipped if you have already set up this workflow.)

1. Keptn triggers the execution of the tests by having integrations with multiple testing tools. 

1. Keptn fetches the results of the test and service-level indicators (SLIs).

1. Keptn evaluate and score the test execution as well as the service-level indicators (SLIs) based on service-level objectives(SLOs).

1. Finally, the quality evaluation of the tests is then returned as a result back to the user.

  {{< popup_image
  link="./assets/test-automation.png"
  caption="Keptn Test Automation"
  width="700px">}}