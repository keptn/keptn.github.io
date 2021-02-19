---
title: Migrate existing Keptn integration
description: Technical guidance regarding migrating an existing Keptn 0.7.x service to a Keptn 0.8.x service
weight: 5
keywords: [0.8.x-integration]
---

This guide will provide information for migrating an existing Keptn 0.7.x service to a Keptn 0.8.x service based on our Go package [keptn/go-utils](https://github.com/keptn/go-utils/) aswell as our [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go). 
If you are using a different framework/programming language, please try to apply the changes described as best as you can.

## CloudEvents

*Note*: If you are using the latest version `go-utils`, this is handled automatically for you in our new helper functions (see below).

With Keptn 0.8.x, we have upgraded to CloudEvents spec 1.0. Please upgrade your relevant CloudEvents and set `"specversion": "1.0"` where adequate, e.g.:
```json
{
  "type": "sh.keptn.events.deployment-finished",
  "specversion": "1.0",
  ...
}
```

In addition, make sure to also upgrade the respective CloudEvents sdk.

## Keptn CloudEvents

*Note*: Most of the following is automatically handled if you are using the latest version of `go-utils`.

In addition to CloudEvents itself, Keptn is shipping a whole new spec for Keptn specific CloudEvents (see https://github.com/keptn/spec/blob/0.2.0/cloudevents.md for current version).

The most important changes are:

* We have streamlined the naming of all types, e.g., they now all start with `sh.keptn.event.` (used to be `sh.keptn.events` for some older events)
* We are making sure that CloudEvents always refer to something that has happened in the past (e.g,. `deployment.finished`)
* A CloudEvent is defined by its "type" (e.g., `deployment`, `test`, `evaluation`, `get-sli`) and its status: `.triggered`, `.started`, `.status.changed` and `.finished` (e.g., `deployment.finished`, `test.triggered`, ...)
* CloudEvents Spec 1.0 is used (instead 0.2)
* Keptn Spec version is added to each cloudevent, e.g., `"shkeptnspecversion": "0.2.0"`
* When a Keptn-service reacts on a `.triggered` event, it is expected to respond with a `.started` event, and eventually a `.finished` event.
* CloudEvents `.started`, `.status.changed` and `.finished` require a `triggeredid` in the CloudEvents extension
* **Most important change:** Keptn-services should now only react when they retrieve a `.triggered` event (they should no longer listen to events like `deployment-finished` or `tests-finished` to do what they need to do)

In addition, if you have listened to certain CloudEvents before, you will need to change your logic as described below:

| Description                                                             | [Keptn 0.7.x](https://github.com/keptn/spec/blob/0.1.7/cloudevents.md) | [Keptn 0.8.x](https://github.com/keptn/spec/blob/0.2.0/cloudevents.md)                                     |
|-------------------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| A configuration-change was triggered (e.g., via CLI)                    | `sh.keptn.event.configuration.change`                                  |   `sh.keptn.event.${STAGE}.${SEQUENCE}.triggered`,  e.g., `sh.keptn.event.dev.artifact-delivery.triggered` |
| A deployment has started                                                | -                                                                      | `sh.keptn.event.deployment.started`                                                                        |
| A deployment has finished, notify another service (e.g. slack) about it | `sh.keptn.events.deployment-finished`                                  | `sh.keptn.event.deployment.finished`                                                                       |
| A deployment has finished, start tests                                  | `sh.keptn.events.deployment-finished`                                  | `sh.keptn.event.test.triggered`                                                                            |
| Tests have started                                                      | -                                                                      | `sh.keptn.event.test.started`                                                                              |
| Tests have finished, notify another service (e.g., slack) about it      |   `sh.keptn.events.tests-finished`                                     |   `sh.keptn.event.test.finished`                                                                           |
| Tests have finished, start evaluation                                   | `sh.keptn.events.tests-finished`                                       |   `sh.keptn.event.evaluation.triggered `                                                                   |
| An evaluation is manually triggered (e.g., via CLI)                     |   `sh.keptn.event.start-evaluation`                                    |  `sh.keptn.event.evaluation.triggered`                                                                     |
| Evaluation has started                                                  | -                                                                      |  `sh.keptn.event.evaluation.started`                                                                       |
| Evaluation has finished, do next step or alike                          |    `sh.keptn.events.evaluation-done`                                   | `sh.keptn.event.evaluation.finished`                                                                       |
| Invalidate evaluation                                                   |   `sh.keptn.events.evaluation.invalidated`                             | `sh.keptn.event.evaluation.invalidated`                                                                    |
| Start retrieving SLIs (known as internal Get-SLI event)                 |    `sh.keptn.internal.event.get-sli`                                   |    `sh.keptn.event.get-sli.triggered`                                                                      |
| Retrieving SLIs has started                                             | -                                                                      | `sh.keptn.event.get-sli.started`                                                                           |
| Retrieving SLIs has finished                                            | `sh.keptn.internal.event.get-sli.done`                                 |   `sh.keptn.event.get-sli.finished`                                                                        |
| Trigger an approval                                                     |   `sh.keptn.event.approval.triggered`                                  |   `sh.keptn.event.approval.triggered`                                                                      |
| Approval has started                                                    | -                                                                      | `sh.keptn.event.approval.started`                                                                          |
| Approval has finished                                                   | `sh.keptn.event.approval.finished`                                     | `sh.keptn.event.approval.finished`                                                                         |
| Remedation triggered                                                    | `sh.keptn.event.remediation.triggered`                                 |  `sh.keptn.event.remediation.triggered`                                                                    |
| Remediation started                                                     | `sh.keptn.event.remediation.started`                                   | `sh.keptn.event.remediation.started`                                                                       |
| Remediation status changed                                              | `sh.keptn.event.remediation.status.changed`                            | `sh.keptn.event.remediation.status.changed`                                                                |
| Remediation finished                                                    | `sh.keptn.event.remediation.finished`                                  | `sh.keptn.event.remediation.finished`                                                                      |
| (Remediation) Action triggered                                          |   `sh.keptn.event.action.triggered`                                    |    `sh.keptn.event.action.triggered`                                                                       |
| (Remediation) Action started                                            | `sh.keptn.event.action.started`                                        | `sh.keptn.event.action.started`                                                                            |
| (Remediation) Action finished                                           | `sh.keptn.event.action.finished`                                       | `sh.keptn.event.action.finished`                                                                           |
| Configure Monitoring                                                    | `sh.keptn.event.monitoring.configure`                                  | `sh.keptn.event.configure-monitoring` (pending changes)                                                    |
| Configure Monitoring Finished                                           | -                                                                      | `sh.keptn.event.configure-monitoring.finished`                                                             |
| Project was created                                                     | `sh.keptn.internal.event.project.create`                               | Ongoing discussion                                                                                                    |
| Project was deleted                                                     | `sh.keptn.internal.event.project.delete`                               | Ongoing discussion                                                                                                    |
| Service was created                                                     | `sh.keptn.internal.event.service.create`                               | Ongoing discussion                                                                                                    |
| Service was deleted                                                     | `sh.keptn.internal.event.service.delete`                               | Ongoing discussion                                                                                                    |

Please note, that even if the name stayed the same, the payloads might have changed. You will need to consult the respective CloudEvents doc, e.g.,
* `action.triggered` on Keptn 0.7.x (spec 0.1.7): https://github.com/keptn/spec/blob/0.1.7/cloudevents.md#action-triggered
* `action.triggered` on Keptn 0.8.x (spec 0.2.0): https://github.com/keptn/spec/blob/0.2.0/cloudevents.md#action-triggered


## Workflow Changes (Shipyard)

As already described above, we have significantly changed the way Keptn executes a sequence e.g. for continuous-delivery. Therefore we are providing some more guidance on how the workflow has changed in certain scenarios below.

### Workflow Change Example: helm-service

In Keptn 0.7.x we relied on a `configuration-changed` event to start deployments:
```
sh.keptn.event.configuration.change (e.g., sent via Keptn CLI)
  -> helm-service creates a helm-release and upgrades it on the Kubernetes Cluster
    -> helm-service sends sh.keptn.events.deployment-finished
```

In Keptn 0.8.x this has significantly changed, as we introduced specific `.triggered`, `.started`, `.finished` events for this:

```
sh.keptn.event.deployment.triggered (sent by shipyard-controller)
  -> helm-service reacts
    -> helm-service sends sh.keptn.event.deployment.started
      -> helm-service creates a helm-release and upgrades it on the Kubernetes Cluster
        -> helm-service sends sh.keptn.event.deployment.finished (result: pass/fail)
```

### Workflow Change Example: jmeter-service

In Keptn 0.7.x we relied on a `deployment-finished` event to start tests:
```
sh.keptn.events.deployment-finished (e.g., sent by helm-service)
  -> jmeter-service executes tests
    -> jmeter-service sends sh.keptn.events.tests-finished (result: pass/fail)
```

In Keptn 0.8.x this has significantly changed, as we introduced specific `.triggered`, `.started`, `.finished` events for this:

```
sh.keptn.event.test.triggered (sent by shipyard-controller)
  -> jmeter-service reacts
    -> jmeter-service sends sh.keptn.event.test.started
      -> jmeter-service executes tests
        -> jmeter-service sends sh.keptn.events.test.finished (result: pass/fail)
```


### Workflow Change Example: SLI Provider (e.g., prometheus-sli-service)

In Keptn 0.7.x we relied on internal `get-sli` event to fetch SLIs:
```
sh.keptn.internal.event.get-sli (e.g., sent by lighthouse-service)
  -> SLI provider (e.g., prometheus-sli-service) starts fetching values from monitoring tool
    -> SLI Provider (e.g., prometheus-sli-service) sends sh.keptn.internal.event.get-sli.done
```

In Keptn 0.8.x we have slightly adapted this behaviour, and enhanced it with specific `.triggered`, `.started`, `.finished` events for this:

```
sh.keptn.event.get-sli.triggered (e.g., sent by lighthouse-service)
  -> SLI provider (e.g., prometheus-sli-service) reacts
    -> SLI provider (e.g., prometheus-sli-service) sends sh.keptn.event.get-sli.started
      -> SLI provider (e.g., prometheus-sli-service) starts fetching values from monitoring tool
        -> SLI Provider (e.g., prometheus-sli-service) sends sh.keptn.event.get-sli.finished
```

## Go-utils

*Note*: This is based on https://github.com/keptn-sandbox/keptn-service-template-go/pull/24

If you have been using `go-utils` without our `keptn-service-template-go`, please upgrade go-utils manually using
```
go get github.com/keptn/go-utils@v0.8.0
go mod tidy
```

There are many breaking changes introduced, most notably:

* Using new Keptn Spec 0.2.0 from `github.com/keptn/go-utils/pkg/lib/v0_2_0` instead of `github.com/keptn/go-utils/pkg/lib`
* Using CloudEvents `github.com/cloudevents/sdk-go/v2` instead of `github.com/cloudevents/sdk-go/pkg/cloudevents`
* All Keptn CloudEvents have appropriate constants and structs in `github.com/keptn/go-utils/pkg/lib/v0_2_0`
* Processing Keptn CloudEvents requires sending a `.started` and `.finished` CloudEvent with `triggeredid` set to the original event id
* Keptn CloudEvents Payload has been adapted to spec 0.2.0
* Fetching (required) resources (and senidng the required `.finished` CloudEvent)
* EventBroker was removed from configuration

What does this mean for your code?

### Using pkg/lib/v0_2_0 instead of pkg/lib

Previously, you might have had the following import in your Go Code:

```golang
import (
    keptn "github.com/keptn/go-utils/pkg/lib"
)
```

Change this to
```golang
import (
    keptnv2 "github.com/keptn/go-utils/pkg/lib/v0_2_0"
)
```

If you want to have both, we recommend using it like this:
```golang
import (
    keptn "github.com/keptn/go-utils/pkg/lib"
    keptnv2 "github.com/keptn/go-utils/pkg/lib/v0_2_0"
)
```

Make sure to adapt all occurances where you used `keptn.` (e.g., `keptn.Keptn` and `keptn.NewKeptn`) accordingly, e.g.:

```golang
myKeptn, err := keptn.NewKeptn(&event, keptnOptions)
```

should now be

```golang
myKeptn, err := keptnv2.NewKeptn(&event, keptnOptions)
```

Also, for functions, you should change it accordingly, e.g.:

```golang
func HandleGetSLIEvent(myKeptn *keptn.Keptn, incomingEvent cloudevents.Event, data *keptn.InternalGetSLIEventData) error {
...
}
```

should be adapted to
```golang
func HandleGetSLIEvent(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data *keptnv2.GetSLITriggeredEventData) error {
...
}
```

### Add ServiceName in main.go

As a best practice, it's good to have serviceName in a const:
```golang
// ServiceName specifies the current services name (e.g., used as source when sending CloudEvents)
const ServiceName = "your-service-name"
```

### Using CloudEvents `github.com/cloudevents/sdk-go/v2`

This change is required to be compatible with the latest Keptn CloudEvents spec. All you need to do is replace your imports, e.g.:
```golang
import (
    "github.com/cloudevents/sdk-go/pkg/cloudevents"
)
```
should be replaced with
```golang
import (
 	cloudevents "github.com/cloudevents/sdk-go/v2" // make sure to use v2 cloudevents here
)
```

### All Keptn CloudEvents have appropriate constants and structs

Considering you have imported the updated go-utils and CloudEvents like this

```golang
import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"

    cloudevents "github.com/cloudevents/sdk-go/v2" // make sure to use v2 cloudevents here
    keptnv2 "github.com/keptn/go-utils/pkg/lib/v0_2_0"
)

// ServiceName specifies the current services name (e.g., used as source when sending CloudEvents)
const ServiceName = "keptn-service-template-go"
```

a series of constants, functions, and structs will be available for processing Keptn CloudEvents, which is demonstrated by the following example:

```golang
func parseKeptnCloudEventPayload(event cloudevents.Event, data interface{}) error {
	err := event.DataAs(data)
	if err != nil {
		log.Fatalf("Got Data Error: %s", err.Error())
		return err
	}
	return nil
}

func processKeptnCloudEvent(ctx context.Context, event cloudevents.Event) error {
    switch event.Type() {
	// sh.keptn.event.get-sli
	case keptnv2.GetTriggeredEventType(keptnv2.GetSLITaskName): // sh.keptn.event.get-sli.triggered
		log.Printf("Processing Get-SLI.Triggered Event")

		eventData := &keptnv2.GetSLITriggeredEventData{} // Data Structure for Get-SLI Triggered Event
		parseKeptnCloudEventPayload(event, eventData)

		return HandleGetSliTriggeredEvent(myKeptn, event, eventData)

	// sh.keptn.event.deployment
	case keptnv2.GetTriggeredEventType(keptnv2.DeploymentTaskName): // sh.keptn.event.deployment.triggered
		log.Printf("Processing Deployment.Triggered Event")

		eventData := &keptnv2.DeploymentTriggeredEventData{}
		parseKeptnCloudEventPayload(event, eventData)

		return HandleDeploymentTriggeredEvent(myKeptn, event, eventData)
        }
    return nil
}

func HandleGetSliTriggeredEvent(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data *keptnv2.GetSLITriggeredEventData) error {
	log.Printf("Handling get-sli.triggered Event: %s", incomingEvent.Context.GetID())
	return nil
}

func HandleDeploymentTriggeredEvent(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data *keptnv2.DeploymentTriggeredEventData) error {
	log.Printf("Handling deployment.triggered Event: %s", incomingEvent.Context.GetID())
	return nil
}
```

*Note*: The full source code of those example is available in our [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).

### Sending CloudEvents

While in keptn/go-utils 0.7.x you had to take care of sending CloudEvents in the correct format, we have tried to hide this complexity by introducing helper functions in keptn/go-utils 0.8.x.

For instance, sending a deployment-finished event in 0.7.x looked like this:
```golang

	source, _ := url.Parse("helm-service")
	contentType := "application/json"

	var deploymentStrategyOldIdentifier string
	if deploymentStrategy == keptnevents.Duplicate {
		deploymentStrategyOldIdentifier = "blue_green_service"
	} else {
		deploymentStrategyOldIdentifier = "direct"
	}

	depFinishedEvent := keptnevents.DeploymentFinishedEventData{
		Project:            keptnHandler.KeptnBase.Project,
		Stage:              keptnHandler.KeptnBase.Stage,
		Service:            keptnHandler.KeptnBase.Service,
		TestStrategy:       testStrategy,
		DeploymentStrategy: deploymentStrategyOldIdentifier,
		Image:              image,
		Tag:                tag,
		Labels:             labels,
		DeploymentURILocal: [],
    	DeploymentURIPublic: []
	}
	

	event := cloudevents.Event{
		Context: cloudevents.EventContextV02{
			ID:          uuid.New().String(),
			Time:        &types.Timestamp{Time: time.Now()},
			Type:        keptnevents.DeploymentFinishedEventType,
			Source:      types.URLRef{URL: *source},
			ContentType: &contentType,
			Extensions:  map[string]interface{}{"shkeptncontext": keptnHandler.KeptnContext},
		}.AsV02(),
		Data: depFinishedEvent,
	}

	err := keptnHandler.SendCloudEvent(event)

	if err != nil {
        errMsg := fmt.Sprintf("Failed to send task finished CloudEvent (%s), aborting...", err.Error())
        log.Println(errMsg)
	}
```

With 0.8.x it looks like this:
```golang
    ServiceName := "helm-service"
    
	deploymentFinishedEventData := &keptnv2.DeploymentFinishedData{
		DeploymentURIsLocal: ["http://a.b.c.d/foobar"],
	}

	_, err = myKeptn.SendTaskFinishedEvent(deploymentFinishedEventData, ServiceName)

	if err != nil {
		errMsg := fmt.Sprintf("Failed to send task finished CloudEvent (%s), aborting...", err.Error())
		log.Println(errMsg)
	}
```

### Processing Keptn CloudEvents requires sending a `.started` and `.finished` CloudEvent with `triggeredid` set to the original event id

Continuing on the previous example, if you were to implement the `HandleGetSliTriggeredEvent`, you are required to send a `.started` event when you start, and a `.finished` event when you have finished handling (and optionally, there is also a `.status.changed` event, if you need/want it).

The following is a shortened example for handling an `sh.keptn.event.action.triggered` event:

```golang
// HandleActionTriggeredEvent handles action.triggered events
// TODO: add in your handler code
func HandleActionTriggeredEvent(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data *keptnv2.ActionTriggeredEventData) error {
	log.Printf("Handling Action Triggered Event: %s", incomingEvent.Context.GetID())
	log.Printf("Action=%s\n", data.Action.Action)

	// check if action is supported
	if data.Action.Action == "action-xyz" {
		// -----------------------------------------------------
		// 1. Send Action.Started Cloud-Event
		// -----------------------------------------------------
		myKeptn.SendTaskStartedEvent(data, ServiceName)

		// -----------------------------------------------------
		// 2. Implement your remediation action here
		// -----------------------------------------------------
		time.Sleep(5 * time.Second) // Example: Wait 5 seconds. Maybe the problem fixes itself.

		// -----------------------------------------------------
		// 3. Send Action.Finished Cloud-Event
		// -----------------------------------------------------
		myKeptn.SendTaskFinishedEvent(&keptnv2.EventData{
			Status: keptnv2.StatusSucceeded, // alternative: keptnv2.StatusErrored
			Result: keptnv2.ResultPass, // alternative: keptnv2.ResultFailed
			Message: "Successfully sleeped!",
		}, ServiceName)

	} else {
		log.Printf("Retrieved unknown action %s, skipping...", data.Action.Action)
		return nil
	}
	return nil
}
```

The following is a more comprehensive example for an SLI provider that provides dummy values:
```golang
// HandleGetSliTriggeredEvent handles get-sli.triggered events if SLIProvider == keptn-service-template-go
// This function acts as an example showing how to handle get-sli events by sending .started and .finished events
// TODO: adapt handler code to your needs
func HandleGetSliTriggeredEvent(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data *keptnv2.GetSLITriggeredEventData) error {
	log.Printf("Handling get-sli.triggered Event: %s", incomingEvent.Context.GetID())
	
	// Step 1 - Do we need to do something?
	// Lets make sure we are only processing an event that really belongs to our SLI Provider
	if data.GetSLI.SLIProvider != "keptn-service-template-go" {
		log.Printf("Not handling get-sli event as it is meant for %s", data.GetSLI.SLIProvider)
		return nil
	}

	// Step 2 - Send out a get-sli.started CloudEvent
	// The get-sli.started cloud-event is new since Keptn 0.8.0 and is required to be send when the task is started
	_, err := myKeptn.SendTaskStartedEvent(data, ServiceName)

	if err != nil {
		errMsg := fmt.Sprintf("Failed to send task started CloudEvent (%s), aborting...", err.Error())
		log.Println(errMsg)
		return err
	}

	// Step 4 - prep-work
	// Get any additional input / configuration data
	// - Labels: get the incoming labels for potential config data and use it to pass more labels on result, e.g: links
	// - SLI.yaml: if your service uses SLI.yaml to store query definitions for SLIs get that file from Keptn
	labels := data.Labels
	if labels == nil {
		labels = make(map[string]string)
	}
	testRunID := labels["testRunId"]

	// Step 5 - get SLI Config File
	// Get SLI File from keptn-service-template-go subdirectory of the config repo - to add the file use:
	//   keptn add-resource --project=PROJECT --stage=STAGE --service=SERVICE --resource=my-sli-config.yaml  --resourceUri=keptn-service-template-go/sli.yaml
	sliFile := "keptn-service-template-go/sli.yaml"
	sliConfigFileContent, err := myKeptn.GetKeptnResource(sliFile)

	// FYI you do not need to "fail" if sli.yaml is missing, you can also assume smart defaults like we do
	// in keptn-contrib/dynatrace-service and keptn-contrib/prometheus-service
	if err != nil {
		// failed to fetch sli config file
		errMsg := fmt.Sprintf("Failed to fetch SLI file %s from config repo: %s", sliFile, err.Error())
		log.Println(errMsg)
		// send a get-sli.finished event with status=error and result=failed back to Keptn

		_, err = myKeptn.SendTaskFinishedEvent(&keptnv2.EventData{
			Status: keptnv2.StatusErrored,
			Result: keptnv2.ResultFailed,
		}, ServiceName)

		return err
	}

	fmt.Println(sliConfigFileContent)

	// Step 6 - do your work - iterate through the list of requested indicators and return their values
	// Indicators: this is the list of indicators as requested in the SLO.yaml
	// SLIResult: this is the array that will receive the results
	indicators := data.GetSLI.Indicators
	sliResults := []*keptnv2.SLIResult{}

	for _, indicatorName := range indicators {
		sliResult := &keptnv2.SLIResult{
			Metric: indicatorName,
			Value:  123.4, // ToDo: Fetch the values from your monitoring tool here
		}
		sliResults = append(sliResults, sliResult)
	}

	// Step 7 - add additional context via labels (e.g., a backlink to the monitoring or CI tool)
	labels["Link to Data Source"] = "https://mydatasource/myquery?testRun=" + testRunID

	// Step 8 - Build get-sli.finished event data
	getSliFinishedEventData := &keptnv2.GetSLIFinishedEventData{
		EventData: keptnv2.EventData{
			Status:  keptnv2.StatusSucceeded,
			Result:  keptnv2.ResultPass,
		},
		GetSLI: keptnv2.GetSLIFinished{
			IndicatorValues: sliResults,
			Start:           data.GetSLI.Start,
			End:             data.GetSLI.End,
		},
	}

	_, err = myKeptn.SendTaskFinishedEvent(getSliFinishedEventData, ServiceName)

	if err != nil {
		errMsg := fmt.Sprintf("Failed to send task finished CloudEvent (%s), aborting...", err.Error())
		log.Println(errMsg)
		return err
	}

	return nil
}
```

*Note*: The full source code of those example is available in our [keptn-service-template-go](https://github.com/keptn-sandbox/keptn-service-template-go).

### Fetching (required) resources

Fetching resources using go-utils works as it used to before. What's new is that you should send a `.finished` event with status=error and result=failed in case you require the file to continue:
```golang
    myKeptn, err := keptnv2.NewKeptn(&event, keptnOptions)
    
    sliFile := "keptn-service-template-go/sli.yaml"
	sliConfigFileContent, err := myKeptn.GetKeptnResource(sliFile)

	// FYI you do not need to "fail" if sli.yaml is missing, you can also assume smart defaults like we do
	// in keptn-contrib/dynatrace-service and keptn-contrib/prometheus-service
	if err != nil {
		// failed to fetch sli config file
		errMsg := fmt.Sprintf("Failed to fetch SLI file %s from config repo: %s", sliFile, err.Error())
		log.Println(errMsg)
		// send a get-sli.finished event with status=error and result=failed back to Keptn

		_, err = myKeptn.SendTaskFinishedEvent(&keptnv2.EventData{
			Status: keptnv2.StatusErrored,
			Result: keptnv2.ResultFailed,
		}, ServiceName)

		return err
	}

```

### Eventbroker was removed from configuration

You can safely remove any occurance of EventBroker (`envConfig` and `keptnOptions`).

```golang
type envConfig struct {
	// Port on which to listen for cloudevents
	Port int `envconfig:"RCV_PORT" default:"8080"`
	// Path to which cloudevents are sent
	Path string `envconfig:"RCV_PATH" default:"/"`
	// Whether we are running locally (e.g., for testing) or on production
	Env string `envconfig:"ENV" default:"local"`
	// URL of the Keptn configuration service (this is where we can fetch files from the config repo)
	ConfigurationServiceUrl string `envconfig:"CONFIGURATION_SERVICE" default:""`
}
...

keptnOptions.ConfigurationServiceURL = env.ConfigurationServiceUrl
```

Make sure to also remove the environment variable from deploy/service.yaml, e.g.,
```yaml
          env:
            - name: EVENTBROKER
              value: 'http://event-broker.keptn.svc.cluster.local/keptn'
            - name: CONFIGURATION_SERVICE
              value: 'http://configuration-service.keptn.svc.cluster.local:8080'
```

should become
```yaml
          env:
            - name: CONFIGURATION_SERVICE
              value: 'http://configuration-service.keptn.svc.cluster.local:8080'
```



## Distributor

The [keptn/distributor](https://github.com/keptn/keptn/tree/release-0.8.0/distributor) connects a Keptn-microservice with our message-queue NATS (for external services this is handled via the Keptn API).

For 0.8.0, most notably we have introduced the following changes:
* Manifest for distributor has been adapted to use `keptn/distributor:0.8.0`, e.g.: https://github.com/keptn-contrib/prometheus-service/blob/2ab67e937a0d2663f5fc9dae43f64293d2fbb932/deploy/service.yaml#L224-L225
* Manifest for distributor has been adapted to reduce resource limits (CPU and memory) to a more realistic value: https://github.com/keptn-contrib/prometheus-service/blob/2ab67e937a0d2663f5fc9dae43f64293d2fbb932/deploy/service.yaml#L228-L234
* Event types have been changed (e.g., from `sh.keptn.events.` to `sh.keptn.event.`) - make sure to subscribe to the correct types (e.g., *all*  types using `PUBSUB_TOPIC="sh.keptn.>"`)

You can also just copy the following code snippet into your Kubernetes manifest to use the distributor:
```yaml
...
        - name: distributor
          image: keptn/distributor:0.8.0
          livenessProbe:
            httpGet:
              path: /health
              port: 10999
            initialDelaySeconds: 5
            periodSeconds: 5
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
          resources:
            requests:
              memory: "16Mi"
              cpu: "25m"
            limits:
              memory: "32Mi"
              cpu: "50m"
          env:
            - name: PUBSUB_URL
              value: 'nats://keptn-nats-cluster'
            - name: PUBSUB_TOPIC
              value: 'sh.keptn.>'
            - name: PUBSUB_RECIPIENT
              value: '127.0.0.1'
```

## Keptn-Service-Template-Go

**Note**: Depending on the complexity of your service it might be easier to start over from https://github.com/keptn-sandbox/keptn-service-template-go and just modify the relevant eventhandlers.

### main.go

Heavy refactoring was done in main.go. If you can, copy the content from https://github.com/keptn-sandbox/keptn-service-template-go. If not, here is a short guide on what has changed:

* **Removed EventBrokerUrl** in `envConfig` and in `keptnOptions`
* **Introduced ServiceName as a const**
    ```golang
    // ServiceName specifies the current services name (e.g., used as source when sending CloudEvents)
    const ServiceName = "keptn-service-template-go" // replace with your service name
    ```
* **Introduce cloud-event parse function** with error handling, to reduce code duplication
    ```golang
    /**
     * Parses a Keptn Cloud Event payload (data attribute)
     */
    func parseKeptnCloudEventPayload(event cloudevents.Event, data interface{}) error {
        err := event.DataAs(data)
        if err != nil {
            log.Fatalf("Got Data Error: %s", err.Error())
            return err
        }
        return nil
    }
    ```
* **Use keptnv2** for most things, e.g.:
    ```golang
    import (
        keptnv2 "github.com/keptn/go-utils/pkg/lib/v0_2_0"
    )
    
    myKeptn, err := keptnv2.NewKeptn(&event, keptnOptions)
    
    switch event.Type() {
    
        // -------------------------------------------------------
        case keptnv2.GetTriggeredEventType(keptnv2.TestTaskName): // sh.keptn.event.test.triggered
        log.Printf("Processing Test.Triggered Event")
        
        eventData := &keptnv2.TestTriggeredEventData{}
        parseKeptnCloudEventPayload(event, eventData)
        
        return HandleTestsTriggered(myKeptn, event, eventData)
        ...
    }
    ```
* **func _main(...) uses cloudevents.NewClient** to run the http events endpoint
    ```golang
    func _main(args []string, env envConfig) int {
        // configure keptn options
        if env.Env == "local" {
            log.Println("env=local: Running with local filesystem to fetch resources")
            keptnOptions.UseLocalFileSystem = true
        }
    
        keptnOptions.ConfigurationServiceURL = env.ConfigurationServiceUrl
        
        ctx := context.Background()
        ctx = cloudevents.WithEncodingStructured(ctx)
        
        // configure http server to receive cloudevents
        p, err := cloudevents.NewHTTP(cloudevents.WithPath(env.Path), cloudevents.WithPort(env.Port))
    
        if err != nil {
            log.Fatalf("failed to create client, %v", err)
        }
        c, err := cloudevents.NewClient(p)
        if err != nil {
            log.Fatalf("failed to create client, %v", err)
        }
    
        log.Printf("Starting receiver")
        log.Fatal(c.StartReceiver(ctx, processKeptnCloudEvent))
    
        return 0
    }
    ```


### eventhandlers.go

We have introduced a new helper function to log CloudEvents to console:
```golang
// GenericLogKeptnCloudEventHandler is a generic handler for Keptn Cloud Events that logs the CloudEvent
func GenericLogKeptnCloudEventHandler(myKeptn *keptnv2.Keptn, incomingEvent cloudevents.Event, data interface{}) error {
	log.Printf("Handling %s Event: %s", incomingEvent.Type(), incomingEvent.Context.GetID())
	log.Printf("CloudEvent %T: %v", data, data)

	return nil
}
```
Other than that, please follow the changes detailed above for Keptn CloudEvents, `go-utils` and `distributor`, as shown above.


## Changes required for SLI-Provider

The most important changes when migrating an SLI provider from 0.7.x to 0.8.x are:

* The SLI provider needs to send a `sh.keptn.event.get-sli.started` *and* `sh.keptn.event.get-sli.finished` event (e.g., using `myKeptn.SendTaskStartedEvent`) - see [keptn-service-template-go/eventhandlers.go](https://github.com/keptn-sandbox/keptn-service-template-go/blob/54086a16c04d01570c1e82a4c8b1cf69f06b02c6/eventhandlers.go#L103-L111))

Please refer to the changes shown above regarding go-utils.

## Changes required for action-provider

Prior to 0.8.x, action providers already needed to send `sh.keptn.event.action.started` and `sh.keptn.event.action.finished` events.

We recommend upgrading to the latest version of keptn/go-utils to be compatible with Keptn CloudEvents and its structures. Please refer to the changes shown above regarding go-utils.

## Breaking changes in API and CLI

In case your integration has been using the CLI or the API, please refer to [the official release notes](https://github.com/keptn/keptn/releases/tag/0.8.0) for more details.
