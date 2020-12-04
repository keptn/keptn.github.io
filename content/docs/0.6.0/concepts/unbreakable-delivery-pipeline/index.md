---
title: Unbreakable Delivery Pipeline
description: Reviews and consolidates the concepts of a continuous delivery pipeline that prevents bad code changes from impacting end users.
weight: 50
keywords: [0.6.x-self-healing, 0.6.x-quality-gates]
aliases:
---

 The goal of the *Unbreakable Delivery Pipeline* is to implement a pipeline that prevents bad code changes from impacting your end users. This pipeline relies on three concepts known as Shift-Left, Shift-Right, and Self-Healing. More precisely,

* **Shift-Left** is the ability to pull data for specific entities (processes, services, or applications) through an automation API and feed it into the tools that are used to decide on whether to stop the pipeline or keep it running,

* **Shift-Right** is the ability to push deployment information and metadata to your monitoring solution (e.g., to differentiate BLUE vs GREEN deployments), to push build or revision numbers of a deployment, or to notify about configuration changes,

* **Self-Healing** is the ability for smart auto-remediation that addresses the root cause of a problem and not the symptom.

Exactly these three concepts have been applied in the tutorials:

1. [Deployments with Quality Gates](../../usecases/deployments-with-quality-gates/): 
    In this particular tutorial, the *carts* service has been changed, which intentionally slowed down the execution of the *addToCarts* function. After changing the service, it has been deployed to the development environment. Although the service has passed the quality gates (functional checks) in the development environment, the service has not passed the quality gate in the staging environment due to the increase of the response time detected by a performance test. This demonstrates an early break of the delivery pipeline based on automated quality gates. Hence, exploiting the concepts of **Shift-Left**, the delivery pipeline has been stopped and immediate feedback to the development team can be provided.

    Additionally, the used pipelines for deploying, testing, and evaluating have pushed information to our monitoring solution (Dynatrace in this case). This information can be used in following steps and provides the basis for **Shift-Right**. Summarizing, the pipeline stopped due to a - intentionally introduced - failure in a service. This was early enough to not deploy this faulty service version into production.

1. [Self-healing with Keptn](../../usecases/self-healing-with-keptn/): 
    This tutorial has leveraged the power a remediation service to build **Self-healing** applications. Thus, a configuration change in the production environment caused troubles that were detected by Dynatrace, which then created a problem ticket. Due to this problem ticket and a corresponding notification, Keptn became aware of it. Subsequently, Keptn forwarded this problem to a remediation service, which triggers a remediation action. This action triggered a workflow that was able to remediate the issue at runtime and healed the application.