---
title: Orchestrate security checks
description: How Keptn can orchestrate security checks
weight: 215
---

Keptn can orchestrate checks of the security of your application
just as it orchestrates checks of the functionality and performance of your application.
This [DevSecOps by Default](https://www.youtube.com/watch?v=kRVUEYPua4A&t=13210s) video
discusses how the Log4Shell security vulnerability discovered in December 2021 was handled,
describes a strategy for managing a new vulnerability that is identified,
then describes how Keptn can orchestrate the evaluation of security vulnerabilies.

Keptn security checks work with observability tools that evaluate your code
and provide data as Service Level Indicators (SLIs).
Those SLI metrics are defined for Keptn in the [sli.yaml](../../reference/files/sli) file.
You then define the corresponding Service Level Objectives (SLOs)
to reflect your criteria for the system's health
in the [slo.yaml](../../reference/files/slo) file.
Keptn runs [quality gates](../quality-gates) that grade each objective and calculate the total score
and then reports this analysis.
Keptn can also implement [remediation](../remediation-sequence) steps that are appropriate
to handle any issues that it finds
in either software that is about to be published
or on the site that is running your application in production.
