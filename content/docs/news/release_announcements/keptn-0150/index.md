---
title: Keptn 0.15.0
weight: 73
---

Keptn 0.15.0 improves Keptn core services to be closer to Zero Downtime upgrades.
For this, Keptn introduces `cp-connector`, a library that will replace the Distributor in all Keptn core services.
Since Keptn will require an upstream in future versions, a new Git Provisioning API is introduced.
This provides an extension point to create Git repositories on demand when a new projects are created. For further information, please refer to the [documentation](../../../../docs/0.15.x/api/git_provisioning/).
Furthermore, Keptn operators can provide a deny list for webhook URLs via a `ConfigMap`, please check out the [documentation](../../../0.15.x/operate/webhook_service/).
Finally, the CLI offers support for Datadog as an SLI provider.

---


## [0.15.0](https://github.com/keptn/keptn/compare/0.14.0...0.15.0) (2022-05-06)


### ⚠ BREAKING CHANGES

* **cli:** Removed `send event new-artifact` command
* **cli:** Removed `--tag` option from trigger delivery command
* Update go-utils to a version without GitCommit in the finished events

### Features

* Add `datadog` flag to `keptn configure monitoring` ([#7285](https://github.com/keptn/keptn/issues/7285)) ([bfcb352](https://github.com/keptn/keptn/commit/bfcb3524d5d0a6e32085196dca4458d5e1fef1f0))
* **bridge:** Configure Git upstream via SSH/HTTPS ([#7330](https://github.com/keptn/keptn/issues/7330)) ([0aaeded](https://github.com/keptn/keptn/commit/0aaededa6057f09e28dd4f6b0b90e2f9cb3dcec5))
* **bridge:** Consider real waiting state for sequences ([#7399](https://github.com/keptn/keptn/issues/7399)) ([f8a5bf0](https://github.com/keptn/keptn/commit/f8a5bf0cb2157d838155aaa2ed9fbfa136cb59e5))
* **bridge:** Create styled loading indicator component ([3c91f7d](https://github.com/keptn/keptn/commit/3c91f7d4c889aca5a4902f3fa9256cd2c4ce3f24)), closes [#5568](https://github.com/keptn/keptn/issues/5568)
* **bridge:** Custom sequence depends on selected stage ([#7463](https://github.com/keptn/keptn/issues/7463)) ([577b8f1](https://github.com/keptn/keptn/commit/577b8f1c31ab96051b06ad253dc891a581956ba7))
* **bridge:** Format trigger sequence date with `YYYY-MM-DD HH:mm:ss` ([#7522](https://github.com/keptn/keptn/issues/7522)) ([096c7a1](https://github.com/keptn/keptn/commit/096c7a161c93924371a9e82af27e9facf9263617))
* **bridge:** OAUTH error handling polished ([#7397](https://github.com/keptn/keptn/issues/7397)) ([0b89a37](https://github.com/keptn/keptn/commit/0b89a37de7996fcac30bc69de717a8b0e7bea13a))
* **bridge:** Open project in new tab ([#7629](https://github.com/keptn/keptn/issues/7629)) ([ba102d5](https://github.com/keptn/keptn/commit/ba102d551e219c6de23a29ac6922c6c3eab0fa9d))
* **bridge:** Show service and time stamp on sequence details page ([#7283](https://github.com/keptn/keptn/issues/7283)) ([d03ab0c](https://github.com/keptn/keptn/commit/d03ab0c78426d201c0df3bb3769c5bb598cb52ad))
* **bridge:** Stop event propagation when clicking on external link ([#7632](https://github.com/keptn/keptn/issues/7632)) ([e93ba8b](https://github.com/keptn/keptn/commit/e93ba8b31e6c5edf5141a54ea5c492a60cfe25cc))
* **bridge:** Unify loading indicators ([#5568](https://github.com/keptn/keptn/issues/5568)) ([#7527](https://github.com/keptn/keptn/issues/7527)) ([b90ac83](https://github.com/keptn/keptn/commit/b90ac831ba39e410325e2482e7ef6f071d6b5ac2))
* Configure terminationGracePeriod, preStop hooks and upgrade strategy for core deployments ([#7466](https://github.com/keptn/keptn/issues/7466)) ([44dbbe1](https://github.com/keptn/keptn/commit/44dbbe17f2a14a8f779eb0463972761b7c77d920))
* **cp-connector:** Added `FixedSubscriptionSource` ([#7528](https://github.com/keptn/keptn/issues/7528)) ([1bfaa27](https://github.com/keptn/keptn/commit/1bfaa2752f62a42351ee94940a02447ee3a590ab))
* **cp-connector:** Forward subscription id to event receiver ([#7655](https://github.com/keptn/keptn/issues/7655)) ([b88db17](https://github.com/keptn/keptn/commit/b88db17d2ead797b42aca2a5b50b8b2ada9bebce))
* Initial implementation of `cp-connector` library ([#7418](https://github.com/keptn/keptn/issues/7418)) ([367e859](https://github.com/keptn/keptn/commit/367e8592633262268c7a7096e7bbf778e5918595))
* **installer:** Add option to define nodeSelector globally or per service ([#7336](https://github.com/keptn/keptn/issues/7336)) ([8b257fa](https://github.com/keptn/keptn/commit/8b257fa56a36cf970a69723f9c3a51c2bcbe4436))
* **installer:** Create separate helm chart for commonly used functionality ([#7568](https://github.com/keptn/keptn/issues/7568)) ([8c93343](https://github.com/keptn/keptn/commit/8c9334390a39b02076b07eeff64b75970e8483f5))
* Introducing ZeroDowntime tests ([#7479](https://github.com/keptn/keptn/issues/7479)) ([71d2c94](https://github.com/keptn/keptn/commit/71d2c94c36d24bbccdac953733774d69c3362f4f))
* **secret-service:** Provide HTTP 400 when scope is not found ([#7325](https://github.com/keptn/keptn/issues/7325)) ([8cf10b6](https://github.com/keptn/keptn/commit/8cf10b69731f094fa131ae7d2d5e00e7082ee261))
* **shipyard-controller:** Introduce automatic provisioning of gitRemoteURI ([#7276](https://github.com/keptn/keptn/issues/7276)) ([59778e0](https://github.com/keptn/keptn/commit/59778e0cfe61ba63e040c0ce4f7fceaa856e2d24))
* **shipyard-controller:** Stop pulling messages after receiving sigterm ([#7464](https://github.com/keptn/keptn/issues/7464)) ([f04874a](https://github.com/keptn/keptn/commit/f04874a6ecf2cd6b9ecb53400da1a53cd5ee5b02))
* **shipyard-controller:** Store sequence executions in new format without potential dots (.) in property names ([#7605](https://github.com/keptn/keptn/issues/7605)) ([1bc93f3](https://github.com/keptn/keptn/commit/1bc93f339b43f82c1735d59041f9358837f93ae5))
* **webhook-service:** Implement `v1beta1` webhook config version ([#7329](https://github.com/keptn/keptn/issues/7329)) ([56c082f](https://github.com/keptn/keptn/commit/56c082fa971eda89b4bc826b4d014e4aa5c049f0))
* **webhook-service:** Introduce `keptn-webhook-config` ConfigMap with denyList ([#7548](https://github.com/keptn/keptn/issues/7548)) ([b392dc0](https://github.com/keptn/keptn/commit/b392dc025a893d69e87dd7ccf209d5ffe93fbb92))


### Bug Fixes

* Better error message for jmeter-service ([#7377](https://github.com/keptn/keptn/issues/7377)) ([f689877](https://github.com/keptn/keptn/commit/f68987703d3ab7b3a9a6e821f800cf631e9d0826))
*  Resource-service clean-up  ([#7427](https://github.com/keptn/keptn/issues/7427)) ([0e75970](https://github.com/keptn/keptn/commit/0e7597043d35c0f0f9d11f6179a8dec732b1a026))
* Add support for ingress class name ([#7324](https://github.com/keptn/keptn/issues/7324)) ([2fe45a8](https://github.com/keptn/keptn/commit/2fe45a872e6247a1703bd270ac503c0f763350dd))
* Added default user string ([#7430](https://github.com/keptn/keptn/issues/7430)) ([3b8f1ca](https://github.com/keptn/keptn/commit/3b8f1caed9dcdb49e40007cf9fc604bb76ce1ce7))
* Added missing UpdateProject parameters ([#7362](https://github.com/keptn/keptn/issues/7362)) ([ae5b81c](https://github.com/keptn/keptn/commit/ae5b81c82e55de2f4c92493ac0ab068b10ea1ce1))
* Added validation of uniform subscriptions ([#7366](https://github.com/keptn/keptn/issues/7366)) ([c9670c7](https://github.com/keptn/keptn/commit/c9670c716508d39f31976cbd474e283fe045e10b))
* **api:** Allow to enable/disable rate limit ([#7534](https://github.com/keptn/keptn/issues/7534)) ([b36816c](https://github.com/keptn/keptn/commit/b36816ce83773fc804517c2e3540a7e67a63b85a))
* **api:** Metadata model update ([#7349](https://github.com/keptn/keptn/issues/7349)) ([f93c920](https://github.com/keptn/keptn/commit/f93c92031bc4c5a8c16b72f0ab8a565ea88602e7))
* **bridge:** Copy to clipboard button rendering ([#7571](https://github.com/keptn/keptn/issues/7571)) ([f2f236f](https://github.com/keptn/keptn/commit/f2f236fe963f1d1d664adc69d26c6ac932684ef2))
* **bridge:** Do not send a start date for evaluation if none is given by the user ([43f053c](https://github.com/keptn/keptn/commit/43f053c8327f433ffcb0475cd740415df9fd9c3a))
* **bridge:** Fix update of git upstream without a user ([#7519](https://github.com/keptn/keptn/issues/7519)) ([4a05795](https://github.com/keptn/keptn/commit/4a05795acd224911a9c695893e9e3b7f0d5784e2))
* **bridge:** Fixed incorrect selected stage in sequence timeline ([#7394](https://github.com/keptn/keptn/issues/7394)) ([558e491](https://github.com/keptn/keptn/commit/558e4914f936f377a5931d1f18c0f63609571e1a))
* **bridge:** Pretty-print request errors ([#7652](https://github.com/keptn/keptn/issues/7652)) ([5b395b9](https://github.com/keptn/keptn/commit/5b395b97595bcc026a437671773a67b28041ecdc))
* **bridge:** Render html in notifications ([#7523](https://github.com/keptn/keptn/issues/7523)) ([5ae2853](https://github.com/keptn/keptn/commit/5ae2853f3a728d5233e22b9715819ea0be9cc9a9))
* **bridge:** Show remediation sequence in default color while running ([#7300](https://github.com/keptn/keptn/issues/7300)) ([6cf6f6b](https://github.com/keptn/keptn/commit/6cf6f6b9fa546c9f4d7b45d7c0a5b3acb6b7cd14))
* **bridge:** Subscription filter now correctly updates on delete/create service ([#7480](https://github.com/keptn/keptn/issues/7480)) ([fc7d3b4](https://github.com/keptn/keptn/commit/fc7d3b4390546746bba2f14bd51bde7aa7e9c20a))
* Changed help messages in labels ([#7491](https://github.com/keptn/keptn/issues/7491)) ([0a2ca97](https://github.com/keptn/keptn/commit/0a2ca97b982cedd781e8ca203b2fa4196b6adcd6))
* **cli:** Cleaned up Oauth command ([#7307](https://github.com/keptn/keptn/issues/7307)) ([c4c9cd1](https://github.com/keptn/keptn/commit/c4c9cd1a9b7046530596de1869cbacdbc66ac18a))
* **cli:** Provide values needed for upgrading the nats dependency ([#7316](https://github.com/keptn/keptn/issues/7316)) ([#7321](https://github.com/keptn/keptn/issues/7321)) ([8962936](https://github.com/keptn/keptn/commit/89629360f4b54300fa923b99d0ad58b8dcaa45f1))
* **cli:** Remove --tag option from trigger delivery command, remove deprecated new-artifact command ([#7376](https://github.com/keptn/keptn/issues/7376)) ([787f08b](https://github.com/keptn/keptn/commit/787f08ba1f6fa3897eb9582c7655fa270ac947d2))
* Disconnect MongoDB client before reconnecting ([#7416](https://github.com/keptn/keptn/issues/7416)) ([a90d39c](https://github.com/keptn/keptn/commit/a90d39c33ddd248f4c19fc3713ab50121b5763d1))
* **distributor:** Parsing of URLforces scheme to http or https ([#7641](https://github.com/keptn/keptn/issues/7641)) ([9240659](https://github.com/keptn/keptn/commit/9240659031ec117bf481cee7543742e95ffd48b3))
* Do not require git user being set when updating project upstream credentials ([#7533](https://github.com/keptn/keptn/issues/7533)) ([ccbf2f1](https://github.com/keptn/keptn/commit/ccbf2f179564741dcd41022fd5ea9840171c4cf8))
* **installer:** Custom readiness probe for MongoDB to fix default one ([#7663](https://github.com/keptn/keptn/issues/7663)) ([0c8b879](https://github.com/keptn/keptn/commit/0c8b87950aa15b3c89c037d8664d6d4846375b45))
* **installer:** Quote value of MAX_AUTH_ENABLED ([#7549](https://github.com/keptn/keptn/issues/7549)) ([b3a4cb9](https://github.com/keptn/keptn/commit/b3a4cb9270eae64ca149bd5fc9e267436d26c75a))
* **installer:** Revert configuration-service back to update strategy recreate ([#7650](https://github.com/keptn/keptn/issues/7650)) ([c4ab18d](https://github.com/keptn/keptn/commit/c4ab18d941600e592d26e75989d6298a30705ccb))
* **jmeter-service:** Avoid nil pointer access when logging results ([#7391](https://github.com/keptn/keptn/issues/7391)) ([c981022](https://github.com/keptn/keptn/commit/c981022228bf35641fc3722c06e54ceb810a7486))
* Rename GitProxyInsecure to InsecureSkpTLS and pass it to upstream interactions ([#7410](https://github.com/keptn/keptn/issues/7410)) ([07d2ad9](https://github.com/keptn/keptn/commit/07d2ad909eb88641ebb3adfe66ede38dec67a902))
* **resource-service:** Fixed unit test ([#7443](https://github.com/keptn/keptn/issues/7443)) ([8f6dbb5](https://github.com/keptn/keptn/commit/8f6dbb5e3274b9f891a4aaab9cb43f39433d12c2))
* **shipyard-controller:** Added option to configure maximum service name length, adapted returned http status code ([#7445](https://github.com/keptn/keptn/issues/7445)) ([26bc02a](https://github.com/keptn/keptn/commit/26bc02ab7016f8d40153e8849115fb4ef05c99a3))
* **shipyard-controller:** Fix order of merging properties for event payload ([#7631](https://github.com/keptn/keptn/issues/7631)) ([#7651](https://github.com/keptn/keptn/issues/7651)) ([640b80e](https://github.com/keptn/keptn/commit/640b80e9e499722ad3f3db845950032d94ac7fa5))
* **shipyard-controller:** Proceed with service deletion if the service is not present on the configuration service anymore ([#7461](https://github.com/keptn/keptn/issues/7461)) ([6ee9f48](https://github.com/keptn/keptn/commit/6ee9f4851ba498d8948e60d006bd7e6459802154))
* URL-provisioning test should wait for pod restart ([#7411](https://github.com/keptn/keptn/issues/7411)) ([966a549](https://github.com/keptn/keptn/commit/966a549600d6c8a4f0f50ddca5e515014d3d4b00))


### Refactoring

* **bridge:** Move static server pages to angular client ([#7369](https://github.com/keptn/keptn/issues/7369)) ([0ff21f3](https://github.com/keptn/keptn/commit/0ff21f3a335379f32afa3b6bc715e574f3ec886d))


### Other

* Add [@renepanzar](https://github.com/renepanzar) as member ([#7612](https://github.com/keptn/keptn/issues/7612)) ([a99e889](https://github.com/keptn/keptn/commit/a99e8890095bb3bb6422c3e3cfd6e953b9449ef6))
* **cli:** Polish upgrade message when no upstream is present ([#7310](https://github.com/keptn/keptn/issues/7310)) ([bdda191](https://github.com/keptn/keptn/commit/bdda1917ca758ef7cf93b08eb1bfc276e2c5faed))
* **installer:** Upgrade MongoDB to v11 ([#7444](https://github.com/keptn/keptn/issues/7444)) ([9346d41](https://github.com/keptn/keptn/commit/9346d41f851300bf308fcc8fe1112ee875924506))
* Make filter a mandatory field in mongo datastore get event by type ([#7355](https://github.com/keptn/keptn/issues/7355)) ([117f904](https://github.com/keptn/keptn/commit/117f904ccb1d270e9cc093b5a346b30803c0892c))
* Updated go-utils to version removing gitcommit from finished events ([#7320](https://github.com/keptn/keptn/issues/7320)) ([c241059](https://github.com/keptn/keptn/commit/c24105911e36b1c9695b5b424ab66740db586bc9))


### Docs

* Add conventions for logging and env var naming ([#7611](https://github.com/keptn/keptn/issues/7611)) ([90f8536](https://github.com/keptn/keptn/commit/90f8536f8b38b667b88cbe12600270fa9e8c44a1))
* **cli:** Add missing/remove unsupported commands from README ([#7544](https://github.com/keptn/keptn/issues/7544)) ([bea81f1](https://github.com/keptn/keptn/commit/bea81f1dcb76e93411f59ee63991b954d83991c8))
* **distributor:** Fixed broken link to cloud events docs ([#7441](https://github.com/keptn/keptn/issues/7441)) ([5ee6f28](https://github.com/keptn/keptn/commit/5ee6f28ff8ccd6aabc405e0405115eab2235a4f9))
* Fix hyperlink to references to docs folder ([#7327](https://github.com/keptn/keptn/issues/7327)) ([5d8b4eb](https://github.com/keptn/keptn/commit/5d8b4eb711b479d1195ee059f790368d3d4e0507))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                  | Container Name        | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| --------------------- | --------------------- | ----------- | --------- | ----------- | --------- | --------------------------------------------------- |
| keptn-mongo           | mongodb               | null        | null      | null        | null      | docker.io/bitnami/mongodb:4.4.13-debian-10-r52      |
| api-gateway-nginx     | api-gateway-nginx     | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.21.6-alpine |
| api-service           | api-service           | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.15.0                          |
| api-service           | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| approval-service      | approval-service      | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.15.0             |
| approval-service      | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| configuration-service | configuration-service | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/configuration-service:0.15.0        |
| remediation-service   | remediation-service   | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.15.0          |
| remediation-service   | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| bridge                | bridge                | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.15.0                      |
| mongodb-datastore     | mongodb-datastore     | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.15.0            |
| mongodb-datastore     | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| lighthouse-service    | lighthouse-service    | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.15.0           |
| lighthouse-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| secret-service        | secret-service        | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.15.0               |
| shipyard-controller   | shipyard-controller   | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.15.0          |
| statistics-service    | statistics-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.15.0           |
| statistics-service    | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| webhook-service       | webhook-service       | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.15.0              |
| webhook-service       | distributor           | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.15.0                  |
| keptn-nats            | nats                  | null        | null      | null        | null      | nats:2.7.3-alpine                                   |
| keptn-nats            | metrics               | null        | null      | null        | null      | natsio/prometheus-nats-exporter:0.9.1               |

</details>
