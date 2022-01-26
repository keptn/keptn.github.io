---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.11
weight: 30
aliases:
  - /docs/0.11.2/operate/upgrade/
  - /docs/0.11.3/operate/upgrade/
  - /docs/0.11.4/operate/upgrade/
---

## Upgrade from Keptn 0.11.x to Keptn 0.11.4

<details><summary>Expand to see upgrade instructions:</summary>
<p>

* **Step 1.** To download and install the Keptn CLI for version 0.11.4, you can choose between:
   * *Automatic installation of the Keptn CLI (Linux and Mac):*

      * The next command will download the 0.11.4 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
      ```console
      curl -sL https://get.keptn.sh | KEPTN_VERSION=0.11.4 bash
      ```

      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

   * *Manual installation of the Keptn CLI:*

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.11.4)
      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)
      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

* **Step 2.** To upgrade your Keptn installation from 0.11.x to 0.11.4, the Keptn CLI offers the command:
  
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
   helm upgrade keptn keptn --install -n keptn --create-namespace --repo=https://charts.keptn.sh --version=0.11.4 --reuse-values --wait
   ```

* :warning: **Step 3.** If you are using the **jmeter-service** or **helm-service**, upgrade them to 0.11.4 using the following commands: 

   ```console
   helm repo update
   helm upgrade jmeter-service https://github.com/keptn/keptn/releases/download/0.11.4/jmeter-service-0.11.4.tgz -n keptn --create-namespace --wait --reuse-values
   helm upgrade helm-service https://github.com/keptn/keptn/releases/download/0.11.4/helm-service-0.11.4.tgz -n keptn --create-namespace --wait --reuse-values
   ```

</p>
</details>

## Upgrade from Keptn 0.10.x to 0.11.x

❗️**CAUTION: This release requires a manual migration of all data in the Keptn MongoDB. Therefore, please execute all 4 steps mentioned in the upgrade instructions**❗️

<details><summary>Expand to see upgrade instructions:</summary>
<p>

* **Step 1.** Before starting the update, it is mandatory to create a backup of your Keptn projects. To do so, please follow the instructions in the [0.10.x backup guide](../../../0.10.x/operate/backup_and_restore).

* **Step 2.** To download and install the Keptn CLI for version 0.11.x, you can choose between:
   * *Automatic installation of the Keptn CLI (Linux and Mac):*

      * The next command will download the 0.11.4 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
      ```console
      curl -sL https://get.keptn.sh | KEPTN_VERSION=0.11.4 bash
      ```

      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

   * *Manual installation of the Keptn CLI:*

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.11.4)
      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)
      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

* **Step 3.** To upgrade your Keptn installation from 0.10.x to 0.11.x, the Keptn CLI offers the command:
   ```console
   keptn upgrade
   ```

      * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation) before executing this command.
      * This CLI command executes a Helm upgrade using the Helm chart from: [keptn-installer/keptn-0.11.4.tgz](https://charts.keptn.sh/packages/keptn-0.11.4.tgz)


* **Step 4.** Restore your Mongo DB and configuration service data according to the steps in the [restore guide](../../operate/backup_and_restore).

* :warning: **Step 5.** If you are using the **jmeter-service** or **helm-service**, upgrade them to 0.11.4 using the following commands: 
   ```console
   helm repo update
   helm upgrade jmeter-service https://github.com/keptn/keptn/releases/download/0.11.4/jmeter-service-0.11.4.tgz -n keptn --create-namespace --wait --reuse-values
   helm upgrade helm-service https://github.com/keptn/keptn/releases/download/0.11.4/helm-service-0.11.4.tgz -n keptn --create-namespace --wait --reuse-values
   ```

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

</p>
</details>
