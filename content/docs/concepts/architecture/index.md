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

## NATS

During Keptn installation, [NATS](https://nats.io/) is installed into the Kubernetes namespace
where the Keptn Control Plane is installed.
NATS is used to communicate with the Execution Plane as discussed below.

## Keptn CLI

Use the [Keptn CLI](../../0.19.x/reference/cli/) to send commands
that interact with the [Keptn API](../../0.19.x/reference/api/).
It must be [installed](../../install/cli-install)
on the local machine and is used to send commands to Keptn.
To communicate with Keptn, you need to know the API token
which is managed as a shared secret by the [Secret Service](../../0.19.x/operate/secrets).
The shared secret is generated during the installation and verified by the *api* component.

## Keptn Bridge

The *Keptn Bridge* is a user interface that can be used
to view and manage Keptn projects and services.

See [Keptn Bridge](../../0.19.x/bridge/),
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

The [Keptn API](../../0.19.x/reference/api/) provides a REST API
that allows you to communicate with Keptn.
It provides endpoints to authenticate, get metadata about the Keptn installation within the cluster,
forward [CloudEvents](../../0.19.x/reference/miscellaneous/events)
to the NATS cluster, and trigger evaluations for a service.

### mongodb-service

The *mongodb-datastore* stores event data in a MongoDB deployed in your Keptn namespace.
Hence, the service provides the REST endpoint `/events` to query events.
The `mongodb-datastore` and `shipyard-controller` pods
have direct connections to mongodb (keptn-mongo).

### resource-service

The *resource-service* is a Keptn core component
that manages resources for Keptn project-related entities, i.e., project, stage, and service.
This replaces the `configuration-service` that was used in Keptn releases before 0.16.x.
It uses the Git-based [upstream repository](../../0.19.x/manage/git_upstream)
which is mounted as a persistent volume to store the resources with version control,
This service can upload the Git repository to any Git-based service
such as GitLab, GitHub, and Bitbucket.

### shipyard-controller

The *shipyard-controller* manages all Keptn-related entities, such as projects, stages and services,
and provides an HTTP API that is used to perform CRUD operations on them. 
This service also controls the execution of task sequences
that are defined in the project's [shipyard](../../0.19.x/reference/files/shipyard)
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
Those services can be plugged into a task sequence
to extend the delivery pipeline or to further automate operations.
Execution plane services subscribe to events using one of the following mechanisms:

* [distributor](../../0.19.x/reference/miscellaneous/distributor) sidecar
that forwards incoming `.triggered` events to execution plane services.
These distributor sidecars can also be used to send `.started` and `.finished` events
back to the Keptn control plane.
This was the original Keptn mechanism for sending events to services.

* **cp-connector** (Control Plane Connector) uses Go code to handle
the logic of an integration connecting back to the control plane.
This mechanism was introduced in Release 0.15.x and is used by all core Keptn services.
The distributor pod is not required, but it requires more coding in each service.

* [go-sdk](https://github.com/stellar/go/blob/master/docs/reference/readme.md)
-- Provides a wrapper that adds features around the cd-connector.
All newer services and most Keptn internal services use `go-sdk`.

The default Keptn installation includes Keptn-services for some Execution Plane services,including:

- **lighthouse-service:** conducts a quality evaluation based on configured SLOs/SLIs. 

- **approval-service:** implements the automatic quality gate in each stage
  where the approval strategy has been set to `automatic`.
  In other words, it sends an `approval.finished` event which contains information
  about whether a task sequence (such as the artifact delivery) should continue or not.
  If the approval strategy within a stage has been set to `manual`,
  the gatekeeper service does not respond with any event since, in that case,
  the user is responsible for sending an `approval.finished` event
  (using either the [Keptn Bridge](../../0.19.x/bridge/#approvals) or the API).  

- **remediation-service:** determines the action to be performed in remediation workflows. 

- **mongodb-datastore:** stores MongoDB event data that is deployed in the cluster.

You also need a service to create/modify the configuration of a service that is going to be onboarded,
fetch configuration files from the *configuration-service*, and apply the configurations.
In older Keptn releases,
the [helm-service](https://artifacthub.io/packages/helm/keptn/helm-service)
was included in the default Keptn distribution for this purpose
and it is still the most popular solution.

Any of these services can be replaced by a service for another tool
that reacts to and sends the same signals.
See [Keptn and other tools](../keptn-tools) for more information.

Execution plane services can be operated within the same cluster as the Keptn Control Plane
or in a different Kubernetes cluster.
In either case, [NATS](https://nats.io/) is installed into the Kubernetes namespace
where the Keptn Control Plane is installed
to communicate with the Execution Plane.

 - When the Control Plane and Execution Plane are operated within the same cluster,
   the services can directly access the HTTP APIs
   provided by the control plane services, without having to authenticate.
   In this case, the distributor sidecars or `cp-connectors`
   directly connect themselves to the NATS cluster to subscribe to topics and send back events.

 - When an execution plane is operated outside of the Cluster,
   it can communicate with the HTTP API exposed by the `api-gateway-nginx`.
   In this case, each request to the API must be authenticated using `keptn-api-token`. 
   The distributor sidecars and cp-connectors are not able to directly connect to the NATS cluster,
   but they can be configured to fetch open `.triggered` events from the HTTP API.

See [Integrations](../../integrations) for links to Keptn-service integrations that are available.
Use the information in [Custom Integrations](../../0.19.x/integrations)
to create a Keptn-service that integrates other tools.

### Summary of NATS behavior for Keptn on a single cluster

On a single-cluster Keptn instance,
the Keptn control plane and execution plane are both installed on the same cluster
and they communicate using NATS.
Execution plane services have a distributor pod
that subscribes to and publishes events on behalf of the execution plane service.

Environment variables documented
on the [distributor](../../0.19.x/reference/miscellaneous/distributor) reference page
control how the distributor behaves,
including setting the `PUBSUB_URL` environment variable that the distributor uses to locate the NATS cluster.

The flow can be summarized as follows.
Note that this discussion assumes using `helm-service` and tasks like `deployment`
but another service could be used for this processing
and any tool could listen for tasks with names other than those of the standard tasks
that are documented on the [shipyard](../../0.19.x/reference/files/shipyard/#fields) reference page.

1. The distributor for the execution plane services on a control plane
   handles the subscriptions and publishes operations for the execution plane service
   by subscribing to NATS subjects that Keptn creates dynamically.

   For sequence-level events:

   ```
   sh.keptn.event.<stage>-<sequence>.<verb>
   ```

   For example, the control plane might publish the following to the subject:

   ```
   sh.kept.event.dev.delivery.triggered
   sh.keptn.event.deployment.triggered
   ```

   For task-level events:

   ```
   .sh.keptn.event.<task>.<verb>
   ```

   Optionally, the control plain can send one or more events in the form:

   ```
   sh.keptn.<task>.status.changed
   ```
   This is useful to signal status updates during long-running tasks.
 
1. The Helm-Service Distributor (HSD) subscribes to the subject:

   ```
   sh.keptn.event.deployment
   ```
   And receives:

   ```
   sh.keptn.event.deployment.started
   ```
   as well as the JSON event body.

1. HSD triggers the helm-service and publishes to the subject:

   ```
   sh.keptn.event.deployment.started
   ```
   as well as the JSON event body.


1. The helm-service finishes the deployment and the HSD publishes to the subject:

   ```
   sh.keptn.event.deployment.finished
   ```
   as well as the JSON event body.

### Summary of behavior of NATS for Keptn on a multi-cluster instance:

In a [multi-cluster](../../install/multi-cluster) configuration,
an execution plane is a namespace or cluster other than where the control plane runs
that runs a Keptn service.
The distributor was originally designed to work for both the control plane and the remote execution planes
but, for recent releases, most execution plane services use `go-sdk` rather than the distributor.

Services that use `go-sdk` on the execution plane communicate over NATS
but the execution plane distributor polls the NATS subjects using the Keptn API.
It polls the NATS subjects using HTTPS (polling the `/api/v1/event` endpoint) on the control plane.

The following Keptn core services use `go-sdk` and are connected to NATS
using the NATS environment variable `NATS_URL` to determine the URL:
`shipyard-controller`, `remediation-service`, `mongodb-datastore`,
`lighthouse-service`, and `approval-service`.
By default, the value of the `NATS_URL` environment variable
is the same as the value of the distributor's `PUBSUB_URL` environment variable.

Keptn does not currently support a ConfigMap that contains the `NATS_URL`
so it must be set as an environment variable in the Helm chart for each configured service.

The `helm-service` and Job Executor Service (JES) use the distributor's API proxy feature
to communicate with the `resource-service` so any configuration changes must be applied
to the distributor and not the `helm-service` or JES.

