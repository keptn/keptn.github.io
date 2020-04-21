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
Use the Keptn CLI to retrieve the endpoint of your Keptn API via the command `keptn status`. 

```console
keptn status
```

Output:
```console
Starting to authenticate
Successfully authenticated
CLI is authenticated against the Keptn cluster https://api.keptn.XX.XXX.XX.XXX.io
```

Access the Keptn Swagger API documentation in your browser at https://api.keptn.XX.XXX.XX.XXX.io/swagger-ui/. You should see something similar to the screenshot:

{{< popup_image
    link="./assets/swagger.png"
    caption="Keptn Swagger API documentation"
    width="700px">}}

## Explore the API

Clicking on an endpoint reveals more details how to use it, including definitions and examples of the payload.

{{< popup_image
    link="./assets/swagger-example.png"
    caption="Keptn Swagger API documentation - Example"
    width="700px">}}

## Technical Details of the Cluster Gateway

The following descriptions are only valid for a full Keptn installation 
(i.e., a Keptn installation which was not installed for the quality-gates use case).

Keptn uses [Istio](https://istio.io/) for connecting and controlling the traffic.
In order to receive incoming and outgoing connections,
a [Gateway](https://istio.io/docs/reference/config/networking/gateway/) named `public-gateway` is available in the `istio-system` namespace.

<details><summary>Details of the Gateway</summary>
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
