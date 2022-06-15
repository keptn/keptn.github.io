---
title: Create a new project
description: Create the upstream Git repository, create and trigger a new project, and view the results on the Keptn bridge
weight: 30
---


Keptn needs a brand new, uninitialised repo to store and manage configuration.
We will create it automatically now.

Decide on a new repo name you'd like to use and set it as an environment variable:

```
export GIT_USER=<YourUserName>
export GITHUB_TOKEN=<YourGitPATToken>
export GIT_NEW_REPO_NAME=keptndemo
```

Now set a meta variable which Keptn will use (no need to change this, just run it)

```
export GIT_REPO=https://github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
```

For example (don't use this!):

```
export GIT_USER=dummyuser
export GITHUB_TOKEN=ghp_abcDEF123XYZ
export GIT_NEW_REPO_NAME=keptndemo
export GIT_REPO=https://github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
```

Verify the details are correctly set by printing them to the console:

```
echo "Git Username: $GIT_USER"
echo "Git Token: $GITHUB_TOKEN"
echo "New Git Repo to be created: $GIT_NEW_REPO_NAME"
echo "URL of new Git Repo: $GIT_REPO"
```{{exec}}

## Create New Repository

The demo environment has the GitHub CLI. The CLI will automatically use the `GITHUB_TOKEN` environment variable to authenticate.

Ensure the GitHub CLI works by listing your existing repositories which should show all existing repositories on your account:

```
gh repo list
```{{exec}}

Now create the new private repository:

```
gh repo create $GIT_NEW_REPO_NAME --public
```{{exec}}

If it worked, you will see:

```
✓ Created repository <YourUserName>/keptndemo on GitHub
```

## Create Keptn Project

A Keptn project is a high level logical container. A project contains stages (which mimic your environment eg. `dev` and `production`) and services (which mimic your microservices).

A Keptn project is modelled by a `shipyard.yaml` file which you must define.

Run the following to create a `shipyard.yaml` file on disk:

```
cd ~
cat << EOF > shipyard.yaml
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
            - name: "je-deployment"
EOF
```{{exec}}

Create the project: `fulltour` and service called `helloservice` using the Keptn CLI.

The Keptn service name must be called precisely `helloservice` because the helm chart we use in this demo is called `helloservice.tgz` and the job executor runs `helm install` and relies on a file being available called `helloservice.tgz`.
  
```
keptn create project fulltour --shipyard shipyard.yaml --git-remote-url $GIT_REPO --git-user $GIT_USER --git-token $GITHUB_TOKEN
keptn create service helloservice --project=fulltour
```{{exec}}

## Add Application Helm Chart

Add the helm chart (this is the real application we will deploy). The `--resource` path is the path to files on disk whereas `--resourceUri` is the Git target folder. Do not change these. Notice also we’re uploading a helm chart with a name matching the Keptn service: `helloservice.tgz`

```
cd ~/keptn-job-executor-delivery-poc
keptn add-resource --project=fulltour --service=helloservice --all-stages --resource=./helm/helloservice.tgz --resourceUri=charts/helloservice.tgz
```{{exec}}

Add the files that locust needs:

```
keptn add-resource --project=fulltour --service=helloservice --stage=qa --resource=./locust/basic.py
keptn add-resource --project=fulltour --service=helloservice --stage=qa --resource=./locust/locust.conf
```{{exec}}

Add the job executor service config file. This tells the JES what container and commands to execute for each Keptn task:

```
keptn add-resource --project=fulltour --service=helloservice --all-stages --resource=job-executor-config.yaml --resourceUri=job/config.yaml
```{{exec}}

## 🎉 Trigger Delivery

You are now ready to trigger delivery of the `helloservice` helm chart into all stages, testing along the way with locust:

Trigger a sequence via the API, via the bridge or via the CLI:

```
keptn trigger delivery \
--project=fulltour \
--service=helloservice \
--image="ghcr.io/podtato-head/podtatoserver:v0.1.1" \
--labels=image="ghcr.io/podtato-head/podtatoserver",version="v0.1.1"
```{{exec}}

Locust runs for 2 minutes (configurable) each time it responds to `je-test.triggered`. Load is generated once in the `qa` stage so expect the end-to-end delivery with Locust load tests to take about 3 minutes.

View the delivery sequence [in the bridge]({{TRAFFIC_HOST1_8080}}/bridge/project/fulltour/sequence)

![deployed](./assets/trigger-delivery-2.jpg)
  
## While You Wait

While you are waiting for the release and load test to finish, why not have a look at your repo in a browser on GitHub.com.
  
Notice Keptn has created a branch per stage. Inside those branches are folders for each Keptn service.

The `keptn add-resource` command is a helper which ensures files are stored on the correct branches and in the correct folders. However, it is not mandatory to use this function; you could choose to upload directly to Git if you know your way around.

## What Happened?

Run `kubectl get namespaces`{{exec}}

Notice the 2 new namespaces: `fulltour-qa` and `fulltour-production`. Your app `helloservice.tgz` is deployed into each namespace thanks to the job executor service that ran `helm` (look at the `qa` and `production` branches in your repo at `helloservice/job/config.yaml`).

Helm is told to deploy `$(KEPTN_STAGE).tgz` (ie. `helloservice.tgz`).

```
NAME                  STATUS
default               Active
kube-system           Active
kube-public           Active
kube-node-lease       Active 
keptn                 Active  
keptn-jes             Active   
fulltour-qa           Active   2m
fulltour-production   Active   2m
```

Validate that pods version `v0.1.1` is running in both environments.

```
kubectl -n fulltour-qa describe pod -l app=helloservice | grep Image:
kubectl -n fulltour-production describe pod -l app=helloservice | grep Image:
```{{exec}}


Also notice that during the `je-test` task, locust was executed. The `job/config.yaml` file in the Git upstream also shows how this was done.

Result: Keptn orchestrated your deployment which was acheived using `helm` and `locust` to generate load.

----

## What Next?

Your application is being deployed into both QA and Production. This is great and indeed Keptn works with ArgoCD and Flux in the same way to ensure code is always up to date.

Sometimes, a manual approval step is required before an artifact is promoted to production. This is especially important right now as we are not testing the quality of the `helloservice` artifact. We will now add this.
