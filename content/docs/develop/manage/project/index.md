---
title: Project
description: Learn how to create and delete a project in Keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in Keptn.

## Create a project

In Keptn, a project is a structure that allows to organize your services and it is represented as a repository. This project contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe the stages, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, and test strategy as shown by an example below:

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
```

Allowed values for the **deployment_strategies** are `direct`, which means that the old version of the artifact is replaced, or `blue_green_service`, which means that a new version is deployed . Allowed values for the **test_strategy** are `functional` or `performance`. More deployment and testing strategies are planned to be incorporated in the next releases.

Create a project with the [Keptn CLI](../../reference/cli). 
```console
keptn create project your_project shipyard.yml
```

## Delete a project

Currently, the Keptn CLI does not support the deletion of a project. However, a project can be deleted manually by following the next steps:

- Delete the GitHub repository for your project, e.g., sockshop.
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
  helm delete --purge sockshop-production
  helm delete --purge sockshop-staging
  ```

## Update a project

Updating a project is currently only supported by following the steps of [deleting](#delete-a-project) a project and [creating](#create-a-project) the project with updated settings again.
