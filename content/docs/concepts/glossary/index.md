---
title: Glossary
description: Terms which are introduced and used in Keptn
weight: 100
keywords: [keptn, glossary]
---

Keptn allows building scalable automation for delivery and operations. Therefore, Keptn introduces and uses the following terms.

## General Terms

**Keptn:** Keptn, pronounced *captain*, is the name of this CNCF project. It is a control-plane for cloud-native application life-cycle orchestration. It is written with capital *K* followed by lower-case letters.

**Project:** A project is a structural element to maintain multiple services forming an application in stages.

**Project stage:** A project stage (or just *stage*) defines a logical space (e.g., a namespace in Kubernetes), which has a dedicated purpose for an application in a continuous delivery process. Typically a project has multiple project stages that are ordered.

**Service:** A service is the smallest deployable unit and is deployed in all project stages according to the order. Each service in a project follows the same task sequences.

**Shipyard:** A shipyard is the declarative means to divide an environment (e.g., Kubernetes cluster) into project stages and to specify task sequences for each project stage.

**Sequence:** A sequence declares a set of tasks for realizing a delivery or operations process. A task sequence is triggered by an external event, i.e., by a *domain event*. Examples for domain events are the availability of a new artifact which should be deployed (i.e., a `new-artifact` event) or the occurrencece of a problem (i.e., a `problem` event).

**Task:** A task is the smallest executable unit of a sequence. A task is triggered by an event. 

**Keptn-service:** A Keptn-service is the unit executing a task. It can be responsible for executing one or many tasks and is is triggered by an event of a task.

**Uniform:** The uniform declares a list of Keptn-services that represents the execution plane of a Keptn installation and are required to execute the respective tasks. (*Note:* Currently, Keptn provides two hard-coded execution planes: (1) full - containing Keptn-services for delivery and automated operations use cases and (2) quality gates only.) 

**Event:** An event triggers a task and contains relevant data for the respective task.

**Keptn installation:** A Keptn installation encloses the control plan and execution plane. 

**Control plane:** The control plane is the minimum set of components, which are required to run a Keptn and to manage projects, stages, and services, to handle events, and to provide integration points. 

**Execution plane:** The execution plane consists of all Keptn-services that are required to process all tasks. 

### Supported Tasks in Continuous/Progressive Delivery

**Deployment:** The *deployment* makes a built artifact (e.g., a Docker image) available for use as a service in a project stage. 

**Test:** The *test* executes a set of tests (e.g., requests) against the service. The test kind (e.g., functional or performance) can be derived from the purpose of the project stage or environment. 

**Evaluation:** The *evaluation* represents the quality gate of a stage by checking the SLO. 

### Supported Tasks in Continuous Operation

**Remediation:** A remediation is an action, which is executed when a problem was detected, e.g., by the monitoring solution. The remediation action should solve the problem in an automatic way.

### Quality Gate
The quality gate is a concept that allows defining SLOs, which are determined by one or many SLIs. [Source](https://landing.google.com/sre/sre-book/chapters/service-level-objectives/) 

**Service-Level Indicator (SLI):** An SLI is a service-level indicator, which is a defined quantitative measure of some metric of the service.

**Service-Level Objective (SLO):** An SLO is a service-level objective, which is a target value or range of values for an SLI. A common structure for SLOs is: *SLI ≤ target value*, or *lower bound ≤ SLI ≤ upper bound*. 

**Service-Level Agreement (SLA):** An SLA is a service-level agreement, which is an explicit or implicit contract with your users that includes consequences of meeting (or missing) the SLOs the SLA contains.
