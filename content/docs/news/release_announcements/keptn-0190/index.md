---
title: Keptn 0.19.0
weight: 67
---

# Release Notes ## [0.19.0](https://github.com/keptn/keptn/compare/0.18.0...0.19.0) (2022-09-09)

---

**Key announcements**:

:information_source: The *Helm-service* and *JMeter-service* have been moved into the [keptn-contrib](https://github.com/keptn-contrib) GH organization.

:star: *Bridge* uses [D3](https://d3js.org/) to render evaluation graphs improving rendering time by up to 30%.

:sparkles: New Import API*: Keptn provides a new import API. This API can be used to setup a Keptn project by importing a template as zip archive.

:hammer: Keptn releases are now signed. We provide a Helm Chart provenance file and our public key as part of the release assets.

---


### ⚠ BREAKING CHANGES

* Helm-service and Jmeter-service were moved into their own repositories under the keptn-contrib GH organization. 0.18.2 was the last version that included them in the Keptn core release. Please check [keptn-contrib/helm-service](https://github.com/keptn-contrib/helm-service) and [keptn-contrib/jmeter-service](https://github.com/keptn-contrib/jmeter-service) for the latest versions.
* **api:** Events sent to the Keptn API are being validated, based on their type. For more information, please check [#5544](https://github.com/keptn/keptn/issues/5544)
* **installer:** The `git.remoteURLDenyList` helm value was moved under `features` for consistency purposes.

### Features

* Add query parameters to GET secret endpoint ([#8732](https://github.com/keptn/keptn/issues/8732)) ([72d8db1](https://github.com/keptn/keptn/commit/72d8db18feecaa65ab96bea16f4fa6680a54b714))
* **api:** Better inbound event validation ([#8578](https://github.com/keptn/keptn/issues/8578)) ([d3742e8](https://github.com/keptn/keptn/commit/d3742e8657c99b1d85798be0d67b8ea5aa8450ee))
* **api:** Enable import endpoint ([#8629](https://github.com/keptn/keptn/issues/8629)) ([5bc5a44](https://github.com/keptn/keptn/commit/5bc5a4440b9442517319af2df38d3681decd2512))
* **api:** Importer manifest validation ([#8508](https://github.com/keptn/keptn/issues/8508)) ([76b5a3f](https://github.com/keptn/keptn/commit/76b5a3fa52d714b855944c9b3c53d5a15e7ad9fb))
* **api:** Provide structured output for successful import operations ([#8515](https://github.com/keptn/keptn/issues/8515)) ([63c5263](https://github.com/keptn/keptn/commit/63c526385bebb23daa9eef3167040b83fa157428))
* **bridge:** Add delete section to subscription edit page ([#8548](https://github.com/keptn/keptn/issues/8548)) ([5b88b36](https://github.com/keptn/keptn/commit/5b88b365444527a8159c15a4a3a1b0154ac112d0))
* **bridge:** Better visualization of failed Key SLIs ([#8545](https://github.com/keptn/keptn/issues/8545)) ([9e72127](https://github.com/keptn/keptn/commit/9e7212784494df6714bd695d2050d625061509cc))
* **bridge:** Improve indicator result score visualization ([#8572](https://github.com/keptn/keptn/issues/8572)) ([2c44f66](https://github.com/keptn/keptn/commit/2c44f663a094444f4acc288d0e54304521f1cb7f))
* **bridge:** Improve ktb-chart ([#8561](https://github.com/keptn/keptn/issues/8561)) ([3bc50fe](https://github.com/keptn/keptn/commit/3bc50feea5dce653bda48191068904ff002b527c))
* **bridge:** Improve the logging on the Bridge server ([#8735](https://github.com/keptn/keptn/issues/8735)) ([6756af1](https://github.com/keptn/keptn/commit/6756af17cfee3f58ba5ca8baf44d77da014d08e1))
* **bridge:** integrate storybook ([#8496](https://github.com/keptn/keptn/issues/8496)) ([8a511f5](https://github.com/keptn/keptn/commit/8a511f590d9808fdc7ff04d6a4bceac15f8e0863))
* **bridge:** Link secret creation from secret selection ([#8478](https://github.com/keptn/keptn/issues/8478)) ([ecf2b08](https://github.com/keptn/keptn/commit/ecf2b08b1750f946aed1b7b8c5865b6f2f61f0a3))
* **bridge:** link to current running sequence ([#8567](https://github.com/keptn/keptn/issues/8567)) ([1845086](https://github.com/keptn/keptn/commit/18450865c5e23ef504bd48f539d4dd775d442229))
* **bridge:** Use ktb-chart component ([#8550](https://github.com/keptn/keptn/issues/8550)) ([becfceb](https://github.com/keptn/keptn/commit/becfcebb4539eeec5b07c187f713b136df146c4b))
* **cli:** Support adding resources to all stages without defining a service + refactoring ([#8822](https://github.com/keptn/keptn/issues/8822)) ([4096a5f](https://github.com/keptn/keptn/commit/4096a5f7965178e7bfa4fd79cfa88dda998aa417))
* **installer:** Bump MongoDB version ([#8729](https://github.com/keptn/keptn/issues/8729)) ([188e5e1](https://github.com/keptn/keptn/commit/188e5e1ded39053cf2e58b0fb9c78a8e51fd2d66))
* **installer:** Move git remote URL deny list under features ([#8673](https://github.com/keptn/keptn/issues/8673)) ([7c8bcfa](https://github.com/keptn/keptn/commit/7c8bcfa7959b3937e84c6d2e2b52f213e1854d5e))
* Introduce signed Keptn Helm charts ([#8730](https://github.com/keptn/keptn/issues/8730)) ([5d2c616](https://github.com/keptn/keptn/commit/5d2c616a46c79fb2c9f4f3680d3c8381cd42e1a6))
* Move Helm and JMeter Service into keptn-contrib ([#8700](https://github.com/keptn/keptn/issues/8700)) ([19db889](https://github.com/keptn/keptn/commit/19db8891155ea79056b8863a8b71277df51f5623))
* Removed clean up of uniform and services when deleting a project ([#8720](https://github.com/keptn/keptn/issues/8720)) ([2f55865](https://github.com/keptn/keptn/commit/2f5586537258a229fcf6d2f0d1df48ec2f2a4cab))
* **shipyard-controller:** Add dbdump endpoint to the Debug-UI ([#8618](https://github.com/keptn/keptn/issues/8618)) ([0d5e228](https://github.com/keptn/keptn/commit/0d5e228f2f59055b4d89ac67a2f4b8cb7383faa6))
* **shipyard-controller:** Add getBlockingSequences endpoint to the Debug-UI ([#8564](https://github.com/keptn/keptn/issues/8564)) ([c3b4fc3](https://github.com/keptn/keptn/commit/c3b4fc319541cee31433a1693811168a86b5b34a))
* **shipyard-controller:** debugUI documentation & feature Flag ([#8736](https://github.com/keptn/keptn/issues/8736)) ([4d80654](https://github.com/keptn/keptn/commit/4d80654008975dcf7bc9631baf3ae8110cdd4500))
* **shipyard-controller:** Introduce Debug-UI for shipyard-controller ([#8400](https://github.com/keptn/keptn/issues/8400)) ([af73538](https://github.com/keptn/keptn/commit/af7353827d9aaa18d2b85849d6ebfc939c068661))
* **shipyard-controller:** Provide option to hide automatically provisioned URLs ([#8745](https://github.com/keptn/keptn/issues/8745)) ([64d4398](https://github.com/keptn/keptn/commit/64d43988a3de2f0f4a87fac7e2e19d8d915230f8))
* Signed container images ([#8740](https://github.com/keptn/keptn/issues/8740)) ([d7a9b55](https://github.com/keptn/keptn/commit/d7a9b55cc46f4783f8485edbb9160195e8c2174e))
* **webhook-service:** Added unmarshalling of curl responses  ([#8782](https://github.com/keptn/keptn/issues/8782)) ([db8778e](https://github.com/keptn/keptn/commit/db8778e00daf2afc46272ab347521d917dee8a02))


### Bug Fixes

* **bridge:** Fix invalid header property for webhook ([#8543](https://github.com/keptn/keptn/issues/8543)) ([c4aed1b](https://github.com/keptn/keptn/commit/c4aed1be14865327b54459cf360f62a16e0269f2))
* **bridge:** Stop navigation overwrite on trace load ([#8617](https://github.com/keptn/keptn/issues/8617)) ([178231c](https://github.com/keptn/keptn/commit/178231cea41357abbd185aab44e426bd8038deef))
* **cli:** Support `--labels` option in `trigger sequence` command ([#8819](https://github.com/keptn/keptn/issues/8819)) ([e484afd](https://github.com/keptn/keptn/commit/e484afd5902630d051781a0ae00e445a380075ff))
* **cli:** Use docker v2 API for fetching images ([#8827](https://github.com/keptn/keptn/issues/8827)) ([bfdb7e1](https://github.com/keptn/keptn/commit/bfdb7e1e841c73194639a8175b6b7cddce79d8be))
* Fixed automatic navigation to latest stage ([#8714](https://github.com/keptn/keptn/issues/8714)) ([be06e14](https://github.com/keptn/keptn/commit/be06e1497b948b5c47ef2f9d0a5d0725239ab805))
* **installer:** Normalize 401 responses ([#8792](https://github.com/keptn/keptn/issues/8792)) ([c8a33e5](https://github.com/keptn/keptn/commit/c8a33e5e3b3738f7df6d00df6e0f4164a32e44a1))
* **lighthouse-service:** If getSLI returns result fail make sure lighthouse fails only after computing indicator results ([#8786](https://github.com/keptn/keptn/issues/8786)) ([5064ea2](https://github.com/keptn/keptn/commit/5064ea27dc96779efbb605e908dbe5feeae27c5c))
* **lighthouse-service:** return a failed Evaluation Result for nil SLIs ([#8665](https://github.com/keptn/keptn/issues/8665)) ([b8e3fa5](https://github.com/keptn/keptn/commit/b8e3fa5fd0942b46318671b845b1b4787ce83eb7))
* log.Fatal will call os.Exit, use log.Println instead ([#8492](https://github.com/keptn/keptn/issues/8492)) ([55b3dea](https://github.com/keptn/keptn/commit/55b3dea42effdc16ca4b58c12a458c139960921e))
* Merge integration subscriptions into one, apply newly supplied subscriptions if existing ones are empty ([#8573](https://github.com/keptn/keptn/issues/8573)) ([ec0036f](https://github.com/keptn/keptn/commit/ec0036f45d521670d5e4d76dc48f811609af552b))
* **resource-service:** GetDefaultBranch looks for HEAD before fallback to master ([#8628](https://github.com/keptn/keptn/issues/8628)) ([9d42dbd](https://github.com/keptn/keptn/commit/9d42dbd678d475b678c847e44ca6a8b68d9d8204))
* **resource-service:** Use values provided by GIT_KEPTN_USER and GIT_KEPTN_EMAIL for commits to the upstream ([#8676](https://github.com/keptn/keptn/issues/8676)) ([a70dfb9](https://github.com/keptn/keptn/commit/a70dfb97ef7cb8726becda39cab404d58899c9a0))
* **shipyard-controller:** Added service in filter of event dispatcher ([#8683](https://github.com/keptn/keptn/issues/8683)) ([5a230bf](https://github.com/keptn/keptn/commit/5a230bf9f3f0aadd06f1e0045d24abc36a23488a))
* **shipyard-controller:** Clean up event queue when cancelling a sequence ([#8583](https://github.com/keptn/keptn/issues/8583)) ([3253bf5](https://github.com/keptn/keptn/commit/3253bf522644f19ed44bbfdec53ab678f4dc86ce))
* **shipyard-controller:** Fail sequence when receiving invalid status ([#8612](https://github.com/keptn/keptn/issues/8612)) ([27c5524](https://github.com/keptn/keptn/commit/27c55249151fb81338d7adfaad6eb0fe9ce26fc1))
* **shipyard-controller:** Merge subscriptions of multiple instances of a registration ([#8509](https://github.com/keptn/keptn/issues/8509)) ([fee5edb](https://github.com/keptn/keptn/commit/fee5edb2dd215e782724d170cb0e3911bb227257))
* **shipyard-controller:** Only update specific properties when updating projects MV on event ([#8817](https://github.com/keptn/keptn/issues/8817)) ([2eed8d6](https://github.com/keptn/keptn/commit/2eed8d63ff7280f9bd884bf019d31a98a8682f86))
* **shipyard-controller:** Remove DB dump enpoints documentation from API docs ([#8771](https://github.com/keptn/keptn/issues/8771)) ([09a7d16](https://github.com/keptn/keptn/commit/09a7d16564eb5b54dd4029c7bb4f45d9a27d1689))
* **shipyard-controller:** Update complete sequence execution after sequence is finished ([#8814](https://github.com/keptn/keptn/issues/8814)) ([8d59655](https://github.com/keptn/keptn/commit/8d596554d14c9fd55c3042b908490090b0676851))
* **shipyard-controller:** Update Integration when Subscriptions field is null ([#8601](https://github.com/keptn/keptn/issues/8601)) ([29c9e7d](https://github.com/keptn/keptn/commit/29c9e7d6d250cde8247558df1303a72c900d4540))


### Refactoring

* **bridge:** Improve modify uniform subscription ([#8681](https://github.com/keptn/keptn/issues/8681)) ([b4d83b8](https://github.com/keptn/keptn/commit/b4d83b879e62be48e9b8bdf48d85b740d021d2ef))
* **bridge:** Refactor integration view ([#8542](https://github.com/keptn/keptn/issues/8542)) ([c3c00ab](https://github.com/keptn/keptn/commit/c3c00aba855c76e1ad5f8adae5f96049b53703e1))
* **bridge:** Split environment-details component ([#8605](https://github.com/keptn/keptn/issues/8605)) ([b0f4364](https://github.com/keptn/keptn/commit/b0f4364b2d19c0c171121b8f6241682732d0207e))


### Docs

* Added registry override info in README.md ([#8658](https://github.com/keptn/keptn/issues/8658)) ([6eaa936](https://github.com/keptn/keptn/commit/6eaa936aa336b1557f44065d8867626ed1c44fe2))
* **bridge:** Streamlined and updated bridge documentation ([#8675](https://github.com/keptn/keptn/issues/8675)) ([75e7a91](https://github.com/keptn/keptn/commit/75e7a9165a57b4a91ec2a697a058f103ae62cd51))
* **cli:** Remove outdated example ([#8596](https://github.com/keptn/keptn/issues/8596)) ([b46547f](https://github.com/keptn/keptn/commit/b46547f97660e7025d3d72d9fbcbf7c66fd8576f))
* **installer:** Enhance helm values documentation ([#8807](https://github.com/keptn/keptn/issues/8807)) ([3c094f3](https://github.com/keptn/keptn/commit/3c094f3207ee7ac56babaf10d29eecc2bf845693))
* Updates Helm value documentation for Keptn Bridge ([#8783](https://github.com/keptn/keptn/issues/8783)) ([9f32521](https://github.com/keptn/keptn/commit/9f32521b46972b58cd30c89412bbedc6bcf3632c))


### Other

* Add [@agardner](https://github.com/agardner)IT as Keptn member ([#8563](https://github.com/keptn/keptn/issues/8563)) ([6841b1d](https://github.com/keptn/keptn/commit/6841b1ddcff06b0edcaaf8a827d865a8063657d6))
* add [@bradmccoydev](https://github.com/bradmccoydev) as member ([#8756](https://github.com/keptn/keptn/issues/8756)) ([b878492](https://github.com/keptn/keptn/commit/b87849206468532177cc01c736ea71faebddb658))
* add [@mehabhalodiya](https://github.com/mehabhalodiya) as member ([#8763](https://github.com/keptn/keptn/issues/8763)) ([039ada4](https://github.com/keptn/keptn/commit/039ada43176dd96d3f43bfb6d5629e858dcccec2))
* Add [@philipp-hinteregger](https://github.com/philipp-hinteregger) to members ([#8692](https://github.com/keptn/keptn/issues/8692)) ([31c3781](https://github.com/keptn/keptn/commit/31c378178acf28039005cc6da1c5dda86c2e63a5))
* **api:** Remote event validation is disabled by default ([#8828](https://github.com/keptn/keptn/issues/8828)) ([b62a1f4](https://github.com/keptn/keptn/commit/b62a1f461f7b0efa7f2f9a0ab10264bd6b6f4989))
* **bridge:** Enable D3 charts by default ([#8644](https://github.com/keptn/keptn/issues/8644)) ([df594eb](https://github.com/keptn/keptn/commit/df594eb93df31d0eef17d918bfbb3cafc23645df))
* **bridge:** Remove resource service feature flag ([#8635](https://github.com/keptn/keptn/issues/8635)) ([aeec940](https://github.com/keptn/keptn/commit/aeec94055f72e7f492db4f452d52f6f1f18b95ec))
* **bridge:** Separate run of client and server (dev) ([#8613](https://github.com/keptn/keptn/issues/8613)) ([d1f5395](https://github.com/keptn/keptn/commit/d1f5395d375c53c1dd8911ffea2f95bf5989f9be))
* Improve shipyard-controller logging for better troubleshooting support ([#8694](https://github.com/keptn/keptn/issues/8694)) ([3031fac](https://github.com/keptn/keptn/commit/3031fac829e5928d5a88bbfdb51b3ef238e5bbab))
* Remove configuration-service k8s service ([#8530](https://github.com/keptn/keptn/issues/8530)) ([d025e5d](https://github.com/keptn/keptn/commit/d025e5d32f79bb8109ac776ba93a2e28d2c2a3a2))
* Remove Helm and Jmeter services from Integration tests ([#8559](https://github.com/keptn/keptn/issues/8559)) ([71b66a8](https://github.com/keptn/keptn/commit/71b66a895ce4d66fa7ea88e1bc3b247699b03558))
* Remove Jmeter and Helm services from pipelines ([#8560](https://github.com/keptn/keptn/issues/8560)) ([ce231e8](https://github.com/keptn/keptn/commit/ce231e8594df85a3718798d8470d4541796140dc))
* Remove unused functions ([#8806](https://github.com/keptn/keptn/issues/8806)) ([834bfef](https://github.com/keptn/keptn/commit/834bfef7d301b47aaff94b5b770beff5c1d55d8d))
* **shipyard-controller:** Cleanup package structure ([#8537](https://github.com/keptn/keptn/issues/8537)) ([4599e37](https://github.com/keptn/keptn/commit/4599e371758a112e5ce00344eacc89041a22fbf2))
* Update tablemark-cli to version 3.0.0 ([#8659](https://github.com/keptn/keptn/issues/8659)) ([d35429b](https://github.com/keptn/keptn/commit/d35429b1134f255e1a834ac7d357b819e1b3fb09))

<details>
<summary>Kubernetes Resource Data</summary>

### Resource Stats

| Name                | Container Name      | CPU Request | CPU Limit | RAM Request | RAM Limit | Image                                               |
| :------------------ | :------------------ | :---------- | :-------- | :---------- | :-------- | :-------------------------------------------------- |
| keptn-mongo         | mongodb             | 200m        | 1000m     | 100Mi       | 500Mi     | docker.io/bitnami/mongodb:5.0.10-debian-11-r3       |
| api-gateway-nginx   | api-gateway-nginx   | 50m         | 100m      | 64Mi        | 128Mi     | docker.io/nginxinc/nginx-unprivileged:1.22.0-alpine |
| api-service         | api-service         | 50m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/api:0.19.0                          |
| approval-service    | approval-service    | 25m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/approval-service:0.19.0             |
| bridge              | bridge              | 25m         | 200m      | 64Mi        | 256Mi     | docker.io/keptn/bridge2:0.19.0                      |
| lighthouse-service  | lighthouse-service  | 50m         | 200m      | 128Mi       | 1Gi       | docker.io/keptn/lighthouse-service:0.19.0           |
| mongodb-datastore   | mongodb-datastore   | 50m         | 300m      | 32Mi        | 512Mi     | docker.io/keptn/mongodb-datastore:0.19.0            |
| remediation-service | remediation-service | 50m         | 200m      | 64Mi        | 1Gi       | docker.io/keptn/remediation-service:0.19.0          |
| resource-service    | resource-service    | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/resource-service:0.19.0             |
| secret-service      | secret-service      | 25m         | 200m      | 32Mi        | 64Mi      | docker.io/keptn/secret-service:0.19.0               |
| shipyard-controller | shipyard-controller | 50m         | 100m      | 32Mi        | 128Mi     | docker.io/keptn/shipyard-controller:0.19.0          |
| statistics-service  | statistics-service  | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/statistics-service:0.19.0           |
| statistics-service  | distributor         | 25m         | 100m      | 16Mi        | 32Mi      | docker.io/keptn/distributor:0.19.0                  |
| webhook-service     | webhook-service     | 25m         | 100m      | 32Mi        | 64Mi      | docker.io/keptn/webhook-service:0.19.0              |
| keptn-nats          | nats                | 200m        | 500m      | 500Mi       | 1Gi       | nats:2.8.4-alpine                                   |

</details>
