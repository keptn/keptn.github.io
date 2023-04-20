---
title: Run tasks in parallel
description: Strategies to run tasks in parallel
weight: 170
keywords: [1.0.x-manage]
aliases:
- /docs/1.0.x/manage/parallel/
---

Sequences that use the same service cannot be run in parallel.
If you simultaneously trigger multiple sequences for the same service,
they are queued to run sequentially.
Sequences for different services can be run in parallel.
This is possible when you have different automation projects
or if you have multiple services within a project.

You can run tasks in parallel by putting them in different stages,
each of which is triggered from the previous stage.
The following [shipyard](../../reference/files/shipyard/) illustrates this.
Here, you see we have three stages:

* `hardening`
* `load-test-1`
* `load-test-2`

Both `load-test-1` and `load-test-2` are triggered
by the `hardening.delivery.finished` event
so will run in parallel.

```yaml
apiVersion: "spec.keptn.sh/0.2.3"
kind: "Shipyard"
metadata:
  name: "shipyard-example-parallel-tasks"
spec:
  stages:
    - name: "hardening"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct"
            - name: "evaluation"
            - name: "release"
    - name: "load-test-1"
      sequences:
        - name: "load-test"
          triggeredOn:
            - event: "hardening.delivery.finished"
          tasks:
            - name: "my-load-test-configuration"
    - name: "load-test-2"
      sequences:
        - name: "load-test"
          triggeredOn:
            - event: "hardening.delivery.finished"
          tasks:
            - name: "my-load-test-configuration"
```
