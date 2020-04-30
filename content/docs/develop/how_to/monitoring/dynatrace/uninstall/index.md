---
title: Uninstall
description: Uninstall
weight: 2
icon: setup
keywords: setup
---

## Uninstall Dynatrace

If you want to uninstall Dynatrace, there are scripts provided to do so. Uninstalling Keptn will not automatically uninstall Dynatrace.

1. (optional) If you do not have the *dynatrace-service* repository, clone the latest release using:

```console
git clone --branch 0.6.1 https://github.com/keptn-contrib/dynatrace-service --single-branch
```

1. Go to correct folder and execute the `uninstallDynatrace.sh` script:

```console
./dynatrace-service/deploy/scripts/uninstallDynatrace.sh
```
