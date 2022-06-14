---
title: Production quality evaluations
description: Run an evaluation on the production stage
weight: 50
---

This is step 4 of the tutorial. If you missed the previous parts, start [here](full-tour.md)

----

## Release Validation Quality Evaluation

In this step, a second quality evaluation step will be added to validate the health of production **after** deployment.

In a perfect world, a service would act identically in preproduction as production. In reality though, services can and will act differently in production for many different reasons.

Including an automated post-deployment quality evaluation provides an extra security check.

If this evaluation fails, it can be used as the trigger (or at least a strong indication) to rollback (or otherwise fix) the deployment.

## Add SLI and SLO files

Previously we added SLI and SLO definitions for `qa`. Add them now for the `production` stage.

In this demo, the same files will be used. In reality however, most likely different objectives would be used in production.

```
cd ~/keptn-job-executor-delivery-poc
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=prometheus/sli.yaml --resourceUri=prometheus/sli.yaml
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=slo.yaml --resourceUri=slo.yaml
```

## Add Locust Files

Locust has the correct files for `qa` but needs the production files now too. Upload them now (or commit them directly to Git, up to you):

```
cd ~/keptn-job-executor-delivery-poc
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=./locust/basic.py
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=./locust/locust.conf
```

## Modify Shipyard

Modify the shipyard on the `main` branch again. After the `je-deployment` task, add two new tasks to the `production` stage:

```
- name: "je-test"
- name: "evaluation"
  properties:
    timeframe: "2m"
```

The shipyard should now look like this:

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
```

> An additional `je-test` step is added so locust generates some load on the application. In a real production environment, this task would probably be unneccessary as production traffic would already be present.

----

## 🎉 Trigger Delivery

Trigger delivery of the "good build". This should:

1. Pass the `qa` quality gate and be automatically promoted to production
2. Pass the `production` quality gate and remain in production

{% include full_tour_trigger_delivery_good_version.md %}

Check the application version running in each environment:

{% include full_tour_check_pod_versions.md %}

Should show `{{ .site.good_version }}` in both environments.

----

## What Next? Production Self-Healing (Scaling)

As mentioned, problems will always occur in production, so lets equip Keptn to deal with issues.

[Continue to add self-healing to Keptn using Helm](full-tour-5-self-healing.md)

