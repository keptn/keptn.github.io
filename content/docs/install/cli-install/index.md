---
title: Install Keptn CLI
description: Install binaries for the Keptn CLI
weight: 35
---

The [Keptn CLI](../../0.18.x/reference/cli/commands) provides command line tools
for various Keptn tasks.
The Keptn CLI is not Keptn itself
but is instead an interface to Keptn,
much as **kubectl** is an interface to Kubernetes.

It is not absolutely necessary to install the Keptn CLI for current Keptn releases,
which allow you to create a project or run a sequence using the [Keptn Bridge](../../0.18.x/bridge).
However, some functionality, such as uploading SLIs and SLOs, requires the CLI
so installing it is recommended, especially for production systems.

The Keptn CLI sends commands to Keptn by interacting with the Keptn API.
The [API Token](../../0.18.x/operate/api_token)
that is used to communicate with Keptn is generated during the installation.
After you install Keptn itself, you must then
[authenticate the CLI and Bridge](../authenticate-cli-bridge).

Install the Keptn CLI on the local machine
that is used to interact with your cloud provider, Kubernetes, etc.

Each Keptn release provides binaries for the Keptn CLI.
These binaries are available for Linux, macOS, and Windows.
Download the version for your operating system and Keptn release from
[GitHub](https://github.com/keptn/keptn/releases/).

You can then install the Keptn CLI using:

* curl
* Homebrew (MacOS only)
* Standard binary installation tools for your operating system

## curl

```
curl -sL https://get.keptn.sh/ | bash
```

This installs the Keptn CLI for you in the current directory on your cloud shell machine.
You can use **sudo** to move the file to another location.
You can run the Keptn CLI from any directory
but you may need to specify the location of the path,
using `.keptn` rather than just `keptn` if it is in your current directory.

## Homebrew

```
brew install keptn
```

## Binaries

Binaries for the Keptn CLI are provided for Linux, macOS, and Windows.

- Download the latest version for your operating system from: [GitHub](https://github.com/keptn/keptn/releases)
- Unpack the archive
- Find the `keptn` binary in the unpacked directory

  - *Linux / macOS*: Add executable permissions (``chmod +x keptn``), and move it to the desired destination (e.g. `mv keptn /usr/local/bin/keptn`)

  - *Windows*: Copy the executable to the desired folder and add the executable to your PATH environment variable.

- Now, verify that the installation has worked and that the version is correct by running:
    - *Linux / macOS*

    ```console
    keptn version
    ```

    - *Windows*

    ```console
    .\keptn.exe version
    ```

