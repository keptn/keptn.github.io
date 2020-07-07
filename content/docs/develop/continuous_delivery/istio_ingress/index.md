---
title: Configure an Istio Ingress
description: ...
weight: 1
---

... in progress ...

## Install Istio 

* To install Istio, please refer to the [official Istio documentation](https://istio.io/latest/docs/setup/install/).

## Configure an Istio Ingress

To be able to reach your onboarded services, Istio has to be installed, and the `istio-ingressgateway` service, as well as the `public-gateway` in the `istio-system` namespace
have to be available. 

When that is done, the next step is to determine the IP and the port of your Istio ingress. To do so, please refer to the following section
of the Istio documentation: [Determining the ingress IP and ports](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports).

Afterwards, create an Istio `Gateway`, as described in the [Istio Docs](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#configuring-ingress-using-an-istio-gateway).

Once that is done, create the `ingress-config` ConfigMap in the `keptn` namespace:

```
INGRESS_IP=<IP_OF_YOUR_INGRESS>
INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
INGRESS_PROTOCOL=<PROTOCOL> # either "http" or "https"
INGRESS_GATEWAY=<GATEWAY_NAME>.<NAMESPACE_OF_GATEWAY>
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_IP}.xip.io --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} --from-literal=ingress_gateway=${INGRESS_GATEWAY} -oyaml --dry-run | kubectl replace -f -
```

If you have already set up set up a domain that points to your Istio Ingress, you can use that one for the `INGRESS_HOSTNAME_SUFFIX`. In this case, use the following command to create the ConfigMap:

```
INGRESS_HOSTNAME=<YOUR_HOSTNAME>
INGRESS_PORT=<PORT_OF_YOUR_INGRESS> 
INGRESS_PROTOCOL=<PROTOCOL> # either "http" or "https"
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${INGRESS_HOSTNAME} --from-literal=ingress_port=${INGRESS_PORT} --from-literal=ingress_protocol=${INGRESS_PROTOCOL} -oyaml --dry-run | kubectl replace -f -
```

After the ConfigMap has been created, restart the `helm-service`, using the following command:

```
kubectl delete pod -n keptn -lrun=helm-service
```

If you are on OpenShift, also restart the `openshift-route-service`:

```
kubectl delete pod -n keptn -lrun=openshift-route-service
```