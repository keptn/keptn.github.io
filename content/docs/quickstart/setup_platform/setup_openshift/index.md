---
title: Setup OpenShift
description: How to setup an OpenShift cluster to be used for Keptn.
weight: 25
keywords: setup
---

## 1. Install local tools

  - [oc CLI - v3.11](https://github.com/openshift/origin/releases/tag/v3.11.0)


## 2. On the OpenShift master node, execute the following steps:

- Set up the required permissions for your user:

```
oc adm policy --as system:admin add-cluster-role-to-user cluster-admin <OPENSHIFT_USER_NAME>
```

- Set up the required permissions for the installer pod:

```
oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:default:default
oc adm policy  add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
```

- Enable admission WebHooks on your OpenShift master node:

```
sudo -i
cp -n /etc/origin/master/master-config.yaml /etc/origin/master/master-config.yaml.backup
oc ex config patch /etc/origin/master/master-config.yaml --type=merge -p '{
  "admissionConfig": {
    "pluginConfig": {
      "ValidatingAdmissionWebhook": {
        "configuration": {
          "apiVersion": "apiserver.config.k8s.io/v1alpha1",
          "kind": "WebhookAdmission",
          "kubeConfigFile": "/dev/null"
        }
      },
      "MutatingAdmissionWebhook": {
        "configuration": {
          "apiVersion": "apiserver.config.k8s.io/v1alpha1",
          "kind": "WebhookAdmission",
          "kubeConfigFile": "/dev/null"
        }
      }
    }
  }
}' >/etc/origin/master/master-config.yaml.patched
if [ $? == 0 ]; then
  mv -f /etc/origin/master/master-config.yaml.patched /etc/origin/master/master-config.yaml
  /usr/local/bin/master-restart api && /usr/local/bin/master-restart controllers
else
  exit
fi
```
