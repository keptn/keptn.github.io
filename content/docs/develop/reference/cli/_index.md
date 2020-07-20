---
title: Keptn CLI
description: Explains how to download and install the Keptn CLI as well as which commands are available.
weight: 30
icon: help
keywords: [cli, setup]
---

In this section, the functionality and commands of the Keptn CLI are described. The Keptn CLI allows installing, configuring, and
uninstalling Keptn. Furthermore, the CLI allows creating projects, onboarding services, and sending new artifact events.

## Prerequisites
- All prerequisites from the [setup](../../installation/setup-keptn#prerequisites) are needed.

## Automatic install of Keptn CLI

This works for Linux and Mac only.

1. This will download the 0.6.2 CLI version from [GitHub](https://github.com/keptn/keptn/releases), unpack it and move it to `/usr/local/bin/keptn`.
```console
curl -sL https://get.keptn.sh | sudo -E bash
```

2. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

## Download and manual install of Keptn CLI
Every release of Keptn provides binaries for the Keptn CLI. These binaries are available for Linux, macOS, and Windows.

1. Download the [version matching your operating system](https://github.com/keptn/keptn/releases/)
1. Unpack the download
1. Find the `keptn` binary in the unpacked directory.
  - *Linux / macOS*: Add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - *Windows*: move/copy the executable to the desired folder and, optionally, add the executable to the PATH environment variable for a more convenient experience.

1. Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

## Start using Keptn CLI

In the following, the commands provided by the Keptn CLI are described. To list all available commands just execute:
    
```console
keptn --help
```

All of these commands also support the help flag (`--help`), which describes details of the respective command (e.g., usage of the command or description of flags).

## Authenticate Keptn CLI

To authenticate the Keptn CLI against the Keptn cluster, the exposed Keptn endpoint and API token are required. 

* Get the Keptn endpoint from the `api-gateway-nginx`. (If you are using port-forward to expose Keptn, your endpoint is `localhost` and the `port` you forwarded Keptn to, e.g.: `http://localhost:8080`) 

  ```console
kubectl -n keptn get service api-gateway-nginx
  ```

  ```console
NAME                TYPE        CLUSTER-IP    EXTERNAL-IP                  PORT(S)   AGE
api-gateway-nginx   ClusterIP   10.107.0.20   <ENDPOINT_OF_API_GATEWAY>    80/TCP    44m
  ```

<details><summary>Retrive API Token and Authenticate Keptn CLI on **Linux / MacOS**</summary>
<p>

* Set the environment variable `KEPTN_ENDPOINT`:

```console
KEPTN_ENDPOINT=<ENDPOINT_OF_API_GATEWAY>
```

* Set the environment variable `KEPTN_API_TOKEN`:

```console
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```console
keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN
```

**Note**: If you receive a warning `Using a file-based storage for the key because the password-store seems to be not set up.` this is because a password store could not be found in your environment. In this case, the credentials are stored in `~/.keptn/.password-store` in your home directory.
</p>
</details>

<details><summary>Retrive API Token and Authenticate Keptn CLI on **Windows**</summary>
<p>

Please expand the corresponding section matching your CLI tool:

<details><summary>PowerShell</summary>
<p>

For the Windows PowerShell, a small script is provided that installs the `PSYaml` module and sets the environment variables.

* Set the environment variable `KEPTN_ENDPOINT`:

```console
$Env:KEPTN_ENDPOINT = '<ENDPOINT_OF_API_GATEWAY>'
```

* Copy the following snippet and paste it in the PowerShell. The snippet retrieves the API token and sets the environment variable `KEPTN_API_TOKEN`:

```
$tokenEncoded = $(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}')
$Env:KEPTN_API_TOKEN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenEncoded))
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```
keptn auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
```

</p>
</details>

<details><summary>Command Line</summary>
<p>

In the Windows Command Line, a couple of steps are necessary.

* Set the environment variable `KEPTN_ENDPOINT`:

```console
set KEPTN_ENDPOINT=<ENDPOINT_OF_API_GATEWAY>
```

* Get the Keptn API Token encoded in base64:

```console
kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token}
```

```console
abcdefghijkladfaea
```

* Take the encoded API token - it is the value from the key `keptn-api-token` (in this example, it is `abcdefghijkladfaea`) and save it in a text file, e.g., `keptn-api-token-base64.txt`

* Decode the file:

```
certutil -decode keptn-api-token-base64.txt keptn-api-token.txt
```

* Open the newly created file `keptn-api-token.txt`, copy the value and paste it into the next command:

```
set KEPTN_API_TOKEN=keptn-api-token
```

* To authenticate the CLI against the Keptn cluster, use the [keptn auth](../../reference/cli/commands/keptn_auth) command:

```
keptn.exe auth --endpoint=$Env:KEPTN_ENDPOINT --api-token=$Env:KEPTN_API_TOKEN
```

</p>
</details>
</p>
</details>