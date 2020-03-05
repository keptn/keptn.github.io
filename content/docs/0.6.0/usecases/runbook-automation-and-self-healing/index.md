---
title: Runbook Automation
description: Gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use automation tools for executing and managing the runbooks.
weight: 45
keywords: [self-healing]
aliases:
---

Gives an overview of how to leverage the power of runbook automation to build self-healing applications. Therefore, you will use ServiceNow workflows that are triggered to remediate incidents.

## About this tutorial

Configuration changes during runtime are sometimes necessary to increase flexibility. A prominent example is feature flags that can be toggled also in a production environment. In this tutorial, we will change the promotion rate of a shopping cart service, which means that a defined percentage of interactions with the shopping cart will add promotional items (e.g., small gifts) to the shopping carts of our customers. However, we will experience troubles with this configuration change. Therefore, we will set means in place that are capable of auto-remediating issues at runtime. In fact, we will leverage workflows in ServiceNow. 

NOTE: This is an externally contributed use case and is documented and maintained in the [servicenow-service repository](https://github.com/keptn-contrib/servicenow-service/tree/0.2.0).
You can find the instructions [here](https://github.com/keptn-contrib/servicenow-service/tree/0.2.0/usecase)
