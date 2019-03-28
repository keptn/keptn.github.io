---
title: Unbreakable Delivery Pipeline
description: Reviews and consolidates the concepts of a delivery pipeline that prevents bad code changes from impacting your end users.
weight: 20
keywords: [self-healing, quality gates]
aliases:
---

This use case reviews and consolidates the concepts of a delivery pipeline that prevents bad code changes from impacting your end users.

## Understanding the Unbreakable Delivery Pipeline

The goal of the *Unbreakable Delivery Pipeline* is to implement a pipeline that prevents bad code changes from impacting your end users. This pipeline relies on three concepts known as Shift-Left, Shift-Right, and Self-Healing. More precisely,

* **Shift-Left** is the ability to pull data for specific entities (processes, services, or applications) through an automation API and feed it into the tools that are used to decide on whether to stop the pipeline or keep it running,

* **Shift-Right** is the ability to push deployment information and metadata to your monitoring solution (e.g., to differentiate BLUE vs GREEN deployments), to push build or revision numbers of a deployment, or to notify about configuration changes,

* **Self-Healing** is the ability for smart auto-remediation that addresses the root cause of a problem and not the symptom.

We exactly used these three concepts in our use cases:

1. [Production Deployments](../production-deployments/index.md): In this use case, the configuration of the *carts* service
has been changed, which intentionally slowed down this service.  Next, this service has been deployed to the development environment.
Although the service has passed the quality gates in the development environment, the service has not passed the quality gate in the staging environment due to the increase of the response time detected by a performance test. This demonstrates an early break of the delivery pipeline based on automated quality gates. Hence, exploiting the concepts of **Shift-Left**, this pipeline has been stopped.
Additionally, the used pipelines for deploying, testing and evaluating have pushed information to our monitoring solution (in this case study Dynatrace was used). This information can be used in following steps and, by this, provides the basis for **Shift-Rigt**.
Summarizing, the pipeline stopped due to a (here intentionally introduced) failure in a service. This was early enough to not deploy this faulty service version into production.

1. [Runbook Automation and Self-healing](../runbook-automation-and-self-healing/index.md): This use case 
has leveraged the power of runbook automation to build **Self-Healing** applications. 
In this use case, a configuration change in the production environment triggered troubles,
which Dynatrace detected and created a problem ticket.
Due to this problem ticket and a corresponding notification, keptn was informed. 
Subsequently, keptn forwarded this problem to ServiceNow, which created an incident.
This incident triggered a workflow that was able to remediate the issue at runtime and, by this, the
application was healed.
Summarizing, a ServiceNow workflow was triggered to remediate an incident and, by this, the service was healed.