---
title: Project with Stages
description: Create and delete a project in Keptn.
weight: 20
keywords: [manage]
aliases:
---

In Keptn, a project is a structure that allows organizing your services. A project is stored as a repository and contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches.

## Create a project

In Keptn, a project is a structure that allows organizing your services.
A project is stored as a repository and contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe the stages, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, test strategy, and remediation strategy as shown by an example below:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
    remediation_strategy: "automated"
```

**Note:**  To learn more about a *shipyard* file, click here [Shipyard specification](https://github.com/keptn/spec/blob/0.1.3/shipyard.md).

* **Option A:** Create a project **without** a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH
  ```

* **Option B:** Create a project **with** a Git upstream:  
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```

## Delete a project

To delete a Keptn project, the [keptn delete project](../../reference/cli/commands/keptn_delete_project) command is provided:
  ```console
  keptn delete project PROJECTNAME
  ```

**Note:** If a Git upstream is configured for this project, the referenced repository or project will not be deleted. Besides, deployed services are also not deleted by this command. 
To clean-up all resources created by Keptn, please follow the information displayed here: [Helm - Clean-up after deleting a project](../../reference/helm/#clean-up-after-deleting-a-project)

## Update a project

Updating a project is currently supported by following the steps of [deleting a project](#delete-a-project) and [creating the project](#create-a-project) with updated settings.
