---
title: Create a project
description: Create a project
weight: 20
keywords: [0.18.x-manage]
aliases:
---

In Keptn, a project is a structure that allows organizing your services.
A project is stored as a Git repository and contains a branch for each stage in your project
such as `dev`, `staging`, and `production` stage).
In other words, the separation of stage configurations is based on git repository branches.

## Create a project

To create a project, use the CLI command [keptn create project](../../reference/cli/commands/keptn_create_project) and pass a [shipyard](../../reference/files/shipyard) file.

The simplest *shipyard.yaml* file has a single stage and no sequences defined would look like this:
```
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "single-stage"
```

For example, you could create a new project with the following command line:
  ```
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```
  See [Git based upstream](../../manage/git_upstream/) for more information.

