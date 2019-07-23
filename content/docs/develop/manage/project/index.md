---
title: Project
description: Learn how to create and delete a project in keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in keptn.

## Create a project

A project is a structure in keptn that allows to organize your services and is represented as a repository in the GitHub organization used by keptn. This project contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe the stages, a single `shipyard.yaml` file is needed that specifies the name, deployment strategy, and test strategy as shown below:

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

Allowed values for the deployment strategies are "direct", which means the old version of the artifact is replaced, or "blue_green_service", which means that a new version is deployed . Allowed values for the test_strategy are "functional" or "performance". We are planning to incorporate more deployment and testing strategies in the next releases.

Create a project with the [keptn CLI](../../reference/cli). 
```
keptn create project your_project shipyard.yml
```


## Delete a project

The keptn CLI does currently not support the deletion of a project. However, by following the next steps, a project can manually be removed:

- Delete the GitHub repository for your project, e.g., sockshop.
- Delete all namespaces that have been created by keptn in your Kubernetes cluster, e.g.,
  - sockshop-dev
  - sockshop-staging
  - sockshop-production
  
    by executing

  ```console
  kubectl delete namespace sockshop-dev sockshop-staging sockshop-production
  ```

In addition, the Helm releases have to be deleted:
```
helm delete --purge sockshop-dev
helm delete --purge sockshop-production
helm delete --purge sockshop-staging
````

## Update a project

Updating a project is currently only supported by following the steps of [deleting](#delete-a-project) a project and [creating](#create-a-project) the project with updated settings again.
