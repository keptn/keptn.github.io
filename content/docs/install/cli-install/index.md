---
title: Install Keptn CLI
description: Install binaries for the Keptn CLI
weight: 35
---

The Keptn CLI must be installed on the local machine.
It is used to send commands to Keptn by interacting with the API of Keptn.
To communicate with Keptn, you must know a shared secret
that is generated during the installation and verified by the *api* component.

Binaries for the Keptn CLI are provided for Linux, macOS, and Windows.

- Download the version for your operating system from: [GitHub](https://github.com/keptn/keptn/releases/tag/0.16.0)
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

