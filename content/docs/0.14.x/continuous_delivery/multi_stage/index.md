---
title: Multi-stage delivery
description: Customize your delivery and staging process.
weight: 1
keywords: [0.14.x-cd]
---

## Declare a multi-stage delivery sequence in shipyard

The definition of a multi-stage delivery manifests in a so-called [Shipyard](../../manage/shipyard) file. It can hold multiple stages with dedicated and opinionated delivery tasks to execute.

**Example**: Simple shipyard file with a delivery sequence in the two stages `dev` and `production`, whereas `dev` uses a direct deployment and `prod` uses blue-green deployment:

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
      - name: "delivery"
        tasks: 
        - name: "deployment"
          properties:
            deploymentstrategy: "direct"
        - name: "release"

    - name: "production"
      sequences:
      - name: "delivery"
        triggeredOn:
          - event: "dev.delivery.finished"
        tasks: 
        - name: "deployment"
          properties:
            deploymentstrategy: "blue_green_service"
        - name: "release"
```

**Example:** Extended shipyard with a delivery sequence in three stages `dev`, `hardening` and `production` in combination with tests:

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "dev"
      sequences:
      - name: "delivery"
        tasks: 
        - name: "deployment"
          properties:
            deploymentstrategy: "direct"
        - name: "test"
          properties:
            teststrategy: "functional"
        - name: "evaluation"
        - name: "release"

    - name: "hardening"
      sequences:
      - name: "delivery"
        triggeredOn:
          - event: "dev.delivery.finished"
        tasks: 
        - name: "deployment"
          properties:
            deploymentstrategy: "blue_green_service"
        - name: "test"
          properties:
            teststrategy: "functional"
        - name: "evaluation"
        - name: "release"

    - name: "production"
      sequences:
      - name: "delivery"
        triggeredOn:
          - event: "hardening.delivery.finished"
        tasks: 
        - name: "deployment"
          properties:
            deploymentstrategy: "blue_green_service"
        - name: "release"
```

**Example:** Extended shipyard with two delivery sequence with varying deployment strategies (e.g., `delivery` is used for a Java-service, whereas `delivery-direct` is used for a database):

```yaml
apiVersion: spec.keptn.sh/0.2.3
kind: "Shipyard"
metadata:
  name: "shipyard-sockshop"
spec:
  stages:
    - name: "production"
      sequences:
        - name: "delivery"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "blue_green_service"
            - name: "release"

        - name: "delivery-direct"
          tasks:
            - name: "deployment"
              properties:
                deploymentstrategy: "direct"
            - name: "release"
```


## Create project with multi-stage delivery

After declaring the delivery for a project in a shipyard, you are ready to create a Keptn project as explained in [create a project](../../manage/project/#create-a-project).

## Trigger a multi-stage delivery

After creating a project and [creating your service(s)](../../manage/service), you can trigger a delivery using the Keptn CLI or API.

<details><summary>**Trigger via Keptn CLI**</summary>
<p>

* Use the command [keptn trigger delivery](../../reference/cli/commands/keptn_trigger_delivery/):

```
keptn trigger delivery --project=$PROJECTNAME --service=$SERVICENAME --image=$IMAGE --tag=$TAG
```

</p>
</details>

<details><summary>**Trigger via Keptn API**</summary>
<p>

* Specify a valid Keptn CloudEvent of type `sh.keptn.event.[STAGENAME].delivery.triggered` and store it as JSON file, e.g., `trigger_delivery.json`

```json
{
  "contenttype": "application/json",
  "data": {
    "project": "[PROJECTNAME]",
    "service": "[SERVICENAME]",
    "stage": "[STAGENAME]",
    "configurationChange": {
      "values": {
        "image": "keptn-examples/carts:0.13.3"
      }
    }
  },
  "source": "https://github.com/keptn/keptn/cli",
  "specversion": "1.0",
  "type": "sh.keptn.event.[STAGENAME].delivery.triggered"
}
```

* Trigger a delivery with a POST request on `/event`:

```console
curl -X POST "${KEPTN_ENDPOINT}/v1/event" \
-H "accept: application/json; charset=utf-8" \
-H "x-token: ${KEPTN_API_TOKEN}" \
-H "Content-Type: application/json; charset=utf-8" \
-d @./trigger_delivery.json
```

</p>
</details>




