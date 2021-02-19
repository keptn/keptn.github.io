---
title: Customize a Shipyard
description: Adapt the Shipyard depending on your processes.
weight: 25
keywords: [0.8.x-manage]
aliases:
---

After creating a project, you can change the shipyard as explained here. 


The most convenient way to change your shipyard is by directly adapting it in the Git *upstream* repository. 

* If you do not have a Git upstream set for your project, then please set one since it is the recommended way of using Keptn: [configure Git upstream](../../manage/git_upstream/#create-keptn-project-or-set-git-upstream).

* If you have no Git repository to set an *upstream*, you can finally update the shipyard using: 

  ```
  keptn add-resource --project=PROJECT --resource=./shipyard.yaml --resourceUri=./shipyard.yaml
  ```

:warning: Do not modify your shipyard in ways that are *not* mentioned in this section. 

:warning: Make sure to have no running sequence while you are updating the shipyard. Otherwise, running sequences will be updated.


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

**Use-case:** To intervene in the delivery process, I would like to add an `approval` task before the `release` task.

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

**Result:** The next time this sequence gets triggered by Keptn, the task will be executed meaning that a `sh.keptn.event.[task].triggered` event is sent out. Make sure to have a Keptn-service that listens to this event type and can execute it. 

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

**Use-case:** I would like to add an additional delivery process to the production stage that allows rolling-out a hotfix without testing and evaluation. 

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

**Result:** After extending the shipyard as shown above, you can trigger this sequence using: 

```
keptn trigger delivery --project=<project> --service=<service> --image=<image> --tag=<tag> --sequence=hotfix-delivery
```

## Define a trigger for a sequence 

An advanced and powerful feature of the shipyard is that you can define *triggers* to kick-off a sequence. Therefore, a sequence offers the `triggeredOn` property where a list of events can be specified. The event type you can list there are events that refer to the status of a sequence execution. Their name follows the pattern:

* `[stage_name].[sequence_name].finished` 

*Note:* It is not required to specify the full qualified event name which would be `sh.keptn.event.[stage_name].[sequence_name].finished` in this case

Besides, a *match selector* can be added to an event that works as a filter on the `result` property of the event. Consequently, you can filter based on sequence executions that *failed* or *passed*, shown by the next example that filters on `failed`: 

```
sequences:
  - name: "rollback"
    triggeredOn:
      - event: "production.delivery.finished"
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

**Use-case:** I would like to add a process (additional sequence) that covers a failed delivery in the production stage by a notification and rollback task. 

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
          triggeredOn:
            - event: "production.delivery.finished"
                selector:
                  match:
                    result: failed
          tasks:
            - name: "notification"
            - name: "rollback"
```

**Result:** When, for example, the *delivery* sequence failed due to a failed test task, the event `sh.keptn.event.production.delivery.finished` with `result=failed` is sent out. Consequently, the *rollback* sequence is triggered based on the configuration of the `triggeredOn` and selector.
