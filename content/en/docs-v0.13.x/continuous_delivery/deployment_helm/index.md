---
title: Deployment with Helm
description: Details about Keptn using Helm for deployment.
weight: 10
keywords: [0.13.x-cd]
---

Keptn uses [Helm v3](https://helm.sh/) for deploying a services to a Kubernetes cluster. This is currently implemented in the [helm-service](https://github.com/keptn/keptn/tree/0.13.1/helm-service).
Keptn's helm-service supports the following deployment strategies:

* **Direct deployments**
* **Blue-green deployments**
* **user-managed deployments**

The explanation below is based on the provided Helm Chart for the carts microservice, see [Charts](https://github.com/keptn/examples/tree/0.11.0/onboarding-carts/carts) for details.

## Direct deployments

If the deployment strategy of a stage in the [shipyard](https://github.com/keptn/examples/blob/0.11.0/onboarding-carts/shipyard.yaml) is configured as `deploymentstrategy: direct`, Helm deploys a
 release called `sockshop-dev-carts` as `carts` in namespace `sockshop-dev`.

```console
$ kubectl get deployments -n sockshop-dev carts -owide
```

```
NAME    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts   1/1     1            1           56m   carts        docker.io/keptnexamples/carts:0.13.1   app=carts
```

When triggering a delivery (with a new artifact), we are updating the values.yaml file in the Helm Chart with the respective image name.

* [chart/values.yaml](https://github.com/keptn/examples/blob/0.11.0/onboarding-carts/carts/values.yaml#L1)
* [chart/templates/deployment.yaml](https://github.com/keptn/examples/blob/0.11.0/onboarding-carts/carts/templates/deployment.yaml#L22)

## Blue-green deployments

If the deployment strategy of a stage in the [shipyard](https://github.com/keptn/examples/blob/0.11.0/onboarding-carts/shipyard.yaml) is configured as `deploymentstrategy: blue_green_service`, Helm creates two
 deployments within the Kubernetes cluster: (1) the primary and (2) the canary deployment. This can be inspected using the
 following command:

```console
$ kubectl get deployments -n sockshop-staging carts carts-primary -owide
```

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1           56m   carts        docker.io/keptnexamples/carts:0.13.1   app=carts-primary
carts           0/0     0            0            3m   carts        docker.io/keptnexamples/carts:0.13.2   app=carts
```


When triggering a delivery (with a new artifact, e.g., 0.13.2), a canary deployment will be modified and scaled up.

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1           57m   carts        docker.io/keptnexamples/carts:0.13.1   app=carts-primary
carts           0/1     1            1            1m   carts        docker.io/keptnexamples/carts:0.13.2   app=carts
```

The primary deployment is always available (and called `carts-primary`). The canary deployment (called `carts`) gets scaled up in the case of a new-artifact event (e.g., in this case someone has sent a new-artifact for 0.13.2). Traffic is shifted to the canary release.

Once testing has finished, the primary deployment is upgraded to the new version (0.13.2).

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1            3m   carts        docker.io/keptnexamples/carts:0.13.2   app=carts-primary
carts           1/1     1            1            1d   carts        docker.io/keptnexamples/carts:0.13.2   app=carts
```

After a new pod for the primary deployment has been successfully deployed, traffic is shifted to the primary deployment
 and the canary deployment is scaled down:

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1            4m   carts        docker.io/keptnexamples/carts:0.13.2   app=carts-primary
carts           0/0     0            0            1d   carts        docker.io/keptnexamples/carts:0.13.2   app=carts
```

## User Managed deployments

If the deployment strategy of a stage in the [shipyard](https://github.com/keptn/examples/blob/0.11.0/onboarding-carts/shipyard.yaml)
is configured as `deploymentstrategy: user_managed`, the provided Helm Chart will be deployed without any modification and
applied as it is.

```
apiVersion: "spec.keptn.sh/0.2.2"
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "staging"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "user_managed"
            - name: "test"
            - name: "evaluation"
            - name: "release"

    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "user_managed"
            - name: "release"
```

Assuming that you've created a project from a shipyard file containing a stage with `deploymentstrategy: user_managed`, you need to:

1. Create a service in your stage:
```
keptn create service <service-name> --project <project-name>
```

2. Add your desired Helm Chart to each stage:
```
keptn add-resource --project=<project-name> --service=<service-name> --all-stages --resource=<your-helm-chart.tgz> --resourceUri=helm/<service-name>.tgz
```

3. Upload a file called `endpoints.yaml` where you can defined the host name under which your deployed service will be available:
  ```
  keptn add-resource --project=<project-name> --service=<service-name> --all-stages --resource=<path_to_endpoints.yaml> --resourceUri=helm/endpoints.yaml
  ```
  **Note**: This step is required, if you will need the `data.deployment.deploymentURIsPublic` and/or `data.deployment.deploymentURIsLocal` property of the `deployment.finished` event sent by the helm-service. This is the case, e.g., when the `jmeter-service`, which performs the `test` task needs to determine the URL for the service to be tested. The `endpoints.yaml` file has the following structure:
  ```yaml
  deploymentURIsLocal:
    - "<my-local-url>" # e.g. http://my-service.sockshop-dev:8080
  deploymentURIsPublic:
    - "<my-public-url>" # e.g. http://123.123.123.nip.io:80
  ```

4. Send an event to trigger the delivery of your service:
```
keptn send event --file=./delivery.json
```
where the content of `delivery.json` looks something like:

```
{
  "contenttype": "application/json",
  "data": {
    "project": "<project-name",
    "service": "<service-name>",
    "stage": "<stage-name>"
  },
  "source": "keptn-cli",
  "specversion": "1.0",
  "type": "sh.keptn.event.<stage-name>.delivery.triggered"
}
```

**Limitations:**

* Currently, when using this deployment strategy, you cannot use the `keptn trigger delivery` command as you would
normally do. Hence, you need to send an event using `keptn send event` like described above.
* Modifications to the Helm Chart via keptn configuration changes are currently not possible.

## Clean-up after deleting a project

When executing [keptn delete project](../../reference/cli/commands/keptn_delete_project/), Keptn does **not** clean up existing deployments nor Helm releases. To do so, delete all relevant namespaces:

* For each stage defined stage within the shipyard of the project, execute `kubectl delete namespace <PROJECTNAME>-<STAGENAME>`, e.g. for `sockshop` with stages `dev`, `staging` and `production`:

  ```console
  kubectl delete namespace sockshop-dev
  kubectl delete namespace sockshop-staging
  kubectl delete namespace sockshop-production
  ```
