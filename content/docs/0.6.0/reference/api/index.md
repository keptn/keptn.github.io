---
title: Keptn API
description: Explains how to connect the Keptn API and which commands are available.
weight: 11
keywords: [api, setup]
---

In this section, the functionality and commands of the Keptn REST API are described.

## Prerequisites

- To access the Keptn API, a running Keptn installation is needed. If you have not set up Keptn yet, [please start here](../../installation/setup-keptn).


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