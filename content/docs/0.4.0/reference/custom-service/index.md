---
title: Write your own keptn service
description: Shows you how to implement your own keptn service and listen for certain events.
weight: 30
keywords: [service, custom]
aliases:
---

Shows you how to implement your own keptn service and listen for certain events.

## About

The goal of this section is to describe how you can add additional functionality to your keptn installation by implementing your own services. 
You can react to certain events that occur during your CD pipeline runs, and, integrate additional tools into your pipeline by accessing their REST interfaces with your custom services. At the moment the events you can subscribe to include:

- sh.keptn.events.new-artifact
- sh.keptn.events.configuration-changed
- sh.keptn.events.deployment-finished
- sh.keptn.events.tests-finished
- sh.keptn.events.evaluation-done
- sh.keptn.events.problem

## Writing your own service

As a reference for writing your own service, please have a look at our implementation of the [GitHub Service](https://github.com/keptn/github-service/tree/release-0.1.x). Essentially, this service is a *nodeJS express* application that accepts POST requests at its `/` endpoint. This endpoint is called by the *knative channel controller* as soon as an event has been pushed to the queue your service is subscribed to. Of course, you can write your own service in any language, as long as it provides the endpoint to receive events.

Services in keptn are implemented as [knative services](https://cloud.google.com/knative/). The template manifest for the *GitHub service* can be found in the [config/service.yaml](https://github.com/keptn/github-service/blob/release-0.1.x/config/service.yaml) file in the GitHub repo:

  ```yaml
  apiVersion: serving.knative.dev/v1alpha1
  kind: Service
  metadata:
    name: github-service
    namespace: keptn
  spec:
    runLatest:
      configuration:
        build:
          apiVersion: build.knative.dev/v1alpha1
          kind: Build
          metadata:
            name: service-builder
            namespace: keptn
          spec:
            serviceAccountName: build-bot
            source:
              git:
                url: https://github.com/keptn/github-service.git
                revision: master
            template:
              name: kaniko
              arguments:
                - name: IMAGE
                  value: docker-registry.keptn.svc.cluster.local:5000/keptn/github-service:latest
        revisionTemplate:
          spec:
            container:
              image: REGISTRY_URI_PLACEHOLDER:5000/keptn/github-service:latest
  ---
  apiVersion: eventing.knative.dev/v1alpha1
  kind: Subscription
  metadata:
    name: github-new-artifact-subscription
    namespace: keptn
  spec:
    channel:
      apiVersion: eventing.knative.dev/v1alpha1
      kind: Channel
      name: new-artifact
    subscriber:
      ref:
        apiVersion: serving.knative.dev/v1alpha1
        kind: Service
        name: github-service
  ```

As you can see in the manifest file, it consists of a *knative service*, as well as a *knative eventing subscription*. The service makes use of knative's source-to-url feature, meaning that knative will take care of building and deploying your service, using the build specification in the manifest file. The build specification accepts the link to a github repository containing a Dockerfile (which you will need to provide) for your application and will use the *kaniko* build template to build the container and push it to the registry specified in the build spec. In this case, the template references the docker registry that has been deployed within the keptn namespace of the cluster. Also, note that there is a placeholder for the IP address of the registry (`REGISTRY_URI_PLACEHOLDER`). This is because currently it is not possible to reference the cluster-internal DNS name for the container image the service should pull when it is being invoked.

The *Subscription* defines to which kind of event the service should listen to. To subscribe your service to a queue, set the property *spec.channel.name* to one of the following:

  ```
  new-artifact
  configuration-changed
  deployment-finished
  tests-finished
  evaluation-done
  problem
  ```

Additionally, you will need to provide a name for the subscription (*metadata.name*), and reference the name of your service (*spec.subscriber.ref.name*).

To deploy the service, we use a script that will first retrieve the IP of the cluster-internal docker registry, and replace the `REGISTRY_URI_PLACEHOLDER` in the manifest file with that value. The resulting manifest file will be stored in the *[config/gen](https://github.com/keptn/github-service/tree/release-0.1.x/config/gen)* directory. By executing the script with

  ```console
  ./deploy.sh
  ```

any previous revisions of the service will be deleted and the newest version will be deployed.

*To summarize*, you will need to provide the following when you want to write a custom service:

- A Github repo, containing the source code, as well as a Dockerfile for your application.
- The application needs to provide a REST endpoint at `/` that accepts `POST` requests for JSON objects.
- The `config` directory, containing the template for the manifest file (see description above), as well as the `config/gen` directory.
- The `deploy.sh` script.

*Note:* this documentation will be replaced with an extensive step-by-step guide in the future.

## CloudEvents

Please note that cloudevents have to be sent with with the HTTP header `Content-Type: application/cloudevents+json` to be set.

Depending on the channel your service is subscribed to, it will receive the payload in the following format:

### sh.keptn.new-artifact

```json
{  
   "specversion":"0.2",
   "type":"sh.keptn.events.new-artifact",
   "id":"1234",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c",
   "data":{  
      "githuborg":"keptn-tiger",
      "project":"sockshop",
      "teststrategy":"functional",
      "deploymentstrategy":"direct",
      "stage":"dev",
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16"
   }
}
```

### sh.keptn.configuration-changed

```json
{  
   "specversion":"0.2",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "data":{  
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16",
      "project":"sockshop",
      "stage":"dev",
      "githuborg":"keptn-tiger",
      "teststrategy":"functional",
      "deploymentstrategy":"direct"
   },
   "type":"sh.keptn.events.configuration-changed",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c"
}
```

### sh.keptn.deployment-finished

```json
{  
   "specversion":"0.2",
   "type":"sh.keptn.events.deployment-finished",
   "id":"1234",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c",
   "data":{  
      "githuborg":"keptn-tiger",
      "project":"sockshop",
      "teststrategy":"functional",
      "deploymentstrategy":"direct",
      "stage":"dev",
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16"
   }
}
```

### sh.keptn.tests-finished

```json
{  
   "specversion":"0.2",
   "type":"sh.keptn.events.tests-finished",
   "id":"1234",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c",
   "data":{  
      "githuborg":"keptn-tiger",
      "project":"sockshop",
      "teststrategy":"functional",
      "deploymentstrategy":"direct",
      "stage":"dev",
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16"
   }
}
```

### sh.keptn.evaluation-done

- Example for a successful evaluation:

```json
{  
   "specversion":"0.2",
   "type":"sh.keptn.events.evaluation-done",
   "id":"1234",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c",
   "data":{  
      "githuborg":"keptn-tiger",
      "project":"sockshop",
      "teststrategy":"functional",
      "deploymentstrategy":"direct",
      "stage":"dev",
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16",
      "evaluationpassed": true,
      "evaluationdetails": { // NOTE: the evaluationdetails object is not strictly typed
        "options":{
            "timeStart":1557838126,
            "timeEnd":1557838317
        },
        "totalScore":100,
        "objectives":{
            "pass":90,
            "warning":75
        },
        "indicatorResults":[
            {
              "id":"ResponseTime_Backend",
              "violations":[

              ],
              "score":100
            }
        ],
        "result":"pass"
      },
      "tag":"0.6.7-16"
   }
}
```

- Example for a failed evaluation:

```json
{  
   "specversion":"0.2",
   "type":"sh.keptn.events.evaluation-done",
   "id":"1234",
   "time":"2018-04-05T17:31:00Z",
   "contenttype":"application/json",
   "shkeptncontext":"db51be80-4fee-41af-bb53-1b093d2b694c",
   "data":{  
      "githuborg":"keptn-tiger",
      "project":"sockshop",
      "teststrategy":"functional",
      "deploymentstrategy":"direct",
      "stage":"dev",
      "service":"carts",
      "image":"10.11.245.27:5000/sockshopcr/carts",
      "tag":"0.6.7-16",
      "evaluationpassed": false,
      "evaluationdetails": { // NOTE: the evaluationdetails object is not strictly typed
        "options":{
          "timeStart":1557839081,
          "timeEnd":1557839741
        },
        "totalScore":0,
        "objectives":{
          "pass":90,
          "warning":75
        },
        "indicatorResults":[
          {
            "id":"ResponseTime_Backend",
            "violations":[
                {
                  "value":1014676.0082135524,
                  "key":"SERVICE-64F930D2B8E888FF",
                  "breach":"upperSevere",
                  "threshold":1000000
                }
            ],
            "score":0
          }
        ],
        "result":"fail"
      },
      "tag":"0.6.7-16"
   }
}
```

### sh.keptn.problem

To receive events in this channel, please follow the instructions of the [Runbook Automation and Self-healing](https://v1.keptn.sh/docs/0.2.0/usecases/runbook-automation-and-self-healing/) section.

```json
{
    "specversion":"0.2",
    "type":"sh.keptn.events.problem",
    "source":"dynatrace",
    "id":"{PID}",
    "time":"2018-04-05T17:31:00Z",
    "contenttype":"application/json",
    "shkeptncontext":"{PID}",
    "data": {
        "State":"{State}",
        "ProblemID":"{ProblemID}",
        "PID":"{PID}",
        "ProblemTitle":"{ProblemTitle}",
        "ProblemDetails":{ProblemDetailsJSON},
        "ImpactedEntities":{ImpactedEntities},
        "ImpactedEntity":"{ImpactedEntity}"
    }
}
```

## Logging

To inspect your service's log messages for a specific pipeline run, as described in the [keptn's log](https://v1.keptn.sh/docs/0.2.0/reference/keptnslog/) section, you can use the `shkeptncontext` property of the incoming CloudEvents. Your service has to output its log messages in the following format:

```json
{
  "keptnContext": "<KEPTN_CONTEXT>",
  "logLevel": "INFO | DEBUG | WARNING | ERROR",
  "keptnService": "<YOUR_SERVICE_NAME>",
  "message": "logging message"
}
```
