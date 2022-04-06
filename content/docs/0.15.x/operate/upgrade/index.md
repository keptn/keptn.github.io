---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.14
weight: 30
aliases:
  - /docs/0.14.0/operate/upgrade/
  - /docs/0.14.1/operate/upgrade/
---

## Upgrade from Keptn 0.13.x to Keptn 0.14.x

With Keptn 0.14.x, we upgraded the NATS cluster and with that, we changed its name.
For existing integration that are not yet updated to use a 0.14.x distributor, please update the distributor `PUBSUB_URL` environment variable and set it to `nats://keptn-nats`.
Please, refer to the [distributor documentation](https://github.com/keptn/keptn/tree/master/distributor#distributor) for further details.

<details><summary>Expand to see upgrade instructions:</summary>
<p>

* **Step 1.** To download and install the Keptn CLI for version 0.14.1, you can choose between:
   * *Automatic installation of the Keptn CLI (Linux and Mac):*

      * The next command will download the 0.14.1 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
      ```console
      curl -sL https://get.keptn.sh | KEPTN_VERSION=0.14.1 bash
      ```

      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

   * *Manual installation of the Keptn CLI:*

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.14.1)
      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)
      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

* **Step 2.** To upgrade your Keptn installation from 0.13.x to 0.14.x, the Keptn CLI offers the command:

   ```console
   keptn upgrade
   ```

   * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation) before executing this command.
   * If you encounter an issue of the CLI saying: `Error: your current Keptn CLI context 'cluster' does not match current Kubeconfig '` when executing the above command, please set the config *KubeContextCheck* using: 

   ```
   keptn set config KubeContextCheck true
   ```

   * If the CLI still complains about the context, please use the Helm approach to upgrade your cluster:

   ```console
   helm upgrade keptn keptn --install -n keptn --create-namespace --repo=https://charts.keptn.sh --version=0.14.1 --reuse-values --wait
   ```

* :warning: **Step 3.** If you are using the **jmeter-service** or **helm-service**, upgrade them to 0.14.1 using the following commands:

   ```console
   helm repo update
   helm upgrade jmeter-service https://github.com/keptn/keptn/releases/download/0.14.1/jmeter-service-0.14.1.tgz -n keptn --create-namespace --wait --reuse-values
   helm upgrade helm-service https://github.com/keptn/keptn/releases/download/0.14.1/helm-service-0.14.1.tgz -n keptn --create-namespace --wait --reuse-values
   ```

</p>
</details>
