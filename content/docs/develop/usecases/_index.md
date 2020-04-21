---
title: Tutorials
description: Explore the functionalities of Keptn based on examples.
weight: 30
url: /docs/develop/usecases/
icon: tasks
---
## Quicklinks

The above list of tutorials helps you to explore the functionalities of Keptn based on examples.

* As a **Developer** you might be most interested in:
  * [Onboarding a Service](./onboard-carts-service/)
  * [Deployments with Quality Gates](./deployments-with-quality-gates/)
  * [Quality Gates for external Deployments](./quality-gates/)

* As a **DevOps Engineer** you might be most interested in:
  * [Write your Keptn Service](./custom-service/)

* As a **Site Reliability Engineer** you might be most interested in:
  * [Self-healing with Keptn](./self-healing-with-keptn/)
  * [Runbook Automation](./runbook-automation-and-self-healing/)

## Application and environment

In these tutorials, a very simple application is used that provides the functionalities for an online shopping cart. This application is composed of a stateless Java service that implements the business logic and a MongoDB that stores items added to the cart by an end-user. The following image show the architecture of the application:

{{< popup_image
  link="./assets/carts-app.png"
  caption="Example application"
  width="30%">}}

In context of the tutorials, this application will be maintained as part of the project sockshop. Besides, the application will be deployed in three stages:

* **Dev stage**: A developer can test the implementation of a new feature in this stage.
* **Staging stage**: Performance test are conducted to verify the stability of the application.
* **Production stage**: An end-user of the application will access the version deployed in this stage. 

