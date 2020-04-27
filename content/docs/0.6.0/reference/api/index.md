---
title: Keptn API
description: Explains how to connect the Keptn API and which commands are available.
weight: 11
keywords: [api, setup]
---

In this section, the functionality and commands of the Keptn REST API are described.

## Prerequisites

- To access the Keptn API, a running Keptn installation is needed. If you have not set up Keptn yet, please start [here](../../installation/setup-keptn).

- To get the **API token** for authenticating API calls, please see [here](../cli/#keptn-auth).  

## Access the Keptn API

The Keptn API is documented in terms of a [Swagger API documentation](https://swagger.io/).

* Use the Keptn CLI to retrieve the endpoint of your Keptn API via the command `keptn status`:

```console
keptn status
```

```console
Starting to authenticate
Successfully authenticated
CLI is authenticated against the Keptn cluster https://api.keptn.YOUR.DOMAIN
```

* Access the Keptn Swagger API documentation in your browser at: https://api.keptn.YOUR.DOMAIN/swagger-ui/

* The index page of the Swagger API documentation looks as follows:

{{< popup_image
    link="./assets/swagger.png"
    caption="Keptn Swagger API documentation"
    width="700px">}}

## Explore the Keptn API

* Select one of the two API collections: 

    * `api-service` contains endpoints to create/delete a project, to create service, and to send/get events.

    * `configuration-service` provides GET endpoints for project/stage/service and endpoints for resource management.

{{< popup_image
    link="./assets/select_api.png"
    caption="Select API"
    width="700px">}}

* Clicking on an endpoint reveals more details how to use it, including definitions and examples of the payload.

{{< popup_image
    link="./assets/swagger-example.png"
    caption="Keptn Swagger API documentation - Example"
    width="700px">}}

## Architecture Details of Keptn API

- Keptn 0.6.2 introduced an NGINX as new K8s deployment and service. This NGINX allows to route the traffic and ensures that all requests are authenticated using the `/auth` endpoint of the `api-service`.
- The `api-service` now does not implement endpoints of the `configuration-service` anymore.
- The `configuration-service` is exposed to the public. Endpoints that are not intended to be used from the public (e.g., *deleting a project*) are marked and the description is accordingly adapted.

**Architecture for the full installation:**
{{< popup_image
    link="./assets/api_architecture_full.png"
    caption="Architecture for full installation"
    width="700px">}}

**Architecture for the quality gates installation:**
{{< popup_image
    link="./assets/api_architecture_quality_gate.png"
    caption="Architecture for quality gate"
    width="700px">}}

## Technical Details of Cluster Gateway

The following descriptions are only valid for a full Keptn installation 
(i.e., a Keptn installation which was not installed for the quality-gates use case).

Keptn uses [Istio](https://istio.io/) for connecting and controlling the traffic.
In order to receive incoming and outgoing connections,
a [Gateway](https://istio.io/docs/reference/config/networking/gateway/) named `public-gateway` is available in the `istio-system` namespace.

<details><summary>*Details of the Gateway*</summary>
    <p>

    apiVersion: networking.istio.io/v1alpha3
    kind: Gateway
    metadata:
    name: public-gateway
    namespace: istio-system
    spec:
    selector:
        istio: ingressgateway
    servers:
    - port:
        name: http
        number: 80
        protocol: HTTP
        hosts:
        - '*'    
    - hosts:
        - '*'
        port:
        name: https
        number: 443
        protocol: HTTPS
        tls:
        mode: SIMPLE
        privateKey: /etc/istio/ingressgateway-certs/tls.key
        serverCertificate: /etc/istio/ingressgateway-certs/tls.crt

</p>
</details>

This Gateway accepts HTTP and HTTPS traffic. 
For the HTTPS traffic, Keptn generates a *self-signed certificate* during the installation.

If you already have a valid certificate for your domain and want to use this, please 
first [configure your domain](../cli/#keptn-configure-domain) and,
afterwards, manually update the used certificate in the Gateway.
For adding a custom certificate, the [Knative Documentation](https://knative.dev/docs/serving/using-a-tls-cert/)
provides useful instructions.
