---
title: Project
description: Learn how to create and delete a project in Keptn.
weight: 20
keywords: [manage]
aliases:
---

Learn how to manage your projects in Keptn.

## Select Git-based upstream  

Keptn will manage a project in an internal Git repository. To upstream this repository to a remote place, you can create a GitHub, Bitbucket repository, or a GitLab project and then tell Keptn where to find it during creating the project explained below. Select one of the three options and make sure to have the Git *user*, *token*, and *remote url* before continuing.

### GitHub
<details><summary>Create user, token, and repository</summary>
<p>

1. If you do not have a GitHub user, create a user by [signing up](https://github.com/join?source=header-home). 

1. Create a [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) for your user with *repo* scope:

    {{< popup_image 
    link="./assets/github_access_token.png" 
    caption="GitHub access token" 
    width="600px">}} 

1. (optional) If you want to use a dedicated GitHub organization for your repository, create a [GitHub organization](https://github.com/organizations/new).

1. Go to your account or your GitHub organization and create a [GitHub repository](https://help.github.com/en/articles/create-a-repo).

    **Note:** Click the **Initialize this repository with a README** checkbox to initialize the repository, which is a prerequisite.

    {{< popup_image 
    link="./assets/github_create_repo.png" 
    caption="GitHub create repository" 
    width="600px">}}  

</p>
</details>

### GitLab
<details><summary>Create user, token, and project</summary>
<p>

1. If you do not have a GitLab user, create a user by [signing up for a free trial](https://customers.gitlab.com/trials/new?gl_com=true). 

1. Create a [personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) for your user with *write_repo* scope:

    {{< popup_image 
    link="./assets/gitlab_access_token.png" 
    caption="GitHub access token" 
    width="600px">}} 

1. Go to your account and create a [GitLab project](https://docs.gitlab.com/ee/gitlab-basics/create-project.html).

    **Note:** Click the **Initialize this repository with a README** checkbox to initialize the repository, which is a prerequisite.

    {{< popup_image 
    link="./assets/gitlab_create_project.png" 
    caption="GitLab create project" 
    width="600px">}} 

</p>
</details>

### Bitbucket
<details><summary>Create user, token, and repository</summary>
<p>

1. If you do not have a Bitbucket user, create a user by [signing up for a free trial](https://bitbucket.org/account/signup/). 

1. Create an [app password](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) for your user with *Write* permissions. Therefore, select your User > **View profile** > **Settings** > **App passwords** > **Create app password**

    {{< popup_image 
    link="./assets/bitbucket_access_token.png" 
    caption="Bitbucket access token" 
    width="600px">}} 

1. Go to your account and create a [Bitbucket repository](https://docs.gitlab.com/ee/gitlab-basics/create-project.html).

    **Note:** Select *Include a README?* - **Yes, with a template** to initialize the repository, which is a prerequisite.

    {{< popup_image 
    link="./assets/bitbucket_create_repo.png" 
    caption="Bitbucket create repository" 
    width="600px">}} 

</p>
</details>

## Create a project

In Keptn, a project is a structure that allows to organize your services. 
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

**Note:**  To learn more about a *shipyard* file, click here [Shipyard specification](https://github.com/keptn/spec/blob/0.1.1/shipyard.md).

* **Option A:** Create a project with the Keptn CLI without a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH
  ```

* **Option B:** Create a project with the Keptn CLI using a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```

## Delete a project

To delete a Keptn project, the [delete project](../../reference/cli#keptn-delete-project) command is provided:
  ```console
  keptn delete project PROJECTNAME
  ```

**Note:** If a Git upstream is configured for this project, the referenced repository or project will not be deleted. Besides, deployed services are also not deleted by this command. 
To clean-up all resources created by Keptn: 

- Delete the remote repository for your project

- Delete the Helm releases that have been deployed by Keptn, e.g.:

  ```console
  helm ls
  ```
  ```console
  helm delete --purge sockshop-dev
  ```
  ```console
  helm delete --purge sockshop-production
  ```
  ```console
  helm delete --purge sockshop-staging
  ```

- Delete all Kubernetes namespaces that have been created by Keptn in your cluster, e.g.:
  - sockshop-dev
  - sockshop-staging
  - sockshop-production

    by executing:

  ```console
  kubectl delete namespace sockshop-dev sockshop-staging sockshop-production
  ```

## Update a project

Updating a project is currently supported by following the steps of [deleting](#delete-a-project) a project and [creating](#create-a-project) the project with updated settings.
