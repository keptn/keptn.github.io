---
title: Statistics Service
description: Provide usage statistics about a Keptn instance

weight: 60
icon: setup
---


The Statistics Service provides usage statistics about a Keptn instance.
You can access the service using the Keptn API
and view the results using the Swagger UI.

## Generate Swagger doc from source

First, install the `go` modules with the following commands:

```
go get -u github.com/swaggo/swag/cmd/swag
go get -u github.com/swaggo/gin-swagger
go get -u github.com/swaggo/files
```

To generate new source that updates the `swagger.yaml` file with new endpoints or models, execute the following:

```
swag init
```

## How to use the service

Access the Statistics Service through the Keptn API under the `statistics` path.
For example:

```
http://keptn-api-url.com/api/statistics
```

Use the following URL to view the swagger UI for the service:

```
http://keptn-api-url.com/api/swagger-ui/?urls.primaryName=statistics
```

To browse the API docs, open the Swagger docs in your browser, e.g. `${KEPTN_URL}/swagger-ui/index.html`.

## Specifying time frames

To retrieve usage statistics for a certain time frame, you must provide the [Unix timestamps](https://www.epochconverter.com/) for the start and end of the time frame.
Use the [EpochConverter](https://www.epochconverter.com/) to generate timestamps.

A Keptn API example using a timestamp is:

```
http://keptn-api-url.com/api/statistics/v1/statistics?from=1600656105&to=1600696105
```

A cURL example using a timestamp is:

```
curl -X GET "http://keptn-api-url.com/api/statistics/v1/statistics?from=1600656105&to=1600696105" -H "accept: application/json" -H "x-token: <keptn-api-token>"
```


## Configuring the aggregating interval

By default, the service aggregates data every 30 minutes.
When this period has passed, the service creates a new entry in the Keptn-MongoDB within the Keptn cluster.
To change how often statistics are stored, set the `AGGREGATION_INTERVAL_SECONDS` variable to your desired value.

