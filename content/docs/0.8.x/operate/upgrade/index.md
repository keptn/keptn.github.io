---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.8
weight: 30
aliases:
  - /docs/0.8.0/operate/upgrade/
---

## Upgrade from Keptn 0.7 to 0.8

Please follow the three steps to succesfully upgrade your Keptn 0.7.3 to 0.8.0 

### Step 1: Keptn CLI and Keptn installation

1. Before starting the update, we strongly advise to create a backup of your Keptn projects. To do so, please follow the instructions in the [backup guide](../../operate/backup_and_restore).

1. To download and install the Keptn CLI for version 0.8.0, you can choose between:
    * **Automatic installation of the Keptn CLI (Linux and Mac)**:

      * The next command will download the 0.8.0 release from [GitHub](https://github.com/keptn/keptn/releases), unpack it, and move it to `/usr/local/bin/keptn`.

        ```console
        curl -sL https://get.keptn.sh | sudo -E bash
        ```
    
      * Verify that the installation has worked and that the version is correct by running:

        ```console
        keptn version
        ```

    * **Manual installation of the Keptn CLI:**

      * Download the release for your platform from the [GitHub](https://github.com/keptn/keptn/releases/tag/0.8.0)

      * Unpack the binary and move it to a directory of your choice (e.g., `/usr/local/bin/`)

      * Verify that the installation has worked and that the version is correct by running:
        ```console
        keptn version
        ```

1. To upgrade your Keptn installation from 0.7.3 to 0.8.0, the Keptn CLI offers the command: 
    ```console
    keptn upgrade
    ```
    
    * Please [verify that you are connected to the correct Kubernetes cluster](../../troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before executing this command.
    
    * This CLI command executes a Helm upgrade using the Helm chart from: [keptn-installer/keptn-0.8.0.tgz](https://storage.googleapis.com/keptn-installer/keptn-0.8.0.tgz)

**Note:** If you have manually modified your Keptn deployment, e.g., you deleted the Kubernetes Secret `bridge-credentials` for disabling basic auth, the `keptn upgrade` command will not detect the modification. Please re-apply your modification after performing the upgrade.

### Step 2: Upgrade Shipyard of your projects

In Keptn 0.8.0, a [new format for the shipyard](https://github.com/keptn/spec/blob/0.2.0/shipyard.md) has been introduced, and Keptn will not support shipyards based on the [previous specifiation](https://github.com/keptn/spec/blob/0.1.7/shipyard.md). Therefore, if you already have created projects on your previous Keptn installation, you will need to use the `keptn upgrade project --shipyard` command to upgrade each of your existing projects to the new format.

#### Upgrade a single project

For each project, execute the following command:

```console
PROJECT=<YOUR_PROJECT_NAME>
keptn upgrade project $PROJECT --shipyard
```

This command will retrieve the current shipyard file of the project, and convert it to the new format. The resulting shipyard will be printed to the console, and you will be asked to confirm the upload of the new version to your project repository. After confirming the dialog with `y` or `yes`, the resulting shipyard will be uploaded to your project repo and you are ready to start task sequences for your project.

**Example:** 

```console
keptn upgrade project my-project --shipyard

Shipyard of project my-project:
-----------------------
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    approval_strategy: 
      pass: "automatic"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    approval_strategy: 
      pass: "automatic"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    remediation_strategy: "automated"

Shipyard converted into version 0.2:
-----------------------
apiVersion: spec.keptn.sh/0.2.0
kind: Shipyard
metadata:
  name: ""
spec:
  stages:
  - name: dev
    sequences:
    - name: artifact-delivery
      triggers: []
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: functional
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: automatic
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers: []
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: functional
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: automatic
      - name: release
        properties: null
  - name: staging
    sequences:
    - name: artifact-delivery
      triggers:
      - dev.artifact-delivery.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: blue_green_service
      - name: test
        properties:
          teststrategy: performance
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers:
      - dev.artifact-delivery-direct.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: performance
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
  - name: production
    sequences:
    - name: artifact-delivery
      triggers:
      - staging.artifact-delivery.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: blue_green_service
      - name: test
        properties:
          teststrategy: ""
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers:
      - staging.artifact-delivery-direct.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: ""
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null

Do you want to continue with this? (y/n)
y
Shipyard of project my-project has been upgraded successfully!
```

#### Automatically upgrade a project

If you would like to automate the project upgrade process, you can append the `-y` flag to the upgrade command to directly upload the new shipyard to the project repository, without requiring a confirmation of the operation during the execution of the command. Example:

```console
keptn upgrade project my-project --shipyard -y
```

#### Dry-run before upgrading

If you would just like to inspect the resulting shipyard, but not upload it right away, you can append the `--dry-run` flag to the command. 
This flag causes the command to print the resulting shipyard file, but it will NOT upload it to the project repo:

```console
keptn upgrade project my-project --shipyard --dry-run

Shipyard of project my-project:
-----------------------
stages:
  - name: "dev"
    deployment_strategy: "direct"
    test_strategy: "functional"
  - name: "staging"
    approval_strategy: 
      pass: "automatic"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    test_strategy: "performance"
  - name: "production"
    approval_strategy: 
      pass: "automatic"
      warning: "manual"
    deployment_strategy: "blue_green_service"
    remediation_strategy: "automated"

Shipyard converted into version 0.2:
-----------------------
apiVersion: spec.keptn.sh/0.2.0
kind: Shipyard
metadata:
  name: ""
spec:
  stages:
  - name: dev
    sequences:
    - name: artifact-delivery
      triggers: []
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: functional
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: automatic
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers: []
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: functional
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: automatic
      - name: release
        properties: null
  - name: staging
    sequences:
    - name: artifact-delivery
      triggers:
      - dev.artifact-delivery.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: blue_green_service
      - name: test
        properties:
          teststrategy: performance
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers:
      - dev.artifact-delivery-direct.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: performance
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
  - name: production
    sequences:
    - name: artifact-delivery
      triggers:
      - staging.artifact-delivery.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: blue_green_service
      - name: test
        properties:
          teststrategy: ""
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
    - name: artifact-delivery-direct
      triggers:
      - staging.artifact-delivery-direct.finished
      tasks:
      - name: deployment
        properties:
          deploymentstrategy: direct
      - name: test
        properties:
          teststrategy: ""
      - name: evaluation
        properties: null
      - name: approval
        properties:
          pass: automatic
          warning: manual
      - name: release
        properties: null
```

### Step 3: Patch namespace where Keptn is installed

With the merge of [#2733](https://github.com/keptn/keptn/pull/2733), the Keptn CLI supports the auto discovery of namespaces that are created by Keptn CLI during the installation of the Keptn control plane by using annotations and labels. To patch the existing namespace, run the following command:

   * Option A: *Using kubectl*: 
      ```
      kubectl patch namespace <NAMESPACE> -p "{\"metadata\": {\"annotations\": {\"keptn.sh/managed-by\": \"keptn\"}, \"labels\": {\"keptn.sh/managed-by\": \"keptn\"}}}"
      ```

   * Option B: *Using Keptn CLI [upgrade command](../../reference/cli/commands/keptn_upgrade)*:

      ```
      keptn upgrade --patch-namespace
      ```

      *Note:* If you installed Keptn in a dedicated namespace, use the `-n` flag to select the namespace:

      ```
      keptn upgrade --patch-namespace -n <NAMESPACE>
      ```
