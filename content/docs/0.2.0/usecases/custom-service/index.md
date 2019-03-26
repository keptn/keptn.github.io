---
title: Write your own Keptn service
description: Shows you how to implement your own keptn service and listen for certain events.
weight: 20
keywords: [service, custom]
aliases:
---

Shows you how to implement your own keptn service and listen for certain events.

## About this use case

The goal of this use case is to describe how you can add additional functionality to your keptn installation by implementing your own services. 
You can react to certain events that occur during your CD pipeline runs, and, integrate additional tools into your pipeline by accessing their REST interfaces with your custom services. At the moment the events you can subscribe to include:

- sh.keptn.events.new-artefact
- sh.keptn.events.configuration-changed
- sh.keptn.events.deployment-finished
- sh.keptn.events.tests-finished
- sh.keptn.events.evaluation-done

## Writing you own service

As a reference for writing your own service, please have a look at our implementation of the [GitHub Service](https://github.com/keptn/github-service). Essentially, this service is a *nodeJS express* application that accepts POST requests at its `/` endpoint. This endpoint is called by the *knative channel controller* as soon as an event has been pushed to the queue your service is subscribed to. Of course, you can write your own service in any language, as long as it provides the endpoint to receive events.

Services in keptn are implemented as [knative services](https://cloud.google.com/knative/). The template manifest for the *GitHub service* can be found in the [config/service.yaml](https://github.com/keptn/github-service/tree/master/config) file in the GitHub repo:

  ```yaml
  apiVersion: serving.knative.dev/v1alpha1
  kind: Service
  metadata:
    name: github-service
    namespace: keptn
  spec:
    runLatest:
      configuration:
        build:
          apiVersion: build.knative.dev/v1alpha1
          kind: Build
          metadata:
            name: service-builder
            namespace: keptn
          spec:
            serviceAccountName: build-bot
            source:
              git:
                url: https://github.com/keptn/github-service.git
                revision: master
            template:
              name: kaniko
              arguments:
                - name: IMAGE
                  value: docker-registry.keptn.svc.cluster.local:5000/keptn/github-service:latest
        revisionTemplate:
          spec:
            container:
              image: REGISTRY_URI_PLACEHOLDER:5000/keptn/github-service:latest
  ---
  apiVersion: eventing.knative.dev/v1alpha1
  kind: Subscription
  metadata:
    name: github-new-artefact-subscription
    namespace: keptn
  spec:
    channel:
      apiVersion: eventing.knative.dev/v1alpha1
      kind: Channel
      name: new-artefact
    subscriber:
      ref:
        apiVersion: serving.knative.dev/v1alpha1
        kind: Service
        name: github-service
  ```

As you can see in the manifest file, it consists of a *knative service*, as well as a *knative eventing subscription*. The service makes use of knative's source-to-url feature, meaning that knative will take care of building and deploying your service, using the build specification in the manifest file. The build specification accepts the link to a github repository containing a Dockerfile (which you will need to provide) for your application and will use the *kaniko* build template to build the container and push it to the registry specified in the build spec. In this case, the template references the docker registry that has been deployed within the keptn namespace of the cluster. Also, note that there is a placeholder for the IP address of the registry (`REGISTRY_URI_PLACEHOLDER`). This is because currently it is not possible to reference the cluster-internal DNS name for the container image the service should pull when it is being invoked.

The *Subscription* defines to which kind of event the service should listen to. To subscribe your service to a queue, set the property *spec.channel.name* to one of the following:

  ```
  configuration-changed   2h
  deployment-finished     2h
  evaluation-done         2h
  keptn-channel           2h
  new-artefact            2h
  problem                 2h
  start-deployment        2h
  start-evaluation        2h
  start-tests             2h
  tests-finished          2h
  ```

Additionally, you will need to provide a name for the subscription (*metadata.name*), and reference the name of your service (*spec.subscriber.ref.name*).

To deploy the service, we use a script that will first retrieve the IP of the cluster-internal docker registry, and replace the `REGISTRY_URI_PLACEHOLDER` in the manifest file with that value. The resulting manifest file will be stored in the *[config/gen](https://github.com/keptn/github-service/tree/master/config/gen)* directory. By executing the script with

  ```console
  $ ./deploy.sh
  ```

any previous revisions of the service will be deleted and the newest version will be deployed.

*To summarize*, you will need to provide the following when you want to write a custom service:

- A Github repo, containing the source code, as well as a Dockerfile for your application.
- The application needs to provide a REST endpoint at `/` that accepts `POST` requests for JSON objects.
- The `config` directory, containing the template for the manifest file (see description above), as well as the `config/gen` directory.
- The `deploy.sh` script.
