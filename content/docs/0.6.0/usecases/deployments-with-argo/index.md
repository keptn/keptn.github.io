---
title: Argo CD for Deploying and Keptn for Testing, Evaluating, and Promoting
description: Describes how Argo CD can be used for deploying and Keptn for testing, evaluating, and promoting
weight: 30
keywords: []
aliases:
---

Describes how Argo CD can be used for deploying and Keptn can be used for testing, evaluating, and promoting.

## About this tutorial

In this tutorial, [Argo CD](https://argoproj.github.io/argo-cd/) is used 
for deploying a [Argo Rollout](https://argoproj.github.io/argo-rollouts/)
and Keptn is used for testing, evaluating, and promoting this rollout.
More precisely, in this tutorial, Argo CD is used as deployment tool
and not the Keptn built-in tool called `helm-service`.
Furthermore, this tutorial uses [Argo Rollouts](https://argoproj.github.io/argo-rollouts/),
which introduces a new custom resource called
`Rollout` implementing deployment strategies such as Blue/Green and Canary.

This tutorial provides a sample Helm chart, which contains the `carts` and `carts-db` service. 
These services will be deployed into 
a `production` environment using Argo CD. Afterwards, Keptn will be used to test the `carts` service 
using performance tests. Using the resulting metrics provided by Prometheus, 
Keptn will then check whether this service passes the defined quality gate.
Depending on whether the quality gate is passed or not, this service will be promoted or aborted.
In case it will be promoted, this service will be released to real-users.

**Note:** The following tutorial is a first proof-of-concept for using Argo CD as
deployment tool.

## Prerequisites

* A completed [Keptn installation](../../installation/setup-keptn)

* Basic knowledge of [Argo CD](https://argoproj.github.io/argo-cd/) and [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)

* Completed [Argo CD installation](https://argoproj.github.io/argo-cd/getting_started/#1-install-argo-cd) and the `argocd` CLI needs to be [logged in](https://argoproj.github.io/argo-cd/getting_started/#4-login-using-the-cli)

* Completed [Argo Rollouts installation](https://argoproj.github.io/argo-rollouts/getting-started/#install-argo-rollouts)

* Clone example files used in this tutorial:

    ```console
    git clone --branch master https://github.com/keptn/examples.git --single-branch
    ```

    ```console
    cd examples/onboarding-carts
    ```

## Configure Keptn

### Install the Keptn Argo-service
The Keptn `argo-service` takes care of *promoting* or *aborting* a Rollout depending on the result of the quality gate.
More precisely, the `argo-service` listens for `sh.keptn.events.evaluation-done` events and depending on the evaluation result (i.e. whether the quality gate is passed or not)
the service promotes or aborts a rollout, respectively.

1. The `argo-service` is not contained in the default installation of Keptn.
To install the `argo-service`, execute:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/argo-service/0.1.0/deploy/service.yaml
    ```

1. The `gatekeeper-service` (which is installed by the default installation of Keptn) has to be removed:

    ```console
    kubectl delete deployment gatekeeper-service-evaluation-done-distributor -n keptn
    ```

### Create project sockshop
This tutorial sets up a single stage environment containing a `production` environment.
In this stage, performance tests are used to test new deployments.
For creating the project, the following shipyard is used:

```console
stages:
  - name: "production"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
```

* Create a new project for your services using the [keptn create project](../../reference/cli/commands/keptn_create_project) command. 
In this tutorial, the project is called *sockshop*. The Git user (`--git-user`), an access token (`--git-token`), and the remote URL (`--git-remote-url`) are required for configuring an upstream.
For details, please visit [select Git-based upstream](../../manage/project/#select-git-based-upstream) where instructions for GitHub, GitLab, and Bitbucket are provided. 
Before executing the following command, make sure you are in the `examples/onboarding-carts` folder:

    ```console
    keptn create project sockshop --shipyard=./shipyard-argo.yaml --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
    ```

### Create carts service

1. Keptn manages all service-related artifacts (like testing files, SLOs, etc.),
in a so-called service. 
Create a service for *carts* using the [keptn create service](../../reference/cli/commands/keptn_create_service) command:

    ```console
    keptn create service carts --project=sockshop
    ```

    **Note:** Since you are not deploying a service with the `helm-service`, [keptn create service](../../reference/cli/commands/keptn_create_service) does not require any Helm chart compared to the [keptn onboard service](../../reference/cli/commands/keptn_onboard_service) command. 

1. After creating the service, Keptn allows to add service-related artifacts like the performance test:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
    ```


### Set up the quality gate and monitoring
Keptn's quality gate is specified by *Service Level Objectives* (SLOs).
In order to pass this quality gate, the service has to meet the SLOs.
These SLOs are described in a file called `slo.yaml`.
To learn more about the *slo.yaml* file, go to [Specifications for Site Reliability Engineering with Keptn](https://github.com/keptn/spec/blob/0.1.2/sre.md).

1. Activate the quality gates for the `carts` service. Therefore, navigate to the `examples/onboarding-carts` folder and upload the `slo.yaml` file using the [add-resource](../../reference/cli/commands/keptn_add-resource) command:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
    ```

For evaluating the SLOs, metrics from a monitoring tool are required.
Currently, this tutorial supports *Prometheus* as a monitoring tool, which is set up in the following steps:

1. Complete steps from section [Setup Prometheus](../../reference/monitoring/prometheus/#setup-prometheus).

1. Complete steps from section [Setup Prometheus SLI provider](../../reference/monitoring/prometheus/#setup-prometheus-sli-provider).

1. Configure custom SLIs for the Prometheus SLI provider as specified in `sli-config-argo-prometheus.yaml`:

    ```console
    keptn add-resource --project=sockshop --stage=production --service=carts --resource=sli-config-argo-prometheus.yaml --resourceUri=prometheus/sli.yaml
    ```

## Configure Argo
Next, this tutorial explains how to set up an Argo app and 
trigger Keptn after a successful deployment.
Therefore, this tutorial assumes that you have completed the [Argo CD installation](https://argoproj.github.io/argo-cd/getting_started/#1-install-argo-cd) and [Argo Rollouts installation](https://argoproj.github.io/argo-rollouts/getting-started/#install-argo-rollouts).


### Add deployment resources
This tutorial provides deployment resources (in the form of a [Helm chart](https://helm.sh/)), which contains the `carts` and `carts-db` service. 
The `carts` service is of type `rollout`, which allows a *blue/green deployment*.

1. Argo CD requires a Git repo where this Helm chart is stored and, here, Keptn's config-repo is re-used.
Execute the following command and replace `GIT_REMOTE_URL` with the URL as you used before when creating the Keptn project:

    ```console
    git clone GIT_REMOTE_URL
    cd sockshop
    git checkout production
    ```
    
1. Copy the `argo` folder provided in the examples repo under `onboarding-carts/` into 
the config repo in the folder `carts`.

1. Add, commit, and push the changes:

    ```console
    git add .
    git commit -m "Add deployment resources"
    git push
    ```

### Create Argo App

1. Create an Argo app using the `argocd` CLI. Therefore, the app name has to follow the format `ServiceName-StageName` and
the namespace has to follow the format `ProjectName-StageName`:

    ```console
    argocd app create --name carts-production --repo GIT_REMOTE_URL --dest-server https://kubernetes.default.svc --dest-namespace sockshop-production --path carts/argo/carts --revision production --sync-policy none
    ```

1. Create a namespace in which the app is deployed:
    ```console
    kubectl create namespace sockshop-production
    ```

### Add Argo Hook for triggering Keptn

In order to infrom Keptn when Argo CD does the deployment,
an [Argo Resource Hook](https://argoproj.github.io/argo-cd/user-guide/resource_hooks/) is configured.
This hook is triggered when Argo CD applies the manifests. This hook
executes a script which sends a [`sh.keptn.events.deployment-finished`](https://github.com/keptn/spec/blob/master/cloudevents.md#deployment-finished) event to the Keptn API.


```console
apiVersion: batch/v1
kind: Job
metadata:
  generateName: app-keptn-notification-
  annotations:
    argocd.argoproj.io/hook: Sync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      containers:
      - name: keptn-notification
        image: agrimmer/alpine-curl-uuid-kubectl:latest
        command: ["/bin/sh","-c"]
        args: ['while [[ $(kubectl get rollout {{ .Values.keptn.service }}-{{ .Values.keptn.stage }} -n {{ .Values.keptn.project }}-{{ .Values.keptn.stage }} -o "jsonpath={..status.conditions[?(@.type==\"Progressing\")].reason}") == "ReplicaSetUpdated" ]]; do echo "waiting for rollout" && sleep 1; done; UUID=$(uuidgen); KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm keptn-domain -n {{ .Values.keptn.project }}-{{ .Values.keptn.stage }} -ojsonpath={.data.app_domain}); KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n {{ .Values.keptn.project }}-{{ .Values.keptn.stage }} -ojsonpath={.data.keptn-api-token} | base64 -d);UUID=$(uuidgen); now=$(TZ=UTC date "+%FT%T.00Z"); curl -X POST -H "Content-Type: application/cloudevents+json" -H "x-token: ${KEPTN_API_TOKEN}" --insecure -d "{\"contenttype\": \"application/json\", \"data\": { \"project\": \"{{ .Values.keptn.project }}\", \"service\": \"{{ .Values.keptn.service }}\", \"stage\": \"{{ .Values.keptn.stage }}\", \"deploymentURILocal\": \"http://{{ .Values.keptn.service }}-canary.{{ .Values.keptn.project }}-{{ .Values.keptn.stage }}\", \"deploymentstrategy\": \"blue_green_service\", \"teststrategy\": \"performance\"}, \"id\": \"${UUID}\", \"source\": \"argo\", \"specversion\": \"0.2\", \"time\": \"${now}\", \"type\": \"sh.keptn.events.deployment-finished\", \"shkeptncontext\": \"${UUID}\"}" ${KEPTN_ENDPOINT}/v1/event']
      restartPolicy: Never
  backoffLimit: 2
```
In order to activate this hook, the Job has to be located in the Helm chart containing the deployment resources.
The example chart in `onboarding-carts/argo/carts` already contains this Hook
and, hence, it was already added in the step before.

* This hook needs to access the Keptn API and therefore requires the Keptn endpoint as well as the api-token.
Therefore, create a config map and a secret with the Keptn endpoint and api-token:

    ```console
    KEPTN_ENDPOINT=$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
    KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    kubectl -n sockshop-production create secret generic keptn-api-token --from-literal="keptn-api-token=$KEPTN_API_TOKEN"
    kubectl -n sockshop-production create configmap keptn-domain --from-literal="app_domain=$KEPTN_ENDPOINT"
    kubectl create clusterrolebinding sockshop-production --clusterrole=cluster-admin --serviceaccount=sockshop-production:default
    ```


## Deploy with Argo and Test, Evaluate, and Promote with Keptn

### Deploy a first version 

1. Sync the Argo app using the ArgoCD UI or the `argocd` CLI:

    ```console
    argocd app sync carts-production
    ```

1. Check whether the hook triggered Keptn. Therefore, go to Keptn Bridge and check whether there is 
a `sh.keptn.events.deployment-finished` event. If you have not exposed the Bridge yet, execute the following command:

    ```console 
    keptn configure bridge --action=expose
    ```
    > The Keptn Bridge is then available on: `https://bridge.keptn.YOUR.DOMAIN/`

1. Follow the events in the Keptn Bridge.

1. The new version (i.e. the `canary`) as well as the released version (i.e. the `primary`) of the `carts` service are exposed via a LoadBalancer.
In order to access the website of the `carts` service, query the external IPs of the LoadBalancer:

    ```console
    kubectl get services -n sockshop-production
    ```

    ```console
    NAME            TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
    carts-canary    LoadBalancer   10.3.10.175   35.x.x.x        80:32475/TCP   47h
    carts-db        ClusterIP      10.3.1.153    <none>          27017/TCP      47h
    carts-primary   LoadBalancer   10.3.14.82    35.x.x.x        80:32597/TCP   47h
    ```

1. Navigate to `http://EXTERNAL-IP` for viewing both versions of the `carts` service in your `production` environment.

  {{< popup_image
  link="./assets/argo-carts-v1.png"
  caption="Carts V1"
  width="50%">}}


**Expected Result:** This version has passed the quality gate. Hence, you should see that both services serve the same content.

You will see these events in the Keptn's Bridge:

  {{< popup_image
  link="./assets/argo-bridge-carts-v1.png"
  caption="Bridge after first deployment"
  width="50%">}}


### Deploy a SLOW version 
Next, we will deploy a slow version of the carts service, which contains an artificial slowdown of 2 second in each request.
This version must should not pass the quality gate and, hence, should not be promoted to serve real-user traffic.

1. In your Git reposititory containing the Argo resources, go to the folder `carts/argo/carts` and open the `values.yaml` file.

1. Edit the `tag` from `0.11.1` to `0.11.2`. 

1. Add, commit, and push these changes:
    ```console
    git add .
    git commit -m "Use slow version"
    git push
    ```

1. Sync the Argo app using the ArgoCD UI or the `argocd` CLI:

    ```console
    argocd app sync carts-production
    ```

1. Follow the events in the Keptn's Bridge. Please note that the performance tests will take approx. 20 minutes.

    {{< popup_image
    link="./assets/quality-gate-not-passed.png"
    caption="carts service"
    width="50%">}}

1. Navigate to `http://EXTERNAL-IP` for viewing both versions of the `carts` service in your `production` environment.

  {{< popup_image
  link="./assets/argo-carts-v2.png"
  caption="Carts CANARY"
  width="50%">}}

  {{< popup_image
  link="./assets/argo-carts-v1.png"
  caption="Carts PRIMARY"
  width="50%">}}

**Expected Result:** This version `0.11.2` should not pass the quality gate. The `primary` version should still show the last version `0.11.1`.

### Deploy a fast version
Finally, we will deploy a version which does _not_ contain the slowdown anymore.
This version should now again pass the quality gate and, hence, should be promoted to serve real-user traffic.

1. In your Git reposititory containing the Argo resources, go to the folder `carts/argo/carts` and open the `values.yaml` file.

1. Edit the `tag` from `0.11.2` to `0.11.3`. 

1. Add, commit, and push these changes:
    ```console
    git add .
    git commit -m "Use fast version"
    git push
    ```

1. Sync the Argo app using the ArgoCD UI or the `argocd` CLI:

    ```console
    argocd app sync carts-production
    ```

1. Follow the events in the Keptn's Bridge. 

1. Navigate to `http://EXTERNAL-IP` for viewing both versions of the `carts` service in your `production` environment.

**Expected Result:** This version `0.11.3` should pass the quality gate. The `primary` version should show version `0.11.3`.

  {{< popup_image
  link="./assets/argo-carts-v3.png"
  caption="Carts CANARY and PRIMARY"
  width="50%">}}

Your Bridge should show an event flow similar to the one in this screenshot:

  {{< popup_image
  link="./assets/argo-bridge-carts-v3.png"
  caption="Keptn's bridge after deploying all three versions"
  width="80%">}}