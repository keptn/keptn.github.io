---
title: Upgrade keptn
description: How to upgrade keptn.
weight: 80
icon: setup
keywords: upgrade
---

Since we introduced breaking changes with Keptn 0.4.0 due to the removal of knative as a core technology, an upgrade script can unfortunately not be provided.
If you want to upgrade your existing Keptn installation, please uninstall Keptn and install it with the new Keptn CLI 0.4.0.

## Uninstall Keptn

For uninstalling Keptn, please [download this file](https://github.com/keptn/installer/blob/0.4.0/scripts/common/uninstallKeptn030.sh) and execute it:
```
./uninstalKeptn030.sh
```

## Install Keptn CLI

Please refer to the [install section](../setup-keptn) to instal Keptn in version 0.4.0.


## Create project and onboard services

Due to a breaking change from Keptn 0.3.0 to 0.4.0 regarding the naming convention of Kubernetes namespaces, it is necessary to re-create a Keptn project and to onboard your services again.

- Delete your configuration repository in your GitHub organization.

- Delete your releases using [Helm](https://helm.sh):

  ``` console
  helm ls
  ```

  ``` console
  NAME               	REVISION	UPDATED                 	STATUS  	CHART         	APP VERSION	NAMESPACE 
  sockshop-dev       	1       	Wed May 29 10:59:56 2019	DEPLOYED	sockshop-0.1.0	           	dev       
  sockshop-production	1       	Wed May 29 11:12:44 2019	DEPLOYED	sockshop-0.1.0	           	production
  sockshop-staging   	1       	Wed May 29 11:07:16 2019	DEPLOYED	sockshop-0.1.0	           	staging 
  ```

  ``` console
  helm delete --purge sockshop-dev
  helm delete --purge sockshop-production
  helm delete --purge sockshop-staging
  ```

  ``` console
  release "sockshop-dev" deleted
  release "sockshop-staging" deleted
  release "sockshop-production" deleted
  ```

- Instructions for creating a project are provided [here](../../usecases/onboard-carts-service/#create-project-sockshop).

- Instructions for onboarding a service are provided [here](../../usecases/onboard-carts-service/#onboard-carts-service-and-carts-database).