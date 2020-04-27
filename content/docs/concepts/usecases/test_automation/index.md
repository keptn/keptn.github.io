---
title: Test Automation
description: Learn about test automation with Keptn.
weight: 3
keywords: [keptn, use-cases]
---

With Keptn you can automate your tests by having Keptn triggering the test execution and evaluating the result, or even by letting Keptn deploying new versions of your applications to a test environment, triggering the test execution and eventually evaluating the result. 


The following image shows the general workflow of how Keptn is automating your tests. Once Keptn is triggered, it will (1) start to deploy the new version of the application that should be tested. This is an optional step and can also be skipped if you have already set up this workflow. Next (2) Keptn will trigger the execution of the tests by having integrations with multiple testing tools. After the test execution, (4) Keptn fetches the results of the test, as well as service-level indicators to (5) evaluate and score the test execution. 
The quality evaluation of the tests is (6) then returned as a result back to the user.

  {{< popup_image
  link="./assets/test-automation.png"
  caption="Keptn Test Automation"
  width="700px">}}