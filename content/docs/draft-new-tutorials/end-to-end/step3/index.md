---
title: Add manual approval
description: Add manual approval step before promoting the artifact
weight: 40
---

Add a step to the delivery sequence which enforces that a user must manually click ✅
before an artifact is promoted to production.

# Clone keptndemo Repo

Clone your demo repo locally so we can work with it:

```
cd ~
gh repo clone $GIT_REPO
cd ~/$GIT_NEW_REPO_NAME
git fetch && git checkout main
```


Add a new task to the shipyard.yaml file on `main` branch.

In the Keptn `production` stage, before the `je-deployment` task, add:

```
- name: "approval"
  properties:
    pass: "manual"
    warning: "manual"
```

```
cd ~/$GIT_NEW_REPO_NAME
cat << EOF > ~/$GIT_NEW_REPO_NAME/shipyard.yaml
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
EOF
git remote set-url origin https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
git config --global user.email "keptn@keptn.sh"
git config --global user.name "Keptn"
git add -A
git commit -m "add approval step to production"
git push
```{{exec}}

## Deliver Artifact

Run the same command as before to trigger delivery of an artifact.

```
keptn trigger delivery \
--project=fulltour \
--service=helloservice \
--image="ghcr.io/podtato-head/podtatoserver:v0.1.1" \
--labels=image="ghcr.io/podtato-head/podtatoserver",version="v0.1.1"
```

## Approve Production Release

The artifact will be released into `qa` as before but the sequence now turns blue.

Manual interaction is required.

The sequence will pause here for as long as required.

![artifact-approval-1](./assets/approval-step-1.jpg)
![artifact-approval-1](./assets/approval-step-2.jpg)

Click the `production` link then inside the approval step,
click ✅ to approve the build.
Watch as the deployment begins, again via `helm`, facilitated by the job executor service.

![production approval](./assets/production-approval.jpg)

----

## Summary

A new task was added to the shipyard file called `approval`.
When it was time to action this task,
Keptn created and distributed a cloudevent of type `sh.keptn.event.approval.triggered`.
The [approval service](https://github.com/keptn/keptn/tree/master/approval-service)
is a Keptn core microservice which listens for and actions this event.

The `properties` block in the shipyard file tell the approval service
that a manual approval is required regardless of the success / fail output of the preceding task.

The `approval.finished` event will not be sent back to keptn until user input has been received
and so the `je-deployment` task is not actioned until after a user clicks to approve.

----

## What Next?

Blindly promoting artifacts to production and requiring manual approvals before each deployment
are at opposite ends of the spectrum.
One is dangerous, the other slows innovation. Is there a safer middle ground?

Perhaps an artifact is allowed to go into production if it passes the evaluation
but manual approval is required if the quality evaluation is a warning or a failure.

In the next step, keptn will introduce "guard rails" in this process.
The `helloservice` application will be monitored and releases will be programatically approved / declined
based on a quality signature defined by you and calculated by keptn.
