---
title: Setup CLI
description: The following description explains how to setup the keptn CLI and connect it to your keptn installation.
weight: 16
keywords: [cli, setup]
---

In this section, the functionality and commands of the keptn CLI are described. The keptn CLI is needed to configure the keptn server, to create new projects and to onboard new services to the keptn server. Furthermore, authorization is needed for the keptn CLI against the keptn server.

<!--
For onboarding, a so-called `shipyard` (**TODO: provide more information/link here**) files has to be provided that defines deployment strategies for the service, as well as the different stages (i.e., dev, staging, and production).
During onboarding, keptn creates a new GitHub projects, which then contains branches for the specified stages (i.e. dev, staging, and production).
Furthermore, keptn creates resources definitions for several Kubernetes resources in terms on [Helm charts](https://helm.sh/).
Please note that onboarding does not deploy a service.
-->

If you are unfamiliar with keptn, we recommend to first watch this [community meeting recording](https://drive.google.com/open?id=1Zj-c0tGIvQ_0Dys6NsyDa-REsEZCvAHJ),
which provides an introduction to keptn.

## Prerequisites
- A successful keptn server installation.
- A GitHub organization, a GitHub user, and [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line). 

## Install the CLI
Every release of keptn provides binaries for the CLI. These binaries are available for Linux, macOS, and Windows.

1. Download your [desired version](https://github.com/keptn/keptn/releases/)
1. Unpack the download
1. Find the `keptn` binary in the unpacked directory.
  - Linux / MacOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the exectable to the desired folder

1. Now, you should be able to run the CLI by 
    ```console
    keptn --help
    ```

{{< popup_image
    link="./assets/keptn-cli-help.png"
    caption="keptn CLI">}}


## Start using the keptn CLI
**TODO:** Describe expected output or how the command can be verified

The CLI allows to onboard a new service using the commands described in the following.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

**Note:** In the current version, keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.

## keptn auth 

Before the CLI can be used, it needs to be authenticated against a keptn installation. Therefore, an endpoint and an API token are required. To retrieve them, execute the following commands:

### Linux / MacOS

```console
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode)

KEPTN_ENDPOINT=https://$(kubectl get ksvc -n keptn control-websocket -o=yaml | yq r - status.domain)
```

### Windows 

```console
TBD
```

If the authentication is successful, keptn will inform the user. Furthermore, if the authentication is successful, the endpoint and the API token are stored in a password store of the underlying operating system.
More precisely, the CLI stores the endpoint and API token using `pass` in case of Linux, using `Keychain` in case of macOS, or `Wincred` in case of Windows.

To authenticate against the keptn installation use command `auth` and your endpoint and API token:

```console
$ keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

**Note**: If you receive a warning `handler_linux.go:29: Use a file-based storage for the key because the password-store seems to be not set up.` it is becaue a password store could not be found in your environment. In this case the credentials are stored in **TODO**


## keptn configure 

In order to work with GitHub (i.e. create a new project, make commits), keptn requires a
GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user.
Therefore, the CLI is used to set the GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user in the keptn installation.

<span style="color:red">
**Note:** Should we describe a best practice, which creates a new GitHub user only used by keptn?
</span>

To configure the used GitHub organization, user, and personal access token use command `configure` and provide your details using the respective flags:

```console
$ keptn configure --org=gitHubOrg --user=gitHub_keptnUser --token=XYZ
```

## keptn create project 

For onboarding a new service, a new GitHub project need to be created first. This new project contains branches for the specified stages (i.e., dev, staging, and production), which are defined in a *shipyard* file like the following example:

```yaml
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    deployment_strategy: "direct"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

To create a new project, use the command `create project` and specify the name of the project as well as the shipyard file.

```console
$ keptn create project sockshop shipyard.yml
```

## keptn onboard service

```console
$ keptn onboard service --project=sockshop --values=values_carts.yaml
```

To onboard a service, please see the [Use Case section](../usecases/onboard-carts-service).

<!-- juergen: I would argue to remove this section since no use case can be done by onboarding an arbitrary service. Instead, link to the first use case of onboarding the carts service here.

## keptn onboard service - Onboard a new service to the project

For describing the used Kubernetes resources, [Helm charts](https://helm.sh/) are used. Here, the CLI allows setting a Helm values description in the before created project. Optionally, the user can also provide a Helm deployment and service description.

To onboard a service, use the command `onboard service` and provide the project name, the Helm chart values and optionally also deployment and service descriptions.

```console
$ keptn onboard service --project=sockshop --values=values.yaml
```
or
```console
$ keptn onboard service --project=sockshop --values=values.yaml --deployment=deployment.yaml --service=service.yaml
```

-->
