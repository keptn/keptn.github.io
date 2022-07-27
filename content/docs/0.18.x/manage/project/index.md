---
title: Project with Stages
description: Create and delete a project in Keptn.
weight: 20
keywords: [0.18.x-manage]
aliases:
---

In Keptn, a project is a structure that allows organizing your services. A project is stored as a git repository and contains branches representing the multi-stage environment (e.g., dev, staging, and production stage).
In other words, the separation of stage configurations is based on git repository branches.

## Create a project

To create a project, you can use the CLI command [keptn create project](../../reference/cli/commands/keptn_create_project) and pass a shipyard file.

**Note**: To learn more about the shipyard specification, please have a look at [shipyard section](../shipyard/) and the [the Keptn spec](https://github.com/keptn/spec/blob/0.2.1/shipyard.md).

The simplest shipyard.yaml file with a single stage and no sequences defined would look like this:
```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "single-stage"
```

* **Recommended approach for Keptn in production:** Create a project with the Keptn CLI using a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```
  See [Git based upstream](../../manage/git_upstream/) for more information.

* **Demo/Lab setting:** Create a project with the Keptn CLI without a Git upstream and **no** backup:
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH
  ```

## Delete a project

To delete a Keptn project, the [keptn delete project](../../reference/cli/commands/keptn_delete_project) command is provided:
  ```console
  keptn delete project PROJECTNAME
  ```

**Note:** If a Git upstream is configured for this project, the referenced repository or project will not be deleted. Besides, deployed services are also not deleted by this command. To clean-up all resources created by Keptn, please go to [Clean-up after deleting a project](../../continuous_delivery/deployment_helm/#clean-up-after-deleting-a-project).

