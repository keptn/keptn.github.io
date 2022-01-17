---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.10
weight: 30
aliases:
  - /docs/0.10.0/operate/upgrade/
---

## Upgrade from Keptn 0.9.x to 0.10.0

<details><summary>Expand to see upgrade instructions:</summary>
<p>

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore).

1. To download and install the Keptn CLI for version 0.10.0, you can choose between:
    * **Automatic installation of the Keptn CLI (Linux and Mac)**:

        * The next command will download the 0.10.0 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
```console
curl -sL https://get.keptn.sh | KEPTN_VERSION=0.10.0 bash
```

      * Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

    * **Manual installation of the Keptn CLI:**

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.10.0)

      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)

      * Verify that the installation has worked and that the version is correct by running:
```console
keptn version
```

1. To upgrade your Keptn installation from 0.9.x to 0.10.0, the Keptn CLI offers the command:
```console
keptn upgrade
```

    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before executing this command.

    * This CLI command executes a Helm upgrade using the Helm chart from: [keptn-installer/keptn-0.10.0.tgz](https://charts.keptn.sh/packages/keptn-0.10.0.tgz)

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

</p>
</details>
