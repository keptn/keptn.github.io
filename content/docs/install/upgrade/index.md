---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.17
weight: 500
---

Keptn only supports upgrading from one release to the next;
you cannot skip releases.
This page

* Summarizes the upgrade process for the Keptn control plane and Keptn execution plane
* Includes some notes about special steps required when updating multi-cluster Keptn instances
* Gives release-specific notes about upgrading from recent releases
* Includes links to Release Notes and upgrade instructions for older releases,
  to help customers who must upgrade from older releases

## Upgrade the Keptn control plane

To upgrade the control plane:

1. Back up your Keptn instance, following
   [Keptn's backup instructions](../../0.19.x/operate/backup_and_restore)
1. Make sure you are connected to the Kubernetes cluster where Keptn is installed.
1. Fetch your current Helm values with the follwoing command:

   ```
   helm get values -n <your-keptn-namespace> <your-keptn-release-name> \
      > keptn-values.yaml
   ```

   For namespace `keptn-test` and release name `keptn` (the default release name),
   the command would look like this:

   ```
   helm get values -n keptn-test keptn
   ```

1. Download the released Helm chart using the following command
   ```
   helm pull https://charts.keptn.sh/packages/keptn-<release>.tgz
   ```
1. Unpack the tar file.

1.  Use a merge tool to merge the `values.yaml` file from the unpacked chart
    and your previously downloaded `keptn-values.yaml` together.

## Upgrade the Execution plane

## Notes for upgrading multi-cluster instances

[Multi-cluster setup](../multi-cluster) gives details about setting up a Keptn installation
with multiple execution planes that run on different clusters than the Keptn control plane.
Some additional configurations are required in recent releases.

* For Keptn releases 0.15.x and later,
you may need to set the `K8S_DEPLOYMENT_NAME` environment variable on each execution plane to a unique name.
* [Add note about setting NATS_URL env variable]


## Upgrade notes by release

## Upgrade from Keptn 0.18.x to Keptn 0.19.x

## Upgrade from Keptn 0.17.x to Keptn 0.18.x

## Upgrade from Keptn 0.16.x to Keptn 0.17.x

With Keptn 0.17.x, the Keptn CLI commands for `install`, `uninstall` and `upgrade` were deprecated. We recommend that you instead use the Helm CLI to upgrade.
The Keptn Helm chart has also been refactored heavily to make it ready for future features and structural changes.
To upgrade, we recommend getting your old Helm values file, and then merging it together with the default Keptn Helm values
to get any new default values that were introduced. Afterwards, you can use your new values file to follow the
[Helm installation instructions](../helm-install).

Detailed step-by-step guide:

- Before upgrading to 0.17.x, please follow [Keptn's backup instructions](../../0.17.x/operate/backup_and_restore)
- Make sure you are connected to the Kubernetes cluster where Keptn is installed.
- Fetch your current Helm values with `helm get values -n <your-keptn-namespace> <your-keptn-release-name> > keptn-values.yaml`
   For namespace `keptn-test` and release name `keptn` (the default release name), the command would look like this:

   ```
   helm get values -n keptn-test keptn
   ```

- Download the released Helm chart using `helm pull https://charts.keptn.sh/packages/keptn-0.17.0.tgz` and unpack it.
- Use a merge tool to merge the `values.yaml` file from the unpacked chart and your previously downloaded `keptn-values.yaml` together.
- You will notice that some Helm values have changed compared to your `keptn-values.yaml` file:
  - `continuous-delivery` -> `continuousDelivery`
  - `control-plane`: Since the `control-plane` and `continuous-delivery` charts were merged into one, all values 
     previously under `control-plane` are now just directly in the values root without the `control-plane` key.
  - All values under `control-plane.common` were moved to the root level of the values.
    e.g. `control-plane.common.strategy.type` -> `strategy.type`
- After adjusting your Helm values you are ready to upgrade to the new version of Keptn. Since the `keptn upgrade` CLI command
   is deprecated with Keptn 0.17, please use Helm directly to do the upgrade:

   ```
   helm upgrade keptn keptn/keptn -n keptn-test --version 0.17.0 --values <your-adjusted-values-file>
   ```

  {{< popup_image
  link="./assets/helm-values-diff.png"
  caption="Diff with old values on the left and updated values on the right">}}

#### Execution Plane

If you have helm-service or jmeter-service installed, please follow the steps below to upgrade:

- Make sure you are connected to the Kubernetes cluster where Keptn is installed.
- Fetch your current Helm values with `helm get values -n <your-exec-plane-namespace> <your-exec-plane-service-release-name> > old-values.yaml`
  For namespace `exec-plane` and release name `helm-service` (the default release name), the command would look like this:

   ```
   helm get values -n exec-plane helm-service
   ```

- Download the released Helm chart using `helm pull https://charts.keptn.sh/packages/helm-service-0.17.0.tgz` and unpack it.
- Use a merge tool to merge the `values.yaml` file from the unpacked chart and your previously downloaded `old-values.yaml` together.
- You will notice that some Helm values have changed compared to your `old-values.yaml` file:
    - `resources` -> `helm-service.resources`/`jmeter-service.resources`
    - The distributor got its own set of `resources` in the values file. You can adjust them or leave them at the sensible defaults.
- After adjusting your Helm values you are ready to upgrade to the new version of your execution plane service.
  Please use Helm directly to do the upgrade:

   ```
   helm upgrade <your-exec-plane-service> -n exec-plane --version 0.17.0 --values <your-adjusted-values-file>
   ```
### Upgrade from earlier releases

|Release Notes                    |Upgrade documentation                                       |
|-------------------------------- |----------------------------------------------------------- |
|[0.16.2](../../news/release_announcements/keptn-0162/), [0.16.1](../../news/release_announcements/keptn-0161/), [0.16.0](../../news/release_announcements/keptn-0160/)   | [Upgrade from Keptn 0.15.x to 0.16.x](../../0.16.x/operate/upgrade)     |
|[0.15.1](../../news/release_announcements/keptn-0151/), [0.15.0](../../news/release_announcements/keptn-0150/)   | [Upgrade from Keptn 0.13.x to 0.15.x](../../0.15.x/operate/upgrade)     |
|[0.14.3](../../news/release_announcements/keptn-0143/), [0.14.2](../../news/release_announcements/keptn-0142/),[0.14.1](../../news/release_announcements/keptn-0141/)   | [Upgrade from Keptn 0.13.x to 0.14.x](../../0.14.x/operate/upgrade)     |
|[0.13.6](../../news/release_announcements/keptn-0136/), [0.13.5](../../news/release_announcements/keptn-0135/), [0.13.4](../../news/release_announcements/keptn-0134/), [0.13.3](../../news/release_announcements/keptn-0133/), [0.13.2](../../news/release_announcements/keptn-0132/), [0.13.1](../../news/release_announcements/keptn-0131/)  [0.13.0](../../news/release_announcements/keptn-0130/)    | [Upgrade from Keptn 0.12.x to 0.13.x](../../0.13.x/operate/upgrade)     |
|[0.12.7](../../news/release_announcements/keptn-0127/), [0.12.6](../../news/release_announcements/keptn-0126/), [0.12.4](../../news/release_announcements/keptn-0124/), [0.12.3](../../news/release_announcements/keptn-0123/), [0.12.2](../../news/release_announcements/keptn-0122/), [0.12.1](../../news/release_announcements/keptn-0121/)  [0.12.0](../../news/release_announcements/keptn-0130/)    | [Upgrade from Keptn 0.11.x to 0.12.x](../../0.14.x/operate/upgrade)     |
|[0.11.4](../../news/release_announcements/keptn-0114/), [0.11.3](../../news/release_announcements/keptn-0113/),[0.11.2](../../news/release_announcements/keptn-0112/)   | [Upgrade from Keptn 0.11.x to 0.11.4](../../0.11.x/operate/upgrade)     |
|[0.10.0](../../news/release_announcements/keptn-0100/)   | [Upgrade from Keptn 0.09.x to 0.10.0](../../0.10.x/operate/upgrade)     |

