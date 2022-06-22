---
title: distributor
description: Environment variables for distributor
weight: 125
---

A distributor subscribes a Keptn service with the Keptn Control Plane.
Both local and remote subscriptions are supported:

* Local (Keptn service runs in the same local Kubernetes cluster as the Keptn Control Plane)
It queries event messages from NATS and sends the events
to services that have a subscription to the event topic.
* Remote (Keptn service runs in a remote "execution plane")
Subscriptions are implemented using the Keptn Subscription API.

Each service has its own distributor that is configured by environment variables.
In most cases, only a subset of these need to be configured.
After the application is deployed,
its subscription can be changed directly in the Bridge.

## Environment variables

The following environment variables configure the distributor
when it runs outside the Keptn cluster:

- `KEPTN_API_ENDPOINT` - Keptn API Endpoint - needed when the distributor runs outside of the Keptn cluster. default = `""`
- `KEPTN_API_TOKEN` - Keptn API Token - needed when the distributor runs outside of the Keptn cluster. default = `""`

The following environment variables configure Keptn to serve as a proxy for the Keptn API:

- `API_PROXY_PORT` - Port on which the distributor listens for incoming Keptn API requests
by its execution plane service. default = `8081`.
- `API_PROXY_PATH` - Path on which the distributor listens for incoming Keptn API requests
by its execution plane service. default = `/`.
- `API_PROXY_HTTP_TIMEOUT` - Timeout value (in seconds) for the API Proxy's HTTP Client. default = `30`.
- `HTTP_POLLING_INTERVAL` - Interval (in seconds) in which the distributor
checks for new triggered events on the Keptn API. default = `10`
- `EVENT_FORWARDING_PATH` - Path on which the distributor listens for incoming events
from its execution plane service. default = `/event`
- `HTTP_SSL_VERIFY` - Determines whether the distributor should check the validity of SSL certificates
when sending requests to a Keptn API endpoint via HTTPS. default = `true`

The following environment variables configure the distributor
when it runs within the Keptn cluster:

