---
title: Manage tasks and sequences
description: Tips for managing tasks and sequences
weight: 35
keywords: [1.0.x-manage]
aliases:
---

A Keptn project's [shipyard](../../reference/files/shipyard)
defines `sequences` that `execute` `tasks`.
When the task receives the `action.finished` event,
the task is finished and subsequent tasks can execute.

## Stop a task

Keptn does not provide a facility to actually abort a task.
The [keptn abort](../../reference/cli/commands/keptn_abort) command
causes the shipyard controller to stop processing,
meaning it does not continue processing
and so prevents the next task from being triggered,
but it does not actually abort the task.

An executing task is stopped only when it receives an `action.finished`
event, usually with a `data.result` value
so that the shipyard controller knows what to do next..
So, if you need to stop a task, you can send a "fake" `action.finished` event
using the [Keptn API](../../reference/api).
You can do this from the [Keptn Bridge](../../bridge):

* Click the PC icon in the action task that is currently spinning and copy the event content.
* Navigate to the API page and click on the user icon on the top-right
* Click on the Keptn API link.
  * Open the POST /event api and click on "try it out".
  * Paste the event body that you copied before. Here,
  * Set (or add if missing) the value of `data.status` to `errored`
  and the value of `data.result` to `fail`.
  * Change the value of `type` to have the `finished` suffix instead of `started`.
* Authenticate the API via the API token
as discussed in [Access the API](../../reference/api/#access-the-keptn-api) and you can fire it.

This sends a `finished` event for your action, marking the task as failed.

## Identifying and cancelling a blocked sequence

Sequences that use the same service within the same stage can not be run in parallel.
If a sequence is stalling, e.g. due to a task executor not being able to fully process its task, other sequences for the same stage/service will not be able to be dispatched until the stalling sequence is cancelled.
To identify the keptnContext ID of a stalling sequence in Keptn 0.18.0 and later, use the new `GET api/controlPlane/v1/sequence-execution` endpoint. For this partcular scenario, the following query parameters will need to be set:

- **project**: This is a mandatory query parameter that always needs to be set for this endpoint
- **stage**: The stage which is currently blocked by a stalling sequence
- **service**: The service that is currently blocked by a stalling sequence
- **status**: This needs to be set to `started`. Since at any given point in time, there may be only one sequence execution with the `started` for a given service within the given stage, this filter will give us the blocking sequence.

The resulting query looks as follows:


```
curl -X 'GET' \
  'http://<api-url>/api/controlPlane/v1/sequence-execution?project=<project>&stage=<stage>&service=<service>&status=started' \
  -H 'accept: application/json'
```

The response will be a JSON object in the following format:

```json
{
   "nextPageKey":1,
   "pageSize":1,
   "totalCount":87,
   "sequenceExecutions":[
      {
         "_id":"99242617-7992-4440-8c4c-2c4aad8c1bc6",
         "schemaVersion":"1",
         "scope":{
            "project":"myapp",
            "stage":"staging",
            "service":"some-service",
            "status":"succeeded",
            "result":"pass",
            "keptnContext":"f7bdf6d6-8257-41fa-80e8-b86609f78d83",
            "triggeredId":"cfa815ad-b5f8-4715-82de-c375f52bc764",
            "gitcommitid":"1c2c7f6d232277061f623b47c2cbd65ce7c091b5",
            "eventType":"sh.keptn.event.staging.delivery.triggered"
         },
         "sequence":{
            "name":"delivery",
            "tasks":[
               {
                  "name":"deployment",
                  "properties":{
                     "deploymentstrategy":"blue_green_service"
                  }
               },
               {
                  "name":"test",
                  "properties":{
                     "teststrategy":"performance"
                  }
               },
               {
                  "name":"evaluation",
                  "properties":null
               },
               {
                  "name":"release",
                  "properties":null
               }
            ]
         },
         "status":{
            "state":"started",
            "stateBeforePause":"",
            "previousTasks":[
               {
                  "name":"deployment",
                  "triggeredID":"c6108a73-7459-42fe-8d10-a22b2fea9268",
                  "result":"pass",
                  "status":"succeeded",
                  "properties":{
                     "deployment":{
                        "deploymentNames":[
                           "canary"
                        ],
                        "deploymentURIsLocal":[
                           "http://some-service.myapp-staging:80"
                        ],
                        "deploymentURIsPublic":[
                           "http://some-service.myapp-staging.svc.cluster.local:80"
                        ],
                        "deploymentstrategy":"duplicate"
                     },
                     "message":"Successfully deployed",
                     "project":"myapp",
                     "result":"pass",
                     "service":"some-service",
                     "stage":"staging",
                     "status":"succeeded"
                  }
               }
            ],
            "currentTask":{
               "name":"test",
               "triggeredID":"f28aa212-7ef2-47a5-8a54-dff620a588ec",
               "events":[
                  {
                     "eventType":"sh.keptn.event.test.started",
                     "source":"jmeter-service",
                     "result":"pass",
                     "status":"succeeded",
                     "time":"2022-08-02T08:12:37.957Z",
                     "properties":null
                  }
               ]
            }
         },
         "inputProperties":{
            "configurationChange":{
               "values":{
                  "image":"docker.io/keptnexamples/some-service:1.0.0"
               }
            },
            "deployment":{
               "deploymentNames":[
                  "direct"
               ],
               "deploymentURIsLocal":[
                  "http://some-service.myapp-dev:80"
               ],
               "deploymentURIsPublic":[
                  "http://some-service.myapp-dev.svc.cluster.local:80"
               ],
               "deploymentstrategy":"direct"
            },
            "evaluation":{
               "indicatorResults":null,
               "result":"pass",
               "score":0,
               "sloFileContent":"",
               "timeEnd":"2022-08-02T08:11:18.633Z",
               "timeStart":"2022-08-02T08:11:15.145Z"
            },
            "message":"",
            "project":"myapp",
            "result":"pass",
            "service":"some-service",
            "stage":"staging",
            "status":"succeeded",
            "temporaryData":{
               "distributor":{
                  "subscriptionID":""
               }
            },
            "test":{
               "end":"2022-08-02T08:11:18.633Z",
               "start":"2022-08-02T08:11:15.145Z"
            }
         },
         "triggeredAt":"2022-08-02T08:11:19.855Z"
      }
   ]
}
```

The Keptn context ID of the sequence can be found in the `scope.keptnContext` property - in this case its value is `f7bdf6d6-8257-41fa-80e8-b86609f78d83`. Using this context ID, you can either navigate to that sequence in the bridge, using the following deep link format: `http://<keptn-url>/bridge/project/<myapp>/sequence/<keptn-context-id>`, and cancel it from there, or you can cancel the sequence using the `api/controlPlane/v1/sequence/<project>/<keptn-context-id>` endpoint:

```
curl -X 'POST' \
  'http://<api-url>/api/controlPlane/v1/sequence/<project>/<keptn-context-id>/control' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "state": "abort"
}'
```
