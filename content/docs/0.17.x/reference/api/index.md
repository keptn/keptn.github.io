---
title: Keptn API
description: Explains how to connect the Keptn API and which commands are available.
weight: 11
---

In this section, the functionality and commands of the Keptn REST API are described.

## Prerequisites

- To access the Keptn API, a running Keptn installation is needed.
See [Installation](../../../install/) for detailed instructions.

- To get the **API token** for authenticating API calls, please see [here](../../operate/api_token/#retrieve-api-token).  

## Access the Keptn API

The Keptn API is documented in terms of a [Swagger API documentation](https://swagger.io/).

* Use the Keptn CLI to retrieve the endpoint of your Keptn API via the command `keptn status`:

    ```console
    keptn status
    ```

    ```console
    Starting to authenticate
    Successfully authenticated
    CLI is authenticated against the Keptn cluster http://YOUR.DOMAIN/api
    ```

* Access the Keptn Swagger API documentation in your browser at: http://YOUR.DOMAIN/api

* The index page of the Swagger API documentation looks as follows:

    {{< popup_image
        link="./assets/swagger.png"
        caption="Keptn Swagger API documentation"
        width="700px">}}

## Explore the Keptn API

* Select one of the two API collections: 

    * `api-service` contains endpoints to authenticate, get Keptn metadata, create/delete a project, to create service, and to send/get events.

    * `configuration-service` provides GET endpoints for project/stage/service and endpoints for resource management.

    * `mongodb-datastore` provides GET endpoint to retrieve Keptn events.

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

Keptn 0.6.2 introduced an NGINX as new K8s deployment and service called `api-gateway-ngnix` shown in the figure below. This NGINX allows to route the traffic and ensures that all requests are authenticated using the `/auth` endpoint of the `api-service`.

- The `api-service` now does not implement endpoints of the `configuration-service` anymore.
- The `configuration-service` is exposed to the public. Endpoints that are not intended to be used from the public (e.g., *deleting a project*) are marked and the description is accordingly adapted.
- The `mongodb-datastore` is exposed to the public. Endpoints that are not intended to be used from the public are marked and the description is accordingly adapted.


**Architecture of Keptn installation:**

{{< popup_image
    link="../../../../concepts/architecture/assets/architecture.png"
    caption="Architecture of Keptn installation"
    width="500px">}}
