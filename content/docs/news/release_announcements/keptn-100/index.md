---
title: Keptn 0.19.3
weight: 64
---

## [1.0.0](https://github.com/keptn/keptn/compare/0.19.0...1.0.0) (2022-12-12)

---

Keptn 1.0.0 is the first major release and the first LTS (Long Term Support) release of Keptn.
Keptn LTS version support is guaranteed for at least 6 months after the initial release. 
The Keptn community announces the LTS end-of-life within 3 months in advance, using the community announcement channel [#announcements](https://app.slack.com/client/TFHDUSPB7/CFH4VK9GT) over Slack.
For this, we introduced [scarf.sh](https://about.scarf.sh/) to track download data to decide whether the support of the LTS versions will be extended.

---

### ⚠ BREAKING CHANGES

* **installer:** We are introducing scarf.sh for download tracking to have valuable information that will help us decide whether support for Keptn LTS will be extended or not.
* **shipyard-controller:** Keptn returns 404 instead of 400 HTTP error code when creation of the project fails when upstream repository is not found. Also returns 409 instead of 500 HTTP error code when creation or update of project fails due to upstream repository is already initialized.

### Features

* **api:** Clean up logs/errors ([16b854c](https://github.com/keptn/keptn/commit/16b854c28ae8ed957f46deb25a5e40ea86658b65))
* **bridge:** Added autofocus to deletion dialog input field ([#9056](https://github.com/keptn/keptn/issues/9056)) ([a31c21d](https://github.com/keptn/keptn/commit/a31c21d4f1472618738c15d93299d3432ce0a4c1))
* **bridge:** Show full date on hover on sequence view ([#8997](https://github.com/keptn/keptn/issues/8997)) ([c7e425a](https://github.com/keptn/keptn/commit/c7e425a7a647fe13d78d5f8b335551f10d527d43))
* **bridge:** Unify logging ([#9166](https://github.com/keptn/keptn/issues/9166)) ([5669c0f](https://github.com/keptn/keptn/commit/5669c0f0f5e2121d3881d15766c0cc24a7b53c34))
* **cli:** Introduce `--data` option for `trigger sequence` command ([#8830](https://github.com/keptn/keptn/issues/8830)) ([50b602e](https://github.com/keptn/keptn/commit/50b602e2791f96764760728b122e685c1d600e76))
* **installer:** Add initcontainers to prevent installation errors ([#8775](https://github.com/keptn/keptn/issues/8775)) ([e2edea7](https://github.com/keptn/keptn/commit/e2edea71e6766e1a34424a42bd2edb7e1b13e42f))
* **installer:** Make bridge username configurable from helm values ([#9007](https://github.com/keptn/keptn/issues/9007)) ([b63473c](https://github.com/keptn/keptn/commit/b63473c19b5e7803d6b0b663a76be95f2b7aedbc))
* **installer:** Use scarf registry as default ([#9288](https://github.com/keptn/keptn/issues/9288)) ([4a7b9a6](https://github.com/keptn/keptn/commit/4a7b9a632d9fb62a3c0d0fb04ea0df5d8a9b493d))
* Introduce tolerations and affinities for helm charts ([#8858](https://github.com/keptn/keptn/issues/8858)) ([d7eb20a](https://github.com/keptn/keptn/commit/d7eb20a9fa9a216b876feaf3b58cbcd96d046c88))
* **resource-service:** Compute git auth method once per API request ([#8824](https://github.com/keptn/keptn/issues/8824)) ([2ebdc86](https://github.com/keptn/keptn/commit/2ebdc8613e3f0a1436ae597ce3f0e91dfb35e429))
* **resource-service:** Move history of previous upstream to new upstream ([#8906](https://github.com/keptn/keptn/issues/8906)) ([d24ace1](https://github.com/keptn/keptn/commit/d24ace1fa5d5e2e6c45dd04297ec75ff1e1351f2))
* **resource-service:** Use libgit2 as a fallback when cloning repo ([#9112](https://github.com/keptn/keptn/issues/9112)) ([e1ab96d](https://github.com/keptn/keptn/commit/e1ab96d16c8104f8782b04033a77a443408ba31b))
* **shipyard-controller:** Clean up logs/errors ([e42225c](https://github.com/keptn/keptn/commit/e42225ccb1a4ef276ac9e9acc0eebb0ef8fe5056))


### Bug Fixes

* [#8974](https://github.com/keptn/keptn/issues/8974) malformed struct tags ([#8975](https://github.com/keptn/keptn/issues/8975)) ([af885ac](https://github.com/keptn/keptn/commit/af885acb5edf1526c1705a4bae361e7fb54dd50d))
* Add `CD` optional to bridge installation type via helm ([#9022](https://github.com/keptn/keptn/issues/9022)) ([f140ed0](https://github.com/keptn/keptn/commit/f140ed07276f60697b14b5e185c0c1e6950850a1))
* **bridge:** Fix inconsistent sequence filter ([#9137](https://github.com/keptn/keptn/issues/9137)) ([1c5401d](https://github.com/keptn/keptn/commit/1c5401da46dc7b33ed4da750f1db82b50f314458))
* **bridge:** Fix incorrect relative change ([#9134](https://github.com/keptn/keptn/issues/9134)) ([391b3e1](https://github.com/keptn/keptn/commit/391b3e1b9b67b61538b1381728f963d906f7b1c3))
* **bridge:** Fix incorrect score-bar representation in evaluation ([#9202](https://github.com/keptn/keptn/issues/9202)) ([ed99f3b](https://github.com/keptn/keptn/commit/ed99f3b515086a5e7ab7e218b1280a7b35640b67))
* **bridge:** Fix incorrect SLI grouping in heatmap ([#9132](https://github.com/keptn/keptn/issues/9132)) ([3f8a652](https://github.com/keptn/keptn/commit/3f8a6528200d5e733ebdc926630638a2bf0fbcea))
* **bridge:** Fix invalid evaluation score status ([#9191](https://github.com/keptn/keptn/issues/9191)) ([44a51d7](https://github.com/keptn/keptn/commit/44a51d7afddd0c82c87d6379afbd9fc14b5a868c))
* **bridge:** Fix invalidate evaluation ([#9145](https://github.com/keptn/keptn/issues/9145)) ([12e345f](https://github.com/keptn/keptn/commit/12e345f7b9ff2c4e4da34262776a4bf8db945331))
* **bridge:** Fix missing update in project settings on project change ([#8983](https://github.com/keptn/keptn/issues/8983)) ([90d30a5](https://github.com/keptn/keptn/commit/90d30a543124b64d07dd6c5ed530936137632af0))
* **bridge:** Fix navigation to blocking sequence ([#9200](https://github.com/keptn/keptn/issues/9200)) ([f38e0fc](https://github.com/keptn/keptn/commit/f38e0fc0faa5b4ddb1d1ffa457ce160f0b64571e))
* **bridge:** Fix relative weight calculation ([#9099](https://github.com/keptn/keptn/issues/9099)) ([c9c2b02](https://github.com/keptn/keptn/commit/c9c2b02588cec780af2f425af69d7b54b6462f22))
* **bridge:** Show correct border color for task items in sequence view ([#9055](https://github.com/keptn/keptn/issues/9055)) ([ca181d5](https://github.com/keptn/keptn/commit/ca181d59dd976fff1e0d2a22877ddf2868a2d336))
* **cli:** Fix non deterministic processing of `trigger sequence --data` flag ([#9040](https://github.com/keptn/keptn/issues/9040)) ([4987bc3](https://github.com/keptn/keptn/commit/4987bc384612202569fdd2742004ec552c3d6305))
* **distributor:** Datarace range variable is captured in goroutine ([#8973](https://github.com/keptn/keptn/issues/8973)) ([0f80060](https://github.com/keptn/keptn/commit/0f800601ec2c6a2a30b8f229feea2561ccfab079))
* Indentation issue in Installer Modue ([#9301](https://github.com/keptn/keptn/issues/9301)) ([409bbab](https://github.com/keptn/keptn/commit/409bbab280a663d51307298648f7ed2d2dbe5cad))
* **installer:** Fix default helm value for Bridge use cases ([#9028](https://github.com/keptn/keptn/issues/9028)) ([e8b0320](https://github.com/keptn/keptn/commit/e8b03203d84986f40a77cc19191f79f2b06fadda))
* **installer:** Remove duplicate volumes and volumeMounts configuration ([#8949](https://github.com/keptn/keptn/issues/8949)) ([5f034c7](https://github.com/keptn/keptn/commit/5f034c700fa281260588f5ba41b6956e6f8fbebc))
* **lighthouse-service:** don't fail sequence if SLO file is missing ([#9153](https://github.com/keptn/keptn/issues/9153)) ([6b1f05f](https://github.com/keptn/keptn/commit/6b1f05fcf547a4863f5f1b76cef7dc9e37d2b920))
* **lighthouse-service:** fail with descriptive error message when SLO criteria and target cannot be parsed ([#9206](https://github.com/keptn/keptn/issues/9206)) ([56977a3](https://github.com/keptn/keptn/commit/56977a3ce1cbd2f5eda4de003a8356f404d641af))
* **lighthouse-service:** handling no SLO objectives ([#9203](https://github.com/keptn/keptn/issues/9203)) ([5626961](https://github.com/keptn/keptn/commit/56269619102da634e87816b13b8faca051040bc3))
* **lighthouse-service:** Include SLO Display Name also when there is no SLI value available ([#9194](https://github.com/keptn/keptn/issues/9194)) ([9ebed1e](https://github.com/keptn/keptn/commit/9ebed1efbc48d0a6b0725cb8884da462bdbda418))
* **lighthouse-service:** Return error if slo.yaml cannot be fetched from resource service ([#9143](https://github.com/keptn/keptn/issues/9143)) ([723ba6d](https://github.com/keptn/keptn/commit/723ba6d0f750a32210d7c7b2dcb7c2da00f56c58))
* Resolve security scan issues ([#9094](https://github.com/keptn/keptn/issues/9094)) ([d50bfde](https://github.com/keptn/keptn/commit/d50bfde5cb37ee26fecbdac5d508681f61c6be9a))
* **resource-service:** Delete tmp-origin before migrating repository ([#9104](https://github.com/keptn/keptn/issues/9104)) ([b3e368f](https://github.com/keptn/keptn/commit/b3e368fc2df93d8f25ff9a1f3f324586cb1c948f))
* **resource-service:** Delete tmp-origin before migrating repository ([#9106](https://github.com/keptn/keptn/issues/9106)) ([b3e368f](https://github.com/keptn/keptn/commit/b3e368fc2df93d8f25ff9a1f3f324586cb1c948f))
* **resource-service:** Determine default branch from helm value when repository is not initialized ([#8843](https://github.com/keptn/keptn/issues/8843)) ([8e91639](https://github.com/keptn/keptn/commit/8e916394247c957c9f029e651f6d345315b37979))
* **resource-service:** Force checkout event if unstaged changes are present ([#9107](https://github.com/keptn/keptn/issues/9107)) ([dbd0ddb](https://github.com/keptn/keptn/commit/dbd0ddba017001f4864a40b6a26cf867614ea1dc))
* **resource-service:** Map go-git specific error types to Keptn error types understood by the resource service error handler ([#8849](https://github.com/keptn/keptn/issues/8849)) ([75a1314](https://github.com/keptn/keptn/commit/75a1314c1fbfab6040346b98bfb8e13331a7c460))
* **resource-service:** Return specific error in when creating a project with an initialized repository ([#8855](https://github.com/keptn/keptn/issues/8855)) ([2f7e1f2](https://github.com/keptn/keptn/commit/2f7e1f273ab0df258fac3a493d4fde9947b86f18))
* **resource-service:** revert go-utils update made in PR ([#9159](https://github.com/keptn/keptn/issues/9159)) ([#9289](https://github.com/keptn/keptn/issues/9289)) ([530b255](https://github.com/keptn/keptn/commit/530b2559c0e19c3e97d4f5499d80251a4573fcc5))
* **resource-service:** Use go-git master version ([#9159](https://github.com/keptn/keptn/issues/9159)) ([3488c51](https://github.com/keptn/keptn/commit/3488c513f9ceafeb83658b12942b3eeedbfe3ba2))
* **shipyard-controller:** Adapt MongoDB query to be compatible with DocumentDB ([#8978](https://github.com/keptn/keptn/issues/8978)) ([baad639](https://github.com/keptn/keptn/commit/baad6396484e26b7cc2adf803772a83cb1fdfdd2))
* **shipyard-controller:** Adopt previous value of IsUpstreamAutoProvisioned when migrating project with old git credentials structure ([#8882](https://github.com/keptn/keptn/issues/8882)) ([f64441d](https://github.com/keptn/keptn/commit/f64441d9148fd1398fa187969c8e9d37649fb347))
* **shipyard-controller:** Avoid nil pointer when modifying project response ([#9188](https://github.com/keptn/keptn/issues/9188)) ([06ce70d](https://github.com/keptn/keptn/commit/06ce70d3c142aea84b62f9df10373c7c1a1803a7))
* **shipyard-controller:** Decode input payload strictly when creating or updating project ([#9101](https://github.com/keptn/keptn/issues/9101)) ([5d9f64b](https://github.com/keptn/keptn/commit/5d9f64bf4a5cd0aae7dfd5662ca3b00e5957445f))
* **shipyard-controller:** Do not validate gitCredentials when not set during project update ([#8935](https://github.com/keptn/keptn/issues/8935)) ([5d10345](https://github.com/keptn/keptn/commit/5d10345eccb1ba5ddf3f5e0c1c546c23b254cdc9))
* **shipyard-controller:** Fixed NilPointerExeption due to typo in SequenceDispatcher ([#9080](https://github.com/keptn/keptn/issues/9080)) ([cb7e9f6](https://github.com/keptn/keptn/commit/cb7e9f6f968d072d2de6a5354c2591568eee91af))
* **shipyard-controller:** Handle http error response range when provisioning GIT repository ([3054eb6](https://github.com/keptn/keptn/commit/3054eb627028ae74a4854382cfeb4e105ccc0549))
* **shipyard-controller:** Handle HTTP error response range when provisioning GIT repository ([#9047](https://github.com/keptn/keptn/issues/9047)) ([3054eb6](https://github.com/keptn/keptn/commit/3054eb627028ae74a4854382cfeb4e105ccc0549))
* **shipyard-controller:** prevent storing empty ssh private key after update ([#8959](https://github.com/keptn/keptn/issues/8959)) ([3211707](https://github.com/keptn/keptn/commit/32117074f3b9f106036a07896887613150fd5c2a))
* **shipyard-controller:** provide Git provisioning error information ([#9204](https://github.com/keptn/keptn/issues/9204)) ([eab3950](https://github.com/keptn/keptn/commit/eab3950dd9762ea19e368d505855d6a9d517e71f))
* **shipyard-controller:** Return 4xx error responses for upstream repository problems ([#9116](https://github.com/keptn/keptn/issues/9116)) ([75ba370](https://github.com/keptn/keptn/commit/75ba37051b3ddb247bf4a78ac318a74c7087ffba))
* **shipyard-controller:** Set headers only if request was successfully created ([#9279](https://github.com/keptn/keptn/issues/9279)) ([2c17ea3](https://github.com/keptn/keptn/commit/2c17ea3c7cc1b30cff273cd09f9e27f307aaa48b))
* Typo in script ([#9121](https://github.com/keptn/keptn/issues/9121)) ([719ae38](https://github.com/keptn/keptn/commit/719ae38babc26690681b0fcb05d520b5c63e962e))
* **webhook-service:** RAdd warning for malformed configuration ([#8841](https://github.com/keptn/keptn/issues/8841)) ([6a432b2](https://github.com/keptn/keptn/commit/6a432b2d331659544755b3a10c33fc73f604507a))


### Docs

* Add info about auto-signoff ([#9105](https://github.com/keptn/keptn/issues/9105)) ([e6da87b](https://github.com/keptn/keptn/commit/e6da87b11e1f324d487e8eef19f001cc88ab7941))


### Refactoring

* **bridge:** Unify initial data retrieval ([#9173](https://github.com/keptn/keptn/issues/9173)) ([6180974](https://github.com/keptn/keptn/commit/6180974106283f75df887c81b0d54f600c6742cd))


### Other

* Add [@aepfli](https://github.com/aepfli) as member (keptn/community[#207](https://github.com/keptn/keptn/issues/207)) ([#9150](https://github.com/keptn/keptn/issues/9150)) ([0a0d423](https://github.com/keptn/keptn/commit/0a0d4235e0d9ca229ecff7159e1e5d654e49f9a0))
* Add [@bradmccoydev](https://github.com/bradmccoydev) as maintainer ([#9061](https://github.com/keptn/keptn/issues/9061)) ([ba87256](https://github.com/keptn/keptn/commit/ba872568a37acc61c77d76bdb07d2393c7a4c8ed))
* Add @DavidPHirsch as maintainer ([#9088](https://github.com/keptn/keptn/issues/9088)) ([d50ad6c](https://github.com/keptn/keptn/commit/d50ad6cc00254ebc32e1b2bb9269f5e69929ba19))
* Add @DavidPHirsch as member ([#8741](https://github.com/keptn/keptn/issues/8741)) ([1c7536f](https://github.com/keptn/keptn/commit/1c7536f86c0f83f31af52e9ad040574e2d53dc57))
* add @TannerGilbert to Bridge Code Owners ([#9219](https://github.com/keptn/keptn/issues/9219)) ([1fdf66f](https://github.com/keptn/keptn/commit/1fdf66f223735be04312fbb839e8a5bfdf2ab97a))
* add bradmccoydev as maintainer ([ba87256](https://github.com/keptn/keptn/commit/ba872568a37acc61c77d76bdb07d2393c7a4c8ed))
* Add heinzburgstaller as Bridge codeowner ([#9139](https://github.com/keptn/keptn/issues/9139)) ([ab0f76c](https://github.com/keptn/keptn/commit/ab0f76cbd43337fb7b8fe02d023e73aa95e24c3d))
* **api:** Clean up logs/errors ([#9168](https://github.com/keptn/keptn/issues/9168)) ([16b854c](https://github.com/keptn/keptn/commit/16b854c28ae8ed957f46deb25a5e40ea86658b65))
* **approval-service:** Clean up logs ([#9171](https://github.com/keptn/keptn/issues/9171)) ([5754401](https://github.com/keptn/keptn/commit/5754401580c7c141763a83ba039f82c8e335accb))
* **bridge:** Improve Bridge logging levels and messages ([#9183](https://github.com/keptn/keptn/issues/9183)) ([9a8bf0a](https://github.com/keptn/keptn/commit/9a8bf0a17545a64bd4654d54f88fe44f93ac04ce))
* **bridge:** Remove Highcharts ([#8922](https://github.com/keptn/keptn/issues/8922)) ([0538276](https://github.com/keptn/keptn/commit/05382762340fe7b056df3e31ac4f83ae3d7087ab))
* **deps:** bump minimatch from 3.0.4 to 3.1.2 in /bridge/server ([#9184](https://github.com/keptn/keptn/issues/9184)) ([d6de224](https://github.com/keptn/keptn/commit/d6de224776710b7b18236a83f1b7c8a782a9f613))
* Fix dependencies with go mod tidy ([e71a566](https://github.com/keptn/keptn/commit/e71a566de2060c25249bc6242619bdf46012f55b))
* github handle in MAINTAINERS ([#9179](https://github.com/keptn/keptn/issues/9179)) ([9293680](https://github.com/keptn/keptn/commit/929368046b017691702f31ba11a6ddf003ae4a18))
* Improve Shipyard Controller logs when deleting subscription or integration ([#9019](https://github.com/keptn/keptn/issues/9019)) ([6403418](https://github.com/keptn/keptn/commit/64034184dfdd637e111545a7c9cc881f8f30f958))
* **installer:** Adapt resource limits ([#8840](https://github.com/keptn/keptn/issues/8840)) ([e741bbe](https://github.com/keptn/keptn/commit/e741bbe93150ab3df936e2324f6f716947085c59))
* **installer:** Improve resource limits/requests ([#8862](https://github.com/keptn/keptn/issues/8862)) ([a37aa40](https://github.com/keptn/keptn/commit/a37aa40f45ed5c5c7d10e2d7863fcbecda3d08bd))
* **lighthouse-service:** Clean up logs ([#9169](https://github.com/keptn/keptn/issues/9169)) ([1869fea](https://github.com/keptn/keptn/commit/1869fea07447e4f339906067813ead168066c570))
* **mongodb-datastore:** Clean up logs ([#9170](https://github.com/keptn/keptn/issues/9170)) ([08eb880](https://github.com/keptn/keptn/commit/08eb8806c4bc641e52bdce2aa1f5265500099b15))
* **resource-service:** Clean up logs ([#9172](https://github.com/keptn/keptn/issues/9172)) ([b5e21b0](https://github.com/keptn/keptn/commit/b5e21b0d065b53041bea7a7e5ab0868617cfbf8e))
* **secret-service:** Clean up logs ([#9175](https://github.com/keptn/keptn/issues/9175)) ([bd1da49](https://github.com/keptn/keptn/commit/bd1da4937752f50ac46080f47e7e54b8e55fb613))
* **shipyard-controller:** Clean up logs/errors ([#9167](https://github.com/keptn/keptn/issues/9167)) ([e42225c](https://github.com/keptn/keptn/commit/e42225ccb1a4ef276ac9e9acc0eebb0ef8fe5056))
* Suggestion on making lifecycle toolkit more prominent ([#9129](https://github.com/keptn/keptn/issues/9129)) ([cb68fc3](https://github.com/keptn/keptn/commit/cb68fc3f772ea047cde3cd216056b8757cedd544))
* Update MongoDB from 12.1.31 to 13.3.1 ([#9158](https://github.com/keptn/keptn/issues/9158)) ([d94e97c](https://github.com/keptn/keptn/commit/d94e97ca4f7ec44a1c69a104d3381fdddfda0bd6))
* **webhook-service:** Clean up logs ([#9176](https://github.com/keptn/keptn/issues/9176)) ([141dadd](https://github.com/keptn/keptn/commit/141daddd9a5955d7a81ad990cc98b1dc2ffb1f3b))
