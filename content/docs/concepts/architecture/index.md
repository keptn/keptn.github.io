---
title: Architecture
description: Learn about the architecture, how Keptn works internally, and can be extended.
weight: 90
keywords: [keptn, architecture]
---

Keptn is an event-based control plane for continuous delivery and automated operations that runs on Kubernetes. Keptn itself follows an event-driven approach with the benefits of loosely coupled components and a flexible design that allows easily integrating other components and services. The events that Keptn understands are specified [here](https://github.com/keptn/spec/blob/0.2.0/cloudevents.md) and follow the [CloudEvents](https://cloudevents.io/) specification [v2](https://github.com/cloudevents/spec/tree/v0.2).

{{< popup_image link="./assets/architecture.png" caption="Keptn architecture" width="65%">}}

## Prerequisites

During the installation of Keptn, [NATS](https://nats.io/) is installed into the Kubernetes namespace where Keptn is installed.

## Keptn CLI
The Keptn CLI needs to be installed on the local machine and is used to send commands to Keptn by interacting with the API of Keptn. To communicate with Keptn you need to know a shared secret that is generated during the installation and verified by the *api* component.

**Note:** A dedicated Keptn CLI section is provided [here](../../0.14.x/reference/cli/), which helps you to get started and lists all available commands.

## Keptn Bridge

The *Keptn Bridge* provides a user interface that shows all Keptn-managed projects and services. Besides, it gives an overview of the staging environment. 

**Note:** A dedicated section for the Keptn Bridge is provided [here](../../0.13.x/reference/bridge/), which explains how to access it and shows the user interface.

## Keptn Control Plane

Keptn has several core components that are set up during the installation.

### api-gateway-nginx

The *api-gateway-nginx* component is the single point used for exposing Keptn to the outside world. Besides, it is responsible to redirect incoming requests to the right internal Keptn endpoints, e.g., to api, bridge, or configuration-service.

### api-service

The *api* component provides a REST API that allows communicating with Keptn. It provides endpoints to authenticate, get metadata about the Keptn installation within the cluster, forwarding CloudEvents to the NATS cluster, and triggering evaluations for a service.

**Note:** A dedicated Keptn API section is provided [here](../../0.13.x/reference/api/), which helps you to access the API and to explore the available endpoints.

### mongodb-service

The *mongodb-datastore* provides means to store event data in a MongoDB deployed in your Keptn namespace. Hence, the service provides the REST endpoint `/events` to query events.

### configuration-service

The *configuration-service* is a Keptn core component and used to manage resources for Keptn project-related entities, i.e., project, stage, and service. To store the resources with version control, a Git repository is used that is mounted as a persistent volume. Besides, this service has the functionality to upload the Git repository to any Git-based service such as GitLab, GitHub, Bitbucket, etc.

### shipyard-controller

The *shipyard-controller* is responsible for managing all Keptn-related entities, such as projects, stages and services and provides an HTTP API that allows to perform CRUD operations on them. 
Another responsibility of this service is the control of task sequences defined in the shipyard file of a project by sending out `.triggered` events whenever a task within a task sequence should be executed. 
It will then listen for incoming `.started` and `.finished` events and use them to proceed within the task sequence.

## Execution Plane Services

To enrich the continuous delivery use case or to build automated operations, Keptn relies on services from the community. Those services can be easily plugged into a task sequence to extend the delivery pipeline or to further automate operations.

This category of services reacts on `.triggered` Keptn events sent by the shipyard controller and perform: (1) continuous delivery tasks like deploying or promoting a service, and (2) orchestrational tasks for automating operations.

Here are some examples of execution plane services:

- **helm-service:** It has two responsibilities: (1) creates/modifies the configuration of a service that is going to be onboarded, and (2) fetches configuration files from the *configuration-service* and applies those using Helm. The current Helm version used by this service is Helm v3.1.2. 

- **lighthouse-service:** It is responsible for conducting a quality evaluation based on configured SLOs/SLIs. 

- **approval-service:** It implements the automatic quality gate in each stage where the approval strategy has been set to `automatic`, i.e., it will send an `approval.finished` event which contains the information about whether a task sequence (e.g. the artifact delivery) should continue or not. If the approval strategy within a stage has been set to `manual`, the gatekeeper service will not respond with any event since in that case the user is responsible for sending an `approval.finished` event (either via the Bridge or via the API).  

- **remediation-service:** It is used to determine the action to be performed in remediation workflows. 

Execution plane services subscribe to events via a distributor sidecar, that forwards incoming `.triggered` events to them. These distributor sidecars can also be used to send `.started` and `.finished` events back to the Keptn control plane.

As illustrated in the architecture diagram above, execution plane services can both be operated within the same cluster as Keptn, or outside of the cluster. 

 - When they are operated within the same cluster, the services can directly access the HTTP APIs provided by the control plane services,
without having to authenticate. In this case, the distributor sidecars directly connect themselves to the NATS cluster to subscribe to topics and send back events.

- When an execution plane is operated outside of the Cluster, it has the possibility to communicate with the HTTP API exposed by the `api-gateway-nginx`. In this case, every request to the API has to be authenticated using the `keptn-api` token. 
Also, the distributor sidecars do not have the possibility to directly connect to the NATS cluster, but they can be configured to fetch open `.triggered` events from the HTTP API.

To read more about developing execution plane services, please refer to the following section in the docs: [Write a Keptn-service](../../0.13.x/integrations/custom_integration/), which helps you to implement a custom service for Keptn. 
