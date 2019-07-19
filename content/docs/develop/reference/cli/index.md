---
title: keptn CLI
description: The following description explains how to use the keptn CLI and connect it to your keptn server.
weight: 10
keywords: [cli, setup]
---

In this section, the functionality and commands of the keptn CLI are described. The keptn CLI allows installing keptn,
configuring keptn, creating new projects, onboarding new services, and sending new artifact events.

## Prerequisites
-  All prerequisites from the [setup](../../installation/setup-keptn-gke#prerequisites) are needed.
- A GitHub organization, a GitHub user, and [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line). 

## Install the keptn CLI
Every release of keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

1. Download the [version matching your operating system](https://github.com/keptn/keptn/releases/)
1. Unpack the download
1. Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
        add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

        move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.


1. Now, you should be able to run the keptn CLI by 
```console
keptn --help
```
{{< popup_image
    link="./assets/keptn-cli-help.png"
    caption="keptn CLI"
    width="700px">}}


## Start using the keptn CLI

In the following, the commands provided by the keptn CLI are described.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

**Note:** In the current version, keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.
In future releases, we add additional checks whether the executed commands succeeded or failed.

## keptn install 

The keptn CLI allows to install keptn on a Google Kubernetes Engine (GKE), OpenShift or Azure Kubernetes Services (AKS). Further details are provided [here](../../installation/#install-keptn).

  - For **GKE**:

    ```console
    keptn install --platform=gke
    ```

  - For **OpenShift**:

    ```console
    keptn install --platform=openshift
    ```

  - For **AKS**:

    ```console
    keptn install --platform=aks
    ```

## keptn auth 

Before the keptn CLI can be used, it needs to be authenticated against a keptn server. Therefore, an endpoint and an API token are required.

**Note:** The CLI is automatically authenticated after installing keptn using the CLI. Hence, `keptn auth` can be skipped.

If the authentication is successful, keptn will inform the user. Furthermore, if the authentication is successful, the endpoint and the API token are stored in a password store of the underlying operating system.
More precisely, the keptn CLI stores the endpoint and API token using `pass` in case of Linux, using `Keychain` in case of macOS, or `Wincred` in case of Windows.

### Linux / macOS

Set the needed environment variables.

```console
KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain})
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    
```

Authenticate to the keptn server.

```console
keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

**Note**: If you receive a warning `Using a file-based storage for the key because the password-store seems to be not set up.` it is because a password store could not be found in your environment. In this case, the credentials are stored in a file called `.keptn` in your home directory.


### Windows 

Please expand the corresponding section matching your CLI tool.

<details><summary>PowerShell</summary>
<p>

For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables. Please note that the PowerShell might have to be started with **Run as Administrator** privileges to install the module.

1. Copy the following snippet and paste it in your PowerShell. The snippet will be automatically executed line by line.

    ```
    $tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
    $Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
    $Env:KEPTN_ENDPOINT = 'https://api.keptn.'+$(kubectl get cm -n keptn keptn-domain -ojsonpath='{.data.app_domain}')
    ```

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the keptn CLI. To authenticate against the keptn server use command auth and your endpoint and API token:

    ```
    keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
    ```

</p>
</details>

<details><summary>Command Line</summary>
<p>

In the Windows Command Line, a couple of steps are necessary.

1. Get the keptn API Token encoded in base64

    ```console
    kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
    ```

    ```console
    abcdefghijkladfaea
    ```

1. Take the encoded API token - it is the value from the key `keptn-api-token` (in this example, it is `abcdefghijkladfaea`) and save it in a text file, e.g., `keptn-api-token-base64.txt`

1. Decode the file

    ```
    certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
    ```

1. Open the newly created file `keptn-api-token.txt`, copy the value and paste it into the next command

    ```
    set KEPTN_API_TOKEN=value-of-your-token
    ```

1. Get the keptn server endpoint 

    ```console
    kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}
    ```

    ```console
    XX.XXX.XXX.XX.xip.io
    ```

1. Copy the `domain` value and save it in an environment variable

    ```
    set KEPTN_ENDPOINT=https://api.keptn.XX.XXX.XXX.XX.xip.io
    ```

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the keptn CLI.

    To authenticate against the keptn server use command `auth` and your endpoint and API token:

    ```
    keptn.exe auth --endpoint=%KEPTN_ENDPOINT% --api-token=%KEPTN_API_TOKEN%
    ```

</p>
</details>





## keptn configure 

In order to work with GitHub (i.e. create a new project, make commits), keptn requires a
GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user.
Therefore, the keptn CLI is used to set the GitHub organization, the GitHub user, and the GitHub personal access token belonging to that user in the keptn server.

**Note:** Keptn is automatically configured after installing keptn using the CLI. Hence, `keptn configure` can be skipped

To configure, use the command `configure` and specify the GitHub organization (flag `--org`), user (flag `--user`),
and personal access token (flag `--token`):

```console
keptn configure --org=gitHubOrg --user=gitHub_keptnUser --token=XYZ
```

## keptn create project 

Before onboarding a service, a project needs to be created. A project represents a repository in the GitHub organization that is used by keptn. This project contains branches representing the multi-stage environment (e.g., dev, staging, and production stage). In other words, the separation of stage configurations is based on repository branches. To describe each stage, a `shipyard.yaml` file is needed that specifies the name, deployment strategy, and test strategy as shown below:

```yaml
registry: sockshop
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    deployment_strategy: "blue_green_service"
```

To create a new project, use the command `create project` and specify the name of the project as well as the `shipyard.yaml` file.

```console
keptn create project your_project shipyard.yml
```

## keptn onboard service

After creating a project which represents a repository in your GitHub organization, the keptn&nbsp;CLI allows to onboard services into this project. Please note that for describing the Kubernetes resources, [Helm charts](https://helm.sh/) are used. Therefore, the keptn CLI allows setting a Helm values description in the before created project. Optionally, the user can also provide a Helm deployment and service description.

To onboard a service, use the command `onboard service` and provide the project name (flag `--project`), the Helm chart values (flag `--values`) and optionally also deployment (flag `--deployment`) and service (flag `--service`) configuration.

- Use default deployment and service configuration:

```console
keptn onboard service --project=your_project --values=values.yaml
```

- Use custom deployment and service configuration:
  
```console
keptn onboard service --project=your_project --values=values.yaml --deployment=deployment.yaml --service=service.yaml
```

**Note:** If you are using custom configurations and you would like to have the environment variables `KEPTN_PROJECT`, `KEPTN_STAGE`, and `KEPTN_SERVICE` within your service, add the following environment variables to your deployment configuration.

  ```yaml
  env:
  ...
  - name: KEPTN_PROJECT
    value: "{{ .Chart.Name }}"
  - name: KEPTN_SERVICE
    value: "{{ .Values.SERVICE_PLACEHOLDER_C.service.name }}"
  - name: KEPTN_STAGE
    valueFrom:
      fieldRef:
        fieldPath: "metadata.namespace"
  ```

To start onboarding a service, please see the [Onboarding a Service](../../usecases/onboard-carts-service) use case.

## keptn send event new-artifact

After onboarding a service, the keptn&nbsp;CLI allows pushing a new artifact for the service.
This artifact is a Docker image, which can be located at Docker Hub, Quay, or any other registry storing docker images.
The new artifact is pushed in the first stage specified in the  `shipyard.yaml` file (usually this will be the dev-stage).
Afterwards, keptn takes care of deploying this new artifact.

To push a new artifact, use the command `send event new-artifact`, which sends a new-artifact-event 
to keptn in order to deploy a new artifact for the specified service in the provided project.
Therefore, this command takes the project (flag `--project`), the service (flag `--service`), 
as well as the image (flag `--image`) and tag (flag `--tag`) of the new artifact.

```console
keptn send event new-artifact --project=your_project --service=your_service --image=docker.io/keptnexamples/carts --tag=0.8.1
```

## keptn send event

This command allows sending arbitrary keptn events. These events have to follow the [Cloud Events](https://cloudevents.io/)
specification and are written in JSON.
**Note:** This command is not required for any use case and requires precise keptn event definitions as you
can find [here](https://github.com/keptn/keptn-specification/blob/master/cloudevents.md).

To send an arbitrary keptn event, use the command `send event` and pass the file containing the event (flag `--file`).
```console
keptn send event --file=new_artifact.json
```

## keptn version

Prints the version of the keptn CLI.

```console
keptn version
```