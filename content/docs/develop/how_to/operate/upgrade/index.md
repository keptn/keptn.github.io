---
title: Upgrade
description: Upgrade your Keptn to 0.7
weight: 20
keywords: upgrade
---

## Upgrade from 0.6.0 to 0.6.1

* To download and install the Keptn CLI for version 0.6.1, please refer to the [Install Keptn CLI section](../setup-keptn/#install-keptn-cli).

* To upgrade your Keptn installation from 0.6.0 to 0.6.1, you can deploy a *Kubernetes Job* that will take care of updating all components to the 0.6.1 release. Please [verify that you are connected to the correct Kubernetes cluster](../../reference/troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before deploying the upgrading job with the next command:

```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/0.6.1/upgrade-060-061/upgrade-job.yaml
```

* To check the status of the update job, please execute:

```console
kubectl get job
```
```
NAME                COMPLETIONS   DURATION   AGE
upgrader            1/1           17s        20h
```

When the job is completed, your Keptn version has been updated to 0.6.1.

<details><summary>*Verifying that the upgrade worked*</summary>

To verify that the upgrade process worked, please check the images and their tags using `kubectl` as described below. 

**Before the upgrade**:

```console
kubectl -n keptn get deployments -owide
```

```
NAME                                                      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS               IMAGES                                      SELECTOR
api                                                       1/1     1            1           4h25m   api                      keptn/api:0.6.0                             run=api
bridge                                                    1/1     1            1           4h25m   bridge                   keptn/bridge2:20200308.0859                 run=bridge
configuration-service                                     1/1     1            1           4h25m   configuration-service    keptn/configuration-service:20200308.0859   run=configuration-service
eventbroker-go                                            1/1     1            1           4h25m   eventbroker-go           keptn/eventbroker-go:0.6.0                  run=eventbroker-go
gatekeeper-service                                        1/1     1            1           4h24m   gatekeeper-service       keptn/gatekeeper-service:0.6.0              run=gatekeeper-service
gatekeeper-service-evaluation-done-distributor            1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
helm-service                                              1/1     1            1           4h25m   helm-service             keptn/helm-service:0.6.0                    run=helm-service
helm-service-configuration-change-distributor             1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
helm-service-service-create-distributor                   1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
jmeter-service                                            1/1     1            1           4h24m   jmeter-service           keptn/jmeter-service:0.6.0                  run=jmeter-service
jmeter-service-deployment-distributor                     1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service                                        1/1     1            1           4h24m   lighthouse-service       keptn/lighthouse-service:0.6.0              run=lighthouse-service
lighthouse-service-get-sli-done-distributor               1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service-start-evaluation-distributor           1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
lighthouse-service-tests-finished-distributor             1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
nats-operator                                             1/1     1            1           4h25m   nats-operator            connecteverything/nats-operator:0.6.0       name=nats-operator
prometheus-service                                        1/1     1            1           27m     prometheus-service       keptn/prometheus-service:0.3.1              run=prometheus-service
prometheus-service-monitoring-configure-distributor       1/1     1            1           27m     distributor              keptn/distributor:0.5.0                     run=distributor
prometheus-sli-service                                    1/1     1            1           24m     prometheus-sli-service   keptn/prometheus-sli-service:0.2.0          run=prometheus-sli-service
prometheus-sli-service-monitoring-configure-distributor   1/1     1            1           24m     distributor              keptn/distributor:0.5.0                     run=distributor
remediation-service                                       1/1     1            1           4h24m   remediation-service      keptn/remediation-service:0.6.0             run=remediation-service
remediation-service-problem-distributor                   1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
shipyard-service                                          1/1     1            1           4h25m   shipyard-service         keptn/shipyard-service:0.6.0                run=shipyard-service
shipyard-service-create-project-distributor               1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
shipyard-service-delete-project-distributor               1/1     1            1           4h25m   distributor              keptn/distributor:0.6.0                     run=distributor
wait-service                                              1/1     1            1           4h24m   wait-service             keptn/wait-service:0.6.0                    run=wait-service
wait-service-deployment-distributor                       1/1     1            1           4h24m   distributor              keptn/distributor:0.6.0                     run=distributor
```

```console
kubectl -n keptn-datastore get deployments -owide
```

```console
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS          IMAGES                                  SELECTOR
mongodb                         1/1     1            1           4h25m   mongodb             centos/mongodb-36-centos7:1             name=mongodb
mongodb-datastore               1/1     1            1           4h25m   mongodb-datastore   keptn/mongodb-datastore:20200308.0859   run=mongodb-datastore
mongodb-datastore-distributor   1/1     1            1           4h25m   distributor         keptn/distributor:0.6.0                 run=distributor
```

**After the upgrade**

```console
kubectl -n keptn get deployments -owide
```

```console
NAME                                                      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS               IMAGES                                  SELECTOR
api                                                       1/1     1            1           4h39m   api                      keptn/api:0.6.1                         run=api
bridge                                                    1/1     1            1           4h39m   bridge                   keptn/bridge2:0.6.1                     run=bridge
configuration-service                                     1/1     1            1           4h39m   configuration-service    keptn/configuration-service:0.6.1       run=configuration-service
eventbroker-go                                            1/1     1            1           4h39m   eventbroker-go           keptn/eventbroker-go:0.6.1              run=eventbroker-go
gatekeeper-service                                        1/1     1            1           4h39m   gatekeeper-service       keptn/gatekeeper-service:0.6.1          run=gatekeeper-service
gatekeeper-service-evaluation-done-distributor            1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
helm-service                                              1/1     1            1           4h39m   helm-service             keptn/helm-service:0.6.1                run=helm-service
helm-service-configuration-change-distributor             1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
helm-service-service-create-distributor                   1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
jmeter-service                                            1/1     1            1           4h39m   jmeter-service           keptn/jmeter-service:0.6.1              run=jmeter-service
jmeter-service-deployment-distributor                     1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
lighthouse-service                                        1/1     1            1           4h39m   lighthouse-service       keptn/lighthouse-service:0.6.1          run=lighthouse-service
lighthouse-service-distributor                            1/1     1            1           72s     distributor              keptn/distributor:0.6.1                 run=distributor
nats-operator                                             1/1     1            1           4h40m   nats-operator            connecteverything/nats-operator:0.6.0   name=nats-operator
prometheus-service                                        1/1     1            1           41m     prometheus-service       keptn/prometheus-service:0.3.1          run=prometheus-service
prometheus-service-monitoring-configure-distributor       1/1     1            1           41m     distributor              keptn/distributor:0.5.0                 run=distributor
prometheus-sli-service                                    1/1     1            1           38m     prometheus-sli-service   keptn/prometheus-sli-service:0.2.1      run=prometheus-sli-service
prometheus-sli-service-monitoring-configure-distributor   1/1     1            1           38m     distributor              keptn/distributor:latest                run=distributor
remediation-service                                       1/1     1            1           4h39m   remediation-service      keptn/remediation-service:0.6.1         run=remediation-service
remediation-service-problem-distributor                   1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
shipyard-service                                          1/1     1            1           4h39m   shipyard-service         keptn/shipyard-service:0.6.1            run=shipyard-service
shipyard-service-create-project-distributor               1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
shipyard-service-delete-project-distributor               1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor
wait-service                                              1/1     1            1           4h39m   wait-service             keptn/wait-service:0.6.1                run=wait-service
wait-service-deployment-distributor                       1/1     1            1           4h39m   distributor              keptn/distributor:0.6.1                 run=distributor

```

```console
kubectl -n keptn-datastore get deployments -owide
```

```console
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS          IMAGES                          SELECTOR
mongodb                         1/1     1            1           2m41s   mongodb             centos/mongodb-36-centos7:1     name=mongodb
mongodb-datastore               1/1     1            1           4h40m   mongodb-datastore   keptn/mongodb-datastore:0.6.1   run=mongodb-datastore
mongodb-datastore-distributor   1/1     1            1           4h40m   distributor         keptn/distributor:0.6.1         run=distributor
```

</details>

<details><summary>*Inspecting the upgrader logs*</summary>
To see the log of the upgrader, execute:

```
kubectl logs job/upgrader
```

The expected log output should look as follows:

```
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"62410fda329f5beff601663f21cf70e7ef22ba0d72201a71e4583742d5a894ce"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: EA38:03B6:2FB4D:40878:5E68D9A4
Content-Length: 185
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:27 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17332-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929768.602904,VS0,VE141
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: 9dd59ca82cfb8b58daeccf1c941cda68f0c41559
Expires: Wed, 11 Mar 2020 12:34:27 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"bd599b4f1a452ac2f017b03fefbc1f290c0ee9d8c698fd47462521a0f4d514bc"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: 14EA:2261:5CD15:7C5E6:5E68D9A7
Content-Length: 931
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:27 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17354-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929768.815580,VS0,VE119
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: 5a6a439ec8e8dd3baa8eb976e3ec4c7311afb3a6
Expires: Wed, 11 Mar 2020 12:34:27 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"73130e0bcf52bb8b5de6a31d5b71398b6872b796bd967581e330d5dfa963eb4c"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: BAA4:61F0:329AB:43B6A:5E68D9A6
Content-Length: 185
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:28 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17347-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929768.007367,VS0,VE122
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: db1cbe1861e8c02f6915c6cf08276cf3583b3543
Expires: Wed, 11 Mar 2020 12:34:28 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"cf93aec85784b32ea6db38007e73173e45cc358e1c6fea212655965d3c55a926"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: 7F68:7400:66E52:87C3C:5E68D9A8
Content-Length: 9180
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:28 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17346-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929768.229165,VS0,VE109
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: 4dbedcfa191cbe06b8db7314ef1f6cac911dcabc
Expires: Wed, 11 Mar 2020 12:34:28 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"92d5830bbf6cdb6063dbd6b21e338603a2eb9b17c7b08a9a8888bc54875abf8f"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: E6C6:26D5:A1F2:EBC2:5E68D9A7
Content-Length: 2060
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:28 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17338-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929768.410886,VS0,VE150
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: c40bed9f09e89a884ccfb50b7a06e01992fdfe29
Expires: Wed, 11 Mar 2020 12:34:28 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"c03cd2606cf51c583f102cd41e5fcf78886ab8df91a4f159833d8b7c0cc02b60"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: 4CF2:1FEB:5D0AD:7C5E8:5E68D9A7
Content-Length: 4381
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:28 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17345-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929769.632244,VS0,VE100
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: 592cdff071a491a9b6dc3f432e711a19273d45ea
Expires: Wed, 11 Mar 2020 12:34:28 GMT
Source-Age: 0

HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Security-Policy: default-src 'none'; style-src 'unsafe-inline'; sandbox
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: deny
X-XSS-Protection: 1; mode=block
ETag: W/"87e9df799f257992b7526b47c65481c0601847caa5c31fba9308f84a8a8e59e6"
Cache-Control: max-age=300
X-Geo-Block-List:
Via: 1.1 varnish (Varnish/6.0)
X-GitHub-Request-Id: C12E:6C2D:66F73:88323:5E68D9A7
Content-Length: 3876
Accept-Ranges: bytes
Date: Wed, 11 Mar 2020 12:29:28 GMT
Via: 1.1 varnish
Connection: keep-alive
X-Served-By: cache-mdw17343-MDW
X-Cache: MISS, MISS
X-Cache-Hits: 0, 0
X-Timer: S1583929769.802585,VS0,VE84
Vary: Authorization,Accept-Encoding
Access-Control-Allow-Origin: *
X-Fastly-Request-ID: ffb1f45f5f9b495b53c9737294bdcceaab6b18bc
Expires: Wed, 11 Mar 2020 12:34:28 GMT
Source-Age: 0

[keptn|DEBUG] [2020-03-11 12:29:28] Check if Keptn 0.6.0 is currently installed
[keptn|DEBUG] [2020-03-11 12:29:29] Exporting events from previous Keptn installation.
2020-03-11T12:29:29.345+0000    connected to: localhost
2020-03-11T12:29:29.369+0000    exported 208 records
[keptn|DEBUG] [2020-03-11 12:29:29] Updating MongoDB.
deployment.extensions "mongodb" deleted
persistentvolumeclaim/mongodata configured
deployment.apps/mongodb created
service/mongodb configured
Waiting for deployment "mongodb" rollout to finish: 0 of 1 updated replicas are available...
deployment "mongodb" successfully rolled out
[keptn|DEBUG] [2020-03-11 12:29:34] Deployment mongodb in keptn-datastore namespace available.
deployment "mongodb" successfully rolled out
[keptn|DEBUG] [2020-03-11 12:29:34] Deployment mongodb-datastore in keptn-datastore namespace available.
deployment "mongodb" successfully rolled out
[keptn|DEBUG] [2020-03-11 12:29:34] Deployment mongodb-datastore-distributor in keptn-datastore namespace available.
[keptn|DEBUG] [2020-03-11 12:29:34] Importing events from previous installation to updated MongoDB.
2020-03-11T12:29:37.691+0000    [........................] keptn.events 0B/110KB (0.0%)
2020-03-11T12:29:37.742+0000    connected to: localhost
2020-03-11T12:29:37.768+0000    [########################] keptn.events 110KB/110KB (100.0%)
2020-03-11T12:29:37.768+0000    imported 208 documents
[keptn|DEBUG] [2020-03-11 12:29:37] Updating mongodb-datastore.
deployment.extensions/mongodb-datastore image updated
deployment.extensions/mongodb-datastore-distributor image updated
[keptn|DEBUG] [2020-03-11 12:29:37] Updating Keptn core.
deployment.apps/api configured
service/api unchanged
deployment.apps/bridge configured
service/bridge unchanged
deployment.apps/eventbroker-go configured
service/event-broker unchanged
deployment.apps/helm-service configured
service/helm-service unchanged
deployment.apps/helm-service-service-create-distributor configured
deployment.apps/shipyard-service configured
service/shipyard-service unchanged
deployment.apps/shipyard-service-create-project-distributor configured
deployment.apps/shipyard-service-delete-project-distributor configured
persistentvolumeclaim/configuration-volume configured
deployment.apps/configuration-service configured
service/configuration-service unchanged
deployment.apps/lighthouse-service configured
service/lighthouse-service unchanged
deployment.apps/lighthouse-service-distributor created
NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
gatekeeper-service   ClusterIP   10.48.2.161   <none>        8080/TCP   7d20h
[keptn|DEBUG] [2020-03-11 12:29:40] Full installation detected. Upgrading CD and CO services
deployment.apps/gatekeeper-service configured
service/gatekeeper-service unchanged
deployment.apps/gatekeeper-service-evaluation-done-distributor configured
deployment.apps/helm-service-configuration-change-distributor configured
deployment.apps/jmeter-service configured
service/jmeter-service unchanged
deployment.apps/jmeter-service-deployment-distributor configured
deployment.apps/wait-service configured
service/wait-service unchanged
deployment.apps/wait-service-deployment-distributor configured
deployment.apps/remediation-service configured
service/remediation-service unchanged
deployment.apps/remediation-service-problem-distributor configured
Error from server (NotFound): services "dynatrace-service" not found
Error from server (NotFound): services "dynatrace-sli-service" not found
Error from server (NotFound): services "prometheus-service" not found
Error from server (NotFound): services "prometheus-sli-service" not found
Error from server (NotFound): services "servicenow-service" not found
```

**Note:** The messages at the end of the log output, such as `Error from server (NotFound): services "dynatrace-service" not found` does not mean that the upgrade has not been successful.
This message simply means that the respective service, e.g. the dynatrace-service has not been installed in your cluster in the previous Keptn version. 
If the service has indeed been deployed previously, it will be updated to the latest compatible version.
</details>

<details><summary>Upgrade didn't work, what to do next?</summary>

Please create a [new bug report](https://github.com/keptn/keptn/issues/new?assignees=&labels=bug&template=bug_report.md&title=) 
and provide us more information (log output, etc...), e.g.:

* `kubectl logs job/upgrader`
* `kubectl get pods -n keptn`
* `kubectl -n keptn get deployments -owide`
* `kubectl get pods -n keptn-datastore`
* `kubectl -n keptn-datastore get deployments -owide`

</details>

## Upgrade from 0.6.0beta(2) to 0.6.0

When we introduced the new lighthouse-service with custom SLIs in 0.6.0.beta we got a lot of feedback. We value this feedback, and we wanted to thank all our beta testers for their extensive testing and feedback provided by providing an upgrade guide from 0.6.0.beta(2) to 0.6.0.

### Custom SLIs in Git repo

For Keptn 0.6.0.beta(2), custom SLIs were configured by creating a Kubernetes ConfigMap for Prometheus that looked like this:

```yaml
apiVersion: v1
data:
  custom-queries: |
    cpu_usage: avg(rate(container_cpu_usage_seconds_total{namespace="$PROJECT-$STAGE",pod_name=~"$SERVICE-primary-.*"}[5m]))
    response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{handler="ItemsController.addToCart",job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
kind: ConfigMap
metadata:
  name: prometheus-sli-config-sockshop
  namespace: keptn
```

With Keptn 0.6.0, custom SLIs need to be added for the project/service/stage by using [keptn add-resource](../../reference/cli/#keptn-add-resource). With this change in mind, we also had to slightly adapt the format of the file. Above file would now look as follows:

```yaml
---
spec_version: '1.0'
indicators:
  cpu_usage: avg(rate(container_cpu_usage_seconds_total{namespace="$PROJECT-$STAGE",pod_name=~"$SERVICE-primary-.*"}[5m]))
  response_time_p95: histogram_quantile(0.95, sum by(le) (rate(http_response_time_milliseconds_bucket{handler="ItemsController.addToCart",job="$SERVICE-$PROJECT-$STAGE"}[$DURATION_SECONDS])))
```

To migrate from the old format to the new format, you can:

1. Fetch the ConfigMap using ` kubectl get configmap -n keptn prometheus-sli-config-sockshop -oyaml`
1. Copy the content from within the `custom-queries: |` section (without `custom-queries: |`)
1. Create a new file called `sli.yaml` with the following content:

    ```yaml
    ---
    spec_version: '1.0'
    indicators:
      # paste-content-here
    ```

The newly created file needs to be added to as follows:

* Prometheus

```console
keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli.yaml --resourceUri=prometheus/sli.yaml
```

* Dynatrace

```console
keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli.yaml --resourceUri=dynatrace/sli.yaml
```

### Ingress Gateway

If you want to stay compatible, you need to perform the following steps:

1. Delete the existing gateways that are relevant for Keptn namespace using:
```console
kubectl delete gateway keptn-gateway -n keptn
```

1. Apply the new public-gateway in namespace istio-system using:
```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/istio/public-gateway.yaml
```

1. Edit the VirtualService for the Keptn api service such that it uses `public-gateway.istio-system` instead of `keptn-gateway`: 
```console
kubectl get vs/api -n keptn -o yaml | sed 's/keptn-gateway/public-gateway.istio-system/g' | kubectl replace -f -
```

1. Verify that you can still access the API via a browser.

1. Adapt all VirtualServices of onboarded services to use the `public-gateway.istio-system` (e.g., by sending a `new-artifact` event for all those services which will be handled by the updated helm-service, or by manually editing the virtual services)

1. (Optional) Delete all generated gateways (in all namespaces of the project-stages) using: `kubectl delete gateways -n $project-$stage` for every $project and $stage)

### Upgrade services

Please [verify that you are connected to the correct Kubernetes cluster](../../reference/troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before performing this operation.

**Update services in keptn-datastore namespace**

```console
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:0.6.0 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore-distributor distributor=keptn/distributor:0.6.0 --record
```

**Update services in keptn namespace**

```console
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/core.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/continuous-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/quality-gates.yaml
kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/release-0.6.0/installer/manifests/keptn/continuous-operations.yaml
```

**Update keptn-contrib services** 

Please [verify that you are connected to the correct Kubernetes cluster](../../reference/troubleshooting/#verify-kubernetes-context-with-keptn-installation)
before performing this operation.

Also, only update the services if you have them installed:

* *dynatrace-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/release-0.6.0/deploy/manifests/dynatrace-service/dynatrace-service.yaml`
* *dynatrace-sli-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/release-0.3.0/deploy/service.yaml`
* *prometheus-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-service/release-0.3.1/deploy/service.yaml`
* *prometheus-sli-service*: `kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/prometheus-sli-service/release-0.2.0/deploy/service.yaml`
* *notification-service*: `kubectl -n keptn set image deployment/notification-service notification-service=keptncontrib/notification-service:0.3.0 --record`

## Upgrade from 0.5.x to 0.6.0

For full details on what has changed from Keptn 0.5.x to Keptn 0.6.0 please refer to the release notes within the [Keptn repository](https://github.com/keptn/keptn/releases/0.6.0). 

Unfortunatley, there are multiple breaking changes from Keptn 0.5.x to Keptn 0.6.x that make it impossible to provide an upgrade script from Keptn 0.5.x to Keptn 0.6.x. These breaking changes include:

* Istio sidecar injection has been introduced for blue-green deployments
* Pitometer was removed, instead the lighthouse was installed
* Ingress gateway handling was changed

Instead of an upgrade script, we will highlight the most important changes that you need to do to get your services onboarded with a fresh Keptn 0.6.0 installation.

**Note:** Advise for migrating from [Keptn 0.6.0.beta(2) to 0.6.0](#upgrade-from-0-6-0beta-2-to-0-6-0) is listed above.

### Helm Charts

Several changes to Helm charts have been made. If you want to stay compatible, please adapt your Helm charts accordingly.

* Parameterize the `replicas` in the deployment manifest. Therefore, set `replicas: {{ .Values.replicaCount }}` instead of a fixed value, e.g.: `replicas: 1`:

  ```yaml
  replicas: {{ .Values.replicaCount }}
  ```

  See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/templates/deployment.yaml#L7

* Then, set a new value in `values.yaml` for each service: `replicaCount`. 

  See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/values.yaml

* Dynatrace integration: We have removed `DT_TAGS` and introduced `DT_CUSTOM_PROP`:

  ```yaml
  - name: DT_CUSTOM_PROP
    value: "keptn_project={{ .Values.keptn.project }} keptn_service={{ .Values.keptn.service }} keptn_stage={{ .Values.keptn.stage }} keptn_deployment={{ .Values.keptn.deployment }}"
  ```
  
  See example: https://github.com/keptn/examples/blob/release-0.6.0/onboarding-carts/carts/templates/deployment.yaml#L29-L30

### New Lighthouse / Pitometer was removed

Pitometer was removed including the support for PerfSpec files. Instead, a new service called *lighthouse* has been introduced. Please follow the [Deployment with Quality Gates](../../usecases/deployments-with-quality-gates/) tutorial to learn more about the new file formats used for quality gates.
