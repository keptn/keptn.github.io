---
title: Update project's shipyard
description: How to modify the projects shipyard
weight: 25
keywords: [1.0.x-manage]
aliases:
---

A Keptn project's [shipyard](../../reference/files/shipyard) can be modified in two ways:

* [Delete the project](../delete) then [create a new project](../project/#create-a-project)
  that contains the updated settings.
* Modify the project files that are stored in the [Git *upstream* repository](../git_upstream)

:warning: Only modify your shipyard in ways mentioned in this section.

:warning: Make sure to have no running sequence while you are updating the shipyard. Otherwise, running sequences will be updated.

The following updates of shipyard.yaml are currently supported by Keptn:

* Add/Remove a task to/from a task sequence
* Add/Remove a task sequence to/from a stage
* Define a trigger for a sequence 

You can not add or delete stages in the *shipyard* file for an existing project
although you can make other modifications.

**Initial shipyard**

The following sections illustrate how to do each of these updates.
These are all based on an initial *shipyard* that contains the following:

```
apiVersion: "spec.keptn.sh/0.2.3"
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

**Add a task to a task sequence**

This adds an `approval` task before the `release` task:

```
apiVersion: "spec.keptn.sh/0.2.3"
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

**Add an additional delivery process to the `production` stage**

The following *shipyard* is modified to add an additional delivery process
to the production stage that allows rolling-out a hotfix without testing and evaluation.

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
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

After extending the shipyard as shown above, you can trigger this sequence using:

```
keptn trigger delivery --project=<project> --service=<service> --image=<image> --tag=<tag> --sequence=hotfix-delivery
```

**Add a remediation sequence**

The following *shipyard* adds a `remediation` sequence to the `production` stage
that allows executing remediation actions when problems occur:

*Updated shipyard:*

```
apiVersion: "spec.keptn.sh/0.2.3"
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

        - name: "remediation"
          triggeredOn:
            - event: "production.remediation.finished"
              selector:
                match:
                  evaluation.result: "fail"
          tasks:
            - name: "get-action"
            - name: "action"
            - name: "evaluation"
              triggeredAfter: "10m"
              properties:
                timeframe: "10m"
```

After extending the shipyard as shown above,
remediations should be executed when a problem event is retrieved.
See [Remediation sequences](../../define/remediation-sequence).



