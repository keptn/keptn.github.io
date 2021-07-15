---
title: Manage Projects
description: Create, update and deletes projects from the Bridge
weight: 21
keywords: [0.8.x-bridge]
---

The Bridge provides you with features to make managing projects more convenient. It is possible to create and update projects directly from the UI.
The following sections explain in detail which functionalities you can use to set up your projects and where to find them.

This may be also interesting for you:

* [Create a project with CLI](https://keptn.sh/docs/0.8.x/reference/cli/commands/keptn_create_project/)
* [Update a project with CLI](https://keptn.sh/docs/0.8.x/reference/cli/commands/keptn_update_project/)

## Create a new project in Bridge

Going to the project overview, you can find a button "Create a new project" there at the bottom of the page.
Clicking on this button redirects you to a new page where you find a form that provides all the necessary information needed for creating a new project in Keptn.

{{< popup_image
link="./assets/project-dashboard-empty.png"
caption="Empty project page">}}

{{< popup_image
link="./assets/create-new-project.png"
caption="Create project page">}}

{{< popup_image
link="./assets/create-new-project-filled-in.png"
caption="Create project page filled in with examples">}}

This information needs to be provided:

#### Project name
The project name is unique in the Keptn installation as must therefore not be a name that is already in use for another project.

#### Git repository settings
The git upstream can be set by providing the Git repository URL, Git username and the Git token. This is parallel to the Git ``--git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL`` parameters when using the Keptn CLI.
More information about how you can set up your git provider can be found in the [Git-based upstream documentation](https://keptn.sh/docs/0.8.x/manage/git_upstream/).

#### Shipyard file
Please provide the shipyard.yaml file here for your project. You can either drag it into the panel or select it manually from your file system with the "Select a file" button.<br/>
You can find more information about the shipyard file on the [Shipyard](https://keptn.sh/docs/0.8.x/manage/shipyard/) documentation page.

After the successful creation of the project, you are redirected directly to the new projects settings page.
Also in the project overview as well as the navigation, your project is already available.

{{< popup_image
link="./assets/create-new-project-success.png"
caption="Successful creation of a project">}}

{{< popup_image
link="./assets/project-dashboard.png"
caption="Project overview">}}

## Update your project
On the project settings page, you can update your project.

{{< popup_image
link="./assets/settings.png"
caption="Project settings">}}

### Update the Git upstream settings
The git upstream can be updated by providing the Git repository URL, Git username and the Git token. This also can be achieved by
using the [keptn update project](https://keptn.sh/docs/0.8.x/reference/cli/commands/keptn_update_project/) command.
More information about how you can set up your git provider can be found in the [Git-based upstream documentation](https://keptn.sh/docs/0.8.x/manage/git_upstream/).
