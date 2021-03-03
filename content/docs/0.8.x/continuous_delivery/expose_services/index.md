---
title: Expose deployed services
description: Configure Istio and create a ConfigMap to expose services deployed by Keptn. 
weight: 1
keywords: [0.8.x-cd]
---

To be able to access the services you will deploy by Keptn, Istio has to be installed. This means that the `istio-ingressgateway` service should already be available in the `istio-system` namespace and a `public-gateway` need to be created as explained below. Besides, a ConfigMap must be edited that tells Keptn how the gateway is configured. 

Please follow the steps in sequential order:

1. Install Istio
1. Create Istio gateway
1. Create ConfigMap with ingress information 

## Install Istio 

* If you have not installed Istio during the [Keptn installation](../../operate/install/#3-install-ingress-controller-and-apply-an-ingress-object), please refer to the official [Installation Guides](https://istio.io/latest/docs/setup/install/) to install Istio on your cluster.

## Create Istio Gateway

* To create an Istio `Gateway`, please follow the offical Istio documentation on [Configuring Ingress using an Istio Gateway](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#configuring-ingress-using-an-istio-gateway). Use the below `gateway.yaml` manifest to create a Istio gateway with the name `public-gateway` in the `istio-system` namespace:

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
      **Note:** The `HOSTNAME_TEMPLATE` describes how the hostname for the automatically generated `VirtualService` should look like. This value will also be used for the `deploymentURIPublic` property contained in the `deployment.finished` events sent by the helm-service will look like. This URL can then be used by execution plane services that need to access the deployed service (e.g. a testing service like the jmeter-service).
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
