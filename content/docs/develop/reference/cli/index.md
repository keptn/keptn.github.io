---
title: Keptn CLI
description: The following description explains how to connect the Keptn CLI to your Keptn cluster and which commands are available.
weight: 10
keywords: [cli, setup]
---

In this section, the functionality and commands of the Keptn CLI are described. The Keptn CLI allows installing, configuring, and
uninstalling Keptn. Furthermore, the CLI allows creating projects, onboarding services, and sending new artifact events.

## Prerequisites
- All prerequisites from the [setup](../../installation/setup-keptn#prerequisites) are needed.

## Install the Keptn CLI
Every release of Keptn provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

1. Download the [version matching your operating system](https://github.com/keptn/keptn/releases/)
1. Unpack the download
1. Find the `keptn` binary in the unpacked directory.
  - Linux / macOS
    
    add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - Windows

    move/copy the executable to the desired folder and, optionally, add the executable to your PATH environment variable for a more convenient experience.

4. Now, you should be able to run the Keptn CLI by 
    ```console
    keptn --help
    ```
{{< popup_image
    link="./assets/keptn-cli-help.png"
    caption="Keptn CLI"
    width="700px">}}


## Start using the Keptn CLI

In the following, the commands provided by the Keptn CLI are described.
All of these commands provide a help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

> **Note:** In the current version, Keptn is missing checks whether the sent command is executed correctly.
In order to guarantee the expected behavior, please strictly use the following commands in the specified order.
In future releases, we add additional checks whether the executed commands succeeded or failed.

### keptn install 

The Keptn CLI allows to install Keptn on an Azure Kubernetes Services (AKS), an Amazon Elastic Kubernetes Service (EKS),
a Google Kubernetes Engine (GKE), and on OpenShift. Further details are provided [here](../../installation/#install-keptn).

- For **AKS**:

    ```console
    keptn install --platform=aks
    ```
- For **EKS**:

    ```console
    keptn install --platform=eks
    ```

- For **GKE**:

    ```console
    keptn install --platform=gke
    ```

- For **OpenShift**:

    ```console
    keptn install --platform=openshift
    ```

### keptn configure domain

The Keptn CLI allows to configure your custom domain. This is mandatory if you cannot use xip.io (e.g., because you are running in AWS that will create ELBs for you).

> **Note:** This command requires a *kubernetes current context* pointing to the cluster where you would like to uninstall Keptn. After installing Keptn this is guaranteed.

```console
keptn domain YOUR_CUSTOM_DOMAIN
```

### keptn auth 

Before the keptn CLI can be used, it needs to be authenticated against a keptn cluster. Therefore, an endpoint and an API token are required.

If the authentication is successful, keptn will inform the user and the endpoint as well as the API token are stored in a password store of the underlying operating system. More precisely, the keptn CLI stores the endpoint and API token using `pass` in case of Linux, using `Keychain` in case of macOS, or `Wincred` in case of Windows.

<details><summary>For Linux / macOS</summary>
<p>

Set the needed environment variables.

```console
KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
```

Authenticate to the Keptn cluster.

```console
keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

> **Note**: If you receive a warning `Using a file-based storage for the key because the password-store seems to be not set up.` this is because a password store could not be found in your environment. In this case, the credentials are stored in `~/.keptn/.password-store` in your home directory.
</p>
</details>

<details><summary>For Windows</summary>
<p>

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

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the Keptn CLI. To authenticate against the Keptn cluster use command auth and your endpoint and API token:

    ```
    keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
    ```

</p>
</details>

<details><summary>Command Line</summary>
<p>

In the Windows Command Line, a couple of steps are necessary.

1. Get the Keptn API Token encoded in base64

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

1. Get the Keptn cluster endpoint 

    ```console
    kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}
    ```

    ```console
    YOUR.DOMAIN
    ```

1. Copy the `domain` value and save it in an environment variable

    ```
    set KEPTN_ENDPOINT=https://api.keptn.YOUR.DOMAIN
    ```

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the Keptn CLI.

    To authenticate against the Keptn cluster use command `auth` and your endpoint and API token:

    ```
    keptn.exe auth --endpoint=%KEPTN_ENDPOINT% --api-token=%KEPTN_API_TOKEN%
    ```

</p>
</details>
</p>
</details>

### keptn create project 

To create a new project, use the command `create project` and specify the name of the project as well as the `shipyard.yaml` file. Learn here more [about writing a shipyard file](../../manage/project/#create-a-project).

```console
keptn create project my-project shipyard.yml
```

### keptn onboard service

To onboard a service, use the command `onboard service` and provide the service name (e.g., `my-service`), project name (`--project` flag) and its Helm chart (`--chart` flag):

```console
keptn onboard service my-service --project=my-project --chart=my-service.tgz
```

To learn more about onboarding a service, please see the [Onboarding a Service](../../usecases/onboard-carts-service) use case.

### keptn add-resource
To add a resource to the configuration store (i.e., git repository) of a service, the `add-resource` command is provided. This command takes a local resource (`--resource` flag) and stores it for further use in Keptn. Thus, this command allows you to add, for example, *test files* to your service, which will then be executed by a test-service (e.g., jmeter-service) during the continuous delivery.  

```console
keptn add-resource --project=my-project --service=my-service --stage=dev --resource=jmeter/basiccheck.jmx
```

### keptn configure monitoring

To configure a monitoring solution for your Keptn cluster, the `configure monitoring` command is provided. This command sets up monotoring in case it is not installed yet. Afterwards, the command configures the monitoring solution for a service based on the provided service indicators (`--service-indicators` flag), and service objectives (`--service-objectives` flag). The currently supported monitoring solution is *Prometheus*, as shown below:

```console
keptn configure monitoring prometheus --project=my-project --service=my-service --service-indicators=service-indicators.yaml --service-objectives=service-objectives.yaml --remediation=remediation.yaml
```

## keptn send event new-artifact

After onboarding a service, the Keptn CLI allows pushing a new artifact for the service. This artifact is a Docker image, which can be located at Docker Hub, Quay, or any other registry storing docker images. The new artifact is pushed in the first stage specified in the `shipyard.yaml` file (usually this will be the dev stage).
Afterwards, Keptn takes care of deploying this new artifact to the other stages.

To push a new artifact, use the command `send event new-artifact`, which sends a new-artifact-event to keptn in order to deploy a new artifact for the specified service in the provided project.
Therefore, this command takes the project (`--project` flag), the service (`--service` flag), as well as the image (`--image` flage) and tag (`--tag` flag) of the new artifact.

```console
keptn send event new-artifact --project=your_project --service=your_service --image=docker.io/keptnexamples/carts --tag=0.9.1
```

## keptn send event

To send an arbitrary Keptn event the `send event` command is provided. An event has to follow the [Cloud Events](https://cloudevents.io/) specification and has to be written in JSON. Then you can pass it in by referencing the JSON file (`--file` flag).

>**Note:** This command is not required for any use case and requires precise Keptn event definitions as you can find [here](https://github.com/keptn/keptn/blob/develop/specification/cloudevents.md).

```console
keptn send event --file=new_artifact.json
```

## keptn version

To show the current version of the Keptn CLI, the `version` command is provided.

```console
keptn version
```

## keptn uninstall

To uninstall Keptn from your cluster, the `uninstall` command is provided.

> **Note:** This command requires a *kubernetes current context* pointing to the cluster where you would like to uninstall Keptn.

```console
keptn uninstall
```