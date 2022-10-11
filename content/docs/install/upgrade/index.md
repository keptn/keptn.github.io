---
title: Upgrade Keptn
description: Upgrade your Keptn
weight: 500
---

Keptn only supports upgrading from one release to the next;
we recommend that you not skip releases
since mitigation strategies for changes in each release
are often baked into the code.

This page has the following information:

* How to [upgrade the Keptn control plane](#upgrade-the-keptn-control-plane)
* How to [upgrade the Keptn execution plane\(#upgrade-the-execution-plane)
* Notes about special steps required when
  [updating multi-cluster Keptn instances](#notes-for-upgrading-multi-cluster-instances)
* [Release-specific notes](#upgrade-notes-by-release) about upgrading from recent releases
* [Links to Release Notes and upgrade instructions](#upgrade-from-earlier-releases) for older releases,
  to help customers who must upgrade from older releases

## Upgrade the Keptn control plane

To upgrade the control plane:

1. Back up your Keptn instance, following
   [Keptn's backup instructions](../../latest/operate/backup_and_restore)
1. Make sure you are connected to the Kubernetes cluster where Keptn is installed.
1. Fetch your current Helm values into a file with the follwoing command:

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
   replacing `<release>` with the release number to which you are upgrading,
   such as `0.19.0`:
   ```
   helm pull https://charts.keptn.sh/packages/keptn-<release>.tgz
   ```
1. Unpack the tar file.

1.  Use a merge tool to merge the `values.yaml` file from the unpacked chart
    and your previously downloaded `keptn-values.yaml` together.

## Upgrade the Execution plane

When you upgrade the Keptn control plane,
you should check the documentation for any services that you are using
to see if the version you are using is compatible with the new Keptn control plane version you installed
or if a new version of the service is available
and to see if the service documents special upgrade instructions.

For most services, the upgrade procedure is similar to the procedure used
to upgrade the Keptn control plane:
download your existing `values.yaml` file for the service
then merge it with the new `values.yaml` file
and use that merged file to upgrade the service:

1. Make sure you are connected to the Kubernetes cluster where Keptn is installed.
1. Fetch your current Helm values with:

   ```
   helm get values -n <your-exec-plane-namespace>
      <your-exec-plane-service-release-name> > old-values.yaml`
   ```
    For example, for namespace `exec-plane` and service release name `helm-service`
    (the default release name), the command is:

   ```
   helm get values -n exec-plane helm-service
   ```

1. Download the released Helm chart using:

   ```
   helm pull https://charts.keptn.sh/packages/<exec-plane-service>-<release>.tgz`
   ```

     For example, to download the Helm chart for `helm-service`, Release 0.17.x,
     the command is:

     ```
     helm pull https://charts.keptn.sh/packages/helm-service-0.17.0.tgz`
     ```

1. Unpack the downloaded file.
1. Use a merge tool to merge the `values.yaml` file from the unpacked chart
   and your previously downloaded `old-values.yaml` together.
1. Use the merged `values` file and the `helm` command to do the upgrade
   to upgrade to the new version of your execution plane service.
   For the `helm-service` example, the command to upgrade to version 0.17.0 is:

   ```
   helm upgrade <your-exec-plane-service> -n exec-plane --version 0.17.0 \
     --values <your-adjusted-values-file>
   ```

## Notes for upgrading multi-cluster instances

[Multi-cluster setup](../multi-cluster) gives details about setting up a Keptn installation
with multiple execution planes that run on different clusters than the Keptn control plane.
Some additional configurations are required in recent releases.

* For Keptn releases 0.15.x and later,
you may need to set the `K8S_DEPLOYMENT_NAME` environment variable on each execution plane to a unique name.
* [Add note about setting NATS_URL env variable]


## Upgrade notes by release

### Upgrade from Keptn 0.18.x to Keptn 0.19.x

No special steps are required to upgrade from Keptn 0.18.x to Keptn 0.19.x.

### Upgrade from Keptn 0.17.x to Keptn 0.18.x

No special steps are required to upgrade from Keptn 0.17.x to Keptn 0.18.x.

### Upgrade from Keptn 0.16.x to Keptn 0.17.x

With Keptn 0.17.x, the Keptn CLI commands for `install`, `uninstall` and `upgrade` were deprecated.
We should instead use the [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) command
from the [Helm CLI](https://helm.sh/docs/helm/) to upgrade.

The Keptn Helm chart has also been refactored heavily in Release 0.17.x,
to prepare it for future features and structural changes.
To upgrade, we recommend getting your old Helm [values](../../latest/reference/files/values) file,
and then merging it together with the default Keptn Helm values
to get any new default values that were introduced.
You can then use your new values file to follow the
[Helm installation instructions](../helm-install).

To upgrade the Keptn control plane to Release 0.17.x,
follow the steps in [Upgrade the Keptn control plane](#upgrade-the-keptn-control-plane).

You will notice that some Helm values have changed compared to your previous `keptn-values.yaml` file:
- `continuous-delivery` -> `continuousDelivery`
- `control-plane`: Since the `control-plane` and `continuous-delivery` charts were merged into one,
  all values previously under `control-plane` are now just directly in the values root
  without the `control-plane` key.
- All values under `control-plane.common` were moved to the root level of the values.
  e.g. `control-plane.common.strategy.type` -> `strategy.type`

- After adjusting your Helm values you are ready to upgrade to the new version of Keptn.
  use a command like the following to do the upgrade:

   ```
   helm upgrade keptn keptn/keptn -n keptn-test --version 0.17.0 --values <your-adjusted-values-file>
   ```

  {{< popup_image
  link="./assets/helm-values-diff.png"
  caption="Diff with old values on the left and updated values on the right">}}

To upgrade the Keptn execution  plane to Release 0.17.x,
follow the instructions in [Upgrade the Execution Plane](#upgrade-the-execution-plane).

You will notice that some Helm values have changed compared to your `old-values.yaml` file:

- `resources` -> `helm-service.resources`/`jmeter-service.resources`
- The distributor got its own set of `resources` in the values file.
  You can adjust them or leave them at the sensible defaults.

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

