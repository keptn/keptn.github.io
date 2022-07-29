---
title: Keptn 0.18.0
weight: 69
---

# Release Notes [0.18.0](https://github.com/keptn/keptn/compare/0.17.0...0.18.0) (2022-07-28)

---

**Key announcements**:

:information_source: *CLI*: The CLI no longer provides the install/uninstall/upgrade commands. Please refer to the [Install Keptn using the Helm chart](../../../install/helm-install/) to see how you can use Helm to install and operate Keptn.

:mailbox: *WebHooks* support the new `v1beta1` version which provides a more structured way to create your webhooks. For futher information, see [Advanced Webhook configuration](../../../0.18.x/integrations/webhooks/#advanced-webhook-configuration).

:star: *Bridge* support lazy loading to provide a faster response time.

:sparkles: *(experimental) New Import API*: Keptn provides a new _alpha_ version of an import API. This API can be used to setup a Keptn project by importing a template as zip archive.

:hammer: Keptn provides the ability to enable / disable "use-case" services in the control plane chart.

---


### ⚠ BREAKING CHANGES

* **cli:** The install/uninstall/upgrade commands are not available anymore. Please use Helm to [operate Keptn](https://keptn.sh/docs/install/helm-install/).
* **resource-service:** Trailing `/` chars in the resource APIs will return a 404. This way, the difference between an empty URI and getting all the resources is explicit.
* All Keptn core services depend on resource-service. From this moment on, the configuration-service is deprecated.

### Features

* **api:** Add create-secret api action to import endpoint ([#8348](https://github.com/keptn/keptn/issues/8348)) ([df9c42b](https://github.com/keptn/keptn/commit/df9c42b2463f3ded77a1f0eb742ddd0e68c7d7d3))
* **api:** Import Endpoint - Implement create webhook subscription action ([73133f0](https://github.com/keptn/keptn/commit/73133f04eb933d2117a18704c9b188cabc59dc08))
* **api:** Import Endpoint - Import package manifest templating ([96035b9](https://github.com/keptn/keptn/commit/96035b9e0218e1678d8f31d1bb52c6a2044ae057))
* **api:** Import Endpoint - Process import package manifest and execute API tasks ([74744aa](https://github.com/keptn/keptn/commit/74744aa7d6fc60f187d7065ba135a9ad36da8892))
* **api:** Import Endpoint - Support simple templating for resource and api tasks in import manifests ([#8456](https://github.com/keptn/keptn/issues/8456)) ([02fd6d5](https://github.com/keptn/keptn/commit/02fd6d520946edbce8890df6b2367f533309b1a6))
* **api:** Import Endpoint - Upload resources from import package ([67339ea](https://github.com/keptn/keptn/commit/67339ea85f12978a820295b5d7bd14f177893ae7))
* **bridge:** Add ktb-chart ([#8420](https://github.com/keptn/keptn/issues/8420)) ([9d55c35](https://github.com/keptn/keptn/commit/9d55c352ebc3394c00d70bd63a0c672462a8be6b))
* **bridge:** Modularize dashboard view and introduce lazy loading ([#8315](https://github.com/keptn/keptn/issues/8315)) ([a6326ca](https://github.com/keptn/keptn/commit/a6326ca66b70e63802b66d6f4a6ce8915d05bc1c))
* **bridge:** Modularize environment view and introduce lazy loading ([#8313](https://github.com/keptn/keptn/issues/8313)) ([4c1ad1a](https://github.com/keptn/keptn/commit/4c1ad1a6c9f188a8cc3d79de941fcd92a580c9f7))
* **bridge:** Modularize evaluation-board and introduce lazy loading ([#8340](https://github.com/keptn/keptn/issues/8340)) ([60309c5](https://github.com/keptn/keptn/commit/60309c5867748c1281b75951dd090c37055ad6c7))
* **bridge:** Modularize integration and common use case views and introduce lazy loading ([#8305](https://github.com/keptn/keptn/issues/8305)) ([609602a](https://github.com/keptn/keptn/commit/609602a636adb19865c4b18b3b55a472f00707a4))
* **bridge:** Modularize project board and introduce lazy loading ([#8342](https://github.com/keptn/keptn/issues/8342)) ([63d61fb](https://github.com/keptn/keptn/commit/63d61fb35e084e4e31a72b1c1440582cc2188430))
* **bridge:** Modularize sequence and logout view and introduce lazy loading ([#8289](https://github.com/keptn/keptn/issues/8289)) ([6cc2e2c](https://github.com/keptn/keptn/commit/6cc2e2c2c88cff5a02a80ecaa6202ff2101e1098))
* **bridge:** Modularize services view and introduce lazy loading ([#8325](https://github.com/keptn/keptn/issues/8325)) ([e1f18d4](https://github.com/keptn/keptn/commit/e1f18d4eafaf4055f1b0bc180e5bb9d545ced27c))
* **bridge:** Modularize settings view ([#8397](https://github.com/keptn/keptn/issues/8397)) ([4373f21](https://github.com/keptn/keptn/commit/4373f21edc4d8c2382c21ddefc4566643bf16e5e))
* **bridge:** Preselect date for datetime picker ([#8450](https://github.com/keptn/keptn/issues/8450)) ([2817781](https://github.com/keptn/keptn/commit/2817781cb7bf885f15c02cc8c0c0a63d1326e880))
* **bridge:** Select project stage from project overview ([#7736](https://github.com/keptn/keptn/issues/7736)) ([e05415c](https://github.com/keptn/keptn/commit/e05415c64e40444f42aec1beacb482170052d2f3))
* **bridge:** Show pause icon if sequence is paused ([#8471](https://github.com/keptn/keptn/issues/8471)) ([6b2669b](https://github.com/keptn/keptn/commit/6b2669bf81097477ad431aeb2589b92e42321337))
* **bridge:** Show user info for OAuth "Insufficient permission" error message ([#8403](https://github.com/keptn/keptn/issues/8403)) ([b2afdf9](https://github.com/keptn/keptn/commit/b2afdf9d9ecb687fca52a7852c15ecf90741bea8))
* **cli:** Introduce WebhookConfig migrator ([#8396](https://github.com/keptn/keptn/issues/8396)) ([917e056](https://github.com/keptn/keptn/commit/917e056f28228de99cd3e927a562771acd194296))
* **cli:** Removed install/uninstall/upgrade commands ([#8302](https://github.com/keptn/keptn/issues/8302)) ([bb8015c](https://github.com/keptn/keptn/commit/bb8015ca9bbe2fdca847b09458d36dd587ae4524))
* **installer:** Add options for setting image repository and tag globally ([#8152](https://github.com/keptn/keptn/issues/8152)) ([100eae9](https://github.com/keptn/keptn/commit/100eae9680b4e96b6404c68bb3a66c4a33d2f9da))
* **installer:** Enable clustered NATS ([#8464](https://github.com/keptn/keptn/issues/8464)) ([3c1ae2b](https://github.com/keptn/keptn/commit/3c1ae2b0a2c3cf4130aab80e76265bc1fc9f6431))
* **installer:** Introduce flags to enable / disable Keptn services ([#8316](https://github.com/keptn/keptn/issues/8316)) ([6ccc7b1](https://github.com/keptn/keptn/commit/6ccc7b1fcead29f5c67b3a81f79b35e1ed9b29cd))
* **installer:** More Security Improvements for NATS ([#8421](https://github.com/keptn/keptn/issues/8421)) ([42e9fad](https://github.com/keptn/keptn/commit/42e9fadefe5b70fed8e07623713ff590c25e723e))
* **installer:** Remove configuration-service references and resourceService.enabled option ([#8296](https://github.com/keptn/keptn/issues/8296)) ([8d8eb99](https://github.com/keptn/keptn/commit/8d8eb99f14c035e86007dce9241ca820e7068921))
* **installer:** Security Improvements ([#8373](https://github.com/keptn/keptn/issues/8373)) ([d946f67](https://github.com/keptn/keptn/commit/d946f67af3827cad0c46beabbffaf39a669d98bc))
* **shipyard-controller:** Introduce API Endpoint for retrieving Sequence Executions ([#8430](https://github.com/keptn/keptn/issues/8430)) ([ac326c7](https://github.com/keptn/keptn/commit/ac326c780b2886a35588b8d1c1869e418ba566b8))
* **shipyard-controller:** Introduce RemoteURL denyList ([#8490](https://github.com/keptn/keptn/issues/8490)) ([6db8f3d](https://github.com/keptn/keptn/commit/6db8f3db00944eb80c94fac92c1d62e9ae9dc551))


### Bug Fixes

* **bridge:** Added missing wait to view more services ui test ([#8320](https://github.com/keptn/keptn/issues/8320)) ([f2bce6b](https://github.com/keptn/keptn/commit/f2bce6b1665fd67b107193890da0794241796ea5))
* **bridge:** Check if configurationChange has image ([#8507](https://github.com/keptn/keptn/issues/8507)) ([16ec462](https://github.com/keptn/keptn/commit/16ec46205361c8b130a6c947e8a20b062d1e75e0))
* **bridge:** Evaluation info misleading if failed because of key sli ([#8250](https://github.com/keptn/keptn/issues/8250)) ([a5d79d0](https://github.com/keptn/keptn/commit/a5d79d03b5d526033d73395a3fc708846b1c21c3))
* **bridge:** Fix detection of pending changes when automatic provisioning active ([#8531](https://github.com/keptn/keptn/issues/8531)) ([0d4c7d2](https://github.com/keptn/keptn/commit/0d4c7d28329cafcf69f3063ec5d72e47638b2505))
* **bridge:** Fix error on viewing service deployment ([#8332](https://github.com/keptn/keptn/issues/8332)) ([9e9f776](https://github.com/keptn/keptn/commit/9e9f7769daaea303310ad7a76ab8dc880de6e6fa))
* **bridge:** Fix evaluation badge wrapping ([#8524](https://github.com/keptn/keptn/issues/8524)) ([d8f75ea](https://github.com/keptn/keptn/commit/d8f75ea2ca217a0f90dbb45bec498039e8b4f1fc))
* **bridge:** Fix incorrect API URL for auth command ([#8386](https://github.com/keptn/keptn/issues/8386)) ([9ea6132](https://github.com/keptn/keptn/commit/9ea613270e159faae3c9059c42decab50b4cae14))
* **bridge:** Navigating to service from stage-details ([#8399](https://github.com/keptn/keptn/issues/8399)) ([e0ce5bd](https://github.com/keptn/keptn/commit/e0ce5bde8d73437aa1bd1bd92a1c435316ce58a9))
* **cli:** Fix broken xref in CLI command reference docs ([#8374](https://github.com/keptn/keptn/issues/8374)) ([cb92bf5](https://github.com/keptn/keptn/commit/cb92bf530757ebac76a7382de8948b01fb51934a))
* **cli:** Print ID of Keptn context after sending events ([#8392](https://github.com/keptn/keptn/issues/8392)) ([65ce578](https://github.com/keptn/keptn/commit/65ce57807ed557ef97067ee9ef075690a2b515c8))
* **installer:** Disable nats cluster due to unreliable behavior ([#8523](https://github.com/keptn/keptn/issues/8523)) ([36cdb07](https://github.com/keptn/keptn/commit/36cdb0735d0b9338664d5c1768e5a9c845276ff7))
* **installer:** Fix NATS clustering settings ([#8484](https://github.com/keptn/keptn/issues/8484)) ([af15cbe](https://github.com/keptn/keptn/commit/af15cbe6902ac4730f8404618dcc97e3677c2ba1))
* **installer:** Fix Nginx not starting when statistics service is disabled ([#8326](https://github.com/keptn/keptn/issues/8326)) ([cde5942](https://github.com/keptn/keptn/commit/cde5942a070f54ba0c373a715acc847649371f02))
* **installer:** Remove configuration service from airgapped installer scripts ([#8376](https://github.com/keptn/keptn/issues/8376)) ([772ebd6](https://github.com/keptn/keptn/commit/772ebd612f9719eec5944c07e718b12e804aae07))
* **installer:** RoleBinding is not installed if not needed for shippy leader election ([#8535](https://github.com/keptn/keptn/issues/8535)) ([e90e94b](https://github.com/keptn/keptn/commit/e90e94bafd456879ff4389e5ae4cd2e9a0ba06df))
* **resource-service:** Return 404 with trailing slashes ([#8265](https://github.com/keptn/keptn/issues/8265)) ([785a39c](https://github.com/keptn/keptn/commit/785a39c60a2056d37fc7c02ff52151a375916e95))
* **resource-service:** Unescape resourceURI before updating single resource ([#8441](https://github.com/keptn/keptn/issues/8441)) ([a73af9e](https://github.com/keptn/keptn/commit/a73af9e2b3db856fdd47777a08ed27e06f85283c))
* **shipyard-controller:** Handling error messages ([#8480](https://github.com/keptn/keptn/issues/8480)) ([dbcb214](https://github.com/keptn/keptn/commit/dbcb214a7fd8efbd191161659739102c1f6dd8ad))
* **webhook-service:** Do not respond to anything else than .triggered event on pre execution error ([#8337](https://github.com/keptn/keptn/issues/8337)) ([4430a13](https://github.com/keptn/keptn/commit/4430a13184e5d4a98eda089e642e587434323492))
* **webhook-service:** Typo in component tests ([#8409](https://github.com/keptn/keptn/issues/8409)) ([7d77b7d](https://github.com/keptn/keptn/commit/7d77b7dbea3f24e642c1146f75902c0e44db687a))
* Zero Downtime test for the webhook-service ([#8408](https://github.com/keptn/keptn/issues/8408)) ([9212fb2](https://github.com/keptn/keptn/commit/9212fb29f07dd877e58b6c9db9e55a69354d453b))


### Docs

* **cli:** Fix typo in create secret command ([#8498](https://github.com/keptn/keptn/issues/8498)) ([36d373f](https://github.com/keptn/keptn/commit/36d373f0516bab7d07ee17208b282b380e484571))
* Fix instructions to install master ([#8429](https://github.com/keptn/keptn/issues/8429)) ([ac943cc](https://github.com/keptn/keptn/commit/ac943cc14c8f05296177fe603c8563e3ff6505df))


### Refactoring

* **bridge:** Refactor project settings ([#8510](https://github.com/keptn/keptn/issues/8510)) ([f10880b](https://github.com/keptn/keptn/commit/f10880bb4a1318aa5f90946e05fdeb7dcc429c9d))
* **bridge:** Refactor secrets page ([#8300](https://github.com/keptn/keptn/issues/8300)) ([66b1dfc](https://github.com/keptn/keptn/commit/66b1dfcdf658c74afaa53c8e32ab343b563f1dd5))
* **bridge:** Refactor the project settings of services ([#8323](https://github.com/keptn/keptn/issues/8323)) ([7bb4122](https://github.com/keptn/keptn/commit/7bb412215d77d6f1f5c1d66adf55f74f26cb1e5f))
* **bridge:** Remove global project polling and remove project dependency in integrations view ([#8412](https://github.com/keptn/keptn/issues/8412)) ([c4845c9](https://github.com/keptn/keptn/commit/c4845c9b568351ab2c93320095d4f061584b7463))
* **bridge:** Rename D3 feature flag ([#8499](https://github.com/keptn/keptn/issues/8499)) ([6a389df](https://github.com/keptn/keptn/commit/6a389df6d44ff561c11d72dc727b49247b5ad9da))
* Refactor all services to use resource-service ([#8271](https://github.com/keptn/keptn/issues/8271)) ([f866d09](https://github.com/keptn/keptn/commit/f866d094a7eba76306e31c7e12d9bf80aa9ae046))


### Other

*  Added new component test in remediation service ([#8343](https://github.com/keptn/keptn/issues/8343)) ([a0c22f9](https://github.com/keptn/keptn/commit/a0c22f9c950176c54e2e25d2183bff8e39b38181))
*  Fix dev repo registry in zd test ([#8411](https://github.com/keptn/keptn/issues/8411)) ([1d17283](https://github.com/keptn/keptn/commit/1d17283ab1db21e8d79b23402de9973c9aac0794))
* Add helm dependencies directly to repository charts ([#8472](https://github.com/keptn/keptn/issues/8472)) ([e6669a4](https://github.com/keptn/keptn/commit/e6669a49ce43ff6d65afcf622a4f78e8eb0dcf47))
* Added repo to resource-service.yaml ([#8382](https://github.com/keptn/keptn/issues/8382)) ([d70d82d](https://github.com/keptn/keptn/commit/d70d82d39fc42d6530bd23ee1726bad9b573a584))
* Added timeout to keptn install ([#8383](https://github.com/keptn/keptn/issues/8383)) ([e2837bb](https://github.com/keptn/keptn/commit/e2837bb62d8ca72ee641f5a006ae17cf950f2293))
* **bridge:** Enable resource-service by default ([#8432](https://github.com/keptn/keptn/issues/8432)) ([40d75d1](https://github.com/keptn/keptn/commit/40d75d1a0ee4a93ab0c44d67c133137ee3fa8479))
* **bridge:** Fix Sonar issues ([#8384](https://github.com/keptn/keptn/issues/8384)) ([b389f67](https://github.com/keptn/keptn/commit/b389f67e9c70b260e36fbd16811ee712aa1035f0))
* **bridge:** Fix Sonar issues part 2 ([#8398](https://github.com/keptn/keptn/issues/8398)) ([ce80143](https://github.com/keptn/keptn/commit/ce8014361af1eb7fc54027f026529e1dd01b2adb))
* **bridge:** Generalization of showing a running sequence ([#8379](https://github.com/keptn/keptn/issues/8379)) ([73e4634](https://github.com/keptn/keptn/commit/73e4634f33a9849e68c868a9240f669e808ecbfc))
* **bridge:** Remove loading of integrations on common-use-case page ([#8344](https://github.com/keptn/keptn/issues/8344)) ([77560f5](https://github.com/keptn/keptn/commit/77560f5a61e802fabb94e0b9d48a31f4db050386))
* **bridge:** Remove no Git upstream is set warning ([#8447](https://github.com/keptn/keptn/issues/8447)) ([ab35607](https://github.com/keptn/keptn/commit/ab356077803b8b9e67a54bc393bcd97128090b0b))
* **bridge:** Remove second labels tag list for remediation sequences ([#8410](https://github.com/keptn/keptn/issues/8410)) ([5bb977e](https://github.com/keptn/keptn/commit/5bb977e281f9b027ba1a0ce627534a2dd50041d0))
* **bridge:** Remove unused service page env var ([#8356](https://github.com/keptn/keptn/issues/8356)) ([7098fdb](https://github.com/keptn/keptn/commit/7098fdba69079e0eb1c36ca0db047e8bc8ae3152))
* **bridge:** Removed obsolete common use cases page ([#8419](https://github.com/keptn/keptn/issues/8419)) ([98e477b](https://github.com/keptn/keptn/commit/98e477b4c276a92033fef6d5f3867e174583f4ec))
* **cli:** Remove warning that no Git upstream is set ([#8518](https://github.com/keptn/keptn/issues/8518)) ([ff49bad](https://github.com/keptn/keptn/commit/ff49bad611f1ed165373b907d14699a78be79501))
* Fix ZeroDowntime registry ([#8434](https://github.com/keptn/keptn/issues/8434)) ([c89506d](https://github.com/keptn/keptn/commit/c89506d088f9b5244955dfa1a721f3a5b81f2a7a))
* Increased coverage for remediation-service ([#8357](https://github.com/keptn/keptn/issues/8357)) ([867d947](https://github.com/keptn/keptn/commit/867d947728ec3399885b54f7880dfd73e880fbd3))
* **installer:** Improve NATS configuration ([#8475](https://github.com/keptn/keptn/issues/8475)) ([0c8a964](https://github.com/keptn/keptn/commit/0c8a964f6bdc038aa0698c7ccc31c911da1cf9db))
* Remove go mod files of configuration service ([#8341](https://github.com/keptn/keptn/issues/8341)) ([1c74388](https://github.com/keptn/keptn/commit/1c743885a14c935d11ce6a015b12b793359c5bd5))
* Remove reference to removed test ([#8369](https://github.com/keptn/keptn/issues/8369)) ([03aec7b](https://github.com/keptn/keptn/commit/03aec7b3698540c1a0cdfc73304d0dd53a0db7b8))
* Removed configuration-service module ([#8294](https://github.com/keptn/keptn/issues/8294)) ([bd3c9af](https://github.com/keptn/keptn/commit/bd3c9af302af6b9523c77d738f6fecca51264136))
* Removed redundant integration tests ([#8324](https://github.com/keptn/keptn/issues/8324)) ([44764cd](https://github.com/keptn/keptn/commit/44764cd784479341bac0c0fac67e7c811bb06d5d))
* **shipyard-controller:** Add extra debug logging to the Git Automatic Provisioner call ([#8440](https://github.com/keptn/keptn/issues/8440)) ([cc9a212](https://github.com/keptn/keptn/commit/cc9a212970034a108314709c11b67dc62bbc72a5))
* **webhook-service:** Slimmed down integration tests for webhook service ([#8339](https://github.com/keptn/keptn/issues/8339)) ([7a01bd0](https://github.com/keptn/keptn/commit/7a01bd0fcbd410c47810adb4d0b5876a5b9e5fe6))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                | Container Name      | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| ------------------- | ------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo         | mongodb             | 200m        | 1000m     | 100Mi       | 500Mi     | docker.io/bitnami/mongodb:4.4.13-debian-10-r52      |
| api-gateway-nginx   | api-gateway-nginx   | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.22.0-alpine |
| api-service         | api-service         | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.18.0                          |
| approval-service    | approval-service    | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.18.0             |
| bridge              | bridge              | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.18.0                      |
| lighthouse-service  | lighthouse-service  | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.18.0           |
| mongodb-datastore   | mongodb-datastore   | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.18.0            |
| remediation-service | remediation-service | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.18.0          |
| resource-service    | resource-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/resource-service:0.18.0             |
| secret-service      | secret-service      | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.18.0               |
| shipyard-controller | shipyard-controller | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.18.0          |
| statistics-service  | statistics-service  | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.18.0           |
| statistics-service  | distributor         | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.18.0                  |
| webhook-service     | webhook-service     | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.18.0              |
| keptn-nats          | nats                | 200m        | 500m      | 500Mi       | 1Gi       | nats:2.8.4-alpine                                   |

</details>