- `PUBSUB_URL` - The URL of the NATS cluster to which the distributor should connect
when the distributor is running within the Keptn cluster. default = `nats://keptn-nats`
- `PUBSUB_TOPIC` - Comma separated list of topics (i.e. event types)
for which the distributor should listen
(see https://github.com/keptn/spec/blob/0.2.4/cloudevents.md for details).
This is the initial subscription for the service;
it is overridden by subscription information supplied through the Bridge.
   * When running within the Keptn cluster, it is possible to use NATS
[Subject hierarchies](https://nats-io.github.io/docs/developer/concepts/subjects.html#matching-a-single-token).
   * When running outside of the cluster (polling events via HTTP), wildcards can not be used.
In this case, each specific topic must be included in the list.
- `PUBSUB_RECIPIENT` - Hostname of the execution plane service to which the distributor
should forward incoming CloudEvents. default = `http://127.0.0.1`
- `PUBSUB_RECIPIENT_PORT` - Port of the execution plane service
to which the distributor should forward incoming CloudEvents. default = `8080`
- `PUBSUB_RECIPIENT_PATH` - Path of the execution plane service
to which the distributor should forward incoming CloudEvents. default = `/`
- `PUBSUB_GROUP` - Used to join a group for receiving messages from the message broker.
Note that only **one** instance of a distributor in a set of distributors having the same `PUBSUB_GROUP`
are able to receive the event. default = `""`

The following environment variables filter events:

- `PROJECT_FILTER` - Filter events for a specific project. default = `""`, supports a comma-separated list of projects.
- `STAGE_FILTER` - Filter events for a specific stage. default = `""`, supports a comma-separated list of stages.
- `SERVICE_FILTER` - Filter events for a specific service. default = `""`, supports a comma-separated list of services.

The following 

- `DISABLE_REGISTRATION` - Disables automatic registration of the Keptn integration to the control plane.
default = `false`
- `REGISTRATION_INTERVAL` - Time duration between trying to re-register to the Keptn control plane.
default =`10s`
- `LOCATION` - Location on which the distributor is running, e.g. "executionPlane-A". default = `""`
- `DISTRIBUTOR_VERSION` - The software version of the distributor. default = `""`
- `VERSION` - The version of the Keptn integration. default = `""`
- `K8S_DEPLOYMENT_NAME` - Kubernetes deployment name of the Keptn integration. default = `""`
- `K8S_POD_NAME` -  Kubernetes deployment name of the Keptn integration. default = `""`
- `K8S_NAMESPACE` - Kubernetes namespace of the Keptn integration. default = `""`
- `K8S_NODE_NAME` - Kubernetes node name the Keptn integration is running on. default = `""`
- `OAUTH_CLIENT_ID` - OAuth client ID used when performing Oauth Client Credentials Flow. default = `""`
- `OAUTH_CLIENT_SECRET` - OAuth client ID used when performing Oauth Client Credentials Flow. default = `""`
- `OAUTH_DISCOVERY` - Discovery URL called by the distributor to obtain further information for the OAuth Client Credentials Flow, e.g. the token URL. default = `""`
- `OAUTH_TOKEN_URL` - Url to obtain the access token. If set, this will override `OAUTH_DISCOVERY` meaning, that no discovery will happen. default = `""`
- `OAUTH_SCOPES` - Comma separated list of tokens to be used during the OAuth Client Credentials Flow. =`""`

All cloud events specified in `PUBSUB_TOPIC` that match the filters
are forwarded to `http://{PUBSUB_RECIPIENT}:{PUBSUB_RECIPIENT_PORT}{PUBSUB_RECIPIENT_PATH}`,
e.g.: `http://helm-service:8080`.

## Usage notes

## Configuration examples

The above list of environment variables is pretty long, but in most scenarios only a few of them have to be set. The following examples show how to set the environment variables properly, depending on where the distributor and it's accompanying execution plane service should run:

**Configuring the distributor when running within the Keptn cluster**

In this case, usually only the `PUBSUB_TOPIC` must be defined, e.g.:

```
PUBSUB_TOPIC: "sh.keptn.event.approval.triggered"
```

This is not necessary if the distributor is used only as a proxy for the Keptn API
and not needed for subscribing to any topic.

This forwards all incoming events of that topic to `http://127.0.0.1:8080`
which is the URL of the execution plane service running in the same pod as the distributor.
If the execution plane service has a different hostname (e.g., when not running in the same pod),
a different port, or listens for events on a different path,
the env vars `PUBSUB_RECIPIENT`, `PUBSUB_RECIPIENT_PORT` and `PUBSUB_RECIPIENT_PATH`
can be set to change this default URL, e.g.:

```
PUBSUB_RECIPIENT: "http://my-service
PUBSUB_RECIPIENT_PORT: "9000"
PUBSUB_RECIPIENT_PATH: "/event-path
```

This causes the distributor to forward all incoming events for its subscribed topic
to `http://my-service:9000/event-path`.

The execution plane service can then access the distributor's Keptn API proxy at `http://localhost:8081/`,
and can forward events by sending them to `http://localhost:8081/event`.
The Keptn API services are then reachable for the execution plane service via the following URLs:


- Mongodb-datastore:
  - `http://localhost:8081/mongodb-datastore`

- Configuration-service:
  - `http://localhost:8081/configuration-service`

- Shipyard-controller:
  - `http://localhost:8081/controlPlane`

If the distributor should listen on a port other than `8081`
(e.g. when that port is needed by the execution plane service),
a different port can be set using the `API_PROXY_PORT` environment variable.

**Configuring the distributor when running outside of the Keptn cluster**

In this case, the Keptn API URL and the API token, as well as a topic have to be defined:

```
KEPTN_API_ENDPOINT: "https://my-keptn-api:8080/api"
KEPTN_API_TOKEN: "my-keptn-api-token"
PUBSUB_TOPIC: "sh.keptn.event.approval.triggered" # can be left empty if the distributor is only used as a proxy to interact with the Keptn API
```

If the endpoint specified by `KEPTN_API_ENDPOINT` does not provide a valid SSL certificate,
by default, the distributor denies any requests to that endpoint.
This behavior can be changed by setting the variable `HTTP_SSL_VERIFY` to `false`.

The remaining parameters, such as `PUBSUB_RECIPIENT`, `PUBSUB_RECIPIENT_PORT` and `PUBSUB_RECIPIENT_PATH`, as well as the `API_PROXY_PORT` can be configured as described above.

## Installation

Distributors are installed automatically as a part of [Keptn](https://keptn.sh).

## Deploy in your Kubernetes cluster

To deploy the current version of a *distributor* in your Keptn Kubernetes cluster, use the file `deploy/distributor.yaml` from this repository and apply it:

```console
kubectl apply -f deploy/service.yaml
```

## Delete in your Kubernetes cluster

To delete a deployed *distributor*, use the file `deploy/distributor.yaml` from this repository and delete the Kubernetes resources:

```console
kubectl delete -f deploy/service.yaml
```

## Usage notes

## Differences between versions

* In Keptn Release 0.14.x, the NATS dependency is upgraded.
Because of this, the NATS cluster name is now `keptn-nats`
rather than `keptn-nats-cluster` as used in earlier releases.
This causes a crashloop for any Keptn service that is not using the 0.14.x distributor.
If you cannot update your distributor to 0.14.x,
you may be able to run your existing distributor
by setting the `PUBSUB_URL`environment variable to `nats://keptn-nats`.
See the [Keptn.0.14.1 Release Announcement](../../../../news/release_announcements/keptn-0141)
for details.

## See also

* [distributor.yaml](../../files/distributor)
* [Write a Keptn-service](../../../integrations/custom_integration)

