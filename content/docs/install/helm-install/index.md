---
title: Install Keptn using the Helm chart
description: Install Keptn on a single cluster using the Helm chart
weight: 40
---

Keptn is installed using a Helm chart using the Helm CLI.
You must install the [Helm CLI](https://helm.sh)
before attempting to install Keptn.

You probably want to also install the [Keptn CLI](../cli-install)
before installing Keptn.
It is possible to do most of what you need to do on modern releases of Keptn without the Keptn CLI
but the CLI provides additional functionality that is useful.
After installing Keptn,
you must [authenticate the Keptn CLI](../authenticate-cli-bridge/#authenticate-keptn-cli). 

Keptn consists of a **Control Plane** and an **Execution Plane**.

* The **Control Plane** is the minimum set of components that are required
  to run a Keptn instance  and to manage projects, stages, and services;
  to handle events; and to provide integration points.
  The control plane orchestrates the task sequences defined in Shipyard
  but does not actively execute the tasks.
  The Keptn Control Plane can run with no Execution Plane configured.

  The Control Plane can implement the [Quality Gates](../../concepts/quality_gates/)
  and [Automated Operations](../../concepts/automated_operations/) features
  but does not run microservices that integrate other tools with Keptn.

* The **Execution Plane** runs the microservices that integrate other tools with Keptn
  and is installed when you install the first microservice on the cluster.
  For example, the JMeter test tool runs on the Execution Plane
  and installing it installs the Execution Plane.
  As another example, the [Continuous Delivery](../../concepts/delivery/) feature
  requires that you install either the
[Job Executor Service](https://artifacthub.io/packages/keptn/keptn-integrations/job-executor-service)
or [Istio](https://istio.io) on the Kubernetes cluster(s)
and they execute on the Execution Plane.

See [Architecture](../../concepts/architecture) for more information
about the Control Plane and the Execution Plane.

You have the following installation options:

* Both the Keptn Control Plane and the Execution Plane
can be installed on an existing Kubernetes cluster that hosts other software
or on a dedicated Keptn Kubernetes cluster.
* The Control Plane and Execution Plane can also be installed on separate Kubernetes clusters;
see [Multi-cluster setup](../multi-cluster) for instructions.
* In a multi-cluster setup, one Keptn Control Plane can support multiple Execution Planes
that are installed on different clusters.

## Install Control Plane

To install the Control Plane, you must do the following:

* Define the Keptn chart repository
* Install Keptn into the `keptn` namespace on the Kubernetes cluster
* Expose the [API gateway's NGINX](../../concepts/architecture/#api-gateway-nginx) service
  that controls how Keptn communicates with the internet.
  See [Choose access option](../access) for details about all the options
  that are available and how to install and use them.
  You can also do this after installation.
* You may also want to modify the Keptn configuration options.
  This is discussed more below.

### Sample installation commands

* **Simple Keptn installation**

  The following commands provide a basic Keptn installation,
  Because the install command does not expose the API gateway's NGINX service,
  we use the **kubectl** command to implement port forwarding,
  which implements the Kubernetes [LoadBalancer](../access/#option-1-expose-keptn-via-a-loadbalancer):**:
   ```
   helm repo add keptn https://charts.keptn.sh
   helm install keptn keptn/keptn -nkeptn --createnamespace
   kubectl -n keptn port-forward svc /api-gateway-nginx 8080:8080
   ```
   This command is useful for creating a basic Keptn installation
   to use for study or demonstration.
   It may not be adequate for a production Keptn installation.

   *Watch a video demonstration of a simple installation [here](https://www.youtube.com/watch?v=neAqh4fAz-k).*

  The following commands are appropriate for installing a fully-functional production Keptn instance.
  They use the following options:

    * `--version 0.18.1` -- Keptn release to be installed
      If you do not specify the release, Helm uses the latest release.

    * `--repo=https://charts.keptn.sh` -- the location of the Helm chart
      (rather than using the `helm repo add` command shown above).
    * `apiGatewayNginx.type=<access-option>` -- this is necessary to access
      the Keptn Bridge UI.
      `<*access-option*>` must be `LoadBalancer`, `NodePort`, `Ingress`, or `Port-forward`.
      See [Choose access options](../access/) for details.
    * `--set=continuousDelivery.enabled=true` -- install Continuous Delivery support
      for this Keptn instance.

* **Install Keptn control-plane with Continuous Delivery support and exposed on a LoadBalancer**
    ```
    helm install keptn keptn --version 0.18.1 -n keptn --repo=https://charts.keptn.sh --create-namespace --wait --set=continuousDelivery.enabled=true,apiGatewayNginx.type=LoadBalancer
    ```

* **Use a LoadBalancer for api-gateway-nginx**

```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.18.1 --repo=https://charts.keptn.sh --set=apiGatewayNginx.type=LoadBalancer
```

* **Install Keptn with an ingress object**

  If you are already using an [Ingress Controller](../access/#option-3-expose-keptn-via-an-ingress)
  and want to create an ingress object for Keptn,
  you can leverage the ingress section of the Helm chart.

  The Helm chart allows customizing the ingress object to your needs.
  When `enabled` is set to `true` (by default, `enabled` is set to `false`),
  the chart allows you to specify optional parameters
  of host, path, pathType, tls, and annotations.
  This supports many different Ingress-Controllers and configurations.

  ```
  helm upgrade keptn keptn --install -n keptn --create-namespace
  --set=ingress.enabled=true,
       ingress.annotations=<YOUR_ANNOTATIONS>,
       ingress.host=<YOUR_HOST>,
       ingress.path=<YOUR_PATH>,
       ingress.pathType=<YOUR_PATH_TYPE>,  
       ingress.tls=<YOUR_TLS>
  ```

## Confirm Installation

After you issue the **helm install** command,
it takes a couple minutes for the installation to finish.
Use the following command to watch the progress:

```
kubectl -n keptn get servers
```

Wait for all the pods in the Keptn namespace to show `Running` under the `STATUS` column
before proceeding.

Use the following command to view all the services that are installed in the Keptn namespace:

```
kubectl -n keptn get services
```

## Access the Keptn Bridge

The [Keptn Bridge](../../0.18.x/bridge) is the graphical user interface
you can use to manage and view Keptn projects running in your installation.
To access it:

1. Expose the API Gateway NGINX.  This can be done in two ways:

   * Set the `apiGatewayNginx` parameter during installation
   * Issue the following command after installation:
     ```
     kubectl -n kkeptn port-forward svc/api-gateway-nginx 8080:80
     ```
2. Open a browser window to `localhost:8080`

3. Log into the Keptn Bridge.
   The following commands give you the username and randomly-generated password
   to use if your site uses [Basic Authentication](../../0.18.x/bridge/basic_authentication):

   ```
   kubectl -n keptn get secret bridge-credentials -o jsonpat-{.data.BASIC_AUTH_USERNAME} | base64 -d echo
   kubectl -n keptn get secret bridge-credentials -o jsonpat-{.data.BASIC_AUTH_PASSWORD} | base64 -d echo
   ```
   You can also use [OpenID Authentication](../../0.18.x/bridge/oauth) to access the Keptn Bridge.

## Install Execution Plane

To install the Execution Plane in the same namespace as the Control Plane,
install a microservice.
For example, the following two commands install the Jmeter and Helm-service microservices
and, by extension, install the Execution Plane:

```
helm install jmeter-service https://github.com/keptn/keptn/releases/download/0.18.1/jmeter-service-0.18.1.tgz -n keptn --create-namespace --wait

helm install helm-service https://github.com/keptn/keptn/releases/download/0.18.1/helm-service-0.18.1.tgz -n keptn --create-namespace --wait
```

The Execution Plane (or multiple Execution Planes) can also be installed on different Kubernetes clusters.
See [Multi-cluster setup](../multi-cluster) for details.

## The --set flag

The `helm install` and `helm upgrade` commands offer a flag called `--set`,
which can be used to specify several configuration options using the format `key1=value1,key2=value2,...`.
The full list of available flags can be found
in the [helm-charts](https://github.com/keptn/keptn/tree/master/installer/manifests/keptn).

* The **Control Plane with the Execution Plane (for Continuous Delivery)**
can be installed by the following command:
```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.18.1 --repo=https://charts.keptn.sh --set=continuousDelivery.enabled=true
```

* The **Control Plane with the Execution Plane (for Continuous Delivery)** and a `LoadBalancer` for exposing Keptn can be installed by the following command:
```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.18.1 --repo=https://charts.keptn.sh --set=continuousDelivery.enabled=true,apiGatewayNginx.type=LoadBalancer
```

## Install Keptn using a user-provided API token

You can provide your own API token for Keptn to use by setting the secret name
in the `apiService.tokenSecretName` Helm value during installation.
For Helm-Service and JMeter-Service,
you can also provide the API token by using the `remoteControlPlane.tokenSecretName` Helm value.

The user-provided secret needs to live in the same namespace where Keptn will be installed.
The user-provided secret should contain a single key `keptn-api-token`
with a token consisting of numbers and letters as its value.

## Execute Helm upgrade without Internet connectivity

The following section contains instructions for installing Keptn in an air-gapped / offline installation scenario.

The following artifacts must be available locally:

* Keptn Helm Chart (control-plane + helm + jmeter)
* Several Docker Images (e.g., pushed into a private registry)
* Helper scripts
* Keptn CLI (optional, but recommended for future use)

**Download Keptn Helm Charts**

Download the Helm charts from the [Keptn 0.18.x release](https://github.com/keptn/keptn/releases/tag/0.18.1):

* Keptn Control Plane: https://github.com/keptn/keptn/releases/download/0.18.1/keptn-0.18.1.tgz
* helm-service (if needed): https://github.com/keptn/keptn/releases/download/0.18.1/helm-service-0.18.1.tgz
* jmeter-service (if needed): https://github.com/keptn/keptn/releases/download/0.18.1/jmeter-service-0.18.1.tgz

Move the Helm Charts to a directory on your local machine, e.g., `offline-keptn`.

For convenience, the following script creates this directory and downloads the required Helm Charts into it:

```
mkdir offline-keptn
cd offline-keptn
curl -L https://github.com/keptn/keptn/releases/download/0.18.1/keptn-0.18.1.tgz -o keptn-0.18.1.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.18.1/helm-service-0.18.1.tgz -o helm-service-0.18.1.tgz
curl -L https://github.com/keptn/keptn/releases/download/0.18.1/jmeter-service-0.18.1.tgz -o jmeter-service-0.18.1.tgz
cd ..
```

**Download Containers/Images**

Within the Helm Charts several Docker Images are referenced (Keptn specific and some third party dependencies).
We recommend pulling, re-tagging and pushing those images to a local registry that the Kubernetes cluster can reach.

A helper script is provided for this in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/pull_and_retag_images.sh

For convenience, you can use the following commands to download and execute the script:

```
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.18.1/installer/airgapped/pull_and_retag_images.sh -o pull_and_retag_images.sh
chmod +x pull_and_retag_images.sh
KEPTN_TAG=0.18.1 ./pull_and_retag_images.sh "your-registry.localhost:5000/"
cd ..
```

Be sure to include the trailing slash for the registry url (e.g., `your-registry.localhost:5000/`).

**Installation**

Keptn's Helm chart allows you to specify the name of all images, which can be especially handy in air-gapped systems where you cannot access DockerHub for pulling the images.

A helper script for this is provided in our Git repository: https://github.com/keptn/keptn/blob/master/installer/airgapped/install_keptn.sh

For convenience, you can use the following commands to download and execute the script:

```
cd offline-keptn
curl -L https://raw.githubusercontent.com/keptn/keptn/0.18.1/installer/airgapped/install_keptn.sh -o install_keptn.sh
chmod +x install_keptn.sh
./install_keptn.sh "your-registry.localhost:5000/" keptn-0.18.1.tgz helm-service-0.18.1.tgz jmeter-service-0.18.1.tgz
cd ..
```

## Install Keptn using a Root-Context

The Helm Chart allows customizing the root-context for the Keptn API and Bridge.
By default, the Keptn API is located under `http://HOSTNAME/api` and the Keptn Bridge is located under `http://HOSTNAME/bridge`.
By specifying a value for `prefixPath`, the prefix used for the root-context can be configured.
For example, if a user sets `prefixPath=/mykeptn` in the Helm install/upgrade command,
the Keptn API is located under `http://HOSTNAME/mykeptn/api` and the Keptn Bridge is located under `http://HOSTNAME/mykeptn/bridge`:

```
helm upgrade keptn keptn --install -n keptn --create-namespace --wait --version=0.18.1 --repo=https://charts.keptn.sh --set=apiGatewayNginx.type=LoadBalancer,continuousDelivery.enabled=true,prefixPath=/mykeptn
```

## Install Keptn with externally hosted MongoDB

If you want to use an externally hosted MongoDB instead of the MongoDB installed by Keptn, please use the `helm upgrade` command as shown below. Basically, provide the MongoDB host, port, user, and password in form of a connection string.

```
helm upgrade keptn keptn --install -n keptn --create-namespace
--set=mongo.enabled=false,
      mongo.external.connectionString=<YOUR_MONGODB_CONNECTION_STRING>,
      mongo.auth.database=<YOUR_DATABASE_NAME>
```

Keptn has no opinion on how to fine-tune the database connection. We recommend the user specify any special configuration via the connection string (docs [here](https://www.mongodb.com/docs/manual/reference/connection-string/)) in the `mongo.external.connectionString` helm value.
