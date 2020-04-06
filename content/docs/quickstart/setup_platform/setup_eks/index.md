---
title: Setup EKS
description: How to setup an EKS cluster to be used for Keptn.
weight: 22
keywords: setup
---

## 1. Install local tools
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (version >= 1.16.156)

## 2. Create EKS cluster
  - [Master version:](/docs/0.6.0/installation/k8s-support/#supported-version) `1.15` (tested version: `1.15`)
    <!-- - **Note:** Version 1.13 has a bug in CoreDNS. [Learn how to fix it](../../../0.6.0/installation/setup-keptn/#setup-kubernetes-cluster).-->
  - One `m5.2xlarge` node