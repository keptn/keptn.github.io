---
title: Add manual production approval
description: Test and evaluate your software
weight: 30
---


This is step 2 of the tutorial. If you missed step 1, [start here first](full-tour.md).

## Manual Approval

Add a step to the delivery sequence which enforces that a user must manually click ✅ before an artifact is promoted to production.

In your Git upstream repo, modify `shipyard.yaml` on the `main` branch. Add a new task in `production` before the `je-deployment` task:

```
- name: "approval"
  properties:
    pass: "manual"
    warning: "manual"
```

Your shipyard should now look like this:
```
apiVersion: "spec.keptn.sh/0.2.2"
kind: "Shipyard"
metadata:
  name: "shipyard-delivery"
spec:
  stages:
    - name: "qa"
      sequences:
        - name: "delivery"
          tasks:
            - name: "je-deployment"
            - name: "je-test"

    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "qa.delivery.finished"
          tasks:
            - name: "approval"
              properties:
                pass: "manual"
                warning: "manual"
            - name: "je-deployment"
```

## Deliver Artifact

In the [web terminal](http://localhost:{{ site.ttyd_port }}) run the same command as before to trigger delivery of an artifact.

{% include full_tour_trigger_delivery_good_version.md %}

## Approve Production Release

The artifact will be released into `qa` as before but the sequence now turns blue.

Manual interaction is required.

The sequence will pause here for as long as required.

![artifact-approval-1](assets/approval-step-1.jpg)
![artifact-approval-1](assets/approval-step-2.jpg)

Click the `production` link then inside the approval step, click ✅ to approve the build. Watch as the deployment begins, again via `helm`, facilitated by the job executor service.

![production approval](assets/production-approval.jpg)

----

## Summary

A new task was added to the shipyard file called `approval`. When it was time to action this task, keptn created and distributed a cloudevent of type `sh.keptn.event.approval.triggered`. The [approval service](https://github.com/keptn/keptn/tree/master/approval-service) is a keptn core microservice which listens for and actions this event.

The `properties` block in the shipyard file tell the approval service that a manual approval is required regardless of the success / fail output of the preceding task.

The `approval.finished` event will not be sent back to keptn until user input has been received and so the `je-deployment` task is not actioned until after a user clicks approve.

----

## Next Steps

Blindly promoting artifacts to production and requiring manual approvals before each deployment are at opposite ends of the spectrum. One is dangerous, the other slows innovation. Is there a safer middle ground?

Perhaps an artifact is allowed to go into production if it passes the evaluation but manual approval is required if the quality evaluation is a warning or a failure.

In the next step, keptn will introduce "guard rails" in this process. The `helloservice` application will be monitored and releases will be programatically approved / declined based on a quality signature defined by you and calculated by keptn.

Continue to [add automated quality evaluations >>](full-tour-3-qa-evaluation.md)



