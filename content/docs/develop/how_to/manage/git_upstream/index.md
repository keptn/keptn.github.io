---
title: Git-based upstream  
description: Select a Get-based upstream for a project
weight: 20
keywords: [manage]
aliases:
---

Keptn manages a project in an internal Git repository. To upstream this repository to a remote place, you can create a GitHub, Bitbucket repository, or a GitLab project and then tell Keptn where to find it when creating the project. Select one of the three options and make sure to have the Git *user*, *token*, and *remote url* before creating a project.

## GitHub
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

## GitLab
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

## Bitbucket
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
