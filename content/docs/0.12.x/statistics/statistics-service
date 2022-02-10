# Statistics Service

This service provides usage statistics about a Keptn installation.

### Generate  Swagger doc from source

First, install the `go` modules with the following commands:

```
go get -u github.com/swaggo/swag/cmd/swag
go get -u github.com/swaggo/gin-swagger
go get -u github.com/swaggo/files
```

If you need to generate new source to update the `swagger.yaml` file with new endpoints or models, execute the following:

```console
swag init
```

## How to use the service

You can access the service via the Keptn API under the `statistics` path, for example:

```
http://keptn-api-url.com/api/statistics
```

Use the following URL to view the swagger UI for the service:

```
http://keptn-api-url.com/api/swagger-ui/?urls.primaryName=statistics
```

To browse the API docs, open the Swagger docs in your [browser](http://localhost:8080/swagger-ui/index.html).

To retrieve usage statistics for a certain time frame, you need to provide the [Unix timestamps](https://www.epochconverter.com/) for the start and end of the time frame.
For example:

```
http://keptn-api-url.com/api/statistics/v1/statistics?from=1600656105&to=1600696105
```

cURL Example:

```
curl -X GET "http://keptn-api-url.com/api/statistics/v1/statistics?from=1600656105&to=1600696105" -H "accept: application/json" -H "x-token: <keptn-api-token>"
```

*Note*: Use the [epochconverter.com](https://www.epochconverter.com/) to generate timestamps.

### Configuring the service

By default, the service aggregates data with a granularity of 30 minutes.
When this period has passed, the service creates a new entry in the Keptn-MongoDB within the Keptn cluster.
To change how often statistics are stored, can set the variable `AGGREGATION_INTERVAL_SECONDS` to your desired value.

[Could we add an example?  And is the value in seconds (as the name of the variable implies) or in minutes as the text might imply unless the default value is 30x60 seconds]
