---
title: Architecture
description: Learn about the architecture, how Keptn works internally, and can be extended.
weight: 90
keywords: [keptn, architecture]
---

Keptn is an event-based control plane for continuous delivery and automated operations that runs on Kubernetes. Keptn itself follows an event-driven approach with the benefits of loosely coupled components and a flexible design that allows easily integrating other components and services. The events that Keptn understands are specified [here](https://github.com/keptn/spec/blob/0.2.0/cloudevents.md) and follow the [CloudEvents](https://cloudevents.io/) specification [v2](https://github.com/cloudevents/spec/tree/v0.2).

{{< popup_image link="./assets/architecture.png" caption="Keptn architecture" width="65%">}}

This event-driven architecture means that Keptn is tool and vendor agnostic.
See [Keptn and other tools](../keptn-tools) for a fuller discussion.

## Prerequisites

During the installation of Keptn, [NATS](https://nats.io/) is installed into the Kubernetes namespace
where the Keptn Control Plane is installed.

## Keptn CLI

Use the [Keptn CLI](../../0.18.x/reference/cli/) to send commands
that interact with the [Keptn API](../../0.18.x/reference/api/).
It must be [installed](../../install/cli-install)
on the local machine and is used to send commands to Keptn.
To communicate with Keptn, you need to know the API token
which is managed as a shared secret by the [Secret Service](../secrets).
The shared secret is generated during the installation and verified by the *api* component.

## Keptn Bridge

The *Keptn Bridge* is a user interface that can be used
to view and manage Keptn projects and services.

See [Keptn Bridge](../../0.18.x/bridge/),
for information about how to access and use the Keptn Bridge.

## Keptn Control Plane

The Keptn Control Plane runs the basic components that are required
to run Keptn and to manage projects, stages, and services.
This includes handling events and providing integration points.
It orchestrates the task sequences that are defined in the *shipyard*
but does not actively execute the tasks.

### api-gateway-nginx

The *api-gateway-nginx* component is the single point used for exposing Keptn to the outside world.
It supports the four [access options](../../install/access) that Kubernetes supports:
LoadBalancer, NodePort, Ingress, and Port-Forward.

It also redirects incoming requests to the appropriate internal Keptn endpoints --
api, bridge, or resource-service.

### api-service

The [Keptn API](../../0.18.x/reference/api/) provides a REST API
that allows you to communicate with Keptn.
It provides endpoints to authenticate, get metadata about the Keptn installation within the cluster,
forward CloudEvents to the NATS cluster, and triggering evaluations for a service.

The documentation shows you how to access the API and to explore the available endpoints.

### mongodb-service

The *mongodb-datastore* stores event data in a MongoDB deployed in your Keptn namespace.
Hence, the service provides the REST endpoint `/events` to query events.

### resource-service

The *resource-service* is a Keptn core component
that manages resources for Keptn project-related entities, i.e., project, stage, and service.
This replaces the `configuration-service` that was used in Keptn releases before 0.16.x.
It uses the Git-based [upstream repository](../../0.18.x/manage/git_upstream)/ mounted as a persistent volume
to store the resources with version control,
This service can upload the Git repository to any Git-based service
such as GitLab, GitHub, and Bitbucket.

### shipyard-controller

The *shipyard-controller* manages all Keptn-related entities, such as projects, stages and services,
and provides an HTTP API that is used to perform CRUD operations on them. 
This service also controls the execution of task sequences
that are defined in the project's [shipyard](../../0.18.x/reference/files/shipyard)
by sending out `.triggered` events whenever a task within a task sequence should be executed. 
It then listens for incoming `.started` and `.finished` events
and uses them to proceed with the task sequence.

## Execution Plane Services

The Keptn Execution Plane hosts the Keptn-services
that integrate the tools that are used to process the tasks.
The Keptn cluster can contain a single Execution Plane
that is installed either in the same Kubernetes cluster as the Control Plane
or in a different Kubernetes cluster..
You can also configure multiple Execution Planes on multiple Kubernetes clusters.

Keptn-services react to `.triggered` Keptn events that are sent by the shipyard controller.
They perform continuous delivery tasks like deploying or promoting a service
and orchestrational tasks for automating operations.
Those services can be easily plugged into a task sequence
to extend the delivery pipeline or to further automate operations.
Execution plane services subscribe to events using one of the following mechanisms:

* [distributor](../../0.18.x/reference/miscellaneous/distributor) sidecar
that forwards incoming `.triggered` events to execution plane services.
These distributor sidecars can also be used to send `.started` and `.finished` events
back to the Keptn control plane.
This was the original Keptn mechanism for sending events to services.

* **cp-connector** (Control Plane Connector) uses Go code to handle
the logic of an integration connecting back to the control plane.
This mechanism was introduced in Release 0.15.x and is used by all core Keptn services.
The distributor pod is not required, but it requires more coding in each service.

* **go-sdk** (experimental) -- Provides a wrapper that adds features around the cd-connector.

The default Keptn installation includes Keptn-services for some Execution Plane services,including:

- **helm-service:** creates/modifies the configuration of a service that is going to be onboarded
  and fetches configuration files from the *configuration-service* and applies those using Helm.

- **lighthouse-service:** conducts a quality evaluation based on configured SLOs/SLIs. 

- **approval-service:** implements the automatic quality gate in each stage
  where the approval strategy has been set to `automatic`.
  In other words, it sends an `approval.finished` event which contains information
  about whether a task sequence (such as the artifact delivery) should continue or not.
  If the approval strategy within a stage has been set to `manual`,
  the gatekeeper service does not respond with any event since, in that case,
  the user is responsible for sending an `approval.finished` event (either via the Bridge or via the API).  

- **remediation-service:** determines the action to be performed in remediation workflows. 

Any of these services can be replaced by a service for another tool
that reacts to and sends the same signals.
See [Keptn and other tools](../keptn-tools) for more information.

As illustrated in the architecture diagram above,
execution plane services can be operated within the same cluster as the Keptn Control Plane
or in a different Kubernetes cluster.

 - When they are operated within the same cluster, the services can directly access the HTTP APIs
   provided by the control plane services, without having to authenticate.
   In this case, the distributor sidecars directly connect themselves to the NATS cluster
   to subscribe to topics and send back events.

 - When an execution plane is operated outside of the Cluster,
   it can communicate with the HTTP API exposed by the `api-gateway-nginx`.
   In this case, every request to the API must be authenticated using the `keptn-api` token. 
   The distributor sidecars are not able to directly connect to the NATS cluster,
   but they can be configured to fetch open `.triggered` events from the HTTP API.

See [Integrations](../../integrations) for links to Keptn-service integrations that are available.
Use the information in [Custom Integrations](../../0.18.x/integrations)
to create a Keptn-service that integrates other tools.
