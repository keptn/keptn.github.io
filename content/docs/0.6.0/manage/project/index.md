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

### Azure DevOps Repo
<details><summary>Create user, token, and repository</summary>
<p>

1. If you do not have an Azure DevOps user, create a user by [signing up for a free trial](https://azure.microsoft.com/en-us/services/devops/). 

1. Create a [personal access token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) for your user with *Read & write* access for the Code:
    
    **Note:** Please carefully select the *Expiration date*.

    {{< popup_image 
    link="./assets/azure_devops_access_token.png" 
    caption="Azure DevOps access token" 
    width="600px">}} 

1. Go to your account and create an Azure project
    
    {{< popup_image 
    link="./assets/azure_devops_create_repo.png" 
    caption="Azure DevOps repository" 
    width="600px">}} 

1. Retrieve the URL for your repository.

    **Important:** Remove the User from the URL before passing it to Keptn. For example, in the picture below the URL would be https://dev.azure.com/YOUR-ORG/keptn/_git/keptn.

    {{< popup_image 
    link="./assets/azure_devops_clone_repo.png" 
    caption="Azure DevOps clone repository" 
    width="600px">}} 

</p>
</details>

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

* **Option A:** Create a project with the Keptn CLI without a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH
  ```

* **Option B:** Create a project with the Keptn CLI using a Git upstream: 
  ```console
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```

## Delete a project

To delete a Keptn project, the [delete project](../../reference/cli/commands/keptn_delete_project) command is provided:
  ```console
  keptn delete project PROJECTNAME
  ```

**Note:** If a Git upstream is configured for this project, the referenced repository or project will not be deleted. Besides, deployed services are also not deleted by this command. 
To clean-up all resources created by Keptn, please follow the information displayed here: [Helm - Clean-up after deleting a project](../../reference/helm/#clean-up-after-deleting-a-project)

## Update a project

Updating a project is currently supported by following the steps of [deleting](#delete-a-project) a project and [creating](#create-a-project) the project with updated settings.
