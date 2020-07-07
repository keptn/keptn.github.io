---
title: Configure an Istio Ingress
description: ...
weight: 1
---

To be able to access the services you are going to deploy with Keptn, Istio has to be installed. This means that the `istio-ingressgateway` service should already be available in the `istio-system` namespace. Besides, a `public-gateway` need to be created as explained next. 

## Install Istio 

* To install Istio, please see the official [Installation Guides](https://istio.io/latest/docs/setup/install/).

## Create Istio gateway

* Create an Istio `Gateway`, as described in the [Istio Docs](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#configuring-ingress-using-an-istio-gateway). An example of a gateway manifest is given below:

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

## Configure Istio ingress

* [Determining the ingress IP and port of Istio Ingress](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports):

    ```console
    kubectl -n istio-system get svc istio-ingressgateway
    ```

* Create the `ingress-config` ConfigMap in the `keptn` namespace:

    ```
    INGRESS_IP=<IP_OF_YOUR_INGRESS>
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                     # "http" or "https"
    INGRESS_GATEWAY=<GATEWAY_NAME>.<NAMESPACE_OF_GATEWAY>

    kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_IP}.xip.io --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=ingress_gateway=${INGRESS_GATEWAY} -oyaml --dry-run | kubectl replace -f -
    ```

* If you have already set up a domain that points to your Istio Ingress, you can use that one for the `INGRESS_HOSTNAME_SUFFIX`. In this case, use the following command to create the ConfigMap:

    ```
    INGRESS_HOSTNAME=<YOUR_HOSTNAME>
    INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
    INGRESS_PROTOCOL=<PROTOCOL>                      # "http" or "https"

    kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} -oyaml --dry-run | kubectl replace -f -
    ```

* After the ConfigMap has been created, restart the `helm-service`:

    ```
    kubectl delete pod -n keptn -lrun=helm-service
    ```

* If you are on OpenShift, also restart the `openshift-route-service`:

    ```
    kubectl delete pod -n keptn -lrun=openshift-route-service
    ```