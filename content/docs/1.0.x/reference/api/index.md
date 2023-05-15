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

* Access the Keptn Swagger UI and API documentation
* by clicking on "Keptn API" in the top right menu on the Bridge
* or by pointing your browser at: http://YOUR.DOMAIN/api .
This gives you easy access to all API Endpoints.

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
        
## Upload a file to a Keptn project
You can upload an API file to a project in any of the following ways :
* Use the [keptn add-resource](../cli/commands/keptn_add-resource) command.
Note that only some APIs are supported by this command.
* Upload the file directly to your Git repo.
* Use the `resource-service` API for uploading
using the Swagger API as shown above.
This gives you sections for uploading resources
on the project, stage or service level.

  To mimic what the `keptn add-resource` command does,
  use the `POST API` call.
  
  ```console
  curl -X 'POST' \
  'http://yourkeptn/api/resource-service/v1/project/YOURPROJECT/stage/YOURSTAGE/service/YOURSERVICE/resource' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "resources": [
    {
      "resourceContent": "PATHTO/yourfile.abc",
      "resourceURI": "BASE64ENCODEDFILE"
    }
  ]
  }
  ```
## Architectural Details of Keptn API

Keptn uses
[NGINX](https://www.nginx.com/)
to route the traffic and ensure that all requests are authenticated
using the `/auth` endpoint of the `api-service`.
This is implemented using the
[api-gateway-ngnix](../../../concepts/architecture/#api-gateway-nginx)
service as shown in the figure below.

- The [api-service](../../../concepts/architecture/#api-service)
  does not itself implement endpoints of the `resource-service`.
- The [resource-service](../../../concepts/architecture/#mongodb-datastore)
  (which replaces the `configuration-service` used in earlier releases)
- is exposed to the public.
  Endpoints that are not intended to be used by the public (e.g., *deleting a project*)
  are marked and the description is adapted accordingly.
- The [mongodb-datastore](../../../concepts/architecture/#mongodb-datastore)
  is exposed to the public.
  Endpoints that are not intended to be used by the public are marked and the description is adapted accordingly.


**Architecture of Keptn installation:**

{{< popup_image
    link="../../../../concepts/architecture/assets/architecture.png"
    caption="Architecture of Keptn installation"
    width="500px">}}
