---
title: Uninstall
description: Shows you how to uninstall keptn
weight: 40

keywords: setup
---

## 1. Clone Installer Repo
```console
git  clone --branch 0.3.0 https://github.com/keptn/installer
```

## 2a. Uninstall for GKE, AKS, k8s
```console
cd  ./installer/scripts/common
./uninstallKeptn.sh
```

## 2b. Uninstall for OpenShift
```console
cd  ./installer/scripts/openshift
./uninstallKeptn.sh
```