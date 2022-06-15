---
title: Authenticate Keptn CLI
description: Authenticate the Keptin CLI and the Keptn Bridge
weight: 20
---

Much like `kubectl`, the `keptn` CLI can be used to interact with the control plane.

Authenticate it now:
```
keptn auth --endpoint={{TRAFFIC_HOST1_8080}}/api --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}' | base64 -d)
```{{exec}}

# Keptn Bridge

The bridge is the web-based interface for Keptn.

Retrieve the username for the bridge (defaults to `keptn`):

```
export BRIDGE_USERNAME=$(kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_USERNAME}" | base64 --decode)
```{{exec}}

Retrieve the password for the bridge (randomly generated during installation):

```
export BRIDGE_PASSWORD=$(kubectl get secret -n keptn bridge-credentials -o jsonpath="{.data.BASIC_AUTH_PASSWORD}" | base64 --decode)
```{{exec}}

Get the retrieved username and password by printing them to the console:

```
echo "Bridge Username: $BRIDGE_USERNAME"
echo "Bridge Password: $BRIDGE_PASSWORD"
```{{exec}}

Visit [the bridge]({{TRAFFIC_HOST1_8080}}/bridge) (opens in a new tab). Login and come back here.

The bridge and API are available at any time from the Killercoda interface:

1. Navigate to the menu icon (three lines on the top right)
2. Select `Traffic / Ports`
3. Click Port `8080` to access the bridge
4. A link to the API is found under the "little person" icon (top right)
