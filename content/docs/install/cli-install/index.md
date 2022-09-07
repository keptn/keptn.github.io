---
title: Install Keptn CLI
description: Install binaries for the Keptn CLI
weight: 35
---

The [Keptn CLI](../../0.18.x/reference/cli/commands) provides command line tools
for various Keptn tasks.
It is possible to run Keptn without the CLI
since you can create projects and trigger sequences using the Keptn Bridge
rather than the CLI.
But some functionality, such as uploading SLIs and SLOs requires the CLI
so installing it is usually a good idea.

Every Keptn release provides binaries for the Keptn CLI.
These binaries are available for Linux, macOS, and Windows.
To install:

- Download the version for your operating system from: [GitHub](https://github.com/keptn/keptn/releases/)
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

