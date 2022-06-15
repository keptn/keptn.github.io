---
title: Self-healing (remediation)
description: Implement self-healing for released software
weight: 70
---

So far, a fairly robust delivery pipeline has been built. Optional manual approval steps have been added, automated quality gates were then added to automate and improve on the previous manual approval.
Finally, release validation was added to run quality evaluations **after** a production release and ensure quality software **in** production.

This step adds the ability to Keptn to self-heal your application based on problems sent to Keptn.

## Scenario

Imagine the application has a known response time problem in production. It can be fixed by scaling the pods - at least until development has a chance to look into the issue.

We will add steps into our Keptn setup to:
1. Scale the pods (using Helm to upgrade the deployment) when a response time problem is received.
2. Use `locust` to generate some new load after the deployment has been scaled
3. Run a quality evaluation to see if the scaling has resolved the issue

> Note: The demo image doesn't actually have a problem pattern that resolves with scaling. So **expect** the quality gate to still provide a warning. Scaling the pods **will** be successful.

## Add New Sequence to Shipyard

Modify the shipyard in the `main` branch of the Git upstream. Add a new sequence in `production` which will be triggered when a problem is received.
This sequence will recursively self-trigger every 2 minutes until the evaluation is in a `pass` or `warning` state. This allows for escalating self-healing actions.

Add this block to the `production` stage:
```
- name: "remediation"
  triggeredOn:
    - event: "production.remediation.finished"
      selector:
        match:
          evaluation.result: "fail"
      tasks:
        - name: "get-action"
        - name: "action"
        - name: "je-test"
        - name: "evaluation"
          properties:
            timeframe: "2m"
```

Run this to modify and push to the Git repo:

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
            - name: "evaluation"
              properties:
                timeframe: "2m"

    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "qa.delivery.finished"
          tasks:
            - name: "approval"
              properties:
                pass: "automatic"
                warning: "automatic"
            - name: "je-deployment"
            - name: "je-test"
            - name: "evaluation"
              properties:
                timeframe: "2m"

        - name: "remediation"
          triggeredOn:
            - event: "production.remediation.finished"
              selector:
                match:
                  evaluation.result: "fail"
          tasks:
            - name: "get-action"
            - name: "action"
            - name: "je-test"
            - name: "evaluation"
              properties:
                timeframe: "2m"
EOF
git remote set-url origin https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
git config --global user.email "keptn@keptn.sh"
git config --global user.name "Keptn"
git pull
git add -A
git commit -m "add self-healing to production"
git push
```

### Explanation

The `remediation` sequence:

1. Is triggered when a problem is sent to Keptn (you'll see this soon)
2. `get-action` retrieves the self-healing action from the `remediation.yaml` file (this will be created soon)
3. `action` uses the job executor service and `helm` to scale the `replicaCount` of the deployment
4. After scaling, job executor service again responds to `je-test` and uses `locust` to generate some load
5. A quality gate evaluation is executed to validate whether or not the scaling actually helped to resolve the issue (expect this to say `warning`)
6. If the quality gate fails, the sequence will be recursively called every 2 minutes until the evaluation fails.

## Create Remediation File

This file maps an incoming problem to the healing action that should occur.

For simplicity we have only one action, but multiple actions per problem type are possible. Keptn will try them in order, which means you can try less invasive resolutions first, escalating them if they fail.

The important parts here are `problemType` denotes the name of the problem type we are expecting to be sent (from an external feed or observability platform). The `action` denotes what we do when this problem type is received and the `value` will be used to tell `helm` how many replicas are required in the new deployment.

```
cd ~/$GIT_NEW_REPO_NAME
git checkout --track origin/production
cat << EOF > helloservice/remediation.yaml
apiVersion: spec.keptn.sh/0.1.4
kind: Remediation
metadata:
  name: helloservice-remediation
spec:
  remediations:
    - problemType: http_response_time_seconds_main_page_sum
      actionsOnOpen:
        - action: scale
          name: scale
          description: Scale up
          value: "2"
