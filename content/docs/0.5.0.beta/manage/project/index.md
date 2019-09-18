---
title: Project
description: Learn how to create and delete a project in Keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in Keptn.

## Select Git-based upstream  

Keptn will manage a project in an internal Git repository. To upstream this repository to a remote place, you can create a GitHub, GitLab repository or a Bitbucket project and then tell Keptn where to find it during creating the project, explained below. Select one of the three options and make sure to have the Git *user*, *token*, and *remote url* before continuing.

### GitHub
<details><summary>Create user, token, and repository</summary>
<p>

1. (optional) If you want to use a dedicated GitHub organization for your repository, create a [GitHub organization](https://github.com/organizations/new).

1. If you do not have a GitHub user, create a user by [signing up](https://github.com/join?source=header-home). 

1. Create a [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for your user with *repo* scope:

    {{< popup_image 
    link="./assets/github-access-token.png" 
    caption="GitHub access token" 
    width="50%">}}

1. Go to your account or the previously create GitHub organization and create a [GitHub repository](https://help.github.com/en/articles/create-a-repo).

    **Note:** Click the **Initialize this repository with a README** checkbox to initialize the repository.

    {{< popup_image 
    link="./assets/github-create-repo.png" 
    caption="GitHub create repository" 
    width="50%">}} 

</p>
</details>

### GitLab
<details><summary>Create user, token, and repository</summary>
<p>

</p>
</details>

### Bitbucket
<details><summary>Create user, token, and project</summary>
<p>

</p>
</details>

## Create a project

In Keptn, a project is a structure that allows to organize your services and it is represented as a repository. This project contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe the stages, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, test strategy, and remediation strategy as shown by an example below:

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

Allowed values for the **deployment_strategies** are `direct`, which means that the old version of the artifact is replaced, or `blue_green_service`, which means that a new version is deployed . Allowed values for the **test_strategy** are `functional` or `performance`. More deployment and testing strategies are planned to be incorporated in the next releases.

* **Option A:** Create a project with the [Keptn CLI](../../reference/cli) without a Git upstream. 
  ```console
  keptn create project <your_project> <shipyard.yaml>
  ```

* **Option B:** Create a project with the [Keptn CLI](../../reference/cli) using a Git upstream. 
  ```console
  keptn create project <your-project> <shipyard.yaml> --git-user=<your-user> --git-token=<your-token> --git-remote-url=<repository-remote-url>
  ```

## Delete a project

Currently, the Keptn CLI does not support the deletion of a project. However, a project can be deleted manually by following the next steps:

- Delete the remote repository for your project.
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
