---
title: Keptn CLI
description: Explains how to download and install the keptn CLI as well as which commands are available.
weight: 30
icon: help
keywords: [cli, setup]
---

In this section, the functionality and commands of the keptn CLI are described. The keptn CLI allows installing, configuring, and
uninstalling Keptn. Furthermore, the CLI allows creating projects, onboarding services, and sending new artifact events.

## Prerequisites
- All prerequisites from the [setup](../../installation/setup-keptn#prerequisites) are needed.

## Automatic install of the keptn CLI

This works for Linux and Mac only.

1. This will download the 0.6.2 CLI version from [GitHub](https://github.com/keptn/keptn/releases), unpack it and move it to `/usr/local/bin/keptn`.
```console
curl -sL https://get.keptn.sh | sudo -E bash
```

2. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

## Download and manual install of the keptn CLI
Every release of Keptn provides binaries for the keptn CLI. These binaries are available for Linux, macOS, and Windows.

1. Download the [version matching your operating system](https://github.com/keptn/keptn/releases/)
1. Unpack the download
1. Find the `keptn` binary in the unpacked directory.
  - *Linux / macOS*: Add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - *Windows*: move/copy the executable to the desired folder and, optionally, add the executable to the PATH environment variable for a more convenient experience.

1. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

## Start using the keptn CLI

In the following, the commands provided by the keptn CLI are described. To list all available commands just execute:
    
```console
keptn --help
```

All of these commands also support the help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

## Authentication

To fully use the keptn CLI, it needs to be authenticated against a Kubernetes cluster with Keptn already installed on it. 
Therefore, an endpoint and an API token are required.

If the authentication is successful, keptn CLI will inform the user. The specified endpoint as well as the API token are 
stored in a password store of the underlying operating system. More precisely, the keptn CLI stores the endpoint and 
API token using `pass` in case of Linux, using `Keychain` in case of macOS, or `Wincred` in case of Windows.

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

**Note**: If you receive a warning `Using a file-based storage for the key because the password-store seems to be not set up.` this is because a password store could not be found in your environment. In this case, the credentials are stored in `~/.keptn/.password-store` in your home directory.
</p>
</details>

<details><summary>For Windows</summary>
<p>

Please expand the corresponding section matching your CLI tool.

<details><summary>PowerShell</summary>
<p>

For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables. Please note that the PowerShell might have to be started with **Run as Administrator** privileges to install the module.

1. Copy the following snippet and paste it in the PowerShell. The snippet will be automatically executed line by line.

    ```
    $tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
    $Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
    $Env:KEPTN_ENDPOINT = 'https://api.keptn.'+$(kubectl get cm -n keptn keptn-domain -ojsonpath='{.data.app_domain}')
    ```

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the keptn CLI. To authenticate against the Keptn cluster, use the `auth` command with the Keptn endpoint and API token:

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
    set KEPTN_API_TOKEN=keptn-api-token
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

1. Now that everything we need is stored in environment variables, we can proceed with authorizing the keptn CLI.

    To authenticate against the Keptn cluster, use the `auth` command with the Keptn endpoint and API token:

    ```
    keptn.exe auth --endpoint=KEPTN_ENDPOINT --api-token=KEPTN_API_TOKEN
    ```

</p>
</details>
</p>
</details>