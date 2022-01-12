---
title: Advanced Install Options
description: Advanced Install Options using Helm
weight: 20
---

## Advanced Install Options: Install Keptn using the Helm chart

When executing `keptn install`, Keptn is installed via a Helm chart, which can also be done using the Helm CLI directly.
Therefore, the [helm CLI](https://helm.sh) is required to execute of the following command:

* *Install Keptn control-plane (with Continuous Delivery support and exposed on a LoadBalancer)*: 

```
helm install keptn https://github.com/keptn/keptn/releases/download/0.11.4/keptn-0.11.4.tgz -n keptn --create-namespace --wait --set=continuous-delivery.enabled=true,control-plane.apiGatewayNginx.type=LoadBalancer
```

* *Install Keptn execution-plane:*

```
helm install jmeter-service https://github.com/keptn/keptn/releases/download/0.11.4/jmeter-service-0.11.4.tgz -n keptn --create-namespace --wait

helm install helm-service https://github.com/keptn/keptn/releases/download/0.11.4/helm-service-0.11.4.tgz -n keptn --create-namespace --wait
```

**Note:** To continue with Keptn after the installation with Helm, we recommend authenticating the Ketpn CLI as explained [here](../install/#authenticate-keptn-cli). 

As shown above, the `helm install` or `helm upgrade` commands offer a flag called `--set`, which can be used to specify several configuration options using the format `key1=value1,key2=value2,...`.

The full list of available flags can be found in the [helm-charts](https://github.com/keptn/keptn/tree/0.11.4/installer/manifests/keptn).


### Example: Use a LoadBalancer for api-gateway-nginx

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.11.4 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer
```

### Example: Install execution plane for Continuous Delivery use-case

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** can be installed by the following command:
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.11.4 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true
```

### Example: Install execution plane for Continuous Delivery use-case and use a LoadBalancer for api-gateway-nginx

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** and a `LoadBalancer` for exposing Keptn can be installed by the following command:
```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.11.4 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true,control-plane.apiGatewayNginx.type=LoadBalancer
```

### Example: Execute Helm upgrade without Internet connectivity

The following section contains instructions for installing Keptn in an air-gapped / offline installation scenario.

The following artifacts need to be available locally:

* Keptn Helm Chart (control-plane + helm + jmeter)
* Several Docker Images (e.g., pushed into a private registry)
* Helper scripts
* Keptn CLI (optional, but recommended for future use)

**Download Keptn Helm Charts**

Download the Helm charts from the [Keptn 0.11.4 release](https://github.com/keptn/keptn/releases/tag/0.11.4):

* Keptn Control Plane: https://github.com/keptn/keptn/releases/download/0.11.4/keptn-0.11.4.tgz
* helm-service (if needed): https://github.com/keptn/keptn/releases/download/0.11.4/helm-service-0.11.4.tgz
* jmeter-service (if needed): https://github.com/keptn/keptn/releases/download/0.11.4/jmeter-service-0.11.4.tgz

Move the helm charts to a directory on your local machine, e.g., `offline-keptn`.

For convenience, the following script creates this directory and downloads the required helm charts into it:

```console
mkdir offline-keptn
cd offline-keptn
curl -L https://github.com/keptn/keptn/releases/download/0.11.4/keptn-0.11.4.tgz -o keptn-0.11.4.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.11.4/helm-service-0.11.4.tgz -o helm-service-0.11.4.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.11.4/jmeter-service-0.11.4.tgz -o jmeter-service-0.11.4.tgz
cd ..
```

**Download Containers/Images**

Within the Helm Charts several Docker Images are referenced (Keptn specific and some third party dependencies).
We recommend to pulling, re-tagging and pushing those images to a local registry that the Kubernetes cluster can reach.

We are providing a helper script for this in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/pull_and_retag_images.sh

For convenience, you can use the following commands to download and execute the script:

```console
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.11.4/installer/airgapped/pull_and_retag_images.sh -o pull_and_retag_images.sh
chmod +x pull_and_retag_images.sh
KEPTN_TAG=0.11.4 ./pull_and_retag_images.sh "your-registry.localhost:5000/"
cd ..
```

Please mind the trailing slash for the registry url (e.g., `your-registry.localhost:5000/`).

**Installation**

Keptn's Helm chart allows you to specify the name of all images, which can be especially handy in air-gapped systems where you cannot access DockerHub for pulling the images.

We are providing a helper script for this in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/install_keptn.sh

For convenience, you can use the following commands to download and execute the script:

```console
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.11.4/installer/airgapped/install_keptn.sh -o install_keptn.sh
chmod +x install_keptn.sh
./install_keptn.sh "your-registry.localhost:5000/" keptn-0.11.4.tgz helm-service-0.11.4.tgz jmeter-service-0.11.4.tgz
cd ..
```

### Install Keptn using a Root-Context

The Helm chart allows customizing the root-context for the Keptn API and Bridge.
By default, the Keptn API is located under `http://HOSTNAME/api` and the Keptn Bridge is located under `http://HOSTNAME/bridge`.
By specifying a value for `control-plane.prefixPath`, the used prefix for the root-context can be configured.
For example, if a user sets `control-plane.prefixPath=/mykeptn` in the Helm install/upgrade command,
the Keptn API is located under `http://HOSTNAME/mykeptn/api` and the Keptn Bridge is located under `http://HOSTNAME/mykeptn/bridge`:

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.11.4 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer,continuous-delivery.enabled=true,control-plane.prefixPath=/mykeptn
```

### Example: Install Keptn with externally hosted MongoDB

If you want to use an externally hosted MongoDB instead of the MongoDB installed by Keptn, please use the `helm upgrade` command as shown below. Basically, provide the MongoDB host, port, user, and password in form of a connection string.

```console
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=control-plane.mongo.enabled=false,
      control-plane.mongo.external.connectionString=<YOUR_MONGODB_CONNECTION_STRING>,
      control-plane.mongo.auth.database=<YOUR_DATABASE_NAME>
```

### Example: Install Keptn with an ingress object

If you are already using an Ingress-Controller and want to create an ingress object for Keptn, you can leverage the ingress section of the helm chart. By default enabled is set to false.

The Helm chart allows customizing the ingress object to your needs.  When enabled is set the true, the chart allows you to specify optional parameters of host, path, pathType, tls, and annotations. This will cater for alot of different Ingress-Controllers and configurations.

```console
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=control-plane.ingress.enabled=true,
      control-plane.ingress.annotations=<YOUR_ANNOTATIONS>,
      control-plane.ingress.host=<YOUR_HOST>,
      control-plane.ingress.path=<YOUR_PATH>,
      control-plane.ingress.pathType=<YOUR_PATH_TYPE>,  
      control-plane.ingress.tls=<YOUR_TLS>
```
