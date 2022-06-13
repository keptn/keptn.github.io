---
title: Keptn 0.11.3
weight: 83
---

This is a hotfix release for Keptn 0.11.2, containing several fixes to improve the stability of Keptn.

### Bug Fixes

* **bridge:** Update services on project change ([#6252](https://github.com/keptn/keptn/issues/6252)) ([74bdf00](https://github.com/keptn/keptn/commit/74bdf009f22415321c85329f336dcb09d4af3f44))
* **cli:** Wrong handling of HTTPS in auth command ([#6269](https://github.com/keptn/keptn/issues/6269)) ([f1941b4](https://github.com/keptn/keptn/commit/f1941b4ce1a04187b712b27717580c9cf6cdbe85))
* **configuration-service:** Create tmpdir for unarchiving in /data/config ([#6329](https://github.com/keptn/keptn/issues/6329)) ([285528b](https://github.com/keptn/keptn/commit/285528be94e7637ead6f91e56e23e34874a0dfaa))
* **configuration-service:** Fix permission issues for configuration service ([#6315](https://github.com/keptn/keptn/issues/6315)) ([#6317](https://github.com/keptn/keptn/issues/6317)) ([de70eeb](https://github.com/keptn/keptn/commit/de70eeb1a734ce6a7117edf4c1b135c42a9bb872))
* **installer:** Disable nats config reloader per default ([#6316](https://github.com/keptn/keptn/issues/6316)) ([#6318](https://github.com/keptn/keptn/issues/6318)) ([d307d83](https://github.com/keptn/keptn/commit/d307d831630a7b0428d0887b11b526835c10e97e))
* **mongodb-datastore:** Ensure MongoDB Client is not nil before retrieving database ([#6251](https://github.com/keptn/keptn/issues/6251)) ([#6255](https://github.com/keptn/keptn/issues/6255)) ([6dd1833](https://github.com/keptn/keptn/commit/6dd18334c882d5da748bef8c7f6f513c05618944))
* **statistics-service:** Migrate data containing dots in keys ([#6250](https://github.com/keptn/keptn/issues/6250)) ([8f50c48](https://github.com/keptn/keptn/commit/8f50c4880380b25533d00deec2eb6b6288397017))
* **statistics-service:** Migration of keptn service execution data ([#6250](https://github.com/keptn/keptn/issues/6250)) ([564fbe6](https://github.com/keptn/keptn/commit/564fbe65fce9cf534185eab2c6d37cadbd9628ed))

## Upgrade to 0.11.x

* The upgrade from 0.10.x to 0.11.x is supported by the `keptn upgrade` command. Find the documentation here: [Upgrade from Keptn 0.10.x to 0.11.x](https://keptn.sh/docs/0.11.x/operate/upgrade/)
