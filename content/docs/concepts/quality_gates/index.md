---
title: Quality Gates
description: Learn about the Keptn Quality Gates.
weight: 2
keywords: [keptn, use-cases]
---

> When developing a software product, you eventually need to deliver a new version of your service in a production environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured in an automated way. 

:bulb: *A quality gate allows conducting a deployment/release validation by ensuring that defined quality criteria are met.*

Keptn quality gates provide you a *declarative way* to define quality criteria of your service. Therefore, Keptn will collect, evaluate, and score those quality criteria to decide if a new release is allowed to be promoted to the next stage or if it has to be held back.

## Keptn Quality Gate Process

Keptn quality gates base on the concepts of *Service-Level Indicators (SLIs)* and *Service-Level Objectives (SLOs)*. Therefore, it is possible to declaratively describe the desired quality objective for your applications and services.

1. The process of evaluating a quality gate can be triggered either via the Keptn CLI or the Keptn API. 
1. Once triggered, Keptn fetches the SLIs from a data provider like [Prometheus or Dynatrace](../../0.15.x/quality_gates/sli-provider/). 
1. Keptn evaluates the SLI against the SLOs that are defined for the application or service. 
1. After evaluation and scoring, Keptn returns the result that can be either processed in an automated way by an existing CD pipeline or by the user to manually decide on the next steps (e.g., promotion to production or pushing it back to the developer for needed improvements).

  {{< popup_image
  link="./assets/quality-gates.png"
  caption="Keptn Quality Gates Process"
  width="700px">}}

## What is a Service-Level Indicator (SLI)?

A service-level indicator is a *"carefully defined quantitative measure of some aspect of the level of service that is provided"* (as defined in the [Site-Reliability Engineering Book](https://landing.google.com/sre/sre-book/chapters/service-level-objectives/)). 

An example of an SLI is the *response time* (also named request latency), which is the indicator of how long it takes for a request to respond with an answer. Other prominent SLIs are *error rate* (or failure rate), and throughput. Keptn defines all SLIs in a dedicated [sli.yaml](../../0.15.x/reference/files/sli/)  file to make SLIs reusable within several quality gates.

## What is a Service-Level Objective (SLO)?

A service-level objective is *"a target value or range of values for a service level that is measured by an SLI."* (as defined in the [Site-Reliability Engineering Book](https://landing.google.com/sre/sre-book/chapters/service-level-objectives/)). 

An example of an SLO can define that a specific request must return results within 100 milliseconds. Keptn quality gates can comprise several SLOs that are all evaluated and scored, based even on different weights for each SLO to consider different importance of each SLO. Keptn defines SLOs in a dedicated [slo.yaml](../../0.15.x/reference/files/slo/) file.


## Quality gate result on the Keptn Bridge

:bulb: *A quality gate answers one question: Does my service meet all defined quality criteria?*

Keptn quality gates help you answer this question by representing
quality gate results on the [Keptn Bridge](../0.18.x/bridge) like this:

<!--TODO: Change image and add annotations [1] ... [5] -->

{{< popup_image
  link="./assets/quality_gate_results.png"
  caption="Quality gate result"
  width="90%">}}

This visualization in the Keptn Bridge allows you to answer the following questions:

* First and most important, *does the service meet all defined quality criteria*?
  * :one: Here, the overall result is a *warning* as shown by the orange bar and with the total score between 50 (fail) and 90 (pass) points.
* Which criteria did not meet its objective?
  * :two: The *response time P95* was measured with 1048 ms. This value is higher than the pass criteria set at 600 ms.
* What does the <=10% mean?
  * :three: This is a relative comparison for which the quality gate result of a previous evaluation is taken into account. In fact, the last passed comparison is taken as a reference value.
* How did this quality result perform compared to others?
  * :four: The answer to this question can be found in the Heatmap and Chart on the top.
  * The Heatmap highlights the currently selected quality gate result with a gray and solid border. The quality gate result that is taken into comparison is highlighted by the dashed border.
  * :five: The total score of a quality gate result is depicted by the cell on the top.
  * The individual criteria are represented by a separate cell in the column.

## References

- [Implementing SLI/SLO based Continuous Delivery Quality Gates using Prometheus](https://medium.com/keptn/implementing-sli-slo-based-continuous-delivery-quality-gates-using-prometheus-9e17ec18ca36?source=friends_link&sk=22e163eb22df2d4a3c8e49d5e06d3802)
- [Automating deployment validation with quality gates](https://medium.com/keptn/automating-deployment-validation-with-quality-gates-71889845e2ca)
