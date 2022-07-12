---
title: values (Keptn helm-service)
description: Configure the Keptn Helm chart
weight: 915
---

The `values.yaml` configuration file defines the configuration used
when installing Keptn with a Helm chart; see
[Installing Keptn using the Helm chart](../../../../install/helm-install).
`Values` is a built-in object of Helm templates; see the Helm documentation at
[Values Files(https://helm.sh/docs/chart_template_guide/values_files/).

## Synopsis (Option 1)

See [values.yaml](https://helm.sh/docs/chart_template_guide/values_files/)
in the Keptn GitHub repository
for the default Keptn file.

## Synopsis (Option 2)

````
continuousDelivery:
  enabled: false
  ingressConfig:
    ingress_hostname_suffix: "svc.cluster.local"
    ingress_protocol: "http"
    ingress_port: "80"
    istio_gateway: "public-gateway.istio-system"

mongo:
  enabled: true
  host: mongodb:27017
  architecture: standalone
  service:
    nameOverride: 'mongo'
    port: 27017
  auth:
    enabled: true
    databases:
      - 'keptn'
    existingSecret: 'mongodb-credentials' # If the password and rootPassword values below are used, remove this field.
    usernames:
      - 'keptn'
    password: null
    rootUser: 'admin'
    rootPassword: null
    bridgeAuthDatabase: 'keptn'
  external:
    connectionString:

prefixPath: ""

keptnSpecVersion: latest

features:
  automaticProvisioning:
    serviceURL: ""
    message: ""
  swagger:
    hideDeprecated: false
  oauth:
    enabled: false
    prefix: "keptn:"

nats:
  nameOverride: keptn-nats
  fullnameOverride: keptn-nats
  cluster:
    replicas: 3
    name: nats
  nats:
    healthcheck:
      startup:
        enabled: false
    jetstream:
      enabled: true

      memStorage:
        enabled: true
        size: 2Gi

      fileStorage:
        enabled: true
        size: 5Gi
        storageDirectory: /data/
        storageClassName: ""

  natsbox:
    enabled: false
  reloader:
    enabled: false

apiGatewayNginx:
  type: ClusterIP
  port: 80
  targetPort: 8080
  nodePort: 31090
  podSecurityContext:
    enabled: true
    defaultSeccompProfile: true
    fsGroup: 101
  containerSecurityContext:
    enabled: true
    runAsNonRoot: true
    runAsUser: 101
    readOnlyRootFilesystem: false
    allowPrivilegeEscalation: false
    privileged: false
  image:
    repository: docker.io/nginxinc/nginx-unprivileged
    tag: 1.22.0-alpine
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  clientMaxBodySize: "5m"
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "64Mi"
      cpu: "50m"
    limits:
      memory: "128Mi"
      cpu: "100m"

remediationService:
  enabled: true
  image:
    repository: docker.io/keptn/remediation-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 5
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "64Mi"
      cpu: "50m"
    limits:
      memory: "1Gi"
      cpu: "200m"

apiService:
  tokenSecretName:
  image:
    repository: docker.io/keptn/api
    tag: ""
  maxAuth:
    enabled: true
    requestsPerSecond: "1.0"
    requestBurst: "2"
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 5
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "50m"
    limits:
      memory: "64Mi"
      cpu: "100m"

bridge:
  image:
    repository: docker.io/keptn/bridge2
    tag: ""
  cliDownloadLink: null
  integrationsPageLink: null
  secret:
    enabled: true
  versionCheck:
    enabled: true
  showApiToken:
    enabled: true
  installationType: null
  lookAndFeelUrl: null
  podSecurityContext:
    enabled: true
    defaultSeccompProfile: true
    fsGroup: 65532
  containerSecurityContext:
    enabled: true
    runAsNonRoot: true
    runAsUser: 65532
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    privileged: false
  oauth:
    discovery: ""
    secureCookie: false
    trustProxy: ""
    sessionTimeoutMin: ""
    sessionValidatingTimeoutMin: ""
    baseUrl: ""
    clientID: ""
    clientSecret: ""
    IDTokenAlg: ""
    scope: ""
    userIdentifier: ""
    mongoConnectionString: ""
  authMsg: ""
  d3heatmap:
    enabled: false
  nodeSelector: {}
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "64Mi"
      cpu: "25m"
    limits:
      memory: "256Mi"
      cpu: "200m"

distributor:
  metadata:
    hostname:
    namespace:
  image:
    repository: docker.io/keptn/distributor
    tag: ""
  config:
    proxy:
      httpTimeout: "30"
      maxPayloadBytesKB: "64"
    queueGroup:
      enabled: true
    oauth:
      clientID: ""
      clientSecret: ""
      discovery: ""
      tokenURL: ""
      scopes: ""
  resources:
    requests:
      memory: "16Mi"
      cpu: "25m"
    limits:
      memory: "32Mi"
      cpu: "100m"

shipyardController:
  image:
    repository: docker.io/keptn/shipyard-controller
    tag: ""
  config:
    taskStartedWaitDuration: "10m"
    uniformIntegrationTTL: "48h"
    disableLeaderElection: true
    replicas: 1
    validation:
      # On Database level, Keptn creates collections that are named like <PROJECTNAME>-<suffix>
      # Keep in mind that "suffix" can occupy up to 20 characters so that you will eventually
      # hit the database limit for max collection name size when your project name is too long.
      # projectNameMaxSize can be used to forbid project names longer than a certain size in Keptn
      projectNameMaxSize: 200
      # The limit of 43 characters for a service's name is currently imposed by the helm-service,
      # which, if being used for the CD use case with blue/green deployments generates a helm release called <serviceName>-generated,
      # and helm releases have a maximum length of 53 characters. Therefore, we use this value as a default.
      # If the helm chart generation for blue/green deployments is not needed, and this value is too small, it can be adapted here
      serviceNameMaxSize: 43
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 15
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "50m"
    limits:
      memory: "128Mi"
      cpu: "100m"

secretService:
  image:
    repository: docker.io/keptn/secret-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "64Mi"
      cpu: "200m"

configurationService:
  image:
    repository: docker.io/keptn/configuration-service
    tag: ""
  # storage and storageClass are the settings for the PVC used by the configuration-storage
  storage: 100Mi
  storageClass: null
  fsGroup: 1001
  initContainer: true
  env:
    GIT_KEPTN_USER: "keptn"
    GIT_KEPTN_EMAIL: "keptn@keptn.sh"
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "256Mi"
      cpu: "100m"

resourceService:
  enabled: true
  replicas: 1
  image:
    repository: docker.io/keptn/resource-service
    tag: ""
  env:
    GIT_KEPTN_USER: "keptn"
    GIT_KEPTN_EMAIL: "keptn@keptn.sh"
    DIRECTORY_STAGE_STRUCTURE: "false"
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "64Mi"
      cpu: "100m"

mongodbDatastore:
  image:
    repository: docker.io/keptn/mongodb-datastore
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "50m"
    limits:
      memory: "512Mi"
      cpu: "300m"

lighthouseService:
  enabled: true
  image:
    repository: docker.io/keptn/lighthouse-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "128Mi"
      cpu: "50m"
    limits:
      memory: "1Gi"
      cpu: "200m"

statisticsService:
  enabled: false
  image:
    repository: docker.io/keptn/statistics-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "64Mi"
      cpu: "100m"

approvalService:
  enabled: true
  image:
    repository: docker.io/keptn/approval-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 5
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "128Mi"
      cpu: "100m"

webhookService:
  enabled: true
  image:
    repository: docker.io/keptn/webhook-service
    tag: ""
  nodeSelector: {}
  gracePeriod: 60
  preStopHookTime: 20
  sidecars: []
  extraVolumeMounts: []
  extraVolumes: []
  resources:
    requests:
      memory: "32Mi"
      cpu: "25m"
    limits:
      memory: "64Mi"
      cpu: "100m"

ingress:
  enabled: false
  annotations: {}
  host: {}
  path: /
  pathType: Prefix
  className: ""
  tls:
    []

logLevel: "info"

strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
podSecurityContext:
  enabled: true
  defaultSeccompProfile: true
  fsGroup: 65532
containerSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 65532
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  privileged: false
nodeSelector: {}
````

## Fields

**continuousDelivery** section

These settings are used to configure
[Continuous Delivery](../../../continuous_delivery),
specifically the Blue-Green deployment option.

  * enabled: false
  * ingressConfig:
    * ingress_hostname_suffix: "svc.cluster.local"
    * ingress_protocol: "http"
    * ingress_port: "80"
    * istio_gateway: "public-gateway.istio-system"

    The default values use [Istio](../../../../install/istio).
    If you are using a different service mesh,
    you need to configure the appropriate fields.

**mongo** section
  * enabled: true
  * host: mongodb:27017
  * architecture: standalone
  * service:
    * nameOverride: 'mongo'
    * port: 27017
  * auth:
    * enabled: true
    * databases:
      * - 'keptn'
    * existingSecret: 'mongodb-credentials' # If the password and rootPassword values below are used, remove this field.
    * usernames:
      * - 'keptn'
    * password: null
    * rootUser: 'admin'
    * rootPassword: null
    * bridgeAuthDatabase: 'keptn'
  * external:
    * connectionString:

**prefixPath** section

keptnSpecVersion: latest

**features** section

  * automaticProvisioning:
    * serviceURL: ""
    * message: ""
  * swagger:
    * hideDeprecated: false
  * oauth:
    * enabled: false
    * prefix: "keptn:"

**nats** section
  * nameOverride: keptn-nats
  * fullnameOverride: keptn-nats
  * cluster:
    * replicas: 3
    * name: nats
  * nats:
    * healthcheck:
      * startup:
        * enabled: false
    * jetstream:
      * enabled: true

      * memStorage:
        * enabled: true
        * size: 2Gi

      * fileStorage:
        * enabled: true
        * size: 5Gi
        * storageDirectory: /data/
        * storageClassName: ""

  * natsbox:
    * enabled: false
  * reloader:
    * enabled: false

**apiGatewayNginx** section
  * type: ClusterIP
  * port: 80
  * targetPort: 8080
  * nodePort: 31090
  * podSecurityContext:
    * enabled: true
    * defaultSeccompProfile: true
    * fsGroup: 101
  * containerSecurityContext:
    * enabled: true
    * runAsNonRoot: true
    * runAsUser: 101
    * readOnlyRootFilesystem: false
    * allowPrivilegeEscalation: false
    * privileged: false
  * image:
    * repository: docker.io/nginxinc/nginx-unprivileged
    * tag: 1.22.0-alpine
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * clientMaxBodySize: "5m"
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "64Mi"
      * cpu: "50m"
    * limits:
      * memory: "128Mi"
      * cpu: "100m"

**remediationService** section
  * enabled: true
  * image:
    * repository: docker.io/keptn/remediation-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 5
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "64Mi"
      * cpu: "50m"
    * limits:
      * memory: "1Gi"
      * cpu: "200m"

**apiService** section
  * tokenSecretName:
  * image:
    * repository: docker.io/keptn/api
    * tag: ""
  * maxAuth:
    * enabled: true
    * requestsPerSecond: "1.0"
    * requestBurst: "2"
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 5
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "50m"
    * limits:
      * memory: "64Mi"
      * cpu: "100m"

**bridge** section
  * image:
    * repository: docker.io/keptn/bridge2
    * tag: ""
  * cliDownloadLink: null
  * integrationsPageLink: null
  * secret:
    * enabled: true
  * versionCheck:
    * enabled: true
  * showApiToken:
    * enabled: true
  * installationType: null
  * lookAndFeelUrl: null
  * podSecurityContext:
    * enabled: true
    * defaultSeccompProfile: true
    * fsGroup: 65532
  * containerSecurityContext:
    * enabled: true
    * runAsNonRoot: true
    * runAsUser: 65532
    * readOnlyRootFilesystem: true
    * allowPrivilegeEscalation: false
    * privileged: false
  * oauth:
    * discovery: ""
    * secureCookie: false
    * trustProxy: ""
    * sessionTimeoutMin: ""
    * sessionValidatingTimeoutMin: ""
    * baseUrl: ""
    * clientID: ""
    * clientSecret: ""
    * IDTokenAlg: ""
    * scope: ""
    * userIdentifier: ""
    * mongoConnectionString: ""
  * authMsg: ""
  * d3heatmap:
    * enabled: false
  * nodeSelector: {}
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "64Mi"
      * cpu: "25m"
    * limits:
      * memory: "256Mi"
      * cpu: "200m"

**distributor** section
  * metadata:
    * hostname:
    * namespace:
  * image:
    * repository: docker.io/keptn/distributor
    * tag: ""
  * config:
    * proxy:
      * httpTimeout: "30"
      * maxPayloadBytesKB: "64"
    * queueGroup:
      * enabled: true
    * oauth:
      * clientID: ""
      * clientSecret: ""
      * discovery: ""
      * tokenURL: ""
      * scopes: ""
  * resources:
    * requests:
      * memory: "16Mi"
      * cpu: "25m"
    * limits:
      * memory: "32Mi"
      * cpu: "100m"

**shipyardController** section
  * image:
    * repository: docker.io/keptn/shipyard-controller
    * tag: ""
  * config:
    * taskStartedWaitDuration: "10m"
    * uniformIntegrationTTL: "48h"
    * disableLeaderElection: true
    * replicas: 1
    * validation:
      * On Database level, Keptn creates collections that are named like <PROJECTNAME>-<suffix>
       Keep in mind that "suffix" can occupy up to 20 characters so that you will eventually
       hit the database limit for max collection name size when your project name is too long.
       projectNameMaxSize can be used to forbid project names longer than a certain size in Keptn
      * projectNameMaxSize: 200
      The limit of 43 characters for a service's name is currently imposed by the helm-service,
      which, if being used for the CD use case with blue/green deployments generates a helm release called <serviceName>-generated,
      and helm releases have a maximum length of 53 characters. Therefore, we use this value as a default.
      If the helm chart generation for blue/green deployments is not needed, and this value is too small, it can be adapted here
      * serviceNameMaxSize: 43
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 15
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "50m"
    * limits:
      * memory: "128Mi"
      * cpu: "100m"

**secretService* section
  * image:
    * repository: docker.io/keptn/secret-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "64Mi"
      * cpu: "200m"

**configurationService** section
  * image:
    * repository: docker.io/keptn/configuration-service
    * tag: ""

  The storage and storageClass are the settings for the PVC used by the configuration-storage
  * storage: 100Mi
  * storageClass: null
  * fsGroup: 1001
  * initContainer: true
  * env:
    * GIT_KEPTN_USER: "keptn"
    * GIT_KEPTN_EMAIL: "keptn@keptn.sh"
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "256Mi"
      * cpu: "100m"

**resourceService** section
  * enabled: true
  * replicas: 1
  * image:
    * repository: docker.io/keptn/resource-service
    * tag: ""
  * env:
    * GIT_KEPTN_USER: "keptn"
    * GIT_KEPTN_EMAIL: "keptn@keptn.sh"
    * DIRECTORY_STAGE_STRUCTURE: "false"
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "64Mi"
      * cpu: "100m"

**mongodbDatastore** section
  * image:
    * repository: docker.io/keptn/mongodb-datastore
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "50m"
    * limits:
      * memory: "512Mi"
      * cpu: "300m"

**lighthouseService** section
  * enabled: true
  * image:
    * repository: docker.io/keptn/lighthouse-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "128Mi"
      * cpu: "50m"
    * limits:
      * memory: "1Gi"
      * cpu: "200m"

**statisticsService** section
  * enabled: false
  * image:
    * repository: docker.io/keptn/statistics-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "64Mi"
      * cpu: "100m"

**approvalService** service
  * enabled: true
  * image:
    * repository: docker.io/keptn/approval-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 5
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "128Mi"
      * cpu: "100m"

**webhookService** section
  * enabled: true
  * image:
    * repository: docker.io/keptn/webhook-service
    * tag: ""
  * nodeSelector: {}
  * gracePeriod: 60
  * preStopHookTime: 20
  * sidecars: []
  * extraVolumeMounts: []
  * extraVolumes: []
  * resources:
    * requests:
      * memory: "32Mi"
      * cpu: "25m"
    * limits:
      * memory: "64Mi"
      * cpu: "100m"

**ingress** service
  * enabled: false
  * annotations: {}
  * host: {}
  * path: /
  * pathType: Prefix
  * className: ""
  * tls:
    * []

**logLevel: "info"** setting

**strategy:** section
  * type: RollingUpdate
  * rollingUpdate:
    * maxSurge: 1
    * maxUnavailable: 0
* podSecurityContext:
  * enabled: true
  * defaultSeccompProfile: true
  * fsGroup: 65532
* containerSecurityContext:
  * enabled: true
  * runAsNonRoot: true
  * runAsUser: 65532
  * readOnlyRootFilesystem: true
  * allowPrivilegeEscalation: false
  * privileged: false
* nodeSelector: {}

* enabled

## Usage

The recommended practice is the declarative approach:
you create your own Keptn values file that includes your customizations
then use your customized values file to install Keptn.
Alternatively, you can also set Helm values with `--set` during helm commands;
this is the imparative approach.
The --set flags take precendence over whatever you have configured in your *values.yaml* file
so can be used to temporarily override a value when necessary.

## Example

The **See also** section of this page references other pages in this documentation set
that contain annotated examples for accomplishing various tasks.

## Files

* Default [values.yaml](https://github.com/keptn/keptn/blob/master/helm-service/chart/values.yaml#L10) file: 

## Differences between versions


## See also

* [Install Keptn using the Helm chart](../../../../install/helm-install)
