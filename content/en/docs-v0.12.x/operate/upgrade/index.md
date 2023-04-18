---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.12
weight: 30
aliases:
  - /docs/0.12.0/operate/upgrade/
---

## Upgrade from Keptn 0.11.x to Keptn 0.12.0

<details><summary>Expand to see upgrade instructions:</summary>
<p>

* **Step 1.** To download and install the Keptn CLI for version 0.12.0, you can choose between:
   * *Automatic installation of the Keptn CLI (Linux and Mac):*

      * The next command will download the 0.12.0 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.
      ```console
      curl -sL https://get.keptn.sh | KEPTN_VERSION=0.12.0 bash
      ```

      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

   * *Manual installation of the Keptn CLI:*

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.12.0)
      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)
      * Verify that the installation has worked and that the version is correct by running:
      ```console
      keptn version
      ```

* **Step 2.** To upgrade your Keptn installation from 0.11.x to 0.12.0, the Keptn CLI offers the command:
  
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
   helm upgrade keptn keptn --install -n keptn --create-namespace --repo=https://charts.keptn.sh --version=0.12.0 --reuse-values --wait
   ```

* :warning: **Step 3.** If you are using the **jmeter-service** or **helm-service**, upgrade them to 0.12.0 using the following commands: 

   ```console
   helm repo update
   helm upgrade jmeter-service https://github.com/keptn/keptn/releases/download/0.12.0/jmeter-service-0.12.0.tgz -n keptn --create-namespace --wait --reuse-values
   helm upgrade helm-service https://github.com/keptn/keptn/releases/download/0.12.0/helm-service-0.12.0.tgz -n keptn --create-namespace --wait --reuse-values
   ```

</p>
</details>
