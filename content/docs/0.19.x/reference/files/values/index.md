---
title: values (Keptn helm-service)
description: Configure the Keptn Helm chart
weight: 915
---

The `values.yaml` configuration file defines the configuration used
when installing Keptn with a Helm chart; see
[Installing Keptn using the Helm chart](../../../../install/helm-install).
`Values` is a built-in object of Helm templates; see the Helm documentation at
[Values Files(https://helm.sh/docs/chart_template_guide/values_files/).

## Spec

See [values.yaml](https://github.com/keptn/keptn/blob/master/installer/manifests/keptn/values.yaml)
in the Keptn GitHub repository for the default Keptn file.

## Usage

The recommended practice is the declarative approach:
you create your own Keptn values file that includes your customizations
then use your customized values file to install Keptn.
Alternatively, you can also set Helm values with `--set` during helm commands;
this is the imparative approach.
The --set flags take precendence over whatever you have configured in your *values.yaml* file
so can be used to temporarily override a value when necessary.

## Files

* Default [values.yaml](https://github.com/keptn-contrib/helm-service/blob/main/chart/values.yaml) file: 

## Differences between versions

**Keptn 0.17.0 changes**

Keptn Helm chart was refactored heavily in Release 0.17.0
to make it ready for future features and structural changes.

- The following Helm values changed for the Control Plane Helm chart:
  - `continuous-delivery` -> `continuousDelivery`
  - `control-plane`: Since the `control-plane` and `continuous-delivery` charts were merged into one, all values
     previously under `control-plane` are now just directly in the values root without the `control-plane` key.
  - All values under `control-plane.common` were moved to the root level of the values.
    e.g. `control-plane.common.strategy.type` -> `strategy.type`

  {{< popup_image
  link="./assets/helm-values-diff.png"
  caption="Diff with old values on the left and updated values on the right">}}

- Values for the Execution Plane Helm chart changed for `helm-service` and `jmeter-service`:

  - `resources` -> `helm-service.resources`/`jmeter-service.resources`
  - The distributor got its own set of `resources` in the values file.
  You can adjust them or leave them at the sensible defaults.

## See also

* [Install Keptn using the Helm chart](../../../../install/helm-install)
* [values.yaml](https://helm.sh/docs/chart_template_guide/values_files/)
  Helm specification for the *values.yaml* file.