EOF
git remote set-url origin https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
git config --global user.email "keptn@keptn.sh"
git config --global user.name "Keptn"
git add -A
git commit -m "add remediation file to production"
git push
```

## Link Input to Action

Keptn now knows what it should *attempt* to do, but recall that Keptn itself doesn't actually **perform** the actions.

We need to bring a tool. We choose to use the job executor service which in turn will use `helm` to scale the deployment.

On the `production` branch of your Git upstream, modify `helloservice/job/config.yaml` and add a new `action`:

```
cd ~/$GIT_NEW_REPO_NAME
cat << EOF > helloservice/job/config.yaml
apiVersion: v2
actions:
  - name: "Deploy using helm"
    events:
      - name: "sh.keptn.event.je-deployment.triggered"
    tasks:
      - name: "Run helm"
        files:
          - /charts
        env:
          - name: IMAGE
            value: "$.data.configurationChange.values.image"
            valueFrom: event
        image: "alpine/helm:3.9.0"
        serviceAccount: "jes-deploy-using-helm"
        cmd: ["helm"]
        args: ["upgrade", "--create-namespace", "--install", "-n", "\$(KEPTN_PROJECT)-\$(KEPTN_STAGE)", "\$(KEPTN_SERVICE)", "/keptn/charts/\$(KEPTN_SERVICE).tgz", "--set", "image=\$(IMAGE)", "--wait"]

  - name: "Run tests using locust"
    events:
      - name: "sh.keptn.event.je-test.triggered"
    tasks:
      - name: "Run locust"
        files:
          - locust/basic.py
          - locust/locust.conf
        image: "locustio/locust:2.8.6"
        cmd: ["locust"]
        args: ["--config", "/keptn/locust/locust.conf", "-f", "/keptn/locust/basic.py", "--host", "http://\$(KEPTN_SERVICE).\$(KEPTN_PROJECT)-\$(KEPTN_STAGE)", "--only-summary"]

  - name: "Remediation: Scaling with Helm"
    events:
      - name: "sh.keptn.event.action.triggered"
        jsonpath:
          property: "$.data.action.action"
          match: "scale"
    tasks:
      - name: "Scale with Helm"
        files:
          - /charts
        env:
          - name: REPLICA_COUNT
            value: "$.data.action.value"
            valueFrom: event
        image: "alpine/helm:3.9.0"
        serviceAccount: "jes-deploy-using-helm"
        cmd: ["helm"]
        args: ["upgrade", "-n", "\$(KEPTN_PROJECT)-\$(KEPTN_STAGE)", "\$(KEPTN_SERVICE)", "/keptn/charts/\$(KEPTN_SERVICE).tgz", "--set", "replicaCount=\$(REPLICA_COUNT)"]
EOF
git add -A
git commit -m "add remediation action to jes in production"
git push
```

## Explanation

The new task:

1. Listens for the `action.triggered` event when the JSON payload contains an `action` word of `scale` (this references the `action` field in `remediation.yaml`)
2. Retrieves the replica count from the incoming JSON payload (this references the `value` field in `remediation.yaml`)
3. Uses `helm` to upgrade the `helloservice.tgz` helm chart and sets the `replicaCount` to whatever value is specified in `remediation.yaml` (in our case `2`)

## Create a fake problem

In reality you would rely on prometheus alert manager or another incoming problem feed from an external observability platform.

For our demo though, we can "fake" this payload so you can easily and quickly retrigger:

```
cd ~
cat <<EOF > remediation_trigger.json
{
  "type": "sh.keptn.event.production.remediation.triggered",
  "specversion": "1.0",
  "source": "https://github.com/keptn/keptn/fake-problem",
  "contenttype": "application/json",
  "data": {
    "project": "fulltour",
    "stage": "production",
    "service": "helloservice",
    "problem": {
      "problemTitle": "http_response_time_seconds_main_page_sum"
    }
  }
}
EOF
```

Notice two important details:

1. The `type` is `production.remediation.triggered`. We are telling Keptn to `trigger` the `remediation` sequence in the `production` stage
2. The `problemTitle` is `http_response_time_seconds_main_page_sum`. This matches what is in the `remediation.yaml` file

----

## Trigger a Problem

Send Keptn a problem event and watch Keptn scale the pods:

```
keptn send event -f ~/remediation_trigger.json
```

When the sequence is complete, you should see:

![remediation sequence complete](./assets/remediation_sequence_complete.png)
  
## See Scaling

`qa` environment should still have 1 pod running. `production` environment should have scaled up to 2 pods.

```
kubectl -n fulltour-qa get pods
kubectl -n fulltour-production get pods
```
  
```
$ kubectl get pods -n fulltour-qa
NAME                           READY   STATUS    RESTARTS   AGE
helloservice-56db8dc7c-mvqxx   1/1     Running   0          17m

$ kubectl get pods -n fulltour-production
NAME                           READY   STATUS    RESTARTS   AGE
helloservice-56db8dc7c-6bvf4   1/1     Running   0          14m
helloservice-56db8dc7c-2wp4s   1/1     Running   0          67s
```
