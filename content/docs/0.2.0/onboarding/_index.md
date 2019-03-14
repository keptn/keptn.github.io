---
title: Onboarding of a service
description: The following description explains how an existing microservice can be onboarded to keptn using the keptn CLI.
weight: 16
keywords: [cli, onboard]
---

For onboarding, a so-called `shipyard` (**TODO: provide more information/link here**) files has to be provided that defines deployment strategies for the service, as well as the different stages (i.e., dev, staging, and production).
During onboarding, keptn creates a new GitHub projects, which then contains branches for the specified stages (i.e. dev, staging, and production).
Furthermore, keptn creates resources definitions for several Kubernetes resources in terms on [Helm charts](https://helm.sh/).
Please note that onboarding does not deploy a service.

If you are unfamiliar with keptn, we recommend to first watch this [community meeting recording](https://drive.google.com/open?id=1Zj-c0tGIvQ_0Dys6NsyDa-REsEZCvAHJ),
which provides an introduction to keptn.

## Prerequisites
- A successful keptn installation
- The endpoint and API token provided by the keptn installation. This endpoint and API token are used by the CLI to send commands to the keptn installation.
- A GitHub organization, user, and personal access token, which are used by keptn 

## Install the CLI
Every release of keptn provides binaries for the CLI. These binaries are available for Linux, macOS, and Windows.

### Linux and Mac OS

1. Download your [desired version](https://github.com/keptn/keptn/releases/tag/0.2)
2. Unpack the download <!--- Check if necessary -->
3. Find the `keptn` binary in the unpacked directory, add executable permissions (``chmod +x keptn``), and move it to the desired destination (``mv keptn /usr/local/bin/keptn``)
1. Now, you should be able to run the CLI by 
    ```console
    keptn --help
    ```

### Windows

1. Download your [desired version](https://github.com/keptn/keptn/releases/tag/0.2)
1. Unpack the download <!--- Check if necessary -->
1. Find the `keptn.exe` executable in the unzipped folder. 
1. Open the `Command Prompt` or `PowerShell` and navigate to this folder.
1. Test the `keptn.exe` by executing 
    - for Command Prompt
        ```
        keptn.exe --help
        ```
        
    - for PowerShell
        ```
        .\keptn.exe --help
        ```

## Steps and commands to onboard a service
**TODO:** Describe expected output or how the command can be verified

The CLI allows to onboard a new service using the commands described in the following.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

**Note:** In the current version, keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.

## keptn auth - Authentication against the keptn installation

Before the CLI can be used, it needs to be authenticated against a keptn installation. Therefore, an endpoint and an API token are required. To retrieve them, execute the following commands:

```console
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode)

KEPTN_ENDPOINT=$(kubectl get ksvc -n keptn control-websocket -o=yaml | yq r - status.domain)
```
    
If the authentication is successful, keptn will inform the user. Furthermore, if the authentication is successful, the endpoint and the API token are stored in a password store of the underlying operating system.
More precisely, the CLI stores the endpoint and API token using `pass` in case of Linux, using `Keychain` in case of macOS, or `Wincred` in case of Windows.

To authenticate against the keptn installation use command `auth` and your endpoint and API token:

#### windows:

```
important: add https to the endpoint!
```

1. Configure the used GitHub organization, user, and personal access token:

## keptn configure - Configure the used GitHub organization, user, and personal access token

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

## keptn create project - Create a new project

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
