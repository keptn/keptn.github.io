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
which is managed as a shared secret by the [Secret Service](../../0.18.x/operate/secrets).
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

- **lighthouse-service:** conducts a quality evaluation based on configured SLOs/SLIs. 

- **approval-service:** implements the automatic quality gate in each stage
  where the approval strategy has been set to `automatic`.
  In other words, it sends an `approval.finished` event which contains information
  about whether a task sequence (such as the artifact delivery) should continue or not.
  If the approval strategy within a stage has been set to `manual`,
  the gatekeeper service does not respond with any event since, in that case,
  the user is responsible for sending an `approval.finished` event (either via the Bridge or via the API).  

- **remediation-service:** determines the action to be performed in remediation workflows. 

You also need a service to create/modify the configuration of a service that is going to be onboarded,
fetch configuration files from the *configuration-service*, and apply the configurations.
In older Keptn releases,
the [helm-service](https://artifacthub.io/packages/helm/keptn/helm-service)
was included in the default Keptn distribution for this purpose
and it is still the most popular solution.

Any of these services can be replaced by a service for another tool
that reacts to and sends the same signals.
See [Keptn and other tools](../keptn-tools) for more information.

As illustrated in the architecture diagram above,
execution plane services can be operated within the same cluster as the Keptn Control Plane
or in a different Kubernetes cluster.

 - When they are operated within the same cluster, the services can directly access the HTTP APIs
   provided by the control plane services, without having to authenticate.
   In this case, the distributor sidecars or `cp-connectors`
   directly connect themselves to the NATS cluster to subscribe to topics and send back events.

 - When an execution plane is operated outside of the Cluster,
   it can communicate with the HTTP API exposed by the `api-gateway-nginx`.
   In this case, every request to the API must be authenticated using the `keptn-api` token. 
   The distributor sidecars and cp-connectors are not able to directly connect to the NATS cluster,
   but they can be configured to fetch open `.triggered` events from the HTTP API.

See [Integrations](../../integrations) for links to Keptn-service integrations that are available.
Use the information in [Custom Integrations](../../0.18.x/integrations)
to create a Keptn-service that integrates other tools.

## Deep dive into NATS and multi-cluster

Starter questions:

1. Can the execution plane services use existing NATS rather than the control plane NATS?
   Answer: Remote execution plane services communicate vit HTTPS, not NATS.
   But can the execution plane services use the existing NATS
   for a single-cluster instance?
1. How does one set NATS configuration environment variables for control plane services?
   Answer: The only NATS environment variable is `NAT_URL`,
   which is hard-coded into the Helm chart for `helm-service`.
   By default, it is set to the same value as the distributor's `PUBSUB_URL` environment variable
   and used for control plane services implemented with `go-sdk` rather than `helm-service`.
   Alternate values can be set for both parameters for each individual service.
1. Does metadata aware execution work for all execution plane services?
   See [JES Issue 363](https://github.com/keptn-contrib/job-executor-service/issues/363)
1. When the Keptn API polls the NATS subjects
   using HTTPS (polling `/api/v1/event` endpoint on the control plane,
   does a "translation" happen or does the HTTPS just poll the datastore for matching events?
1. Are solutions that use JES/Webhooks to integrate tools and `go-sdk` for event handling
   as scalable as dedicated services and NATS?
   Note that Keptn is not moving away from NATS but is offering alternate ways
   for external tools to connect to NATS and the control plane.
1. How is NATS authentication handled?  How would it be configured if using the Outsystems NATS server?
   Answer: Not currently possible. The NATS cluster that comes with Keptn is not exposed to the public
   and does not enforce authentication by the services that run in the same cluster.

Need definition of terms.  May be misused in this write-up in the meantime:

* **subject:** Is this the same as a topic, so an event?
  And the PUBSUB_TOPIC environment variable contains a comma-separated list
  of topics for which the distributor should listen;
  that list can be overridden by subscription information from the Bridge.

  When the control plane and execution plane are in the same K8s cluster,
  [NATS subject hierarchies](https://docs.nats.io/nats-concepts/subjects)  are supported.
  But wildcards cannot be used when polling events via HTTP,
  which is the mechanism used in multi-cluster Keptn installations,
  so each specific topic must be included in the list.
  But if `go-sdk` is being used instead of the distributor for multi-cluster instances,
  how is this relevant?
* **pub:** Publish?
* **sub:** Subscribe?

## Summary of behavior of NATS for Keptn on a single cluster

On a single-cluster Keptn instance,
the Keptn control plane and execution plane are both installed on the same cluster
and they communicate using NATS.
Execution plane services have a distributor pod that sub/pub event on behalf of the execution plane service.

Environment variables documented
on the [distributor](../../0.19.x/reference/miscellaneous/distributor) reference page
set NATS environment variables for the distributor.
[Meg to add NATS_URL to that page: https://github.com/keptn/keptn.github.io/issues/1442)]

The flow can be summarized as follows.
Note that this discussion assumes using `helm-service` and tasks like `deployment`
but another service could be used (created?) for this processing
and any tool could listen for tasks with names other than those of the standard tasks
that are documented on the [shipyard](../../0.19.x/reference/files/shipyard/#fields) reference page.

* The distributor for the execution plane services on a control plane
  handles the sub(s) and pub(s) for the execution plane service
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

* The Helm-Service Distributor (HSD) subscribes to subject:

  ```
  sh.keptn.event.deployment
  ```
  And receives:

   ```
   sh.keptn.event.deployment.started
   ```
   as well as the JSON event body.

* HSD triggers helm-service and pubs to subject:

  ```
  sh.keptn.vent.deployment.started
  ```
  as well as the JSON event body.

* The helm-service finishes the deployment and HSD pubs to subject:

  ```
  sh.keptn.event.deployment.finished
  ```
  as well as the JSON event body.

## Summary of behavior of NATS for Keptn on a multi-cluster instance:

The execution plane is really just a namespace or cluster other than where the control plane runs.
The distributor was originally designed to work for both the control plane and the remote execution planes
but, for recent releases, most execution plane services use
[go-sdk](https://github.com/stellar/go/blob/master/docs/reference/readme.md) rather than the distributor.

Services that use `go-sdk` on the execution plane can communicate over NATS
but the execution plane distributor polls the NATS subjects using the Keptn API.
It polls the NATS subjects using HTTPS (polling the `/api/v1/event` endpoint) on the control plane.

The following Keptn core services are connected to NATS
and each uses the `NATS_URL` environment variable to determine the URL:
`shipyard-controller`, `remediation-service`, `mongodb-datastore`,
`lighthouse-service`, and `approval-service`.
By default, the value of the `NATS_URL` environment variable
is the same as the value of the distributor's `PUBSUB_URL` environment variable;
is it a requirement that both values always match?

Keptn does not currently support a ConfigMap that contains the `NATS_URL`
so it must be set as an environment variable in the Helm chart [is that correct?] for each configured service.

The `helm-service` and Job Executor Service (JES) use the distributor's API proxy feature
to communicate with the `resource-service` so any configuration changes must be applied
to the distributor and not the `helm-service` or JES.

## Outsystems environment

The Outsystems requirement is set up by Geos, Rings, and Stamps:

* **Geo:** logical structure used to isolate compute and data
* **Ring:** logical structure used to control the release of code
* **Stamp:** cluster with specific applications and configurations


{{< popup_image link="./assets/jay-environment.png" caption="Outsystems environment" width="65%">}}

Nats is required for cross-communication between stamps/clusters.
NATS is set up so each service within a stamp/cluster
communicates (pub/sub) to the local NATS server in the stamp/cluster.
Gateways forward messages between stamps/clusters,
enabling cross-communication between stamps/clusters
without requiring (or allowing) the service to talk to anything other than the local NATS cluster.

Webhooks, HTTPS polling, and HTTPS REST are not allowed for cross-communication between stamps/clusters
but they would like to use their current NATS setup to enable cross-communication
between the Keptn control plane and execution plane services
using a pattern similar to that used for a single cluster Keptn instance.

### Integrating Keptn into the Outsystems environment

These are the steps taken to implement this configuration:

* The configuration of the Keptn control plane makes the Keptn distributor
  communicate to the existing NATS cluster within the Outsystems cluster.
  This can be done using by setting the `NATS_URL` environment variable
  for the `shipyard-controller`, `remediation-service`, `mongodb-datstore`,
  `lighthouse-service`, and `approval-service` control plane services
  that use `sdk-go`.
  The `PUBSUB_URL` distributor environment variable must be set to point to the existing NATS server
  for the `helm-service`, `statistics-service`, and `api-service` on the control plane.

  For this experiment, the URL of the Outsystems NATS cluster is:
  ```
  nats://natsserver.default.svc.cluster.local:4222
  ```

  Also set the `distributor.PUBSUB_URL` environment value to have the same value as `NATS_URL`
  and point to the existing Outsystems cluster.

* The configuration of the Keptn execution plane configures the Keptn distributor
  to communicate with the existing Outsystems NATS server within the cluster.
  This can be done by setting the distributor's `PUBSUB_URL` environment variable.

* Update the Keptn helm chart deployment template for each of the services without a distributor
  in the following way, so if the variable is not passed, nothing changes:
  ```
  ...
  env:
    {{- if .Values.NATS_URL }}
    - name: NATS_URL
      value: {{ .Values.NATS_URL }}
    {{- end }}
    ...
  ...
  ```
* The `mongodb-datastore` already hard-codes the NATS_URL,
  so change it in the following way so that,
  if the variable is not passed, it defaults to the existing value.
   ```
   env:
     ...
     - name: NATS_URL
       value: {{ .Values.NATS_URL | default "nats://keptn-nats" }}
   ```
* The `statistics-service` uses the distributor, so modify the distributor portion of the template,
  so if the value is not passed, nothing happens.
  ```
  env:
    {{- if .Values.distributor.PUBSUB_URL }}
    - name: PUBSUB_URL
      value: {{ .Values.distributor.PUBSUB_URL }}
    {{- end }}
   ```
* Modify the `helm-service` `deployment.yaml` within the Helm chart
  in the same way as for the `statistics-service`.
...
          env:
            {{- if .Values.distributor.PUBSUB_URL }}
            - name: PUBSUB_URL
              value: {{ .Values.distributor.PUBSUB_URL }}
            {{- end }}
            ...

* May need to set the `K8S_DEPLOYMENT_NAME` as discussed in the
  [Multi-cluster installation](../../install/multi-cluster/#keptn-sees-only-one-instance-of-an-integration-deployed-on-multiple-execution-planes) documentation.

* Create two separate Kubernetes clusters
  using a [NATS supercluster](https://docs.nats.io/running-a-nats-service/configuration/gateways) setup
  so NATS events that are published to the local NATS server
  are seen by ann NATS servers in the Kubernetes clusters.

* Set the `KEPTN_API_ENDPOINT` and `KEPTN_API_TOKEN` environment variables
  for the [distributor](../../0.19.x/reference/miscellaneous/distributor)
  so that events are handled using HTTP polling (`/api/vi/event`)
  rather than using the local NATS server.

* Exploring whether the [Istio](../../install/istio)
  [multi-cluster mesh](https://istio.io/latest/docs/setup/install/multicluster/)
  can be used to enable local REST requests made by the execution plane distributor
  to be forwarded to the control plane service on the separate cluster.
  This would minimize the changes required for the `distributor` or `go-sdk`.


### Open issues

1. A ConfigMap that contains the NATS URL would be convenient
   but it is not currently implemented in Keptn.
   Instead, the NATS_URL or PUBSUB_URL must be set manually
   for each control plane service.

1. How to handle NATS authentication.
   In the current Keptn release, the control plane services are hard-coded in the Helm chart
   to connect the NATS cluster that is installed with Keptn.
   The NATS cluster that comes with Keptn is not exposed to the public
   and does not enforce authentication by the services that run in the same cluster.

1. The JES also uses the distributor's API proxy to communicate with the Keptn API
   but did not work on first pass.
   Jay removed it from his configuration to concentrate on debugging the helm-service interface.

1. How does one handle having multiple clusters per stage?
   The Outsystems environment has multiple GEOs (e.g. regions) with multiple rings (e.g. `stages`)
   spanning each of the GEOs.
   Within  each ring are multiple stamps (e.g. K8s clusters).

1. As the Outsystems environment grows, adding more stamps and GEOs,
   will the execution services be auto-discovered (or auto-registered) by the control plane?

1. Can the Istio multi-cluster mesh be used to enable local REST requests made by the execution plane
   to be forwarded to the control plane service on the separate cluster?
   If not, we will need to modify the distributor to add an option
   that subscribes to the events via a NATS cluster
   but uses the public Keptn API for requests to services of the Keptn control plane.

