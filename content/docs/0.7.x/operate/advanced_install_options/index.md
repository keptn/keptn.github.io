---
title: Advanced Install Options
description: Advanced Install Options using Helm
weight: 3
---

## Advanced Install Options: Install Keptn using the Helm chart
When executing `keptn install`, Keptn is installed via a Helm chart, which can also be used directly.
For this, the [Helm CLI](https://helm.sh) is required.

The command `helm upgrade ...` offers a flag called `--set`, which can be used to specify several configuration options using the format `key1=value1,key2=value2,...`.

The following flags are available:

<!-- generated using https://www.tablesgenerator.com/markdown_tables# -->
| Flag                                            | Description                                                                                                                                       | Possible Values                       | Default Value                  |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|--------------------------------|
| `continuous-delivery.enabled`                         | Specifies whether the continuous-delivery execution-plane services (e.g., helm-service, jmeter-service) should be installed on the cluster or not | true, false                           | false                          |
| `continuous-delivery.<SERVICE-NAME>.image.repository` | Allows to specify an alternative repository for the docker image used                                                      | Container registry URL                | docker.io/keptn/<SERVICE-NAME> |
| `control-plane.apiGatewayNginx.type`                  | Specifies the Kubernetes service-type for api-gateway-nginx, which can be used to expose the Keptn API                               | NodePort, ClusterIP, LoadBalancer     | ClusterIP                      |
| `control-plane.prefixPath`                            | Allows to set a prefixPath for the api-gateway. This value has to start with a "/" but must not contain a trailing "/"                                                                                                    | a URI, e.g., /mykeptn                 | empty                          |
| `control-plane.bridge.cliDownloadLink`                | Specifies a download link for the Keptn CLI which is displayed in Keptn Bridge                                                                   | any string/URL                        | null                           |
| `control-plane.bridge.versionCheck.enabled`           | Specifies whether the automatic version-check in Keptn Bridge should be enabled or not                                                           | true, false                           | true                           |
| `control-plane.bridge.showApiToken.enabled`           | Specifies whether the Keptn API Token and the `keptn auth` command should be shown in Keptn Bridge or not                                         | true, false                           | true                           |
| `control-plane.bridge.secret.enabled`                 | Specifies whether the secret used for the basic auth is enabled or not. Please be aware that if this value is set to `false`, there is no basic authentication for the bridge.                                         | true, false                           | true                           |
| `control-plane.bridge.installationType`               | Specifies which of the use cases are supported in the installation                                         | "QUALITY_GATES,CONTINUOUS_OPERATIONS", "QUALITY_GATES,CONTINUOUS_OPERATIONS,CONTINUOUS_DELIVERY"                           | "QUALITY_GATES,CONTINUOUS_OPERATIONS"                           |
| `control-plane.configurationService.storage`          | Allows to specify the storage-size of the persistent volume used in configuration-service                                                         | K8s volume storage size (e.g., 500Mi) | 100Mi                          |
| `control-plane.configurationService.storageClass`     | Allows to specify the storage-class of the persistent volume used in configuration-service                                                        | K8s storage class                     | null                           |
| `control-plane.<SERVICE-NAME>.image.repository`       | Allows to specify an alternative repository for the docker image                                                                                  | Container registry URL                | docker.io/keptn/<SERVICE-NAME> |



### Example: Use a LoadBalancer for api-gateway-nginx

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.7.3 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer
```

### Example: Install execution plane for Continuous Delivery use-case

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** can be installed by the following command:
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.7.3 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true
```

### Example: Install execution plane for Continuous Delivery use-case and use a LoadBalancer for api-gateway-nginx

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** and a `LoadBalancer` for exposing Keptn can be installed by the following command:
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.7.3 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true,control-plane.apiGatewayNginx.type=LoadBalancer
```

### Example: Execute Helm upgrade without Internet connectivity

* Download the Helm chart from [keptn-installer/keptn-0.7.3.tgz](https://charts.keptn.sh/packages/keptn-0.7.3.tgz) and move it to the machine that has no Internet connectivity, but should perform the installation:

* To install the **Control Plane with the Execution Plane (for Continuous Delivery)** and a `LoadBalancer` for exposing Keptn, execute the following command. 
**Note:** Reference the Helm chart stored locally instead of a repository and version:
```console
helm upgrade keptn ./keptn-0.7.3.tgz --install -n keptn --create-namespace --wait --set=control-plane.apiGatewayNginx.type=LoadBalancer,continuous-delivery.enabled=true
```

Furthermore, Keptn's Helm chart allows you to set all images, which can be especially
handy in air-gapped systems where you cannot access DockerHub for pulling the images.
For example, here all images are pulled from a registry with the URL `YOUR_REGISTRY/`
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.7.3 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer,continuous-delivery.enabled=true,\
control-plane.mongodb.image.repository=YOUR_REGISTRY/centos/mongodb-36-centos7,\
control-plane.nats.nats.image=YOUR_REGISTRY/nats:2.1.7-alpine3.11,\
control-plane.nats.reloader.image=YOUR_REGISTRY/connecteverything/nats-server-config-reloader:0.6.0,\
control-plane.nats.exporter.image=YOUR_REGISTRY/synadia/prometheus-nats-exporter:0.5.0,\
control-plane.apiGatewayNginx.image.repository=YOUR_REGISTRY/nginxinc/nginx-unprivileged:1.19.4-alpine,\
control-plane.remediationService.image.repository=YOUR_REGISTRY/keptn/remediation-service,\
control-plane.apiService.image.repository=YOUR_REGISTRY/keptn/api,\
control-plane.bridge.image.repository=YOUR_REGISTRY/keptn/bridge2,\
control-plane.eventbroker.image.repository=YOUR_REGISTRY/keptn/eventbroker-go,\
control-plane.helmService.image.repository=YOUR_REGISTRY/keptn/helm-service,\
control-plane.distributor.image.repository=YOUR_REGISTRY/keptn/distributor,\
control-plane.shipyardService.image.repository=YOUR_REGISTRY/keptn/shipyard-service,\
control-plane.configurationService.image.repository=YOUR_REGISTRY/keptn/configuration-service,\
control-plane.mongodbDatastore.image.repository=YOUR_REGISTRY/keptn/mongodb-datastore,\
control-plane.lighthouseService.image.repository=YOUR_REGISTRY/keptn/lighthouse-service,\
continuous-delivery.gatekeeperService.image.repository=YOUR_REGISTRY/keptn/gatekeeper-service,\
continuous-delivery.distributor.image.repository=YOUR_REGISTRY/keptn/distributor,\
continuous-delivery.jmeterService.image.repository=YOUR_REGISTRY/keptn/jmeter-service\
/
```

<details><summary>For pulling, re-tagging, and pushing all Keptn Docker images, we prepared a small helper script:</summary>
<p>    
```console
#!/bin/bash
KEPTN_TAG=0.7.3
IMAGES_CONTROL_PLANE="centos/mongodb-36-centos7:1 nats:2.1.7-alpine3.11 connecteverything/nats-server-config-reloader:0.6.0 synadia/prometheus-nats-exporter:0.5.0 nginxinc/nginx-unprivileged:1.19.1-alpine keptn/remediation-service:${KEPTN_TAG} keptn/api:${KEPTN_TAG} keptn/bridge2:${KEPTN_TAG} keptn/eventbroker-go:${KEPTN_TAG} keptn/helm-service:${KEPTN_TAG} keptn/distributor:${KEPTN_TAG} keptn/shipyard-service:${KEPTN_TAG} keptn/configuration-service:${KEPTN_TAG} keptn/mongodb-datastore:${KEPTN_TAG} keptn/lighthouse-service:${KEPTN_TAG}"
# IMAGES_CONTINUOUS_DELIVERY="keptn/gatekeeper-service:${KEPTN_TAG} keptn/jmeter-service:${KEPTN_TAG}"
INTERNAL_DOCKER_REGISTRY="YOUR_REGISTRY/"

for img in $IMAGES_CONTROL_PLANE
do
    echo $img
    docker pull $img
    docker tag $img ${INTERNAL_DOCKER_REGISTRY}${img}
    docker push ${INTERNAL_DOCKER_REGISTRY}${img}
    echo ${INTERNAL_DOCKER_REGISTRY}${img}
done  
```
</p>
</details>

### Install Keptn using a Root-Context

The Helm chart allows customizing the root-context for the Keptn API and Bridge. 
By default, the Keptn API is located under `http://HOSTNAME/api` and the Keptn Bridge is located under `http://HOSTNAME/bridge`.
By specifying a value for `control-plane.prefixPath`, the used prefix for the root-context can be configured.
For example, if a user sets `control-plane.prefixPath=/mykeptn` in the Helm install/upgrade command,
the Keptn API is located under `http://HOSTNAME/mykeptn/api` and the Keptn Bridge is located under `http://HOSTNAME/mykeptn/bridge`:
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.7.3 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer,continuous-delivery.enabled=true,control-plane.prefixPath=/mykeptn
```
