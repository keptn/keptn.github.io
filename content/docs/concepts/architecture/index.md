---
title: Architecture
description: Learn about the architecture, how Keptn works internally, and can be extended.
weight: 90
keywords: [keptn, architecture]
---

Keptn is an event-based control plane for continuous delivery and automated operations that runs on Kubernetes. Keptn itself follows an event-driven approach with the benefits of loosely coupled components and a flexible design that allows easily integrating other components and services. The events that Keptn understands are specified [here](https://github.com/keptn/spec/blob/0.1.3/cloudevents.md) and follow the [CloudEvents](https://cloudevents.io/) specification [v2](https://github.com/cloudevents/spec/tree/v0.2).

{{< popup_image link="./assets/architecture.png" caption="Keptn architecture" width="65%">}}

## Prerequisites

During a Keptn installation, [NATS](https://nats.io/) is installed in the Kubernetes namespace Keptn is running.

## Keptn CLI
The Keptn CLI needs to be installed on the local machine and is used to send commands to Keptn by interacting with the API of Keptn. To communicate with Keptn you need to know a shared secret that is generated during the installation and verified by the *api* component.

**Note:** A dedicated Keptn CLI section is provided [here](../../0.7.x/reference/cli/), which helps you to get started and lists all available commands.

## Keptn Bridge

The *Keptn Bridge* provides a user interface that shows all Keptn-managed projects and services. Besides, it gives an overview of the staging environment. 

**Note:** A dedicated section for the Keptn Bridge is provided [here](../../0.7.x/reference/bridge/), which explains how to access it and shows the user interface.

## Keptn Control Plane

Keptn has several core components that are set up during the installation.

### api-gateway-nginx

The *api-gateway-nginx* component is the single point used for exposing Keptn to the outside world. Besides, it is responsible to redirect incoming requests to the right internal Keptn endpoints, e.g., to api, bridge, or configuration-service.

### api-service

The *api* component provides a REST API that allows communicating with Keptn. It receives the commands from the CLI and executes the requested tasks. However, the api component mostly uses other internal services or forwards events to the *eventbroker*. In addition to the REST API, the api component maintains a websocket server to forward Keptn messages to the *Keptn CLI*.

**Note:** A dedicated Keptn API section is provided [here](../../0.7.x/reference/api/), which helps you to access the API and to explore the available endpoints.

### eventbroker-service

The *eventbroker* is responsible for receiving all events and sending those to NATS.

### mongodb-service

The *mongodb-datastore* provides means to store event data in a MongoDB deployed in your Keptn namespace. Hence, the service provides the REST endpoint `/events` to query events.

### configuration-service

The *configuration-service* is a Keptn core component and used to manage resources for Keptn project-related entities, i.e., project, stage, and service. To store the resources with version control, a Git repository is used that is mounted as a persistent volume. Besides, this service has the functionality to upload the Git repository to any Git-based service such as GitLab, GitHub, Bitbucket, etc.

### Control Plane related Services

This category of services reacts on Keptn events and perform: (1) initial tasks like creating a project or creating a service, (2) continuous delivery tasks like deploying or promoting a service, and (3) orchestrational tasks for automating operations.

- **shipyard-service:** It is responsible for creating a project and processing a shipyard file that defines the stages each deployment has to go through until it is released to end-users.

- **helm-service:** It has two responsibilities: (1) creates/modifies the configuration of a service that is going to be onboarded, and (2) fetches configuration files from the *configuration-service* and applies those using Helm. The current Helm version used by this service is Helm v3.1.2. 

- **lighthouse-service:** It is responsible for conducting a quality evaluation based on configured SLOs/SLIs. 

- **gatekeeper-service:** It implements the quality gate in each stage, i.e., depending on the evaluation result it either promotes an artifact to the next stage or not.

- **remediation-service:** It is used to orchestrate remediation workflows. 

## Keptn services

To enrich the continuous delivery use case or to build automated operations, Keptn relies on services from the community. Those services can be easily plugged into a task sequence to extend the delivery pipeline or to further automate operations.

**Note:** A dedicated how-to guide is provided [here](../../0.7.x/integrations/custom_integration/), which helps you to implement a custom service for Keptn.