---
title: Advanced Install Options
description: Advanced Install Options using Helm
weight: 20
---

## Advanced Install Options: Install Keptn using the Helm chart

Keptn is installed via a Helm chart, which can also be done using the Helm CLI directly.
Therefore, the [helm CLI](https://helm.sh) is required to execute the following command:

* *Install Keptn control-plane (with Continuous Delivery support and exposed on a LoadBalancer)*:

```
helm install keptn https://github.com/keptn/keptn/releases/download/0.16.0/keptn-0.16.0.tgz -n keptn --create-namespace --wait --set=continuous-delivery.enabled=true,control-plane.apiGatewayNginx.type=LoadBalancer
```

* *Install Keptn execution-plane:*

```
helm install jmeter-service https://github.com/keptn/keptn/releases/download/0.16.0/jmeter-service-0.16.0.tgz -n keptn --create-namespace --wait

helm install helm-service https://github.com/keptn/keptn/releases/download/0.16.0/helm-service-0.16.0.tgz -n keptn --create-namespace --wait
```

**Note:** To continue with Keptn after the installation with Helm, we recommend authenticating the Ketpn CLI as explained [here](../install/#authenticate-keptn-cli).

As shown above, the `helm install` or `helm upgrade` commands offer a flag called `--set`, which can be used to specify several configuration options using the format `key1=value1,key2=value2,...`.

The full list of available flags can be found in the [helm-charts](https://github.com/keptn/keptn/tree/0.16.0/installer/manifests/keptn).

### Use a LoadBalancer for api-gateway-nginx

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.16.0 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer
```

### Install execution plane for Continuous Delivery use-case

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** can be installed by the following command:

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.16.0 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true
```

### Install execution plane for Continuous Delivery use-case and use a LoadBalancer for api-gateway-nginx

For example, the **Control Plane with the Execution Plane (for Continuous Delivery)** and a `LoadBalancer` for exposing Keptn can be installed by the following command:

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.16.0 --repo=https://charts.keptn.sh --set=continuous-delivery.enabled=true,control-plane.apiGatewayNginx.type=LoadBalancer
```

### Execute Helm upgrade without Internet connectivity

The following section contains instructions for installing Keptn in an air-gapped / offline installation scenario.

The following artifacts must be available locally:

* Keptn Helm Chart (control-plane + helm + jmeter)
* Several Docker Images (e.g., pushed into a private registry)
* Helper scripts
* Keptn CLI (optional, but recommended for future use)

**Download Keptn Helm Charts**

Download the Helm charts from the [Keptn 0.16.x release](https://github.com/keptn/keptn/releases/tag/0.16.0):

* Keptn Control Plane: <https://github.com/keptn/keptn/releases/download/0.16.0/keptn-0.16.0.tgz>
* helm-service (if needed): <https://github.com/keptn/keptn/releases/download/0.16.0/helm-service-0.16.0.tgz>
* jmeter-service (if needed): <https://github.com/keptn/keptn/releases/download/0.16.0/jmeter-service-0.16.0.tgz>

Move the Helm Charts to a directory on your local machine, e.g., `offline-keptn`.

For convenience, the following script creates this directory and downloads the required Helm Charts into it:

```console
mkdir offline-keptn
cd offline-keptn
curl -L https://github.com/keptn/keptn/releases/download/0.16.0/keptn-0.16.0.tgz -o keptn-0.16.0.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.16.0/helm-service-0.16.0.tgz -o helm-service-0.16.0.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.16.0/jmeter-service-0.16.0.tgz -o jmeter-service-0.16.0.tgz
cd ..
```

**Download Containers/Images**

Within the Helm Charts several Docker Images are referenced (Keptn specific and some third party dependencies).
We recommend pulling, re-tagging and pushing those images to a local registry that the Kubernetes cluster can reach.

A helper script is provided for this in our Git repository: <https://github.com/keptn/keptn/blob/master/installer/airgapped/pull_and_retag_images.sh>

For convenience, you can use the following commands to download and execute the script:

```console
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.16.0/installer/airgapped/pull_and_retag_images.sh -o pull_and_retag_images.sh
chmod +x pull_and_retag_images.sh
KEPTN_TAG=0.16.0 ./pull_and_retag_images.sh "your-registry.localhost:5000/"
cd ..
```

Be sure to include the trailing slash for the registry url (e.g., `your-registry.localhost:5000/`).

**Installation**

Keptn's Helm chart allows you to specify the name of all images, which can be especially handy in air-gapped systems where you cannot access DockerHub for pulling the images.

A helper script for this is provided in our Git repository: <https://github.com/keptn/keptn/blob/master/installer/airgapped/install_keptn.sh>

For convenience, you can use the following commands to download and execute the script:

```console
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.16.0/installer/airgapped/install_keptn.sh -o install_keptn.sh
chmod +x install_keptn.sh
./install_keptn.sh "your-registry.localhost:5000/" keptn-0.16.0.tgz helm-service-0.16.0.tgz jmeter-service-0.16.0.tgz
cd ..
```

### Install Keptn using a Root-Context

The Helm Chart allows customizing the root-context for the Keptn API and Bridge.
By default, the Keptn API is located under `http://HOSTNAME/api` and the Keptn Bridge is located under `http://HOSTNAME/bridge`.
By specifying a value for `control-plane.prefixPath`, the prefix used for the root-context can be configured.
For example, if a user sets `control-plane.prefixPath=/mykeptn` in the Helm install/upgrade command,
the Keptn API is located under `http://HOSTNAME/mykeptn/api` and the Keptn Bridge is located under `http://HOSTNAME/mykeptn/bridge`:

```console
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.16.0 --repo=https://charts.keptn.sh --set=control-plane.apiGatewayNginx.type=LoadBalancer,continuous-delivery.enabled=true,control-plane.prefixPath=/mykeptn
```

### Install Keptn with externally hosted MongoDB

If you want to use an externally hosted MongoDB instead of the MongoDB installed by Keptn, please use the `helm upgrade` command as shown below. Basically, provide the MongoDB host, port, user, and password in form of a connection string.

```console
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=control-plane.mongo.enabled=false,
      control-plane.mongo.external.connectionString=<YOUR_MONGODB_CONNECTION_STRING>,
      control-plane.mongo.auth.database=<YOUR_DATABASE_NAME>
```

Keptn has no opinion on how to fine-tune the database connection. We recommend the user specify any special configuration via the connection string (docs [here](https://www.mongodb.com/docs/manual/reference/connection-string/)) in the `control-plane.mongo.external.connectionString` helm value.

### Install Keptn with an ingress object

If you are already using an Ingress-Controller and want to create an ingress object for Keptn, you can leverage the ingress section of the helm chart. By default enabled is set to false.

The Helm chart allows customizing the ingress object to your needs.  When enabled is set the true, the chart allows you to specify optional parameters of host, path, pathType, tls, and annotations. This supports many different Ingress-Controllers and configurations.

```console
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=control-plane.ingress.enabled=true,
      control-plane.ingress.annotations=<YOUR_ANNOTATIONS>,
      control-plane.ingress.host=<YOUR_HOST>,
      control-plane.ingress.path=<YOUR_PATH>,
      control-plane.ingress.pathType=<YOUR_PATH_TYPE>,  
      control-plane.ingress.tls=<YOUR_TLS>
```

### Install Keptn using a user-provided API token

You can provide your own API token for Keptn to use by setting the secret name
in the `apiService.tokenSecretName` Helm value during installation. For Helm-Service and JMeter-Service you
can also provide the API token by using the `remoteControlPlane.tokenSecretName` Helm value.

The user-provided secret needs to live in the same namespace where Keptn will be installed.
The user-provided secret should contain a single key `keptn-api-token` with a token consisting of numbers and letters as its value.
