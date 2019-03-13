---
title: Onboarding of a service
description: The following description explains how an existing service can be onboarded using keptn.
weight: 16
keywords: [cli, onboard]
---

Onboarding a new service creates a new GitHub project, which contains branches for the specified stages (i.e. dev, staging, and production).
These stages and e.g. their respective deployment strategy are specified in a so-called `shipyard` file.
Furthermore, in onboarding the used Kubernetes resources are described using [Helm charts](https://helm.sh/).
However, onboarding does not deploy a service.

The CLI supports to onboard a new service. 
Therefore, the CLI sends commands to the keptn installation.

If you are unfamiliar with keptn, we recommend to first watch this [community meeting recording](https://drive.google.com/open?id=1Zj-c0tGIvQ_0Dys6NsyDa-REsEZCvAHJ),
which provides an introduction of keptn.


## Prerequisites
- A successful keptn installation
- The endpoint and API token provided by the keptn installation. This endpoint and API token are used by the CLI to send commands to the keptn installation
- A GitHub organization, user, and personal access token, which are used by keptn 


## Install the CLI
Every release of keptn provides binaries for the CLI. These binaries are available for Linux, macOS, and Windows.

1. Download your [desired version](https://github.com/keptn/keptn/releases/tag/0.2)
2. Unpack the download <!--- Check if necessary -->
3. Find the `keptn` binary in the unpacked directory, add executable permissions (``chmod +x keptn``), and move it to the desired destination (``mv keptn /usr/local/bin/keptn``)

Now, you should be able to run the CLI by 
```console
keptn --help
```
## Steps and commands to onboard a service
**TODO:** Describe expected output or how the command can be verified

The CLI allows to onboard a new service using the commands described in the following.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g. usage of the command or description of flags).

**Note:** In the current version, keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.

1. Authentication against the keptn installation:

    Before the CLI can be used, it needs to be authenticated against a keptn installation.
    Therefore, an endpoint and an API token are required. Both are exposed during the keptn installation.
    
    If the authentication is successful, keptn will inform the user.
    Furthermore, if the authentication is successful, the endpoint and the API token are stored in a password store of the underlying operating system.
    More precisely, the CLI stores the endpoint and API token using `pass` in case of Linux, using `Keychain` in case of macOS, or
    `Wincred` in case of Windows.

    To authenticate against the keptn installation use command `auth` and your endpoint and API token:
    ```console
    keptn auth --endpoint=mykeptnendpoint.com --api-token=xyz
    ```

1. Configure the used GitHub organization, user, and personal access token:

    In order to work with GitHub (i.e. create a new project, make commits), keptn requires a
    GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user.
    Therefore, the CLI is used to set the GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user in the keptn installation.

    <span style="color:red">
    **Note:** Should we describe a best practice, which creates a new GitHub user only used by keptn?
    </span>

    To configure the used GitHub organization, user, and personal access token use command `configure` and provide your details using the respective flags:
    ```console
    keptn configure --org=MyOrg --user=keptnUser --token=XYZ
    ```

1. Create a new project:

    For onboarding a new service, a new GitHub project is created. This new project contains branches for the specified stages (i.e. dev, staging, and production).  
        
    To create a new project use command `create project` and specify the name of the project as well as the shipyard file.
    ```console
    keptn create project sockshop shipyard.yml
    ```

1. Onboard a new service:

    For describing the used Kubernetes resources, [Helm charts](https://helm.sh/) are used.
    Here, the CLI allows setting a Helm values description in the before created project.
    Optionally, the user can also provide a Helm deployment and service description.

    To onboard a service using the Helm descriptions use command `onboard service` and provide the project name, the Helm values description and optionally also deployment and service descriptions.
    ```console
    keptn onboard service --project=sockshop --values=values.yaml
    ```
    or
    ```console
    keptn onboard service --project=sockshop --values=values.yaml --deployment=deployment.yaml --service=service.yaml
    ```
