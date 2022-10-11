---
title: Start a project
description: Set up a new project
weight: 20
keywords: [0.19.x-manage]
aliases:
---

In Keptn, a project is a structure that allows organizing your services.
A project is stored as a Git repository and contains a branch
for each stage defined for the project
(e.g., dev, staging, and production stage).

## Before you create a project

Before you create a project:

* You must [Install Keptn](../../../install/helm-install)
  on a Kubernetes cluster that has **kubectl** installed.

* In most cases, you should also [install the Keptn CLI](../../../install/cli-install)
  and [authenticate the Keptn CLI and Bridge](../../../install/authenticate-cli-bridge).
  You can create projects and services, trigger sequences, and many other common tasks
  using the Keptn Bridge rather than the command line
  but you may prefer using the command line
  and some tasks can only be accomplished from the command line.
  If you want to use the command line to create your project,
  you must install and authenticate the CLI.

* We also suggest reading [Plan your project](../plan)
  to anticipate some of the choices you must make as you create a new project.

## Prepare resources for the project

Before you create the project, you must create some resources
that are required to create a project:

* A new, unitialized Git-based upstream repository that will store
all the configuration and data information that Keptn needs
as well as a user token for that repository.
See [Git-based upstream](../git_upstream) for details.

  * Note that, in Keptn releases 0.15.x and earlier, the upstream git-based repository was optional
  although strongly recommended.
  Beginning with Keptn release 0.16.x, all Keptn projects must have an associated Git-upstream repository.

* A [shipyard](../../reference/files/shipyard) file
  that defines the `stages` for your project.
  You cannot add, remove, or rename `stages` after you create the project.
  A *shipyard.yaml* file like the following is enough to create the project:

  ```
  apiVersion: spec.keptn.sh/0.2.3
  kind: "Shipyard"
  metadata:
    name: "shipyard-sockshop"
  spec:
    stages:
      - name: "dev"
      - name: "hardening"
      - name: "production"
  ```

  * At least one `stage` with a `name` is required.
  * The project `name` must start with a lowercase letter
    and contain only lowercase letters, numbers, and hyphens
  * The project name should be less than 200 characters long
  * See the [shipyard](../../reference/files/shipyard) page
    for more details about naming rules

  Create this file on your local system;
  it is passed to the project's upstream Git repository for this project.

  This "stub" *shipyard* file is enough to create a project.
  You must include sequences, tasks, etc in the shipyard before running it.
  You can add those before or after you create the project.
  See the [Define Keptn Projects](../../define) section for information
  about how to define sequences and tasks for your project.

## Create a project

You can create a project in either of the following ways:

* From the Keptn Bridge
* On the command line (requires that the Keptn CLI is installed and authenticated)

### Create a project from the Keptn Bridge:

The [Create a Keptn Project and Service](https://www.youtube.com/watch?v=W4YzlUawFkU) video
shows how to create a Keptn project and service from the Keptn Bridge.

For written instructions, see
[Create a new project in Bridge](../../bridge/manage_projects/#create-a-new-project-in-bridge).

### Create project from the CLI command line

To create a project from the command line,
use the [keptn create project](../../reference/cli/commands/keptn_create_project) command
and pass a [shipyard](../../reference/files/shipyard) file.

For example, you could create a new project with the following command line:
  ```
  keptn create project PROJECTNAME --shipyard=FILEPATH --git-user=GIT_USER --git-token=GIT_TOKEN --git-remote-url=GIT_REMOTE_URL
  ```

See the reference page for details about arguments and options for this command.

