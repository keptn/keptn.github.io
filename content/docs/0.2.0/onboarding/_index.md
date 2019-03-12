---
title: Onboarding of a service
description: The CLI allows controlling keptn by sending commands to the keptn installation. In the current release, the CLI can be used to onboard a service.
weight: 36
keywords: [cli, onboard]
---


## Install the CLI
Every release of Keptn provides binaries for the CLI. These binaries are available for Linux, macOS, and Windows.

1. Download your [desired version](https://github.com/keptn/keptn/releases/tag/0.2)
2. Unpack the download <!--- Check if necessary -->
3. Find the `kepn` binary in the unpacked directory, add executable permissions (``chmod +x keptn``), and move it to its desired destination (``mv keptn /usr/local/bin/keptn``)

Now, you should be able to run the CLI by 
```console
keptn --help
```

## Steps and commands to onboard a service
In this release, the CLI allows to onboard a new service.
Therefore, the commands described in the following can be used.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g. usage of the command or description of flags).

**Note:** In the current version, keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.

1. Authentication against the keptn installation:

    Before the CLI can be used, it needs to be authenticated against a keptn installation.
    Therefore, an endpoint and an API token are required. Both are exposed during the keptn installation.
    
    If the authentication is successful, the endpoint and the API token are stored in a password store of the respective operating system.
    Therefore, the CLI stores the endpoint and API token using `pass` in case of Linux, using the `Keychain` in case of macOS, or
    `Wincred` in case of Windows.

    Example:
    ```console
    keptn auth --endpoint=mykeptnendpoint.com --api-token=xyz
    ```

1. Configure the used GitHub organization, user, and personal access token:

    Next, the CLI is used to set the GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user in the keptn installation.

    <span style="color:red">
    **Note:** Currently, this functionality is not implemented in keptn, i.e. in the GitHub service. Instead, the organization, user, and token are hard-coded.
    For the organization `keptn-tiger`, for the user `johannes-b`, and a respective token is used. We will implement this functionality soon. 
    </span>

    <span style="color:red">
    **Note:** Should we describe a best practice, which creates a new GitHub user only used by keptn?
    </span>

    Example:
    ```console
    keptn configure --org=MyOrg --user=keptnUser --token=XYZ
    ```

1. Create a new project in GitHub:

    Next, the CLI is used to create a new project. Therefore, the user has to provide a name for the project and a shipyard file describing the used stages.

    Example:
    ```console
    keptn create project sockshop shipyard.yml
    ```

1. Onboard a new service:

    Finally, the CLI is used to onboard a new service in the before created project.
    For onboarding a new service, the user has to provide a Helm values description. Optionally, the user can also provide a Helm deployment and service description.

    Example:
    ```console
    keptn onboard service --project=carts --values=values.yaml
    ```
    or
    ```console
    keptn onboard service --project=carts --values=values.yaml --deployment=deployment.yaml --service=service.yaml
    ```