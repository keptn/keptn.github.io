---
title: Upgrade Keptn
description: Upgrade your Keptn to 0.17
weight: 500
---

## Upgrade from Keptn 0.16.x to Keptn 0.17.x

With Keptn 0.17.x, the Keptn CLI commands for `install`, `uninstall` and `upgrade` were deprecated. We recommend to upgrade using the Helm CLI instead.
Additionally, the Keptn Helm chart was refactored heavily to make it ready for future features and structural changes.
To upgrade, we recommend getting your old Helm values file, and then merging it together with the default Keptn Helm values
to get any new default values that were introduced. Afterwards, you can use your new values file to follow the
[Helm installation instructions](../install/#install-keptn).

Detailed step by step guide:
- Follow [Keptn's backup instructions](../backup_and_restore)
- Make sure you are connected to the kubernetes cluster where Keptn is installed.
- Fetch your current Helm values with `helm get values -n <your-keptn-namespace> <your-keptn-release-name> > keptn-values.yaml`
   For namespace `keptn-test` and release name `keptn` (the default release name) the command would look like this:

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
    e.g. `common.strategy.type` -> `strategy.type`
- After adjusting your Helm values you are ready to upgrade to the new version of Keptn. Since the `keptn upgrade` CLI command
   is deprecated with Keptn 0.17, please use Helm directly to do the upgrade:

   ```
   helm upgrade keptn -n keptn-test --version 0.17.0 --values <your-adjusted-values-file>
   ```
