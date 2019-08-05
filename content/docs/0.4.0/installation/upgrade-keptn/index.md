---
title: Upgrade keptn
description: How to upgrade keptn.
weight: 80
icon: setup
keywords: upgrade
---

Since the removal of knative as a core technology in keptn 0.4.0 is considered to be a breaking change, an upgrade script can unfortunately not be provided. If you want to upgrade your existing keptn installation, uninstall keptn and install it with the new keptn CLI 0.4.0.

## Uninstall keptn

For uninstalling keptn, [download this script](https://github.com/keptn/installer/blob/0.4.0/scripts/common/uninstallKeptn030.sh) and execute it:
```
./uninstallKeptn030.sh
```

## Install keptn CLI

Please refer to the [install section](../setup-keptn) to instal keptn in version 0.4.0.

## Create project and onboard services

Due to a breaking change from keptn 0.3.0 to 0.4.0 regarding the naming convention of Kubernetes namespaces, it is necessary to re-create a keptn project and to onboard your services again.

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
