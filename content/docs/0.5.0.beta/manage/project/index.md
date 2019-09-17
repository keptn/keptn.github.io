---
title: Project
description: Learn how to create and delete a project in Keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in Keptn.

## Create a project

In Keptn, a project is a structure that allows to organize your services. 
A project is stored as a repository and contains contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe the stages, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, test strategy, and remmediation strategy as shown by an example below:

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

For the **deployment_strategies** `direct` and `blue_green_service` is allowed. 
When `direct` is used, the old version of an artifact is replaced.
When `blue_green_service` is used, a new version of an artifact is deployed next to the old one.
After a successful validation of this new version, it replaces the old one and is marked as stable (i.e. it becomes the `primary`-version). 
For the **test_strategy** `functional` and `performance` is allowed.
This test strategy selects the executed tests.
More deployment and testing strategies are planned to be incorporated in the next releases.

Create a project with the [Keptn CLI](../../reference/cli). 
```console
keptn create project your_project shipyard.yml
```

## Delete a project

Currently, the Keptn CLI does not support the deletion of a project. However, a project can be deleted manually by following the next steps:

- Delete the repository for your project, e.g., sockshop.
- Delete all namespaces that have been created by Keptn in your Kubernetes cluster, e.g.,
  - sockshop-dev
  - sockshop-staging
  - sockshop-production

  by executing:

  ```console
  kubectl delete namespace sockshop-dev sockshop-staging sockshop-production
  ```

- In addition, the Helm releases have to be deleted:

  ```console
  helm delete --purge sockshop-dev
  ```
  ```console
  helm delete --purge sockshop-production
  ```
  ```console
  helm delete --purge sockshop-staging
  ```

## Update a project

Updating a project is currently only supported by following the steps of [deleting](#delete-a-project) a project and [creating](#create-a-project) the project with updated settings again.
