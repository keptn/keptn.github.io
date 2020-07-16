---
title: Expose deployed services
description: Configure Istio and create a ConfigMap to expose services deployed by Keptn. 
weight: 1
---

To be able to access the services you will deploy by Keptn, Istio has to be installed. This means that the `istio-ingressgateway` service should already be available in the `istio-system` namespace and a `public-gateway` need to be created as explained below. Besides, a ConfigMap must be created that tells Keptn how the gateway is configured. 

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
    INGRESS_IP=<IP_OF_YOUR_INGRESS>.xip.io
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                            # "http" or "https"
    INGRESS_GATEWAY=<GATEWAY_NAME>.<NAMESPACE_OF_GATEWAY>  # e.g. public-gateway.istio-sysetm
    ```

      **Note:** In the above example, `xip.io` is used as wildcard DNS for the IP address.

    ```console
    kubectl apply configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_IP} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=ingress_gateway=${INGRESS_GATEWAY}
    ```

* If you have already set up a domain that points to your Istio ingress, you can use it for the `INGRESS_HOSTNAME_SUFFIX`. In this case, use the following command to create the `ingress-config` ConfigMap in the `keptn` namespace:

    ```
    INGRESS_HOSTNAME=<YOUR_HOSTNAME>
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                            # "http" or "https"
    ```
    
    ```console
    kubectl apply configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL}
    ```

* After creating the ConfigMap, restart the `helm-service`:

    ```
    kubectl delete pod -n keptn -lrun=helm-service
    ```

* If you are on OpenShift, also restart the `openshift-route-service`:

    ```
    kubectl delete pod -n keptn -lrun=openshift-route-service
    ```