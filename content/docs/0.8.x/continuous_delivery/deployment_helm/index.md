---
title: Deployment with Helm
description: Details about Keptn using Helm for deployment.
weight: 10
keywords: [0.8.x-cd]
---

Keptn uses [Helm v3](https://helm.sh/) for deploying onboarded services to a Kubernetes cluster. This is currently implemented in the [helm-service](https://github.com/keptn/keptn/tree/0.7.3/helm-service). The helm-service supports two deployment strategies explained below:

* **Direct deployments**
* **Blue-green deployments**

The explanation is based on the provided Helm Chart for the carts microservice, see [Charts](https://github.com/keptn/examples/tree/0.7.3/onboarding-carts/carts) for details.

## Direct deployments

If the deployment strategy of a stage in the [shipyard](https://github.com/keptn/examples/blob/0.7.3/onboarding-carts/shipyard.yaml) is configured as `deployment_strategy: direct`, Helm deploys a 
 release called `sockshop-dev-carts` as `carts` in namespace `sockshop-dev`.
 
```console
$ kubectl get deployments -n sockshop-dev carts -owide
```

```
NAME    READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts   1/1     1            1           56m   carts        docker.io/keptnexamples/carts:0.11.1   app=carts
```

When sending a new-artifact, we are updating the values.yaml file in the Helm Charts with the respective image name.

* [chart/values.yaml](https://github.com/keptn/examples/blob/0.7.3/onboarding-carts/carts/values.yaml#L1)
* [chart/templates/deployment.yaml](https://github.com/keptn/examples/blob/0.7.3/onboarding-carts/carts/templates/deployment.yaml#L22)

## Blue-green deployments

If the deployment strategy of a stage in the [shipyard](https://github.com/keptn/examples/blob/0.7.3/onboarding-carts/shipyard.yaml) is configured as `deployment_strategy: blue_green_service`, Helm creates two
 deployments within the Kubernetes cluster: (1) the primary and (2) the canary deployment. This can be inspected using the
 following command:

```console
$ kubectl get deployments -n sockshop-staging carts carts-primary -owide
```

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1           56m   carts        docker.io/keptnexamples/carts:0.11.1   app=carts-primary
carts           0/0     0            0            3m   carts        docker.io/keptnexamples/carts:0.11.2   app=carts
```


When a new artifact is deployed (e.g., 0.11.2), a canary deployment will be modified and scaled up.

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1           57m   carts        docker.io/keptnexamples/carts:0.11.1   app=carts-primary
carts           0/1     1            1            1m   carts        docker.io/keptnexamples/carts:0.11.2   app=carts
```

The primary deployment is always available (and called `carts-primary`). The canary deployment (called `carts`) gets scaled up in the case of a new-artifact event (e.g., in this case someone has sent a new-artifact for 0.11.2). Traffic is shifted to the canary release. 
 
Once testing has finished, the primary deployment is upgraded to the new version (0.11.2). 
 
```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1            3m   carts        docker.io/keptnexamples/carts:0.11.2   app=carts-primary
carts           1/1     1            1            1d   carts        docker.io/keptnexamples/carts:0.11.2   app=carts
```

After a new pod for the primary deployment has been successfully deployed, traffic is shifted to the primary deployment
 and the canary deployment is scaled down:

```
NAME            READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                 SELECTOR
carts-primary   1/1     1            1            4m   carts        docker.io/keptnexamples/carts:0.11.2   app=carts-primary
carts           0/0     0            0            1d   carts        docker.io/keptnexamples/carts:0.11.2   app=carts
```

## Clean-up after deleting a project

When executing [keptn delete project](../../reference/cli/commands/keptn_delete_project/), Keptn does **not** clean up existing deployments nor Helm releases. To do so, delete all relevant namespaces:

* For each stage defined the shipyard file, execute `kubectl delete namespace PROJECTNAME-STAGENAME`, e.g.:

  ```console
  kubectl delete namespace sockshop-dev
  kubectl delete namespace sockshop-staging
  kubectl delete namespace sockshop-production
  ```
**Note:** This will also delete the corresponding Helm releases, which are stored as Kubernetes secrets in the namespaces.
