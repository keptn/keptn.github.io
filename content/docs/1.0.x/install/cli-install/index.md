---
title: Install Keptn CLI
description: Install binaries for the Keptn CLI
weight: 35
---

Install the Keptn CLI on the local machine
that is used to interact with your cloud provider, Kubernetes, etc.
The Keptn CLI is not Keptn itself
but is instead an interface to Keptn,
much as **kubectl** is an interface to Kubernetes.

The Keptn CLI sends commands to Keptn by interacting with the Keptn API.
The [API Token](../../operate/api_token)
that is used to communicate with Keptn is generated during the installation.

It is not absolutely necessary to install the Keptn CLI for current Keptn releases,
which allow you to create a project or run a sequence using the [Keptn Bridge](../../bridge),
but it is recommended for production systems.

You can install the Keptn CLI using:

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

**Note:** For the rest of the documentation we will stick to the *Linux / macOS* version of the commands.

