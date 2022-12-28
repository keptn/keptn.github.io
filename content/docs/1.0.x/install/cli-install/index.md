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

You can use the `curl` command to install the Keptn CLI on Linux, WSL2, and macOS.
Windows users need `bash`, `curl`, and `awk` installed (e.g., using Git Bash).

1. Download the *latest stable Keptn version*
   from [GitHub](https://github.com/keptn/keptn/releases),
   unpack it, and install it into the current directory on your cloud shell machine:

   ```
   curl -sL https://get.keptn.sh/ | bash
   ```

   Use **sudo** to move the file to another location.
   such as `/usr/local/bin/keptn`.
   You can run the Keptn CLI from any directory
   but you may need to specify the location of the path,
   using `./keptn` rather than just `keptn` if it is in your current directory.

2. Verify that the installation has worked and that the version is correct.
   On Linux and macOS, run:

    ```
    keptn version
    ```
    On Windows, run:

    ```
    .\keptn.exe version
    ```
## Installation on macOS using brew

1. Run the following command to automatically fetch the latest Keptn CLI via Homebrew:

   ```
   brew install keptn
   ```

1. Verify that the installation has worked and that the version is correct by running:

   ```
   keptn version
   ```

1. To upgrade Keptn CLI to a new release, run:

   ```
   brew upgrade keptn
   ```

1. To uninstall Keptn CLI, run:

   ```
   brew uninstall keptn
   ```

## Manually install Keptn CLI from binaries

Each release of Keptn provides binaries for the Keptn CLI.
These binaries are available for Linux, macOS, and Windows.
To install the Keptn CLI from the binaries:

1. Download the
   [version matching your operating system](https://github.com/keptn/keptn/releases/).
1. Unpack the archive.
1. Find the `keptn` binary in the unpacked directory.
   * *Linux / macOS*:
     * Add executable permissions:
       ```
       chmod +x keptn
       ```
     * Move the `keptn` binary to the desired destination
       For example,
       ```
       mv keptn /usr/local/bin/keptn
       ```

   * *Windows*:
     * Move/copy the executable to the desired folder.
     * Optionally, add the executable to the `PATH` environment variable.

1. Verify that the installation has worked and that the version is correct.

   * On Linux or MacOS, run:

     ```
     keptn version
     ```

    * On Windows, run:

      ```
      .\keptn.exe version
      ```

After you install both the Keptn CLI and Keptn itself,
you must authenticate the CLI and the Bridge.
See [Authenticate Keptn CLI and Bridge](../authenticate-cli-bridge).

