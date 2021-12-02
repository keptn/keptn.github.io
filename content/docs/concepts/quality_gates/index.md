---
title: Quality Gates
description: Learn about the Keptn Quality Gates.
weight: 2
keywords: [keptn, use-cases]
---

> When developing a software product, sooner than later you need to deliver a new deployment of your service in a production environment. To conduct this in a controlled manner and without impacting end-user experience, the quality of the new service has to be ensured in an automated way. 

:bulb: *A quality gate allows conducting a deployment/release validation by ensuring that defined quality criteria are met.*

Keptn quality gates provide you a *declarative way* to define the quality criteria of your service. Therefore, Keptn will collect, evaluate, and score those quality criteria to decide if a new deployment or release is allowed to be promoted to the next stage or if it has to be held back.

## Keptn Quality Gate Process

Keptn quality gates base on the concepts of *Service-Level Indicators (SLIs)* and *Service-Level Objectives (SLOs)*. Therefore, it is possible to declaratively describe the desired quality objective for your applications and services.

1. The process of evaluating a quality gate can be triggered either via the Keptn CLI or the Keptn API. 
1. Once triggered, Keptn fetches the SLIs from a data provider like [Prometheus or Dynatrace](../../0.8.x/quality_gates/sli-provider/). 
1. Keptn evaluates the SLI against the SLOs that are defined for the application or service. 
1. After evaluation and scoring, Keptn returns the result that can be either processed in an automated way by an existing CD pipeline or by the user to manually decide on the next steps (e.g., promotion to production or pushing it back to the developer for needed improvements).

  {{< popup_image
  link="./assets/quality-gates.png"
  caption="Keptn Quality Gates Process"
  width="700px">}}

## What is a Service-Level Indicator (SLI)?

A service-level indicator is a *"carefully defined quantitative measure of some aspect of the level of service that is provided"* (as defined in the [Site-Reliability Engineering Book](https://landing.google.com/sre/sre-book/chapters/service-level-objectives/)). 

An example of an SLI is the *response time* (also named request latency), which is the indicator of how long it takes for a request to respond with an answer. Other prominent SLIs are *error rate* (or failure rate), and throughput. Keptn defines all SLIs in a dedicated `sli.yaml` file to make SLIs reusable within several quality gates. To learn more about the SLI configuration, please continue [here](../../0.8.x/quality_gates/sli/). 

## What is a Service-Level Objective (SLO)?

A service-level objective is *"a target value or range of values for a service level that is measured by an SLI."* (as defined in the [Site-Reliability Engineering Book](https://landing.google.com/sre/sre-book/chapters/service-level-objectives/)). 

An example of an SLO can define that a specific request must return results within 100 milliseconds. Keptn quality gates can comprise several SLOs that are all evaluated and scored, based even on different weights for each SLO to consider different importance of each SLO. Keptn defines SLOs in a dedicated `slo.yaml`. To learn more about the SLO configuration, please continue [here](../../0.8.x/quality_gates/slo/). 

## References

- [Implementing SLI/SLO based Continuous Delivery Quality Gates using Prometheus](https://medium.com/keptn/implementing-sli-slo-based-continuous-delivery-quality-gates-using-prometheus-9e17ec18ca36?source=friends_link&sk=22e163eb22df2d4a3c8e49d5e06d3802)
- [Automating deployment validation with quality gates](https://medium.com/keptn/automating-deployment-validation-with-quality-gates-71889845e2ca)
