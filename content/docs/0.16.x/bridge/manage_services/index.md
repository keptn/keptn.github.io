---
title: Manage Services
description: Create, update and delete services from the Bridge
weight: 40
keywords: [0.16.x-bridge]
---

The Bridge provides features to make managing services more convenient. It is possible to create and delete services directly from the UI.
The following sections provide details about the functionalities you can use to set up your services and where to find them.

This may also be interesting for you:

* [Create a service with the CLI](../../reference/cli/commands/keptn_create_service/)

## Create a service in Bridge

On the service settings page, you can find a "Create service" button.
Clicking on this button opens a form where you can enter a name for the service. A valid service name contains lowercase letters, numbers, and hyphens.

{{< popup_image
link="./assets/service-settings.png"
caption="Keptn Bridge Service Settings View">}}

{{< popup_image
link="./assets/create-service.png"
caption="Keptn Bridge Create Service View">}}

## Manage files for a service

If you configured a Git upstream repository, the Bridge provides you with an overview of the uploaded files for each stage.
Currently, it is not possible to directly manage files for a service in the Bridge. But you can directly jump to the repository with the provided link next to each stage.
The link takes you to the branch and service folder of the selected service and stage. There, you can add, edit and delete files directly. It will then be synced back to your Keptn installation.
(Direct links are supported for Github, Bitbucket, Azure DevOps and CodeCommit)

{{< popup_image
link="./assets/manage-service-files.png"
caption="Keptn Bridge Service Files">}}

## Delete a service in Bridge

To delete a service, click on the "*Edit*"-icon next to the service name and then on "*Delete this service*".
{{< popup_image
link="./assets/delete-service.png"
caption="Keptn Bridge Delete Service View">}}
