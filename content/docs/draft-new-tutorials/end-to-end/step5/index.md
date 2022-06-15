---
title: Validate released software
description: Add second evaluation for deployed software
weight: 60
---

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

Locust has the correct files for `qa` but needs the `production` files now too. Upload them now (or commit them directly to Git, up to you):

```
cd ~/keptn-job-executor-delivery-poc
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=./locust/basic.py
keptn add-resource --project=fulltour --service=helloservice --stage=production --resource=./locust/locust.conf
```

## Add Test and Evaluation to Production

Modify the shipyard on the `main` branch again. After the `je-deployment` task, add two new tasks to the `production` stage:

```
- name: "je-test"
- name: "evaluation"
  properties:
    timeframe: "2m"
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
EOF
git remote set-url origin https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
git config --global user.email "keptn@keptn.sh"
git config --global user.name "Keptn"
git add -A
git commit -m "add load gen and evaluation to production"
git push
```

> An additional `je-test` step is added so locust generates some load on the application. In a real production environment, this task would probably be unneccessary as production traffic would already be present.

----

## 🎉 Trigger Delivery

Trigger delivery of the "good build". This should:

1. Pass the `qa` quality gate and be automatically promoted to production
2. Pass the `production` quality gate and remain in production

```
keptn trigger delivery \
--project=fulltour \
--service=helloservice \
--image="ghcr.io/podtato-head/podtatoserver:v0.1.1" \
--labels=image="ghcr.io/podtato-head/podtatoserver",version="v0.1.1"
```

Check the application version running in each environment:

```
kubectl -n fulltour-qa describe pod -l app=helloservice | grep Image:
kubectl -n fulltour-production describe pod -l app=helloservice | grep Image:
```

Should show `v0.1.1` in both environments.

----

## What Next?

As mentioned, problems will always occur in production, so lets equip Keptn to deal with issues.

Self-healing capabilities will be introduced using a provider (eg. helm) and an action (eg. scaling up pods) in response to a problem report.
