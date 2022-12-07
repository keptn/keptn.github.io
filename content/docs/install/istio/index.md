---
title: Install and configure Istio
description: Configure Istio and create a ConfigMap to expose services deployed by Keptn.
weight: 75
aliases:
- /docs/0.19.x/continuous_delivery/expose_services/
- /docs/1.0.x/continuous_delivery/expose_services/
---

Istio can be installed in order to access the services that Keptn deploys.
You can instead use and install the [Job Executor Service](../jes-install).

Please follow the steps in sequential order
to implement Istio for your Keptn instance:

1. Install Istio
1. Create Istio `public-gateway`.
   The `istio-ingressgateway` service must already be available in the `istio-system` namespace
1. Create ConfigMap with ingress information
   by populating the `ingressConfig` section of the `values.yaml` file

The following sections give more details.

## Install Istio

* If you did not install Istio during the [Keptn installation](../access/#option-3-expose-keptn-via-an-ingress), please refer to the official [Installation Guides](https://istio.io/latest/docs/setup/install/) to install Istio on your cluster.

## Create Istio Gateway

* To create an Istio `Gateway`, please follow the official Istio documentation on [Configuring Ingress using an Istio Gateway](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#configuring-ingress-using-an-istio-gateway). Use the below `gateway.yaml` manifest to create a Istio gateway with the name `public-gateway` in the `istio-system` namespace:

```yaml
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: public-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      name: http
      number: 80
      protocol: HTTP
    hosts:
    - '*'
```

```console
kubectl apply -f gateway-manifest.yaml
```

## Create ConfigMap with ingress information

* [Determine the ingress IP and ports](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

    ```console
    kubectl -n istio-system get svc istio-ingressgateway
    ```

* Create the `ingress-config` ConfigMap in the `keptn` namespace:

    ```
    INGRESS_HOSTNAME_SUFFIX=<IP_OF_YOUR_INGRESS>.nip.io
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                            # "http" or "https"
    ISTIO_GATEWAY=<GATEWAY_NAME>.<NAMESPACE_OF_GATEWAY>  # e.g. public-gateway.istio-system
    HOSTNAME_TEMPLATE=<HOSTNAME_TEMPLATE> # optional, default = \${INGRESS_PROTOCOL}://\${service}.\${project}-\${stage}.\${INGRESS_HOSTNAME_SUFFIX}:\${INGRESS_PORT}
    ```

      **Note:** In the above example, `nip.io` is used as wildcard DNS for the IP address.
      **Note:** The `HOSTNAME_TEMPLATE` describes how the hostname for the automatically generated `VirtualService` should look. This value is also used for the `deploymentURIPublic` property contained in the `deployment.finished` events sent by the helm-service will look like. This URL can then be used by execution plane services that need to access the deployed service (e.g. a testing service like the jmeter-service).
      Within the `HOSTNAME_TEMPLATE`, you can use the variables `INGRESS_HOSTNAME_SUFFIX`, `INGRESS_PORT`, `INGRESS_PROTOCOL`, as well as `project`, `stage` and `service`. Please escape those variables using `\${}` when defining the value for `HOSTNAME_TEMPLATE`, since the resulting string should contain the placeholders of those variables instead of their actual values.

    ```console
    kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME_SUFFIX} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=istio_gateway=${ISTIO_GATEWAY} --from-literal=hostname_template=${HOSTNAME_TEMPLATE} -oyaml --dry-run | kubectl replace -f -
    ```

* If you have already set up a domain that points to your Istio ingress, you can use it for the `INGRESS_HOSTNAME_SUFFIX`. In this case, use the following command to create the `ingress-config` ConfigMap in the `keptn` namespace:

    ```
    INGRESS_HOSTNAME_SUFFIX=<YOUR_HOSTNAME>
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                            # "http" or "https"
    ISTIO_GATEWAY=<GATEWAY_NAME>.<NAMESPACE_OF_GATEWAY>  # e.g. public-gateway.istio-system
    HOSTNAME_TEMPLATE=<HOSTNAME_TEMPLATE> # optional, default = \${INGRESS_PROTOCOL}://\${service}.\${project}-\${stage}.\${INGRESS_HOSTNAME_SUFFIX}:\${INGRESS_PORT}
    ```
    
    ```console
    kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME_SUFFIX} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=istio_gateway=${ISTIO_GATEWAY} --from-literal=hostname_template=${HOSTNAME_TEMPLATE} -oyaml --dry-run | kubectl replace -f -
    ```

* After creating the ConfigMap, restart the `helm-service`:

    ```
    kubectl delete pod -n keptn --selector=app.kubernetes.io/name=helm-service
    ```
