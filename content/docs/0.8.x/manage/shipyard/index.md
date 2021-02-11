---
title: Customize a Shipyard
description: Adapt the Shipyard depending on your processes.
weight: 25
keywords: [0.8.x-manage]
aliases:
---

After creating a project, you can change the shipyard as explained here. Please do not modify your shipyard in ways that are *not* mentioned in this section. 


The most convenient way to change your shipyard is by directly changing it in the Git *upstream* repository. 

* *You have no Git upstream configured?* Then please do so, as it is the recommended way of using Keptn: [set Git upstream](../../manage/git_upstream/#create-keptn-project-or-set-git-upstream).

* If you have no Git repository to set an *upstream*, you can finally update the shipyard using: 

  ```
  keptn add-resource --project=PROJECT --resource=./shipyard.yaml --resourceUri=./shipyard.yaml
  ```

:warning: Please make sure to have no running sequence while you are updating a shipyard. Otherwise, running sequences will be updated.

## Add/Remove a task to/from a task sequence

If you want to add or remove an additional task to a sequence, you can do this by adding/removing the task directly in the shipyard: 

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Example:** I would like to add an approval step before the `release` task to control the roll-out. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "approval"
            - name: "release"
```

**Consequence:** The next time this sequence gets triggered by Keptn, the task will be executed meaning that a `sh.keptn.event.[task].triggered` event is sent out. Make sure to have a Keptn-service that listens to this event type and can execute it. 

## Add/Remove a task sequence to/from a stage

If you want to add or remove an additional task sequence to a stage, you can do this by adding/removing the sequence directly in the shipyard: 

*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Example:** I would like to add an additional delivery process to a stage that allows rolling-out a hotfix without testing and evaluation. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

        - name: "hotfix-delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

## Define a trigger for a sequence 

An advanced and powerful feature of the shipyard is that you can define the triggers *on* when to kick-off a sequence. Therefore, a sequence offers the `on` property where a list of events can be specified. The event type you can list there are events that refer to the status of a sequence execution. Their name follows the pattern:

* `sh.keptn.event.[stage_name].[sequence_name].finished` 

Besides, a *match selector* can be added to an event that works as a filter on the `result` property of the event. Consequently, you can filter based on sequence executions that failed or passed, shown by the next example that filters on `failed`: 

```
sequences:
  - name: "rollback"
    on:
    - sh.keptn.event.production.delivery.finished:
        selector:
          match:
            result: failed
```


*Initial shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"
```

**Example:** I would like to add a process (additional sequence) that covers a failed delivery in the production stage by a notification and rollback task. 

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.0"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

        - name: "rollback"
          on:
          - sh.keptn.event.production.delivery.finished:
              selector:
                match:
                  result: failed
          tasks:
            - name: "notification"
            - name: "rollback"
```