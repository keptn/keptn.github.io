---
title: Keptn on MicroK8s (experimental)
description: Install the quality gates standalone version of Keptn on Microk8s. 
weight: 80
---

## Installation Guide

If you would like to install the quality-gates standalone version of Keptn on [MicroK8s](https://microk8s.io/), please follow the instructions below.

**Note**: Running Keptn on MicroK8s is currently an experimental feature.

### Guide for macOS via Multipass

If you are using macOS, you will need to run MicroK8s using [multipass](https://multipass.run/). You can install multipass using either the [multipass installer](https://github.com/canonical/multipass/releases/download/v1.0.0/multipass-1.0.0%2Bmac-Darwin.pkg), or by using brew:

  ```console
  brew cask install multipass
  ```

After you have installed multipass, you can install Keptn using the following commands:

  ```console
  multipass launch --name microk8s-vm --mem 8G --disk 40G --cpus 2
  multipass exec microk8s-vm -- sudo snap install microk8s --classic
  multipass exec microk8s-vm -- sudo iptables -P FORWARD ACCEPT
  multipass exec microk8s-vm -- sudo microk8s.enable dns
  multipass exec microk8s-vm -- sudo microk8s.enable dns ingress
  multipass exec microk8s-vm -- sudo microk8s.enable storage
  multipass exec microk8s-vm -- sudo /snap/bin/microk8s.config > kubeconfig

  export KUBECONFIG=./kubeconfig
  kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
  multipass exec microk8s-vm -- sudo ifconfig

  keptn install --platform=kubernetes --keptn-installer-image=keptn/installer:0.6.1 --use-case=quality-gates --gateway=NodePort
  ```

Afterwards, you are ready to use Keptn for the use case of [Keptn Quality Gates](../../../concepts/quality_gates/).

### Guide for Ubuntu

If you are using Ubuntu, you can install Keptn using the following commands:

  ```console
  sudo snap install microk8s --classic
  sudo iptables -P FORWARD ACCEPT
  sudo microk8s.enable dns
  sudo microk8s.enable dns ingress
  sudo microk8s.enable storage
  sudo /snap/bin/microk8s.config > kubeconfig
  export KUBECONFIG=./kubeconfig
  kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml

  keptn install --platform=kubernetes --use-case=quality-gates --gateway=NodePort
  ```

Afterwards, you are ready to use Keptn for the use case of [Keptn Quality Gates](../../../concepts/quality_gates/).
