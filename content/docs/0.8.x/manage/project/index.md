---
title: Project with Stages
description: Create and delete a project in Keptn.
weight: 20
keywords: [0.8.x-manage]
aliases:
---

In Keptn, a project is a structure that allows organizing your services. A project is stored as a repository and contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches.

## Create a project

To describe the stages of a project, a **shipyard** is needed that specifies multi-stage delivery worklow as shown by an example below. 

**Note:** To learn more about a shipyard, see [declare shipyard before creating a project](../../continuous_delivery/multi_stage/#declare-shipyard-before-creating-a-project).

```yaml
apiVersion: spec.keptn.sh/0.2.0
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct"
            - name: "test"
              properties:
                teststrategy: "functional"
            - name: "evaluation"
            - name: "release"

    - name: "staging"
      sequences:
        - name: "delivery"
          triggers:
            - "dev.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "test"
              properties:
                teststrategy: "performance"
            - name: "evaluation"
            - name: "release"

    - name: "production"
      sequences:
        - name: "delivery"
          triggers:
            - "staging.delivery.finished"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"
```

* **Recommended approach for Keptn in production:** Create a project with the Keptn CLI using a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```

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

## Update a project

Updating a project is currently supported by following the steps of [deleting a project](#delete-a-project) and [creating the project](#create-a-project) with updated settings.
